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
  def unpack_vertex_data(packed_vertex)
    3.times do |i|
      packed_vertex[i] = (packed_vertex[i] * @scale[i]) + @translation[i]
    end
    
    packed_vertex
  end
end