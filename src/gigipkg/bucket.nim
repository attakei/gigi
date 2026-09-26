import std/[logging, osproc, paths]
from std/os import findExe, quoteShellCommand

const CLI_NAME = "git"

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

proc createBucket*(dest: Path, uri: string, branch: string = "") =
  var args: seq[string] = @[]
  if branch != "":
    args.add ["--branch", branch]
  args.add [uri, dest.string]
  let (output, exitCode) = runGit("clone", args)
  if exitCode != 0:
    error "Failed to clone bucket"
