MARGIN = 0
SCREEN_WIDTH = window.innerWidth
SCREEN_HEIGHT = window.innerHeight - 2 * MARGIN

#basic parts
container = undefined
stats = undefined
camera = undefined
scene = undefined
renderer = undefined
controls = undefined
mesh = undefined
texture = undefined
geometry = undefined

materials = undefined
material = undefined

current_material = undefined #defalut material
light = undefined
pointLight = undefined
ambientLight = undefined
effect = undefined
resolution = undefined
numBlobs = undefined
composer = undefined
effectFXAA = undefined
hblur = undefined
vblur = undefined
effectController = undefined
time = 0

clock = new THREE.Clock()

initCamera = ->
  camera = new THREE.PerspectiveCamera(60,SCREEN_WIDTH / SCREEN_HEIGHT,1,10000)
  camera.position.set(-Math.random()* 200,400,1300)
  return


initMatchingCubes = ->
  
  # MARCHING CUBES
  resolution = 28
  numBlobs = 1000
  effect = new THREE.MarchingCubes(resolution, materials[current_material].m, true, true)
  effect.position.set(Math.random()*100,Math.random()* 100, Math.random()*100)
  effect.scale.set(800, 700, 1000)
  effect.enableUvs = false
  effect.enableColors = true
  scene.add(effect)
  return
  

initStats = ->
  #STATS
  stats = new Stats()
  container.appendChild(stats.domElement)
  return



initScene = ->
  container = document.getElementById('container')

  # SCENE
  scene = new THREE.Scene()
  return

initLight = ->
  # LIGHTS
  light = new THREE.DirectionalLight(0xffffff)
  light.position.set(0.5, 0.5, 1)
  scene.add(light)

  pointLight = new THREE.PointLight("#FFA07A")
  pointLight.position.set(0, 0, 100)
  scene.add(pointLight)
  ambientLight = new THREE.AmbientLight(0x080808)
  scene.add(ambientLight)
  return

initGui = ->
  setupGui()


initEvents = ->
  window.addEventListener('resize', onWindowResize, false)


initControls = ->
  # CONTROLS
  controls = new THREE.OrbitControls(camera, renderer.domElement)
  return
  

initRenderer = ->
  # RENDERER
  renderer = new THREE.WebGLRenderer()
  renderer.setClearColor("#00008B")
  renderer.setPixelRatio(window.devicePixelRatio)
  renderer.setSize(SCREEN_WIDTH, SCREEN_HEIGHT)

  renderer.domElement.style.position = 'absolute'
  renderer.domElement.style.top = MARGIN + 'px'
  renderer.domElement.style.left = '0px'

  container.appendChild(renderer.domElement)

  renderer.gammaInput = true
  renderer.gammaOutput = true
  return
  


initMaterial = ->
# MATERIALS
  materials = generateMaterials()
  current_material = "matte"
  return

  
initComposer = ->
  # COMPOSER
  renderer.autoClear = true

  renderTargetParameters = 
    minFilter: THREE.LinearFilter
    magFilter: THREE.LinearFilter
    format: THREE.RGBFormat
    stencilBuffer: false

  renderTarget = new THREE.WebGLRenderTarget(SCREEN_WIDTH, SCREEN_HEIGHT, renderTargetParameters)
  effectFXAA = new THREE.ShaderPass(THREE.FXAAShader)
  hblur = new THREE.ShaderPass(THREE.HorizontalTiltShiftShader)
  vblur = new THREE.ShaderPass(THREE.VerticalTiltShiftShader)
  bluriness = 8
  hblur.uniforms['h'].value = bluriness / SCREEN_WIDTH
  vblur.uniforms['v'].value = bluriness / SCREEN_HEIGHT
  hblur.uniforms['r'].value = vblur.uniforms['r'].value = 0.5
  effectFXAA.uniforms['resolution'].value.set(1 / SCREEN_WIDTH, 1 / SCREEN_HEIGHT)
  composer = new THREE.EffectComposer(renderer, renderTarget)
  renderModel = new THREE.RenderPass(scene, camera)
  vblur.renderToScreen = true

  #effectFXAA.renderToScreen = true;
  composer = new THREE.EffectComposer(renderer, renderTarget)
  composer.addPass(renderModel)
  composer.addPass(effectFXAA)
  composer.addPass(hblur)
  composer.addPass(vblur)
  return
  
