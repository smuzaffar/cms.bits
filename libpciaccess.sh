package: libpciaccess
version: "%(tag_basename)s"
tag: libpciaccess_0.16
sources: 
- http://deb.debian.org/debian/pool/main/libp/libpciaccess/%(tag_basename)s.orig.tar.gz
requires:
 - zlib
 - gcc
---
tar -xzf "$SOURCEDIR/${SOURCE0}" \
    --strip-components=1 \
    -C "$BUILDDIR"

./configure \
  --prefix ${INSTALLROOT} \
  --disable-dependency-tracking \
  --enable-shared \
  --disable-static \
  --with-pic \
  --with-gnu-ld \
  --with-zlib \
  CPPFLAGS="-I$ZLIB_ROOT/include" \
  LDFLAGS="-L$ZLIB_ROOT/lib"