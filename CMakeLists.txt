# SPDX-License-Identifier: GPL-3.0-or-later
cmake_minimum_required(VERSION 3.20)
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/VERSION" AUDILINK_PROJECT_VERSION)
string(STRIP "${AUDILINK_PROJECT_VERSION}" AUDILINK_PROJECT_VERSION)
if(NOT AUDILINK_PROJECT_VERSION MATCHES "^[0-9]+\\.[0-9]+\\.[0-9]+$")
  message(FATAL_ERROR "VERSION must contain a semantic major.minor.patch version")
endif()
project(AUDILINK VERSION "${AUDILINK_PROJECT_VERSION}" LANGUAGES C)

file(READ "${CMAKE_CURRENT_SOURCE_DIR}/include/audilink/audilink.h" AUDILINK_PUBLIC_VERSION_HEADER)
string(REGEX MATCH
  "#define[ \t]+AUDILINK_VERSION[ \t]+\"([0-9]+\\.[0-9]+\\.[0-9]+)\""
  AUDILINK_PUBLIC_VERSION_MATCH "${AUDILINK_PUBLIC_VERSION_HEADER}")
if(NOT AUDILINK_PUBLIC_VERSION_MATCH OR NOT CMAKE_MATCH_1 STREQUAL PROJECT_VERSION)
  message(FATAL_ERROR "VERSION and AUDILINK_VERSION must agree")
endif()
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
add_subdirectory(src/link EXCLUDE_FROM_ALL)
set(BUILD_TESTING ON CACHE BOOL "" FORCE)
enable_testing()

add_library(audilink-core STATIC src/audilink.c)
add_library(AUDILINK::Core ALIAS audilink-core)
target_include_directories(audilink-core PUBLIC include)
target_compile_definitions(audilink-core PRIVATE AUDILINK_VERSION="${PROJECT_VERSION}")
target_link_libraries(audilink-core PUBLIC LINK::Core)

add_executable(audilink-smoke tests/test_smoke.c)
target_compile_definitions(audilink-smoke PRIVATE AUDILINK_EXPECTED_VERSION="${PROJECT_VERSION}")
target_link_libraries(audilink-smoke PRIVATE AUDILINK::Core)
add_test(NAME audilink-smoke COMMAND audilink-smoke)
add_executable(audilink-obd2 tests/test_obd2.c)
target_link_libraries(audilink-obd2 PRIVATE AUDILINK::Core)
add_test(NAME audilink-obd2 COMMAND audilink-obd2)
add_executable(audilink-generic-diagnostics tests/test_generic_diagnostics.c)
target_link_libraries(audilink-generic-diagnostics PRIVATE AUDILINK::Core)
add_test(NAME audilink-generic-diagnostics COMMAND audilink-generic-diagnostics)

option(AUDILINK_BUILD_LINUX_GUI "Build native GTK4 GUI" OFF)
option(AUDILINK_BUILD_WINDOWS_DISCOVER "Build Win32 Discover GUI" ${WIN32})
include(GNUInstallDirs)

