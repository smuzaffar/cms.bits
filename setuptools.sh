package: setuptools
version: "%(tag_basename)s"
tag: v80.9.0
source: https://github.com/pypa/setuptools
requires:
 - Python
prepend_path:
  PYTHON3PATH: "%(root_dir)s/${PYTHON3_LIB_SITE_PACKAGES}"
---
rsync -a --chmod=ug=rwX --delete --exclude '**/.git' \
      --delete-excluded "$SOURCEDIR"/ "$BUILDDIR"/

python3 setup.py build
python3 setup.py egg_info

python3 setup.py install --single-version-externally-managed \
    --record=/dev/null --skip-build --prefix="$INSTALLROOT"
