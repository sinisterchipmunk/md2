class MD2::Frame
  # Float[3] containing X, Y, Z scale values
  attr_reader :scale
  
  # Float[3] containing X, Y, Z translations
  attr_reader :translation
  
  # The name of this frame (string)
  attr_reader :name
  
  # The vertices for this frame.
  attr_reader :vertices
  
  # The indices of the normal vectors.
  attr_reader :normal_indices
  
  def reduce
    {        
      :name => name,
      :translation => @translation,
      :scale => @scale,
      :vertices => packed_vertices,
      :normal_indices => normal_indices.flatten
    }
  end
  
  def initialize(frame_data)
    @scale = []
    @translation = []
    @vertices = []
    @normal_indices = []
    
    # 3 floats (scale), 3 floats (transl), 16 bytes (name), and variable num of unsigned chars (vertices)
    frame_data = frame_data.unpack("f3f3a16C*")
    3.times { @scale << frame_data.shift }
    3.times { @translation << frame_data.shift }
    @name = frame_data.shift.strip
    while !frame_data.empty?
      packed_vertex = MD2::Vertex.new(frame_data.shift, frame_data.shift, frame_data.shift)
      @vertices << unpack_vertex_data(packed_vertex)
      @normal_indices << frame_data.shift
    end
  end
  
  private
  def packed_vertices
    vertices.collect do |vert|
      [ ((vert[0] - @translation[0]) / @scale[0]).to_i,
        ((vert[1] - @translation[1]) / @scale[1]).to_i,
        ((vert[2] - @translation[2]) / @scale[2]).to_i ]
    end.flatten
  end
  
  def unpack_vertex_data(packed_vertex)
    3.times do |i|
      packed_vertex[i] = (packed_vertex[i] * @scale[i]) + @translation[i]
    end
    
    packed_vertex
  end
end