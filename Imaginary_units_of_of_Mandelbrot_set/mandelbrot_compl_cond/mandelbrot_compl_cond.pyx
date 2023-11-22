# distutils: extra_compile_args = -fopenmp
# distutils: extra_link_args = -fopenmp
# distutils: language = c++
import numpy as np
from libcpp.vector cimport vector

from cython cimport boundscheck, wraparound
from cython.parallel cimport prange


def calc_mand(double cond, int resolution, int precision, double scale, double x, double y):
    cdef:
        double complex z
        int row, col, i

    minX = x - scale / 2
    minY = y - scale / 2

    '''cdef vector[vector[double complex]] counts
    cdef vector[double complex] counts_inside = range(resolution)
    for i in range(resolution):
        counts.push_back(counts_inside)'''
        
    counts = np.zeros((resolution, resolution), dtype=np.complex_)

    for row in range(resolution):
        for col in range(resolution):
            z = minX + col * scale / resolution + (minY + row * scale / resolution) * 1j
            firstZ = z
            for i in range(precision + 1):
                z = z * z + firstZ
                if z.real * z.real + z.imag * z.imag > cond:
                    break
            
            counts[col][row] = z
            
    return counts
