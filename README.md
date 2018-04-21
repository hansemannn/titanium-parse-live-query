# Parse Live Query in Titanium

Use the Parse & Parse Live Query iOS and Android SDK's in Axway Titanium! Read more about the Parse Live Query API 
in the official native repositories:

- iOS: https://github.com/parse-community/ParseLiveQuery-iOS-OSX
- Android: https://github.com/parse-community/ParseLiveQuery-Android

> Warning: While iOS is ready for production, Android is highly dependent on community contributions. Submit a pull request
to expose new features, e.g. query subscriptions.

## Requirements

- [x] iOS: Swift 4.1+ (embedded into the hook in `hooks/`), iOS 8+
- [x] Android: Gradle, Android 4.1+
- [x] Titanium SDK 6.3.0+ (7.0.0+ for Android)

## Usage with other Modules

If you use this module together with Ti.Facebook, you need to remove the `Bolts.framework` from
```
<project>/modules/iphone/ti.livequery/<version>/platform/Bolts.framework
```
since it is already bundled with Ti.Facebook. Remember: In case you remove Ti.Facebook, put the framework
back in our replace it with a fresh module version that contains the framework.

## Setup

### iOS

No additional setup required.

### Android

Add the following to the `<android>` manifest section of the tiapp.xml:
```xml
<application ...>
  ...
  <meta-data android:name="com.parse.SERVER_URL" android:value="YOUR_SERVER_URL" />
  <meta-data android:name="com.parse.APPLICATION_ID" android:value="YOUR_APP_ID" />
</application>
```

## API'S

### Root-Module

#### Methods

##### `initialize(args: Dictionary)`

- `applicationId` (String)
- `clientKey` (String)
- `server` (String)
- `localDatastoreEnabled` (Boolean)

##### `createClient(args: Dictionary)` **iOS only**

- `applicationId` (String)
- `clientKey` (String)
- `server` (String)

#####  `saveObject(args)`

- `className` (String)
- `parameters` (Dictionary)
- `callback` (Function)

##### `clearAllCachedResults()`

#### Constants **iOS only**

##### EVENT_TYPE_ENTERED
##### EVENT_TYPE_LEFT
##### EVENT_TYPE_CREATED
##### EVENT_TYPE_UPDATED
##### EVENT_TYPE_DELETED

---

### `Client` **iOS only**

#### Methods

#####  `reconnect()`

#####  `disconnect()`

#####  `isConnected()` -> Boolean

##### `subscribeToQuery(query)`

- `query` (`Query`)

##### `unsubscribeFromQuery(args)`

- `className` (String)
- `query` (String)

#### Events **iOS only**

##### `subscribe`

- `query` (`Query`)

##### `unsubscribe`

- `query` (`Query`)

##### `event`

- `type` (`EVENT_TYPE_*`)
- `object` (`Object`)
- `query` (`Query`)

##### `error`

- `error` (String)
- `query` (`Query`)

---

### `Query` **iOS only**

#### Initializer (`createQuery(args)`)

- `className` (String)
- `predicate` (String, optional, e.g. `name = "hans"`)

#### Methods

##### `findObjectsInBackground(callback)`

- `callback` (Function)

##### `clearCachedResult()`

---

### `Object` **iOS only**

#### Properties

##### `parseClassName` (String)

##### `objectId` (String)

##### `createdAt` (String)

##### `updatedAt` (String)

##### `allKeys` (Array<String>)

#### Methods

##### `objectForKey(key)` -> Any

##### `setObjectForKey(object, key)`

##### `removeObjectForKey(key)` 

##### `deleteObject()` 

## Compile native libraries

### iOS

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
lipo -create -output universal/<name>.framework/<name> sim/<name>.framework/<name> device/<name>.framework/<name>
```
7. Replace the final frameworks in `<module-project>/platform`
8. Make a pull request to this repo, so others can benefit from it as well

These steps are based on a [Shell Script](https://gist.github.com/cromandini/1a9c4aeab27ca84f5d79) used natively.

Note: In the future, this will all be done by CocoaPods. Make sure to follow [TIMOB-25927](https://jira.appcelerator.org/browse/TIMOB-25927) regarding Swift support in the SDK.

### Android

0. Install Gradle and go to `android/`
1. Run `gradle getDeps`
2. Validate that the libraries are copied to `lib/`

## Example

```js
var ParseLiveQuery = require('ti.livequery');

var win = Ti.UI.createWindow({
  backgroundColor: '#fff'
});

var btn1 = Ti.UI.createButton({
  title: 'Initialize Parse',
  top: 100
});

var btn2 = Ti.UI.createButton({
  title: 'Subscribe',
  top: 200
});

btn1.addEventListener('click', function() {
  ParseLiveQuery.initialize({
    applicationId: '',
    clientKey: '',
    server: ''
  });
});

// iOS only
btn2.addEventListener('click', function() {
  var client = ParseLiveQuery.createClient({
    applicationId: '',
    clientKey: '',
    server: ''
  });

  client.addEventListener('subscribe', function(e) {
    Ti.API.info('Subscribed!');
    // Subscribed
  });

  client.addEventListener('unsubscribe', function(e) {
    Ti.API.info('Unsubscribed!');
    // Unsubscribed
  });

  client.addEventListener('event', function(e) {
    Ti.API.info('Event!');

    printObject(e.object);

    // Event received, check with e.type
  });

  client.addEventListener('error', function(e) {
    Ti.API.info('Error!');
    Ti.API.info(e.error);
    // Error received, check with e.error
  });

  var query = ParseLiveQuery.createQuery({
    className: 'Posts',
    predicate: 'name = "Hans"'
  });

  client.subscribeToQuery(query);

  // Get existing objects
  query.findObjectsInBackground(function(e) {
    Ti.API.info(e);
    var objects = e.objects;

    for (var i = 0; i < objects.length; i++) {
      printObject(objects[i]);
    }
  })
});

// Utility method to print objects by using "objectForKey"
function printObject(object) {
  var allKeys = object.allKeys;

  for (var i = 0; i < allKeys.length; i++) {
    var key = allKeys[i];
    var value = object.objectForKey(key);
    Ti.API.info(key + ' = ' + value);
  }
}

win.add(btn1);
win.add(btn2);

win.open();
```

## Author
Hans Knöchel ([@hansemannnn](https://twitter.com/hansemannnn) / [Web](http://hans-knoechel.de))

## License
Apache 2.0

## Contributing
Code contributions are greatly appreciated, please submit a new [Pull-Request](https://github.com/hansemannn/titanium-parse-live-query/pull/new/master)!
