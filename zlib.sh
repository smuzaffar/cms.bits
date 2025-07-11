package: zlib
version: "v1.2.13"
sources:
  - git://github.com/madler/zlib.git?obj=master/%(version)s&export=zlib-%(version)s&output=/zlib-%(version)s.tgz
build_requires:
  - alibuild-recipe-tools
requires:
  - GCC-Toolchain
---
tar -xzf "$SOURCEDIR"/${SOURCE0}
cd zlib-${PKGVERSION}
CONF_FLAG="-fPIC -O3 -DUSE_MMAP -DUNALIGNED_OK -D_LARGEFILE64_SOURCE=1"
CFLAGS="$CONF_FLAGS" ./configure --prefix="$INSTALLROOT"
make $MAKEPROCESSES
make install
