$:.unshift(File.dirname(__FILE__))
require File.join(File.dirname(__FILE__), "../ext/md2/md2")
require 'sizes'
require 'active_support/core_ext'

class MD2
  include Sizes
  
  autoload :Header,   "md2/header"
  autoload :Errors,   "md2/errors"
  autoload :Frame,    "md2/frame"
  autoload :Vertex,   "md2/vertex"
  autoload :Triangle, "md2/triangle"
  autoload :Command,  "md2/command"
  
  attr_reader :header
  attr_reader :base_path, :frames, :triangles, :skins, :texcoords, :gl_commands
  
  delegate :skin_width, :skin_height, :frame_size, :skin_count, :vertex_count,
           :texture_coord_count, :triangle_count, :gl_command_count, :frame_count,
           :skin_name_offset, :texture_coord_offset, :triangle_offset, :frame_data_offset,
           :gl_command_offset, :eof_offset, :to => :header
  
  def initialize(path)
    load(path)
  end
  
  private
  def load(path)
    @base_path = File.dirname(path)
    File.open(path, "rb") do |file|
      read_header(file)
      read_frames(file)
      read_triangles(file)
      read_skins(file)
      read_texcoords(file)
    end
    @gl_commands = read_gl_commands_ext(gl_command_count, gl_command_offset, path)
  end
  
  def read_header(file)
    @header = MD2::Header.new(file)
  end
  
  def read_frames(file)
    @frames = []
    read_data(file, frame_data_offset, frame_count, frame_size) do |chunk|
      @frames << MD2::Frame.new(chunk)
    end
  end

  def read_triangles(file)
    @triangles = []
    read_data(file, triangle_offset, triangle_count, 6 * sizeof(:short)) do |chunk|
      @triangles << MD2::Triangle.new(chunk)
    end
  end
  
  def read_skins(file)
    @skins = []
    read_data(file, skin_name_offset, skin_count, sizeof(:char)*64) do |chunk|
      @skins << chunk.strip
    end
  end
  
  def read_texcoords(file)
    @texcoords = []
    read_data(file, texture_coord_offset, texture_coord_count, sizeof(:short)*2) do |chunk|
      @texcoords << chunk.unpack("s2")
    end
  end
  
  def read_data(file, offset, count, chunk_size)
    file.sysseek(offset)
    data = file.sysread(count * chunk_size)
    count.times do |num|
      yield data[(num*chunk_size)...(num*chunk_size+chunk_size)]
    end
  end
end
