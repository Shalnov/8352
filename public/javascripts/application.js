var NestedAttributesJs = {
  add : function(e) {
    element = $(e);
    template = eval($(e).attr("href").replace(/.*#/, '') + '_template');
		template = NestedAttributesJs.replace_ids(template);

    $(template).insertBefore($(element));
  },
  replace_ids : function(template){
    var new_id = new Date().getTime();
    return $(template).html().replace(/NEW_RECORD/g, "new_" + new_id);
  }
}

$(window).load(function(){
  $('.add_nested').click(function(){
			NestedAttributesJs.add($(this));
  });
});

