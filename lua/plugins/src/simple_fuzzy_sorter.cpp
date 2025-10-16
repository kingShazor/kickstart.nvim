#include "simple_fuzzy_sorter.h"

#include <algorithm>
#include <functional>
#include <iostream>
#include <string>

using namespace std;

namespace
{
  enum
  {
    MISMATCH = 0,
    FULL_MATCH = 100
  };

  int full_match( const std::string &text, const std::string &pattern )
  {
    if ( const auto it = search( text.begin(),
                                 text.end(),
                                 boyer_moore_horspool_searcher( pattern.begin(), pattern.end() ) );
         it != text.end() )
    {
      std::cout << "Full match: " << text << pattern;
      return FULL_MATCH;
    }

    return MISMATCH;
  }

  int get_fuzzy_score( const std::string &text, const std::string &pattern )
  {
    return full_match( text, pattern );
  }

  fzs_position_t *get_positions( const string &, const string &pattern )
  {
    auto res = new fzs_position_t{ .data = new uint[ pattern.size() ], .size = pattern.size(), .cap = pattern.size() };

    for ( uint i = 0; i < pattern.size(); ++i )
      res->data[ i ] = i;

    return res;
  }
} // namespace

int fzs_get_score( const char *text, const char *pattern )
{
  return get_fuzzy_score( text, pattern );
}

fzs_position_t *fzs_get_positions( const char *text, const char *pattern )
{
  return get_positions( text, pattern );
}

void fzs_free_positions( fzs_position_t *pos )
{
  if ( pos )
  {
    delete[] pos->data;
    delete pos;
  }
}
