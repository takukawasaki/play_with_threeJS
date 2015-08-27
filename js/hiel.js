// Generated by CoffeeScript 1.9.1
var Geometry, animate, camera, container, init, initCamera, initObject, initStats, mouseX, mouseY, onDocumentMouseMove, onWindowResize, render, renderer, root, scene, start, stats, step, windowHalfX, windowHalfY;

container = void 0;

stats = void 0;

camera = void 0;

scene = void 0;

renderer = void 0;

Geometry = void 0;

root = void 0;

mouseX = 0;

mouseY = 0;

windowHalfX = window.innerWidth / 2;

windowHalfY = window.innerHeight / 2;

init = function() {
  var info;
  container = document.createElement('div');
  document.body.appendChild(container);
  info = document.createElement('div');
  info.style.position = 'absolute';
  info.style.top = '30px';
  info.style.width = '100%';
  info.style.textAlign = 'right';
  info.innerHTML = 'Drag to change move';
  container.appendChild(info);
  scene = new THREE.Scene();
  renderer = new THREE.WebGLRenderer();
  renderer.setClearColor('#191970');
  renderer.setPixelRatio(window.devicePixelRatio);
  renderer.setSize(window.innerWidth, window.innerHeight);
  renderer.sortObjects = false;
  container.appendChild(renderer.domElement);
};

initCamera = function() {
  camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 1, 15000);
};

step = 0;

initObject = function() {
  var _, amount, geometry, i, j, k, l, m, material, n, object, parent;
  geometry = new THREE.BoxGeometry(1, 1, 1000000);
  material = new THREE.MeshNormalMaterial();
  root = new THREE.Mesh(geometry, material);
  root.position.x = 100;
  root.position.y = 100;
  root.position.z = 100;
  scene.add(root);
  amount = 2000;
  object = void 0;
  parent = root;
  for (i = j = 0; j < 2000; i = ++j) {
    object = new THREE.Mesh(geometry, material);
    object.position.x = 1000;
    object.position.y = 1000;
    parent.add(object);
    parent = object;
  }
  parent = root;
  for (i = k = 0; k < 2000; i = ++k) {
    object = new THREE.Mesh(geometry, material);
    object.position.x = -1000;
    parent.add(object);
    parent = object;
  }
  parent = root;
  for (_ = l = 0; l < 2000; _ = ++l) {
    object = new THREE.Mesh(geometry, material);
    object.position.z = 1000;
    object.position.y = 1000;
    parent.add(object);
    parent = object;
  }
  parent = root;
  for (_ = m = 0; m < 2000; _ = ++m) {
    object = new THREE.Mesh(geometry, material);
    object.position.z = -1000;
    object.position.y = -1000;
    parent.add(object);
    parent = object;
  }
  parent = root;
  for (_ = n = 0; n < 2000; _ = ++n) {
    object = new THREE.Mesh(geometry, material);
    object.position.z = 10;
    object.position.x = 200;
    parent.add(object);
    parent = object;
  }
};

initStats = function() {
  stats = new Stats();
  stats.domElement.style.position = 'absolute';
  stats.domElement.style.top = '0px';
  stats.domElement.style.zIndex = 100;
  container.appendChild(stats.domElement);
};

onWindowResize = function() {
  windowHalfX = window.innerWidth / 2;
  windowHalfY = window.innerHeight / 2;
  camera.aspect = window.innerWidth / window.onnerHeight;
  camera.updateProjectionMatrix();
  renderer.setSize(window.innerWidth, window.innerHeight);
};

onDocumentMouseMove = function(event) {
  mouseX = (event.clientX - windowHalfX) * 10;
  mouseY = (event.clientY - windowHalfY) * 10;
};

animate = function() {
  requestAnimationFrame(animate);
  render();
  stats.update();
};

render = function() {
  var rx, ry, rz, time;
  time = Date.now() * 0.001;
  rx = Math.tan(time * 0.9) * 0.1;
  ry = Math.sin(time * 0.3) * 0.1;
  rz = Math.cos(time * 0.8) * 0.1;
  camera.position.x += (mouseX - camera.position.x) * .05;
  camera.position.y += (-mouseY - camera.position.y) * .05;
  camera.position.z += (-mouseY - camera.position.y) * .051;
  camera.lookAt(scene.position);
  root.traverse(function(object) {
    object.rotation.x = rx;
    object.rotation.y = ry;
    object.rotation.z = rz;
  });
  renderer.render(scene, camera);
};

start = function() {
  init();
  initCamera();
  initObject();
  initStats();
  animate();
};

document.addEventListener('mousemove', onDocumentMouseMove, false);

window.addEventListener('resize', onWindowResize, false);

start();

//# sourceMappingURL=hiel.js.map
