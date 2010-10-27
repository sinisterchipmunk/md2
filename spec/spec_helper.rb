$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'md2'
require 'spec'
require 'spec/autorun'
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

Spec::Runner.configure do |config|
  config.include SpecHelpers
end
