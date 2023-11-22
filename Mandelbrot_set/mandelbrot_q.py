import numpy as np
import matplotlib.pyplot as plt
import time
import mandelbrot_q

t1 = time.time()
#mb = mandelbrot.calc_mand(720, 2720, 0.0001, -0.745, 0.13, 2)
mq = mandelbrot_q.calc_mand(100, 50, 3.4, -0.65, 0)
print ("time:", time.time() - t1)

fig, ax = plt.subplots()
fig.set_size_inches(10, 10)
ax = fig.add_subplot(projection='3d')

x = np.linspace(0, 2, 100)
y = np.linspace(0, 2, 100)
X, Y = np.meshgrid(x, y)
#ax.plot(mq[ 50, 50, :, 50], mq[ 50, 50, 50, :], mq[ :, 50, 50, 50], lw=0.5)
ax.plot_surface(X, Y, mq[ :, :, 50, 50])
ax.set_xlabel("X Axis")
ax.set_ylabel("Y Axis")
ax.set_zlabel("Z Axis")

plt.show()
