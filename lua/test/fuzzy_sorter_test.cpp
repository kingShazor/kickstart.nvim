#include <gtest/gtest.h>

#include "simple_fuzzy_sorter.h"

using namespace fuzzy_score_n;

// ----------- fuzzy-match-file-name-tests -------

TEST( FuzzySorter, empty_pattern_test )
{
  auto score = fzs_get_score( "init.lua", "" );
  EXPECT_EQ( score, FULL_MATCH );
}

TEST( FuzzySorter, fuzzy_file_match )
{
  auto score = fzs_get_score( "init.lua", "init" );
  EXPECT_EQ( score, FULL_MATCH );
}

// das nächste zeichen ist kein Wortanfang (erwartet $ oder '.', '('...
TEST( FuzzySorter, fuzzy_file_match_missing_end_bonus )
{
  auto score = fzs_get_score( "init.lua", "init." );
  EXPECT_EQ( score, FULL_MATCH - BOUNDARY_WORD );
}

// das erste zeichen ist kein Wortanfang
TEST( FuzzySorter, fuzzy_file_match_missing_start_bonus )
{
  auto score = fzs_get_score( "init.lua", "nit" );
  EXPECT_EQ( score, FULL_MATCH - BOUNDARY_WORD );
}

// missing both word boundarie missing both word boundaries
TEST( FuzzySorter, fuzzy_file_match_missing_both_bounds )
{
  auto score = fzs_get_score( "init.lua", "ni" );
  EXPECT_EQ( score, FULL_MATCH - BOUNDARY_BOTH );
}

TEST( FuzzySorter, fuzzy_file_mapping_suggest )
{
  auto score = fzs_get_score( "mapping_suggest_station_header.cpp", "mapping suggest st" );
  EXPECT_EQ( score, FULL_MATCH * 3 - BOUNDARY_WORD );
}

TEST( FuzzySorter, fuzzy_file_location_util )
{
  auto score = fzs_get_score( "integration_location_util.cpp", "location util" );
  EXPECT_EQ( score, FULL_MATCH * 2 );
}

TEST( FuzzySorter, fuzzy_file_util_location )
{
  auto score = fzs_get_score( "integration_location_util.cpp", "util location" );
  EXPECT_EQ( score, FULL_MATCH * 2 );
}

TEST( FuzzySorter, fuzzy_file_in_lo_ut )
{
  auto score = fzs_get_score( "integration_location_util.cpp", "in lo ut" );
  EXPECT_EQ( score, FULL_MATCH * 3 - BOUNDARY_WORD * 3 );
}

TEST( FuzzySorter, fuzzy_file_very_fuzzy )
{
  auto score = fzs_get_score( "mapping_suggest_station_header.cpp", "mpns" );
  EXPECT_GT( score, 30 );
  EXPECT_LT( score, 40 );
}

TEST( FuzzySorter, fuzzy_file_upper_case_also_match )
{
  auto score = fzs_get_score( "INTEGRATION.cmake", "inte cmake" );
  EXPECT_EQ( score, FULL_MATCH * 2 - BOUNDARY_WORD );
}

TEST( FuzzySorter, NoMatch )
{
  auto score = fzs_get_score( "init.lua", "vim" );
  EXPECT_EQ( score, MISMATCH );
}
