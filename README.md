# multi-music-app
These scripts allow you to play, pause, go to previous and next track in whichever music app you are currently (or were last) listening in. By default, this will check for Music (formerly iTunes) and Spotify, but other music playing apps can be easily supported.

### Using in Alfred
This was primarily designed to be called from an Alfred workflow, such a workflow is provided under the alfred directory. To run in Alfred, you can just download the workflow file and load into alfred. See https://www.alfredapp.com/help/workflows/ for more on adding workflows

#### Shortcut keys
  * pp - play/pause current music app
  * pn - play next track in current music app
  * pr - play previous track in current music app
  * ssp - pause the current music app (if playing) and start the screen saver

### Using from Command line

You can also run this from the commandline via osascript.

First, you need to compile the applescripts (one time only). Just run:

``make``

You should then see `core.scpt` and `config.scpt` in the directory

You can then use the individual interface scripts to perform commands, for example:

``osascript ./playpause.applescript``

### Configuration
In `multiMusicAppConfig.applescript`, there are a few configuration options:

````
# the file to store state information in
property stateFile: "/tmp/multiMusicApp.plist"

# set the default app. This is the app that will start playing if no previous app
# can be identified, or if it's been more than the TTL time since another app was used
property defaultApp: "Music"

# set other music apps here, comma separated
property otherApps: {"Spotify"}

# How long (in seconds) to continue interacting with previous app
# If the lastApp was updated more than this many seconds ago, disregard it and return the default app
property ttl: (60 * 60)
````

### Files
| File        | Description     |
| :---------- |:--------------- |
| alfred/multi music app.alfredworkflow | Alfred workflow package. This contains all the other (precompiled) scripts. | 
| alfred/icon.png   |Icon file for alfred | 
| Makefile | makefile |
| multiMusicApp.applescript |The main guts of the script. Compiled to core.scpt |
| multiMusicAppConfig.applescript | Configuration file. Compiled to config.scpt | 
| next.applescript<br> pause.applescript<br> playpause.applescript<br> previous.applescript | Scripts providing interfaces to the app functions |

