# Super-Builder
Super-Builder (previously known as Caffe-Builder) is a set of CMake scripts (using CMake's ExternalProject) that automate the build and installation of popular C/C++ open source libraries on Windows using microsoft toolchain.

Using this project will (hopefully) make building, installing and using open source libraries on Windows much easier. 

## Building libraries
### Get the Prerequisites
* CMake (tested with 3.4)
* Visual Studio (tested with 2013 in 64 bit mode)
* Git
* [Ninja](https://github.com/ninja-build/ninja/releases/download/v1.6.0/ninja-win.zip)

Make sure CMake, Git and Ninja are in your path.

### Optional dependencies
* CUDA (tested with 7.0) for GPU support in opencv and other libraries
* Python (tested with 2.7.x) to build boost.python for example

### Clone this repository:
    cmd> cd %super_builder_root%    
    cmd> git clone https://github.com/willyd/super-builder.git super-builder
        
### Create a build directory and configure CMake to build super-builder inside:
    cmd> mkdir build
    cmd> cd build
    :: Set the Visual Studio envrionment for ninja (120 -> Visual Studio 2013, 64 -> amd64) 
    cmd> ..\setenv.cmd 120 64 
    :: Configure cmake
    cmd> cmake -GNinja -C ..\cmake\configs\Default.cmake ..\   
    
### Build and installing the libraries
    :: This will build all libraries that were configured to build with the BUILD_* options (see below)
    cmd> ninja
    :: Or alternatively
    cmd> ninja <libname>
    :: You can execute this command to list all possible targets
    cmd> ninja -t targets
    
The libraries will be installed in build\install. Alongside the libraries a series of Find*.cmake files will be installed and a InitialCache.cmake file will be installed too.    
    
### Using the built libraries in your project
    cmd> cd myproject
    cmd> mkdir build
    cmd> cd build
    cmd> cmake -G <generator name> -C %super_builder_root%\super-builder\build\install\InitialCache.cmake









