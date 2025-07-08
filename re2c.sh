package: re2c
version: "%(tag_basename)s"
tag: 1.0.1
source: https://github.com/skvadrik/re2c
requires:
  - "GCC-Toolchain:(?!osx)"
---
rsync -a --chmod=ug=rwX --delete --exclude '**/.git' --delete-excluded "$SOURCEDIR"/ "$BUILDDIR"/
cd $PKGNAME
autoreconf -i -W all
./configure --prefix="$INSTALLROOT"
make -j"$(nproc)"
make install
