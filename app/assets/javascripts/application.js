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
		if ($(this).attr('class') == 'highlight') {
			$(this).removeClass("highlight");
			$checkbox.prop('checked', true);
		}
		else{
			$(this).attr('class','highlight');
			$checkbox.prop('checked', false);
		}

		var $imgSrc = $(this).attr('src');
		var $checkbox = $('input[value="$imgSrc"]');
	});
});
