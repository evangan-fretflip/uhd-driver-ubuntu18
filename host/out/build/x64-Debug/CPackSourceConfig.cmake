# This file will be configured to contain variables for CPack. These variables
# should be set in the CMake list file of the project before CPack module is
# included. The list of available CPACK_xxx variables and their associated
# documentation may be obtained using
#  cpack --help-variable-list
#
# Some variables are common to all generators (e.g. CPACK_PACKAGE_NAME)
# and some are specific to a generator
# (e.g. CPACK_NSIS_EXTRA_INSTALL_COMMANDS). The generator specific variables
# usually begin with CPACK_<GENNAME>_xxxx.


set(CPACK_BUILD_SOURCE_DIRS "E:/UHD/UHD-4.0.0.0(B210适配)/host;E:/UHD/UHD-4.0.0.0(B210适配)/host/out/build/x64-Debug")
set(CPACK_CMAKE_GENERATOR "Ninja")
set(CPACK_COMPONENTS_ALL "libraries;pythonapi;headers;utilities;examples;manual;doxygen;readme;images")
set(CPACK_COMPONENTS_ALL_SET_BY_USER "TRUE")
set(CPACK_COMPONENT_DOXYGEN_DESCRIPTION "API documentation (html)")
set(CPACK_COMPONENT_DOXYGEN_DISPLAY_NAME "Doxygen")
set(CPACK_COMPONENT_DOXYGEN_GROUP "Documentation")
set(CPACK_COMPONENT_EXAMPLES_DEPENDS "libraries")
set(CPACK_COMPONENT_EXAMPLES_DESCRIPTION "Example executables")
set(CPACK_COMPONENT_EXAMPLES_DISPLAY_NAME "Examples")
set(CPACK_COMPONENT_EXAMPLES_GROUP "Runtime")
set(CPACK_COMPONENT_HEADERS_DESCRIPTION "C++ development headers")
set(CPACK_COMPONENT_HEADERS_DISPLAY_NAME "C++ Headers")
set(CPACK_COMPONENT_HEADERS_GROUP "Development")
set(CPACK_COMPONENT_IMAGES_DESCRIPTION "FPGA and firmware images")
set(CPACK_COMPONENT_IMAGES_DISPLAY_NAME "Images")
set(CPACK_COMPONENT_LIBRARIES_DESCRIPTION "Dynamic link library")
set(CPACK_COMPONENT_LIBRARIES_DISPLAY_NAME "Libraries")
set(CPACK_COMPONENT_LIBRARIES_GROUP "Development")
set(CPACK_COMPONENT_MANUAL_DESCRIPTION "Manual/application notes (rst and html)")
set(CPACK_COMPONENT_MANUAL_DISPLAY_NAME "Manual")
set(CPACK_COMPONENT_MANUAL_GROUP "Documentation")
set(CPACK_COMPONENT_PYTHONAPI_DESCRIPTION "UHD Python API")
set(CPACK_COMPONENT_PYTHONAPI_DISPLAY_NAME "UHD Python API")
set(CPACK_COMPONENT_PYTHONAPI_GROUP "Development")
set(CPACK_COMPONENT_README_DESCRIPTION "Readme files (txt)")
set(CPACK_COMPONENT_README_DISPLAY_NAME "Readme")
set(CPACK_COMPONENT_README_GROUP "Documentation")
set(CPACK_COMPONENT_README_REQUIRED "TRUE")
set(CPACK_COMPONENT_TESTS_DEPENDS "libraries")
set(CPACK_COMPONENT_UNSPECIFIED_HIDDEN "TRUE")
set(CPACK_COMPONENT_UNSPECIFIED_REQUIRED "TRUE")
set(CPACK_COMPONENT_UTILITIES_DEPENDS "libraries")
set(CPACK_COMPONENT_UTILITIES_DESCRIPTION "Utility executables and python scripts")
set(CPACK_COMPONENT_UTILITIES_DISPLAY_NAME "Utilities")
set(CPACK_COMPONENT_UTILITIES_GROUP "Runtime")
set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "E:/UHD/UHD-4.0.0.0(B210适配)/host/out/build/x64-Debug/debian/preinst;E:/UHD/UHD-4.0.0.0(B210适配)/host/out/build/x64-Debug/debian/postinst;E:/UHD/UHD-4.0.0.0(B210适配)/host/out/build/x64-Debug/debian/prerm;E:/UHD/UHD-4.0.0.0(B210适配)/host/out/build/x64-Debug/debian/postrm")
set(CPACK_DEBIAN_PACKAGE_DEPENDS "libboost-all-dev, python3-requests")
set(CPACK_DEBIAN_PACKAGE_RECOMMENDS "python3, python3-tk")
set(CPACK_DEFAULT_PACKAGE_DESCRIPTION_FILE "D:/VS 2019/Common7/IDE/CommonExtensions/Microsoft/CMake/CMake/share/cmake-3.20/Templates/CPack.GenericDescription.txt")
set(CPACK_DEFAULT_PACKAGE_DESCRIPTION_SUMMARY "UHD built using CMake")
set(CPACK_GENERATOR "7Z;ZIP")
set(CPACK_IGNORE_FILES "\\.git*;\\.swp$")
set(CPACK_INSTALLED_DIRECTORIES "E:/UHD/UHD-4.0.0.0(B210适配)/host;/")
set(CPACK_INSTALL_CMAKE_PROJECTS "")
set(CPACK_INSTALL_PREFIX "E:/UHD/UHD-4.0.0.0(B210适配)/host/out/install/x64-Debug")
set(CPACK_MODULE_PATH "E:/UHD/UHD-4.0.0.0(B210适配)/host/cmake/Modules")
set(CPACK_NSIS_DISPLAY_NAME "UHD")
set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "
    WriteRegStr HKLM \"SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment\" \"UHD_PKG_PATH\" \"$INSTDIR\"
