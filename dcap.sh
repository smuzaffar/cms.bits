package: dcap
version: "%(tag_basename)s"
tag: cms/2.47.12
source: https://github.com/cms-externals/dcap
requires:
- zlib
- gcc
- gmake
---
set -e
rsync -a --chmod=ug=rwX --delete --exclude '**/.git' "$SOURCEDIR"/ "$BUILDDIR"/
if [ -f src/Makefile.am ]; then
    perl -p -i.bak -e 's|^library_includedir.*|library_includedir=\$(includedir)|' src/Makefile.am
    echo "Patched src/Makefile.am"
    diff src/Makefile.am.bak src/Makefile.am || true
else
    echo "Warning: src/Makefile.am not found"
fi
mkdir -p config
aclocal -I config
autoheader
libtoolize --automake
automake --add-missing --copy --foreign
autoconf 
./configure --prefix "$INSTALLROOT" \
    CFLAGS="-I${ZLIB_ROOT}/include -Wno-implicit-function-declaration" \
    LDFLAGS="-L${ZLIB_ROOT}/lib"
make -C src ${JOBS:+-j$JOBS}
make -C src install 