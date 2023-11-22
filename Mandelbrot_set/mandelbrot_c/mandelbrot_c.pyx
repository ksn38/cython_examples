# distutils: extra_compile_args = -fopenmp
# distutils: extra_link_args = -fopenmp
# distutils: language = c++
import numpy as np


def calc_mand(double cond):
    cdef:
        double complex z
        double complex firstZ
        int row, col, i
        int resolution = 1440
        double x = -0.65 #place on grid
        double y = 0     #place on grid
        double scale = 3.4

    minX = x - scale / 2
    minY = y - scale / 2

    out_matrix = np.zeros((resolution, resolution), dtype=np.float64)

    for row in range(resolution):
        for col in range(resolution):
            z = minX + col * scale / resolution + (minY + row * scale / resolution) * 1j
            firstZ = z
            for i in range(50):
                z = z ** 2 + firstZ
                if z.real * z.real + z.imag * z.imag > cond:
                    break

            out_matrix[col,row] = i

    return out_matrix
