$ ->
  zindex = 999
  $('.project-link').each ->
    sign = (x) ->
      return (if x is 0 then x else (if x > 0 then 1 else -1)) if +x is x
      NaN

    rotAmt = 0.75*sign(Math.random() - 0.5)*(Math.random() + 1)
    $(this).css
      transform: 'rotate(' + rotAmt + 'deg)'
      zIndex: zindex--
