url = require('url')
require('zappajs') process.env.PORT || 3000, ->
  @use (req, res, next) =>
    parsed = url.parse(req.url)
    unless parsed.pathname == '/'
      ext = parsed.pathname.match(/\.([^\/.]+)/)
      unless ext
        parsed.pathname += '.html'
        req.url = url.format(parsed)
    next()
  @use 'static'
