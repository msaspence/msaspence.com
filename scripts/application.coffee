$().ready ()->
  $(document).on 'click', '.actions .more', (e)->
    e.preventDefault()
    $this = $(this)
    $this.parent().siblings('.more-details').slideToggle()
    if $this.text() == 'More Details'
      $this.text('Less Details')
    else
      $this.text('More Details')

  # $(document).on 'click', '#btn-print', (e)->
  #   e.preventDefault()
  #   # Create an iframe element
  #   iframe = document.createElement "iframe"
  #   iframe.style.width = "100%"
  #   iframe.style.height = "100%"
  #   # iframe.style.visibility = "hidden" # or display: none; but hidden is better for printing
  #   iframe.src = "/Matthew Spence Resume Full Stack Software Engineer.pdf" # Ensure same-origin or proper CORS
  #   document.body.appendChild iframe
  #   $(e.target).closest('.btn').addClass 'loading'
    
  #   # Wait for the PDF to load
  #   iframe.onload = ->
  #     # Give some time for rendering (adjust if needed)
  #     setTimeout (->
  #       try
  #         # Trigger the print dialog of the loaded PDF
  #         iframe.contentWindow.focus()
  #         iframe.contentWindow.print()
  #         $(e.target).closest('.btn').removeClass 'loading'

  #       catch error
  #         console.error "Error triggering print:", error
  #     ), 500 # Delay may need adjustment based on file size and rendering speed
  