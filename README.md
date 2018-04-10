# Parse Live Query in Titanium

Use the Parse & Parse Live Query iOS SDK's in Axway Titanium!

> Warning! This module is only a proof of concept so far and does not export all possible API's.

## Compile Swift Libraries

This project uses the following 5 Swift dependencies:

- Bolds
- BoldsSwift
- Parse
- ParseLiveQuery
- Starscream

While `Bolds` and `Parse` are Obj-C based, the others are dynamic Swift libraries. This projects resolves
all dependencies already for you, including setting the Swift version using the hook placed in `hooks/`.

Right now, Titanium only supports CocoaPods for Hyperloop, so in order to use it for classic modules, you need
to create universal "fat" frameworks and strip the unused architectures again (this is taken care of by the SDK already).
A universal library can be created by grabbing the frameworks from `Debug-iphonesimulator` (Simulator architectures) 
and `Debug-iphoneos` (Device architectures) and combine them using the following commands:

0. Install CocoaPods (`sudo gem install cocoapods`) and run `pod install` in the `native/` directory of this repository
1. Create the following folder structures: `sim/`, `device/` & `universal/`
2. Copy the .framework files from `Debug-iphonesimulator` to `sim/`
3. Copy the .framework files from `Debug-iphoneos` to `device/`
4. Copy the .framework files from `device` to `universal/` (they are the base for universal frameworks)
5. For `BoldsSwift` and `ParseLiveQuery`, copy the `Modules/*.swiftmodule` to the universal directory of the framework
6. Use the following command to merge the sim- and device-frameworks together:
```bash
lipo -export -output universal/<name>.framework/<name> sim/<name>.framework/<name> device/<name>.framework/<name>
```
7. Replace the final frameworks in `<module-project>/platform`
8. Make a pull request to this repo, so others can benefit from it as well

These steps are based on a [Shell Script](https://gist.github.com/cromandini/1a9c4aeab27ca84f5d79) used natively.

Note: In the future, this will all be done by CocoaPods. Make sure to follow [TIMOB-25927](https://jira.appcelerator.org/browse/TIMOB-25927) regarding Swift support in the SDK.

## Example

```js
var ParseLiveQuery = require('ti.livequery');

var win = Ti.UI.createWindow({
  backgroundColor: '#fff'
});

var btn = Ti.UI.createButton({
  title: 'Initialize Parse'
});

btn.addEventListener('click', function() {
  ParseLiveQuery.initialize({
    applicationKey: 'YOUR_APP_KEY',
    clientKey: 'YOUR_CLIENT_KEY',
    server: 'YOUR_SERVER_URL'
  });
});

win.add(btn);
win.open();
```

## Author
Hans Knöchel ([@hansemannnn](https://twitter.com/hansemannnn) / [Web](http://hans-knoechel.de))

## License
Apache 2.0

## Contributing
Code contributions are greatly appreciated, please submit a new [Pull-Request](https://github.com/hansemannn/titanium-parse-live-query/pull/new/master)!
