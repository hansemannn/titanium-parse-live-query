# Parse Live Query in Titanium

Use the Parse & Parse Live Query iOS SDK's in Axway Titanium! Read more about the Parse Live Query API 
in the [official native repository](https://github.com/parse-community/ParseLiveQuery-iOS-OSX).

## API'S

### Root-Module

#### Methods

##### `initialize(args: Dictionary)`

- `applicationId` (String)
- `clientKey` (String)
- `server` (String)
- `localDatastoreEnabled` (Boolean)

##### `createClient(args: Dictionary)`

- `applicationId` (String)
- `clientKey` (String)
- `server` (String)

#####  `saveObject(args)`

- `className` (String)
- `parameters` (Dictionary)
- `callback` (Function)

#### Constants

##### EVENT_TYPE_ENTERED
##### EVENT_TYPE_LEFT
##### EVENT_TYPE_CREATED
##### EVENT_TYPE_UPDATED
##### EVENT_TYPE_DELETED

---

### `Client`

#### Methods

#####  `reconnect()`

#####  `disconnect()`

#####  `isConnected()` -> Boolean

##### `subscribeToQuery(query)`

- `query` (`Query`)

##### `unsubscribeFromQuery(args)`

- `className` (String)
- `query` (String)

#### Events

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

### `Query`

#### Initializer (`createQuery(args)`)

- `className` (String)
- `predicate` (String, optional, e.g. `name = "hans"`)

#### Methods

##### `findObjectsInBackground(callback)`

- `callback` (Function)

---

### `Object`

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

var btn1 = Ti.UI.createButton({
  title: 'Initialize Parse',
  top: 100
});

var btn2 = Ti.UI.createButton({
  title: 'Subscribe to Class',
  top: 200
});

btn1.addEventListener('click', function() {
  ParseLiveQuery.initialize({
    applicationId: 'YOUR_APP_KEY',
    clientKey: 'YOUR_CLIENT_KEY',
    server: 'YOUR_SERVER_URL'
  });
});
  
btn2.addEventListener('click', function() {
  var client = ParseLiveQuery.createClient({
    applicationId: 'YOUR_APP_KEY',
    clientKey: 'YOUR_CLIENT_KEY',
    server: 'YOUR_SERVER_URL'
  });
  
  client.addEventListener('subscribe', function(e) {
    // Subscribed
  });
  
  client.addEventListener('unsubscribe', function(e) {
    // Unsubscribed
  });
  
  client.addEventListener('event', function(e) {
    // Event received, check with e.type
  });
  
  client.addEventListener('error', function(e) {
    // Error received, check with e.error
  });
  
  client.subscribeToQuery({
    className: 'YOUR_CLASS_NAME'
  });
});

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
