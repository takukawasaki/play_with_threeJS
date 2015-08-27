
rnd = (x) ->
  Math.floor(Math.random() * x)

make_pos = (O,X,Y,Z) ->
  O.position.set(rnd(X),rnd(Y),rnd(Z))
  return
  
make_rotate = (O,X,Y,Z) ->
  O.rotation.set(rnd(X),rnd(Y),rnd(Z))

  return

cam_pos = (camera,X,Y,Z) ->
  camera.position.x = X
  camera.position.y = Y
  camera.position.z =Z
  return
