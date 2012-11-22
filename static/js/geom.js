// Generated by CoffeeScript 1.3.3
(function() {

  (typeof exports !== "undefined" && exports !== null ? exports : this)._geom = {
    distance: function(x0, y0, x1, y1) {
      return Math.sqrt((Math.pow(x1 - x0, 2)) + (Math.pow(y1 - y0, 2)));
    },
    norm: function(x, y) {
      var f;
      return [x / (f = Math.sqrt(x * x + y * y)), y / f];
    },
    pi: Math.PI
  };

}).call(this);
