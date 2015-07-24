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

### Known issues
* Sometimes a download will fail. This seems to happen only for archives downloaded from sourceforge. Executing cmake (or clicking the Configure button in CMake-Gui) usually solves the problems.
* Even though LMDB builds successfully it does not work and hence the related Caffe tests will fail. This most likely related to this: https://groups.google.com/forum/#!topic/caffe-users/0RKsTTYRGpQ
* For some reasons the implementation of usleep on Windows does not stop the cuda threads and four Caffe tests fail.
* When Caffe-Builder builds boost it may output errors to the Error List Window in Visual Studio. You can safely ignore the following errors:
    * Error	334	error C1189: #error :  "Not SPARC"	
    * Error	333	error C1189: #error :  "Not PPC"	
    * Error	332	error C1189: #error :  "Not MIPS1"	
    * Error	331	error C1189: #error :  "Not ARM"	
    * Error	335	error C1083: Cannot open include file: 'unicode/uversion.h': No such file or directory	












