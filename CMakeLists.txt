cmake_minimum_required(VERSION 3.16)

project(kiosk-browser VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick WebEngineQuick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appkiosk-browser
    main.cpp
)

qt_add_qml_module(appkiosk-browser
    URI kiosk-browser
    VERSION 1.0
    QML_FILES
        Main.qml
)

target_link_libraries(appkiosk-browser
    PRIVATE Qt6::Quick Qt6::WebEngineQuick
)

include(GNUInstallDirs)
install(TARGETS appkiosk-browser
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
