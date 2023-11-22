from distutils.core import setup, Extension
from Cython.Build import cythonize

ext = Extension("mandelbrot2",
                sources=["mandelbrot2.pyx", "mandelbrot2.cpp"],
                language="c++")

setup(name="mandelbrot2", ext_modules=cythonize(ext))

#setup(name="julia", ext_modules=cythonize("julia.pyx"))
