from Cython.Build import cythonize


from distutils.core import setup

setup(
    name="count_min_sketch",
    version="3.0.4",
    packages=['count_min_sketch/'],
    description="A fast and accurate Count-Min Sketch data structure.",
    author="Andrew Nystrom",
    author_email="AWNystrom@gmail.com",
    url="https://github.com/AWNystrom/CountMinSketch",
    keywords=["count", "min", "sketch", "fast", "pure"],
    license="Apache 2.0",
    long_description=open('README.md').read(),
    classifiers=["Programming Language :: Python",
                 "Programming Language :: Python :: 2.7",
                 "Programming Language :: Python :: 2",
                 "License :: OSI Approved :: Apache Software License",
                 "Operating System :: OS Independent",
                 "Development Status :: 4 - Beta",
                 "Intended Audience :: Developers"
                 ],
    )
