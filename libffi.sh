package: libffi
version: "%(tag_basename)s"
tag: v3.4.2
build_requires:
 - alibuild-recipe-tools
requires:
 - "GCC-Toolchain:(?!osx)"
source: https://github.com/libffi/libffi
---
rsync -a --chmod=ug=rwX --delete --exclude '**/.git' \
      "$SOURCEDIR"/ "$BUILDDIR"/
autoreconf -fiv
./configure \
  --prefix="$INSTALLROOT" \
  --enable-portable-binary \
  --disable-dependency-tracking \
  --disable-static \
  --disable-docs
make $MAKEPROCESSES
make $MAKEPROCESSES install

rm -rf "${INSTALLROOT}/lib"
rm -rf ${INSTALLROOT}/lib64/*.la
