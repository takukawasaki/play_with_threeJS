window.addEventListener("load",->
  threeStart())


#start function

threeStart = ->
  initThree()
  initCamera()
  initObject()
  loops()
  return

canvasFrame = undefined
renderer = undefined
scene = undefined


#initialize canvas

initThree = ->
  canvasFrame = document.createElement('div')
  renderer = new THREE.WebGLRenderer()
  if not renderer
    alert("initialize three.js")
  renderer.setSize(window.innerWidth,window.innerHeight)
  document.body.appendChild(canvasFrame)
  canvasFrame.appendChild(renderer.domElement)
  renderer.setClearColor('black',1.0)
  scene = new THREE.Scene()
  return


#camera

camera = undefined

initCamera = ->
  camera = new THREE.PerspectiveCamera(45,window.innerWidth/window.innerHeight,1,10000)
  camera.position.set(200,200,200)
  camera.up.x = 0 + Math.random()*10
  camera.up.y = 0 + Math.random()*10
  camera.up.z = 1 + Math.random()*10
  camera.lookAt({
    x:0
    y:0
    z:0
    })

  return

###オブジェクト定義###

axis = undefined
geometry = undefined
material = undefined
cube = undefined
cubes = (0 for i in [0..100])

initObject = ->
  geometry = new THREE.BoxGeometry(10,10,10)
  material = new THREE.MeshNormalMaterial()

  for i ,index in cubes
    cubes[index] = new THREE.Mesh(geometry,material)
    cubes[index].position.x = Math.floor(Math.random() * 2)
    cubes[index].position.y = Math.floor(Math.random() * 4)
    cubes[index].position.z = Math.floor(Math.random() * 3)
    scene.add(cubes[index])
  return

step = 0
y = 2

loops = ->
  for i in cubes
    i.position.x = Math.floor(Math.random() * 10)
    i.position.y = Math.floor(Math.random() * 4)
    i.position.z = Math.floor(Math.random() * 20)
    i.rotation.x = Math.floor(Math.random() * 10)
    i.rotation.y = Math.floor(Math.random() * 5)
    i.rotation.z = Math.floor(Math.random() * 2)
    i.scale.x = Math.floor(Math.random()*2)
    i.scale.y = Math.floor(Math.random()*2)
    i.scale.z = Math.floor(Math.random()*2)
    i.translateY(10)
    i.translateX(10)
    i.translateZ(20)
  renderer.render(scene,camera)
  requestAnimationFrame(loops)  
  return