init = ->
  initCamera()
  initScene()
  initLight()
  initMaterial()
  initMatchingCubes()
  initRenderer()
  initControls()
  initStats()
  initComposer()
  initGui()
  initEvents()
  return





onWindowResize = (event) ->
  SCREEN_WIDTH = window.innerWidth
  SCREEN_HEIGHT = window.innerHeight - 2 * MARGIN
  camera.aspect = SCREEN_WIDTH / SCREEN_HEIGHT
  camera.updateProjectionMatrix()
  renderer.setSize(SCREEN_WIDTH, SCREEN_HEIGHT)
  composer.setSize(SCREEN_WIDTH, SCREEN_HEIGHT)
  hblur.uniforms['h'].value = 4 / SCREEN_WIDTH
  vblur.uniforms['v'].value = 4 / SCREEN_HEIGHT
  effectFXAA.uniforms['resolution'].value.set(1 / SCREEN_WIDTH, 1 / SCREEN_HEIGHT)
  return



generateMaterials = ->
  materials = undefined
  texture = undefined
  # environment map
  path = '../../textures/cube/skybox/'
  format = '.jpg'
  urls = [
    path + 'px' + format
    path + 'nx' + format
    path + 'py' + format
    path + 'ny' + format
    path + 'pz' + format
    path + 'nz' + format
  ]
  
  reflectionCube = THREE.ImageUtils.loadTextureCube(urls)
  reflectionCube.format = THREE.RGBFormat
  refractionCube = new THREE.Texture(reflectionCube.image, THREE.CubeRefractionMapping)
  reflectionCube.format = THREE.RGBFormat

  # toons
  toonMaterial1 = createShaderMaterial('toon1', light, ambientLight)
  toonMaterial2 = createShaderMaterial('toon2', light, ambientLight)
  hatchingMaterial = createShaderMaterial('hatching', light, ambientLight)
  hatchingMaterial2 = createShaderMaterial('hatching', light, ambientLight)
  dottedMaterial = createShaderMaterial('dotted', light, ambientLight)
  dottedMaterial2 = createShaderMaterial('dotted', light, ambientLight)

  hatchingMaterial2.uniforms.uBaseColor.value.setRGB(Math.random() * 100, Math.random() * 200, Math.random() * 200)
  hatchingMaterial2.uniforms.uLineColor1.value.setHSL(Math.random() * 255, Math.random() * 255, Math.random() * 255)
  hatchingMaterial2.uniforms.uLineColor2.value.setHSL(Math.random() * 255, Math.random() * 255, Math.random() * 255)
  hatchingMaterial2.uniforms.uLineColor3.value.setHSL(Math.random() * 255, Math.random() * 255, Math.random() * 255)
  hatchingMaterial2.uniforms.uLineColor4.value.setHSL(0.1, 0.8, 0.5)
  dottedMaterial2.uniforms.uBaseColor.value.setRGB(0.3, 0.4, 0.3)
  dottedMaterial2.uniforms.uLineColor1.value.setHSL(0.05, 1.0, 0.5)

  texture = THREE.ImageUtils.loadTexture('../../textures/waternormals.jpg')
  texture.wrapS = texture.wrapT = THREE.RepeatWrapping
  materials = 
    'chrome':
      m: new THREE.MeshPhongMaterial(
        color: "#FF0000"
        specular: "#FAF0E6"
        envMap: reflectionCube
        combine: THREE.MixOperation
        reflectivity: 0.6
        metal:true)
      h: 1
      s: 1
      l: 0
    'liquid':
      m: new THREE.MeshPhongMaterial(
        color:"#F0F1FF"
        specular: "#FFFF00"
        envMap: refractionCube
        combine: THREE.MixOperation
        reflectivity: 0.8
        metal:true)
      h: 1
      s: 0
      l: 1
    'shiny':
      m: new THREE.MeshPhongMaterial(
        color: "#00BFFF"
        specular: "#00BFFF"
        envMap: reflectionCube
        combine: THREE.MixOperation
        reflectivity: 0.3
        metal: true)
      h: 0
      s: 0.8
      l: 0.2
    'matte':
      m: new THREE.MeshPhongMaterial(
        color: "#FF6347"
        specular: 0x111111
        shininess: 1)
      h: 0
      s: 0
      l: 1
    'flat':
      m: new THREE.MeshPhongMaterial(
        color: "#FFFFF0"
        specular: 0x111111
        shininess: 1
        shading: THREE.FlatShading)
      h: 0
      s: 0
      l: 1
    'textured':
      m: new THREE.MeshPhongMaterial(
        color: "#00BFFF"
        specular: 0x111111
        shininess: 1
        map: texture)
      h: 0
      s: 0
      l: 1
    'colors':
      m: new THREE.MeshPhongMaterial(
        color: "#00FFFF"
        specular: 0xffffff
        shininess: 2
        vertexColors: THREE.VertexColors)
      h: 0
      s: 0
      l: 1
    'plastic':
      m: new THREE.MeshPhongMaterial(
        color: "#FFB6C1"
        specular: 0x888888
        shininess: 250)
      h: 0.6
      s: 0.8
      l: 0.1
    'toon1':
      m: toonMaterial1
      h: 0.2
      s: 1
      l: 0.75
    'toon2':
      m: toonMaterial2
      h: 0.4
      s: 1
      l: 0.75
    'hatching':
      m: hatchingMaterial
      h: Math.random()
      s: 1
      l: 0.9
    'hatching2':
      m: hatchingMaterial2
      h: 0.3
      s: 0.8
      l: 0.5
    'dotted':
      m: dottedMaterial
      h: 0.2
      s: 1
      l: 0.9
    'dotted2':
      m: dottedMaterial2
      h: 0.1
      s: 1
      l: 0.5
  materials

