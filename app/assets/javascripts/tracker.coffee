window.LocalTracker ?= {}	

window.LocalTracker.performTracking = ->
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

		updateRect = (rect) ->
			rect.click ->
				number = number + 1
				if rect.hasClass("rect-clicked")
					resetRect()
				else
					rect.addClass("rect-clicked")
					rect.attr("id","#{number}")


		resetRect = ->
			$(".rect-clicked").each (index, element) ->
				number = 0
				$(element).removeAttr("id")
				$(element).removeClass('rect-clicked')
				

