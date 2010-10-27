require 'spec_helper'

describe MD2 do
  subject { MD2.new(md2_file("pilot")) }
  
  it "should have frames.first.vertices.size == header.vertex_count" do
    subject.frames.first.vertices.size.should == subject.header.vertex_count
  end
  
  it "should not contain null characters" do
    subject.frames.first.name.should_not =~ /#{Regexp::escape ?\0.chr}/
  end
end
