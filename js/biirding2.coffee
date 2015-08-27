SCREEN_WIDTH = window.innerWidth
SCREEN_HEIGHT = window.innerHeight
SCREEN_WIDTH_HALF = SCREEN_WIDTH / 2
SCREEN_HEIGHT_HALF = SCREEN_HEIGHT / 2
camera = undefined
scene = undefined
renderer = undefined
birds = undefined
bird = undefined
boid = undefined
boids = undefined
stats = undefined
view = undefined

initStart = ->
  view = document.createElement('div')
  document.body.appendChild(view)

  renderer = new THREE.WebGLRenderer()
  renderer.setClearColor('#87CEEB')
  renderer.setPixelRatio(window.devicePixelRatio)
  renderer.setSize(SCREEN_WIDTH, SCREEN_HEIGHT)

  document.body.appendChild(renderer.domElement)

  scene = new THREE.Scene()
  return


initCamera = ->
  camera = new THREE.PerspectiveCamera(80, SCREEN_WIDTH / SCREEN_HEIGHT, 1, 10000)
  camera.position.x = Math.random() * 400
  camera.position.y = Math.random() * 100
  camera.position.z = Math.random() * 150
  camera.rotation.x = Math.random() * 120
  camera.rotation.y = Math.random() * 200
  camera.rotation.z = Math.random() * 100
  camera.up.set(200,400,500)
  camera.rotationAutoUpdate
  camera.lookAt(scene.position)
  
  return

initObject = ->
  birds = []
  boids = []
  i = [0..500]
  for j,index in i
    boid = boids[j] = new Boid()
    boid.position.x = Math.random() * 400 - 100
    boid.position.y = Math.random() * 400 - 300
    boid.position.z = Math.random() * 400 - 200
    boid.velocity.x = Math.random() * 10  - 2
    boid.velocity.y = Math.random() * 10  - 2
    boid.velocity.z = Math.random() * 10  - 2
    boid.setAvoidWalls(true)
    boid.setWorldSize(800, 700, 700)
    bird = birds[j] = new THREE.Mesh(new Bird(), new THREE.MeshBasicMaterial(
      color: Math.random() * 100
      side: THREE.DoubleSide))
    bird.phase = Math.floor(Math.random() * 100.83)
    scene.add(bird)

  return


initStats = ->
  stats = new Stats()
  stats.domElement.style.position = 'absolute'
  stats.domElement.style.left = '0px'
  stats.domElement.style.top = '0px'

  view.appendChild(stats.domElement)

  return
  


onWindowResize = ->
  camera.aspect = window.innerWidth / window.innerHeight
  camera.updateProjectionMatrix()
  renderer.setSize(window.innerWidth, window.innerHeight)
  return

onDocumentMouseMove = (event) ->
  vector = new THREE.Vector3(event.clientX - SCREEN_WIDTH_HALF, -event.clientY + SCREEN_HEIGHT_HALF, 0)
  i = 0
  il = boids.length
  while i < il
    boid = boids[i]
    vector.z = boid.position.z
    boid.repulse vector
    i++
  return

animate = ->
  requestAnimationFrame(animate)  
  render()
  stats.update()

  return

render = ->
  for v,i in birds
    boid = boids[i]
    boid.run(boids)
    bird = birds[i]
    bird.position.copy boids[i].position
    color = bird.material.color
    color.r = color.g = color.b = (500 - bird.position.z) / 1000
    bird.rotation.y = Math.atan2(-boid.velocity.z, boid.velocity.x)
    bird.rotation.z = Math.asin(boid.velocity.y / boid.velocity.length())
    bird.phase = (bird.phase + Math.max(0, bird.rotation.z) + 0.1) % 62.83
    bird.geometry.vertices[5].y = bird.geometry.vertices[4].y = Math.sin(bird.phase) * 5
    
    
  renderer.render(scene, camera)
  return

start = ->
  initStart()
  initCamera()
  initObject()
  animate()
  return

window.addEventListener('resize', onWindowResize, false)
document.addEventListener('mousemove', onDocumentMouseMove, false)

start()  




