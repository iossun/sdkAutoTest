#include "VersionStamp.h"
#include <string>

namespace PixelFree {

#define VERSION_MAJOR 2
#define VERSION_MINOR 0
#define VERSION_FIX 0

#define SDK_GIT_VERSION a8a0c664

static std::string pixfree_version;

const char* GetVersion() {
  pixfree_version = std::to_string(VERSION_MAJOR) + "." +
                 std::to_string(VERSION_MINOR) + "." +
                 std::to_string(VERSION_FIX) + "_";

  pixfree_version += std::string(PIXEL_MAKE_STR(SDK_GIT_VERSION));
  return pixfree_version.c_str();
};

int GetVersionMajor() { return VERSION_MAJOR; }
int GetVersionMinor() { return VERSION_MINOR; }
int GetVersionFix() { return VERSION_FIX; }
}  
