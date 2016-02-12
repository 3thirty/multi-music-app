set configFile to (system attribute "PWD") & "/config.scpt"
set configFilePath to POSIX path of file (configFile)
set config to load script configFilePath as alias

set coreFile to (system attribute "PWD") & "/core.scpt"
set coreFilePath to POSIX path of file (coreFile)
set core to load script coreFilePath as alias

tell core
    setConfig(config)
    executeCommand("pause", false)
end tell
