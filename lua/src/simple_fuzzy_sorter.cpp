#include "simple_fuzzy_sorter.h"

#include <algorithm>
#include <cctype>
#include <clocale>
#include <functional>
#include <iostream>
#include <string>
#include <unordered_set>

using namespace std;
using namespace fuzzy_score_n;

namespace
{
  enum
  {
    MIN_FUZZY_PATTERN_SIZE = 3,
    CHAR_SIZE = 127,
    U_CHAR_SIZE = 256
  };

  vector< unsigned char > boundaryChars()
  {
    vector< unsigned char > boundaries( CHAR_SIZE, false );
    boundaries[ '-' ] = true;
    boundaries[ '_' ] = true;
    boundaries[ ' ' ] = true;
    boundaries[ '(' ] = true;
    boundaries[ ')' ] = true;
    boundaries[ ']' ] = true;
    boundaries[ '[' ] = true;
    boundaries[ '.' ] = true;
    boundaries[ ':' ] = true;
    boundaries[ ';' ] = true;

    return boundaries;
  }

  unordered_set< string > strictWordListInit()
  {
    return { "int",  "float", "double", "class", "struct", "return", "QString", "bool",      "enum", "char",
             "void", "auto",  "struct", "class", "vector", "map",    "pair",    "constexpr", "using" };
  }

  unordered_set< string > &strictWordList()
  {
    static unordered_set< string > wordList = strictWordListInit();
    return wordList;
  }

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

  // end ist nach dem letzten gefunden zeichen
  int scoreBoundary( const string &text, uint begin, uint end )
  {
    dbg() << "calc boundary: " << begin << end << text;
    static const vector< unsigned char > boundary = boundaryChars();
    int score = 0;
    if ( begin == 0 || boundary[ static_cast< unsigned char >( text[ begin - 1 ] ) ] )
    {
      dbg() << "found start";
      score += 2;
    }
    if ( end == text.size() || boundary[ static_cast< unsigned char >( text[ end ] ) ] )
    {
      dbg() << "found end";
      score += 2;
    }

    return score;
  }

  int get_strict_score( const string &text, const string &pattern )
  {
    if ( const auto it = search( text.begin(),
                                 text.end(),
                                 boyer_moore_horspool_searcher( pattern.begin(), pattern.end() ) );
         it != text.end() )
    {
      const auto pos = it - text.begin();
      dbg() << "full match! text: " << text << "pattern:" << pattern << "index" << pos
            << "last:" << ( pos + pattern.size() );
      return FULL_MATCH - BOUNDARY_BOTH + scoreBoundary( text, pos, pos + pattern.size() );
    }

    return MISMATCH;
  }

  // todo posi von dem Word zurückliefern!
  int get_fuzzy_score( const string &text, const string &pattern )
  {
    dbg() << "find pattern: " << pattern;
    int score = MISMATCH;
    const size_t maxPos = text.size() - pattern.size();
    vector< uint > positions;
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
          if ( isupper( textChar ) )
            textChar = tolower( textChar );
          if ( patternChar == textChar )
            break;
        }
        dbg() << "search:" << patternChar << "pos: " << pos << "startPos " << startPos;
        if ( pos == text.size() )
          break;

        if ( positions.empty() )
          i = pos;
        else
        {
          if ( const uint gap = pos - startPos; gap > MAX_GAP )
            break;
          else if ( gap > 0 )
          {
            penalty += ( gap * GAP_PENALTY );
            dbg() << "penalty found: " << penalty << "pos" << pos << "startPos: " << startPos;
          }
        }
        positions.push_back( pos );
        startPos = pos + 1;
      }

      dbg() << "positions: " << positions.size();
      // Impossible match, when first char can't be found
      if ( positions.empty() )
        break;
      if ( positions.size() == pattern.size() )
      {
        const int newScore = pattern.size() * MATCH_CHAR - penalty;
        const int boundaryScore = scoreBoundary( text, positions.front(), positions.back() + 1 );
        if ( newScore == maxScore && boundaryScore == BOUNDARY_BOTH )
          return FULL_MATCH;

        int normalizedScore = static_cast< int >(
          static_cast< float >( newScore ) / static_cast< float >( maxScore ) * 100.0f + 0.5f );
        dbg() << "normalizedScore: " << normalizedScore << "penalty was: " << penalty;
        normalizedScore += ( -BOUNDARY_BOTH + boundaryScore );
        score = max( normalizedScore, score );
      }
      positions.clear();
    }

    dbg() << "final fuzzy-score for: " << pattern << "score: " << score;
    return score;
  }

  int get_score( const string &text, const string &pattern )
  {
    if ( pattern.empty() )
      return FULL_MATCH;
    if ( pattern.size() > text.size() )
      return MISMATCH;

    if ( pattern.size() < MIN_FUZZY_PATTERN_SIZE )
      return get_strict_score( text, pattern );

    const char sep = ' ';

    struct patternHelper_c
    {
      string pattern;
      bool strict;
    };

    const auto &strictWords = strictWordList();
    vector< patternHelper_c > patternHelpers;
    string nextPattern;
    bool strict = false;
    const uint lastPos = pattern.size() - 1;
    for ( uint i = 0; i < pattern.size(); ++i )
    {
      const char c = pattern[ i ];
      const bool isSpace = c == sep;
      if ( !isSpace )
      {
        if ( isupper( c ) )
          strict = true;
        nextPattern.push_back( c );
      }
      if ( isSpace || i == lastPos )
      {
        if ( !nextPattern.empty() )
        {
          if ( !strict &&
               ( nextPattern.size() < MIN_FUZZY_PATTERN_SIZE || strictWords.find( nextPattern ) != strictWords.end() ) )
            strict = true;
          patternHelpers.push_back( patternHelper_c{ .pattern = nextPattern, .strict = strict } );
          nextPattern.clear();
          strict = false;
        }
      }
    }

    int score = MISMATCH;
    for ( const auto &patternHelper : patternHelpers )
    {
      const int patternScore = patternHelper.strict ? get_strict_score( text, patternHelper.pattern )
                                                    : get_fuzzy_score( text, patternHelper.pattern );
      // const int patternScore = get_strict_score( text, patternHelper.pattern );

      if ( patternScore == MISMATCH )
        return MISMATCH;
      score += patternScore;
    }

    return score;
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
  return get_score( text, pattern );
}

fzs_position_t *fzs_get_positions( const char *text, const char *pattern )
{
  // todo impl
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

void set_locale( const char *locale )
{
  setlocale( LC_ALL, locale );
}
