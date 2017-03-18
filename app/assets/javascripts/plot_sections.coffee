window.LocalPloter ?= {}	

window.LocalPloter.plotSection = (x, y, w, h,tx,ty) ->
	$rect = $('<div></div>')
	$('.inner-sorting-canvas').append($rect)
	$rect.addClass('rect')
	$rect.css("width", "#{w}px")
	$rect.css("height", "#{h}px")
	$rect.css("left","#{x}px")
	$rect.css("top","#{y}px")
	$rect.css({"transform":"translate(#{tx}px,#{ty}px)"})
	console.log "translate(#{tx}px,#{ty}px)"


window.LocalPloter.performPlot = (sections)->
	for section in sections
		window.LocalPloter.plotSection(section.left, section.top, section.width, section.height, section.translateX, section.translateY)