package: curl
version: "7.79.0"
tag: curl-7_79_0
source: https://github.com/curl/curl.git
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

make ${JOBS:+-j$JOBS}
make install