package: libpciaccess
version: "%(tag_basename)s"
tag: libpciaccess-0.16
source: https://gitlab.freedesktop.org/xorg/lib/libpciaccess
requires:
 - zlib
 - gcc
---
rsync -a --chmod=ug=rwX --delete --exclude '**/.git' "$SOURCEDIR"/ "$BUILDDIR"/

./autogen.sh

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