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
  camera.position.set(500,500,500)
  camera.up.x = 0
  camera.up.y = 0
  camera.up.z = 1
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
    scene.add(cubes[index])

  return

step = 0

requestAnimationFrame = window.mozRequestAnimationFrame
y = 2

rnd = (x) ->
  Math.floor(Math.random() * x)

make_pos = (O,X,Y,Z) ->
  O.position.set(rnd(X),rnd(Y),rnd(Z))
  return
  
make_rotate = (O,X,Y,Z) ->
  O.rotation.set(rnd(X),rnd(Y),rnd(Z))

  return

cam_pos = (camera,X,Y,Z) ->
  camera.position.x = X
  camera.position.y = Y
  camera.position.z =Z
  return
  
loops = ->
  for i,index in cubes
    if index % 2 is 0
      make_pos(i,rnd(4),rnd(y++),rnd(y++))
      make_rotate(i,rnd(5),rnd(4),rnd(-10))
      camera.lookAt({x:rnd(50),y:rnd(50),z:rnd(50)})
    else
      make_pos(i,rnd(-10),rnd(-y-- * 10), rnd(-y-- * 10))
      make_rotate(i,rnd(-2 * 10),rnd(-40),rnd(-5))
      cam_pos(camera,200,200,200)
      
  renderer.render(scene,camera)
  requestAnimationFrame(loops)
  return



@rnd = rnd
