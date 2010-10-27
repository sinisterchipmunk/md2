class MD2::Header
  # The length of an MD2 header is fixed.
  LENGTH = 68
  
  # The magic number that all MD2 headers start with. This is equal to "IDP2" in bytes.
  MD2_IDENT = ((?2.ord<<24) + (?P.ord<<16) + (?D.ord<<8) + ?I.ord) # we use #ord because of Ruby 1.9
  
  # The MD2 file format version. This is always 8.
  MD2_VERSION = 8
  
  attr_reader :skin_width, :skin_height, :frame_size, :skin_count, :vertex_count,
              :texture_coord_count, :triangle_count, :gl_command_count, :frame_count,
              :skin_name_offset, :texture_coord_offset, :triangle_offset, :frame_data_offset,
              :gl_command_offset, :eof_offset
  
  def initialize(file)
    header = file.sysread(LENGTH).unpack("i17")
    raise MD2::Errors::InvalidFile, "Header identifier did not match" unless header.shift == MD2_IDENT
    raise MD2::Errors::InvalidVersion, "File format version mismatch" unless header.shift == MD2_VERSION
    
    @skin_width           = header.shift
    @skin_height          = header.shift
    @frame_size           = header.shift
    @skin_count           = header.shift
    @vertex_count         = header.shift
    @texture_coord_count  = header.shift
    @triangle_count       = header.shift
    @gl_command_count     = header.shift
    @frame_count          = header.shift
    @skin_name_offset     = header.shift
    @texture_coord_offset = header.shift
    @triangle_offset      = header.shift
    @frame_data_offset    = header.shift
    @gl_command_offset    = header.shift
    @eof_offset           = header.shift
  end
end
