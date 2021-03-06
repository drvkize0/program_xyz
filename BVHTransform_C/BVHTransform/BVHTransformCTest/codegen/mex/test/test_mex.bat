@echo off
set MATLAB=D:\Program Files\MATLAB\R2014a
set MATLAB_ARCH=win64
set MATLAB_BIN="D:\Program Files\MATLAB\R2014a\bin"
set ENTRYPOINT=mexFunction
set OUTDIR=.\
set LIB_NAME=test_mex
set MEX_NAME=test_mex
set MEX_EXT=.mexw64
call mexopts.bat
echo # Make settings for test > test_mex.mki
echo COMPILER=%COMPILER%>> test_mex.mki
echo COMPFLAGS=%COMPFLAGS%>> test_mex.mki
echo OPTIMFLAGS=%OPTIMFLAGS%>> test_mex.mki
echo DEBUGFLAGS=%DEBUGFLAGS%>> test_mex.mki
echo LINKER=%LINKER%>> test_mex.mki
echo LINKFLAGS=%LINKFLAGS%>> test_mex.mki
echo LINKOPTIMFLAGS=%LINKOPTIMFLAGS%>> test_mex.mki
echo LINKDEBUGFLAGS=%LINKDEBUGFLAGS%>> test_mex.mki
echo MATLAB_ARCH=%MATLAB_ARCH%>> test_mex.mki
echo BORLAND=%BORLAND%>> test_mex.mki
echo OMPFLAGS= >> test_mex.mki
echo OMPLINKFLAGS= >> test_mex.mki
echo EMC_COMPILER=msvc120>> test_mex.mki
echo EMC_CONFIG=optim>> test_mex.mki
"D:\Program Files\MATLAB\R2014a\bin\win64\gmake" -B -f test_mex.mk
