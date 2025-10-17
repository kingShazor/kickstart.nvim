cmake_minimum_required(VERSION 3.19)
project(fzs LANGUAGES CXX)

add_library(${PROJECT_NAME} SHARED "src/simple_fuzzy_sorter.cpp")

target_include_directories(${PROJECT_NAME} PUBLIC
  $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/src>)
target_compile_options(${PROJECT_NAME}
  PRIVATE
    $<$<CXX_COMPILER_ID:MSC>:/W4>
    $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-Wall -Wextra -Wpedantic>)
target_compile_definitions(${PROJECT_NAME}
  PRIVATE
    $<$<PLATFORM_ID:Windows>:_CRT_NONSTDC_NO_DEPRECATE>
    $<$<PLATFORM_ID:Windows>:_CRT_SECURE_NO_DEPRECATE>
    $<$<PLATFORM_ID:Windows>:_CRT_SECURE_NO_WARNINGS>)

set_target_properties(${PROJECT_NAME} PROPERTIES
    WINDOWS_EXPORT_ALL_SYMBOLS ON
    CXX_STANDARD 23
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
    PREFIX lib)
# # This cannot be a generator expression in this version of CMake
# if (NOT (MSVC OR MSYS OR MINGW OR WIN32))
#   set_property(TARGET ${PROJECT_NAME} PROPERTY SUFFIX .so)
# endif()

if (UNIX AND NOT APPLE)
  target_compile_options(${PROJECT_NAME} PRIVATE -fPIC)
endif()

install(TARGETS ${PROJECT_NAME} DESTINATION ${CMAKE_BINARY_DIR})
