followersPhotos = ->
  $('#sorty-followers').click ->  
    $.ajax '/followers_photos',
      type: 'POST',
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data) ->
        console.log data
        $.ajax 'photos/reaload_photos_queue',
          type: 'GET',
          dataType: 'script',
          data: { photos_ids: data }
          error: (jqXHR, textStatus, errorThrown) ->
            console.log("AJAX Error: #{textStatus}")
          success: (data) ->
            window.location.replace("/photos")

$(document).ready followersPhotos
$(document).on 'turbolinks:load', ->
  followersPhotos()
