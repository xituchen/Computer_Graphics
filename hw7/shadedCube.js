

var canvas;
var gl;

var numVertices  = 36;

var pointsArray = [];
var normalsArray = [];

var vertices = [
        vec4( -0.5, -0.5,  0.5, 1.0 ),
        vec4( -0.5,  0.5,  0.5, 1.0 ),
        vec4( 0.5,  0.5,  0.5, 1.0 ),
        vec4( 0.5, -0.5,  0.5, 1.0 ),
        vec4( -0.5, -0.5, -0.5, 1.0 ),
        vec4( -0.5,  0.5, -0.5, 1.0 ),
        vec4( 0.5,  0.5, -0.5, 1.0 ),
        vec4( 0.5, -0.5, -0.5, 1.0 )
    ];

var redLightPosition = vec4(1.0, -1.0, 1.0, 0.0 );
var redLightAmbient = vec4(0.2, 0.0, 0.0, 1.0 );
var redLightDiffuse = vec4( 1.0, 0.0, 0.0, 1.0 );
var redLightSpecular = vec4( 1.0, 0.0, 0.0, 1.0 );

var greenLightPosition = vec4(-1.0, 1.0, 1.0, 0.0 );
var greenLightAmbient = vec4(0.0, 0.2, 0.0, 1.0 );
var greenLightDiffuse = vec4( 0.0, 1.0, 0.0, 1.0 );
var greenLightSpecular = vec4( 0.0, 1.0, 0.0, 1.0 );

var materialAmbient = vec4( 1.0, 0.0, 1.0, 1.0 );
var materialDiffuse = vec4( 1.0, 0.8, 0.0, 1.0);
var materialSpecular = vec4( 1.0, 0.8, 0.0, 1.0 );
var materialShininess = 100.0;

var ctm;
var ambientColor, diffuseColor, specularColor;
var modelView, projection;
var viewerPos;
var program;

var xAxis = 0;
var yAxis = 1;
var zAxis = 2;
var cubeAxis = 0;
var redLightAxis = 0;
var greenLightAxis = 0;
var theta =[0, 0, 0];

var thetaLoc;

var cubeFlag = true;
var redLightFlag = true;
var greenLightFlag = true;

function quad(a, b, c, d) {

     var t1 = subtract(vertices[b], vertices[a]);
     var t2 = subtract(vertices[c], vertices[b]);
     var normal = cross(t1, t2);
     var normal = vec3(normal);
     normal = normalize(normal);

     pointsArray.push(vertices[a]); 
     normalsArray.push(normal); 
     pointsArray.push(vertices[b]); 
     normalsArray.push(normal); 
     pointsArray.push(vertices[c]); 
     normalsArray.push(normal);   
     pointsArray.push(vertices[a]);  
     normalsArray.push(normal); 
     pointsArray.push(vertices[c]); 
     normalsArray.push(normal); 
     pointsArray.push(vertices[d]); 
     normalsArray.push(normal);    
}


function colorCube()
{
    quad( 1, 0, 3, 2 );
    quad( 2, 3, 7, 6 );
    quad( 3, 0, 4, 7 );
    quad( 6, 5, 1, 2 );
    quad( 4, 5, 6, 7 );
    quad( 5, 4, 0, 1 );
}


