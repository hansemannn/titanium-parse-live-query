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
