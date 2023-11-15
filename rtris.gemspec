# frozen_string_literal: true

require_relative 'lib/rtris/version'

Gem::Specification.new do |spec|
  spec.name        = 'rtris'
  spec.version     = Rtris::VERSION
  spec.authors     = ['Ramon Torres']
  spec.email       = 'raymondjavaxx@gmail.com'
  spec.homepage    = 'https://github.com/raymondjavaxx/rtris'
  spec.summary     = 'A Tetris clone written in Ruby.'
  spec.license     = 'MIT'
  spec.files = Dir['README.md', 'LICENSE', 'lib/**/*.{rb,ogg,png,wav}']
  spec.executables = %w[rtris]

  spec.add_dependency 'gosu', '~> 1.4'
  spec.add_dependency 'zeitwerk', '~> 2.6'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-minitest'
  spec.add_development_dependency 'rubocop-rake'

  spec.required_ruby_version = '>= 2.7.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
end