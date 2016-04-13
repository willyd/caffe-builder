:: Download the ninja executable
call download_ninja.cmd

:: Add the ninja folder to the path
set path=%path%;%cd%

:: Set the environment for build with VS (2013, 64-bit)
call setenv.cmd 120 64

:: Create build_directory and cd to it
if NOT EXIST .\build (mkdir .\build)
cd .\build

:: Configure with CMake and build
cmake -GNinja -C ..\cmake\configs\AppveyorPart1.cmake ..\
ninja