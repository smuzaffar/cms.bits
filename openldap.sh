package: openldap
version: "2.6.10"
sources:
 - ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-%(version)s.tgz
requires:
  - GCC-Toolchain
  - db6
---
tar -xzf "$SOURCEDIR"/${SOURCE0}
cd openldap-${PKGVERSION}
rm -f ./build/config.{sub,guess}
curl -L -k -s -o build/config.guess http://cmsrep.cern.ch/cmssw/download/config/config.guess
curl -L -k -s -o build/config.sub http://cmsrep.cern.ch/cmssw/download/config/config.sub
chmod +x ./build/config.{sub,guess}

./configure \
  --prefix=${INSTALLROOT} \
  --without-cyrus-sasl \
  --with-tls=openssl \
  --disable-static \
  --disable-slapd \
  CPPFLAGS="-I${DB6_ROOT}/include" \
  LDFLAGS="-L${DB6_ROOT}/lib"
make depend
make
make install

find ${INSTALLROOT}/lib -type f | xargs chmod 0755

# Remove man pages.
rm -rf ${INSTALLROOT}/man ${INSTALLROOT}/share/man
