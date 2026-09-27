## Internal helper for chronicles
import std/strutils
import chronicles

# proc parseLogLevel(level: string) {.raises: [ValueError].}: LogLevel =
proc parseLogLevel(level: string): LogLevel =
  ## Log level string to Enum type
  case level.toLowerAscii()
  of "trace":
    LogLevel.TRACE
  of "debug":
    LogLevel.DEBUG
  of "info":
    LogLevel.INFO
  of "notice":
    LogLevel.NOTICE
  of "warn":
    LogLevel.WARN
  of "error":
    LogLevel.ERROR
  of "fatal":
    LogLevel.FATAL
  of "none":
    LogLevel.NONE
  else:
    raise newException(ValueError, "Passed invalid text for log-level")

proc setLogLevel*(level: string) =
  chronicles.setLogLevel(parseLogLevel(level))

proc setLogLevel*(level: string, sinkIdx: int) =
  chronicles.setLogLevel(parseLogLevel(level), sinkIdx)
