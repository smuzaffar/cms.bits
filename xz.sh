package: xz
version: "%(tag_basename)s"
tag: v5.2.5
requires:
 - "GCC-Toolchain:(?!osx)"
source: https://github.com/tukaani-project/xz
env:
 "XZ_ROOT": "$INSTALLROOT"
---
rsync -a --chmod=ug=rwX --delete --exclude '**/.git' --delete-excluded \
    "$SOURCEDIR"/ "$BUILDDIR"/

./autogen.sh --no-po4a

./configure \
    CFLAGS='-fPIC -Ofast' \
    --prefix="$INSTALLROOT" \
    --disable-static \
    --disable-nls \
    --disable-rpath \
    --disable-dependency-tracking \
    --disable-doc

make ${MAKEPROCESSES}
make ${MAKEPROCESSES} install
