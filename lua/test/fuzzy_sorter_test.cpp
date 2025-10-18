#include <gtest/gtest.h>

#include "simple_fuzzy_sorter.h"

using namespace fuzzy_score_n;

// ----------- full-match-file-tests -------

TEST( FuzzySorter, empty_pattern_test )
{
  auto score = fzs_get_score( "init.lua", "" );
  EXPECT_EQ( score, FULL_MATCH );
}

TEST( FuzzySorter, full_file_match )
{
  auto score = fzs_get_score( "init.lua", "init" );
  EXPECT_EQ( score, FULL_MATCH );
}

// das nächste zeichen ist kein Wortanfang (erwartet $ oder '.', '('...
TEST( FuzzySorter, full_file_match_missing_end_bonus )
{
  auto score = fzs_get_score( "init.lua", "init." );
  EXPECT_EQ( score, FULL_MATCH - BOUNDARY_WORD );
}

// das erste zeichen ist kein Wortanfang
TEST( FuzzySorter, full_file_match_missing_start_bonus )
{
  auto score = fzs_get_score( "init.lua", "nit" );
  EXPECT_EQ( score, FULL_MATCH - BOUNDARY_WORD );
}

// missing both word boundarie missing both word boundaries
TEST( FuzzySorter, full_file_match_missing_both_bounds )
{
  auto score = fzs_get_score( "init.lua", "ni" );
  EXPECT_EQ( score, FULL_MATCH - BOUNDARY_BOTH );
}

TEST( FuzzySorter, NoMatch )
{
  auto score = fzs_get_score( "init.lua", "vim" );
  EXPECT_EQ( score, MISMATCH );
}
