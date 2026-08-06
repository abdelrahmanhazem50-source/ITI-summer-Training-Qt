cmake_minimum_required(VERSION 3.16)

project(GeddoSmartHome VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick LinguistTools)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appGeddoSmartHome
    main.cpp
)

qt_add_qml_module(appGeddoSmartHome
    URI GeddoSmartHome
    VERSION 1.0
    QML_FILES
        Main.qml
)

qt_add_translations(appGeddoSmartHome
    TS_FILES
        translations/smarthome_ar.ts
    RESOURCE_PREFIX "/i18n"
)

target_link_libraries(appGeddoSmartHome
    PRIVATE Qt6::Quick
)

set_target_properties(appGeddoSmartHome PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)
