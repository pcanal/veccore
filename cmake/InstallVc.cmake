include(ExternalProject)

set(Vc_VERSION "1.3.2")
set(Vc_PROJECT "Vc-${Vc_VERSION}")
set(Vc_SRC_URI "http://github.com/VcDevel/Vc")
set(Vc_SRC_MD5 "f996a2dcab9f0ef3e21ba0d0feba9c3e")
set(Vc_DESTDIR "${CMAKE_BINARY_DIR}/${Vc_PROJECT}")
set(Vc_ROOTDIR "${Vc_DESTDIR}/${CMAKE_INSTALL_PREFIX}")

if (KNC)
  set(KNC_SUFFIX "_MIC")
endif()

set(Vc_LIBNAME ${CMAKE_STATIC_LIBRARY_PREFIX}Vc${KNC_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX})
set(Vc_LIBRARY ${Vc_ROOTDIR}/lib${LIB_SUFFIX}/${Vc_LIBNAME})

ExternalProject_Add(${Vc_PROJECT}
  PREFIX externals
  URL "${Vc_SRC_URI}/releases/download/${Vc_VERSION}/${Vc_PROJECT}.tar.gz"
  URL_MD5 ${Vc_SRC_MD5}
  BUILD_IN_SOURCE 0
  BUILD_BYPRODUCTS ${Vc_LIBRARY}
  CMAKE_ARGS -G ${CMAKE_GENERATOR}
             -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
             -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
             -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
             -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
             -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
             -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
  INSTALL_COMMAND env DESTDIR=${Vc_DESTDIR} ${CMAKE_COMMAND} --build . --target install
)

add_library(Vc${KNC_SUFFIX} STATIC IMPORTED)
set_property(TARGET Vc${KNC_SUFFIX} PROPERTY IMPORTED_LOCATION ${Vc_LIBRARY})
add_dependencies(Vc${KNC_SUFFIX} ${Vc_PROJECT})

set(Vc_LIBRARIES Vc${KNC_SUFFIX})
set(Vc_INCLUDE_DIR "${Vc_ROOTDIR}/include")
set(Vc_INCLUDE_DIRS "${Vc_ROOTDIR}/include")

set(VecCore_LIBRARIES ${VecCore_LIBRARIES} ${Vc_LIBRARIES})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Vc
  REQUIRED_VARS Vc_INCLUDE_DIRS Vc_LIBRARIES VERSION_VAR Vc_VERSION)

install(DIRECTORY ${Vc_ROOTDIR}/ DESTINATION ".")
