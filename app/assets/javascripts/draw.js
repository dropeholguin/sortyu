$(document).on("turbolinks:load", function() {

    //Adds a section on click within the canvas (image)
    function drawRect(event){
        if($(event.target).closest('#inner-canvas').length) {
            $rect = $('<div class="rect resize-drag rect-pad"></div>');
            $("#inner-canvas").append($rect);

            $rect.css( {position:"absolute", width: "44px", top: "300px", left: "250px"});

            var container = document.querySelector("#canvas");
            var screenWidth = $(window).width();
            // If mobile
            if (screenWidth <= 425 ){
                console.log('Mobile Device');
                var xPosition = event.clientX - (0 + container.getBoundingClientRect().left + ($rect.innerWidth() / 2));
                var yPosition = event.clientY - (5 + container.getBoundingClientRect().top + ($rect.innerWidth() / 2));
            }
            // If tablet
            else if(screenWidth > 425 && screenWidth <= 768){
                console.log('Tablet Device');
                var xPosition = event.clientX - (55 + container.getBoundingClientRect().left + ($rect.innerWidth() / 2));
                var yPosition = event.clientY - (10 + container.getBoundingClientRect().top + ($rect.innerWidth() / 2));
            }
            // If small computer
            else if( screenWidth > 768 && screenWidth <= 1024){
                console.log('Small Computer Device');
                var xPosition = event.clientX - (75 + container.getBoundingClientRect().left + ($rect.innerWidth() / 2));
                var yPosition = event.clientY - (5 + container.getBoundingClientRect().top + ($rect.innerWidth() / 2));
            }
            // computer and big screens
            else{
                console.log('Computer Device');
                var xPosition = event.clientX - (135 + container.getBoundingClientRect().left + ($rect.innerWidth() / 2));
                var yPosition = event.clientY - (5 + container.getBoundingClientRect().top + ($rect.innerWidth() / 2));
            }
            $rect.css( {position:"absolute", width: "44px", top:yPosition + "px", left: xPosition + "px"});
        }
    }

    //Deletes a section when canvas has "deleting" class
    function deleteRect(event){
        if($('#canvas').hasClass('deleting')){
            $rect = $(event.target);
            $rect.remove();
        }
    }

    //Bind the drawing event at the beginning [DISABLED]
    //$("#canvas").bind("click", drawRect);

    //Binds the drawing event on click again in case it was "unbinded" some where
    //Also calls deleteRect() when #canvas is in "deleting" status
    $("#canvas").on("click", function(event){
        if($('#canvas').hasClass('drawing')){
            //Avoids Sections repetition when previous one is not resized or moved.
            $("#canvas").unbind("click", drawRect);

            $("#canvas").bind("click", drawRect);
        } else if($('#canvas').hasClass('deleting')){
            $target = $(event.target);
            if($target.hasClass('rect')){
                deleteRect(event);
            }
        }
    });

    //Drawing and deleting states of canvas switcher
    $("#eraser").on("click", function(event){
        event.preventDefault();
        $("#canvas").removeClass("drawing");
        $("#canvas").addClass("deleting");
    });
    $("#pencil").on("click", function(event){
        event.preventDefault();
        $("#canvas").removeClass("deleting");
        $("#canvas").addClass("drawing");
    })

    function dragMoveListener (event) {
        var target = event.target,
        // keep the dragged position in the data-x/data-y attributes
        x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx,
        y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy;

        // translate the element
        target.style.webkitTransform =
        target.style.transform =
        'translate(' + x + 'px, ' + y + 'px)';

        // update the posiion attributes
        target.setAttribute('data-x', x);
        target.setAttribute('data-y', y);
    }

    window.dragMoveListener = dragMoveListener;

    //Implements drang, drop, resize events on the rect within the canvas
    interact('.resize-drag')
        .draggable({
            onmove: window.dragMoveListener,
            // keep the element within the area of it's parent
            restrict: {
                restriction: "parent",
                endOnly: true,
                elementRect: { top: 0, left: 0, bottom: 1, right: 1 }
            },
            onend: function () {
                //Unbinds the click event on canvas while dragging to avoid double drawing
                $("#canvas").unbind("click", drawRect);
            }
        })
        .resizable({
            preserveAspectRatio: false,
            edges: { left: true, right: true, bottom: true, top: true },
            restrict: {
                restriction: "parent",
                endOnly: true,
                elementRect: { top: 0, left: 0, bottom: 1, right: 1 }
            }
        })
        .on('resizemove', function (event) {
            var target = event.target,
            x = (parseFloat(target.getAttribute('data-x')) || 0),
            y = (parseFloat(target.getAttribute('data-y')) || 0);
            // update the element's style
            target.style.width  = event.rect.width + 'px';
            target.style.height = event.rect.height + 'px';
            // translate when resizing from top or left edges
            x += event.deltaRect.left;
            y += event.deltaRect.top;

            target.style.webkitTransform = target.style.transform = 'translate(' + x + 'px,' + y + 'px)';

            target.setAttribute('data-x', x);
            target.setAttribute('data-y', y);

            //Unbinds the click event on canvas while resizing to avoid double drawing
            $("#canvas").unbind("click", drawRect);
        });
});
