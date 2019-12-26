#  A tribute to MacOS testing task by MacPaw

## How to use this app

* add files to the list by pressing Command+O or select `Open` from the app menu
* select operation to run on the list of files
* take the bottle of rum from under the table
* press the button at the bottom
* enjoy

## What the app can do

Remove, duplicate and calculate hash sums for the list of files.

## Architecture and design considerations

* using XPC to schedule tasks to a separate process running in the background
* bi-directinal XPC to show accurate loading indicator
* simple MVVM with no bindings (I could add KVO, macos bindings, FRP such as RxSwift or ReactiveSwift, but what's the point when my designer is crying)
* 