window.onload = function init() {
    canvas = document.getElementById( "gl-canvas" );
    
    gl = WebGLUtils.setupWebGL( canvas );
    if ( !gl ) { alert( "WebGL isn't available" ); }

    gl.viewport( 0, 0, canvas.width, canvas.height );
    gl.clearColor( 1.0, 1.0, 1.0, 1.0 );
    
    gl.enable(gl.DEPTH_TEST);

    //
    //  Load shaders and initialize attribute buffers
    //
    program = initShaders( gl, "vertex-shader", "fragment-shader" );
    gl.useProgram( program );
    
    colorCube();

    var nBuffer = gl.createBuffer();
    gl.bindBuffer( gl.ARRAY_BUFFER, nBuffer );
    gl.bufferData( gl.ARRAY_BUFFER, flatten(normalsArray), gl.STATIC_DRAW );
    
    var vNormal = gl.getAttribLocation( program, "vNormal" );
    gl.vertexAttribPointer( vNormal, 3, gl.FLOAT, false, 0, 0 );
    gl.enableVertexAttribArray( vNormal );

    var vBuffer = gl.createBuffer();
    gl.bindBuffer( gl.ARRAY_BUFFER, vBuffer );
    gl.bufferData( gl.ARRAY_BUFFER, flatten(pointsArray), gl.STATIC_DRAW );
    
    var vPosition = gl.getAttribLocation(program, "vPosition");
    gl.vertexAttribPointer(vPosition, 4, gl.FLOAT, false, 0, 0);
    gl.enableVertexAttribArray(vPosition);

    thetaLoc = gl.getUniformLocation(program, "theta"); 
    
    viewerPos = vec3(0.0, 0.0, -20.0 );

    projection = ortho(-1, 1, -1, 1, -100, 100);
    
    redAmbientProduct = mult(redLightAmbient, materialAmbient);
    redDiffuseProduct = mult(redLightDiffuse, materialDiffuse);
    redSpecularProduct = mult(redLightSpecular, materialSpecular);

    greenAmbientProduct = mult(greenLightAmbient,materialAmbient);
    greenDiffuseProduct = mult(greenLightDiffuse,materialDiffuse);
    greenSpecularProduct = mult(greenLightSpecular,materialSpecular);

    document.getElementById("ButtonCubeX").onclick = function(){cubeAxis = xAxis;};
    document.getElementById("ButtonCubeY").onclick = function(){cubeAxis = yAxis;};
    document.getElementById("ButtonCubeZ").onclick = function(){cubeAxis = zAxis;};
    document.getElementById("ButtonCubeT").onclick = function(){cubeFlag = !cubeFlag;};

    document.getElementById("slideGreenAmbientLighting").onchange =
        function() {
            var newAmbient = parseInt(document.getElementById("slideGreenAmbientLighting").value)
            greenLightAmbient = vec4( 0.0, newAmbient/500, 0.0, 1.0 );
            greenAmbientProduct = mult(greenLightAmbient,materialAmbient);
            gl.uniform4fv(gl.getUniformLocation(program, "greenAmbientProduct"),
               flatten(greenAmbientProduct));
        }

    document.getElementById("slideGreenDiffuseLighting").onchange =
        function() {
            var newDiffuse = parseInt(document.getElementById("slideGreenDiffuseLighting").value)
            greenLightDiffuse = vec4( 0.0, newDiffuse/100, 0.0, 1.0 );
            greenDiffuseProduct = mult(greenLightDiffuse,materialDiffuse);
            gl.uniform4fv(gl.getUniformLocation(program, "greenDiffuseProduct"),
               flatten(greenDiffuseProduct) );
        }

    document.getElementById("slideRedAmbientLighting").onchange =
        function() {
            var newAmbient = parseInt(document.getElementById("slideRedAmbientLighting").value)
            redLightAmbient = vec4( newAmbient/500,0.0, 0.0, 1.0 );
            redAmbientProduct = mult(redLightAmbient,materialAmbient);
            gl.uniform4fv(gl.getUniformLocation(program, "redAmbientProduct"),
               flatten(redAmbientProduct));
        }

    document.getElementById("slideRedDiffuseLighting").onchange =
        function() {
            var newDiffuse = parseInt(document.getElementById("slideRedDiffuseLighting").value)
            redLightDiffuse = vec4( newDiffuse/100,0.0, 0.0, 1.0 );
            redDiffuseProduct = mult(redLightDiffuse,materialDiffuse);
            gl.uniform4fv(gl.getUniformLocation(program, redDiffuseProduct),
               flatten(redDiffuseProduct) );
        }

    document.getElementById("lightPosition").onchange =
        function() {
            var newPosition = parseFloat(document.getElementById("lightPosition").value)
            redLightPosition = vec4(newPosition, -newPosition, 1.0, 0.0 );
            greenLightPosition = vec4(-newPosition, newPosition, 1.0, 0.0 );
            gl.uniform4fv(gl.getUniformLocation(program, redLightPosition),
               flatten(redLightPosition));
            gl.uniform4fv(gl.getUniformLocation(program, greenLightPosition),
               flatten(greenLightPosition));
            console.log(redLightPosition);
            console.log(greenLightPosition);
        }   

    gl.uniform4fv(gl.getUniformLocation(program, "redAmbientProduct"),
       flatten(redAmbientProduct));
    gl.uniform4fv(gl.getUniformLocation(program, "redDiffuseProduct"),
       flatten(redDiffuseProduct) );
    gl.uniform4fv(gl.getUniformLocation(program, "redSpecularProduct"), 
       flatten(redSpecularProduct) );	
    gl.uniform4fv(gl.getUniformLocation(program, "redLightPosition"), 
       flatten(redLightPosition) );

    gl.uniform4fv(gl.getUniformLocation(program, "greenAmbientProduct"),
       flatten(greenAmbientProduct));
    gl.uniform4fv(gl.getUniformLocation(program, "greenDiffuseProduct"),
       flatten(greenDiffuseProduct) );
    gl.uniform4fv(gl.getUniformLocation(program, "greenSpecularProduct"), 
       flatten(greenSpecularProduct) );   
    gl.uniform4fv(gl.getUniformLocation(program, "greenLightPosition"), 
       flatten(greenLightPosition) );
       
    gl.uniform1f(gl.getUniformLocation(program, 
       "shininess"),materialShininess);
    
    gl.uniformMatrix4fv( gl.getUniformLocation(program, "projectionMatrix"),
       false, flatten(projection));

    render();
}

var render = function(){
            
    gl.clear( gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

    if(cubeFlag) theta[cubeAxis] += 2.0;

    modelView = mat4();
    modelView = mult(modelView, rotate(theta[xAxis], [1, 0, 0] ));
    modelView = mult(modelView, rotate(theta[yAxis], [0, 1, 0] ));
    modelView = mult(modelView, rotate(theta[zAxis], [0, 0, 1] ));

    gl.uniformMatrix4fv( gl.getUniformLocation(program,
            "modelViewMatrix"), false, flatten(modelView) );

    gl.drawArrays( gl.TRIANGLES, 0, numVertices );



    requestAnimFrame(render);
}
