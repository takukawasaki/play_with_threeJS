
group = undefined
container = undefined
stats = undefined
particlesData = []
camera = undefined
scene = undefined
renderer = undefined
positions = undefined
colors = undefined
pointCloud = undefined
particlePositions = undefined
linesMesh = undefined
maxParticleCount = 1000
particleCount = 500
r = 1400
rHalf = r / 2

effectController = {
  showDots: true
  showLines: true
  minDistance: 300
  limitConnections: false
  maxConnections: 100
  particleCount: 100
  }
  
initGUI = ->

  gui = new (dat.GUI)
  gui.add(effectController, 'showDots').onChange (value) ->
    pointCloud.visible = value
    return
  gui.add(effectController, 'showLines').onChange (value) ->
    linesMesh.visible = value
    return
  gui.add(effectController, 'minDistance', 10, 1000)
  gui.add(effectController, 'limitConnections')
  gui.add(effectController, 'maxConnections', 0, 1000, 1)
  gui.add(effectController, 'particleCount', 0, maxParticleCount, 1).onChange (value) ->
    particleCount = parseInt(value)

    return
  return


initStart = ->

  container = document.getElementById('container')

  renderer = new THREE.WebGLRenderer(antialias: true)
  renderer.setPixelRatio window.devicePixelRatio
  renderer.setSize(window.innerWidth, window.innerHeight)
  renderer.setClearColor('#FA8072',1.0)
  renderer.gammaInput = true #ガンマ補正
  renderer.gammaOutput = true
  container.appendChild(renderer.domElement)
  scene = new THREE.Scene()
  group = new THREE.Group()
  scene.add(group)

  return 


initCamera = ->
  camera = new THREE.PerspectiveCamera(60, window.innerWidth / window.innerHeight, 1,10000)

  #/from module.js
  cam_pos(camera,rnd(1000),rnd(1000),rnd(1000))
  make_rotate(camera,rnd(700),rnd(700),rnd(700))
  cam_up(camera,rnd(500),rnd(500),rnd(500))
  return



initObj = ->
  
  controls = new THREE.OrbitControls(camera, container) #マウスによるカメラ一座標の移動するクラス
  controls.userzoom = true
  helper = new THREE.BoxHelper(new THREE.Mesh(new THREE.BoxGeometry(r*2, r*2, r*2)))
  helper.material.color.setHex('#90EE90')
  helper.material.blending = THREE.AdditiveBlending
  helper.material.transparent = true
  group.add(helper)
  segments = maxParticleCount * maxParticleCount
  positions = new Float32Array(segments * 20)
  colors = new Float32Array(segments * 30)
  pMaterial = new THREE.PointCloudMaterial(
    color: '#00FF00'
    size: 7
    blending: THREE.AdditiveBlending
    transparent: true
    sizeAttenuation: false)

  particles = new THREE.BufferGeometry()
  particlePositions = new Float32Array(maxParticleCount * 3)
  i = 0
  while i < maxParticleCount
    x = Math.random() * r - r / 2
    y = Math.random() * r - r / 2
    z = Math.random() * r - r / 2
    particlePositions[i * rnd(5)] = x
    particlePositions[i * rnd(3) + 1] = y
    particlePositions[i * rnd(3) + 2] = z
    # add it to the geometry
    particlesData.push
      velocity: new THREE.Vector3(-1 + Math.random() * 2, -1 + Math.random() * 5, -1 + Math.random() * 8)
      numConnections: 1
    i++

  particles.drawcalls.push({
    start: 0
    count: particleCount
    index: 0})

  particles.addAttribute 'position', new THREE.DynamicBufferAttribute(particlePositions, 3)

  # create the particle system
  pointCloud = new THREE.PointCloud(particles, pMaterial)
  group.add(pointCloud)
  geometry = new THREE.BufferGeometry()
  geometry.addAttribute('position', new THREE.DynamicBufferAttribute(positions, 3))
  geometry.addAttribute('color', new THREE.DynamicBufferAttribute(colors, 3))
  geometry.computeBoundingSphere()
  geometry.drawcalls.push({
    start: 0
    count: 0
    index: 0})
    
  material = new THREE.LineBasicMaterial({
    vertexColors: THREE.VertexColors
    blending: THREE.AdditiveBlending
    transparent: true})
    
  linesMesh = new THREE.Line(geometry, material, THREE.LinePieces)
  group.add(linesMesh)

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

animate = ->

  vertexpos = 0
  colorpos = 0
  numConnected = 0
  i = 0
  while i < particleCount
    particlesData[i].numConnections = 0
    i++
  i = 0
  while i < particleCount
    # get the particle
    particleData = particlesData[i]
    particlePositions[i * 3] += particleData.velocity.x
    particlePositions[i * 3 + 1] += particleData.velocity.y
    particlePositions[i * 3 + 2] += particleData.velocity.z
    if particlePositions[i * 3 + 1] < -rHalf or particlePositions[i * 3 + 1] > rHalf
      particleData.velocity.y = -particleData.velocity.y
    if particlePositions[i * 3] < -rHalf or particlePositions[i * 3] > rHalf
      particleData.velocity.x = -particleData.velocity.x
    if particlePositions[i * 3 + 2] < -rHalf or particlePositions[i * 3 + 2] > rHalf
      particleData.velocity.z = -particleData.velocity.z
    if effectController.limitConnections and particleData.numConnections >= effectController.maxConnections
      i++
      continue
    # Check collision
    j = i + 1
    while j < particleCount
      particleDataB = particlesData[j]
      if effectController.limitConnections and particleDataB.numConnections >= effectController.maxConnections
        j++
        continue
      dx = particlePositions[i * 3] - particlePositions[j * 3]
      dy = particlePositions[i * 3 + 1] - particlePositions[j * 3 + 1]
      dz = particlePositions[i * 3 + 2] - particlePositions[j * 3 + 2]
      dist = Math.sqrt(dx * dx + dy * dy + dz * dz)
      if dist < effectController.minDistance
        particleData.numConnections++
        particleDataB.numConnections++
        alpha = 1.0 - dist / effectController.minDistance
        positions[vertexpos++] = particlePositions[i * 3]
        positions[vertexpos++] = particlePositions[i * 3 + 1]
        positions[vertexpos++] = particlePositions[i * 3 + 2]
        positions[vertexpos++] = particlePositions[j * 3]
        positions[vertexpos++] = particlePositions[j * 3 + 1]
        positions[vertexpos++] = particlePositions[j * 3 + 2]
        colors[colorpos++] = alpha
        colors[colorpos++] = alpha
        colors[colorpos++] = alpha
        colors[colorpos++] = alpha
        colors[colorpos++] = alpha
        colors[colorpos++] = alpha
        numConnected++
      j++
    i++
  linesMesh.geometry.drawcalls[0].count = numConnected * 2
  linesMesh.geometry.attributes.position.needsUpdate = true
  linesMesh.geometry.attributes.color.needsUpdate = true
  pointCloud.geometry.attributes.position.needsUpdate = true
  requestAnimationFrame(animate)
  stats.update()
  render()
  return

render = ->
  time = Date.now() * 0.001
  group.rotation.y = time * 0.1
  renderer.render(scene, camera)

  return

starts = ->
  initGUI()
  initStart()
  initCamera()
  initObj()
  initStats()
  animate()

  return
  

window.addEventListener 'resize', onWindowResize, false


starts()
