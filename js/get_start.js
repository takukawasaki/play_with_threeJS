// Generated by CoffeeScript 1.9.1
var axis, camera, canvasFrame, cube, cubes, geometry, i, initCamera, initObject, initThree, loops, material, renderer, scene, step, threeStart, y;

window.addEventListener("load", function() {
  return threeStart();
});

threeStart = function() {
  initThree();
  initCamera();
  initObject();
  loops();
};

canvasFrame = void 0;

renderer = void 0;

scene = void 0;

initThree = function() {
  canvasFrame = document.createElement('div');
  renderer = new THREE.WebGLRenderer();
  if (!renderer) {
    alert("initialize three.js");
  }
  renderer.setSize(window.innerWidth, window.innerHeight);
  document.body.appendChild(canvasFrame);
  canvasFrame.appendChild(renderer.domElement);
  renderer.setClearColor('black', 1.0);
  scene = new THREE.Scene();
};

camera = void 0;

initCamera = function() {
  camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 1, 10000);
  camera.position.set(100, 100, 100);
  camera.up.x = 1;
  camera.up.y = 0;
  camera.up.z = 1;
  camera.lookAt({
    x: rnd(100),
    y: rnd(100),
    z: rnd(100)
  });
};


/*オブジェクト定義 */

axis = void 0;

geometry = void 0;

material = void 0;

cube = void 0;

cubes = (function() {
  var j, results;
  results = [];
  for (i = j = 0; j <= 100; i = ++j) {
    results.push(0);
  }
  return results;
})();

initObject = function() {
  var index, j, len;
  geometry = new THREE.BoxGeometry(10, 10, 10);
  material = new THREE.MeshNormalMaterial();
  for (index = j = 0, len = cubes.length; j < len; index = ++j) {
    i = cubes[index];
    cubes[index] = new THREE.Mesh(geometry, material);
    scene.add(cubes[index]);
  }
};

step = 0;

y = 2;

loops = function() {
  var index, j, len;
  for (index = j = 0, len = cubes.length; j < len; index = ++j) {
    i = cubes[index];
    if (index % 2 === 0) {
      make_pos(i, rnd(4), rnd(y++), rnd(y++));
      make_rotate(i, rnd(3), rnd(4), rnd(10));
    } else {
      i.position.x = Math.floor(Math.random() * -10);
      i.position.y = Math.floor(Math.random() * -(y--));
      i.position.z = Math.floor(Math.random() * -(y--));
      i.rotation.x = Math.floor(Math.random() * -2);
      i.rotation.y = Math.floor(Math.random() * -4);
      i.rotation.z = Math.floor(Math.random() * -5);
    }
  }
  renderer.render(scene, camera);
  requestAnimationFrame(loops);
};

//# sourceMappingURL=get_start.js.map