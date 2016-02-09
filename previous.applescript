set configFile to POSIX path of file ("/Users/ethans/work/multi-music-app/config.scpt")
set config to load script configFile as alias

set coreFile to POSIX path of file ("/Users/ethans/work/multi-music-app/core.scpt")
set core to load script coreFile as alias

tell core
    setConfig(config)
    executeCommand("previous track")
end tell
