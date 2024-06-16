from distutils.core import setup
from Cython.Build import cythonize

setup(name="Julia_c_im",
      ext_modules=cythonize("Julia_c_im.pyx"))
