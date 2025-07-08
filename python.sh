package: Python
version: "%(tag_basename)s"
tag: v3.9.14
source: https://github.com/python/cpython
build_requires:
 - alibuild-recipe-tools
requires:
 - expat
 - bz2lib
 - db6
 - gdbm
 - libffi
 - zlib
 - sqlite
 - xz
env:
 "PYTHONROOT": "$INSTALLROOT"
---
if [[ ! -d "$SOURCEDIR" ]]; then
    exit 1
fi

if ! rsync -a --chmod=ug=rwX --delete --exclude '**/.git' \
      --delete-excluded "$SOURCEDIR"/ "$BUILDDIR"/; then
    exit 1
fi

if ! mkdir -p "${INSTALLROOT}"/{include,lib,bin}; then
    exit 1
fi

export DB6_ROOT
export LIBFFI_ROOT
LDFLAGS=""
CPPFLAGS=""

for d in ${EXPAT_ROOT} ${BZ2LIB_ROOT} ${DB6_ROOT} ${GDBM_ROOT} ${LIBFFI_ROOT} ${ZLIB_ROOT} ${SQLITE_ROOT} ${XZ_ROOT}; do
    if [[ -n "$d" ]]; then
        if [[ -e "$d/lib" ]]; then
            LDFLAGS="$LDFLAGS -L$d/lib"
        fi
        if [[ -e "$d/lib64" ]]; then
            LDFLAGS="$LDFLAGS -L$d/lib64"
        fi
        if [[ -e "$d/include" ]]; then
            CPPFLAGS="$CPPFLAGS -I$d/include"
        fi
    fi
done

mkdir -p "$BUILDDIR/tmp"

if ! ./configure \
  --prefix="${INSTALLROOT}" \
  --enable-shared \
  --enable-ipv6 \
  --with-system-ffi \
  --without-ensurepip \
  --with-system-expat \
  LDFLAGS="$LDFLAGS" \
  CPPFLAGS="$CPPFLAGS"; then
    exit 1
fi

make -j"$(nproc)"
make install 
