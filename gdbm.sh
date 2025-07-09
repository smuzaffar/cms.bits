package: gdbm
version: "%(tag_basename)s"
tag: v1.10
build_requires:
 - alibuild-recipe-tools
requires:
 - "GCC-Toolchain:(?!osx)"
source: https://github.com/akritkbehera/gdbm
---
CONFIG_BASE_URL="http://cmsrep.cern.ch/cmssw/download/config"
CONFIG_GUESS_URL="${CONFIG_BASE_URL}/config.guess"
CONFIG_SUB_URL="${CONFIG_BASE_URL}/config.sub"

TMPDIR="$BUILDDIR/tmp"
mkdir -p "$TMPDIR"

rm -f "$TMPDIR"/config.{sub,guess}

curl -L -k -s -o "$TMPDIR"/config.guess "$CONFIG_GUESS_URL"

curl -L -k -s -o "$TMPDIR"/config.sub "$CONFIG_SUB_URL"

ls -l "$TMPDIR"/config.*

if [[ -f "$TMPDIR/config.guess" && -f "$TMPDIR/config.sub" ]]; then
    ls -la "$TMPDIR"/config.{guess,sub}
else
    exit 1
fi
for CONFIG_GUESS_FILE in $(find "$BUILDDIR" -name 'config.guess' -not -path "*/tmp/*"); do
    rm -f "$CONFIG_GUESS_FILE" || { echo "❌ Failed to remove $CONFIG_GUESS_FILE"; exit 1; }
    cp "$TMPDIR/config.guess" "$CONFIG_GUESS_FILE" || { echo "❌ Failed to copy config.guess to $CONFIG_GUESS_FILE"; exit 1; }
    chmod +x "$CONFIG_GUESS_FILE" || { echo "❌ Failed to chmod $CONFIG_GUESS_FILE"; exit 1; }
done

for CONFIG_SUB_FILE in $(find "$BUILDDIR" -name 'config.sub' -not -path "*/tmp/*"); do
    rm -f "$CONFIG_SUB_FILE" || { echo "❌ Failed to remove $CONFIG_SUB_FILE"; exit 1; }
    cp "$TMPDIR/config.sub" "$CONFIG_SUB_FILE" || { echo "❌ Failed to copy config.sub to $CONFIG_SUB_FILE"; exit 1; }
    chmod +x "$CONFIG_SUB_FILE" || { echo "❌ Failed to chmod $CONFIG_SUB_FILE"; exit 1; }
done


echo "→ rsync -a --chmod=ug=rwX --delete --exclude '**/.git' $SOURCEDIR/ $BUILDDIR/"
rsync -a --chmod=ug=rwX --delete --exclude '**/.git' "$SOURCEDIR"/ "$BUILDDIR"/

cd "$BUILDDIR"
./configure \
  --enable-libgdbm-compat \
  --prefix="$INSTALLROOT" \
  --disable-dependency-tracking \
  --disable-nls \
  --disable-rpath

: "${MAKEPROCESSES:=-j$(nproc)}"
echo "→ make $MAKEPROCESSES"
make $MAKEPROCESSES
