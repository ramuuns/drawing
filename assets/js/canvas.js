
export function Canvas(id, sendCallback, colors, clear) {
    const canvas = document.getElementById(id);
    const ctx = canvas.getContext("2d");
    const w = canvas.width;
    const h = canvas.height;

    let color = "black";
    let strokeWidth = 2;
    let prevX = 0;
    let prevY = 0;
    let currX = 0;
    let currY = 0;
    let is_drawing = false;

    const sendImage = function() {
        var dataURL = canvas.toDataURL();
        sendCallback(dataURL);
    }

    const draw = function() {
        ctx.beginPath();
        ctx.moveTo(prevX, prevY);
        ctx.lineTo(currX, currY);
        ctx.strokeStyle = color;
        ctx.lineWidth = strokeWidth;
        ctx.stroke();
        ctx.closePath();
        sendImage();
    }

    const handleMove = function(e) {
        if (is_drawing) {
            prevX = currX;
            prevY = currY;
            currX = e.clientX - canvas.offsetLeft;
            currY = e.clientY + window.scrollY - canvas.offsetTop;
            draw();
        }
    }

    const handleDown = function(e) {
        /*prevX = currX;
        prevY = currY;*/
        currX = e.clientX - canvas.offsetLeft;
        currY = e.clientY + window.scrollY - canvas.offsetTop;
    
        is_drawing = true;
        ctx.beginPath();
        ctx.fillStyle = color;
        ctx.fillRect(currX, currY, 2, 2); //maybe not?
        ctx.closePath();
    }

    const handleUp = function(e) { is_drawing = false; }
    const handleOut = function(e) { is_drawing = false; }

    canvas.addEventListener("mousemove", handleMove);
    canvas.addEventListener("mousedown", handleDown);
    canvas.addEventListener("mouseup", handleUp);
    canvas.addEventListener("mouseout", handleOut);

    window.addEventListener("phx:client-image", function(e) {
        const image = e.detail.image
        if (image && image != "null") {
            var img = new Image();
            img.onload = function() {
                ctx.drawImage(img, 0, 0);
            };

            img.src = image;
        }
    });

    document.getElementById(clear).onclick = function() {
        ctx.clearRect(0, 0, w, h);
        sendImage();
    }

    Array.from(document.getElementById(colors).getElementsByTagName("button")).map((el) => el.onclick = function() {
        document.getElementById(colors).getElementsByClassName("selected")[0].className = "pick-color";
        this.className = "pick-color selected";
        color = this.dataset.color;
    });

}