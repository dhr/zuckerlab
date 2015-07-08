(function() {
  $(function() {
    var clearWidth, pos, pubFilter, updateArticles;
    $.fn.selectText = function() {
      var doc, el, range, sel, win;
      el = this[0];
      win = window;
      doc = win.document;
      sel = void 0;
      range = void 0;
      if (win.getSelection && doc.createRange) {
        range = doc.createRange();
        range.selectNodeContents(el);
        sel = win.getSelection();
        sel.removeAllRanges();
        sel.addRange(range);
      } else if (doc.body.createTextRange) {
        range = doc.body.createTextRange();
        range.moveToElementText(el);
        range.select();
      }
    };
    updateArticles = function() {
      var searchText;
      searchText = $('#pubfilter').val().toLowerCase();
      if (searchText) {
        $('.publist li').each(function() {
          var text;
          text = this.querySelector('.reference').textContent;
          if (text.toLowerCase().indexOf(searchText) >= 0) {
            return this.style.display = 'block';
          } else {
            return this.style.display = 'none';
          }
        });
      } else {
        $('.publist li').show();
      }
      return $('.clearbtn').toggle(searchText.length > 0);
    };
    pubFilter = $('#pubfilter');
    pubFilter.on('input', updateArticles);
    pos = pubFilter.position();
    pubFilter.after("<div class='clearbtn'></div>");
    $('.clearbtn').toggle(pubFilter.val().length > 0);
    clearWidth = $('.clearbtn').outerWidth();
    $('.clearbtn').css({
      position: 'absolute',
      top: pos.top + (pubFilter.outerHeight() - clearWidth) / 2 + 1,
      left: pos.left + pubFilter.outerWidth() - clearWidth - 10
    }).on('click', function() {
      pubFilter.val('');
      updateArticles();
      return pubFilter.focus();
    });
    return $('.publist li').each(function() {
      var $elem, $ref, ctrl, ctrlText, firstAuthor, kind, pre, refstr, year;
      $elem = $(this);
      kind = (function() {
        switch (false) {
          case !$elem.hasClass('journal'):
            return '@Article';
          case !$elem.hasClass('book'):
            return '@InCollection';
          case !$elem.hasClass('conference'):
            return '@inproceedings';
          default:
            return '';
        }
      })();
      if (kind.size === 0) {
        return;
      }
      $elem.append($("<div class='bibtex'>\n  <a class='control'>BibTeX</a>\n  <div class='bibtex-content'>\n    <pre></pre>\n  </div>\n</div>"));
      firstAuthor = $elem.find('.author')[0].textContent.split(',')[0];
      year = $elem.find('.year').text();
      refstr = kind + "{" + firstAuthor + year;
      $ref = $elem.find('.reference > *').each(function() {
        var $item;
        $item = $(this);
        refstr += ",\n  ";
        if ($item.hasClass('authors')) {
          refstr += "Author = {";
          refstr += $item.find('.author').map(function() {
            return this.textContent;
          }).toArray().join(" and ");
        } else {
          refstr += this.className.charAt(0).toUpperCase() + this.className.slice(1);
          refstr += " = {" + this.textContent;
        }
        return refstr += "}";
      });
      refstr += "\n}";
      pre = $elem.find('pre');
      pre.text(refstr);
      ctrl = $elem.find('.control');
      ctrl.css({
        width: ctrl.width()
      });
      ctrlText = ctrl.text();
      ctrl.on('mouseover', function() {
        return ctrl.text('Select');
      });
      ctrl.on('mouseout', function() {
        return ctrl.text(ctrlText);
      });
      return ctrl.on('click', function() {
        return pre.selectText();
      });
    });
  });

}).call(this);

//# sourceMappingURL=publications.js.map
