(function() {
  $(function() {
    var zindex;
    zindex = 999;
    return $('.project-link').each(function() {
      var rotAmt, sign;
      sign = function(x) {
        if (+x === x) {
          return (x === 0 ? x : (x > 0 ? 1 : -1));
        }
        return NaN;
      };
      rotAmt = 0.75 * sign(Math.random() - 0.5) * (Math.random() + 1);
      return $(this).css({
        transform: 'rotate(' + rotAmt + 'deg)',
        zIndex: zindex--
      });
    });
  });

}).call(this);

//# sourceMappingURL=index.js.map
