package: curl
version: "7.79.0"
tag: curl-7_79_0
source: https://github.com/curl/curl.git
build_requires:
  - "OpenSSL:(?!osx)"
requires:
  - zlib
---
set -x
rsync -a --chmod=ug=rwX --delete --exclude '**/.git' --delete-excluded "$SOURCEDIR"/ "$BUILDDIR"/

if [[ "$OSTYPE" == "darwin"* ]]; then
    KERBEROS_ROOT=/usr/heimdal
    OS_TYPE="darwin"
else
    KERBEROS_ROOT=/usr
    OS_TYPE="linux"
fi

./buildconf

./configure \
  --prefix="$INSTALLROOT" \
  --disable-silent-rules \
  --disable-static \
  --without-libidn \
  --without-zstd \
  --disable-ldap \
  --with-zlib="$ZLIB_ROOT" \
  --without-nss \
  --without-libssh2 \
  --with-gssapi="$KERBEROS_ROOT" \
  --with-openssl

make -j"$MAKEPROCESSES"

make install


if [[ "$OS_TYPE" == "darwin" ]]; then
    echo "Applying macOS-specific post-install steps..."

    # Trick to get our version of curl pick up our version of its associated shared
    # library (which is different from the one coming from the system!).
    install_name_tool -id "$INSTALLROOT/lib/libcurl-cms.dylib" \
                      -change "$INSTALLROOT/lib/libcurl.4.dylib" "$INSTALLROOT/lib/libcurl-cms.dylib" \
                      "$INSTALLROOT/lib/libcurl.4.dylib"

    install_name_tool -change "$INSTALLROOT/lib/libcurl.4.dylib" "$INSTALLROOT/lib/libcurl-cms.dylib" \
                      "$INSTALLROOT/bin/curl"

    ln -sf libcurl.4.dylib "$INSTALLROOT/lib/libcurl-cms.dylib"
fi
