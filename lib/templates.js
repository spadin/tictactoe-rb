this["tttTemplates"] = this["tttTemplates"] || {};

this["tttTemplates"]["board"] = function(obj){var __p='';var print=function(){__p+=Array.prototype.join.call(arguments, '')};with(obj||{}){__p+='<div class="pieces"></div>\n<div class="message"></div>';}return __p;};

this["tttTemplates"]["game"] = function(obj){var __p='';var print=function(){__p+=Array.prototype.join.call(arguments, '')};with(obj||{}){__p+='<div class="start-screen">\n  <h1>Tic Tac Toe Game</h1>\n  <ul class="menu">\n    <li><a href="#hh">Start Human vs Human</a></li>\n    <li><a href="#ha">Start Human vs AI</a></li>\n    <li><a href="#ah">Start AI vs Human</a></li>\n    <li><a href="#aa">Start AI vs AI</a></li>\n  </ul>\n</div>\n<div class="game-board"></div>';}return __p;};

this["tttTemplates"]["gameover"] = function(obj){var __p='';var print=function(){__p+=Array.prototype.join.call(arguments, '')};with(obj||{}){__p+='<div class="game-over">\n  <span>'+( message )+'</span>\n  <a href="#reset">Start over</a>\n</div>';}return __p;};

this["tttTemplates"]["square"] = function(obj){var __p='';var print=function(){__p+=Array.prototype.join.call(arguments, '')};with(obj||{}){__p+='<div class="square '+( className )+'">'+( mark )+'</div>';}return __p;};