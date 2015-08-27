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
  camera.position.set(100,100,100)
  camera.up.x = 1
  camera.up.y = 0
  camera.up.z = 1
  camera.lookAt({
    x:rnd(100)
    y:rnd(100)
    z:rnd(100)
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


y = 2

loops = ->
  for i,index in cubes
    if index % 2 is 0
      make_pos(i,rnd(4),rnd(y++),rnd(y++))
      make_rotate(i,rnd(3),rnd(4),rnd(10))

    else
      i.position.x = Math.floor(Math.random() * -10)
      i.position.y =Math.floor(Math.random() * -y-- )
      i.position.z = Math.floor(Math.random() * -y--)
      i.rotation.x =  Math.floor(Math.random() * -2)
      i.rotation.y =  Math.floor(Math.random() * -4)
      i.rotation.z= Math.floor(Math.random() * -5)
  renderer.render(scene,camera)
  requestAnimationFrame(loops)  
  return
