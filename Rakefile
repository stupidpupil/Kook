require 'rspec/core/rake_task'

task :default => [:spec]

RSpec::Core::RakeTask.new(:spec) do |task|
  file_list = FileList['spec/**/*_spec.rb']
 
  %w(conformance).each do |exclude|
    file_list = file_list.exclude("spec/#{exclude}/**/*_spec.rb")
  end
 
  task.pattern = file_list
end