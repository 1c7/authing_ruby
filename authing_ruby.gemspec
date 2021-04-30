# -*- encoding: utf-8 -*-
require "./lib/version"

Gem::Specification.new do |s|
  s.name        = 'authing_ruby'
  s.version     = AuthingRuby::VERSION
  s.summary     = "Authing 的 Ruby SDK"
  s.description = "Authing 的 Ruby SDK"
  
  s.authors     = ["郑诚(Zheng Cheng)"]
  # 如果你参与了开发，请在作者列表里留下你的名字

  s.email       = 'chengzheng.apply@gmail.com'
  s.files       = Dir['lib/**/*', 'authing_ruby.gemspec']
  s.homepage    = 'https://github.com/1c7/authing_ruby'
  s.license     = 'MIT'
end