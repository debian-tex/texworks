# - Try to find Synctex
# Once done this will define
#
#  SYNCTEX_FOUND - system has SyncTeX
#  SYNCTEX_INCLUDE_DIR - the SyncTeX include directory
#  SYNCTEX_LIBRARIES - Link these to use SyncTeX
#  SYNCTEX_VERSION_MAJOR, SYNCTEX_VERSION_MINOR, SYNCTEX_VERSION_PATCH,
#  SYNCTEX_VERSION_STRING - SyncTeX version information
#
# Redistribution and use of this file is allowed according to the terms of the
# MIT license. For details see the file COPYING-CMAKE-MODULES.


if ( SYNCTEX_INCLUDE_DIR AND SYNCTEX_LIBRARIES )
   # in cache already
   SET(Synctex_FIND_QUIETLY TRUE)
endif ( SYNCTEX_INCLUDE_DIR AND SYNCTEX_LIBRARIES )

# use pkg-config to get the directories and then use these values
# in the FIND_PATH() and FIND_LIBRARY() calls
if( NOT WIN32 )
  find_package(PkgConfig)

  pkg_check_modules(SYNCTEX_PKG QUIET synctex)
endif( NOT WIN32 )

FIND_PATH(SYNCTEX_INCLUDE_DIR NAMES synctex_parser.h
  PATHS
    /usr/local/include/synctex_parser
    /usr/X11/include/synctex_parser
    /usr/include/synctex_parser
  HINTS
    ${SYNCTEX_PKG_INCLUDE_DIRS} # Generated by pkg-config
)

FIND_LIBRARY(SYNCTEX_LIBRARIES NAMES synctex ${SYNCTEX_PKG_LIBRARIES}
  PATHS
    /usr/local
    /usr/X11
    /usr
  HINTS
    ${SYNCTEX_PKG_LIBRARY_DIRS} # Generated by pkg-config
  PATH_SUFFIXES
    lib64
    lib
)

IF ( SYNCTEX_INCLUDE_DIR AND EXISTS "${SYNCTEX_INCLUDE_DIR}/synctex_parser.h" )
  file(STRINGS "${SYNCTEX_INCLUDE_DIR}/synctex_parser.h" SYNCTEX_PARSER_H REGEX "^Version: [0-9.]+$")

  string(REGEX REPLACE "^Version: ([0-9]+).*$" "\\1" SYNCTEX_VERSION_MAJOR "${SYNCTEX_PARSER_H}")
  string(REGEX REPLACE "^Version: ${SYNCTEX_VERSION_MAJOR}\\.([0-9]+).*$" "\\1" SYNCTEX_VERSION_MINOR "${SYNCTEX_PARSER_H}")
  set(SYNCTEX_VERSION_PATCH 0)
  set(SYNCTEX_VERSION_STRING "${SYNCTEX_VERSION_MAJOR}.${SYNCTEX_VERSION_MINOR}.${SYNCTEX_VERSION_PATCH}")
ENDIF ()

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Synctex REQUIRED_VARS SYNCTEX_LIBRARIES SYNCTEX_INCLUDE_DIR VERSION_VAR SYNCTEX_VERSION_STRING )

# show the SYNCTEX_INCLUDE_DIR and SYNCTEX_LIBRARIES variables only in the advanced view
MARK_AS_ADVANCED(SYNCTEX_INCLUDE_DIR SYNCTEX_LIBRARIES )

