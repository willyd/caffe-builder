# Caffe-Builder
Caffe-Builder is a set of CMake scripts (using CMake's ExternalProject) that automate the build and installation of the Caffe library and its dependencies.

Using this project will (hopefully) make building and installation of Caffe on Windows much easier. 

## Building Caffe with Caffe-Builder
### Get the Prerequisites
* CMake (tested with 3.2)
* Visual Studio (tested with 2013 in 64 bit mode)
* Git
* CUDA (tested with 7.0) for GPU support

### Clone this repository:    
    cmd> git clone https://github.com/willyd/caffe-builder.git caffe-builder
        
### Create a build directory and configure CMake to build Caffe-Builder inside:
    cmd> md ..\build
    cmd> cd ..\build
    cmd> cmake -G "<your generator>" ..\caffe-builder
    
CMake will download all the sources and files required to compile Caffe and its dependencies to the folder build\DownloadCache. This can take some time.
    
### Build the project
    cmd> cmake --build .
    
Alternatively you can build the caffe-builder.sln by opening it in Visual Studio. Build only one configuration as the project is setup to build the two configuration for each project in batch.
After some time you should have both Debug and Release binaries for Caffe and all its dependencies in the build\install folder. All libraries are built as static libraries. Please note that building Caffe as a shared library is not supported right now with Visual Studio.
    










