from distutils.core import setup, Extension
from Cython.Build import cythonize

ext = Extension("julia_quaternion2",
                sources=["julia_quaternion2.pyx", "julia_quaternion2.cpp"],
                language="c++")

setup(name="julia_quaternion2", ext_modules=cythonize(ext))

#setup(name="julia", ext_modules=cythonize("julia.pyx"))
