require 'rake'
require 'rake/testtask'

# 如何运行: rake test
# 目的：跑这一条命令，可以把所有 mini test 都跑了，就不需要手工运行一个个文件
# 用途是做整体测试，而不是单个功能
Rake::TestTask.new do |t|
  t.pattern = 'lib/test/mini_test/*.rb'
end
