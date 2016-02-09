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


####################
## CONFIG
####################

## the file to store state information in
property stateFile: "/tmp/multiMusicApp.plist"

# set the default app. This is the app that will start playing if no previous app
# can be identified, or if it's been more than the TTL time since another app was used
property defaultApp: "iTunes"

## set other music apps here, comma separated
property otherApps: {"Spotify"}

# How long (in seconds) to continue interacting with previous app
# If the lastApp was updated more than this many seconds ago, disregard it and return the default app
property ttl: (60 * 60)

####################
