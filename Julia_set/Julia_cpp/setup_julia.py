from distutils.core import setup, Extension
from Cython.Build import cythonize

ext = Extension("julia",
                sources=["julia.pyx", "julia.cpp"],
                language="c++")

setup(name="julia", ext_modules=cythonize(ext))

#setup(name="julia", ext_modules=cythonize("julia.pyx"))
