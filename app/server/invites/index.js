(function(){
  var controllers;
  controllers = require("./controllers");
  exports.index = controllers.index;
  exports.activate = controllers.activate;
  exports.error = controllers.error;
}).call(this);