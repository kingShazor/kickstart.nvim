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
    FULL_MATCH = 100,
    BOUNDARY_WORD = 2,
    BOUNDARY_BOTH = BOUNDARY_WORD * 2,
    CHAR_SIZE = 127,
    U_CHAR_SIZE = 256
  };

  vector< unsigned char > boundaryChars()
  {
    vector< unsigned char > boundaries( CHAR_SIZE, false );
    boundaries[ '-' ] = true;
    boundaries[ ' ' ] = true;
    boundaries[ '(' ] = true;
    boundaries[ ')' ] = true;
    boundaries[ ']' ] = true;
    boundaries[ '[' ] = true;
    boundaries[ '.' ] = true;

    return boundaries;
  }

  int scoreBoundary( const std::string &text, uint begin, uint end )
  {
    static const vector< unsigned char > boundary = boundaryChars();
    int score = 0;
    if ( begin == 0 || boundary[ text[ begin ] ] )
      score += 2;
    if ( end + 1 == text.size() || boundary[ text[ end ] ] )
      score += 2;

    return score;
  }

  int full_match( const std::string &text, const std::string &pattern )
  {
    if ( const auto it = search( text.begin(),
                                 text.end(),
                                 boyer_moore_horspool_searcher( pattern.begin(), pattern.end() ) );
         it != text.end() )
    {
      // cout << "Full match: " << text << pattern << endl;
      return FULL_MATCH - BOUNDARY_BOTH + scoreBoundary( text, *it, *it + pattern.size() - 1 );
    }

    return MISMATCH;
  }

  int get_fuzzy_score( const std::string &text, const std::string &pattern )
  {
    if ( pattern.empty() )
      return FULL_MATCH;

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

// -------- C-Interface ----------
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
