$ ->
  updateArticles = ->
    searchText = $('#pubfilter').val().toLowerCase()
    if searchText
      $('.publist li').each ->
        if @textContent.toLowerCase().indexOf(searchText) >= 0
          @style.display = 'block'
        else
          @style.display = 'none'
    else
      $('.publist li').show()
    $('.clearbtn').toggle(searchText.length > 0)

  pubFilter = $('#pubfilter')
  pubFilter.on 'input', updateArticles

  pos = pubFilter.position()
  pubFilter.after '<div class="clearbtn"></div>'
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
