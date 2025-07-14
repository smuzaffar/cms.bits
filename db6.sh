package: db6
version: "%(tag_basename)s"
tag: 6.2.32
requires:
 - "GCC-Toolchain:(?!osx)"
sources:
- http://cmsrep.cern.ch/cmssw/download/db-%(version)s.tar.gz
---
tar -xzvf "$SOURCEDIR"/${SOURCE0}
cd db-${PKGVERSION}
./dist/configure \
    --prefix="$INSTALLROOT" \
    ${BUILD:+--build="$BUILD"} \
    ${HOST:+--host="$HOST"} \
    --disable-java \
    --disable-tcl \
    --disable-static

make -j"${MAKE_JOBS:-$(nproc)}"
make install
