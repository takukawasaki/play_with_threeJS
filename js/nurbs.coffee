container = undefined
stats = undefined
camera = undefined
scene = undefined
renderer = undefined
group = undefined

targetRotation = 0
targetRotationOnMouseDown = 0

mouseX = 0
mouseXOnMouseDown = 0

windowHalfX = window.innerWidth /2
windowHalfY = window.innerHeight / 2



init = ->

  container = document.createElement('div')
  document.body.appendChild(container)

  info = document.createElement('div')
  info.style.position = 'absolute'
  info.style.top = '30px'
  info.style.width = '100%'
  info.style.textAlign = 'center'
  info.innerHTML = 'Drag to spin'
  container.appendChild(info)

  camera = new THREE.PerspectiveCamera(50,window.innerWidth/window.innerHeight,1,10000)
  camera.position.set(Math.random() * 1000,Math.random()* 1050,Math.random()*5000)

  scene = new THREE.Scene
  group = new THREE.Group()
  group.position.y = 50
  group.position.x = Math.random() * 1000
  scene.add(group)

  nurbsControlPoints = []
  nurbsKnots = []
  nurbsDegree = 60
  
  for i in [0..3]
    nurbsKnots.push(0)
  for i in [0..200]
    j = 200
    nurbsControlPoints.push(new THREE.Vector4(Math.random() * 400 -200,Math.random() * 400 ,Math.random() * 400 - 20, 1))
    knot = (i + 1) / (j - nurbsDegree)
    nurbsKnots.push(THREE.Math.clamp(knot,0,1))

  nurbsCurve = new THREE.NURBSCurve(nurbsDegree,nurbsKnots,nurbsControlPoints)

  nurbsGeometry = new THREE.Geometry()

  nurbsGeometry.vertices = nurbsCurve.getPoints( 200 )
  nurbsMaterial = new THREE.LineBasicMaterial( { linewidth: 1, color: 0x333333 } )
  i = 1
  while i is true
    x = 0
    y = 0
    z = 0
    nurbsLine = new THREE.Line( nurbsGeometry, nurbsMaterial )
    nurbsLine.position.set( x, y, z )
    x += Math.sin(38)
    y += Math.sin(20)
    z += Math.sin(10)
    
  nurbsControlPointsGeometry = new THREE.Geometry()
  nurbsControlPointsGeometry.vertices = nurbsCurve.controlPoints
  nurbsControlPointsMaterial = new THREE.LineBasicMaterial( { linewidth: 1, color: 0x333333, opacity: 1.8 } )

  nurbsControlPointsLine = new THREE.Line( nurbsControlPointsGeometry, nurbsControlPointsMaterial )


  group.add( nurbsLine, nurbsControlPointsLine )


  renderer = new THREE.CanvasRenderer()
  renderer.setClearColor( 0xf0f0f0 )
  renderer.setPixelRatio( window.devicePixelRatio )
  renderer.setSize( window.innerWidth, window.innerHeight )
  container.appendChild( renderer.domElement )

  stats = new Stats()
  stats.domElement.style.position = 'absolute'
  stats.domElement.style.top = '0px'
  container.appendChild( stats.domElement )

  document.addEventListener( 'mousedown', onDocumentMouseDown, false )
  document.addEventListener( 'touchstart', onDocumentTouchStart, false )
  document.addEventListener( 'touchmove', onDocumentTouchMove, false )

  window.addEventListener('resize',onWindowResize,false)

  return
  

onWindowResize = ->
  windowHalfX = window.innerWidth / 2
  windowHalfY = window.innerHeight / 2

  camera.aspect = window.innerWidth / window.innerHeight
  camera.updateProjectionMatrix()

  renderer.setSize( window.innerWidth, window.innerHeight )
  return

onDocumentMouseDown = (event) ->

  event.preventDefault()

  document.addEventListener( 'mousemove', onDocumentMouseMove, false )
  document.addEventListener( 'mouseup', onDocumentMouseUp, false )
  document.addEventListener( 'mouseout', onDocumentMouseOut, false )

  mouseXOnMouseDown = event.clientX - windowHalfX
  targetRotationOnMouseDown = targetRotation
  return

onDocumentMouseMove = (event) ->

  mouseX = event.clientX - windowHalfX

  targetRotation = targetRotationOnMouseDown + ( mouseX - mouseXOnMouseDown ) * 0.02
  return

onDocumentMouseUp = (event) ->
  document.removeEventListener( 'mousemove', onDocumentMouseMove, false )
  document.removeEventListener( 'mouseup', onDocumentMouseUp, false )
  document.removeEventListener( 'mouseout', onDocumentMouseOut, false )

  return

onDocumentMouseOut = (event) ->
  
  document.removeEventListener( 'mousemove', onDocumentMouseMove, false )
  document.removeEventListener( 'mouseup', onDocumentMouseUp, false )
  document.removeEventListener( 'mouseout', onDocumentMouseOut, false )
  return


onDocumentTouchStart = (event) ->
  if event.touches.length is 1
    event.preventDefault()
    mouseXOnMouseDown = event.touches[0].pageX - windowHalfX
    targetRotationOnMouseDown = targetRotation

  return

onDocumentTouchMove = (event) ->
  if ( event.touches.length == 1 ) 

    event.preventDefault()

    mouseX = event.touches[ 0 ].pageX - windowHalfX
    targetRotation = targetRotationOnMouseDown + ( mouseX - mouseXOnMouseDown ) * 0.05
    return


animate = ->
  requestAnimationFrame(animate)

  render()
  stats.update()
  return

render = ->

  group.rotation.y += (targetRotation - group.rotation.y) * 0.05
  renderer.render(scene,camera)

  return
  
      
    
init()
animate()
