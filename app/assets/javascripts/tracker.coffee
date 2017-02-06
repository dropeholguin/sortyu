window.LocalTracker ?= {}

window.LocalTracker.performTracking = ->
	if $('#sorting-principal').length > 0
		$img = $('#trackme')
		tracker = new tracking.ObjectTracker(['face'])
		tracker.setStepSize(1.7)
		tracking.track('#trackme', tracker)
		
		tracker.on 'track', (event) ->
			console.log('inside the tracker')
			for rect in event.data
				console.log rect
				plotRectangle(rect.x, rect.y, rect.width, rect.height)

		plotRectangle = (x, y, w, h) ->
			$rect = $('<div></div>')
			$('#photo-container').append($rect)
			$rect.addClass('rect')
			$rect.css("width", "#{w}px")
			$rect.css("height", "#{h}px")
			console.log('this was executed correctly')
			imgOffset = $img.offset()
			console.log imgOffset
			$rect.css("left","#{(imgOffset.left + x)}px")
			$rect.css("top","#{(imgOffset.top + y)}px")
			