createShaderMaterial = (id, light, ambientLight) ->
  material = undefined
  
  shader = THREE.ShaderToon[id]
  u = THREE.UniformsUtils.clone(shader.uniforms)
  vs = shader.vertexShader
  fs = shader.fragmentShader
  material = new THREE.ShaderMaterial(
    uniforms: u
    vertexShader: vs
    fragmentShader: fs)
    
  material.uniforms.uDirLightPos.value = light.position
  material.uniforms.uDirLightColor.value = light.color
  material.uniforms.uAmbientLightColor.value = ambientLight.color
  material

#

setupGui = ->

  createHandler = (id) ->
    ->
      mat_old = materials[current_material]
      mat_old.h = m_h.getValue()
      mat_old.s = m_s.getValue()
      mat_old.l = m_l.getValue()
      current_material = id
      mat = materials[id]
      effect.material = mat.m
      m_h.setValue(mat.h)
      m_s.setValue(mat.s)
      m_l.setValue(mat.l)
      if current_material == 'textured'
        effect.enableUvs = true

      else
        effect.enableUvs = false

      if current_material == 'colors'
        effect.enableColors = true

      else
        effect.enableColors = false
      return

  effectController =
    material: 'flat'
    speed: 1
    numBlobs: 100
    resolution:40
    isolation: 80
    floor: false
    wallx: false
    wallz: false
    hue: 0.4
    saturation: 0.8
    lightness: 0.52
    lhue: 0.04
    lsaturation: 1.0
    llightness: 1.5
    lx: 0.5
    ly: 0.5
    lz: 1.0
    postprocessing: false
    dummy: ->
      h = undefined
      m_h = undefined
      m_s = undefined
      m_l = undefined
      return
      
  gui = new dat.GUI()

  # material (type)
  h = gui.addFolder('Materials')
  for m of materials
    effectController[m] = createHandler(m)
    h.add(effectController, m).name(m)


  # material (color)
  h = gui.addFolder('Material color')
  m_h = h.add(effectController, 'hue', 0.02, 1.0, 0.125)
  m_s = h.add(effectController, 'saturation', 0.0, 1.0, 0.025)
  m_l = h.add(effectController, 'lightness', 0.0,Math.random()*2, 0.025)

  # light (point)
  h = gui.addFolder('Point light color')
  h.add(effectController, 'lhue', 0.0, 1.0, 0.025).name 'hue'
  h.add(effectController, 'lsaturation', 0.0, 1.0, 0.025).name 'saturation'
  h.add(effectController, 'llightness', 0.0, 1.0, 0.025).name 'lightness'

  # light (directional)
  h = gui.addFolder('Directional light orientation')
  h.add(effectController, 'lx', -0.02, 1.0, 0.025).name 'x'
  h.add(effectController, 'ly', -1.0, 1.0, 0.025).name 'y'
  h.add(effectController, 'lz', -1.0, 1.0, 0.025).name 'z'

  # simulation
  h = gui.addFolder('Simulation')
  h.add(effectController, 'speed', 0.1, 50, 0.1) #0.1 to 500 step 0.3
  h.add(effectController, 'numBlobs', 1, 500, 1) #1 to 500 step 1
  h.add(effectController, 'resolution', 14, 40, 1)
  h.add(effectController, 'isolation', 10, 300, 1)
  h.add(effectController, 'floor')
  h.add(effectController, 'wallx')
  h.add(effectController, 'wallz')
  # rendering
  h = gui.addFolder('Rendering')
  h.add effectController, 'postprocessing'
  return

