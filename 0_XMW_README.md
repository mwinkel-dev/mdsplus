## Recent Changes

This "preview" contains these major changes:

- based on recent `cmake` branch (many changes, including latest `alpha`)


## Still To Do

Customers using macOS will typically install Xcode, which includes the AppleClang compiler.  However, they might also have installed the Clang compiler.  (Although the Jenkins build system will probably use Clang, the goal is to ensure it also builds with AppleClang.)  Some issues have been seen when switching between the two compilers.  These issues will be investigated / fixed soon.   

- AppleClang on Intel macOS Ventura works for all build types: `Debug`, `Release`, `MinSizeRel`, and `RelWithDebInfo`.
- Clang though only works with `Debug`.  (When using the other build types, the Java `MdsTreeNodeTest` fails.)


## Notes for mw-preview-macos-intel-v2

The `mw-preview-macos-intel-v2` branch is a temporary preview branch for Intel macOS Ventura.   It is NOT the official branch.  This preview branch will vanish soon.

The original plan was to do some prototyping on both Intel and Apple Silicon macOS Ventura.   And then check-in changes for both to the official alpha branch.  (And also to build "universal" binaries so there would be just one macOS release kit.)

However, porting MDSplus to Apple Silicon macOS Ventura is far more complicated than porting to Intel macOS Ventura.  So the check-ins will now be done in the following phases:

- macOS OFD lock changes submitted to the official "alpha" branch -- ***DONE***
- Intel preview branch created in this repo (based on the "cmake" branch) -- ***DONE***
- Additional Intel macOS changes will be checked into alpha -- ***DONE***
- A new stable release will be made -- ***Stephen is planning***
- Apple Silicon preview branch created in this repo (based on the "cmake" branch)
- Apple Silicon changes submitted to official "alpha" branch
- Changes for universal binaries then added (or at least documented)


## Work In Progress

Transient / temporary work is denoted with uppercase "XMW" (indicates "experimental change made by MarkW").  Source directories that are in flux will usually have a "0_XMW_README.md" file with some notes about the changes / experiments.   Source comments that contain "XMW" (such as "//XMW" or "#XMW") are temporary changes (such as debug print statements).

Any change flagged with "XMW" (whether file or source lines), *MUST* not be included in PRs submitted to official branches.

Note that the "XMW" tag has a naming collision with xmdsshr/UilKeyTab.h -- the items in that file that start with "XMW" are original source code.   They are not part of the changes made for Intel macOS Ventura.


## Limitations

This is prototype software.   Although it passes 99% of the test cases (one test fails), it has the following limitations:

- No LabView
- No IDL
- No install / smoke tests of the resulting MDSplus


## Flaky Tests?

There is a chance that the test framework might be generating false positives.  Some tests that are reported as passing, might actually be failing.

Also, some results might be flaky when test cases are run in parallel.


## Summary of Changes

There are few changes for Intel macOS Ventura because its Application Binary Interface (ABI) is similar to Linux.

The changes that were made, fall into these categories:
- features that were broken on macOS for years (such as OFD locks)
- test cases that were broken on macOS for years (such as TreeSegmentTest and do_tditests.sh)
- CMake related changes (finding missing environment variables)
- a few macOS specific changes


## Building MDSplus

A few environment variables must be set before building.  Edit these as needed.

```
# Fortran compiler is "flang" because gfortran not yet available
# for Intel macOS Ventura.  Also, "flang" can be used to create 
# "universal" binaries that will work with both Intel and Apple Silicon.
# Note that "flang" requires access to Apple's SDK.
export XMW_FLANG=/opt/local/libexec/llvm-16/bin/flang-new
export XMW_LIB=/opt/local/libexec/llvm-16/lib
export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
export LIBRARY_PATH="$XMW_LIB:$SDKROOT/usr/lib"
```

Inside the mdsplus repo, run a Python script (which in turn calls CMake) with this command:

```
./deploy/build.py --test -j
```

Note that `-j` denotes parallel testing.  To do sequential testing, omit the `-j`.



## Using the Installed MDSplus

There will likely be two versions of Python on the Mac.  One is included with Apple's Xcode, the other installed with MacPorts.  Use the one installed with MacPorts.

```
export PYTHON=/opt/local/bin/python3.11
export PyLib=/opt/local/Library/Frameworks/Python.framework/Versions/3.11/lib/libpython3.11.dylib
$PYTHON <my_program.py>
```

After running the MDSplus `setup.sh` script, you might also have to set the following environment variables.

```
PYTHONPATH -- so can import the MDSplus module
MDSPLUS_LIBRARY_PATH -- used by mdsshr/librtl.c
LD_LIBRARY_PATH -- used by some Java apps
DYLD_LIBRARY_PATH -- used by some Java apps
```


## MacPorts

This preview branch was developed using libraries / tools installed by MacPorts.   See www.macports.org for details.

These are the ports that were requested.
```  
  bison @3.8.2_2 (active)
  cmake @3.24.4_0 (active)
  doxygen @1.9.3_3 (active)
  flang-16 @16.0.6_1 (active)
  flex @2.6.4_0 (active)
  freetds @1.3.19_0 (active)
  gcc12 @12.3.0_0+stdlib_flag (active)
  openjdk8 @8u372_1+release+server (active)
  openjdk11 @11.0.20_0+release+server (active)
  openmotif @2.3.8_3 (active)
  py-numpy @1.25.2_0 (active)
```

