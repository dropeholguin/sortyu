window.LocalTracker ?= {}	

window.LocalTracker.performTracking = ->
	#Creates the tracker if finds the id
	if $('#photo-edit-section').length > 0
		number = 0
		$img = $('#edit-my-sections')
		tracker = new tracking.ObjectTracker(['face'])
		tracker.setStepSize(1.7)
		tracking.track('#edit-my-sections', tracker)
		
		tracker.on 'track', (event) ->
			for rect in event.data
				plotRectangle(rect.x, rect.y, rect.width, rect.height)
			createSection(event.data.length)
			resetRect()

		#Draws a rectangle
		plotRectangle = (x, y, w, h) ->
			$rect = $('<div></div>')
			$('#photo-editor').append($rect)
			$rect.addClass('rect resize-drag')
			$rect.css("width", "#{w}px")
			$rect.css("height", "#{h}px")
			imgOffset = $img.offset()
			$rect.css("left","#{(imgOffset.left + x)}px")
			$rect.css("top","#{(imgOffset.top + y)}px")

			# updateRect($rect)


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

		#If a clicked rectangle gets click, resets all rectangles
		resetRect = ->
			if not isSortingDone()
				$(".rect-clicked").each (index, element) ->
					number = 0
					$(element).removeAttr("id")
					$(element).removeClass('magictime puffIn rect-clicked')
					$('.rect span').remove()

		# Method to create a section in the database for a trackerJs rectangle
		createSection = (rectangles) ->
			photoId = $('#next-sort').data('photo_id')
			$.ajax 'photos/create_sections',
			type: 'POST',
			dataType: 'script',
			data: {
				photo_id: photoId, rectangles: rectangles
			},
			error: (jqXHR, textStatus, errorThrown) ->
				console.log("AJAX Error: #{textStatus}")
			success: (data, textStatus, jqXHR) ->
				console.log("Photo sections created successfully!")

		#checks if all rectangles are clicked
		isSortingDone = ->
			if $(".rect-clicked").length == $(".rect").length
				return true
			else
				return false
				