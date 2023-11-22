# distutils: extra_compile_args = -fopenmp
# distutils: extra_link_args = -fopenmp
# distutils: language = c++
import numpy as np
#from libcpp.vector cimport vector

from cython cimport boundscheck, wraparound
from cython.parallel cimport prange


def calc_mand(int resolution, int precision, double scale, double r, double i):
    cdef:
        double j, k, imag_i, imag_j, imag_k, real
        int x, y, z, n, p

    minR = r - scale / 2
    minI = i - scale / 2
    minJ = minI
    minK = minI

    out_matrix = np.zeros((resolution, resolution, resolution, resolution), dtype=np.float64)

    for x in range(resolution):
        for y in range(resolution):
            for z in range(resolution):
                for n in range(resolution):
                    r = minR + x * scale / resolution
                    i = minI + y * scale / resolution
                    j = minJ + z * scale / resolution
                    k = minK + n * scale / resolution
                    oldR = r
                    oldI = i
                    oldJ = j
                    oldK = k
                    for p in range(precision + 1):
                        real = r*r - i*i - j*j - k*k #real component of z^2
                        imag_i = 2 * r * i #imaginary component of z^2
                        imag_j = 2 * r * j #imaginary component of z^2
                        imag_k = 2 * r * k #imaginary component of z^2
                        r = real + oldR #real component of new z
                        i = imag_i + oldI #imaginary component of new z
                        j = imag_j + oldJ #imaginary component of new z
                        k = imag_k + oldK #imaginary component of new z
                        if r*r + i*i + j*j + k*k > 4:
                            break

                    out_matrix[x, y, z, n] = p

    return out_matrix
