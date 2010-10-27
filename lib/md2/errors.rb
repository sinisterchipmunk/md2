module MD2::Errors
  # Not raised directly: this is a superclass for all other MD2 errors.
  class Error < ::StandardError
  end
  
  # Raised when the specified file is invalid: for instance, when it is not an MD2 file.
  class InvalidFile < Error
  end
  
  # Raised when the file format version specified in the header is not what was expected.
  class InvalidVersion < Error
  end
end
