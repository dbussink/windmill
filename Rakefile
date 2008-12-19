lib_dir = File.expand_path(File.join(File.dirname(__FILE__), "lib"))
$:.unshift(lib_dir)
$:.uniq!

require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'
require 'spec/rake/spectask'

require File.join(File.dirname(__FILE__), 'lib/windmill', 'version')

PKG_DISPLAY_NAME   = 'Windmill'
PKG_NAME           = PKG_DISPLAY_NAME.downcase
PKG_VERSION        = Windmill::VERSION::STRING
PKG_FILE_NAME      = "#{PKG_NAME}-#{PKG_VERSION}"

RELEASE_NAME       = "REL #{PKG_VERSION}"

RUBY_FORGE_PROJECT = PKG_NAME
RUBY_FORGE_USER    = "dbussink"
RUBY_FORGE_PATH    = "/var/www/gforge-projects/#{RUBY_FORGE_PROJECT}"
RUBY_FORGE_URL     = "http://#{RUBY_FORGE_PROJECT}.rubyforge.org/"

PKG_SUMMARY        = "Windmill Ruby driver"
PKG_DESCRIPTION    = <<-TEXT
Basic Ruby Windmill client so it's easy to integrate with
for example Cucumber features.
TEXT

PKG_FILES = FileList[
    "lib/**/*", "spec/**/*", "vendor/**/*",
    "tasks/**/*", "website/**/*",
    "[A-Z]*", "Rakefile"
].exclude(/database\.yml/).exclude(/[_\.]git$/)

RCOV_ENABLED = (RUBY_PLATFORM != "java" && RUBY_VERSION =~ /^1\.8/)
if RCOV_ENABLED
  task :default => "spec:verify"
else
  task :default => "spec"
end

WINDOWS = (RUBY_PLATFORM =~ /mswin|win32|mingw|bccwin|cygwin/) rescue false
SUDO = WINDOWS ? '' : ('sudo' unless ENV['SUDOLESS'])

Dir['tasks/**/*.rake'].each { |rake| load rake }