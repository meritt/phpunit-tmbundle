require 'rubygems'
gem "rspec"

require 'spec/rake/spectask'

ENV['TM_SUPPORT_PATH'] ||= "/Applications/TextMate.app/Contents/SharedSupport/Support"

desc "Default Task"
task :default => [:spec]

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end
