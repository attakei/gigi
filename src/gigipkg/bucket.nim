import std/[osproc, paths]
from std/os import findExe, quoteShellCommand
import chronicles

const CLI_NAME = "git"

type Bucket* = object
  path*: Path

proc `$`*(bucket: Bucket): string =
  result = bucket.path.string

proc name*(bucket: Bucket): string =
  result = bucket.path.lastPathPart.string

proc runGit(
    command: string, args: seq[string] = @[], workDir: string = ""
): tuple[output: string, exitCode: int] =
  let gitExe = findExe(CLI_NAME)
  if gitExe == "":
    error "git command not found in PATH"
    return
  var cmdLine = @[gitExe, command]
  cmdLine.add args
  result = execCmdEx(quoteShellCommand(cmdLine), workingDir = workDir)

proc initBucket*(path: Path): Bucket =
  result.path = path

proc createBucket*(dest: Path, uri: string, branch: string = "") =
  var args: seq[string] = @[]
  if branch != "":
    args.add ["--branch", branch]
  args.add [uri, dest.string]
  let (output, exitCode) = runGit("clone", args)
  if exitCode != 0:
    error "Failed to clone bucket", output = output
