cmake_minimum_required (VERSION 3.1)
project(sdkTest VERSION 1.1.1)

option(PIXELFREE_BUILD_SHARED_LIB "build PixelFree shared lib" OFF)
option(PIXELFREE_BUILD_INTERFACE_LIB "build PixelFree interface" ON)

macro(get_git_hash _git_hash)   
    find_package(Git QUIET)     
    if(GIT_FOUND)
      execute_process(          
        COMMAND ${GIT_EXECUTABLE} log -1 --pretty=format:%h 
        OUTPUT_VARIABLE ${_git_hash}        
        OUTPUT_STRIP_TRAILING_WHITESPACE    
        ERROR_QUIET                         
        WORKING_DIRECTORY                   
          ${CMAKE_CURRENT_SOURCE_DIR}
        )
    endif()
endmacro()                      
macro(get_git_hash_ios _git_hash)   
    execute_process(          
    COMMAND git log -1 --pretty=format:%h 
    OUTPUT_VARIABLE ${_git_hash}        
    OUTPUT_STRIP_TRAILING_WHITESPACE    
    ERROR_QUIET                         
    WORKING_DIRECTORY                   
        ${CMAKE_CURRENT_SOURCE_DIR}
    )
endmacro()       
set(GIT_HASH "")
get_git_hash(GIT_HASH)
if(IOS)
get_git_hash_ios(GIT_HASH)
endif()
message(STATUS "Current Version Info is ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}_${GIT_HASH}")

configure_file(
    ${PROJECT_SOURCE_DIR}/Common/VersionStamp.cc.in
    ${PROJECT_SOURCE_DIR}/Common/VersionStamp.cc
    @ONLY
)


if (MSVC)
  add_compile_options(/W1)
  if (${PIXELFREE_USE_TFPB} STREQUAL OFF)
    add_compile_options(/WX)
  endif()
  if (${MSVC_TOOLSET_VERSION} STREQUAL 141)
    # vs 2017
    add_definitions(-D_ENABLE_EXTENDED_ALIGNED_STORAGE)
  endif()
else()
  # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --std=c++11")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3")
  add_compile_options(-fPIC)
  add_compile_options(-Werror)
  # add_compile_options(-Wall)
  add_compile_options(-Wno-sign-compare)
endif()
if (ANDROID)
  # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fopenmp")
endif()

if (IOS)
  add_definitions(-DTARGET_OS_IPHONE)
endif()

if (MSVC)
  set(CompilerFlags
      CMAKE_C_FLAGS_DEBUG
      CMAKE_C_FLAGS_MINSIZEREL
      CMAKE_C_FLAGS_RELEASE
      CMAKE_C_FLAGS_RELWITHDEBINFO
      CMAKE_CXX_FLAGS_DEBUG
      CMAKE_CXX_FLAGS_MINSIZEREL
      CMAKE_CXX_FLAGS_RELEASE
      CMAKE_CXX_FLAGS_RELWITHDEBINFO)
  foreach(CompilerFlag ${CompilerFlags})
    if(${CompilerFlag} MATCHES "/MD")
      string(REPLACE "/MD" "/MT" ${CompilerFlag} "${${CompilerFlag}}")
    endif()
  endforeach()

  if (${CMAKE_GENERATOR_PLATFORM} STREQUAL "x64")
    set(MSVC_WIN64 1)
  elseif (${CMAKE_GENERATOR_PLATFORM} STREQUAL "Win32")
    set(MSVC_WIN32 1)
  endif()
endif()


include_directories(${PROJECT_SOURCE_DIR}/Common)



file(GLOB_RECURSE PIXELFREE_SRCS Common/*.cc)


if (PIXELFREE_BUILD_SHARED_LIB)
  add_definitions(-DPIXELFREE_BUILD_SHARED_LIB=${PIXELFREE_BUILD_SHARED_LIB})
  set(CMAKE_SHARED_LINKER_FLAGS "-s ${CMAKE_SHARED_LINKER_FLAGS}")
  add_library(sdkTest SHARED ${PIXELFREE_SRCS})
  target_link_libraries(sdkTest ${LINK_LIBS})
else()
  add_library(sdkTest ${PIXELFREE_SRCS})
  target_link_libraries(sdkTest ${LINK_LIBS})
endif()

