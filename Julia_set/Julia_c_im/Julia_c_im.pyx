# distutils: extra_compile_args = -fopenmp
# distutils: extra_link_args = -fopenmp

from cython cimport boundscheck, wraparound
from cython.parallel cimport prange

import numpy as np

cdef inline double norm2(double complex z) nogil:
    return z.real * z.real + z.imag * z.imag

cdef double escape(double complex z,
                double complex c,
                double z_max,
                int n_max) nogil:

    cdef:
        int i = 0
        double z_max2 = z_max * z_max

    while norm2(z) < z_max2 and i < n_max:
        z = z * z + c
        i += 1

    return z.imag

@boundscheck(False)
@wraparound(False)
def calc_julia(double complex c, double bound=2.1, double z_max=4.0, int n_max=1000):
    cdef:
        double step = 2.0 * bound / 1440
        int i, j
        double complex z
        double real, imag
        double [:, ::1] counts

    counts = np.zeros((2560 + 1, 1440 + 1), dtype=np.double)

    for i in prange(2560 + 1, nogil=True, schedule='static', chunksize=1):
        real = -bound - 1.1 + i * step
        for j in range(1440 + 1):
            imag = -bound + j * step
            z = real + imag * 1j
            counts[i,j] = escape(z, c, z_max, n_max)

    return counts

'''@boundscheck(False)
@wraparound(False)
def julia_fraction(int[:,::1] counts, int maxval=1000):
    cdef:
        int total = 0
        int i, j, N, M
    N = counts.shape[0]; M = counts.shape[1]

    for i in prange(N, nogil=True):
        for j in range(M):
            if counts[i,j] == maxval:
                total += 1
    return total / float(counts.size)'''
