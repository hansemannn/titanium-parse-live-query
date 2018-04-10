# Parse Live Query in Titanium

Use the Parse & Parse Live Query iOS SDK's in Axway Titanium!

> Warning! This module is only a proof of concept so far and does not export all possible API's.

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

## License

Apache 2

## Author

Hans Knöchel
