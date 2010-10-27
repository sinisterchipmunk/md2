$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'md2'
begin
  # rspec 1.x
  require 'spec'
  require 'spec/autorun'
  RSPEC_VERSION = 1
rescue LoadError
  # rspec 2.x
  require 'rspec'
  RSPEC_VERSION = 2
end

require 'json'

module SpecHelpers
  def file(path)
    File.join(File.dirname(__FILE__), "support", path)
  end
  
  def md2_file(path)
    file("#{path}/#{path}.md2")
  end
  
  def mock_io(string)
    StringIO.new(string)
  end
end

if RSPEC_VERSION == 1
  Spec::Runner.configure do |config|
    config.include SpecHelpers
  end
else
  RSpec.configure do |config|
    config.include SpecHelpers
  end
end