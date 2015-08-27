container = undefined
stats = undefined
camera = undefined
scene = undefined
renderer = undefined
mesh = undefined
geometry = undefined
material = undefined
positions = undefined
particleSystem = undefined


init = ->

  container = document.createElement('div')
  scene = new THREE.Scene()
  scene.fog = new THREE.Fog(0x050505, 2000, 3500)
  
  renderer = new THREE.WebGLRenderer(antialias: false)
  renderer.setClearColor(scene.fog.color)
  renderer.setPixelRatio(window.devicePixelRatio)
  renderer.setSize(window.innerWidth, window.innerHeight)
  document.body.appendChild(container)
  container.appendChild(renderer.domElement)

  return


initObj = ->

  particles = 50000
  geometry = new THREE.BufferGeometry()
  positions = new Float32Array(particles * 3)
  colors = new Float32Array(particles * 3)
  color = new THREE.Color()

  n = 1000
  n2 = n / 2
  # particles spread in the cube
  i = 0
  while i < positions.length
    # positions
    x = Math.random() * n - n2 * Math.cos(n)
    y = Math.random() * n - n2 * Math.sin(n)
    z = Math.random() * n - n2 * Math.tan(n)
    positions[i] = x
    positions[i + 1] = y
    positions[i + 2] = z
    # colors
    vx = x / n + 0.1 * Math.random() * 10
    vy = y / n + 0.5 * Math.random() * 10
    vz = z / n + 0.5 * Math.random() * 10
    color.setRGB vx, vy, vz
    colors[i] = color.r
    colors[i + 1] = color.g
    colors[i + 2] = color.b
    i += 3
    
  geometry.addAttribute('position', new THREE.BufferAttribute(positions, 3))
  geometry.addAttribute('color', new THREE.BufferAttribute(colors, 3))
  geometry.computeBoundingBox()
  #
  material = new THREE.PointCloudMaterial(
    size: 15
    vertexColors: THREE.VertexColors)
    
  particleSystem = new THREE.PointCloud(geometry, material)
  scene.add(particleSystem)
  return
  



initCamera = ->
  camera = new THREE.PerspectiveCamera(40, window.innerWidth / window.innerHeight, 1, 10000)

  camera.position.x = Math.random() * 100
  camera.position.z = Math.random() * 300
  camera.position.y = Math.random() * 1000
  return

initStats = ->
  stats = new Stats()
  stats.domElement.style.position = 'absolute'
  stats.domElement.style.top = '0px'
  container.appendChild(stats.domElement)
  return



tweens = ->
  for i in 1000
    target = {x:Math.random() *1000,y:Math.random() * 1000,z:Math.random()*100}
    tween = new TWEEN.Tween(particleSystem.position)
      .to(target,400)
      .onUpdate(->
        particleSystem.geometry.verticesNeedUpdate = true;
        return)
      .start()

  return



onWindowResize = ->
  camera.aspect = window.innerWidth / window.innerHeight
  camera.updateProjectionMatrix()
  renderer.setSize window.innerWidth, window.innerHeight
  return

#

animate = ->
  render()
  requestAnimationFrame animate
  TWEEN.update()
  stats.update()
  return

render = ->
  time = Date.now() * 0.001
  particleSystem.rotation.x = time * 0.25
  particleSystem.rotation.y = time * 0.5
  renderer.render scene, camera
  return


start = ->
  init()
  initCamera()
  initObj()
  initStats()
  tweens()
  animate()
  return

window.addEventListener('resize', onWindowResize, false)

start()
