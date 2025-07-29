package: pcre2
version: "%(tag_basename)s"
tag: pcre2-10.36
source: https://github.com/PCRE2Project/pcre2
requires:
 - bz2lib
 - zlib
 - gcc
---
rsync -a --chmod=ug=rwX --delete --exclude '**/.git' "$SOURCEDIR"/ "$BUILDDIR"/

sh autogen.sh

./configure \
  --enable-unicode-properties \
  --enable-pcregrep-libz \
  --enable-pcregrep-libbz2 \
  --prefix=${INSTALLROOT} \
  CPPFLAGS="-I${BZ2LIB_ROOT}/include -I${ZLIB_ROOT}/include" \
  LDFLAGS="-L${BZ2LIB_ROOT}/lib -L${ZLIB_ROOT}/lib"

make ${JOBS:+-j$JOBS}
make install