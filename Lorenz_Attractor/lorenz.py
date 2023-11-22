import numpy as np
from lorenz import calc_to_arrs
import timeit


def lorenz_py():
    def lorenz(x, y, z, s=10, r=28, b=2.667):
        """
        Given:
           x, y, z: a point of interest in three dimensional space
           s, r, b: parameters defining the lorenz attractor
        Returns:
           x_dot, y_dot, z_dot: values of the lorenz attractor's partial
               derivatives at the point x, y, z
        """
        x_dot = s*(y - x)
        y_dot = r*x - y - x*z
        z_dot = x*y - b*z
        return x_dot, y_dot, z_dot


    dt = 0.01
    num_steps = 10000

    # Need one more for the initial values
    xs = np.empty(num_steps + 1)
    ys = np.empty(num_steps + 1)
    zs = np.empty(num_steps + 1)

    # Set initial values
    xs[0], ys[0], zs[0] = (0., 1., 1.05)

    # Step through "time", calculating the partial derivatives at the current point
    # and using them to estimate the next point
    for i in range(num_steps):
        x_dot, y_dot, z_dot = lorenz(xs[i], ys[i], zs[i])
        xs[i + 1] = xs[i] + (x_dot * dt)
        ys[i + 1] = ys[i] + (y_dot * dt)
        zs[i + 1] = zs[i] + (z_dot * dt)
        
    return xs, ys, zs

result = calc_to_arrs()

'''# Plot
import matplotlib.pyplot as plt

ax = plt.figure().add_subplot(projection='3d')

ax.plot(result[0], result[1], result[2], lw=0.5)
ax.set_xlabel("X Axis")
ax.set_ylabel("Y Axis")
ax.set_zlabel("Z Axis")
ax.set_title("Lorenz Attractor")

plt.show()'''

print('py', timeit.timeit(stmt="lorenz_py()", setup='from __main__ import lorenz_py', number=100))
print('cy', timeit.timeit(stmt="calc_to_arrs()", setup='from __main__ import calc_to_arrs', number=100))

if __name__ == '__main__':
   import cProfile
   cProfile.run('lorenz_py', sort='time')
   cProfile.run('calc_to_arrs()', sort='time')


   
