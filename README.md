# PoBFrontend

A cross-platform [Path of Building](https://github.com/Openarl/PathOfBuilding) driver.

## Building

### Dependencies:

- Qt5
- luajit
- zlib
- opengl
- lua-curl (see below)
- Bitstream-Vera and Liberation TTF fonts. Will work without these but most likely look terrible.

### Build dependencies:

- meson
- pkg-config
- ninja (optional, can tell meson to generate makefiles if you prefer)

### Build Lua-Curl:

You need to build [Lua-Curl](https://github.com/Lua-cURL/Lua-cURLv3) for luajit.

1. Clone it from the Github repo above
2. While in the root directory, Run `LUA_IMPL=luajit make`. You should get lcurl.so

### Get the PoBFrontend sources:

`git clone https://github.com/philroberts/pobfrontend.git`

### Build:

First, change into this directory.

```bash
# Assuming you installed qt with Homebrew
PKG_CONFIG_PATH="/usr/local/opt/qt/lib/pkgconfig" meson -Dbuildtype=release . build
cd build
ninja
```

Run the thing:

```bash
cd /path/to/PathOfBuilding # <- a pathofbuilding git clone
for f in tree*.zip; do unzip $f;done # <- use the provided tree data because reasons
unzip runtime-win32.zip lua/xml.lua lua/base64.lua lua/sha1.lua
mv lua/*.lua .
rmdir lua
cp /path/to/lcurl.so . # our lcurl.so from earlier
/path/to/build/pobfrontend
```

You can adjust the font size up or down with a command line argument:

```bash
pobfrontend -2
```

### Notes:

I have the following edit in my PathOfBuilding clone, stops it from saving builds even when I tell it not to:

```diff
--- a/Modules/Build.lua
+++ b/Modules/Build.lua
@@ -599,7 +599,7 @@ function buildMode:CanExit(mode)
 end

 function buildMode:Shutdown()
-       if launch.devMode and self.targetVersion and not self.abortSave then
+       if false then --launch.devMode and self.targetVersion and not self.abortSave then
                if self.dbFileName then
                        self:SaveDBFile()
                        elseif self.unsaved then
```

###### OS X

On mac you need to invoke meson with some extra flags, per the luajit documentation:

```bash
LDFLAGS="-pagezero_size 10000 -image_base 100000000" meson pobfrontend build
```
