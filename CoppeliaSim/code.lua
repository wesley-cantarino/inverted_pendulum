-- x' = Ax + Bu
-- y = Cx
--
-- u = -kx

-- M = 2,7; m = 0.2351; g = 9,8; l = 0,3137;

if (sim_call_type == sim.syscb_init) then
  revoluteJointHandle = sim.getObjectHandle('revoluteJoint')
  sliderJointHandle = sim.getObjectHandle('sliderJoint')
  cartHandle = sim.getObjectHandle('cartV')
  pendulumHandle = sim.getObjectHandle('pendulumV')
  pendDummyHandle = sim.getObjectHandle('pendDummy')
  cartDummyHandle = sim.getObjectHandle('cartDummy')

  --lugar em que quero chegar
  y0 = {1 - 0.03, 0, math.pi, 0}
end



if (sim_call_type == sim.syscb_actuation) then
  --START -- Situação da planta
  x = sim.getJointPosition(sliderJointHandle)
  xdot, gar = sim.getObjectVelocity(cartHandle)

  th = sim.getJointPosition(revoluteJointHandle)
  thdot, gar = sim.getObjectVelocity(pendDummyHandle)

  pendVel = sim.getObjectVelocity(pendDummyHandle)
  pendPos = sim.getObjectPosition(pendDummyHandle, - 1)
  cartVel = sim.getObjectVelocity(cartDummyHandle)
  cartPos = sim.getObjectPosition(cartDummyHandle, - 1)

  pendVelwrtCart = {pendVel[1] - cartVel[1], pendVel[3] - cartVel[3]}
  pendPoswrtCart = {pendPos[1] - cartPos[1], pendPos[3] - cartPos[3]}

  omega = (pendPoswrtCart[1] * pendVelwrtCart[2] - pendPoswrtCart[2] * pendVelwrtCart[1]) / (pendPoswrtCart[1]^2 + pendPoswrtCart[2]^2)

  x = x
  xdot = cartVel[1]
  th = th + math.pi
  thdot = omega
  --planta estado
  print(x, xdot, th, thdot)

  --END -- Situação da planta


  --ganho k
  k = { - 31.6228, - 118.9923, 200.9721, 70.7427}

  -- u = -k*x   onde x é a planta estado
  u = k[1] * (x - y0[1]) + k[2] * (xdot - y0[2]) + k[3] * (th - y0[3]) + k[4] * (thdot - y0[4])

  --applicar forca -u no carro
  sim.addForce(cartHandle, {0, 0, 0}, {0, - u, 0})


  --distorcao
  if ((x - y0[1]) < 0.01) then
    sim.addForce(cartHandle, {0, 0, 0}, {0, 1, 0})
  end
end


if (sim_call_type == sim.syscb_sensing) then

end


if (sim_call_type == sim.syscb_cleanup) then

end
