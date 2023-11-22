# distutils: extra_compile_args = -fopenmp
# distutils: extra_link_args = -fopenmp
# distutils: language = c++
import numpy as np
from libcpp.vector cimport vector

from cython cimport boundscheck, wraparound
from cython.parallel cimport prange


def calc_mand(int resolution, int precision, double scale, double x, double y, double exp):
    cdef:
        double complex z, firstZ
        int row, col, i

    minX = x - scale / 2
    minY = y - scale / 2

    #counts = np.zeros((resolution, resolution), dtype=np.float64)
    counts = np.zeros((resolution, resolution), dtype=np.complex_)

    for row in range(resolution):
        for col in range(resolution):
            z = minX + col * scale / resolution + (minY + row * scale / resolution) * 1j
            firstZ = z
            for i in range(precision + 1):
                z = z ** exp + firstZ
                if z.real * z.real + z.imag * z.imag > 4:
                    break
            
            counts[col][row] = z
            
    return counts
