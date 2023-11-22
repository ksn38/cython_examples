from distutils.core import setup, Extension
from Cython.Build import cythonize

ext = Extension("mandelbrot_image_circle",
                sources=["mandelbrot_image_circle.pyx", "mandelbrot_image_circle.cpp"],
                language="c++")

setup(name="mandelbrot_image_circle", ext_modules=cythonize(ext))

#setup(name="julia", ext_modules=cythonize("julia.pyx"))
