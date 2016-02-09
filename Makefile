build:
	osacompile -o core.scpt multiMusicApp.applescript
	osacompile -o config.scpt multiMusicAppConfig.applescript

clean:
	rm *.scpt
