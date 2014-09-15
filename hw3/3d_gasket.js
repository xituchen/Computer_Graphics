// Computer Graphics Homework 3 by Anli Ji, Xitu Chen

var baseColors = [
    vec4(1.0, 1.0, 0.0,1),
    vec4(0.0, 1.0, 1.0,1),
    vec4(0.0, 0.0, 1.0,1),
    vec4(1.0, 1.0, 0,1)
];

var colors = [];


// takes in a tetrahedron [a,b,c,d]
// return the verts to draw this tetrahedron [[a,b,c],[a,b,d],[a,c,d],[b,c,d]]
function tentrahedronToTrangle(tentrahedrons){
    verts = [];
    for (var i = 0; i<tentrahedrons.length; i++){
        verts.push([tentrahedrons[i][0],tentrahedrons[i][1],tentrahedrons[i][2]]);
        verts.push([tentrahedrons[i][0],tentrahedrons[i][1],tentrahedrons[i][3]]);
        verts.push([tentrahedrons[i][0],tentrahedrons[i][2],tentrahedrons[i][3]]);
        verts.push([tentrahedrons[i][1],tentrahedrons[i][2],tentrahedrons[i][3]]);
        for (var j=0; j<4; j++) {
            colors.push([baseColors[j],baseColors[j],baseColors[j]]);
        }
    }
    return verts;
}

// draw the verts that would eventually forms the final shape
function draw(verts){
    console.log(colors);
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

    for (var i=0; i<verts.length; i++) {
        // Load the data into the GPU
        var cBuffer = gl.createBuffer();
        gl.bindBuffer(gl.ARRAY_BUFFER, cBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, flatten(colors[i]), gl.STATIC_DRAW);

        var bufferId = gl.createBuffer();
        gl.bindBuffer( gl.ARRAY_BUFFER, bufferId );
        gl.bufferData( gl.ARRAY_BUFFER, flatten(verts[i]), gl.STATIC_DRAW );

        // Associate out shader variables with our data buffer
        var vColor = gl.getAttribLocation(program, "vColor");
        gl.vertexAttribPointer(vColor, 3, gl.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(vColor);

        var vPosition = gl.getAttribLocation( program, "vPosition" );
        gl.vertexAttribPointer( vPosition, 3, gl.FLOAT, false, 0, 0 );
        gl.enableVertexAttribArray( vPosition );
        
        gl.drawArrays( gl.TRIANGLE_FAN, 0, verts[i].length );
    }
}

function perturb(number){
    var noise = Math.floor((Math.random() * 21)) - 10;
    return number * (1 + noise/100);
}

function halve(v1,v2){
    var halved = vec3(perturb((v1[0]+v2[0])/2),perturb((v1[1]+v2[1])/2),perturb((v1[2]+v2[2])/2));
    return halved;
}


function splitting(tentrahedrons){
    var splitted = [];
    for (var i = 0; i < tentrahedrons.length; i++){
        splitted.push([tentrahedrons[i][0],halve(tentrahedrons[i][0],tentrahedrons[i][1]),halve(tentrahedrons[i][0],tentrahedrons[i][2]),halve(tentrahedrons[i][0],tentrahedrons[i][3])]);
        splitted.push([halve(tentrahedrons[i][1],tentrahedrons[i][0]),tentrahedrons[i][1],halve(tentrahedrons[i][1],tentrahedrons[i][2]),halve(tentrahedrons[i][1],tentrahedrons[i][3])]);
        splitted.push([halve(tentrahedrons[i][2],tentrahedrons[i][0]),halve(tentrahedrons[i][2],tentrahedrons[i][1]),tentrahedrons[i][2],halve(tentrahedrons[i][2],tentrahedrons[i][3])]);
        splitted.push([halve(tentrahedrons[i][3],tentrahedrons[i][0]),halve(tentrahedrons[i][3],tentrahedrons[i][1]),halve(tentrahedrons[i][3],tentrahedrons[i][2]),tentrahedrons[i][3]]);
    }
    return splitted;
}

var gl;
var points;

window.onload = function init()
{
    // 3 initial points
    var v1 = vec3(-0.8,-0.6,-0.8);
    var v2 = vec3(0.8,-0.6,-0.8);
    var v3 = vec3(0,-0.8,0.6);
    var v4 = vec3(0,0.6, 0.2);
    verts = [[v1,v2,v3,v4]];

    draw(tentrahedronToTrangle(splitting(splitting(splitting(splitting(splitting(verts)))))));
};