if(AUDILINK_BUILD_LINUX_GUI)
  if(NOT UNIX OR APPLE)
    message(FATAL_ERROR "AUDILINK_BUILD_LINUX_GUI is Linux-only")
  endif()
  find_package(PkgConfig REQUIRED)
  pkg_check_modules(GTK4 REQUIRED IMPORTED_TARGET gtk4>=4.6)
  find_program(GLIB_COMPILE_RESOURCES_EXECUTABLE NAMES glib-compile-resources REQUIRED)
  set(AUDILINK_LINUX_RESOURCE_SOURCE "${CMAKE_CURRENT_BINARY_DIR}/audilink-linux-resources.c")
  add_custom_command(OUTPUT "${AUDILINK_LINUX_RESOURCE_SOURCE}"
    COMMAND "${GLIB_COMPILE_RESOURCES_EXECUTABLE}" --generate-source --c-name=audilink_linux_resources
      "--target=${AUDILINK_LINUX_RESOURCE_SOURCE}" audilink.gresource.xml
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/app/linux"
    DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/app/linux/audilink.gresource.xml"
      "${CMAKE_CURRENT_SOURCE_DIR}/app/linux/assets/audilink-emblem.png"
    VERBATIM)
  add_executable(audilink app/linux/main.c "${AUDILINK_LINUX_RESOURCE_SOURCE}")
  set_source_files_properties("${AUDILINK_LINUX_RESOURCE_SOURCE}" PROPERTIES COMPILE_OPTIONS "-w")
  target_link_libraries(audilink PRIVATE AUDILINK::Core PkgConfig::GTK4)
  link_enable_linux_gtk_shell(audilink UDEV_RULE_NAME "60-audilink-openport2.rules")
  install(TARGETS audilink RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}")
  install(FILES app/linux/assets/audilink-emblem.png DESTINATION "${CMAKE_INSTALL_DATADIR}/pixmaps" RENAME audilink.png)
  install(FILES app/linux/audilink.desktop DESTINATION "${CMAKE_INSTALL_DATADIR}/applications")
  install(FILES README.md docs/OBD2.md docs/GENERIC_BASELINE.md DESTINATION "${CMAKE_INSTALL_DATADIR}/doc/audilink")
  set(CPACK_GENERATOR "DEB")
  set(CPACK_PACKAGE_NAME "audilink")
  set(CPACK_PACKAGE_VENDOR "Infiltrator Projects")
  set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Audi diagnostics GUI using LINK")
  set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
  set(CPACK_PACKAGE_CONTACT "Infiltrator Projects")
  set(CPACK_PACKAGING_INSTALL_PREFIX "/usr")
  set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Infiltrator Projects")
  set(CPACK_DEBIAN_PACKAGE_SECTION "utils")
  set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "amd64")
  set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)
  set(CPACK_DEBIAN_FILE_NAME DEB-DEFAULT)
  set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
  include(CPack)
endif()

if(AUDILINK_BUILD_WINDOWS_DISCOVER)
  if(NOT WIN32)
    message(FATAL_ERROR "AUDILINK_BUILD_WINDOWS_DISCOVER is Windows-only")
  endif()
  link_add_windows_discover(audilink-discover
    PRODUCT_NAME "AUDILINK" PRODUCT_SLUG "audilink" WINDOW_CLASS "AUDILINKDiscoverWindow"
    PRODUCT_VERSION "${PROJECT_VERSION}" PRODUCT_COPYRIGHT "Copyright (C) 2026 Shannon Smith"
    PRODUCT_SUBTITLE "Audi Diagnostics"
    PRODUCT_DESCRIPTION "A C-first, open-source Audi vehicle diagnostics platform."
    PRODUCT_AUTHORS "Shannon Smith"
    PRODUCT_LICENSE_NAME "GPL-3.0-or-later"
    PRODUCT_WEBSITE "https://github.com/Infiltrator-Projects/AUDILINK"
    PRODUCT_ICON_PNG "${CMAKE_CURRENT_SOURCE_DIR}/app/ios/AUDILINK/Assets.xcassets/AppIcon.appiconset/AppIcon-60@3x.png")
  target_link_libraries(audilink-discover PRIVATE AUDILINK::Core)
  if(MSVC)
    target_compile_options(audilink-discover PRIVATE
      "/FI${CMAKE_CURRENT_SOURCE_DIR}/src/link/platform/windows/link-discover-theme.h")
  endif()
  target_compile_definitions(audilink-discover PRIVATE
    LINK_THEME_BACKGROUND=0x000C0A09
    LINK_THEME_PANEL=0x001A1715
    LINK_THEME_INPUT=0x00141211
    LINK_THEME_TEXT=0x00F3F2F1
    LINK_THEME_MUTED=0x00A8A29D
    LINK_THEME_ACCENT=0x003D1FD9
    LINK_THEME_ACCENT_TEXT=0x00141211
    "LINK_PRODUCT_FONT_UI=\"Segoe UI\"")
endif()
