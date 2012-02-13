file(GLOB NCore_SOURCES ${CMAKE_CURRENT_SOURCE_DIR} "*.cpp")
file(GLOB NCore_HEADERS ${CMAKE_CURRENT_SOURCE_DIR} "*.h")

qt4_automoc(NCore_MOC_SOURCES ${NCore_HEADERS})
add_library(NCore SHARED ${NCore_SOURCES} ${NCore_MOC_SOURCES})

target_link_libraries(NCore ${QT_LIBRARIES} ${libmagic_LIBRARY})
set_target_properties(NCore PROPERTIES
  VERSION ${NANOGEAR_MAJOR}
  SOVERSION ${NANOGEAR_VERSION})