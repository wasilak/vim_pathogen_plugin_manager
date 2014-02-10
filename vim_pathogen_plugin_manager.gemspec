# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vim_pathogen_plugin_manager/version'

Gem::Specification.new do |spec|
  spec.name          = "vim_pathogen_plugin_manager"
  spec.version       = VimPathogenPluginManager::VERSION
  spec.authors       = ["Piotr Wasilewski"]
  spec.email         = ["piotr.m.wasilewski@gmail.com"]
  spec.summary       = %q{Vim plugin manager for Pathogen.}
  spec.description   = %q{Plugin manager for Pathogen. Vundle has one, now Pathogen does too.}
  spec.homepage      = "https://github.com/wasilak/vim_pathogen_plugin_manager"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ['vim_pathogen_plugin_manager']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "colorize"
  spec.add_development_dependency "optparse"
  spec.add_development_dependency "uri"
  spec.add_development_dependency "fileutils"
end
