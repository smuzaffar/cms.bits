package: libuuid
version: "%(tag_basename)s"
tag: v2.34
source: https://github.com/akritkbehera/libuuid
requires:
 - "GCC-Toolchain:(?!osx)"
---
if ! rsync -a --chmod=ug=rwX --delete --exclude '**/.git' \
      --delete-excluded "$SOURCEDIR"/ "$BUILDDIR"/; then
    exit 1
fi

./configure \
    $([ $(uname) == Darwin ] && echo --disable-shared) \
    --libdir=$INSTALLROOT/lib64 \
    --prefix=$INSTALLROOT \
    --disable-silent-rules \
    --disable-tls \
    --disable-rpath \
    --disable-libblkid \
    --disable-libmount \
    --disable-mount \
    --disable-losetup \
    --disable-fsck \
    --disable-partx \
    --disable-mountpoint \
    --disable-fallocate \
    --disable-unshare \
    --disable-eject \
    --disable-agetty \
    --disable-cramfs \
    --disable-wdctl \
    --disable-switch_root \
    --disable-pivot_root \
    --disable-kill \
    --disable-utmpdump \
    --disable-rename \
    --disable-login \
    --disable-sulogin \
    --disable-su \
    --disable-schedutils \
    --disable-wall \
    --disable-makeinstall-setuid \
    --without-ncurses \
    --enable-libuuid

make ${JOBS+-j $JOBS}

mkdir -p $INSTALLROOT/lib64
cp -p $BUILDDIR/.libs/libuuid.a* $INSTALLROOT/lib64

if [ "$(uname -s)" = "Linux" ]; then
	cp -p $BUILDDIR/.libs/libuuid.so* $INSTALLROOT/lib64
fi

mkdir -p $INSTALLROOT/include
make install-uuidincHEADERS
