package: zstd
version: "%(tag_basename)s"
tag: v1.5.7
source: https://github.com/facebook/zstd
build_requires:
 - CMake
requires:
 - gcc
---
rsync -a --chmod=ug=rwX --delete --exclude '**/.git' "$SOURCEDIR"/ "$BUILDDIR"/

cmake build/cmake \
 -DZSTD_BUILD_CONTRIB:BOOL=OFF \
 -DZSTD_BUILD_STATIC:BOOL=OFF \
 -DZSTD_BUILD_TESTS:BOOL=OFF \
 -DCMAKE_BUILD_TYPE=Release \
 -DZSTD_BUILD_PROGRAMS:BOOL=OFF \
 -DZSTD_LEGACY_SUPPORT:BOOL=OFF \
 -DCMAKE_INSTALL_PREFIX:STRING=%{i} \
 -DCMAKE_INSTALL_LIBDIR:STRING=lib \
 -Dzstd_VERSION:STRING=${PKGVERSION}

make ${JOBS:+-j$JOBS}
make install