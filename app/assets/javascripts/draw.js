$(document).on("turbolinks:load", function() {

    //Adds a rectangle on click within the canvas (image)
    function drawRect(event){
        $rect = $('<div class="rect resize-drag"></div>');
        $("#inner-canvas").append($rect);

        $rect.css( {position:"absolute", width: "44px", top: "300px", left: "250px"});

        var container = document.querySelector("#canvas");

        var xPosition = event.clientX - container.getBoundingClientRect().left + ($rect.innerWidth() / 2);
        var yPosition = event.clientY - container.getBoundingClientRect().top + ($rect.innerWidth() / 2);

        $rect.css( {position:"absolute", width: "44px", top:yPosition + "px", left: xPosition + "px"});
    }

    //Bind the drawing event at the beginning
    $("#canvas").bind("click", drawRect);

    //Binds the drawing event on click again in case it was "unbinded" some where
    $("#canvas").on("click", function(){
        $("#canvas").bind("click", drawRect);
    });

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
            target.textContent = Math.round(event.rect.width) + '×' + Math.round(event.rect.height);

            //Unbinds the click event on canvas while resizing to avoid double drawing
            $("#canvas").unbind("click", drawRect);
        });
});
