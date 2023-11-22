from distutils.core import setup, Extension
from Cython.Build import cythonize

ext = Extension("mandelbrot_q",
                sources=["mandelbrot_q.pyx", "mandelbrot_q.cpp"],
                language="c++")

setup(name="mandelbrot_q", ext_modules=cythonize(ext))

#setup(name="julia", ext_modules=cythonize("julia.pyx"))
