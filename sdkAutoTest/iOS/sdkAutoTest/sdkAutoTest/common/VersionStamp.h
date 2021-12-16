#ifndef VERSIONSTAMP_H
#define VERSIONSTAMP_H
namespace PixelFree {
#define PIXEL_MAKE_STR1(a) #a
#define PIXEL_MAKE_STR(a) PIXEL_MAKE_STR1(a)
const char* Get
();
int GetVersionMajor();
int GetVersionMinor();
int GetVersionFix();
}  
#endif
