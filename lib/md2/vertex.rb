class MD2::Vertex < Array
  def initialize(x, y, z)
    super()
    raise ArgumentError, "x is nil" if x.nil?
    raise ArgumentError, "y is nil" if y.nil?
    raise ArgumentError, "z is nil" if z.nil?
    self << x << y << z
  end
  
  def x
    self[0]
  end
  
  def y
    self[1]
  end
  
  def z
    self[2]
  end
  
  def x=(x)
    self[0] = x
  end
  
  def y=(y)
    self[1] = y
  end
  
  def z=(z)
    self[2] = z
  end
end