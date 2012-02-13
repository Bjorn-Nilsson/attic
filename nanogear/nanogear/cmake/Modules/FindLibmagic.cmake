# - Try to find libmagic (from the GNU file package)
# Once done, this will define
#
#  libmagic_FOUND - system has libmagic
#  libmagic_INCLUDE_DIRS - the libmagic include directories
#  libmagic_LIBRARIES - link these to use libmagic

include(LibFindMacros)


# Include dir
find_path(libmagic_INCLUDE_DIR
  NAMES magic.h
  PATHS
    ${libmagic_CUSTOM_INCLUDE_DIR}
    /usr/include
)

# Finally the library itself
find_library(libmagic_LIBRARY
  NAMES magic
  PATHS
    ${libmagic_CUSTOM_LIBRARY_DIR}
    /usr/lib
    /usr/lib64
)

# Set the include dir variables and the libraries and let libfind_process do the rest.
# NOTE: Singular variables for this library, plural for libraries this this lib depends on.
set(libmagic_PROCESS_INCLUDES libmagic_INCLUDE_DIR)
set(libmagic_PROCESS_LIBS libmagic_LIBRARY)
libfind_process(libmagic)

