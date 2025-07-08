package: db6
version: "%(tag_basename)s"
tag: v6.2.32
build_requires:
 - alibuild-recipe-tools
source: https://github.com/akritkbehera/Berkeley-DB-6.2.32
---
echo "→ rsync from $SOURCEDIR to $BUILDDIR"
rsync -av --chmod=ug=rwX --delete --exclude '**/.git' \
      "$SOURCEDIR"/ "$BUILDDIR"/

cd "$BUILDDIR"
echo "→ ./dist/configure --prefix=$INSTALLROOT ${BUILD:+--build=$BUILD} ${HOST:+--host=$HOST} --disable-java --disable-tcl --disable-static"
./dist/configure \
    --prefix="$INSTALLROOT" \
    ${BUILD:+--build="$BUILD"} \
    ${HOST:+--host="$HOST"} \
    --disable-java \
    --disable-tcl \
    --disable-static

echo "→ make -j${MAKE_JOBS:-$(nproc)}"
make -j"${MAKE_JOBS:-$(nproc)}"

make install
