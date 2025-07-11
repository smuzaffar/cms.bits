package: py-flit-core
version: 3.12.0
sources:
  - https://pypi.io/packages/source/f/flit-core/flit_core-%(version)s.tar.gz
requires:
 - Python
 - setuptools
 - pip
prepend_path:
  PYTHON3PATH: "%(root_dir)s/${PYTHON3_LIB_SITE_PACKAGES}"
---
PIP_PKGNAME=$(echo ${PKGNAME} | cut -f2-10 -d-)
export PIPFILE="$SOURCEDIR"/${SOURCE0}
export PYTHONUSERBASE="$INSTALLROOT"
export TMPDIR="$BUILDDIR/bits-tmp"
mkdir -p $TMPDIR
unset PIP_ROOT
pip3 list --disable-pip-version-check
pip3 install --no-clean --no-deps --no-index --no-build-isolation --no-cache-dir --disable-pip-version-check --user -vvv $PIPFILE
pip3 show ${PIP_PKGNAME} --disable-pip-version-check | grep '^Name:' | sed 's|^Name: *||;s| ||g'
PKG_NAME=$(pip3 show ${PIP_PKGNAME} --disable-pip-version-check | grep '^Name:' | sed 's|^Name: *||;s| ||g')
[ "${PKG_NAME}" = "" ] && exit 1
DEPS=$(pip3 check --disable-pip-version-check | grep "^${PKG_NAME}  *${PKGVERSION}  *requires " | sed 's|,.*||;s|.* |py-|' | tr '\n' ' ') || true
if [ "$DEPS" != "" ] ; then
   echo "ERROR: Missing dependencies for %n (python3) found: $DEPS"
   exit 1
fi
