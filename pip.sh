package: pip
version: "%(tag_basename)s"
tag: 25.1.1
source: https://github.com/pypa/get-pip
requires:
 - Python
 - setuptools
---
if ! rsync -a --chmod=ug=rwX --delete --exclude '**/.git' \
      --delete-excluded "$SOURCEDIR"/ "$BUILDDIR"/; then
    exit 1
fi

echo "The python is from"
which python3
curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py \
  --no-setuptools \
  --no-wheel \
  --prefix "$INSTALLROOT"

