import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtMultimedia
import audio_player_live 1.0

Window {
    id: root

    width: 1240
    height: 740
    minimumWidth: 1040
    minimumHeight: 640
    visible: true
    title: "MediaPlayer IVI"
    color: backgroundColor

    // pageIndex: 0 = audio, 1 = Bluetooth receiver, 2 = video
    property int pageIndex: 0
    property string sourceMode: "local"
    property string videoName: "No video selected"
    property bool showSplash: true

    readonly property color backgroundColor: "#0B0D10"
    readonly property color railColor: "#101318"
    readonly property color surfaceColor: "#15191E"
    readonly property color raisedColor: "#1C2127"
    readonly property color hoverColor: "#252B32"
    readonly property color lineColor: "#2B323A"
    readonly property color textColor: "#F4F2ED"
    readonly property color dimTextColor: "#9AA3AD"
    readonly property color faintTextColor: "#67717C"
    readonly property color accentColor: "#F2A65A"
    readonly property color accentDarkColor: "#3A291B"
    readonly property color blackColor: "#050607"

    palette.window: backgroundColor
    palette.windowText: textColor
    palette.text: textColor
    palette.buttonText: textColor
    palette.button: raisedColor
    palette.highlight: accentColor

    function fileName(path) {
        var value = path.toString()
        var parts = value.split("/")
        return decodeURIComponent(parts[parts.length - 1])
    }

    function openAudioPage(mode) {
        pageIndex = 0
        sourceMode = mode
        videoPlayer.pause()
    }

    function currentTitle() {
        if (sourceMode === "radio") {
            if (audioController.currentRadioStationName.length > 0)
                return audioController.currentRadioStationName
            return "Choose a station"
        }

        if (audioController.audioTitle.length > 0)
            return audioController.audioTitle

        if (audioController.playlist.length > 0 &&
                audioController.currentPlaylistIndex >= 0) {
            return fileName(audioController.playlist[audioController.currentPlaylistIndex])
        }

        return "Nothing playing"
    }

    function currentSubtitle() {
        if (sourceMode === "radio") {
            if (audioController.currentRadioStationCountry.length > 0)
                return audioController.currentRadioStationCountry
            return "Internet Radio"
        }

        if (audioController.audioAuthor.length > 0)
            return audioController.audioAuthor

        return sourceMode === "usb" ? "USB Media" : "Local Library"
    }

    function sourceLabel() {
        if (sourceMode === "radio")
            return "RADIO"
        if (sourceMode === "usb")
            return "USB"
        return "LOCAL"
    }

    // ------------------------------------------------------------------
    // Reusable controls. They style normal Qt controls only.
    // Playback, seeking and volume still use the normal Slider/Button API.
    // ------------------------------------------------------------------
    component NavButton: Button {
        id: navButton
        property url iconSource
        property string label
        property bool selected: false

        implicitWidth: 88
        implicitHeight: 72
        padding: 0
        flat: true

        background: Rectangle {
            radius: 10
            color: navButton.selected ? root.raisedColor
                                      : navButton.hovered ? root.hoverColor : "transparent"

            Rectangle {
                width: 3
                height: 30
                radius: 2
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                color: navButton.selected ? root.accentColor : "transparent"
            }
        }

        contentItem: Item {
            Row {
                anchors.centerIn: parent
                spacing: 9

                Image {
                    width: 22
                    height: 22
                    anchors.verticalCenter: parent.verticalCenter
                    source: navButton.iconSource
                    fillMode: Image.PreserveAspectFit
                    opacity: navButton.selected ? 1.0 : 0.78
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: navButton.label
                    color: navButton.selected ? root.textColor : root.dimTextColor
                    font.pixelSize: 11
                    font.bold: true
                }
            }
        }
    }

    component RoundButton: Button {
        id: roundButton
        property url iconSource
        property bool primary: false

        implicitWidth: primary ? 62 : 48
        implicitHeight: primary ? 62 : 48
        padding: 0

        background: Rectangle {
            radius: width / 2
            color: roundButton.primary
                   ? (roundButton.down ? "#D98D46" : root.accentColor)
                   : (roundButton.down || roundButton.hovered ? root.hoverColor : root.raisedColor)
            border.width: roundButton.primary ? 0 : 1
            border.color: root.lineColor
        }

        contentItem: Item {
            Image {
                anchors.centerIn: parent
                width: roundButton.primary ? 27 : 20
                height: roundButton.primary ? 27 : 20
                source: roundButton.iconSource
                fillMode: Image.PreserveAspectFit
            }
        }
    }

    component ActionButton: Button {
        id: actionButton
        property url iconSource
        property bool accent: false

        implicitWidth: 152
        implicitHeight: 42
        padding: 0

        background: Rectangle {
            radius: 9
            color: actionButton.accent
                   ? (actionButton.down ? "#D98D46" : root.accentColor)
                   : (actionButton.down || actionButton.hovered ? root.hoverColor : root.raisedColor)
            border.width: actionButton.accent ? 0 : 1
            border.color: root.lineColor
        }

        contentItem: Item {
            Row {
                anchors.centerIn: parent
                spacing: 8

                Image {
                    width: 17
                    height: 17
                    anchors.verticalCenter: parent.verticalCenter
                    visible: actionButton.iconSource.toString().length > 0
                    source: actionButton.iconSource
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: actionButton.text
                    color: root.textColor
                    font.pixelSize: 12
                    font.bold: true
                }
            }
        }
    }

    component SmallButton: Button {
        id: smallButton
        implicitWidth: 94
        implicitHeight: 38
        padding: 0

        background: Rectangle {
            radius: 8
            color: smallButton.down || smallButton.hovered ? root.hoverColor : root.raisedColor
            border.width: 1
            border.color: root.lineColor
        }

        contentItem: Item {
            Text {
                anchors.centerIn: parent
                text: smallButton.text
                color: root.textColor
                font.pixelSize: 11
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    component StyledSlider: Slider {
        id: slider
        implicitHeight: 30

        background: Rectangle {
            x: slider.leftPadding
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            width: slider.availableWidth
            height: 4
            radius: 2
            color: root.lineColor

            Rectangle {
                width: slider.visualPosition * parent.width
                height: parent.height
                radius: 2
                color: slider.enabled ? root.accentColor : root.faintTextColor
            }
        }

        handle: Rectangle {
            x: slider.leftPadding +
               slider.visualPosition * (slider.availableWidth - width)
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            width: 16
            height: 16
            radius: 8
            color: root.textColor
            border.width: 3
            border.color: slider.enabled ? root.accentColor : root.lineColor
        }
    }

    component FormField: TextField {
        id: field
        implicitHeight: 44
        color: root.textColor
        placeholderTextColor: root.faintTextColor
        selectionColor: root.accentColor
        selectedTextColor: root.blackColor
        font.pixelSize: 13
        leftPadding: 13
        rightPadding: 13

        background: Rectangle {
            radius: 8
            color: root.backgroundColor
            border.width: 1
            border.color: field.activeFocus ? root.accentColor : root.lineColor
        }
    }

    AudioPlayer {
        id: audioController
    }

    AudioOutput {
        id: videoAudioOutput
        volume: 0.70
    }

    MediaPlayer {
        id: videoPlayer
        audioOutput: videoAudioOutput
        videoOutput: videoOutput
    }

    Connections {
        target: audioController

        function onErrorOccurred() {
            errorDialog.text = audioController.errorString
            errorDialog.open()
        }
    }

    Timer {
        interval: 1900
        running: true
        repeat: false
        onTriggered: root.showSplash = false
    }

    FolderDialog {
        id: localFolderDialog
        title: "Choose Music Folder"

        onAccepted: {
            root.openAudioPage("local")
            audioController.loadFolder(selectedFolder.toString())
        }
    }

    FolderDialog {
        id: usbFolderDialog
        title: "Choose USB Music Folder"

        onAccepted: {
            root.openAudioPage("usb")
            audioController.loadFolder(selectedFolder.toString())
        }
    }

    FileDialog {
        id: videoFileDialog
        title: "Choose Video"
        fileMode: FileDialog.OpenFile
        nameFilters: [
            "Video files (*.mp4 *.mkv *.avi *.mov *.webm *.m4v)",
            "All files (*)"
        ]

        onAccepted: {
            audioController.stop()
            root.pageIndex = 2
            root.videoName = root.fileName(selectedFile)
            videoPlayer.source = selectedFile
            videoPlayer.play()
        }
    }

    MessageDialog {
        id: errorDialog
        title: "MediaPlayer IVI"
        text: ""
    }

    Dialog {
        id: addStationDialog
        modal: true
        width: 430
        anchors.centerIn: Overlay.overlay
        padding: 0
        standardButtons: Dialog.NoButton

        onOpened: {
            stationName.text = ""
            stationCountry.text = ""
            stationUrl.text = ""
            stationName.forceActiveFocus()
        }

        background: Rectangle {
            radius: 14
            color: root.surfaceColor
            border.width: 1
            border.color: root.lineColor
        }

        contentItem: ColumnLayout {
            spacing: 14

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 72
                color: root.raisedColor
                radius: 14

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Add Radio Station"
                    color: root.textColor
                    font.pixelSize: 18
                    font.bold: true
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                spacing: 7

                Text {
                    text: "Station name"
                    color: root.dimTextColor
                    font.pixelSize: 11
                }

                FormField {
                    id: stationName
                    Layout.fillWidth: true
                    placeholderText: "Example Radio"
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                spacing: 7

                Text {
                    text: "Country"
                    color: root.dimTextColor
                    font.pixelSize: 11
                }

                FormField {
                    id: stationCountry
                    Layout.fillWidth: true
                    placeholderText: "Optional"
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                spacing: 7

                Text {
                    text: "Stream URL"
                    color: root.dimTextColor
                    font.pixelSize: 11
                }

                FormField {
                    id: stationUrl
                    Layout.fillWidth: true
                    placeholderText: "https://..."
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                Layout.bottomMargin: 20
                Layout.topMargin: 6
                spacing: 10

                Item { Layout.fillWidth: true }

                SmallButton {
                    text: "Cancel"
                    onClicked: addStationDialog.close()
                }

                ActionButton {
                    text: "Add Station"
                    iconSource: "icons/plus.png"
                    accent: true
                    enabled: stationName.text.trim().length > 0 &&
                             stationUrl.text.trim().length > 0

                    onClicked: {
                        audioController.addRadioStation(
                                    stationName.text,
                                    stationCountry.text,
                                    stationUrl.text)
                        addStationDialog.close()
                    }
                }
            }
        }
    }

    // ------------------------------------------------------------------
    // Main application
    // ------------------------------------------------------------------
    Rectangle {
        anchors.fill: parent
        color: root.backgroundColor

        RowLayout {
            anchors.fill: parent
            spacing: 0

            // Left source rail
            Rectangle {
                Layout.preferredWidth: 112
                Layout.fillHeight: true
                color: root.railColor

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 74

                        Image {
                            anchors.centerIn: parent
                            width: 43
                            height: 43
                            source: "icons/logo.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        color: root.lineColor
                    }

                    NavButton {
                        Layout.fillWidth: true
                        iconSource: "icons/folder.png"
                        label: "Local"
                        selected: root.pageIndex === 0 && root.sourceMode === "local"

                        onClicked: {
                            root.openAudioPage("local")
                            localFolderDialog.open()
                        }
                    }

                    NavButton {
                        Layout.fillWidth: true
                        iconSource: "icons/radio.png"
                        label: "Radio"
                        selected: root.pageIndex === 0 && root.sourceMode === "radio"
                        onClicked: root.openAudioPage("radio")
                    }

                    NavButton {
                        Layout.fillWidth: true
                        iconSource: "icons/usb.png"
                        label: "USB"
                        selected: root.pageIndex === 0 && root.sourceMode === "usb"

                        onClicked: {
                            root.openAudioPage("usb")
                            usbFolderDialog.open()
                        }
                    }

                    NavButton {
                        Layout.fillWidth: true
                        iconSource: "icons/bluetooth.png"
                        label: "Phone"
                        selected: root.pageIndex === 1

                        onClicked: {
                            audioController.stop()
                            videoPlayer.pause()
                            root.pageIndex = 1
                        }
                    }

                    NavButton {
                        Layout.fillWidth: true
                        iconSource: "icons/video.png"
                        label: "Video"
                        selected: root.pageIndex === 2

                        onClicked: {
                            audioController.stop()
                            root.pageIndex = 2
                        }
                    }

                    Item { Layout.fillHeight: true }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "IVI"
                        color: root.faintTextColor
                        font.pixelSize: 10
                        font.bold: true
                        font.letterSpacing: 2
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                // Top bar
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 72
                    color: root.backgroundColor

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 26
                        anchors.rightMargin: 26

                        ColumnLayout {
                            spacing: 1

                            Text {
                                text: root.pageIndex === 0 ? "MEDIA" :
                                      root.pageIndex === 1 ? "PHONE AUDIO" : "VIDEO"
                                color: root.accentColor
                                font.pixelSize: 9
                                font.bold: true
                                font.letterSpacing: 1.5
                            }

                            Text {
                                text: root.pageIndex === 0 ? root.sourceLabel() + " PLAYER" :
                                      root.pageIndex === 1 ? "BLUETOOTH RECEIVER" : "VIDEO PLAYER"
                                color: root.textColor
                                font.pixelSize: 17
                                font.bold: true
                            }
                        }

                        Item { Layout.fillWidth: true }

                        Rectangle {
                            Layout.preferredWidth: 9
                            Layout.preferredHeight: 9
                            radius: 5
                            color: (root.pageIndex === 0 && audioController.playing) ||
                                   (root.pageIndex === 2 &&
                                    videoPlayer.playbackState === MediaPlayer.PlayingState)
                                   ? root.accentColor : root.faintTextColor
                        }

                        Text {
                            text: (root.pageIndex === 0 && audioController.playing) ||
                                  (root.pageIndex === 2 &&
                                   videoPlayer.playbackState === MediaPlayer.PlayingState)
                                  ? "PLAYING" : "READY"
                            color: root.dimTextColor
                            font.pixelSize: 10
                            font.bold: true
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: root.lineColor
                }

                StackLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    currentIndex: root.pageIndex

                    // ==================================================
                    // AUDIO PAGE
                    // ==================================================
                    Item {
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 24
                            spacing: 18

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: root.surfaceColor
                                radius: 16
                                border.width: 1
                                border.color: root.lineColor

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 26
                                    spacing: 14

                                    RowLayout {
                                        Layout.fillWidth: true

                                        Rectangle {
                                            Layout.preferredWidth: 78
                                            Layout.preferredHeight: 28
                                            radius: 14
                                            color: root.accentDarkColor

                                            Text {
                                                anchors.centerIn: parent
                                                text: root.sourceLabel()
                                                color: root.accentColor
                                                font.pixelSize: 9
                                                font.bold: true
                                                font.letterSpacing: 1
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                            }
                                        }

                                        Item { Layout.fillWidth: true }

                                        ActionButton {
                                            visible: root.sourceMode !== "radio"
                                            text: root.sourceMode === "usb" ? "Choose USB" : "Choose Folder"
                                            iconSource: root.sourceMode === "usb"
                                                        ? "icons/usb.png" : "icons/folder.png"

                                            onClicked: {
                                                if (root.sourceMode === "usb")
                                                    usbFolderDialog.open()
                                                else
                                                    localFolderDialog.open()
                                            }
                                        }
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        Column {
                                            anchors.centerIn: parent
                                            width: Math.min(parent.width - 30, 520)
                                            spacing: 14

                                            Rectangle {
                                                width: 190
                                                height: 190
                                                radius: 95
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                color: root.backgroundColor
                                                border.width: 1
                                                border.color: root.lineColor

                                                Rectangle {
                                                    width: 128
                                                    height: 128
                                                    radius: 64
                                                    anchors.centerIn: parent
                                                    color: root.accentDarkColor

                                                    Image {
                                                        anchors.centerIn: parent
                                                        width: 60
                                                        height: 60
                                                        source: root.sourceMode === "radio"
                                                                ? "icons/radio.png" : "icons/disc.png"
                                                        fillMode: Image.PreserveAspectFit
                                                    }
                                                }
                                            }

                                            Text {
                                                width: parent.width
                                                text: root.currentTitle()
                                                color: root.textColor
                                                font.pixelSize: 25
                                                font.bold: true
                                                horizontalAlignment: Text.AlignHCenter
                                                elide: Text.ElideRight
                                            }

                                            Text {
                                                width: parent.width
                                                text: root.currentSubtitle()
                                                color: root.dimTextColor
                                                font.pixelSize: 13
                                                horizontalAlignment: Text.AlignHCenter
                                                elide: Text.ElideRight
                                            }

                                            Text {
                                                width: parent.width
                                                visible: root.sourceMode !== "radio" &&
                                                         audioController.audioAlbum.length > 0
                                                text: audioController.audioAlbum
                                                color: root.faintTextColor
                                                font.pixelSize: 11
                                                horizontalAlignment: Text.AlignHCenter
                                                elide: Text.ElideRight
                                            }
                                        }
                                    }

                                    StyledSlider {
                                        id: audioSeek
                                        Layout.fillWidth: true
                                        from: 0
                                        to: Math.max(1, audioController.duration)
                                        value: audioController.position
                                        enabled: root.sourceMode !== "radio" &&
                                                 audioController.duration > 0
                                        live: true
                                        onMoved: audioController.position = Math.round(value)
                                    }

                                    RowLayout {
                                        Layout.fillWidth: true

                                        Text {
                                            text: root.sourceMode === "radio"
                                                  ? "LIVE" : audioController.formatTime(audioController.position)
                                            color: root.sourceMode === "radio"
                                                   ? root.accentColor : root.dimTextColor
                                            font.pixelSize: 10
                                            font.bold: root.sourceMode === "radio"
                                        }

                                        Item { Layout.fillWidth: true }

                                        Text {
                                            text: root.sourceMode === "radio"
                                                  ? "STREAM" : audioController.formatTime(audioController.duration)
                                            color: root.dimTextColor
                                            font.pixelSize: 10
                                        }
                                    }

                                    RowLayout {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 66
                                        spacing: 12

                                        Item { Layout.fillWidth: true }

                                        RoundButton {
                                            iconSource: "icons/previous.png"
                                            onClicked: audioController.previous()
                                        }

                                        RoundButton {
                                            primary: true
                                            iconSource: audioController.playing
                                                        ? "icons/pause.png" : "icons/play.png"
                                            onClicked: audioController.playPause()
                                        }

                                        RoundButton {
                                            iconSource: "icons/stop.png"
                                            onClicked: audioController.stop()
                                        }

                                        RoundButton {
                                            iconSource: "icons/next.png"
                                            onClicked: audioController.next()
                                        }

                                        Item { Layout.fillWidth: true }
                                    }

                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 10

                                        Button {
                                            id: muteButton
                                            Layout.preferredWidth: 38
                                            Layout.preferredHeight: 38
                                            padding: 0

                                            background: Rectangle {
                                                radius: 8
                                                color: muteButton.hovered ? root.hoverColor : "transparent"
                                            }

                                            contentItem: Item {
                                                Image {
                                                    anchors.centerIn: parent
                                                    width: 19
                                                    height: 19
                                                    source: audioController.muted
                                                            ? "icons/mute.png" : "icons/volume.png"
                                                    fillMode: Image.PreserveAspectFit
                                                }
                                            }

                                            onClicked: audioController.muted = !audioController.muted
                                        }

                                        StyledSlider {
                                            id: audioVolume
                                            Layout.fillWidth: true
                                            from: 0
                                            to: 1
                                            stepSize: 0.01
                                            value: audioController.volume
                                            live: true
                                            onMoved: audioController.volume = value
                                        }

                                        Text {
                                            Layout.preferredWidth: 42
                                            text: Math.round(audioController.volume * 100) + "%"
                                            color: root.dimTextColor
                                            font.pixelSize: 10
                                            horizontalAlignment: Text.AlignRight
                                        }
                                    }
                                }
                            }

                            // Playlist / radio stations
                            Rectangle {
                                Layout.preferredWidth: 370
                                Layout.fillHeight: true
                                color: root.surfaceColor
                                radius: 16
                                border.width: 1
                                border.color: root.lineColor

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 18
                                    spacing: 12

                                    RowLayout {
                                        Layout.fillWidth: true

                                        ColumnLayout {
                                            spacing: 1

                                            Text {
                                                text: root.sourceMode === "radio" ? "STATIONS" : "QUEUE"
                                                color: root.textColor
                                                font.pixelSize: 16
                                                font.bold: true
                                            }

                                            Text {
                                                text: root.sourceMode === "radio"
                                                      ? audioController.radioStations.length + " saved stations"
                                                      : audioController.playlist.length + " tracks"
                                                color: root.dimTextColor
                                                font.pixelSize: 10
                                            }
                                        }

                                        Item { Layout.fillWidth: true }

                                        Button {
                                            id: addRadioButton
                                            visible: root.sourceMode === "radio"
                                            Layout.preferredWidth: 38
                                            Layout.preferredHeight: 38
                                            padding: 0

                                            background: Rectangle {
                                                radius: 9
                                                color: addRadioButton.hovered
                                                       ? root.hoverColor : root.raisedColor
                                                border.width: 1
                                                border.color: root.lineColor
                                            }

                                            contentItem: Item {
                                                Image {
                                                    anchors.centerIn: parent
                                                    width: 17
                                                    height: 17
                                                    source: "icons/plus.png"
                                                }
                                            }

                                            onClicked: addStationDialog.open()
                                        }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 1
                                        color: root.lineColor
                                    }

                                    ListView {
                                        id: playlistView
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        visible: root.sourceMode !== "radio"
                                        clip: true
                                        spacing: 6
                                        model: audioController.playlist

                                        delegate: Button {
                                            id: trackButton
                                            required property int index
                                            required property string modelData
                                            width: playlistView.width
                                            height: 58
                                            padding: 0

                                            background: Rectangle {
                                                radius: 9
                                                color: trackButton.index === audioController.currentPlaylistIndex
                                                       ? root.accentDarkColor
                                                       : trackButton.hovered ? root.hoverColor : "transparent"
                                            }

                                            contentItem: RowLayout {
                                                spacing: 11

                                                Rectangle {
                                                    Layout.preferredWidth: 34
                                                    Layout.preferredHeight: 34
                                                    radius: 8
                                                    color: root.raisedColor

                                                    Image {
                                                        anchors.centerIn: parent
                                                        width: 17
                                                        height: 17
                                                        source: "icons/disc.png"
                                                    }
                                                }

                                                Text {
                                                    Layout.fillWidth: true
                                                    text: root.fileName(trackButton.modelData)
                                                    color: root.textColor
                                                    font.pixelSize: 12
                                                    elide: Text.ElideRight
                                                    verticalAlignment: Text.AlignVCenter
                                                }

                                                Text {
                                                    visible: trackButton.index === audioController.currentPlaylistIndex
                                                    text: "NOW"
                                                    color: root.accentColor
                                                    font.pixelSize: 8
                                                    font.bold: true
                                                }
                                            }

                                            onClicked: audioController.playPlaylistIndex(index)
                                        }

                                        Text {
                                            anchors.centerIn: parent
                                            visible: audioController.playlist.length === 0
                                            width: parent.width - 40
                                            text: root.sourceMode === "usb"
                                                  ? "Choose the mounted USB music folder"
                                                  : "Choose a folder to load your music"
                                            color: root.dimTextColor
                                            font.pixelSize: 12
                                            horizontalAlignment: Text.AlignHCenter
                                            wrapMode: Text.WordWrap
                                        }
                                    }

                                    ListView {
                                        id: radioView
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        visible: root.sourceMode === "radio"
                                        clip: true
                                        spacing: 7
                                        model: audioController.radioStations

                                        delegate: Button {
                                            id: stationButton
                                            required property int index
                                            required property var modelData
                                            width: radioView.width
                                            height: 66
                                            padding: 0

                                            property bool currentStation:
                                                audioController.currentRadioStationName === modelData.name

                                            background: Rectangle {
                                                radius: 9
                                                color: stationButton.currentStation
                                                       ? root.accentDarkColor
                                                       : stationButton.hovered ? root.hoverColor : "transparent"
                                            }

                                            contentItem: RowLayout {
                                                spacing: 11

                                                Rectangle {
                                                    Layout.preferredWidth: 38
                                                    Layout.preferredHeight: 38
                                                    radius: 9
                                                    color: root.raisedColor

                                                    Image {
                                                        anchors.centerIn: parent
                                                        width: 19
                                                        height: 19
                                                        source: "icons/radio.png"
                                                    }
                                                }

                                                ColumnLayout {
                                                    Layout.fillWidth: true
                                                    spacing: 2

                                                    Text {
                                                        Layout.fillWidth: true
                                                        text: stationButton.modelData.name
                                                        color: root.textColor
                                                        font.pixelSize: 12
                                                        font.bold: stationButton.currentStation
                                                        elide: Text.ElideRight
                                                    }

                                                    Text {
                                                        Layout.fillWidth: true
                                                        text: stationButton.modelData.country
                                                        color: root.dimTextColor
                                                        font.pixelSize: 10
                                                        elide: Text.ElideRight
                                                    }
                                                }

                                                Text {
                                                    visible: stationButton.currentStation
                                                    text: "LIVE"
                                                    color: root.accentColor
                                                    font.pixelSize: 8
                                                    font.bold: true
                                                }
                                            }

                                            onClicked: audioController.playRadioStation(index)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // ==================================================
                    // BLUETOOTH PHONE RECEIVER PAGE
                    // ==================================================
                    Item {
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 24
                            spacing: 18

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: root.surfaceColor
                                radius: 16
                                border.width: 1
                                border.color: root.lineColor

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 32
                                    spacing: 18

                                    ColumnLayout {
                                        Layout.alignment: Qt.AlignHCenter
                                        spacing: 5

                                        Text {
                                            Layout.alignment: Qt.AlignHCenter
                                            text: "PHONE AUDIO"
                                            color: root.accentColor
                                            font.pixelSize: 10
                                            font.bold: true
                                            font.letterSpacing: 1.4
                                        }

                                        Text {
                                            Layout.alignment: Qt.AlignHCenter
                                            text: "Bluetooth Receiver"
                                            color: root.textColor
                                            font.pixelSize: 28
                                            font.bold: true
                                        }

                                        Text {
                                            Layout.alignment: Qt.AlignHCenter
                                            text: "Pair your phone with this IVI system and play audio"
                                            color: root.dimTextColor
                                            font.pixelSize: 12
                                        }
                                    }

                                    Item { Layout.fillHeight: true }

                                    RowLayout {
                                        Layout.alignment: Qt.AlignHCenter
                                        spacing: 24

                                        Rectangle {
                                            Layout.preferredWidth: 122
                                            Layout.preferredHeight: 122
                                            radius: 28
                                            color: root.raisedColor
                                            border.width: 1
                                            border.color: root.lineColor

                                            Image {
                                                anchors.centerIn: parent
                                                width: 60
                                                height: 60
                                                source: "icons/phone.png"
                                                fillMode: Image.PreserveAspectFit
                                            }
                                        }

                                        Text {
                                            text: "→"
                                            color: root.accentColor
                                            font.pixelSize: 34
                                            font.bold: true
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }

                                        Rectangle {
                                            Layout.preferredWidth: 122
                                            Layout.preferredHeight: 122
                                            radius: 61
                                            color: root.accentDarkColor
                                            border.width: 1
                                            border.color: root.accentColor

                                            Image {
                                                anchors.centerIn: parent
                                                width: 60
                                                height: 60
                                                source: "icons/bluetooth.png"
                                                fillMode: Image.PreserveAspectFit
                                            }
                                        }

                                        Text {
                                            text: "→"
                                            color: root.accentColor
                                            font.pixelSize: 34
                                            font.bold: true
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }

                                        Rectangle {
                                            Layout.preferredWidth: 122
                                            Layout.preferredHeight: 122
                                            radius: 28
                                            color: root.raisedColor
                                            border.width: 1
                                            border.color: root.lineColor

                                            Image {
                                                anchors.centerIn: parent
                                                width: 60
                                                height: 60
                                                source: "icons/logo.png"
                                                fillMode: Image.PreserveAspectFit
                                            }
                                        }
                                    }

                                    Item { Layout.fillHeight: true }

                                    RowLayout {
                                        Layout.alignment: Qt.AlignHCenter
                                        spacing: 12

                                        ActionButton {
                                            text: "Pair Phone"
                                            iconSource: "icons/bluetooth.png"
                                            accent: true
                                            implicitWidth: 170
                                            onClicked: audioController.openBluetoothSettings()
                                        }

                                        ActionButton {
                                            text: "Bluetooth Devices"
                                            iconSource: "icons/open.png"
                                            implicitWidth: 174
                                            onClicked: audioController.openBluetoothSettings()
                                        }
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "PHONE  →  BLUETOOTH  →  IVI AUDIO"
                                        color: root.faintTextColor
                                        font.pixelSize: 9
                                        font.bold: true
                                        font.letterSpacing: 1.1
                                    }
                                }
                            }

                            Rectangle {
                                Layout.preferredWidth: 310
                                Layout.fillHeight: true
                                color: root.surfaceColor
                                radius: 16
                                border.width: 1
                                border.color: root.lineColor

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 24
                                    spacing: 18

                                    Text {
                                        text: "CONNECT PHONE"
                                        color: root.textColor
                                        font.pixelSize: 16
                                        font.bold: true
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 1
                                        color: root.lineColor
                                    }

                                    Repeater {
                                        model: [
                                            "Open Bluetooth devices",
                                            "Pair MediaPlayer IVI from your phone",
                                            "Play music on your phone"
                                        ]

                                        RowLayout {
                                            Layout.fillWidth: true
                                            spacing: 12

                                            Rectangle {
                                                Layout.preferredWidth: 28
                                                Layout.preferredHeight: 28
                                                radius: 14
                                                color: root.accentDarkColor

                                                Text {
                                                    anchors.centerIn: parent
                                                    text: index + 1
                                                    color: root.accentColor
                                                    font.pixelSize: 10
                                                    font.bold: true
                                                }
                                            }

                                            Text {
                                                Layout.fillWidth: true
                                                text: modelData
                                                color: root.dimTextColor
                                                font.pixelSize: 11
                                                wrapMode: Text.WordWrap
                                            }
                                        }
                                    }

                                    Item { Layout.fillHeight: true }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 142
                                        radius: 12
                                        color: root.backgroundColor
                                        border.width: 1
                                        border.color: root.lineColor

                                        Column {
                                            anchors.centerIn: parent
                                            spacing: 10

                                            Image {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                width: 44
                                                height: 44
                                                source: "icons/cast.png"
                                            }

                                            Text {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                text: "AUDIO RECEIVER"
                                                color: root.accentColor
                                                font.pixelSize: 9
                                                font.bold: true
                                                font.letterSpacing: 1.1
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // ==================================================
                    // VIDEO PAGE
                    // ==================================================
                    Item {
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 24
                            spacing: 14

                            RowLayout {
                                Layout.fillWidth: true

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2

                                    Text {
                                        text: "NOW SHOWING"
                                        color: root.accentColor
                                        font.pixelSize: 9
                                        font.bold: true
                                        font.letterSpacing: 1.3
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        text: root.videoName
                                        color: root.textColor
                                        font.pixelSize: 21
                                        font.bold: true
                                        elide: Text.ElideRight
                                    }
                                }

                                ActionButton {
                                    text: "Open Video"
                                    iconSource: "icons/open.png"
                                    accent: true
                                    onClicked: videoFileDialog.open()
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: root.blackColor
                                radius: 16
                                border.width: 1
                                border.color: root.lineColor
                                clip: true

                                VideoOutput {
                                    id: videoOutput
                                    anchors.fill: parent
                                    anchors.margins: 2
                                    fillMode: VideoOutput.PreserveAspectFit
                                }

                                Column {
                                    anchors.centerIn: parent
                                    spacing: 12
                                    visible: videoPlayer.source.toString() === ""

                                    Rectangle {
                                        width: 82
                                        height: 82
                                        radius: 20
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: root.raisedColor
                                        border.width: 1
                                        border.color: root.lineColor

                                        Image {
                                            anchors.centerIn: parent
                                            width: 38
                                            height: 38
                                            source: "icons/video.png"
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }

                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "Open a video to begin"
                                        color: root.dimTextColor
                                        font.pixelSize: 12
                                    }
                                }
                            }

                            StyledSlider {
                                id: videoSeek
                                Layout.fillWidth: true
                                from: 0
                                to: Math.max(1, videoPlayer.duration)
                                value: videoPlayer.position
                                enabled: videoPlayer.duration > 0
                                live: true
                                onMoved: videoPlayer.position = Math.round(value)
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 11

                                Text {
                                    Layout.preferredWidth: 54
                                    text: audioController.formatTime(videoPlayer.position)
                                    color: root.dimTextColor
                                    font.pixelSize: 10
                                }

                                Item { Layout.fillWidth: true }

                                RoundButton {
                                    primary: true
                                    iconSource: videoPlayer.playbackState === MediaPlayer.PlayingState
                                                ? "icons/pause.png" : "icons/play.png"

                                    onClicked: {
                                        if (videoPlayer.playbackState === MediaPlayer.PlayingState)
                                            videoPlayer.pause()
                                        else
                                            videoPlayer.play()
                                    }
                                }

                                RoundButton {
                                    iconSource: "icons/stop.png"
                                    onClicked: videoPlayer.stop()
                                }

                                Item { Layout.fillWidth: true }

                                Image {
                                    Layout.preferredWidth: 19
                                    Layout.preferredHeight: 19
                                    source: "icons/volume.png"
                                    fillMode: Image.PreserveAspectFit
                                }

                                StyledSlider {
                                    id: videoVolume
                                    Layout.preferredWidth: 190
                                    from: 0
                                    to: 1
                                    stepSize: 0.01
                                    value: videoAudioOutput.volume
                                    live: true
                                    onMoved: videoAudioOutput.volume = value
                                }

                                Text {
                                    Layout.preferredWidth: 42
                                    text: Math.round(videoAudioOutput.volume * 100) + "%"
                                    color: root.dimTextColor
                                    font.pixelSize: 10
                                    horizontalAlignment: Text.AlignRight
                                }

                                Text {
                                    Layout.preferredWidth: 54
                                    text: audioController.formatTime(videoPlayer.duration)
                                    color: root.dimTextColor
                                    font.pixelSize: 10
                                    horizontalAlignment: Text.AlignRight
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // ------------------------------------------------------------------
    // Splash screen
    // ------------------------------------------------------------------
    Rectangle {
        id: splash
        anchors.fill: parent
        z: 100
        visible: root.showSplash
        color: root.backgroundColor

        Column {
            anchors.centerIn: parent
            spacing: 16

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 112
                height: 112
                source: "icons/logo.png"
                fillMode: Image.PreserveAspectFit
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "MediaPlayer IVI"
                color: root.textColor
                font.pixelSize: 29
                font.bold: true
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "EMBEDDED LINUX MEDIA SYSTEM"
                color: root.dimTextColor
                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 2
            }

            Rectangle {
                width: 230
                height: 1
                anchors.horizontalCenter: parent.horizontalCenter
                color: root.lineColor
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Under supervision of"
                color: root.faintTextColor
                font.pixelSize: 10
            }

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 76
                height: 76
                source: "icons/iti.png"
                fillMode: Image.PreserveAspectFit
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Information Technology Institute"
                color: root.dimTextColor
                font.pixelSize: 10
                font.bold: true
            }
        }
    }
}
