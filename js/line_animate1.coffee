target = undefined
renderer = undefined
scene = undefined
line = undefined
tween = undefined
pos1 = undefined

#initialize canvas

initThree = ->
  canvasFrame = document.createElement('div')
  renderer = new THREE.WebGLRenderer()
  if not renderer
    alert("initialize three.js")
  renderer.setSize(window.innerWidth,window.innerHeight)
  document.body.appendChild(canvasFrame)
  canvasFrame.appendChild(renderer.domElement)
  renderer.setClearColor('black',1.0)
  scene = new THREE.Scene()

  return


#camera

camera = undefined

initCamera = ->
  camera = new THREE.PerspectiveCamera(60,window.innerWidth/window.innerHeight,1,10000)
  camera.position.z = 500
  return

###オブジェクト定義###

geometry = undefined
material = undefined
curve = undefined
pos = undefined
next = undefined

initObject = ->

  SUBDIVISIONS = 20
  geometry = new THREE.Geometry();
  
  pos = {x:0,y:0,z:0}
  next = {x:pos.x+1,y:pos.y,z : pos.z}

  
  ###
  curve = new THREE.QuadraticBezierCurve3()
  curve.v0 = new THREE.Vector3(0, 0, 0)
  curve.v1 = new THREE.Vector3(0, 100, 0)
  curve.v2 = new THREE.Vector3(0, 200, 0)

  for j in [0..20]
    geometry.vertices.push( curve.getPoint(j / SUBDIVISIONS) )
  ###
  
  geometry.vertices.push(pos)
  geometry.vertices.push(next)
  
  material = new THREE.LineBasicMaterial( { color: 0xffffff, linewidth: 50 } )
  line = new THREE.Line(geometry, material)
  scene.add(line)

  return


tweens = ->

  target = {x:400,y:0,z:0}
  tween = new TWEEN.Tween(line.position)
    .to(target,20000)
    .onUpdate(->
      line.geometry.verticesNeedUpdate = true;
      return)
    .start()

  return

animate = ->
  renderer.render(scene,camera)  
  requestAnimationFrame(animate)
  next.x += 1
  TWEEN.update()


  return

start = ->
  initThree()
  initCamera()
  initObject()
  tweens()
  animate()
  return

start()
