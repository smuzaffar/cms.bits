package: zlib
version: "%(tag_basename)s"
tag: v1.2.13
source: https://github.com/madler/zlib
build_requires:
  - alibuild-recipe-tools
requires:
  - GCC-Toolchain
---
echo "→ rsync -a --chmod=ug=rwX --delete --exclude '**/.git' $SOURCEDIR/ $BUILDDIR/"
rsync -a --chmod=ug=rwX --delete --exclude '**/.git' \
       "$SOURCEDIR"/ "$BUILDDIR"/

CONF_FLAG="-fPIC -O3 -DUSE_MMAP -DUNALIGNED_OK -D_LARGEFILE64_SOURCE=1"

CFLAGS="$CONF_FLAGS" ./configure --prefix="$INSTALLROOT"

: "${MAKEPROCESSES:=-j$(nproc)}"
make $MAKEPROCESSES

echo "→ make install"
make install

# Modulefile
MODULEDIR="$INSTALLROOT/etc/modulefiles"
MODULEFILE="$MODULEDIR/$PKGNAME"
mkdir -p "$MODULEDIR"
alibuild-generate-module --lib > "$MODULEFILE"
