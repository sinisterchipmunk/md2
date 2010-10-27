require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "md2"
    gem.summary = %Q{A Ruby library for loading MD2 3D model files.}
    gem.description = %Q{A Ruby library for loading MD2 3D model files.}
    gem.email = "sinisterchipmunk@gmail.com"
    gem.homepage = "http://thoughtsincomputation.com"
    gem.authors = ["Colin MacKenzie IV"]
    gem.add_dependency "sizes", ">= 1.0"
    gem.add_dependency "activesupport", ">= 2.3.5"
    gem.add_development_dependency "rspec", ">= 1.2.9"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

begin
  require 'spec/rake/spectask'
  Spec::Rake::SpecTask.new(:spec) do |spec|
    spec.libs << 'lib' << 'spec'
    spec.spec_files = FileList['spec/**/*_spec.rb']
  end
  
  Spec::Rake::SpecTask.new(:rcov) do |spec|
    spec.libs << 'lib' << 'spec'
    spec.pattern = 'spec/**/*_spec.rb'
    spec.rcov = true
  end
  
  task :spec => :check_dependencies
  
  task :default => :spec
rescue LoadError
  puts "It seems you don't have rspec 1.x. You won't be able to run the test suite."
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "md2 #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
