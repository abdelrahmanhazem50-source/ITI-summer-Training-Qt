cmake_minimum_required(VERSION 3.16)

project(GeddoStore VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick LinguistTools)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appGeddoStore
    main.cpp
)

qt_add_qml_module(appGeddoStore
    URI GeddoStore
    VERSION 1.0
    QML_FILES
        Main.qml
)

qt_add_translations(appGeddoStore
    TS_FILES
        translations/store_ar.ts
    RESOURCE_PREFIX "/i18n"
)

target_link_libraries(appGeddoStore
    PRIVATE Qt6::Quick
)

set_target_properties(appGeddoStore PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)
