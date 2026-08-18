cmake_minimum_required(VERSION 3.16)

project(MediaPlayerIVI VERSION 1.5 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Multimedia)
qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appMediaPlayerIVI
    main.cpp
    audioplayer.cpp
    audioplayer.h
)

qt_add_qml_module(appMediaPlayerIVI
    URI audio_player_live
    VERSION 1.0
    QML_FILES
        Main.qml
    RESOURCES
        icons/logo.png
        icons/folder.png
        icons/radio.png
        icons/usb.png
        icons/bluetooth.png
        icons/video.png
        icons/disc.png
        icons/previous.png
        icons/play.png
        icons/pause.png
        icons/stop.png
        icons/next.png
        icons/mute.png
        icons/volume.png
        icons/plus.png
        icons/open.png
        icons/cast.png
        icons/phone.png
        icons/iti.png
)

target_link_libraries(appMediaPlayerIVI
    PRIVATE Qt6::Quick Qt6::Multimedia
)
