/*
 * Pre-include system headers that radare2's r_types.h would
 * otherwise pull in after setting _FILE_OFFSET_BITS=64, which
 * causes struct definition conflicts with SwiftGlibc.
 */
#include <sys/types.h>
#include <fcntl.h>
#include <dirent.h>

#include <libr/r_core.h>
