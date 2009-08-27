function branches() {
  $('#branches tr').draggable('destroy');
  $('#branches tr').droppable('destroy');
  $('#branches tr ._branch').droppable('destroy');

  $('#branches tr._branch').draggable({
    revert: 'invalid',
    handle: '._move',
    helper: 'clone',
    helper: function() {
      return "<div class='helper'>"+$(this).attr('rel')+"</div>"
    }
  })

  $('#branches tr._branch').droppable({
    accept: 'tr',
    hoverClass: 'hover',
    drop: function(event, ui) {
      $.ajax({
        type: 'post',
        data: {
          source: $(ui.draggable).attr('id'),
          target: $(this).attr('id'),
          authenticity_token: window._token
        },
        url: '/admin/branches/move',
        success: function(html) {
          $('#branches').html(html);
        }
      });
    },
    greedy: true
  });
  
  $('#branches tr td._branch').droppable({
    accept: 'tr._branch',
    hoverClass: 'hover',
    drop: function(event, ui) {
      $.ajax({      
        type: 'post',
        data: {
          source: $(ui.draggable).attr('id'),
          target_parent: $(this).parents('tr').attr('id'),
          authenticity_token: window._token
        },
        url: '/admin/branches/move',
        success: function(html) {
          $('#branches').html(html);
        }
      });
    },
    greedy: true
  });
}