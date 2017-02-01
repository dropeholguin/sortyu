// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require turbolinks
//= require social-share-button
// Bower packages
//= require_tree .

var createCookie = function(name, value, days) {
   var expires;
   if (days) {
       var date = new Date();
       date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
       expires = "; expires=" + date.toGMTString();
   }
   else {
       expires = "";
   }
   document.cookie = name + "=" + value + expires + "; path=/";
}

//Reads cookies
function readCookie(name) {
	var nameEQ = name + "=", ca = document.cookie.split(';');
	for (var i = 0; i < ca.length; i += 1) {
		var c = ca[i];
		while (c.charAt(0) === ' ') { 
			c = c.substring(1, c.length);
		}
		if (c.indexOf(nameEQ) === 0) {
			return c.substring(nameEQ.length, c.length);
		}
	}
	return null;
}

function deleteCookie(name){
 createCookie(name,"",-1);
}

$(function(){ 
	$(document).foundation(); 
});

$(document).on("turbolinks:load", function() { 
	$(document).foundation();
});

$(document).on("turbolinks:load", function() {
	var $next = $('.next_page'); 
	var $previous = $('.previous_page');
	$('.pagination').removeClass('pagination');
	$previous.remove();
	$next.addClass('button');
});

$(document).on("turbolinks:load", function() {
	$('#gallery-import img').click(function(){
		var $imgSrc = $(this).attr('src');
		var $checkbox = $('input[value="'+$imgSrc+'"]');

		if ($(this).attr('class') == 'highlight') {
			$(this).removeClass("highlight");
			$checkbox.prop('checked', false);
		}
		else{
			$(this).attr('class','highlight');
			$checkbox.prop('checked', true);
		}
	});
});
