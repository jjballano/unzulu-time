
App.Welcome =
  initialize: ->
    $('#startForm').on('submit', (event)->
      event.preventDefault()
      window.location.href = '/'+$('#username').val()
    )