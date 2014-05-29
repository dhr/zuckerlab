$ ->
  $.fn.selectText = ->
    el = this[0]
    win = window
    doc = win.document
    sel = undefined
    range = undefined
    if win.getSelection and doc.createRange
      range = doc.createRange()
      range.selectNodeContents el
      sel = win.getSelection()
      sel.removeAllRanges()
      sel.addRange range
    else if doc.body.createTextRange
      range = doc.body.createTextRange()
      range.moveToElementText el
      range.select()
    return

  # Reference search functionality
  updateArticles = ->
    searchText = $('#pubfilter').val().toLowerCase()
    if searchText
      $('.publist li').each ->
        text = @querySelector('.reference').textContent
        if text.toLowerCase().indexOf(searchText) >= 0
          @style.display = 'block'
        else
          @style.display = 'none'
    else
      $('.publist li').show()
    $('.clearbtn').toggle(searchText.length > 0)

  pubFilter = $('#pubfilter')
  pubFilter.on 'input', updateArticles

  # Add clear button to filter input
  pos = pubFilter.position()
  pubFilter.after "<div class='clearbtn'></div>"
  $('.clearbtn').toggle pubFilter.val().length > 0
  clearWidth = $('.clearbtn').outerWidth()
  $('.clearbtn').css
    position: 'absolute'
    top: pos.top + (pubFilter.outerHeight() - clearWidth)/2 + 1
    left: pos.left + pubFilter.outerWidth() - clearWidth - 10
  .on 'click', ->
    pubFilter.val ''
    updateArticles()
    pubFilter.focus()

  # Add BibTeX control
  $('.publist li').each ->
    $elem = $(this)

    kind = switch
      when $elem.hasClass 'journal' then '@Article'
      when $elem.hasClass 'book' then '@InCollection'
      when $elem.hasClass 'conference' then '@inproceedings'
      else ''

    if kind.size == 0
      return

    $elem.append $ """
      <div class='bibtex'>
        <a class='control'>BibTeX</a>
        <div class='bibtex-content'>
          <pre></pre>
        </div>
      </div>
    """

    firstAuthor = $elem.find('.author')[0].textContent.split(',')[0]
    year = $elem.find('.year').text()
    refstr = kind + "{" + firstAuthor + year
    $ref = $elem.find('.reference > *').each ->
      $item = $(this)
      refstr += ",\n  "
      if $item.hasClass 'authors'
        refstr += "Author = {"
        refstr += $item.find('.author').map -> @textContent
          .toArray().join " and "
      else
        refstr += @className.charAt(0).toUpperCase() + @className.slice(1)
        refstr += " = {" + @textContent
      refstr += "}"
    refstr += "\n}"
    pre = $elem.find('pre')
    pre.text(refstr)

    ctrl = $elem.find('.control')
    ctrl.css
      width: ctrl.width()
    ctrlText = ctrl.text()
    ctrl.on 'mouseover', ->
      ctrl.text 'Select'
    ctrl.on 'mouseout', ->
      ctrl.text ctrlText
    ctrl.on 'click', ->
      pre.selectText()
