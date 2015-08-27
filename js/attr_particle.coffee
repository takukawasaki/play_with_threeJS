if !Detector.webgl
  Detector.addGetWebGLMessage()

renderer = undefined
scene = undefined
camera = undefined
stats = undefined
sphere = undefined
uniforms = undefined
attributes = undefined
vc1 = undefined
WIDTH = window.innerWidth
HEIGHT = window.innerHeight
sphere = undefined
geometry = undefined
geometry2 = undefined
vertices = undefined
radius = 0
segments = 0
rings = 0

pos = {radius:60,segments:100,rings:800}
next = {x:pos.radius+1,y:pos.segments,z : pos.rings}



initCamera = ->
  camera = new THREE.PerspectiveCamera(45, WIDTH / HEIGHT, 1, 10000)
  camera.position.z = 300
  return

  


init = ->
  scene = new THREE.Scene()
  renderer = new THREE.WebGLRenderer()
  renderer.setPixelRatio(window.devicePixelRatio)
  renderer.setSize(WIDTH, HEIGHT)
  renderer.setClearColor('#191970')
  container = document.getElementById('container')
  container.appendChild renderer.domElement


  window.addEventListener 'resize', onWindowResize, false
  return


initObj = ->
  attributes =
    size:
      type: 'f'
      value: []
    ca:
      type: 'c'
      value: []
  uniforms =
    amplitude:
      type: 'f'
      value: 4.0
    color:
      type: 'c'
      value: new THREE.Color("#E0FFFF")
    texture:
      type: 't'
      value: THREE.ImageUtils.loadTexture('../textures/lensflare0.png')
  uniforms.texture.value.wrapS = uniforms.texture.value.wrapT = THREE.RepeatWrapping
  shaderMaterial = new THREE.ShaderMaterial(
    uniforms: uniforms
    attributes: attributes
    transparent: true)

  radius = 60
  segments = 100
  rings = 2000

  geometry = new THREE.SphereGeometry(radius,segments,rings)

  
  vc1 = geometry.vertices.length

  geometry2 = new THREE.BoxGeometry(7.8 * radius, 2.8 * radius, 1.8 * radius, Math.random() * 20, 100,Math.random())
  geometry.merge(geometry2)

  sphere = new THREE.PointCloud(geometry, shaderMaterial)
  vertices = sphere.geometry.vertices
  values_size = attributes.size.value
  values_color = attributes.ca.value


  for v in [0...vertices.length]
    values_size[v] = 1000
    values_color[v] = new THREE.Color("#E0FFFF")
    if v < vc1
      values_color[v].setHSL(44.31 + 3.1 * v / vc1, 100.99, (vertices[v].y + radius) / (4 * radius))
    else
      values_size[v] = 400
      values_color[v].setHSL(11.6, 0.75, 8.25 + vertices[v].y / (2 * radius))


  scene.add(sphere)
  return



initStats = ->
  stats = new Stats
  stats.domElement.style.position = 'absolute'
  stats.domElement.style.top = '0px'
  container.appendChild(stats.domElement)
  return


onWindowResize = ->
  camera.aspect = window.innerWidth / window.innerHeight
  camera.updateProjectionMatrix()
  renderer.setSize window.innerWidth, window.innerHeight
  return





animate = ->
  requestAnimationFrame animate
  render()
  stats.update()
  return

render = ->

  time = Date.now() * 0.005
  sphere.rotation.y = 0.02 * time
  sphere.rotation.z = 0.02 * time
  
  i = 0
  while i < attributes.size.value.length
    if i < vc1
      attributes.size.value[i] = 16 + 120 * Math.sin(0.1 * i + time)
    i++
  attributes.size.needsUpdate = true

  sphere.position.x += Math.random() 
  sphere.position.y += Math.random() 
  sphere.position.z += Math.random() 



  
  if sphere.position.x > 30 
    sphere.position.x -= Math.random()

      
  if sphere.position.y > 30 
    sphere.position.y -= Math.random()
  
    
  if sphere.position.z > 40
    sphere.position.z -= Math.random()


  renderer.render scene, camera
  return


run = ->
  initCamera()
  init()
  initObj()
  initStats()
  animate()
  return

run()  






