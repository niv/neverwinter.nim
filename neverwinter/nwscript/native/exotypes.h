//
// SPDX-License-Identifier: GPL-3.0
//
// This file is part of the NWScript compiler open source release.
//
// The initial source release is licensed under GPL-3.0.
//
// All subsequent changes you submit are required to be licensed under MIT.
//
// However, the project overall will still be GPL-3.0.
//
// The intent is for the base game to be able to pick up changes you explicitly
// submit for inclusion painlessly, while ensuring the overall project source code
// remains available for everyone.
//

#pragma once

// This file is a reduced variant taken from the base game.
// Do not port changes here back to the game unless needed for script compiler functionality.

// WIN32 don't clobber std::min/max.
// This is not what we need in our life.
#define NOMINMAX

#include <stddef.h>
#include <stdio.h>
#include <assert.h>
#include <stdint.h>

typedef int BOOL;
typedef uint32_t STRREF;
typedef uint32_t OBJECT_ID;
typedef uint16_t RESTYPE;

#define FALSE 0
#define TRUE  1

#define INVALID_OBJECT_ID  0x7f000000
#define RESTYPE_INVALID    0xFFFF

#define MINSHORT    0x8000
#define MAXSHORT    0x7fff
#define MAXWORD     0xffff
#define MAXDWORD    0xffffffff
#define MAXBYTE     0xff


#include <algorithm>

// N.B.: C++98 functions only, see http://en.cppreference.com/w/cpp/algorithm

// Some external libraries (like mss) define their own min/max.
// This is not what we need in our life.
#undef min
#undef max
#undef clamp

// Legacy. N.B.: semantics changed, now uses < internally. Should not
// have *any* effect as it's only used to compare numbers.
// Left here because used in a LOT of places, and it's bad to break
// assumptions.
#define NWN_max(a,b) (std::max)(a,b)
#define NWN_min(a,b) (std::min)(a,b)

// This would be in in c++17.
#if __cplusplus < 201500
namespace std
{
	// Returns value n clamped to inclusive (l, n). Works with any
	// type that the compiler knows how to compare.
	template <class T> const T& clamp(const T& n, const T& l, const T& h)
	{
		return std::max(l, std::min(n, h));
	}

	// Returns value n clamped to inclusive (l, n).
	//
	// Uses Cmp to compare, where Cmp is:
	//   bool(const Type1 &a, const Type2 &b);
	// Where Type1 and Type2 are implicitly convertible.
	template <class T, class Cmp> const T& clamp(const T& n, const T& l,
		const T& h, Cmp cmp)
	{
		return std::max(l, std::min(n, h, cmp), cmp);
	}
};
#endif

#if ((defined __linux__) || (defined __APPLE__))
#define stricmp strcasecmp
#define strnicmp strncasecmp
#endif // LINUX
