class MD2::Triangle
  attr_reader :vertex_indices, :texcoord_indices
  
  def initialize(data)
    data = data.unpack("s6")
    @vertex_indices   = [data[0], data[1], data[2]]
    @texcoord_indices = [data[3], data[4], data[5]]
  end
end
