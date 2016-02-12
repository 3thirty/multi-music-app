##
# @author       ethan@3thirty.net
# @date         2016-02-08
# @version      1.0
#
# Script to play or pause from the music app (iTunes or Spotify) that is currently being used.
#
# This allows you to continue to play/pause within the "current" app (via this
# script). To tell this script that you have switched app, just manually start
# playing from the new app and the script will pick up the switch when you next
# pause
#
#

##
# execute a command to the latest app
#
# @param    command One of pause, next track, previous track
#
on executeCommand(command, forcePlay)
    global stateFile
    global defaultApp
    global otherApps
    global DEBUG

    set DEBUG to false

    newStateFile(stateFile)

    set appStates to {}
    copy otherApps to apps
    copy defaultApp to beginning of apps

    # find the current state of all apps
    repeat with checkApp in apps
        set state to "paused"
        if isAppRunning(checkApp) then
            set state to (run script "tell application \"" & checkApp & "\" to get player state as string")
        end if
        copy state to end of appStates
    end

    if DEBUG then
        set i to 0
        set message to ""
        repeat with thisApp in apps
            set i to i + 1
            set message to message & thisApp & ": " & item i of appStates & "\n"
        end
        display dialog message
    end if

    # if something is playing pause it
    set i to 0
    set lastApp to null
    repeat with state in appStates
        set i to i + 1
        if state as string is "playing"
            set lastApp to item i of apps
            run script "tell application \"" & lastApp & "\" to " & command
        end if
    end

    # if nothing is playing, play the previous app
    if lastApp is null
        set lastApp to getState(stateFile)
    
        if forcePlay is true
            run script "tell application \"" & lastApp & "\" to play"
        end if
    end if

    storeState(stateFile, lastApp)
end executeCommand


##
# define global variables from config object
#
# @param    config  A config object with the required properties
#
on setConfig(config)
    global stateFile
    global defaultApp
    global otherApps
    global ttl

    set stateFile to stateFile of config
    set defaultApp to defaultApp of config
    set otherApps to otherApps of config
    set ttl to ttl of config
end setConfig


##
# write details of the app that is currently being used to disk
#
# @param    stateFile   string with the full path to the statefile
# @param    lastApp     The name of the app
#
# @return    void
on storeState(stateFile, lastApp)
    set stateFilePath to POSIX path of stateFile
    
    tell application "System Events"
        set propertyList to property list file stateFilePath
        
        tell propertyList
            tell contents
                set value to {|lastApp|:lastApp, |lastTime|:get (current date)}
            end tell
        end tell
        
    end tell
end storeState

##
# Read previously-stored details of the app that is currently being used from disk.
# If the data is older than the TTL, doesn't exist or fails in any other way, then return the default app
#
# @param    stateFile   string with the full path to the statefile
#
# @return    the name of the app that was last used, within the TTL period
on getState(stateFile)
    global defaultApp
    global ttl
    set stateFilePath to POSIX path of stateFile
    
    set lastApp to defaultApp
    set lastTime to (current date) - ttl + 1
    
    try
        tell application "System Events"
            tell property list file stateFilePath
                tell contents
                    if property list item "lastTime" exists then
                        set lastTime to value of property list item "lastTime"
                    end if
                    
                    if property list item "lastApp" exists then
                        set lastApp to value of property list item "lastApp"
                    end if
                    
                    set diff to get (current date) - lastTime
                    if diff > ttl then
                        set lastApp to defaultApp
                    end if
                end tell
            end tell
        end tell
    on error error_message number error_number
        return defaultApp
    end try
    
    return lastApp
end getState

##
# create a new empty plist file if one doesn't exist already
#
# @param    stateFile   string with the full path to the statefile
#
# @return void
on newStateFile(stateFile)
    global DEBUG

    set defaultPlist to "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict/>
</plist>"
    
    try
        tell application "System Events"
            if exists file (stateFile) as alias then
                return
            end if
        end tell
    end try
    
    if DEBUG then
        display dialog "creating empty statefile"
    end if

    set stateFile to open for access stateFile with write permission
    set eof of stateFile to 0
    write defaultPlist to stateFile starting at eof
    close access stateFile
end newStateFile

##
# Check if the named app is currently running 
#
# @param    checkApp    The app name to heck for
#
# @return   true if the app is currently running, false otherwise
#
on isAppRunning(checkApp)
    tell application "System Events"
        return (name of processes) contains checkApp
    end tell
end appIsRunning
