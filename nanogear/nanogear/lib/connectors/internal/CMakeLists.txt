set(NInternalConnector_SOURCES
  nhttpserver.cpp
  nrequesthandler.cpp
)
set(NInternalConnector_HEADERS
  nhttpserver.h
  nrequesthandler.h
  nutility.h
)

qt4_wrap_cpp(NInternalConnector_MOC_SOURCES nhttpserver.h)
add_library(NInternalConnector SHARED
  ${NInternalConnector_SOURCES}
  ${NInternalConnector_MOC_SOURCES}
)

target_link_libraries(NInternalConnector NInternalConnector)
set_target_properties(NInternalConnector PROPERTIES
  VERSION ${NANOGEAR_MAJOR}
  SOVERSION ${NANOGEAR_VERSION}
)
