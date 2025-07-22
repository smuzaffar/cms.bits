package: numactl
version: "%(tag_basename)s"
tag: v2.0.14
source: https://github.com/numactl/numactl
requires:
 - gcc
---
rsync -a --chmod=ug=rwX --delete --exclude '**/.git' --delete-excluded "$SOURCEDIR"/ "$BUILDDIR"/

./autogen.sh
./configure \
  --prefix=$INSTALLROOT \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking \
  --with-pic \
  --with-gnu-ld
  
make ${JOBS+-j $JOBS}
make install

rm -rf $INSTALLROOT/lib/pkgconfig