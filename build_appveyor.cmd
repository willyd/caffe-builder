:: Download the ninja executable
call download_ninja.cmd

::
if "%BUILD_PART_1%" == "1" (
    echo "Building Part 1"
) else (
    echo "Building Part 2"
)

:: Add the ninja folder to the path
set path=%path%;%cd%

:: Set the environment for build with VS (2013, 64-bit)
call setenv.cmd 120 64

:: Create build_directory and cd to it
if NOT EXIST .\build (mkdir .\build)
cd .\build

:: Configure with CMake and build
cmake -GNinja -C ..\cmake\configs\Appveyor.cmake ..\
ninja