mesh = undefined
container = undefined
canvas = undefined
context = undefined
texture = undefined
camera = undefined
scene  = undefined
renderer = undefined
geometry = undefined
material = undefined
obj = [0..100]
group = undefined


initCamera = ->
  camera = new THREE.PerspectiveCamera(45,window.innerWidth/window.innerHeight,1,10000)
  camera.position.z = 400
  
  return

init = ->
  container = document.createElement('div')
  document.body.appendChild(container)
  scene = new THREE.Scene()
  group = new THREE.Group()
  group.position.y = 50
  group.position.x = Math.random() * 100
  scene.add(group)
  renderer = new THREE.WebGLRenderer()
  renderer.setClearColor("#FF7F50")
  renderer.setPixelRatio(window.devicePixelRatio)
  renderer.setSize(window.innerWidth,window.innerHeight)
  container.appendChild(renderer.domElement)

  return



initObject = ->
  geometry = new THREE.BoxGeometry(Math.random() * 10,Math.random() * 70,Math.random() * 200)
  texture = new THREE.Texture(createImage())
  texture.needsUpdate = true
  
  material = new THREE.MeshBasicMaterial(
    map: texture
    wireframe: false)

  for i,index in obj
    obj[index] =  new THREE.Mesh(geometry,material)
    group.add(obj[index])
    #scene.add(obj[index])
    geometry.dispose()
    material.dispose()
    texture.dispose()

  return


createImage = ->
  canvas = document.createElement('canvas')
  canvas.width = 250 * Math.random() 
  canvas.height = 750 * Math.random()

  context = canvas.getContext('2d')
  context.fillStyle = 'rgb(' + Math.floor(Math.random() * 156) + ',' + Math.floor(Math.random() * 256) + ',' + Math.floor(Math.random() * 256) + ')'

  context.fillRect(0,0,106,156)

  return canvas


render = ->

  for i ,index in obj
    make_pos(i,rnd(-100),rnd(-100),rnd(150))
    make_rotate(i,rnd(2000) ,rnd(-1000),rnd(1000))
    make_pos(group,rnd(-10),rnd(-10),rnd(0))
    make_rotate(group,rnd(1200),rnd(1200),rnd(1200))
    #cam_pos(camera,rnd(0),rnd(0),rnd(1000) * 2)
    make_rotate(camera,1,1,1)
    renderer.render(scene,camera)


    
  return

initStats = ->
  stats = new Stats()
  stats.domElement.style.position = 'absolute'
  stats.domElement.style.top = '0px'
  container.appendChild( stats.domElement )
  return

  
animate = ->
  requestAnimationFrame(animate)
  render()

  return



run = ->
  initCamera()
  init()
  initObject()
  initStats()
  animate()
  return

run()  
