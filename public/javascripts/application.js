// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


//função para mostrar mais twits
	$(function() {
		registerEvent();
	});

	function registerEvent() {
		$(".ver_mais").click(function() {
			elemento = $(this);
			url = $(this).attr('href');
      $.get(url, function(data) {
        div = elemento.parent().parent();
        div.find('.ver_mais').remove();
        div.find('.bloco_ver_mais').remove();
				div.find('.newsLang').replaceWith(data);
				registerEvent();
			});
			return false;
		});
	}

// recupera todos os cookies e mostra os grupos de tags de acordo com os valores dos cookies
$(document).ready(function(){
	var i=0;
	for (i=1;i<=7;i++) {
		var id = 'lang0'+i;
		if ($.cookie(id) == null) //cookie sem valor, mostra todas as linguagens
		    $('div#lang0'+i).show();
		else if ($.cookie(id) == 1)
		    // Exibimos
		    $('div#lang0'+i).show();
		else if ($.cookie(id) == 0)
		    $('div#lang0'+i).hide();
	}
});

//esconde grupode de tags e grava cookie
$(document).ready(function(){
		$('a.hide').click(function(){
				var id = $(this).parent().parent().parent().attr('id');
				$('div#'+id).hide(function(){
						$.cookie(id, 0, {expires: 365});
				});
		});
});

//mostra grupo de tags e grava cookie
$(document).ready(function(){
	$('a.linkLang').click(function(){
		var id = 'lang0'+$(this).attr('id');
		$('div#'+id).show('fast',function(){
			$.cookie(id, 1, {expires: 365});
		});
	});
});
