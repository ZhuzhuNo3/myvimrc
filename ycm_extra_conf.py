import os
import re
import json

# cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
compilation_database_file = ''

flags = [
'-Wall',
'-Wextra',
'-Wno-long-long',
'-Wno-variadic-macros',
'-fexceptions',
'-DNDEBUG',
'-std=c++11',
'-x',
'c++',
]

def AddCompilationDatabase( comp_database_file ):
  flags_set=set()
  with open(comp_database_file,'r') as f:
    comp_db = json.load(f)
    for cmd in comp_db:
      if "command" in cmd:
        for inc in re.findall(r" ((?:-I|-isystem)\s?(?:[^\s]*(?:\\ )?/?)+)",cmd["command"]):
          flags_set.add(inc)
      if "arguments" in cmd:
        incs = cmd["arguments"]
        for i in range(0, len(incs)):
          if re.match(r"^(-I|-isystem)$", incs[i]) and i + 1 != len(incs):
            flags_set.add(incs[i]+incs[i+1])
          elif re.match(r"^((-I|-isystem).+)$",incs[i]):
            flags_set.add(incs[i])
  return list(flags_set)

pwd = os.getcwd()
for dbPath in [
    compilation_database_file,
    pwd + '/build/compile_commands.json',
    pwd + '/compile_commands.json',
    pwd + '/../' + os.path.basename(pwd) + '_compile_commands.json',
    ]:
  if os.path.exists( dbPath ):
    flags += AddCompilationDatabase( dbPath )
    break

flags += [
'-isystem',
'/usr/local/include',
'-isystem',
'/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../include/c++/v1',
'-isystem',
'/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/12.0.0/include',
'-isystem',
'/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include',
'-isystem',
'/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include',
'-isystem',
'/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks',

# Termux
'-isystem',
'/data/data/com.termux/files/usr/include',
'-isystem',
'/data/data/com.termux/files/usr/include/c++/v1',
'-isystem',
'/data/data/com.termux/files/usr/include/c++/v1/experimental',

'-I',
'/Users/zhuzhou/追一科技/Bot/code/yibot/calc/mcppp/mcp++/inc',
'-I',
'/usr/local/Cellar/protobuf/*/include',
'-I',
'/usr/local/Cellar/jsoncpp',
'-I',
'/Users/zhuzhou/追一科技/Bot/code/yibot/calc/common',
'-I',
'/Users/zhuzhou/追一科技/Bot/code/yibot/calc/mcppp/mcp++/mcp++/src/TsdBase',
'-I',
'/Users/zhuzhou/追一科技/Bot/code/yibot/calc/mcppp/mcp++/mcp++/src/base',
'-I',
'/Users/zhuzhou/追一科技/Bot/code/yibot/calc/mcppp/mcp++/mcp++/src/ccd',
'-I',
'/Users/zhuzhou/追一科技/Bot/code/yibot/calc/mcppp/mcp++/mcp++/src/dcc',
'-I',
'/Users/zhuzhou/追一科技/Bot/code/yibot/calc/mcppp/mcp++/mcp++/src/libhttp',
'-I',
'/Users/zhuzhou/追一科技/Bot/code/yibot/calc/mcppp/mcp++/mcp++/src/mcd',
'-I',
'/Users/zhuzhou/追一科技/Bot/code/yibot/calc/mcppp/mcp++/mcp++/src/old',
'-I',
'/Users/zhuzhou/追一科技/Bot/code/yibot/calc/mcppp/mcp++/mcp++/src/watchdog',
'-I',
'/Users/zhuzhou/追一科技/Bot/code/yibot/calc/mcppp/mcp++/mcp++/src/wtg',
]

def Settings( **kwargs ):
  return {
    'flags': flags,
  }