And this is the full list of ports that were installed:
```
  autoconf @2.71_2 (active)
  bash @5.2.15_0 (active)
  bison @3.8.2_2 (active)
  bison-runtime @3.8.2_0 (active)
  brotli @1.0.9_2 (active)
  bzip2 @1.0.8_0 (active)
  cctools @949.0.1_3+xcode (active)
  clang-16 @16.0.6_2+analyzer (active)
  clang_select @2.2_1 (active)
  cmake @3.24.4_0 (active)
  curl @8.2.1_0+http2+ssl (active)
  curl-ca-bundle @8.2.1_0 (active)
  cython_select @0.1_2 (active)
  db48 @4.8.30_5 (active)
  doxygen @1.9.3_3 (active)
  expat @2.5.0_0 (active)
  fftw-3 @3.3.10_0+gfortran (active)
  flang-16 @16.0.6_1 (active)
  flex @2.6.4_0 (active)
  fontconfig @2.14.2_0 (active)
  freetds @1.3.19_0 (active)
  freetype @2.12.1_0 (active)
  gcc12 @12.3.0_0+stdlib_flag (active)
  gcc12-libcxx @12.3.0_0+clang14 (active)
  gcc_select @0.1_10 (active)
  gdbm @1.23_0 (active)
  gettext @0.21.1_0 (active)
  gettext-runtime @0.21.1_0 (active)
  gettext-tools-libs @0.21.1_0 (active)
  gmake @4.4.1_0 (active)
  gmp @6.2.1_1 (active)
  gnutls @3.7.10_0 (active)
  icu @73.2_0 (active)
  isl @0.24_1 (active)
  kerberos5 @1.21.2_0 (active)
  ld64 @3_4+ld64_xcode (active)
  ld64-xcode @2_4 (active)
  libarchive @3.7.1_0 (active)
  libb2 @0.98.1_1 (active)
  libcomerr @1.47.0_0 (active)
  libcxx @5.0.1_5 (active)
  libedit @20221030-3.1_0 (active)
  libffi @3.4.4_0 (active)
  libgcc @6.0_0 (active)
  libgcc12 @12.3.0_0+stdlib_flag (active)
  libiconv @1.17_0 (active)
  libidn2 @2.3.4_1 (active)
  libjpeg-turbo @2.1.5.1_0 (active)
  libmpc @1.3.1_0 (active)
  libomp @16.0.6_0 (active)
  libpng @1.6.40_0 (active)
  libpsl @0.21.2-20230117_0 (active)
  libtasn1 @4.19.0_0 (active)
  libtextstyle @0.21.1_0 (active)
  libtool @2.4.7_0 (active)
  libunistring @1.1_0 (active)
  libuv @1.44.2_0 (active)
  libxml2 @2.10.4_2 (active)
  libxslt @1.1.37_2 (active)
  llvm-16 @16.0.6_1 (active)
  llvm_select @2_1 (active)
  lmdb @0.9.31_0 (active)
  lz4 @1.9.4_0 (active)
  lzo2 @2.10_0 (active)
  m4 @1.4.19_1 (active)
  mlir-16 @16.0.6_1 (active)
  mpfr @4.2.0_0 (active)
  ncurses @6.4_0 (active)
  nettle @3.9.1_0 (active)
  nghttp2 @1.55.1_0 (active)
  OpenBLAS @0.3.23_0+gcc12+lapack (active)
  openjdk8 @8u372_1+release+server (active)
  openjdk8-bootstrap @8_0 (active)
  openjdk11 @11.0.20_0+release+server (active)
  openmotif @2.3.8_3 (active)
  openssl @3_12 (active)
  openssl3 @3.1.2_0 (active)
  ossp-uuid @1.6.2_13+perl5_34 (active)
  p11-kit @0.25.0_0 (active)
  perl5 @5.34.1_0+perl5_34 (active)
  perl5.34 @5.34.1_0 (active)
  pkgconfig @0.29.2_0 (active)
  py-numpy @1.25.2_0 (active)
  py311-cython @0.29.36_0 (active)
  py311-numpy @1.25.2_0+gfortran+openblas (active)
  py311-setuptools @68.1.2_0 (active)
  python3_select @0.0_3 (active)
  python311 @3.11.4_0+lto+optimizations (active)
  python_select @0.3_10 (active)
  readline @8.2.001_0 (active)
  sqlite3 @3.42.0_0 (active)
  xar @1.8.0.498_0 (active)
  Xft2 @2.3.8_0 (active)
  xorg-libice @1.1.1_0 (active)
  xorg-libpthread-stubs @0.5_0 (active)
  xorg-libsm @1.2.4_0 (active)
  xorg-libX11 @1.8.6_0 (active)
  xorg-libXau @1.0.11_0 (active)
  xorg-libxcb @1.15_0+python311 (active)
  xorg-libXdmcp @1.1.4_0 (active)
  xorg-libXext @1.3.5_0 (active)
  xorg-libXmu @1.1.4_0 (active)
  xorg-libXp @1.0.4_0 (active)
  xorg-libXt @1.3.0_0 (active)
  xorg-xcb-proto @1.16.0_0+python311 (active)
  xorg-xorgproto @2023.2_0 (active)
  xrender @0.9.11_0 (active)
  xz @5.4.4_0 (active)
  zlib @1.3_0 (active)
  zstd @1.5.5_0 (active)
```
