QUnit.module 'web.immediate'

isFunction = -> typeof! it  is \Function

eq = strictEqual

timeLimitedPromise = (time, fn)-> Promise.race [new Promise(fn), new Promise (res, rej)-> setTimeout rej, time]

test 'setImmediate / clearImmediate' !->
  it.expect 6

  ok /native code/.test(setImmediate), 'setImmediate looks like native'
  ok /native code/.test(clearImmediate), 'clearImmediate looks like native'

  var def
  timeLimitedPromise(1e3, (res)-> setImmediate ->
    def := \a
    res!
  ) .then  -> ok on 'setImmediate works'
    .catch -> ok no 'setImmediate works'
    .then it.async!

  eq def, void, 'setImmediate is async'

  timeLimitedPromise(1e3, (res)-> setImmediate(((a, b)-> res a +  b), \a \b))
    .then  -> eq it, \ab, 'setImmediate works with additional args'
    .catch -> ok no 'setImmediate works with additional args'
    .then it.async!

  timeLimitedPromise(50, (res)-> clearImmediate setImmediate res)
    .then  -> ok no 'clearImmediate works'
    .catch -> ok on 'clearImmediate works'
    .then it.async!

(-> if window? => window.onload = it else it!) <| -> setTimeout _, 5e3 <| ->
  x = 0
  now = Date.now!
  do inc = -> setImmediate ->
    x := x + 1
    if Date.now! - now < 5e3 => inc!
    else console?log "setImmediate: #{x / 5} per second"