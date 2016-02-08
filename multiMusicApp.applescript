##
# @author    ethan@3thirty.net
# @date        2016-02-05
# @version    1.0
#
# Script to play or pause from the music app (iTunes or Spotify) that is currently being used.
#
# This allows you to continue to play/pause within the "current" app (via this
# script). To tell this script that you have switched app, just manually start
# playing from the new app and the script will pick up the switch when you next
# pause
#
#

####################
## CONFIG
####################

# the file to store state information in
set stateFile to "/tmp/multiMusicApp.plist"

# set the default app. can be iTunes or spotify
set defaultApp to "iTunes"

# How long (in seconds) to continue interacting with previous app
# If the lastApp was updated more than this many seconds ago, disregard it and return the default app
set ttl to (60 * 60)

####################
set DEBUG to false

newStateFile(stateFile)

tell application "Spotify"
    set spotifyState to get player state as string
end tell

tell application "iTunes"
    set itunesState to get player state as string
end tell

if DEBUG then
    display dialog "itunes: " & itunesState & "
spotify: " & spotifyState
end if

if spotifyState is "playing" and itunesState is "playing" then
    tell application "Spotify" to pause
    tell application "iTunes" to pause
else if spotifyState is "playing" then
    # spotify is playing, so pause it
    set lastApp to "Spotify"
    tell application "Spotify" to pause
else if itunesState is "playing" then
    # itunes is playing, so pause it
    set lastApp to "iTunes"
    tell application "iTunes" to pause
else
    # nothing is playing
    set lastApp to getState(stateFile)
    run script "tell application \"" & lastApp & "\" to play"
end if

if DEBUG then
    display dialog "writing to statefile: " & lastApp
end if


storeState(stateFile, lastApp)


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
