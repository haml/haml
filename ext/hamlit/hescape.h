#ifndef HESCAPE_H
#define HESCAPE_H

#include <sys/types.h>
#include <stdint.h>

/*
 * Replace characters according to the following rules.
 * Note that this function can handle only ASCII-compatible string.
 *
 * " => &quot;
 * & => &amp;
 * ' => &#39;
 * < => &lt;
 * > => &gt;
 *
 * @return size of dest. If it's larger than len, dest is required to be freed.
 */
extern size_t hesc_escape_html(uint8_t **dest, const uint8_t *src, size_t size);

#endif
