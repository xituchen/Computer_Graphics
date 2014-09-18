// Computer Graphics Homework 3 by Anli Ji, Xitu Chen
var gl;
var points;

var vertexes = [];
var colors = [];


// takes in a tetrahedron [a,b,c,d]
// return the verts to draw this tetrahedron [[a,b,c],[a,b,d],[a,c,d],[b,c,d]]
function tetrahedronToTrangle(a, b, c, d){
    var baseColors = [
        vec4(1.0, 0.0, 0.0),
        vec4(1.0, 0.0, 0.0),
        vec4(1.0, 0.0, 0.0),
        vec4(1.0, 0.0, 0.0)
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

// draw the verts that would eventually forms the final shape
function draw(){
    // console.log(colors);
    var canvas = document.getElementById( "gl-canvas" );
    
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

    var bufferId = gl.createBuffer();
    gl.bindBuffer( gl.ARRAY_BUFFER, bufferId );
    gl.bufferData( gl.ARRAY_BUFFER, flatten(vertexes), gl.STATIC_DRAW );

    // Associate out shader variables with our data buffer
    var vColor = gl.getAttribLocation(program, "vColor");
    gl.vertexAttribPointer(vColor, 3, gl.FLOAT, false, 0, 0);
    gl.enableVertexAttribArray(vColor);

    var vPosition = gl.getAttribLocation( program, "vPosition" );
    gl.vertexAttribPointer( vPosition, 3, gl.FLOAT, false, 0, 0 );
    gl.enableVertexAttribArray( vPosition );
    
    gl.drawArrays( gl.TRIANGLES, 0, vertexes.length );
}

function perturb(x, y, z){
    var noise = Math.floor((Math.random() * 11)) - 7;
    x1 = x * (1+(noise/100));
    noise = Math.floor((Math.random() * 11)) - 7;
    y1 = y * (1+(noise/100));
    noise = Math.floor((Math.random() * 11)) - 7;
    z1 = z * (1+(noise/100));

    return vec3(x1, y1, z1);
}

// function halve(v1,v2){
//     var halved = vec3(perturb((v1[0]+v2[0])/2),perturb((v1[1]+v2[1])/2),perturb((v1[2]+v2[2])/2));
//     return halved;
// }


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


window.onload = function init()
{
    // 3 initial points
    var v1 = vec3(-0.8,-0.6,-0.8);
    var v2 = vec3(0.8,-0.6,-0.8);
    var v3 = vec3(0,-0.8,0.6);
    var v4 = vec3(0,0.6, 0.2);

    splitting(v1, v2, v3, v4, 5);
    console.log(vertexes);
    draw();
};


