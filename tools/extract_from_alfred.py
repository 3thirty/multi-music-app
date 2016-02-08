#!/usr/bin/python

##
# Script to extract the current applescript portion from the alfred plist file
# 
# requires xmltodict (https://github.com/martinblech/xmltodict)
#

import xmltodict

inputFile = '/Users/ethans/Dropbox/Alfred2 Settings/Alfred.alfredpreferences/workflows/user.workflow.347FDD51-CD90-4A08-A512-A490BF98E8DC/info.plist'

with open(inputFile, 'r') as f:
    xml = f.read()

dict = xmltodict.parse(xml);

print dict['plist']['dict']['array']['dict'][1]['dict']['string']
