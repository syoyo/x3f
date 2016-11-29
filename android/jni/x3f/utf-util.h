#ifndef UTF_UTIL_H_
#define UTF_UTIL_H_

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

extern char *utf_util_utf16_to_utf8(uint16_t *str);

#ifdef __cplusplus
}
#endif

#endif  // UTF_UTIL_H_
