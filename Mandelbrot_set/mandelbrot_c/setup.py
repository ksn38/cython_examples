from distutils.core import setup, Extension
from Cython.Build import cythonize

ext = Extension("mandelbrot_c",
                sources=["mandelbrot_c.pyx", "mandelbrot_c.cpp"],
                language="c++")

setup(name="mandelbrot_c", ext_modules=cythonize(ext))

#setup(name="julia", ext_modules=cythonize("julia.pyx"))
