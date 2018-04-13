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