")
set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "
    DeleteRegValue HKLM \"SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment\" \"UHD_PKG_PATH\"
")
set(CPACK_NSIS_INSTALLER_ICON_CODE "")
set(CPACK_NSIS_INSTALLER_MUI_ICON_CODE "")
set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64")
set(CPACK_NSIS_MODIFY_PATH "ON")
set(CPACK_NSIS_PACKAGE_NAME "UHD")
set(CPACK_NSIS_UNINSTALL_NAME "Uninstall")
set(CPACK_OUTPUT_CONFIG_FILE "E:/UHD/UHD-4.0.0.0(B210适配)/host/out/build/x64-Debug/CPackConfig.cmake")
set(CPACK_PACKAGE_CONTACT "Ettus Research <support@ettus.com>")
set(CPACK_PACKAGE_DEFAULT_LOCATION "/")
set(CPACK_PACKAGE_DESCRIPTION_FILE "D:/VS 2019/Common7/IDE/CommonExtensions/Microsoft/CMake/CMake/share/cmake-3.20/Templates/CPack.GenericDescription.txt")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Ettus Research - USRP Hardware Driver")
set(CPACK_PACKAGE_FILE_NAME "uhd-4.0.0.0-0-unknown")
set(CPACK_PACKAGE_FILE_NAME "uhd-4.0.0.0-0-unknown")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "UHD")
set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "UHD")
set(CPACK_PACKAGE_NAME "UHD")
set(CPACK_PACKAGE_RELOCATABLE "true")
set(CPACK_PACKAGE_VENDOR "Ettus Research (National Instruments)")
set(CPACK_PACKAGE_VERSION "4.0.0.0-0-unknown")
set(CPACK_PACKAGE_VERSION_MAJOR "0")
set(CPACK_PACKAGE_VERSION_MINOR "1")
set(CPACK_PACKAGE_VERSION_PATCH "1")
set(CPACK_RESOURCE_FILE_LICENSE "E:/UHD/UHD-4.0.0.0(B210适配)/host/LICENSE")
set(CPACK_RESOURCE_FILE_README "D:/VS 2019/Common7/IDE/CommonExtensions/Microsoft/CMake/CMake/share/cmake-3.20/Templates/CPack.GenericDescription.txt")
set(CPACK_RESOURCE_FILE_WELCOME "E:/UHD/UHD-4.0.0.0(B210适配)/host/README.md")
set(CPACK_RPM_EXCLUDE_FROM_AUTO_FILELIST_ADDITION "/usr/share/man;/usr/share/man/man1;/usr/lib64/pkgconfig;/usr/lib64/cmake;/usr/lib64/python2.7;/usr/lib64/python2.7/site-packages")
set(CPACK_RPM_PACKAGE_REQUIRES "boost-devel, python3-requests")
set(CPACK_RPM_PACKAGE_SOURCES "ON")
set(CPACK_RPM_POST_INSTALL_SCRIPT_FILE "E:/UHD/UHD-4.0.0.0(B210适配)/host/out/build/x64-Debug/redhat/post_install")
set(CPACK_RPM_POST_UNINSTALL_SCRIPT_FILE "E:/UHD/UHD-4.0.0.0(B210适配)/host/out/build/x64-Debug/redhat/post_uninstall")
set(CPACK_RPM_PRE_INSTALL_SCRIPT_FILE "E:/UHD/UHD-4.0.0.0(B210适配)/host/out/build/x64-Debug/redhat/pre_install")
set(CPACK_RPM_PRE_UNINSTALL_SCRIPT_FILE "E:/UHD/UHD-4.0.0.0(B210适配)/host/out/build/x64-Debug/redhat/pre_uninstall")
set(CPACK_RPM_SPEC_MORE_DEFINE "%global __python %{__python3}")
set(CPACK_SET_DESTDIR "OFF")
set(CPACK_SOURCE_7Z "ON")
set(CPACK_SOURCE_GENERATOR "7Z;ZIP")
set(CPACK_SOURCE_IGNORE_FILES "\\.git*;\\.swp$")
set(CPACK_SOURCE_INSTALLED_DIRECTORIES "E:/UHD/UHD-4.0.0.0(B210适配)/host;/")
set(CPACK_SOURCE_OUTPUT_CONFIG_FILE "E:/UHD/UHD-4.0.0.0(B210适配)/host/out/build/x64-Debug/CPackSourceConfig.cmake")
set(CPACK_SOURCE_PACKAGE_FILE_NAME "uhd-4.0.0.0-0-unknown")
set(CPACK_SOURCE_TOPLEVEL_TAG "win64-Source")
set(CPACK_SOURCE_ZIP "ON")
set(CPACK_STRIP_FILES "")
set(CPACK_SYSTEM_NAME "win64")
set(CPACK_THREADS "1")
set(CPACK_TOPLEVEL_TAG "win64-Source")
set(CPACK_WIX_SIZEOF_VOID_P "8")

if(NOT CPACK_PROPERTIES_FILE)
  set(CPACK_PROPERTIES_FILE "E:/UHD/UHD-4.0.0.0(B210适配)/host/out/build/x64-Debug/CPackProperties.cmake")
endif()

if(EXISTS ${CPACK_PROPERTIES_FILE})
  include(${CPACK_PROPERTIES_FILE})
endif()
