#ifndef VERSIONSTAMP_H
#define VERSIONSTAMP_H
#define PIXEL_MAKE_STR1(a) #a
#define PIXEL_MAKE_STR(a) PIXEL_MAKE_STR1(a)
//#ifdef __cplusplus
//extern "C" {
//#endif

__attribute__((visibility("default"))) const char* GetVersion();
__attribute__((visibility("default"))) int GetVersionMajor();
__attribute__((visibility("default"))) int GetVersionMinor();
__attribute__((visibility("default"))) int GetVersionFix();


__attribute__((visibility("default"))) int add(int a,int b,int *ret);

__attribute__((visibility("default"))) int sub(int a,int b,int *ret);

//#ifdef __cplusplus
//}
#endif
