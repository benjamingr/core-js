QUnit.module \ES7

eq = strictEqual

test 'RegExp.escape' !->
  {escape} = RegExp
  ok typeof! escape is \Function, 'Is function'
  ok /native code/.test(escape), 'looks like native'
  eq escape('qwe asd'), 'qwe asd', "Don't change simple string"
  eq escape('\\[]{}()*+?.^$|'), '\\\\\\[\\]\\{\\}\\(\\)\\*\\+\\?\\.\\^\\$\\|', 'Escape all RegExp special chars'