// Generated by CoffeeScript 1.9.1
var INTERSECTED, PI2, animate, camera, container, init, initCamera, initObj, initStats, mouse, objects, onDocumentMouseMove, onWindowResize, programFill, programStroke, radius, raycaster, render, renderer, scene, start, stats, table, targets, theta;

container = void 0;

stats = void 0;

camera = void 0;

scene = void 0;

renderer = void 0;

raycaster = void 0;

mouse = void 0;

PI2 = Math.PI * 2;

table = ["https://www.processing.org/", "http://www.python.jp/", "https://pypi.python.org/pypi"];

objects = [];

targets = {
  table: []
};

programFill = function(context) {
  context.beginPath();
  context.arc(0, 0, 0.5, 0, PI2, true);
  context.fill();
};

programStroke = function(context) {
  context.lineWidth = 0.025;
  context.beginPath();
  context.arc(0, 0, 0.5, 0, PI2, true);
  context.stroke();
};

INTERSECTED = void 0;

init = function() {
  var i, j, len;
  container = document.createElement('a');
  for (j = 0, len = table.length; j < len; j++) {
    i = table[j];
    container.setAttribute("href", i);
  }
  document.body.appendChild(container);
  scene = new THREE.Scene();
  raycaster = new THREE.Raycaster();
  mouse = new THREE.Vector3();
  renderer = new THREE.CanvasRenderer();
  renderer.setClearColor(0xf0f0f0);
  renderer.setPixelRatio(window.devicePixelRatio);
  renderer.setSize(window.innerWidth, window.innerHeight);
  container.appendChild(renderer.domElement);
};

initObj = function() {
  var i, particle;
  i = 0;
  while (i < 100) {
    particle = new THREE.Sprite(new THREE.SpriteCanvasMaterial({
      color: Math.random() * 0x808080 + 0x808080,
      program: programStroke,
      text: table[0]
    }));
    particle.position.x = Math.random() * 800 - 400;
    particle.position.y = Math.random() * 800 - 400;
    particle.position.z = Math.random() * 800 - 400;
    particle.scale.x = particle.scale.y = Math.random() * 20 + 20;
    scene.add(particle);
    i++;
  }
};

initCamera = function() {
  camera = new THREE.PerspectiveCamera(70, window.innerWidth / window.innerHeight, 1, 10000);
  camera.position.set(0, 300, 500);
};

initStats = function() {
  stats = new Stats();
  stats.domElement.style.position = 'absolute';
  stats.domElement.style.top = '0px';
  container.appendChild(stats.domElement);
};

onWindowResize = function() {
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();
  renderer.setSize(window.innerWidth, window.innerHeight);
};

onDocumentMouseMove = function(event) {
  event.preventDefault();
  mouse.x = event.clientX / window.innerWidth * 2 - 1;
  mouse.y = -(event.clientY / window.innerHeight) * 2 + 1;
  mouse.z = -(event.clientY / window.innerHeight) * 2 + 1;
};

animate = function() {
  requestAnimationFrame(animate);
  render();
  stats.update();
};

radius = 600;

theta = 0;

render = function() {
  var intersects;
  theta += 0.1;
  camera.position.x = radius * Math.sin(THREE.Math.degToRad(theta));
  camera.position.y = radius * Math.sin(THREE.Math.degToRad(theta));
  camera.position.z = radius * Math.cos(THREE.Math.degToRad(theta));
  camera.lookAt(scene.position);
  camera.updateMatrixWorld();
  raycaster.setFromCamera(mouse, camera);
  intersects = raycaster.intersectObjects(scene.children);
  if (intersects.length > 0) {
    if (INTERSECTED !== intersects[0].object) {
      if (INTERSECTED) {
        INTERSECTED.material.program = programStroke;
      }
      INTERSECTED = intersects[0].object;
      INTERSECTED.material.program = programFill;
    }
  } else {
    if (INTERSECTED) {
      INTERSECTED.material.program = programStroke;
    }
    INTERSECTED = null;
  }
  renderer.render(scene, camera);
};

start = function() {
  init();
  document.addEventListener('mousemove', onDocumentMouseMove, false);
  window.addEventListener('resize', onWindowResize, false);
  initCamera();
  initObj();
  initStats();
  animate();
};

start();

//# sourceMappingURL=circle_tt.js.map
