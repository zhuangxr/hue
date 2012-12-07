var fs = require("fs");
var jasmine = require("jasmine-node");

for (var key in jasmine) {
  global[key] = jasmine[key];
}

var sys = require("sys");
var path = require("path");

var filename = __dirname + "/lib/jasmine.jquery.js";
var src = fs.readFileSync(filename);
var minorVersion = process.version.match(/\d\.(\d)\.\d/)[1];
switch (minorVersion) {
  case "1":
  case "2":
    process.compile(src + "\njasmine;", filename);
    break;
  default:
    require("vm").runInThisContext(src + "\njasmine;", filename);
}

// override the fixturesPath specified in the single tests
global.jasmine.fromNode = true;

// override the loadFixtures method of jasmine-jquery
global.loadFixtures = function (path) {
  var _filePath = global.jasmine.getFixtures().fixturesPath + path;
  var content = fs.readFileSync(_filePath);
  global.jasmine.getFixtures().fixturesCache_[_filePath] = (content.toString());
  global.jasmine.getFixtures().cleanUp();
  global.jasmine.getFixtures().createContainer_(content.toString());
};

global.window = require("jsdom").jsdom().createWindow();
global.document = global.window.document;
global.jQuery = global.$ = require("jquery");

// adds support for a real XMLHttpRequest
var XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest;
$.support.cors = true;
$.ajaxSettings.xhr = function () {
  return new XMLHttpRequest;
}


require("../desktop/core/static/ext/js/bootstrap.min.js");
require("../desktop/core/static/ext/js/jquery/plugins/jquery.dataTables.1.8.2.min.js");

require("../desktop/core/static/js/Source/jHue/jquery.selector.js");
require("../desktop/core/static/js/Source/jHue/jquery.tableextender.js");
//require("./plugins/bootstrap.min.js");
//require("./plugins/jquery.selector.js");
//require("./plugins/jquery.tableextender.js");

global.jasmine.getFixtures().fixturesPath = __dirname + "/../desktop/core/static/jasmine/";
global.jasmine.executeSpecsInFolder(__dirname + "/../desktop/core/static/jasmine", function (runner, log) {
  process.exit(runner.results().failedCount ? 1 : 0);
}, true, true);