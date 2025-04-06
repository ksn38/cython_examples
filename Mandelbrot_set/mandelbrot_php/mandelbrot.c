#include <stdio.h>
#include <complex.h>
#include <stdlib.h>

//#define MAX_ITER 300
#define ESCAPE_RADIUS 4.0

void calc_mandelbrot(int resolution, double x, double y, double scale, int max_iter) {
    double complex z, firstZ;
    int row, col, i;
    double minX = x - scale / 2;
    double minY = y - scale / 2;

    // Бинарный вывод: сначала resolution (4 байта), затем данные
    fwrite(&resolution, sizeof(int), 1, stdout);

    for (row = 0; row < resolution; row++) {
        for (col = 0; col < resolution; col++) {
            z = (minX + col * scale / resolution) + (minY + row * scale / resolution) * I;
            firstZ = z;

            for (i = 0; i < max_iter; i++) {
                z = z * z + firstZ;
                if (creal(z) * creal(z) + cimag(z) * cimag(z) > ESCAPE_RADIUS) break;
            }

            double val = (double)i;
            fwrite(&val, sizeof(double), 1, stdout);
        }
    }
}

int main(int argc, char** argv) {
    if (argc != 6) {
        fprintf(stderr, "Usage: %s resolution center_x center_y scale\n", argv[0]);
        return 1;
    }
    
    calc_mandelbrot(atoi(argv[1]), atof(argv[2]), atof(argv[3]), atof(argv[4]), atof(argv[5]));
    return 0;
}
