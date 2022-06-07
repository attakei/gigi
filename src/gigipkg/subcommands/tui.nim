import std/[algorithm, os, strutils, tables]
import illwill
import ../gitignore


type
  Container = ref object of RootObj
    tb: TerminalBuffer
    templates: GitignoreTable
    idx: int
    cursor: int


proc initContainer(templates: GitignoreTable): Container =
  result = Container()
  result.tb = newTerminalBuffer(terminalWidth(), terminalHeight())
  result.templates = templates
  result.idx = 0
  result.cursor = 0


proc show(self: Container) =
  self.tb.setForegroundColor(fgGreen)
  self.tb.drawRect(1, 1, terminalWidth() - 2, terminalHeight() - 1, doubleStyle=true)
  self.tb.write(3, 1, "List of templates")
  self.tb.setForegroundColor(fgWhite)
  var
    idx = 0
    pos = 0
  for tgt in self.templates.keys:
    idx += 1
    if idx < self.idx:
      continue
    var
      txt = "[ ] " & self.templates[tgt].name
    txt &= " ".repeat(terminalWidth() - 4 - txt.len)
    if pos == self.cursor:
      self.tb.setForegroundColor(fgBlack)
      self.tb.setBackgroundColor(bgWhite)
    else:
      self.tb.setForegroundColor(fgWhite)
      self.tb.setBackgroundColor(bgBlack)
    self.tb.write(2, pos + 2, txt)
    pos += 1
    if pos >= terminalHeight() - 3:
      break


proc exitProc() {.noconv.} =
  illwillDeinit()
  showCursor()
  quit(0)


proc run*(templates: GitignoreTable) =
  illwillInit(fullscreen=true)
  setControlCHook(exitProc)
  hideCursor()
  var container = initContainer(templates)
  container.tb.write(0, 0, "Press Q, Esc or Ctrl-C to quit")
  while true:
    var key = getKey()
    case key
    of Key.None: discard
    of Key.Escape, Key.Q: exitProc()
    of Key.J:
      container.cursor += 1
    of Key.K:
      if container.cursor > 0:
        container.cursor -= 1
    else:
      discard
    container.show()
    container.tb.display()
    sleep(20)
