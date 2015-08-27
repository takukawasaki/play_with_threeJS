container = undefined
stats = undefined
camera = undefined
scene = undefined
renderer = undefined
geometry = undefined

effect = undefined

mouseX = 0
mouseY = 0

windowHalfX = 0
windowHalfY = 0



init = ->
  container = document.createElement('div')
  document.body.appendChild(container)

  renderer = new THREE.CanvasRenderer()
  renderer.setClearColor(0xffffff)
  renderer.setPixelRatio(window.devicePixelRatio)
  renderer.setSize(window.innerWidth, window.innerHeight)
  container.appendChild(renderer.domElement)
  scene = new THREE.Scene()

  return


initCamera = ->
  camera = new THREE.PerspectiveCamera(40, window.innerWidth / window.innerHeight, 1, 10000)
  camera.position.x = 100
  camera.position.y = 100
  camera.position.z = 100
  return


cubes = (0 for i in [0..5])
initObject = ->
  geometry = new THREE.BoxGeometry(10,10,10)
  material = new THREE.MeshNormalMaterial()
  
  for i ,index in cubes
    
    cubes[index] = new THREE.Mesh(geometry, material)
    cubes[index].position.x =  Math.random() * 2000 - 1000
    cubes[index].position.y =  Math.random() * 2000 - 1000
    cubes[index].position.z =  Math.random() * 2000 - 1000
    cubes[index].rotation.x = Math.random() * 1000
    cubes[index].rotation.y = Math.random() * 2000
  
    cubes[index].matrixAutoUpdate = false
    cubes[index].updateMatrix()
    scene.add(cubes[index])
  
  return

effect = undefined

initEffect = ->
  effect = new THREE.StereoEffect(renderer)
  effect.setSize(window.innerWidth, window.innerHeight)

  return
  
initStats = ->
  stats = new Stats()
  stats.domElement.style.position = 'absolute'
  stats.domElement.style.top = '10px'
  stats.domElement.style.zIndex = 100
  container.appendChild(stats.domElement)
  return


onWindowResize = ->
  windowHalfX = window.innerWidth / 2
  windowHalfY = window.innerHeight / 2
  camera.aspect = window.innerWidth / window.innerHeight
  camera.updateProjectionMatrix()
  renderer.setSize(window.innerWidth, window.innerHeight)
  effect.setSize(window.innerWidth, window.innerHeight)
  return

onDocumentMouseMove = (event) ->
  mouseX = (event.clientX - windowHalfX) * 2
  mouseY = (event.clientY - windowHalfY) * 2
  return



animate = ->
  initObject()
  requestAnimationFrame(animate)
  render()
  stats.update()

  return

render = ->
  camera.position.x += (mouseX - camera.position.x) * .05
  camera.position.y += (-mouseY - camera.position.y) * .05
  camera.lookAt(scene.position)

  currentSeconds = Date.now()
  scene.position.x = Math.sin(currentSeconds * 0.0007) * 0.05
  scene.position.y = Math.sin(currentSeconds * 0.00002) * 0.005
  scene.position.z = Math.sin(currentSeconds * 0.00007) * 0.002
  scene.rotation.x = Math.sin(currentSeconds * 0.0007) * 0.05
  scene.rotation.y = Math.sin(currentSeconds * 0.0001) * 0.03
  scene.rotation.y = Math.sin(currentSeconds * 0.00015) * 0.05
  
  for i in cubes
    i.position.x =  Math.random() * 200 - 100
    i.position.y =  Math.random() * 1000 - 500
    i.position.z =  Math.random() * 200 - 1000
    i.rotation.x = Math.random() * 100 * Math.PI
    i.rotation.y = Math.random() * 200 * Math.PI
    i.rotation.z = Math.cos(currentSeconds * 0.001) * 0.003

  effect.render(scene,camera)
  return

start = ->
  init()
  initCamera()
  initObject()
  initStats()
  initEffect()
  animate()
  return
  
window.addEventListener('resize', onWindowResize, false)  
document.addEventListener('mousemove', onDocumentMouseMove, false)

start()
