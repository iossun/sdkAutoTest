#include "VersionStamp.h"
#include <string>


#define VERSION_MAJOR 1
#define VERSION_MINOR 1
#define VERSION_FIX 1

#define SDK_GIT_VERSION 78a99cf

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

int add(int a,int b,int *ret){
    int code_OK = 1;
//    if (<#condition#>) {
//        return  -1;
//    }
    *ret = a + b;
    return code_OK;
}
int sub(int a,int b,int *ret){
    int code_OK = 1;
//    if (<#condition#>) {
//        return  -1;
//    }
    *ret = a - b;
    return code_OK;
}
