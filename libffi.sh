package: libffi
version: "%(tag_basename)s"
tag: v3.4.2
build_requires:
 - alibuild-recipe-tools
requires:
 - "GCC-Toolchain:(?!osx)"
source: https://github.com/libffi/libffi
prepend_path:
  LD_LIBRARY_PATH: "$LIBFFI_ROOT/lib64"
---
rsync -a --chmod=ug=rwX --delete --exclude '**/.git' \
      "$SOURCEDIR"/ "$BUILDDIR"/
autoreconf -fiv
echo "→ ./configure --prefix=$INSTALLROOT --enable-portable-binary --disable-dependency-tracking --disable-static --disable-docs"
./configure \
  --prefix="$INSTALLROOT" \
  --enable-portable-binary \
  --disable-dependency-tracking \
  --disable-static \
  --disable-docs
: "${MAKEPROCESSES:=-j$(nproc)}"
make $MAKEPROCESSES

make $MAKEPROCESSES install

#echo "→ rm -rf $INSTALLROOT/lib && rm -rf $INSTALLROOT/lib64/*.la"
rm -rf "${INSTALLROOT}/lib"
rm -rf ${INSTALLROOT}/lib64/*.la
