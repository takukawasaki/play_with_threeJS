Boid = ->
  vector = new THREE.Vector3()
  _acceleration = undefined
  _width = 500
  _height = 500
  _depth = 700
  _goal = undefined
  _neighborhoodRadius = 800
  _maxSpeed = 6
  _maxSteerForce = 0.2
  _avoidWalls = false
  @position = new THREE.Vector3()
  @velocity = new THREE.Vector3()
  _acceleration = new THREE.Vector3()

  @setGoal = (target) ->
    _goal = target
    return

  @setAvoidWalls = (value) ->
    _avoidWalls = value
    return

  @setWorldSize = (width, height, depth) ->
    _width = width
    _height = height
    _depth = depth
    return

  @run = (boids) ->
    if _avoidWalls
      vector.set -_width, @position.y, @position.z
      vector = @avoid(vector)
      vector.multiplyScalar 5
      _acceleration.add vector
      vector.set _width, @position.y, @position.z
      vector = @avoid(vector)
      vector.multiplyScalar 5
      _acceleration.add vector
      vector.set @position.x, -_height, @position.z
      vector = @avoid(vector)
      vector.multiplyScalar 5
      _acceleration.add vector
      vector.set @position.x, _height, @position.z
      vector = @avoid(vector)
      vector.multiplyScalar 5
      _acceleration.add vector
      vector.set @position.x, @position.y, -_depth
      vector = @avoid(vector)
      vector.multiplyScalar 5
      _acceleration.add vector
      vector.set @position.x, @position.y, _depth
      vector = @avoid(vector)
      vector.multiplyScalar 5
      _acceleration.add vector

    else 

      this.checkBounds();

    
    

    if Math.random() > 0.7
      @flock boids
    @move()
    return

  @flock = (boids) ->
    if _goal
      _acceleration.add(@reach(_goal, 0.005))
    _acceleration.add(@alignment(boids))
    _acceleration.add(@cohesion(boids))
    _acceleration.add(@separation(boids))
    return

  @move = ->
    @velocity.add _acceleration
    l = @velocity.length()
    if l > _maxSpeed
      @velocity.divideScalar l / _maxSpeed
    @position.add(@velocity)
    _acceleration.set 0, 0, 0
    return

  @checkBounds = ->
    if @position.x > _width
      @position.x = -_width
    if @position.x < -_width
      @position.x = _width
    if @position.y > _height
      @position.y = -_height
    if @position.y < -_height
      @position.y = _height
    if @position.z > _depth
      @position.z = -_depth
    if @position.z < -_depth
      @position.z = _depth
    return

  #

  @avoid = (target) ->
    steer = new THREE.Vector3()
    steer.copy(@position)
    steer.sub(target)
    steer.multiplyScalar(1 / @position.distanceToSquared(target))
    steer

  @repulse = (target) ->
    distance = @position.distanceTo(target)
    if distance < 150
      steer = new THREE.Vector3()
      steer.subVectors @position, target
      steer.multiplyScalar 0.5 / distance
      _acceleration.add(steer)
    return

  @reach = (target, amount) ->
    steer = new THREE.Vector3()
    steer.subVectors target, @position
    steer.multiplyScalar amount
    steer

  @alignment = (boids) ->
    boid = undefined
    velSum = new THREE.Vector3()
    count = 0
    i = 0
    il = boids.length
    while i < il
      if Math.random() > 0.6
        i++
        continue
      boid = boids[i]
      distance = boid.position.distanceTo(@position)
      if distance > 0 and distance <= _neighborhoodRadius
        velSum.add boid.velocity
        count++
      i++
    if count > 0
      velSum.divideScalar count
      l = velSum.length()
      if l > _maxSteerForce
        velSum.divideScalar l / _maxSteerForce
    velSum

  @cohesion = (boids) ->
    boid = undefined
    distance = undefined
    posSum = new (THREE.Vector3)
    steer = new (THREE.Vector3)
    count = 0
    i = 0
    il = boids.length
    while i < il
      if Math.random() > 0.6
        i++
        continue
      boid = boids[i]
      distance = boid.position.distanceTo(@position)
      if distance > 0 and distance <= _neighborhoodRadius
        posSum.add boid.position
        count++
      i++
    if count > 0
      posSum.divideScalar count
    steer.subVectors posSum, @position
    l = steer.length()
    if l > _maxSteerForce
      steer.divideScalar l / _maxSteerForce
    steer

  @separation = (boids) ->
    boid = undefined
    distance = undefined
    posSum = new THREE.Vector3()
    repulse = new THREE.Vector3()
    i = 0
    il = boids.length
    while i < il
      if Math.random() > 0.6
        i++
        continue
      boid = boids[i]
      distance = boid.position.distanceTo(@position)
      if distance > 0 and distance <= _neighborhoodRadius
        repulse.subVectors @position, boid.position
        repulse.normalize()
        repulse.divideScalar distance
        posSum.add repulse
      i++
    posSum

  return
