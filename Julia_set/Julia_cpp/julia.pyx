# distutils: extra_compile_args = -fopenmp
# distutils: extra_link_args = -fopenmp
# distutils: language = c++
from libcpp.vector cimport vector

from cython cimport boundscheck, wraparound
from cython.parallel cimport prange


cdef inline double norm2(double complex z) nogil:
    return z.real * z.real + z.imag * z.imag


cdef int escape(double complex z,
                double complex c,
                double z_max,
                int n_max) nogil:

    cdef:
        int i = 0
        double z_max2 = z_max * z_max

    while norm2(z) < z_max2 and i < n_max:
        z = z * z + c
        i += 1

    return i


@boundscheck(False)
@wraparound(False)
def calc_julia(int resolution, double complex c,
               double bound=2.8, double z_max=4.0, int n_max=1000):

    cdef:
        double step = 2.0 * bound / resolution
        int i, j
        double complex z
        double real, imag
        
    cdef vector[vector[int]] counts
    cdef vector[int] counts_inside = range(resolution + 1)
    
    for i in range(resolution + 1):
        counts.push_back(counts_inside)
    
    for i in prange(resolution + 1, nogil=True, schedule='static' ,chunksize=1):
        real = -bound + i * step
        for j in range(resolution + 1):
            imag = -bound + j * step
            z = real + imag * 1j
            counts[i][j] = escape(z, c, z_max, n_max)

    return counts

'''@boundscheck(True)
@wraparound(True)
def julia_fraction(vector[vector[int]] counts, int maxval=1000):
    cdef:
        int total = 0
        int i, j, N, M
    N = counts[0].size(); M = counts[1].size()

    for i in prange(N, nogil=True):
        for j in range(M):
            if counts[i][j] == maxval:
                total += 1
    return total / float(counts.size)'''
