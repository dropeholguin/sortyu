searchPhotos = ->
	$('#idForm').submit (e) ->
		e.preventDefault()
		$.ajax
			type: 'GET'
			url: '/photos/reaload_photos_queue'
			data: $('#idForm').serialize()
			success: (data) ->
				photoIds = readCookie('photos_queue').split("-")
				if photoIds[0] == ""
					window.location.replace("/search_photos")
				else
					window.location.replace("/photos")

$(document).on 'turbolinks:load', ->
  searchPhotos()

