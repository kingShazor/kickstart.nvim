#include "simple_fuzzy_sorter.h"

#include <algorithm>
#include <cctype>
#include <functional>
#include <iostream>
#include <string_view>

using namespace std;
using namespace fuzzy_score_n;

namespace
{
  enum
  {
    U_CHAR_SIZE = 256
  };

  // small extra bonus for matching sign after oder before the pattern
  vector< unsigned char > boundaryChars()
  {
    vector< unsigned char > boundaries( U_CHAR_SIZE, false );
    boundaries[ '-' ] = true;
    boundaries[ '_' ] = true;
    boundaries[ ' ' ] = true;
    boundaries[ '/' ] = true;
    boundaries[ '\\' ] = true;
    boundaries[ '(' ] = true;
    boundaries[ ')' ] = true;
    boundaries[ ']' ] = true;
    boundaries[ '[' ] = true;
    boundaries[ '.' ] = true;
    boundaries[ ':' ] = true;
    boundaries[ ';' ] = true;

    return boundaries;
  }

  // who would need this?
  struct [[maybe_unused]] dbg
  {
    bool _addSep = false;

    ~dbg()
    {
      cout << endl;
    }

    template< class ARG >
    dbg &operator<<( const ARG &val )
    {
      if ( _addSep )
        cout << " ";
      else
        _addSep = true;

      cout << val;
      return *this;
    }
  };

  // end is after the last found sign.
  int scoreBoundary( const string_view &text, uint begin, uint end )
  {
    static const vector< unsigned char > boundary = boundaryChars();
    int score = 0;
    if ( begin == 0 || boundary[ static_cast< unsigned char >( text[ begin - 1 ] ) ] )
      score += 2;
    if ( end == text.size() || boundary[ static_cast< unsigned char >( text[ end ] ) ] )
      score += 2;

    return score;
  }

  using result_t = variant< int, vector< int > >;

  /*
   * calcing a fast strict score (the pattern must match ascending).
   */
  result_t get_strict_score( const string_view &text, const string_view &pattern, const bool getPositions )
  {
    if ( const auto it = search( text.begin(),
                                 text.end(),
                                 boyer_moore_horspool_searcher( pattern.begin(), pattern.end() ) );
         it != text.end() )
    {
      const auto pos = it - text.begin();
      if ( getPositions )
      {
        vector< int > positions;
        for ( uint x = pos; x < pos + pattern.size(); ++x )
          positions.push_back( x );
        return positions;
      }

      return FULL_MATCH - BOUNDARY_BOTH + scoreBoundary( text, pos, pos + pattern.size() );
    }

    if ( getPositions )
      return vector< int >();
    return MISMATCH;
  }

  /*
   * \pattern includes only lower case chars
   * fuzzy means: allowing gaps between found characters and looking also for uppercase chars
   *              we don't use UTF-8 here, because the overhead. It will only used for finding file_names
   *              so a 'ü' will have here two chars which need to match 'case sensitve'.
   *              Also meaning langugage chars count as a larger gap.
   */
  result_t get_fuzzy_score( const string_view &text, const string_view &pattern, const bool getPositions )
  {
    int score = MISMATCH;
    const size_t maxPos = text.size() - pattern.size();
    vector< int > positions;
    vector< int > resultPositions;
    const int maxScore = pattern.size() * MATCH_CHAR;
    uint startPos = 0;
    for ( uint i = 0; i <= maxPos; ++i )
    {
      int penalty = 0;
      startPos = i;
      for ( const char patternChar : pattern )
      {
        uint pos = startPos;
        // find fuzzy position
        for ( ; pos < text.size(); ++pos )
        {
          char textChar = text[ pos ];
          if ( textChar > 0 && isupper( textChar ) )
            textChar = tolower( textChar );
          if ( patternChar == textChar )
            break;
        }
        if ( pos == text.size() )
          break;

        if ( positions.empty() )
          i = pos;
        else
        {
          if ( const uint gap = pos - startPos; gap > MAX_GAP )
            break;
          else if ( gap > 0 )
            penalty += ( gap * GAP_PENALTY );
        }
        positions.push_back( static_cast< int >( pos ) );
        startPos = pos + 1;
      }

      // Impossible match, when first char can't be found
      if ( positions.empty() )
        break;
      if ( positions.size() == pattern.size() )
      {
        const int boundaryScore = scoreBoundary( text, positions.front(), positions.back() + 1 );
        if ( penalty == 0 && boundaryScore == BOUNDARY_BOTH )
        {
          std::swap( positions, resultPositions );
          score = FULL_MATCH;
          break;
        }

        const int newScore = pattern.size() * MATCH_CHAR - penalty;
        int normalizedScore = static_cast< int >(
          static_cast< float >( newScore ) / static_cast< float >( maxScore ) * 100.0f + 0.5f );
        normalizedScore += ( -BOUNDARY_BOTH + boundaryScore );
        if ( getPositions && normalizedScore > score )
          std::swap( positions, resultPositions );
        score = max( normalizedScore, score );
      }
      positions.clear();
    }

    if ( getPositions )
      return resultPositions;
    return score;
  }

