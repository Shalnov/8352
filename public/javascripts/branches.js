function get_visible() {
  var visible = [];
  $('#branches tr').each(function(i, tag) {
    if ($(tag).css('display') != 'none') { 
      visible.push(tag.id);
    }
  });
  return visible;  
}

function get_open_icons_visible() {
  var open_icons_visible = [];
  $('#branches tr ._open').each(function(i, tag) {
    if ($(tag).css('display') == 'none') {
      open_icons_visible.push(tag.id);
    }
  });
  return open_icons_visible;  
}

function branches() {
  $('#branches tr ._branch').droppable('destroy');
  $('#branches tr ._branch').draggable('destroy');
  $('#branches tr ._group').draggable('destroy');  
  $('#groups tr ._group').draggable('destroy');

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
          authenticity_token: window._token,
          "visible[]": get_visible(),
          "open_icons_visible[]": get_open_icons_visible()
        },
        url: '/admin/branches/move'
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
    var cls = '.' + $(this).attr('rel');
    $(cls).hide();
    $(this).hide();
    $(this).parent().find('._open').show();
    $(cls).find('._close').click();
    zebra();
  });
  
  $('#branches ._open').live('click', function() {
    var cls = $(this).attr('rel');
    $('.'+cls).show();
    $(this).hide();
    $(this).parent().find('._close').show();
    zebra();
  });  
}

function zebra() {
  var flg = 1;
  $('#branches tr:visible').each(function(i, tr) {
    $(tr).removeClass('odd').removeClass('even');
    $(tr).addClass(flg ? 'odd' : 'even')
    flg = !flg;
  });
}

$(document).ready(function() {
  zebra();
  
  $('#branches tr').live('mouseover', function(e) {
    $(this).find('._edit').show();
  });

  $('#branches tr').live('mouseout', function(e) {
    $(this).find('._edit').hide();
  });
  
  $('#loader').ajaxStart(function() {
    $(this).show();
  });

  $('#loader').ajaxStop(function() {
    zebra();
    $(this).hide();
  });
  
  $('a._delete').live('click', function(e) {
    e.preventDefault();
    $.ajax({
      type: 'get',
      dataType: 'script',
      data: {
        _method: '_delete',
        authenticity_token: window._token,
        "visible[]": get_visible(),
        "open_icons_visible[]": get_open_icons_visible()
      },
      url: $(this).attr('href')
    }); 
  });

  $('a._move_up, a._move_down').live('click', function(e) {
    e.preventDefault();
    $.ajax({
      type: 'post',
      dataType: 'script',
      data: {
        authenticity_token: window._token,
        "visible[]": get_visible(),
        "open_icons_visible[]": get_open_icons_visible()
      },
      url: $(this).attr('href')
    }); 
  });
});