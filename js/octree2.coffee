camera = undefined
scene = undefined
renderer = undefined
octree = undefined
geometry = undefined
material = undefined
mesh = undefined
meshes = []
meshesSearch = []
meshCountMax = 1000
radius = 500
radiusMax = radius * 200
radiusMaxHalf = radiusMax * 0.8
radiusSearch = 400
searchMesh = undefined
baseR = 40
baseG = 100
baseB = 225
foundR = 30
foundG = 100
foundB = 200
adding = true
rayCaster = new THREE.Raycaster()
origin = new THREE.Vector3()
direction = new THREE.Vector3()

init = ->
  container = document.createElement('div')
  # standard three scene, camera, renderer
  scene = new THREE.Scene()
  renderer = new THREE.WebGLRenderer()
  renderer.setClearColor('#2F4F4F')
  renderer.setPixelRatio(window.devicePixelRatio)
  renderer.setSize(window.innerWidth, window.innerHeight)
  document.body.appendChild(container)
  container.appendChild(renderer.domElement)

  return

#initialize camera

initCamera = ->
  camera = new THREE.PerspectiveCamera(85, window.innerWidth / window.innerHeight, 1, radius * 10000)
  scene.add(camera)
  cam_pos(camera,rnd(1400),rnd(3000),rnd(5000))
  make_rotate(camera,1300,1500,1400)
  
  return

initOctree = ->
  octree = new THREE.Octree(
    undeferred: false
    depthMax: Infinity
    objectsThreshold: 4
    overlapPct: 0.45
    scene: scene)

  # create object to show search radius and add to scene
  searchMesh = new THREE.Mesh(new THREE.SphereGeometry(radiusSearch,10,10), new THREE.MeshBasicMaterial(
    color: '#7CFC00'
    transparent: true
    opacity: 0.8))
  scene.add(searchMesh)
  return
  
  
animate = ->
  
  requestAnimationFrame(animate)
  # modify octree structure by adding/removing objects
  modifyOctree()
  # search octree at random location
  searchOctree()
  # render results
  render()
  # update octree to add deferred objects
  octree.update()
  return

modifyOctree = ->
  # if is adding objects to octree
  if adding == true
    # create new object
    geometry = new THREE.SphereGeometry(40, 10, 10)
    material = new THREE.MeshBasicMaterial()
    material.color.setRGB(baseR, baseG, baseB)
    mesh = new THREE.Mesh(geometry, material)
    # give new object a random position in radius
    mesh.position.set(Math.random() * radiusMax + 1000 - radiusMaxHalf, Math.random() * radiusMax - radiusMaxHalf + 300, Math.random() * radiusMax - radiusMaxHalf + 400)
    # add new object to octree and scene
    octree.add(mesh)
    scene.add(mesh)
    # store object for later
    meshes.push(mesh)
    # if at max, stop adding
    if meshes.length == meshCountMax
      adding = false
  else
    # get object
    mesh = meshes.shift()
    # remove from scene and octree
    scene.remove(mesh)
    octree.remove(mesh)
    # if no more objects, start adding
    if meshes.length == 0
      adding = true

  return

searchOctree = ->
  i = undefined
  il = undefined
  # revert previous search objects to base color
  i = 0
  il = meshesSearch.length
  while i < il
    meshesSearch[i].object.material.color.setRGB(baseR, baseG, baseB)
    i++

  # new search position
  searchMesh.position.set(Math.random() * radiusMax - radiusMaxHalf, Math.random() * radiusMax - radiusMaxHalf, Math.random() * radiusMax - radiusMaxHalf )
  # record start time

  timeStart = Date.now()

  origin.copy(searchMesh.position)
  direction.set(Math.random() * 2 - 1, Math.random() * 2 - 1, Math.random() * 2 - 1).normalize()
  rayCaster.set(origin, direction)
  meshesSearch = octree.search(rayCaster.ray.origin, radiusSearch, true, rayCaster.ray.direction)
  intersections = rayCaster.intersectOctreeObjects(meshesSearch)
  # record end time
  timeEnd = Date.now()
  # set color of all meshes found in search
  i = 0
  il = meshesSearch.length
  while i < il
    meshesSearch[i].object.material.color.setRGB(foundR, foundG, foundB)
    i++


  return

render = ->
  timer = -Date.now() / 8000
  camera.position.x = Math.cos(timer) * 400
  camera.position.z = Math.cos(timer) * 90000
  camera.position.y = Math.tan(timer) * 7000
  camera.lookAt(scene.position)
  renderer.render(scene, camera)
  return


start = ->
  init()
  initCamera()
  initOctree()
  animate()
  return

start()  
