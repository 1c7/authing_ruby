# -*- encoding: utf-8 -*-

require "./lib/version"
# 可参照 https://github.com/heartcombo/devise/blob/master/devise.gemspec

Gem::Specification.new do |s|
  s.name        = 'authing_ruby'
  s.version     = Authing::VERSION
  s.summary     = "Authing 的 Ruby SDK (非官方,社区写的)"
  s.description = "Authing 的 Ruby SDK (非官方,社区写的)"
  s.authors     = ["郑诚(Zheng Cheng)"]
  s.email       = 'zhengcheng.apply@gmail.com'
  s.files       = ["lib/authing_ruby.rb"]
  s.homepage    = 'https://github.com/1c7/authing_ruby'
  s.license     = 'MIT'
end