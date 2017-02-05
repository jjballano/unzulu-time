//= require jquery-ui/widgets/autocomplete


App.Tasks =
  initialize: ->
    projectList = JSON.parse($('#project-list').val())
    $('#projects').autocomplete({
      source: projectList
    })