  /*
   * split pattern into tokens. Small tokens or with upper case char are strict searched.
   * \param getPositions true: get positions instead of a rating
   */
  result_t get_score( const string_view &text, const string_view &pattern, const bool getPositions )
  {
    if ( pattern.empty() )
      return getPositions ? result_t{ vector< int >() } : result_t{ FULL_MATCH };
    if ( pattern.size() > text.size() )
      return getPositions ? result_t{ vector< int >() } : result_t{ MISMATCH };

    if ( pattern.size() < MIN_FUZZY_PATTERN_SIZE )
      return get_strict_score( text, pattern, getPositions );

    const char sep = ' ';

    struct patternHelper_c
    {
      string_view pattern;
      bool strict;
    };

    // creating a cache doesn't make sense: costs generating tokens ~= creating a cache
    vector< patternHelper_c > patternHelpers;
    bool strict = false;
    for ( uint i = 0; i < pattern.size(); ++i )
    {
      uint y = i;
      for ( ; y < pattern.size(); ++y )
      {
        const char c = pattern[ y ];
        const bool isSpace = c == sep;
        if ( isSpace )
          break;
        else if ( c > 0 && isupper( c ) )
          strict = true;
      }
      if ( uint newPatternSize = y - i; y > 0 )
      {
        if ( !strict && newPatternSize < MIN_FUZZY_PATTERN_SIZE )
          strict = true;
        patternHelpers.push_back( patternHelper_c{ .pattern = pattern.substr( i, newPatternSize ), .strict = strict } );
        strict = false;
        i = y;
      }
    }

    // creating a variant was also ugly :(
    int score = MISMATCH;
    vector< int > positions;
    for ( const auto &patternHelper : patternHelpers )
    {
      const auto result = patternHelper.strict ? get_strict_score( text, patternHelper.pattern, getPositions )
                                               : get_fuzzy_score( text, patternHelper.pattern, getPositions );

      if ( getPositions )
      {
        for ( const int position : std::get< vector< int > >( result ) )
          positions.push_back( position );
      }
      else
      {
        const int patternScore = std::get< int >( result );

        if ( patternScore == MISMATCH )
          return MISMATCH;
        score += patternScore;
      }
    }

    if ( getPositions )
      return positions;

    return score;
  }
} // namespace

// -------- C-Interface ----------

// ma score is the best :)
int fzs_get_score( const char *text, const char *pattern )
{
  return std::get< int >( get_score( text, pattern, false ) );
}

// positions will be displayed by the gui
fzs_position_t *fzs_get_positions( const char *text, const char *pattern )
{
  const auto positions = std::get< vector< int > >( get_score( text, pattern, true ) );
  fzs_position_t *result = new fzs_position_t{ .data = new uint[ positions.size() ], .size = positions.size() };
  for ( uint i = 0; i < positions.size(); ++i )
    result->data[ i ] = positions[ i ];

  return result;
}

// lua need controll over this :-(
void fzs_free_positions( fzs_position_t *pos )
{
  if ( pos )
  {
    delete[] pos->data;
    delete pos;
  }
}
