from distutils.core import setup, Extension
from Cython.Build import cythonize

ext = Extension("mandelbrot_compl_cond",
                sources=["mandelbrot_compl_cond.pyx", "mandelbrot_compl_cond.cpp"],
                language="c++")

setup(name="mandelbrot_compl_cond", ext_modules=cythonize(ext))

#setup(name="julia", ext_modules=cythonize("julia.pyx"))
