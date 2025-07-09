package: VecGeom
version: "%(tag_basename)s"
tag: v1.2.6
source: https://gitlab.cern.ch/VecGeom/VecGeom.git
requires:
  - "GCC-Toolchain:(?!osx)"
  - "Vc"
build_requires:
  - CMake
  - ninja
  - alibuild-recipe-tools
---

rsync -av --chmod=ug=rwX --delete --exclude '**/.git' \
      "$SOURCEDIR"/ "$BUILDDIR"/
