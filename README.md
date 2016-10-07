# Caffe-Builder
Caffe-Builder is a set of CMake scripts (using CMake's ExternalProject) that automate the build and installation of popular C/C++ open source libraries on Windows using microsoft toolchain.

Using this project will (hopefully) make building, installing and using open source libraries on Windows much easier.

[![Build status](https://ci.appveyor.com/api/projects/status/cks08mgov46p76y6/branch/master?svg=true)](https://ci.appveyor.com/project/willyd/caffe-builder/branch/master)

## Building libraries
### Get the Prerequisites
* CMake (tested with 3.4 and 3.6)
* Visual Studio (tested with 2013 and 2015 in 64 bit mode)
* Git
* [Ninja](https://github.com/ninja-build/ninja/releases/download/v1.6.0/ninja-win.zip)

Make sure CMake, Git and Ninja are in your path.

### Optional dependencies
* CUDA (tested with 7.5) for GPU support in opencv and other libraries
* Python (tested with 2.7.x) to build boost.python for example

### Clone this repository:
    cmd> cd %caffe_builder_root%
    cmd> git clone https://github.com/willyd/caffe-builder.git caffe-builder

### Building the libraries
Execute the following command to build the libraries

    cmd> build_v120_x64.cmd

Alternatively you can execute one command after the other
    :: Create a build directory
    cmd> mkdir build && cd build
    :: Setup the VS compiler
    cmd> call "%VS120COMNTOOLS%..\..\VC\vcvarsall.bat" amd64
    :: This will build all libraries that were configured to build with the BUILD_* options (see below)
    cmd> ninja
    :: Or alternatively
    cmd> ninja <libname>
    :: You can execute this command to list all possible targets
    cmd> ninja -t targets

The libraries will be installed in build\libraries. Alongside the libraries a series of Find*.cmake files will be installed and a caffe-builder-config.cmake file will be installed too. You can replace `120` with `140` in the commands above to build with VS 2015.

### Using the built libraries in your project
    cmd> cd myproject
    cmd> mkdir build
    cmd> cd build
    cmd> cmake -G <generator name> -C %caffe_builder_root%\caffe-builder\build\libraries\caffe-build-config.cmake









