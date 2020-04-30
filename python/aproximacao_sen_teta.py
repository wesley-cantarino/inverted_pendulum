import numpy as np
import matplotlib.pyplot as plot

teta = np.arange(-np.pi/6, np.pi/6, 0.1)

seno = np.sin(teta)
err = teta - seno

plot.plot(teta, seno)
plot.plot(teta, err)

plot.title('Sine ~= teta')
plot.xlabel('angle')
plot.ylabel('sin')

plot.grid(True, which='both')
plot.axhline(y=0, color='k')

plot.show()