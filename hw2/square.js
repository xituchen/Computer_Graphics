// Computer Graphics Homework 1 by Anli Ji, Xitu Chen

var gl;
var points;

window.onload = function init()
{
    var canvas = document.getElementById( "gl-canvas" );
    
    gl = WebGLUtils.setupWebGL( canvas );
    if ( !gl ) { alert( "WebGL isn't available" ); }

    // var whole = "";
    // var guys = whole.split(" ");
    // var i = 0;
    // while (true) {
    //     if (guys.length == 0) {
    //         break;
    //     }
        
    // }

    // we did both our first and last name initials
    var verts = [
        [
            vec3(0, 0, 0),
            vec3(0, 0.2, 0),
            vec3(0.2, 0.3, 0.1),
            vec3(0.2, 0, 0)
        ]
    ];

    //
    //  Configure WebGL
    //
    gl.viewport( 0, 0, canvas.width, canvas.height );
    gl.clearColor( 0.0, 0.0, 0.0, 1.0 );
    
    //  Load shaders and initialize attribute buffers
    var program = initShaders( gl, "vertex-shader", "fragment-shader" );
    gl.useProgram( program );
    
    gl.clear( gl.COLOR_BUFFER_BIT );
    
    for (var i=0; i<verts.length; i++) {
        // Load the data into the GPU
        var bufferId = gl.createBuffer();
        gl.bindBuffer( gl.ARRAY_BUFFER, bufferId );
        gl.bufferData( gl.ARRAY_BUFFER, flatten(verts[i]), gl.STATIC_DRAW );

        // Associate out shader variables with our data buffer

        var vPosition = gl.getAttribLocation( program, "vPosition" );
        gl.vertexAttribPointer( vPosition, 3, gl.FLOAT, false, 0, 0 );
        gl.enableVertexAttribArray( vPosition );
        
        gl.drawArrays( gl.TRIANGLE_FAN, 0, verts[i].length );
    }
};


