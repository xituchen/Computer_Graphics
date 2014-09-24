// Computer Graphics Homework 3 by Anli Ji, Xitu Chen

var gl;
var canvas;

var vertexes = [];
var colors = [];

window.onload = function init()
{
    // 4 initial points
    var v1 = vec3(-0.8, -0.8, 0.8);
    var v3 = vec3(0,-0.4, -0.8);
    var v2 = vec3(0.8, -0.8, 0.8);
    var v4 = vec3(0, 0.6, 0.2);

    splitting(v1, v2, v3, v4, 5);

    // initializing canvas
    canvas = document.getElementById( "gl-canvas" );
    
    gl = WebGLUtils.setupWebGL( canvas );
    if ( !gl ) { alert( "WebGL isn't available" ); }

    //  Configure WebGL
    gl.viewport( 0, 0, canvas.width, canvas.height );
    gl.enable(gl.DEPTH_TEST);
    gl.clearColor( 1.0, 1.0, 1.0, 1.0 );
    
    //  Load shaders and initialize attribute buffers
    var program = initShaders( gl, "vertex-shader", "fragment-shader" );
    gl.useProgram( program );
    
    gl.clear( gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

    // Load the data into the GPU
    var cBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, cBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(colors), gl.STATIC_DRAW);
    
    // Associate out shader variables with our data buffer
    var vColor = gl.getAttribLocation(program, "vColor");
    gl.vertexAttribPointer(vColor, 3, gl.FLOAT, false, 0, 0);
    gl.enableVertexAttribArray(vColor);

    var bufferId = gl.createBuffer();
    gl.bindBuffer( gl.ARRAY_BUFFER, bufferId );
    gl.bufferData( gl.ARRAY_BUFFER, flatten(vertexes), gl.STATIC_DRAW );

    var vPosition = gl.getAttribLocation( program, "vPosition" );
    gl.vertexAttribPointer( vPosition, 3, gl.FLOAT, false, 0, 0 );
    gl.enableVertexAttribArray( vPosition );
    
    gl.drawArrays( gl.TRIANGLES, 0, vertexes.length );
};


// takes in a tetrahedron a,b,c,d
// pushes the verts to draw this tetrahedron [a,b,c],[a,b,d],[a,c,d],[b,c,d]
function tetrahedronToTrangle(a, b, c, d){
    var baseColors = [
        vec3(0.5, 0.0, 0.8),
        vec3(0.9, 0.85, 0.0),
        vec3(0.1, 0.7, 0.4),
        vec3(0.8, 0.1, 0.4)
    ];
    
    vertexes.push(a);
    colors.push(baseColors[0]);
    vertexes.push(b);
    colors.push(baseColors[0]);
    vertexes.push(c);
    colors.push(baseColors[0]);
    vertexes.push(a);
    colors.push(baseColors[1]);
    vertexes.push(b);
    colors.push(baseColors[1]);
    vertexes.push(d);
    colors.push(baseColors[1]);
    vertexes.push(a);
    colors.push(baseColors[2]);
    vertexes.push(c);
    colors.push(baseColors[2]);
    vertexes.push(d);
    colors.push(baseColors[2]);
    vertexes.push(b);
    colors.push(baseColors[3]);
    vertexes.push(c);
    colors.push(baseColors[3]);
    vertexes.push(d);
    colors.push(baseColors[3]);
}

// adds a random percentage deviation to each number passed in and returns a vec3
function perturb(x, y, z){
    var noise = Math.floor((Math.random() * 11)) - 5;
    x1 = x * (1+(noise/100));
    noise = Math.floor((Math.random() * 11)) - 5;
    y1 = y * (1+(noise/100));
    noise = Math.floor((Math.random() * 11)) - 5;
    z1 = z * (1+(noise/100));

    return vec3(x1, y1, z1);
}


// splits a tetrahedron specified by a, b, c, d recursively for times number of times
function splitting(a, b, c, d, times){
    if (times === 0) {
        tetrahedronToTrangle(a, b, c, d);
        return;
    }
    var one_two = mix(a, b, 0.5);
    var one_three = mix(a, c, 0.5);
    var one_four = mix(a, d, 0.5);
    var two_three = mix(b, c, 0.5);
    var two_four = mix(b, d, 0.5);
    var three_four = mix(c, d, 0.5);

    one_two = perturb(one_two[0], one_two[1], one_two[2]);
    one_three = perturb(one_three[0], one_three[1], one_three[2]);
    one_four = perturb(one_four[0], one_four[1], one_four[2]);
    two_three = perturb(two_three[0], two_three[1], two_three[2]);
    two_four = perturb(two_four[0], two_four[1], two_four[2]);
    three_four = perturb(three_four[0], three_four[1], three_four[2]);

    times = times - 1;

    splitting(a, one_two, one_three, one_four, times);
    splitting(one_two, b, two_three, two_four, times);
    splitting(one_three, two_three, c, three_four, times);
    splitting(one_four, two_four, three_four, d, times);
}

