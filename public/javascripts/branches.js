function branches() {
/*  $('#branches tr ._branch').droppable('destroy');
  $('#branches tr ._branch').draggable('destroy');
  $('#branches tr ._group').draggable('destroy');  
  $('#groups tr ._group').draggable('destroy');    */

  $('#branches tr._branch').droppable({
    accept: 'tr._branch, tr._group',
    hoverClass: 'hover',
    drop: function(event, ui) {
      $.ajax({
        type: 'post',
        dataType: 'script',
        data: {
          clone: $(ui.helper).hasClass('gclone'),
          source: $(ui.draggable).attr('id'),
          target: $(this).attr('id'),
          authenticity_token: window._token
        },
        url: '/admin/branches/move',
        error: function() {
          alert('error')
        }
      });
    }
  });

  $('#branches tr._branch').draggable({
    revert: 'invalid',
    handle: '._move',
    helper: function() {
      return "<div class='helper'>"+$(this).attr('rel')+"</div>"
    }
  });
  
  $('#branches tr._group').draggable({
    revert: 'invalid',
    handle: '._move ._clone',
    helper: function() {
      return "<div class='helper'>"+$(this).attr('rel')+"</div>"
    },
    start: function(event, ui) {
      if ($(event.originalEvent.originalTarget).hasClass('_clone')) {
        $(ui.helper).addClass('gclone');
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
  
  $('#branches ._close').live('click', function() {
    var cls = $(this).attr('rel');
    $('.'+cls).hide();
    $(this).hide();
    $(this).parent().find('._open').show();
  });
  
  $('#branches ._open').live('click', function() {
    var cls = $(this).attr('rel');
    $('.'+cls).show();
    $(this).hide();
    $(this).parent().find('._close').show();
  })  
}