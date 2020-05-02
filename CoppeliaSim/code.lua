-- DO NOT WRITE CODE OUTSIDE OF THE if-then-end SECTIONS BELOW!! (unless the code is a function definition)

if (sim_call_type == sim.syscb_init) then

  -- Put some initialization code here


  --simRemoteApi.start(19999)
  revoluteJointHandle = sim.getObjectHandle('revoluteJoint')
  sliderJointHandle = sim.getObjectHandle('sliderJoint')
  cartHandle = sim.getObjectHandle('cartV')
  pendulumHandle = sim.getObjectHandle('pendulumV')
  pendDummyHandle = sim.getObjectHandle('pendDummy')
  cartDummyHandle = sim.getObjectHandle('cartDummy')



  -- Make sure you read the section on "Accessing general-type objects programmatically"
  -- For instance, if you wish to retrieve the handle of a scene object, use following instruction:
  --
  -- handle=sim.getObjectHandle('sceneObjectName')
  --
  -- Above instruction retrieves the handle of 'sceneObjectName' if this script's name has no '#' in it
  --
  -- If this script's name contains a '#' (e.g. 'someName#4'), then above instruction retrieves the handle of object 'sceneObjectName#4'
  -- This mechanism of handle retrieval is very convenient, since you don't need to adjust any code when a model is duplicated!
  -- So if the script's name (or rather the name of the object associated with this script) is:
  --
  -- 'someName', then the handle of 'sceneObjectName' is retrieved
  -- 'someName#0', then the handle of 'sceneObjectName#0' is retrieved
  -- 'someName#1', then the handle of 'sceneObjectName#1' is retrieved
  -- ...
  --
  -- If you always want to retrieve the same object's handle, no matter what, specify its full name, including a '#':
  --
  -- handle=sim.getObjectHandle('sceneObjectName#') always retrieves the handle of object 'sceneObjectName'
  -- handle=sim.getObjectHandle('sceneObjectName#0') always retrieves the handle of object 'sceneObjectName#0'
  -- handle=sim.getObjectHandle('sceneObjectName#1') always retrieves the handle of object 'sceneObjectName#1'
  -- ...
  --
  -- Refer also to simGetCollisionhandle, sim.getDistanceHandle, sim.getIkGroupHandle, etc.
  --
  -- Following 2 instructions might also be useful: sim.getNameSuffix and sim.setNameSuffix
end



if (sim_call_type == sim.syscb_actuation) then

  -- Put your main ACTUATION code here
  --sim.addForce(cartHandle,{0,0,0},{0,0,40})
  -- For example:



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

  y0 = {0, 0, math.pi, 0}

  x = x
  xdot = cartVel[1]
  th = th + math.pi
  thdot = omega






  print(x, xdot, th, thdot)

  k = { - 31.6228, - 118.9923, 200.9721, 70.7427}
  u = k[1] * (x - y0[1]) + k[2] * (xdot - y0[2]) + k[3] * (th - y0[3]) + k[4] * (thdot - y0[4])

  error = tonumber(string.format("%."..(4 or 0).."f", (y0[1] - x)))
  --sim.displayDialog("mesageBox",u..']['..x..'] ['..xdot..'] ['..th..']['..thdot,sim.dlgstyle_message,NULL,NULL,NULL,NULL)
  --sim.displayDialog("Message",'Set Point: '..y0[1]..'     '..'Error: '..error,sim.dlgstyle_message,NULL,NULL,NULL,NULL)


  t = sim.getSystemTime()

  sim.addForce(cartHandle, {0, 0, 0}, {0, - u, 0})



  --sim.addForce(cartHandle,{0,0,0},{0,-20*(cartVel[1]),0})
  --sim.pauseSimulation()
  --String
  -- local position=sim.getObjectPosition(handle,-1)
  -- position[1]=position[1]+0.001
  -- sim.setObjectPosition(handle,-1,position)

end


if (sim_call_type == sim.syscb_sensing) then

  -- Put your main SENSING code here
  --x=sim.getJointPosition(sliderJointHandle)
  --xdot=sim.getJointTargetVelocity(sliderJointHandle)
  --th=sim.getJointPosition(revoluteJointHandle)
  --thdot=sim.getJointTargetVelocity(revoluteJointHandle)
end


if (sim_call_type == sim.syscb_cleanup) then

  -- Put some restoration code here

end
