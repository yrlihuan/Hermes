#!/usr/bin/env python

from distutils.core import setup, Extension

cstorage = Extension('cstorage',
                    define_macros = [('MAJOR_VERSION', '1'),
                                     ('MINOR_VERSION', '0')],
                    include_dirs = ['../cpp'],
                    libraries = [],
                    library_dirs = [],
                    sources = ['py_cstorage.cpp', 'py_level2.cpp', '../cpp/level2.cpp'])

setup (name = 'cstorage',
       version = '1.0',
       description = 'serialize && deserialize csv data in c binary format',
       author = '',
       author_email = '',
       url = '',
       long_description = '',
       ext_modules = [cstorage])
