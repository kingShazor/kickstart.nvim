#include "simple_fuzzy_sorter.h"

#include <string>

namespace
{
  int get_fuzzy_score( const std::string &text, const std::string &pattern )
  {
    return 0;
  }
}

int fzs_get_score( const char *text, const char *pattern )
{
  return get_fuzzy_score( text, pattern );
}
