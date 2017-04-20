App.list = App.cable.subscriptions.create { channel: "ListChannel", id: window.location.pathname.split('/')[2]},
  connected: ->
# Called when the subscription is ready for use on the server

  disconnected: ->
# Called when the subscription has been terminated by the server

  received: (data) ->
    alert('List was updated')
    row = $("tr td:nth-child(1)").filter( ->  return $(this).text() == data.task.id.toString()).closest('tr')
    if data.method == 'delete'
      row.fadeOut(300, ->  $(this).remove())
    else if data.method == 'create'
      ft.rows.add(data.task);
    else if data.method == 'edit'
      row.remove()
      ft.rows.add(data.task);
