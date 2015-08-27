container = undefined
stats = undefined
camera = undefined
scene = undefined
renderer = undefined
raycaster = undefined
mouse = undefined
PI2 = Math.PI * 2


table = ["https://www.processing.org/","http://www.python.jp/", "https://pypi.python.org/pypi"]
objects = []
targets = {table:[]}

programFill = (context) ->
  context.beginPath()

  context.arc(0, 0, 0.5, 0, PI2, true)
  context.fill()
  return

programStroke = (context) ->
  context.lineWidth = 0.025
  context.beginPath()
  context.arc(0, 0, 0.5, 0, PI2, true)
  context.stroke()
  return

INTERSECTED = undefined

init = ->
  container = document.createElement('a')
  for i in table
    container.setAttribute("href",i)
  document.body.appendChild container
  
  scene = new THREE.Scene()
  
  raycaster = new THREE.Raycaster()
  mouse = new THREE.Vector3()

  renderer = new THREE.CanvasRenderer()
  renderer.setClearColor(0xf0f0f0)
  renderer.setPixelRatio(window.devicePixelRatio)
  renderer.setSize(window.innerWidth, window.innerHeight)
  container.appendChild(renderer.domElement)


  return

initObj = ->
  i = 0
  while i < 100
    particle = new THREE.Sprite(new THREE.SpriteCanvasMaterial(
      color: Math.random() * 0x808080 + 0x808080
      program: programStroke
      text:table[0]))
    particle.position.x = Math.random() * 800 - 400
    particle.position.y = Math.random() * 800 - 400
    particle.position.z = Math.random() * 800 - 400
    particle.scale.x = particle.scale.y = Math.random() * 20 + 20
    scene.add(particle)
    i++
  return
  
  

initCamera = ->
  camera = new THREE.PerspectiveCamera(70, window.innerWidth / window.innerHeight, 1, 10000)
  camera.position.set 0, 300, 500
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
  renderer.setSize window.innerWidth, window.innerHeight
  return


onDocumentMouseMove = (event) ->
  event.preventDefault()
  mouse.x = event.clientX / window.innerWidth * 2 - 1
  mouse.y = -(event.clientY / window.innerHeight) * 2 + 1
  mouse.z = -(event.clientY / window.innerHeight) * 2 + 1
  return



animate = ->
  requestAnimationFrame animate
  render()
  stats.update()
  return


radius = 600
theta = 0

render = ->
  # rotate camera
  theta += 0.1
  camera.position.x = radius * Math.sin(THREE.Math.degToRad(theta))
  camera.position.y = radius * Math.sin(THREE.Math.degToRad(theta))
  camera.position.z = radius * Math.cos(THREE.Math.degToRad(theta))
  camera.lookAt(scene.position)
  camera.updateMatrixWorld()
  # find intersections
  raycaster.setFromCamera(mouse, camera)
  
  intersects = raycaster.intersectObjects(scene.children)
  if intersects.length > 0
    if INTERSECTED isnt intersects[0].object
      if INTERSECTED
        INTERSECTED.material.program = programStroke
      INTERSECTED = intersects[0].object
      INTERSECTED.material.program = programFill
  else
    if INTERSECTED
      INTERSECTED.material.program = programStroke
    INTERSECTED = null
  renderer.render(scene, camera)
  return

start = ->
  init()

  document.addEventListener( 'mousemove', onDocumentMouseMove, false )
  window.addEventListener( 'resize', onWindowResize, false )
  initCamera()
  initObj()
  initStats()
  animate()
  return





start()

