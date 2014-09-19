Glaurung
========

Free UCI Chess engine created by Tord Romstad  http://www.glaurungchess.com/ .  Just trying to bring it up to speed with the rest of the world =)

## iOS Support
This will work for any devices running iOS 7+

## Known Issue(s)

### 1 Unresolved ARC Issue Remaining
There is an unresolved ARC issue with the method `connectToServer:port:` found in `Classes/RemoteEngineController.mm`.

Mainly I haven't found a quick way to fix it though I'm sure there is.  Instead of racking my brain this late at night, just commented out the method body and will revisit it later.  Otherwise - we now have an ARC version that seems to work =]
 
