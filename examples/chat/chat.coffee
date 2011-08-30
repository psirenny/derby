derby = require 'derby'
# This module's "module" and "exports" objects are passed to Derby, so that it
# can expose certain functions on this module for the server or client code.
{model, view} = derby.createApp module, exports


# SERVER & CLIENT VIEW DEFINITION #

# Context object names starting with a capital letter are reserved. They are
# used for built-in properties of model.
view.make 'info', """
  {{^Connected}}
    {{#CanConnect}}
      <p id=info>Offline<span id=reconnect> &ndash; 
      <a href=# onclick="return chat.connect()">Reconnect</a></span>'
    {{/CanConnect}}{{^CanConnect}}
      <p id=info>Unable to reconnect &ndash; 
      <a href=javascript:window.location.reload()>Reload</a>
    {{/CanConnect}}
  {{/Connected}}
  """

view.make 'message', """
  <li><img src=img/s.png class={{user.picClass}}>
    <div class=message>
      <p><b>{{user.name}}</b>
      <p>{{comment}}
    </div>
  """,
  # The "After" option specifies a function to execute after the view is
  # rendered. If a view that has an after function is rendered on the server,
  # the after function will be added to the preLoad functions.
  After: -> $('messages').scrollTop = $('messageList').offsetHeight


# USER FUNCTIONS DEFINITION #

# Exported functions are exposed as a global in the browser with the same
# name as this module. This function is called by the form submission action.
exports.postMessage = ->
  model.push '_room.messages',
    user: model.ref '_room.users', '_session.userId'
    comment: model.get '_session.newComment'
  model.set '_session.newComment', ''
  return false