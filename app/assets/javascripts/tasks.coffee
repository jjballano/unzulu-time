//= require jquery-ui/widgets/autocomplete


App.Tasks =
  initialize: ->
    projectList = JSON.parse($('#project-list').val())
    $('#project').autocomplete({
      source: projectList
    })
