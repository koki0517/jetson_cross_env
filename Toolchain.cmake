# Toolchain.cmake
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# Sysrootの場所（Docker内のパスを指定します）
set(CMAKE_SYSROOT /sysroot)

# コンパイラの指定
set(CMAKE_C_COMPILER /usr/bin/aarch64-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER /usr/bin/aarch64-linux-gnu-g++)

# 検索パスの設定
set(CMAKE_FIND_ROOT_PATH /workspace/install ${CMAKE_SYSROOT})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# ROS 2固有の設定（Python等のパス調整が必要な場合があるが基本はこれで動作）

# Python3のクロスコンパイル設定
set(Python3_INCLUDE_DIR /sysroot/usr/include/python3.10)
set(Python3_LIBRARY /sysroot/usr/lib/aarch64-linux-gnu/libpython3.10.so)

set(PYTHON_SOABI cpython-310-aarch64-linux-gnu CACHE STRING "Force python suffix" FORCE)
set(Python3_SOABI cpython-310-aarch64-linux-gnu CACHE STRING "Force python suffix" FORCE)

# CUDAのクロスコンパイル設定
set(CMAKE_CUDA_COMPILER /usr/local/cuda/bin/nvcc)
set(CMAKE_CUDA_HOST_COMPILER /usr/bin/aarch64-linux-gnu-g++)
set(CMAKE_CUDA_ARCHITECTURES 87)
