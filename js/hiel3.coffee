container = undefined

stats = undefined

camera = undefined
scene = undefined
renderer = undefined
Geometry = undefined

root = undefined
mouseX = 0
mouseY = 0

windowHalfX = window.innerWidth / 2
windowHalfY = window.innerHeight / 2



init = ->
  container = document.createElement('div')
  document.body.appendChild(container)

  info = document.createElement('div')
  info.style.position = 'absolute'
  info.style.top = '30px'
  info.style.width = '100%'
  info.style.textAlign = 'right'
  info.innerHTML = 'Drag to change move'
  container.appendChild(info)


  scene = new THREE.Scene()
    
  renderer = new THREE.WebGLRenderer()
  renderer.setClearColor('#191970')
  renderer.setPixelRatio(window.devicePixelRatio)
  renderer.setSize(window.innerWidth,window.innerHeight)
  renderer.sortObjects = false

  container.appendChild(renderer.domElement)

  return

initCamera = ->
  camera = new THREE.PerspectiveCamera(45,window.innerWidth/window.innerHeight,1,15000)

  return

step = 0

initObject = ->
  geometry = new THREE.BoxGeometry(100,100,1000)
  material = new THREE.MeshNormalMaterial()

  root = new THREE.Mesh(geometry,material)
  root.position.x = 100
  root.position.y = 100
  root.position.z = 100
  
  scene.add(root)
  amount = 2000
  object = undefined
  parent = root

  for i in [0...2000]
    object = new THREE.Mesh(geometry,material)
    object.position.x = 1000
    object.position.y = 1000
    parent.add(object)
    parent = object

  parent = root

  for i in [0...2000]
    object = new THREE.Mesh(geometry,material)
    object.position.x = - 1000

    parent.add(object)
    parent = object

  parent = root

  for _ in [0...2000]

    object = new THREE.Mesh(geometry,material)
    object.position.z =  1000
    object.position.y = 1000
    parent.add(object)
    parent = object

  parent = root

  for _ in [0...2000]
    object = new THREE.Mesh(geometry,material)
    object.position.z = - 1000
    object.position.y = -1000
    parent.add(object)
    parent = object

  parent = root

  for _ in [0...2000]
    object = new THREE.Mesh(geometry,material)
    object.position.z =  10
    object.position.x = 200
    parent.add(object)
    parent = object


  return
    

initStats = ->
  stats = new Stats()
  stats.domElement.style.position = 'absolute'
  stats.domElement.style.top = '0px'
  stats.domElement.style.zIndex = 100
  container.appendChild(stats.domElement)

  return

  
onWindowResize = ->
  windowHalfX = window.innerWidth / 2
  windowHalfY = window.innerHeight /2

  camera.aspect = window.innerWidth / window.onnerHeight
  camera.updateProjectionMatrix()
  renderer.setSize(window.innerWidth,window.innerHeight)

  return

onDocumentMouseMove = (event) ->
  mouseX = (event.clientX - windowHalfX) * 10
  mouseY = (event.clientY - windowHalfY) * 10

  return

animate = ->
  requestAnimationFrame(animate)
  render()
  stats.update()
  return

render = ->

  time = Date.now() * 0.001
  rx = Math.tan( time * 0.9) * 0.1
  ry = Math.sin(time * 0.3) * 0.1
  rz = Math.cos( time * 0.8) * 0.1

  camera.position.x += (mouseX - camera.position.x) * .05
  camera.position.y += (-mouseY - camera.position.y) * .05
  camera.position.z += (-mouseY - camera.position.y) * .051
  camera.lookAt(scene.position)

  root.traverse((object) ->
    object.rotation.x = rx 
    object.rotation.y = ry 
    object.rotation.z = rz 
    return
  )
  renderer.render(scene,camera)
  return

start = ->
  init()
  initCamera()
  initObject()
  initStats()
  animate()
  return


document.addEventListener('mousemove',onDocumentMouseMove,false)

window.addEventListener('resize',onWindowResize,false)

start()
