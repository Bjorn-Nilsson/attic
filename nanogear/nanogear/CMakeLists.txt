project(nanogear)
cmake_minimum_required(VERSION 2.6)
include(${PROJECT_SOURCE_DIR}/VERSION.cmake)
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/Modules)
enable_testing()


# Dependencies
## Qt
find_package(Qt4 COMPONENTS QtCore QtNetwork REQUIRED)
set(QT_DONT_USE_QTGUI 1)
include(${QT_USE_FILE})
## Libmagic
find_package(Libmagic REQUIRED)


# Include directory
include_directories(${QT_INCLUDES}
  ${PROJECT_SOURCE_DIR}/lib/core
  ${PROJECT_SOURCE_DIR}/lib/connectors/internal)

# Next targetadd_subdirectory(lib)
add_subdirectory(lib)
if(WITH_EXAMPLES)
  add_subdirectory(examples)
endif(WITH_EXAMPLES)
