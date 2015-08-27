positions = undefined
container = undefined
stats = undefined
camera = undefined
scene = undefined
renderer = undefined
mesh = undefined
camera = undefined
segments = undefined
geometry = undefined
material = undefined

init = ->
  container = document.createElement('div')
  scene = new THREE.Scene()
  segments = 1000
  #
  renderer = new THREE.WebGLRenderer(antialias: true)
  renderer.setPixelRatio(window.devicePixelRatio)
  renderer.setSize(window.innerWidth, window.innerHeight)
  renderer.gammaInput = true
  renderer.gammaOutput = true

  document.body.appendChild(container)
  container.appendChild(renderer.domElement)
  
  return


initCamera = ->
  camera = new THREE.PerspectiveCamera(27,window.innerWidth/window.innerHeight ,1,10000)
  camera.position.z = 1500
  return


initObject = ->
  geometry = new THREE.BufferGeometry()
  material = new THREE.LineBasicMaterial({vertexColors:THREE.VertexColors ,color:'#E0FFFF',linewidth:1})
  positions = new Float32Array(segments * 3)
  colors = new Float32Array(segments * 3)

  r = 40 #radius
  i = -2000
  while i < segments
    x = r * Math.cos(i)
    y = r * Math.sin(rnd(i))
    z = r * Math.tan(i)

    # positions
    positions[i] = x 
    positions[i+1 * 3] = y 
    positions[i+2 ] = z  * 0.4

    # colors
    colors[i] = Math.floor(Math.random() * 10)
    colors[i+1] = Math.floor(Math.random()*10 )
    colors[i+2] = Math.floor(Math.random() *10)

    x += Math.random() 
    y += Math.random() 
    z += Math.random() 
    r++
    i++
    
  geometry.addAttribute('position', new THREE.BufferAttribute(positions, 3))
  geometry.addAttribute('color', new THREE.BufferAttribute(colors, 3))
  geometry.computeBoundingSphere()


  mesh = new THREE.Line(geometry, material)
  mesh.geometry.verticesNeedUpdate = true;
  scene.add(mesh)

  return
  

initStats = ->
  stats = new Stats()
  stats.domElement.style.position = 'absolute'
  stats.domElement.style.top = '0px'
  container.appendChild(stats.domElement)
  return
  

onWindowResize = ->
  camera.aspect = window.innerWidth / window.innerHeight
  camera.updateProjectionMatrix()
  renderer.setSize(window.innerWidth, window.innerHeight)
  return



animate = ->
  requestAnimationFrame animate
  render()
  stats.update()
  return

render = ->
  time = Date.now() * 0.001
  for i in [0..50]
    mesh.position.x *= time * 0.000025
    mesh.position.y *= time * 0.00025
    mesh.position.y *= time * 100.25
    mesh.rotation.x = time * 0.25
    mesh.rotation.y = time * 0.4

    cam_pos(camera,rnd(300),rnd(200),rnd(2000))
    renderer.render(scene, camera)
  return


start = ->
  init()
  initCamera()
  initObject()
  initStats()
  animate()
  return

window.addEventListener 'resize', onWindowResize, false
start()
