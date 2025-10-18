#pragma once

#include <sys/types.h>

namespace fuzzy_score_n
{
  enum
  {
    MISMATCH = 0,
    FULL_MATCH = 100,
    BOUNDARY_WORD = 2,
    BOUNDARY_BOTH = BOUNDARY_WORD * 2,
  };
} // namespace fuzzy_score_n

extern "C"
{
  typedef struct
  {
    unsigned int *data;
    size_t size;
    size_t cap;
  } fzs_position_t;

  int fzs_get_score( const char *text, const char *pattern );

  fzs_position_t *fzs_get_positions( const char *text, const char *pattern );
  void fzs_free_positions( fzs_position_t *pos );
}
