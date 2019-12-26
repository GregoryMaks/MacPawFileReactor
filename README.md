#  A tribute to MacOS testing task by MacPaw

## How to use this app

* add files to the list by pressing Command+O or select `Open` from the app menu
* select operation to run on the list of files
* take the bottle of rum from under the table
* press the button at the bottom
* enjoy

## What the app can do

Remove, duplicate and calculate hash sums for the list of files.
Add random delays for more fun during file processing, don't add too many files (or remove call to `addSomeFun()` from Operations beforehand)

## Known issues

Processing large files is not optimized, this can be an issue when copying or calculating hash sum (improvement needed)

## Architecture and design considerations

* no external libraries or frameworks used (except Apple ones)
* using XPC to schedule tasks to a separate process running in the background
* bi-directinal XPC to show accurate loading indicator
* simple MVVM with no bindings (I could add KVO, macos bindings, FRP such as RxSwift or ReactiveSwift, but what's the point when my designer is crying)
* localization is in place, only en-US is available now

## What I would do given time

* large files processing
* good data-driven architecture (Redux or similar)
* DI, Swinject or similar (code is ready for it, separate interfaces for services as example)
* unit test coverage
* more XPC error handling (I am afraid what I've done may not be enough)
* processing of large files should be better
* some small stuff like drag-n-drop, file removal, adding folders recursively, etc. 
