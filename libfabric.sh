package: libfabric
version: "2.1.0"
tag: v2.1.0
source: https://github.com/ofiwg/libfabric
requires:
 - curl
 - numactl
 - rdma-core
 - xpmem
 - cuda
 - gdrcopy
 - gcc
---

rsync -a --chmod=ug=rwX --delete --exclude '**/.git' "$SOURCEDIR"/ "$BUILDDIR"/

./autogen.sh

# Configuration arguments array
configure_args=()

# Basic configuration options
configure_args+=(
    "--prefix=${INSTALLROOT}"
    "--disable-dependency-tracking"
    "--disable-debug"
    "--disable-profile"
    "--disable-asan"
    "--disable-lsan"
    "--disable-tsan"
    "--disable-ubsan"
    "--enable-shared"
    "--disable-static"
    "--enable-shm"
    "--enable-sm2"
    "--enable-xpmem=${XPMEM_ROOT}"
    "--disable-sockets"
    "--enable-tcp"
    "--enable-udp"
    "--enable-verbs=${RDMA_CORE_ROOT}"
    "--disable-opx"
    "--disable-psm2"
    "--disable-psm3"
    "--disable-usnic"
    "--disable-efa"
    "--disable-cxi"
    "--disable-mrail"
    "--disable-lpp"
    "--disable-ucx"
    "--enable-rxm"
    "--enable-lnx"
)

# CUDA configuration
if [[ -z "${without_cuda}" ]]; then
    # CUDA enabled (default)
    configure_args+=(
        "--enable-cuda-dlopen"
        "--enable-gdrcopy-dlopen"
        "--with-cuda=${CUDA_ROOT}"
        "--with-gdrcopy=${GDRCOPY_ROOT}"
    )
else
    # CUDA disabled
    configure_args+=(
        "--disable-cuda-dlopen"
        "--disable-gdrcopy-dlopen"
        "--without-cuda"
        "--without-gdrcopy"
    )
fi

# ROCm configuration
if [[ -z "${without_rocm}" ]]; then
    # ROCm enabled (default)
    configure_args+=(
        "--enable-rocr-dlopen"
        "--with-rocr=${ROCM_ROOT}"
    )
else
    # ROCm disabled
    configure_args+=(
        "--disable-rocr-dlopen"
        "--without-rocr"
    )
fi

# Additional configuration options
configure_args+=(
    "--disable-ze-dlopen"
    "--without-ze"
    "--with-pic"
    "--with-dlopen"
    "--with-gnu-ld"
    "--with-curl=DIR"
    "--with-numa=${NUMACTL_ROOT}"
)

./configure "${configure_args[@]}"

make ${JOBS:+-j$JOBS}
make install