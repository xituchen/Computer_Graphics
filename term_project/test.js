
var scene = new THREE.Scene();
var camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
var renderer = new THREE.WebGLRenderer();
renderer.setSize(window.innerWidth, window.innerHeight);
document.body.appendChild(renderer.domElement);

var geometry = new THREE.Geometry();

var dump = vert_dump;
while(dump.length > 3) {
    var a = new THREE.Vector3(dump[0], dump[1], dump[2]);
    geometry.vertices.push(a);
    dump.splice(0, 3);
}

dump = face_dump;
while(dump.length > 3) {
    var b = new THREE.Face3(dump[0], dump[1], dump[2]);
    geometry.faces.push(b);
    dump.splice(0, 3);
}

// parseVerts();
// parseFaces();

console.log(geometry.vertices);
console.log(geometry.faces);

// geometry.computeFaceNormals();

var object = new THREE.Mesh(geometry, new THREE.MeshBasicMaterial({color: 0x00ff00}));

scene.add(object);

camera.position.z = 5;
renderer.render(scene, camera);




// function parseVerts() {
//     var dump = vert_dump;
//     while(dump.length > 3) {
//         var a = new THREE.Vector3(dump[0], dump[1], dump[2]);
//         geometry.vertices.push(a);
//         dump.splice(0, 3);
//     }
// }

// function parseFaces() {
//     var dump = face_dump;
//     while(dump.length > 3) {
//         var b = new THREE.Face3(dump[0], dump[1], dump[2]);
//         geometry.faces.push(b);
//         dump.splice(0, 3);
//     }
// }

// function parseUV() {
//     var dump = uv_dump[0];
//     while(dump.length > 6) {
//         temp = [];
//         for (var i=0; i<3; i++) {
//             temp.push(new THREE.Vector2(dump[i*2], dump[i*2+1]));
//         }
//         dump.splice(0, 6);
//         uvs.push(temp);
//     }
// }


// function render(){
    // requestAnimationFrame(render);
    // cube.rotation.x += 0.1;
    // cube.rotation.y += 0.1;
//     renderer.render(scene, camera);
// }

// var geom = new THREE.Geometry(); 
// var v1 = new THREE.Vector3(0,0,0);
// var v2 = new THREE.Vector3(0,500,0);
// var v3 = new THREE.Vector3(0,500,500);

// geom.vertices.push(v1);
// geom.vertices.push(v2);
// geom.vertices.push(v3);

// geom.faces.push( new THREE.Face3( 0, 1, 2 ) );
// geom.computeFaceNormals();

// var object = new THREE.Mesh( geom, new THREE.MeshNormalMaterial() );

// object.position.z = -100;//move a bit back - size of 500 is a bit big
// object.rotation.y = -Math.PI * .5;//triangle is pointing in depth, rotate it -90 degrees on Y

// scene.add(object);

// renderer.render(scene, camera);


