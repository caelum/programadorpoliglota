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

$(document).ready(function(){
	$('#lang01 a.hide').click(function(){
		$('div#lang01').hide();
	});
	$('#lang02 a.hide').click(function(){
			$('div#lang02').hide();
		});
	$('#lang03 a.hide').click(function(){
			$('div#lang03').hide();
		});
	$('#lang04 a.hide').click(function(){
			$('div#lang04').hide();
		});
	$('#lang05 a.hide').click(function(){
			$('div#lang05').hide();
		});
	$('#lang06 a.hide').click(function(){
			$('div#lang06').hide();
		});
	$('#lang07 a.hide').click(function(){
			$('div#lang07').hide();
		});
});

$(document).ready(function(){
	$('#link01').click(function(){
		$('div#lang01').show();
	});
	$('#link02').click(function(){
			$('div#lang02').show();
		});
	$('#link03').click(function(){
			$('div#lang03').show();
		});
	$('#link04').click(function(){
			$('div#lang04').show();
		});
	$('#link05').click(function(){
			$('div#lang05').show();
		});
	$('#link06').click(function(){
			$('div#lang06').show();
		});
	$('#link07').click(function(){
			$('div#lang07').show();
		});
});
