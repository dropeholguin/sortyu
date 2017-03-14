save_sections = ->
	if $('#photo-edit-section').length > 0
		$('.notice').fadeOut()
		$('#save-sections').on 'click', ->
			$('.notice').fadeIn('slow')
			$('.notice').append('Sections have been saved')

			setTimeout (->
				$('.notice').fadeOut()
				setTimeout (->
					$('.notice').html('')
				), 1000
			), 2000

$(document).on 'turbolinks:load', ->
	save_sections()
