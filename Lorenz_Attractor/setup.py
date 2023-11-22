from distutils.core import setup, Extension
from Cython.Build import cythonize

ext = Extension("lorenz",
                sources=["lorenz.pyx", "lorenz.cpp"],
                language="c++")

setup(name="lorenz", ext_modules=cythonize(ext))

#setup(ext_modules=cythonize('lorenz.pyx'))
