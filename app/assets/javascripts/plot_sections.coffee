window.LocalPloter ?= {}

# Draws the rectangles when a photo has sections at section edit view
window.LocalPloter.plotSectionEdit = (x, y, w, h,tx,ty) ->
	$rect = $('<div></div>')
	$('#inner-canvas').append($rect)
	$rect.addClass('rect resize-drag')
	$rect.css("width", "#{w}px")
	$rect.css("height", "#{h}px")
	$rect.css("left","#{x}px")
	$rect.css("top","#{y}px")
	$rect.css({"transform":"translate(#{tx}px,#{ty}px)"})





# Cycles sections to draw rectangles at sorting page
window.LocalPloter.performPlot = (sections)->
	number = 0

	#checks if all rectangles are clicked
	isSortingDone = ->
		if $(".rect-clicked").length == $(".rect").length
			return true
		else
			return false

	#If a clicked rectangle gets click, resets all rectangles
	resetRect = ->
		if not isSortingDone()
			$(".rect-clicked").each (index, element) ->
				number = 0
				$(element).removeAttr("id")
				$(element).removeClass('magictime puffIn rect-clicked')
				$('.rect span').remove()

	#Adds on click event to each rectangle to reset all rectangles
	updateRect = (rect) ->
		rect.click ->
			number = number + 1
			if rect.hasClass("rect-clicked")
				resetRect()
			else
				rect.addClass("magictime puffIn rect-clicked")
				rect.attr("id","#{number}")
				rect.append("<span>#{number}</span>")

	# Draws the rectangles at the sorting page
	window.LocalPloter.plotSection = (x, y, w, h,tx,ty) ->
		$rect = $('<div></div>')
		$('.inner-sorting-canvas').append($rect)
		$rect.addClass('rect')
		$rect.css("width", "#{w}px")
		$rect.css("height", "#{h}px")
		$rect.css("left","#{x}px")
		$rect.css("top","#{y}px")
		$rect.css({"transform":"translate(#{tx}px,#{ty}px)"})
		updateRect($rect)

	for section in sections
		window.LocalPloter.plotSection(section.left, section.top, section.width, section.height, section.translateX, section.translateY)
