# -*- encoding: utf-8 -*-
require "./lib/authing_ruby/version"

Gem::Specification.new do |s|
  s.name        = 'authing_ruby'
  s.version     = AuthingRuby::VERSION
  s.summary     = "Authing 的 Ruby SDK"
  s.description = "Authing 的 Ruby SDK"
  
  s.authors     = ["郑诚(Zheng Cheng)"]
  # 如果你参与了开发，请在作者列表里留下你的名字

  s.email       = ['chengzheng.apply@gmail.com']
  s.files       = Dir['lib/**/*', 'authing_ruby.gemspec']

  # 运行时依赖
  s.add_runtime_dependency 'minitest', ['~> 5.14', '>= 5.14.4']
  s.add_runtime_dependency 'faraday', ['~> 1.4', '>= 1.4.1']
  s.add_runtime_dependency 'http', ['~> 4.4', '>= 4.4.1']
  s.add_runtime_dependency 'jwt', ['~> 2.2', '>= 2.2.3']
  s.add_runtime_dependency 'uri-query_params', ['~> 0.7.2']
  s.add_runtime_dependency 'logging', ['~> 2.3']

  # 开发时依赖
  s.add_development_dependency 'dotenv', ['~> 2.7', '>= 2.7.6']
  s.add_development_dependency 'rake', ['~> 13.0', '>= 13.0.3']

  s.homepage    = 'https://github.com/1c7/authing_ruby'
  s.license     = 'MIT'
end
