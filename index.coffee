charm = require('charm')(process)
arDrone = require 'ar-drone'
client = arDrone.createClient()
client.config('control:altitude_max', 1600)

actions =
  k: 'front'
  h: 'left'
  l: 'right'
  j: 'back'
  t: 'takeoff'
  q: 'land'
  s: 'stop'
  K: 'up'
  J: 'down'
  H: 'clockwise'
  L: 'counterClockwise'

charm.on 'data', (c) ->
  k = String.fromCharCode c.toString()
  charm.emit "key_#{c}"

timeout = null

for key, move of actions
  do (key, move) ->
    charm.on "key_#{key}", ->
      clearTimeout timeout
      console.log '\n', move
      if move in [ 'stop', 'land', 'takeoff' ]
        do client[move]
      else
        client[move] .2
        timeout = setTimeout (-> client.stop()), 1400
