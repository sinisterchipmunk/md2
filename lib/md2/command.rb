# This class is instantiated from the C extension. You shouldn't have to instantiate it directly.
#
# GL Commands are an optimization technique employed by MD2 files to improve render time. The
# MD2 file contains a span of bytes equal to the MD2::Header#gl_command_count. Those bytes in
# turn have the following format:
#
#   1. How many bytes follow for a single GL command. This is an integer, so the data need to be
#      cast into an integer in order to be processed.
#
#      This byte also indicates the render method for this GL command: if it's positive,
#      this is a triangle strip; if it's negative, a triangle fan. If zero, this byte
#      represents the end of the command list. Terminating bytes are silently omitted
#      by this Ruby library.
#   2. The horizontal texture coordinate. This is a float, so the data needs to be cast into a
#      float to be processed.
#   3. The vertical texture coordinate. This is a float, so the data needs to be cast into a
#      float to be processed.
#   4. The vertex index to be rendered. This is an integer, so the data needs to be cast into
#      an integer to be processed.
#
# As the data are cast into the necessary types, the boundaries of any given command structure
# must be adjusted to match. I was not able to find a way to do this using pure Ruby, so the
# bulk of the above algorithm is implemented in this gem's C extension.
#
# This class is only instantiated after the fact, with the data already deserialized.
#
class MD2::Command
  # A data structure containing a single #texture_s, #texture_t and #vertex_index.
  class Segment
    attr_reader :texture_s, :texture_t, :vertex_index
    def initialize(s, t, index)
      @texture_s, @texture_t, @vertex_index = s, t, index
    end
  end
  
  # The type of command. This is equal to either :triangle_strip or :triangle_fan.
  attr_reader :type
  
  # an array of segments, each an instance of MD2::Command::Segment. Segments contain the vertex and texture data
  # for this command.
  attr_reader :segments
  
  # Arguments are expected to be a single array with the following content:
  #   [ (:triangle_strip|:triangle_fan), *elements ]
  #
  # The remainder of the elements are expected to appear in this order:
  #   (s_coord, t_coord, vert_index)
  #
  # So, the elements are expected to be in groups of 3: the s and t texture coordinates (which are Floats),
  # and the vertex index (which is a Fixnum).
  #
  # The array of args is expected to be a single, flat array -- the data should not be nested
  # into other arrays.
  #
  def initialize(args)
    @type = args.shift
    @segments = []
    
    0.step(args.length-1, 3) do |index|
      @segments << MD2::Command::Segment.new(args[index], args[index+1], args[index+2])
    end
  end
end
