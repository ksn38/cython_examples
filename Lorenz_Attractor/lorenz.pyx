# distutils: language = c++
## distutils: sources = mt19937.cpp
from libcpp.vector cimport vector
#from cython cimport boundscheck, wraparound


#@boundscheck(False)
#@wraparound(False)
cdef tuple lorenz_cy(double x, y, z):
    """
    Given:
       x, y, z: a point of interest in three dimensional space
       s, r, b: parameters defining the lorenz attractor
    Returns:
       x_dot, y_dot, z_dot: values of the lorenz attractor's partial
           derivatives at the point x, y, z
    """
    cdef int s=10, r=28 
    cdef double b=2.667
    
    x_dot = s*(y - x)
    y_dot = r*x - y - x*z
    z_dot = x*y - b*z
    return x_dot, y_dot, z_dot

#@boundscheck(False)
#@wraparound(False)
cpdef tuple calc_to_arrs():
    cdef double dt = 0.01
    cdef int num_steps = 10000

    # Need one more for the initial values
    cdef vector[double] xs = range(num_steps + 1)
    cdef vector[double] ys = range(num_steps + 1)
    cdef vector[double] zs = range(num_steps + 1)

    # Set initial values
    xs[0], ys[0], zs[0] = (0., 1., 1.05)

    # Step through "time", calculating the partial derivatives at the current point
    # and using them to estimate the next point
    cdef int i
    for i in range(num_steps):
        x_dot, y_dot, z_dot = lorenz_cy(xs[i], ys[i], zs[i])
        xs[i + 1] = xs[i] + (x_dot * dt)
        ys[i + 1] = ys[i] + (y_dot * dt)
        zs[i + 1] = zs[i] + (z_dot * dt)
    return xs, ys, zs