# this controls content of marching cubes voxel field

updateCubes = (object, time, numblobs, floor, wallx, wallz) ->
  object.reset()
  # fill the field with some metaballs
  i = undefined
  ballx = undefined
  bally = undefined
  ballz = undefined
  subtract = undefined
  strength = undefined
  subtract = 20.34
  strength = 1.2 / ((Math.sqrt(numblobs) - 1) / 3 + 1)

  for i in [0...numblobs]
    ballx = Math.cos(i + 1.26 * time * (1.03 + 0.5 * Math.sin(0.21 * i))) * 0.27 + 0.5
    bally = Math.sqrt(Math.sin(i + 1.12 * time * Math.cos(1.22 + 0.1424 * i))) * 0.77
    # dip into the floor
    ballz = Math.cos(i + 1.32 * time * 0.1 * Math.tan(0.92 + 0.53 * i )) * 0.27 + 0.5
    object.addBall(ballx, bally, ballz, strength, subtract)


  if floor
    object.addPlaneY(2, 12)
  if wallz
    object.addPlaneZ(2, 12)
  if wallx
    object.addPlaneX(2, 12)
  return



animate = ->
  requestAnimationFrame animate
  render()
  stats.update()
  return


render = ->
  delta = clock.getDelta()
  time += delta * effectController.speed * 0.1

  controls.update(delta)

  # marching cubes
  if effectController.resolution isnt resolution
    resolution = effectController.resolution
    effect.init(resolution)

  if effectController.isolation isnt effect.isolation
    effect.isolation = effectController.isolation

  updateCubes(effect, time, effectController.numBlobs, effectController.floor, effectController.wallx, effectController.wallz)

  # materials
  if effect.material instanceof THREE.ShaderMaterial
    if current_material == 'dotted2'
      effect.material.uniforms.uLineColor1.value.setHSL effectController.hue, effectController.saturation, effectController.lightness

    else if current_material == 'hatching2'
      u = effect.material.uniforms
      u.uLineColor1.value.setHSL(effectController.hue, effectController.saturation, effectController.lightness)
      u.uLineColor2.value.setHSL(effectController.hue, effectController.saturation, effectController.lightness)
      u.uLineColor3.value.setHSL(effectController.hue, effectController.saturation, effectController.lightness)
      u.uLineColor4.value.setHSL(effectController.hue + 1.2 % 1.0, effectController.saturation, effectController.lightness)

    else
      effect.material.uniforms.uBaseColor.value.setHSL(effectController.hue, effectController.saturation, effectController.lightness)

  else
    effect.material.color.setHSL(effectController.hue, effectController.saturation, effectController.lightness)

  # lights
  light.position.set(effectController.lx * Math.random() * 100, effectController.ly*Math.random() * 100, effectController.lz*Math.random() * 100)
  light.position.normalize()
  pointLight.color.setHSL effectController.lhue, effectController.lsaturation, effectController.llightness

  # render
  if effectController.postprocessing
    composer.render(delta)
  else
    renderer.clear()
    renderer.render scene, camera
  return

run = ->
  init()
  animate()
  return
  

run()
