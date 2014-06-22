spawn = require 'win-spawn'

build = ->
  coffee = spawn(
    'coffee'
    ['-c', '-o', 'lib/shadowsocks', 'src']
    { stdio: 'inherit' }
  )
  coffee.on 'exit', process.exit

test = ->
  coffee = spawn(
    'node'
    ['lib/shadowsocks/test.js']
    { stdio: 'inherit' }
  )
  coffee.on 'exit', process.exit

task 'build', 'Build ./ from src/', build

task 'test', 'Run unit test', test

