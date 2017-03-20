window.LocalTracker ?= {}	

window.LocalTracker.performTracking = ->
	#Runs the tracker when an image sections are edited for the first time
	if $('#photo-edit-section').length > 0
		$img = $('#edit-my-sections')
		tracker = new tracking.ObjectTracker(['face'])
		tracker.setStepSize(1.7)
		tracking.track('#edit-my-sections', tracker)
		
		tracker.on 'track', (event) ->
			for rect in event.data
				plotRectangle(rect.x, rect.y, rect.width, rect.height)
			resetRect()

		#Draws a rectangle
		plotRectangle = (x, y, w, h) ->
			$rect = $('<div class=""></div>')
			$('#inner-canvas').append($rect)
			$rect.addClass('rect resize-drag')
			$rect.css("width", "#{w}px")
			$rect.css("height", "#{h}px")
			imgOffset = $img.offset()
			$rect.css("left","#{x}px")
			$rect.css("top","#{y}px")


		# Method to create a section in the database for a trackerJs rectangle
		createSection = (rectangles) ->
			photoId = $('#next-sort').data('photo_id')
			$.ajax '/photos/create_sections',
			type: 'POST',
			dataType: 'script',
			data: {
				photo_id: photoId, rectangles: rectangles
			},
			error: (jqXHR, textStatus, errorThrown) ->
				console.log("AJAX Error: #{textStatus}")
			success: (data, textStatus, jqXHR) ->
				console.log("Photo sections created successfully!")
				