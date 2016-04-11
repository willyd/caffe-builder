@setlocal EnableDelayedExpansion
@echo off
rem Usage: setenv.cmd <msvc_version> <msvc_platform>
rem Example: setenv.cmd 120 amd64
set toolsets=(100 110 120 140)
for %%t in %toolsets% do (	
	if "%1" == "%%t" (
		set toolset=%%t
		goto :set_platform
	)
	if "%1" == "v%%t" (
		set toolset=%%t
		goto :set_platform
	)
)
echo setenv ERROR: Unknown toolset %1
goto :error

:set_platform
set platforms32=(32 x86 win32 Win32)
if "%2" == "" (
	set platform=x86
	goto :set_batch_file
) 
for %%t in %platforms32% do (
	if "%2" == "%%t" (
		set platform=x86
		goto :set_batch_file
	)
)
set platforms64=(64 x64 win64 Win64 amd64)
for %%t in %platforms64% do (
	if "%2" == "%%t" (
		set platform=amd64
		goto :set_batch_file
	)
)
echo setenv ERROR: Unknown platform %2
goto :error

:set_batch_file
set batch_file="!VS%toolset%COMNTOOLS!..\..\VC\vcvarsall.bat"
@endlocal & set batch_file=%batch_file% & set platform=%platform%
call %batch_file% %platform%
goto :end

:error
set ERRORLEVEL=1

:end

