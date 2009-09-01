function branches() {
  $('#branches tr').draggable('destroy');
  $('#branches tr').droppable('destroy');
  $('#branches tr ._branch').droppable('destroy');

  $('#branches tr._branch').draggable({
    revert: 'invalid',
    handle: '._move',
    helper: function() {
      return "<div class='helper'>"+$(this).attr('rel')+"</div>"
    }
  });

  $('#branches tr._branch').droppable({
    accept: 'tr._branch, tr._group',
    hoverClass: 'hover',
    drop: function(event, ui) {
      $.ajax({
        type: 'post',
        data: {
          clone: event.originalEvent.shiftKey,
          source: $(ui.draggable).attr('id'),
          target: $(this).attr('id'),
          authenticity_token: window._token
        },
        url: '/admin/branches/move',
        success: function(html) {
          $('#branches').html(html);
        },
        error: function() {
          alert('error')
        }
      });
    }
  });
  
  $('#branches tr._group').draggable({
    revert: 'invalid',
    handle: '._move',
    helper: function() {
      return "<div class='helper'>"+$(this).attr('rel')+"</div>"
    },
    drag: function(event, ui) {
      if (event.originalEvent.shiftKey) {
        $(ui.helper).addClass('gclone');
      } else {
        $(ui.helper).removeClass('gclone');
      }
    }
  });
  
  $('#groups tr._group').draggable({
    revert: 'invalid',
    handle: '._move',
    helper: function() {
      return "<div class='helper'>"+$(this).attr('rel')+"</div>"
    },    
  });
}