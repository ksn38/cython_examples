# The original, non-parallelized version.

from cython cimport boundscheck, wraparound
from pyquaternion import Quaternion
import numpy as np

cdef inline double norm2(z):
    #return z.real * z.real + z.imag * z.imag
    return z[0] * z[0] + z[1] * z[1] + z[2] * z[2]


'''cdef int escape(double complex z,
                double complex c,
                double z_max,
                int n_max) nogil:

    cdef:
        int i = 0
        double z_max2 = z_max * z_max

    while norm2(z) < z_max2 and i < n_max:
        z = z * z + c
        i += 1

    return i'''


def calc_julia(int resolution, double complex c,
               double bound=1.5, double z_max=4.0, int n_max=1000):

    cdef:
        double step = 2.0 * bound / resolution
        int i, j
        double complex z
        double real, imag
        #int[:, ::1] counts

    counts = np.zeros((resolution+1, resolution+1, resolution+1, resolution+1), dtype=np.int32)

    for r in range(resolution + 1):
        real = -bound + r * step
        for i in range(resolution + 1):
            imag_i = -bound + i * step
            for j in range(resolution + 1):
                imag_j = -bound + j * step
                z = Quaternion(real, imag_i, imag_j, 0)
                counter = 0
                while norm2(z) < (z_max * z_max) and counter < n_max:
                    z = z ** 2 + c
                    counter += 1

                counts[r, i, j] = counter
                
        return np.asarray(counts)


