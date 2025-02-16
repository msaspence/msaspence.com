$().ready ()->
  $(document).on 'click', '.actions .more', (e)->
    e.preventDefault()
    $this = $(this)
    $this.parent().siblings('.more-details').slideToggle()
    if $this.text() == 'More Details'
      $this.text('Less Details')
    else
      $this.text('More Details')

  $(document).on 'click', '#btn-print', (e)->
    e.preventDefault()
    window.print()
  