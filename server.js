(function() {
  var url;

  url = require('url');

  require('zappajs')(process.env.PORT || 3000, function() {
    var _this = this;
    this.use(function(req, res, next) {
      var ext, parsed;
      parsed = url.parse(req.url);
      if (parsed.pathname !== '/') {
        ext = parsed.pathname.match(/\.([^\/.]+)/);
        if (!ext) {
          parsed.pathname += '.html';
          req.url = url.format(parsed);
        }
      }
      return next();
    });
    return this.use('static');
  });

}).call(this);
