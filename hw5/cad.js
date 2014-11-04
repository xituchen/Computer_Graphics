// Computer Graphics Homework 5 by Anli Ji and Xitu Chen

var canvas;
var gl;

var maxNumVertices  = 200;
var index = 0;

var componentR = 0.0
var componentG = 0.0
var componentB = 0.0
var sliderColor = vec4(0.0,0.0,0.0,1.0)

var t;
var numPolygons = 0;
var numIndices = [];
numIndices[0] = 0;
var start = [0];

function componentToHex(c) {
    var hex = c.toString(16);
    return hex.length == 1 ? "0" + hex : hex;
}

function rgbToHex(r, g, b) {
    return "#" + componentToHex(r) + componentToHex(g) + componentToHex(b);
}

window.onload = function init() {
    canvas = document.getElementById( "gl-canvas" );
    
    gl = WebGLUtils.setupWebGL( canvas );
    if ( !gl ) { alert( "WebGL isn't available" ); }

    var slide_r = document.getElementById("slideR").onchange =
        function() {
            componentR = parseInt(document.getElementById("slideR").value)
            sliderColor = vec4(componentR/255,componentG/255,componentB/255,1.0)
            console.log(sliderColor)
            document.getElementById("colorSample").style.backgroundColor = rgbToHex(componentR,componentG,componentB)            
        }

    var slide_g = document.getElementById("slideG").onchange =
        function() {
            componentG = parseInt(document.getElementById("slideG").value)
            sliderColor = vec4(componentR/255,componentG/255,componentB/255,1.0)
            console.log(sliderColor)
            document.getElementById("colorSample").style.backgroundColor = rgbToHex(componentR,componentG,componentB)

        }

    var slide_b = document.getElementById("slideB").onchange =
        function() {
            componentB = parseInt(document.getElementById("slideB").value)
            sliderColor = vec4(componentR/255,componentG/255,componentB/255,1.0)
            console.log(sliderColor)
            document.getElementById("colorSample").style.backgroundColor = rgbToHex(componentR,componentG,componentB)
        }
        
    var a = document.getElementById("Button1")
    a.addEventListener("click", function(){
        numPolygons++;
        numIndices[numPolygons] = 0;
        start[numPolygons] = index;
        render();
    });

    var b = document.getElementById("Button2")
    b.addEventListener("click", function(){
        // location.reload();
        index = 0;
        numPolygons = 0;
        numIndices = [];
        numIndices[0] = 0;
        start = [0];

        gl.clear(gl.FRAMEBUFFER);
        render();
    });

    canvas.addEventListener("mousedown", function(){
        t  = vec2(2*event.clientX/canvas.width-1, 
           2*(canvas.height-event.clientY)/canvas.height-1);
        gl.bindBuffer( gl.ARRAY_BUFFER, bufferId );
        gl.bufferSubData(gl.ARRAY_BUFFER, 8*index, flatten(t));

        t = vec4(sliderColor);
        
        gl.bindBuffer( gl.ARRAY_BUFFER, cBufferId );
        gl.bufferSubData(gl.ARRAY_BUFFER, 16*index, flatten(t));

        numIndices[numPolygons]++;
        index++;
    } );


    gl.viewport( 0, 0, canvas.width, canvas.height );
    gl.clearColor( 0.8, 0.8, 0.8, 1.0 );
    gl.clear( gl.COLOR_BUFFER_BIT );


    //
    //  Load shaders and initialize attribute buffers
    //
    var program = initShaders( gl, "vertex-shader", "fragment-shader" );
    gl.useProgram( program );
    
    var bufferId = gl.createBuffer();
    gl.bindBuffer( gl.ARRAY_BUFFER, bufferId );
    gl.bufferData( gl.ARRAY_BUFFER, 8*maxNumVertices, gl.STATIC_DRAW );
    var vPos = gl.getAttribLocation( program, "vPosition" );
    gl.vertexAttribPointer( vPos, 2, gl.FLOAT, false, 0, 0 );
    gl.enableVertexAttribArray( vPos );
    
    var cBufferId = gl.createBuffer();
    gl.bindBuffer( gl.ARRAY_BUFFER, cBufferId );
    gl.bufferData( gl.ARRAY_BUFFER, 16*maxNumVertices, gl.STATIC_DRAW );
    var vColor = gl.getAttribLocation( program, "vColor" );
    gl.vertexAttribPointer( vColor, 4, gl.FLOAT, false, 0, 0 );
    gl.enableVertexAttribArray( vColor );
}

function render() {
    
    gl.clear( gl.COLOR_BUFFER_BIT );

    for(var i=0; i<numPolygons; i++) {
        gl.drawArrays( gl.TRIANGLE_FAN, start[i], numIndices[i] );
    }
}