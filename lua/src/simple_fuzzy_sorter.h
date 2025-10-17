#pragma once

#include <sys/types.h>
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
