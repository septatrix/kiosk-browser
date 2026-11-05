cmake_minimum_required(VERSION 3.16)

project(kiosk-browser VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick WebEngineQuick)

qt_standard_project_setup(REQUIRES 6.4)

qt_add_executable(kiosk-browser
    main.cpp
)

qt_add_qml_module(kiosk-browser
    URI KioskBrowser
    VERSION 1.0
    # Qt < 6.5 does not default to this prefix, which main.cpp relies on
    RESOURCE_PREFIX /qt/qml
    QML_FILES
        Main.qml
)

target_link_libraries(kiosk-browser
    PRIVATE Qt6::Quick Qt6::WebEngineQuick
)

include(GNUInstallDirs)
install(TARGETS kiosk-browser
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

set(CPACK_PACKAGE_NAME "kiosk-browser")
set(CPACK_PACKAGE_VENDOR "septatrix")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Qt-based kiosk browser")
# Releases pass the version of the tag.
# A plain set() here would shadow it.
if(NOT DEFINED CPACK_PACKAGE_VERSION)
    set(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})
endif()
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "septatrix <noreply@github.com>")
# Libraries are detected automatically.
# QML modules are loaded at runtime, so they have to be listed.
# Each of these is required: the application exits without it.
# Several are not dependencies of the packages that use them.
set(KIOSK_QML_DEPENDS
    # imported by Main.qml
    qml6-module-qtquick
    qml6-module-qtwebengine
    qml6-module-qtquick-virtualkeyboard
    qt6-virtualkeyboard-plugin
    # imports of the above that their packages do not depend on:
    # Main.qml fails to load without WorkerScript,
    # and the keyboard (InputPanel) fails to load without the others
    qml6-module-qtqml
    qml6-module-qtqml-workerscript
    qml6-module-qtquick-window
    qml6-module-qtquick-layouts
    qml6-module-qt-labs-folderlistmodel
)
list(JOIN KIOSK_QML_DEPENDS ", " CPACK_DEBIAN_PACKAGE_DEPENDS)
set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)

include(CPack)
