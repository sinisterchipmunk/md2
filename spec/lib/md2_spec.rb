require 'spec_helper'

describe MD2 do
  subject { MD2.new(md2_file("pilot")) }
  
  it "should load an MD2" do
    subject
  end
  
  it "should have frames.size == header.frame_count" do
    subject.frames.size.should == subject.header.frame_count
  end
  
  it "should have triangles.size == header.triangle_count" do
    subject.triangles.size.should == subject.header.triangle_count
  end
  
  it "should have skins.size == header.skin_count" do
    subject.skins.size.should == subject.header.skin_count
  end
  
  it "should not have null characters in skin names" do
    subject.skins.first.should_not =~ /#{Regexp::escape ?\0.chr}/
  end
  
  it "should have texcoords.size == header.texture_coord_count" do
    subject.texcoords.size.should == subject.header.texture_coord_count
  end
  
  it "should have gl_commands.size == 310" do
    # gl_commands.size should NOT equal subject.header.gl_command_count because that count represents
    # all bytes in the command range; the actual number of commands varies by file and is impossible
    # to precalculate from the header data alone.
    subject.gl_commands.size.should == 310
  end
  
  it "should have correct base path" do
    subject.base_path.should == File.dirname(md2_file("pilot"))
  end
  
  context "commands" do
    it "should not exceed 1.0 for T coordinates" do
      subject.gl_commands.each do |command|
        command.segments.each do |segment|
          segment.texture_t.should be <= 1.0
        end
      end
    end

    it "should not exceed 1.0 for S coordinates" do
      subject.gl_commands.each do |command|
        command.segments.each do |segment|
          segment.texture_s.should be <= 1.0
        end
      end
    end

    it "should not have nil vertex indices" do
      subject.gl_commands.each do |command|
        command.segments.each do |segment|
          segment.vertex_index.should_not be_nil
        end
      end
    end
  end
end
