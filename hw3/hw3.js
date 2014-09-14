// Computer Graphics Homework 3 by Anli Ji, Xitu Chen

var gl;
var points;

window.onload = function init()
{
    var canvas = document.getElementById( "gl-canvas" );
    
    gl = WebGLUtils.setupWebGL( canvas );
    if ( !gl ) { alert( "WebGL isn't available" ); }

    // 3 initial points
    var v1 = vec3(-0.5,-0.8,0);
    var v2 = vec3(0.8,0.7,0);
    var v3 = vec3(-0.4,0.6,0);
    var p = vec3(0.4,0.5,0)
    var q = vec3();

    var verts = [[v1,v2,v3]];
    var points = [[p]];

    for(var i=0;i<30000;i++){
        var randomPoint = Math.floor((Math.random() * 3) + 1);
        if (randomPoint == 1){
            q = vec3((v1[0]+p[0])/2,(v1[1]+p[1])/2,(v1[2]+p[2])/2)
        }
        else if (randomPoint == 2){
            q = vec3((v2[0]+p[0])/2,(v2[1]+p[1])/2,(v2[2]+p[2])/2)
        }
        else{
            q = vec3((v3[0]+p[0])/2,(v3[1]+p[1])/2,(v3[2]+p[2])/2)
        }
        points.push([q]);
        p = q;
    }

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
        
        gl.drawArrays( gl.LINE_LOOP, 0, verts[i].length );
    }

    for (var i=0; i<points.length; i++) {
        // Load the data into the GPU
        var bufferId = gl.createBuffer();
        gl.bindBuffer( gl.ARRAY_BUFFER, bufferId );
        gl.bufferData( gl.ARRAY_BUFFER, flatten(points[i]), gl.STATIC_DRAW );

        // Associate out shader variables with our data buffer

        var vPosition = gl.getAttribLocation( program, "vPosition" );
        gl.vertexAttribPointer( vPosition, 3, gl.FLOAT, false, 0, 0 );
        gl.enableVertexAttribArray( vPosition );
        
        gl.drawArrays( gl.POINTS, 0 ,points[i].length);
    }
};


