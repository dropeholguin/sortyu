window.LocalTracker ?= {}	

window.LocalTracker.performTracking = ->
	#Creates the tracker if finds the id
	if $('#sorting-principal').length > 0
		number = 0
		$img = $('#trackme')
		tracker = new tracking.ObjectTracker(['face'])
		tracker.setStepSize(1.7)
		tracking.track('#trackme', tracker)
		
		tracker.on 'track', (event) ->
			for rect in event.data
				plotRectangle(rect.x, rect.y, rect.width, rect.height)
			resetRect()

		#Draws a rectangle
		plotRectangle = (x, y, w, h) ->
			$rect = $('<div></div>')
			$('#photo-container').append($rect)
			$rect.addClass('rect')
			$rect.css("width", "#{w}px")
			$rect.css("height", "#{h}px")
			imgOffset = $img.offset()
			$rect.css("left","#{(imgOffset.left + x)}px")
			$rect.css("top","#{(imgOffset.top + y)}px")
			updateRect($rect)


		#Adds on click event to each rectangle to reset all rectangles
		updateRect = (rect) ->
			rect.click ->
				number = number + 1
				if rect.hasClass("rect-clicked")
					resetRect()
				else
					rect.addClass("rect-clicked")
					rect.attr("id","#{number}")

		#If a clicked rectangle gets click, resets all rectangles
		resetRect = ->
			$(".rect-clicked").each (index, element) ->
				number = 0
				$(element).removeAttr("id")
				$(element).removeClass('rect-clicked')

		#checks if all rectangles are clicked
		countRectangles = ->
				if $(".rect-clicked").length == $(".rect").length
					return true
				else
					return false
				