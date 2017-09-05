// This is a test harness for your module
// You should do something interesting in this harness
// to test out the module and to provide instructions
// to users on how to use it by getAttribution.


// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});

win.open();

var label = Ti.UI.createLabel();
win.add(label);

var iadattributes = require('com.gaurang.iadattributes');
Ti.API.info("module is => " + iadattributes);

var eventListenerAtt = function(e){
	Ti.API.info("Got Value From Attributes : " + JSON.stringify(e));
	label.text = JSON.stringify(e);
};

iadattributes.addEventListener("analyticsInfo", eventListenerAtt);

label.text = iadattributes.getAttribution();
var removeListener = function(e){
	iadattributes.removeEventListener("analyticsInfo", eventListenerAtt);
};
win.addEventListener('close', removeListener);