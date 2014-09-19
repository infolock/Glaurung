Glaurung
========

Free UCI Chess engine created by Tord Romstad  http://www.glaurungchess.com/ .  Just trying to bring it up to speed with the rest of the world =)

## iOS Support
This will work for any devices running iOS 7+

## Current Plans
I've completed the transition of the code ( which seems to have been built with iOS SDK 3.0(ish) ) and brought it into a working iOS 8 environment.  I've also converted it over to be ARC with 1 minor and outstanding issue ( see Known Issues below ).  However, the one known issue is related to the "Remote PC" feature.  So, unless you plan to try that ( which I haven't tried myself yet ), be warned that you may need to first resolve that small problem.

With all that being said, the ultimate goal is to take this from being an Objective C iOS 8.0 source to a Swift iOS 8 source.  Its a large build with a sh!t ton of work, but if this can be converted to Swift I believe it will be well worth the effort.


## Known Issue(s)

### 1 Unresolved ARC Issue Remaining
There is an unresolved ARC issue with the method `connectToServer:port:` found in `Classes/RemoteEngineController.mm`.

Mainly I haven't found a quick way to fix it though I'm sure there is.  Instead of racking my brain this late at night, just commented out the method body and will revisit it later.  Otherwise - we now have an ARC version that seems to work =]
 
