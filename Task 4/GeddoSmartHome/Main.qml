import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window

    width: 1100
    height: 760
    minimumWidth: 680
    minimumHeight: 540
    visible: true
    title: qsTr("Smart Home Control Dashboard")
    color: pageColor

    property string currentUser: ""
    property bool showSplash: true
    property bool darkMode: false
    property bool notificationsEnabled: true
    property bool energySaverEnabled: false
    property int screenBrightness: 78
    property int targetTemperature: 24
    property int activeDevices: 0
    property real liveEnergy: 0.0
    property date currentDate: new Date()

    readonly property bool isArabic: languageManager.currentLanguage === "ar"
    readonly property int textAlignment: isArabic ? Text.AlignRight : Text.AlignLeft

    readonly property color pageColor: darkMode ? "#0B1220" : "#F4F7FC"
    readonly property color cardColor: darkMode ? "#131D2E" : "#FFFFFF"
    readonly property color softCardColor: darkMode ? "#182439" : "#F7F9FD"
    readonly property color primaryColor: "#5B67F1"
    readonly property color primaryDarkColor: "#3039A8"
    readonly property color accentColor: "#22C8A6"
    readonly property color titleColor: darkMode ? "#F7F9FF" : "#172033"
    readonly property color bodyColor: darkMode ? "#AEBBD0" : "#67728A"
    readonly property color borderColor: darkMode ? "#25334B" : "#E5EAF3"
    readonly property color inputColor: darkMode ? "#101929" : "#F7F9FD"

    LayoutMirroring.enabled: isArabic
    LayoutMirroring.childrenInherit: true

    function deviceTitle(key) {
        if (key === "livingLight")
            return qsTr("Living Room Light")
        if (key === "bedroomLight")
            return qsTr("Bedroom Light")
        if (key === "airConditioner")
            return qsTr("Air Conditioner")
        if (key === "fan")
            return qsTr("Ceiling Fan")
        if (key === "garage")
            return qsTr("Garage Door")
        return qsTr("Security Camera")
    }

    function deviceRoom(key) {
        if (key === "livingLight")
            return qsTr("Living room")
        if (key === "bedroomLight")
            return qsTr("Main bedroom")
        if (key === "airConditioner")
            return qsTr("Living room")
        if (key === "fan")
            return qsTr("Guest room")
        if (key === "garage")
            return qsTr("Garage")
        return qsTr("Front entrance")
    }

    function greetingText() {
        var hour = currentDate.getHours()
        if (hour < 12)
            return qsTr("Good morning")
        if (hour < 18)
            return qsTr("Good afternoon")
        return qsTr("Good evening")
    }

    function updateDeviceSummary() {
        var active = 0
        var energy = 0

        for (var i = 0; i < devicesModel.count; i++) {
            if (devicesModel.get(i).isOn) {
                active++
                energy += devicesModel.get(i).energyUsage
            }
        }

        activeDevices = active
        liveEnergy = energy
    }

    function changeDeviceState(index, newState) {
        devicesModel.setProperty(index, "isOn", newState)
        updateDeviceSummary()

        console.log(deviceTitle(devicesModel.get(index).deviceKey)
                    + (newState ? " is ON" : " is OFF"))
    }

    component SoftShadow: Rectangle {
        property int shadowRadius: 24
        property real shadowOpacity: window.darkMode ? 0.28 : 0.08

        width: parent ? parent.width : 0
        height: parent ? parent.height : 0
        radius: shadowRadius
        color: "#000000"
        opacity: shadowOpacity
        x: 0
        y: 8
        z: -1
    }

    component PrimaryButton: Button {
        id: primaryButton

        property string iconSource: ""
        property bool compact: false

        implicitHeight: 52
        implicitWidth: compact ? 52 : 150
        hoverEnabled: true

        contentItem: Row {
            anchors.centerIn: parent
            spacing: primaryButton.iconSource === "" ? 0 : 9
            layoutDirection: window.isArabic ? Qt.RightToLeft : Qt.LeftToRight

            Image {
                width: 21
                height: 21
                visible: primaryButton.iconSource !== ""
                source: primaryButton.iconSource
                fillMode: Image.PreserveAspectFit
            }

            Text {
                visible: !primaryButton.compact
                text: primaryButton.text
                color: "white"
                font.pixelSize: 15
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        background: Rectangle {
            radius: 16
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: primaryButton.down ? "#3D47BC" : "#6E78F5"
                }
                GradientStop {
                    position: 1
                    color: primaryButton.down ? "#252D8B" : "#4753D7"
                }
            }
            scale: primaryButton.down ? 0.97 : primaryButton.hovered ? 1.02 : 1.0

            Behavior on scale {
                NumberAnimation { duration: 130; easing.type: Easing.OutCubic }
            }
        }
    }

    component OutlineButton: Button {
        id: outlineButton

        property string iconSource: ""
        property bool compact: false

        implicitHeight: 44
        implicitWidth: compact ? 44 : 128
        hoverEnabled: true

        contentItem: Row {
            anchors.centerIn: parent
            spacing: outlineButton.iconSource === "" ? 0 : 8
            layoutDirection: window.isArabic ? Qt.RightToLeft : Qt.LeftToRight

            Image {
                width: 20
                height: 20
                visible: outlineButton.iconSource !== ""
                source: outlineButton.iconSource
                fillMode: Image.PreserveAspectFit
            }

            Text {
                visible: !outlineButton.compact
                text: outlineButton.text
                color: window.primaryColor
                font.pixelSize: 14
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        background: Rectangle {
            radius: 14
            color: outlineButton.down
                   ? (window.darkMode ? "#202E46" : "#E7EAFF")
                   : outlineButton.hovered
                     ? (window.darkMode ? "#1C2940" : "#F0F2FF")
                     : "transparent"
            border.color: window.darkMode ? "#394A68" : "#D8DDFB"
            border.width: 1

            Behavior on color { ColorAnimation { duration: 130 } }
        }
    }

    component LanguageButton: Button {
        id: languageButton

        implicitWidth: 112
        implicitHeight: 42
        hoverEnabled: true
        text: window.isArabic ? "English" : "العربية"

        contentItem: Row {
            anchors.centerIn: parent
            spacing: 8

            Image {
                width: 19
                height: 19
                source: "https://img.icons8.com/fluency-systems-filled/96/globe.png"
                fillMode: Image.PreserveAspectFit
            }

            Text {
                text: languageButton.text
                color: window.titleColor
                font.pixelSize: 14
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        background: Rectangle {
            radius: 14
            color: languageButton.hovered ? window.softCardColor : window.cardColor
            border.color: window.borderColor
            border.width: 1
            scale: languageButton.down ? 0.96 : 1.0

            Behavior on scale { NumberAnimation { duration: 100 } }
            Behavior on color { ColorAnimation { duration: 160 } }
        }

        onClicked: languageManager.setLanguage(window.isArabic ? "en" : "ar")
    }

    component ModernSwitch: Item {
        id: modernSwitch

        property bool checked: false
        property color activeColor: window.accentColor
        signal toggled(bool newState)

        implicitWidth: 56
        implicitHeight: 32

        Rectangle {
            anchors.fill: parent
            radius: height / 2
            color: modernSwitch.checked
                   ? modernSwitch.activeColor
                   : (window.darkMode ? "#344157" : "#D9DFEA")

            Behavior on color { ColorAnimation { duration: 220 } }

            Rectangle {
                width: 24
                height: 24
                radius: 12
                y: 4
                x: modernSwitch.checked ? parent.width - width - 4 : 4
                color: "white"

                Behavior on x {
                    NumberAnimation {
                        duration: 240
                        easing.type: Easing.OutBack
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                modernSwitch.checked = !modernSwitch.checked
                modernSwitch.toggled(modernSwitch.checked)
            }
        }
    }

    component DeviceCard: Rectangle {
        id: deviceCard

        required property int index
        required property string deviceKey
        required property string deviceImage
        required property string iconBackground
        required property string deviceAccent
        required property real energyUsage
        required property bool isOn

        Layout.fillWidth: true
        Layout.preferredWidth: 310
        Layout.minimumWidth: 250
        height: 216
        radius: 24
        color: window.cardColor
        border.color: cardMouse.containsMouse
                      ? deviceCard.deviceAccent
                      : window.borderColor
        border.width: cardMouse.containsMouse ? 1.5 : 1
        scale: cardMouse.pressed ? 0.985 : cardMouse.containsMouse ? 1.018 : 1.0
        clip: true

        transform: Translate {
            y: cardMouse.containsMouse ? -4 : 0
            Behavior on y {
                NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
            }
        }

        Behavior on scale {
            NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
        }

        Behavior on border.color { ColorAnimation { duration: 160 } }

        SoftShadow {
            shadowRadius: parent.radius
            shadowOpacity: cardMouse.containsMouse
                           ? (window.darkMode ? 0.35 : 0.13)
                           : (window.darkMode ? 0.22 : 0.07)
        }

        Rectangle {
            width: 126
            height: 126
            radius: 63
            color: deviceCard.deviceAccent
            opacity: deviceCard.isOn ? 0.10 : 0.035
            anchors.right: parent.right
            anchors.rightMargin: -34
            anchors.top: parent.top
            anchors.topMargin: -40
            scale: deviceCard.isOn ? 1.12 : 0.85

            Behavior on scale {
                NumberAnimation { duration: 420; easing.type: Easing.OutBack }
            }
            Behavior on opacity { NumberAnimation { duration: 250 } }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            RowLayout {
                Layout.fillWidth: true
                spacing: 14

                Rectangle {
                    Layout.preferredWidth: 68
                    Layout.preferredHeight: 68
                    radius: 20
                    color: deviceCard.iconBackground
                    scale: deviceCard.isOn ? 1.0 : 0.94

                    Behavior on scale {
                        NumberAnimation { duration: 220; easing.type: Easing.OutBack }
                    }

                    Image {
                        id: deviceIcon
                        width: 49
                        height: 49
                        anchors.centerIn: parent
                        source: deviceCard.deviceImage
                        sourceSize.width: 180
                        sourceSize.height: 180
                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                        opacity: status === Image.Ready ? 1 : 0

                        Behavior on opacity { NumberAnimation { duration: 250 } }

                        RotationAnimator on rotation {
                            running: deviceCard.isOn && deviceCard.deviceKey === "fan"
                            from: 0
                            to: 360
                            duration: 1600
                            loops: Animation.Infinite
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        Layout.fillWidth: true
                        text: window.deviceTitle(deviceCard.deviceKey)
                        color: window.titleColor
                        font.pixelSize: 18
                        font.bold: true
                        wrapMode: Text.WordWrap
                        horizontalAlignment: window.textAlignment
                    }

                    Text {
                        Layout.fillWidth: true
                        text: window.deviceRoom(deviceCard.deviceKey)
                        color: window.bodyColor
                        font.pixelSize: 13
                        horizontalAlignment: window.textAlignment
                    }
                }

                ModernSwitch {
                    checked: deviceCard.isOn
                    activeColor: deviceCard.deviceAccent
                    onToggled: function(newState) {
                        window.changeDeviceState(deviceCard.index, newState)
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: window.borderColor
            }

            RowLayout {
                Layout.fillWidth: true

                Row {
                    spacing: 8

                    Rectangle {
                        width: 9
                        height: 9
                        radius: 5
                        anchors.verticalCenter: parent.verticalCenter
                        color: deviceCard.isOn ? window.accentColor : "#9CA6B8"

                        SequentialAnimation on opacity {
                            running: deviceCard.isOn
                            loops: Animation.Infinite
                            NumberAnimation { to: 0.35; duration: 700 }
                            NumberAnimation { to: 1.0; duration: 700 }
                        }
                    }

                    Text {
                        text: deviceCard.isOn ? qsTr("Active") : qsTr("Inactive")
                        color: deviceCard.isOn ? window.accentColor : window.bodyColor
                        font.pixelSize: 13
                        font.bold: true
                    }
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: Math.round(deviceCard.energyUsage * 100) + "%"
                    color: deviceCard.deviceAccent
                    font.pixelSize: 14
                    font.bold: true
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 7

                Text {
                    Layout.fillWidth: true
                    text: qsTr("Energy usage")
                    color: window.bodyColor
                    font.pixelSize: 12
                    horizontalAlignment: window.textAlignment
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 8
                    radius: 4
                    color: window.darkMode ? "#26334A" : "#E9EDF4"

                    Rectangle {
                        width: parent.width * deviceCard.energyUsage
                        height: parent.height
                        radius: parent.radius
                        color: deviceCard.deviceAccent

                        Behavior on width {
                            NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
                        }
                    }
                }
            }
        }

        MouseArea {
            id: cardMouse
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
        }
    }

    ListModel {
        id: devicesModel

        ListElement {
            deviceKey: "livingLight"
            deviceImage: "https://img.icons8.com/fluency/240/light-on.png"
            iconBackground: "#FFF7D7"
            deviceAccent: "#F2B63F"
            energyUsage: 0.30
            isOn: true
        }
        ListElement {
            deviceKey: "bedroomLight"
            deviceImage: "https://img.icons8.com/fluency/240/lamp.png"
            iconBackground: "#FFF0DD"
            deviceAccent: "#F08A3E"
            energyUsage: 0.20
            isOn: false
        }
        ListElement {
            deviceKey: "airConditioner"
            deviceImage: "https://img.icons8.com/fluency/240/air-conditioner.png"
            iconBackground: "#E3F3FF"
            deviceAccent: "#4CA8F5"
            energyUsage: 0.80
            isOn: true
        }
        ListElement {
            deviceKey: "fan"
            deviceImage: "https://img.icons8.com/fluency/240/fan.png"
            iconBackground: "#E4FAF1"
            deviceAccent: "#28B889"
            energyUsage: 0.50
            isOn: false
        }
        ListElement {
            deviceKey: "garage"
            deviceImage: "https://img.icons8.com/fluency/240/garage.png"
            iconBackground: "#F5EDE6"
            deviceAccent: "#A97752"
            energyUsage: 0.65
            isOn: false
        }
        ListElement {
            deviceKey: "camera"
            deviceImage: "https://img.icons8.com/fluency/240/home-security.png"
            iconBackground: "#F0E9FF"
            deviceAccent: "#8A65E8"
            energyUsage: 0.18
            isOn: true
        }
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: window.currentDate = new Date()
    }

    Timer {
        interval: 1650
        running: true
        repeat: false
        onTriggered: window.showSplash = false
    }

    Component.onCompleted: updateDeviceSummary()

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: loginPage

        pushEnter: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "x"
                    from: window.isArabic ? -stackView.width : stackView.width
                    to: 0
                    duration: 430
                    easing.type: Easing.OutCubic
                }
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 300 }
            }
        }

        pushExit: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "x"
                    from: 0
                    to: window.isArabic ? stackView.width * 0.12 : -stackView.width * 0.12
                    duration: 360
                    easing.type: Easing.OutCubic
                }
                NumberAnimation { property: "opacity"; from: 1; to: 0.45; duration: 280 }
            }
        }

        popEnter: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "x"
                    from: window.isArabic ? stackView.width * 0.12 : -stackView.width * 0.12
                    to: 0
                    duration: 380
                    easing.type: Easing.OutCubic
                }
                NumberAnimation { property: "opacity"; from: 0.45; to: 1; duration: 300 }
            }
        }

        popExit: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "x"
                    from: 0
                    to: window.isArabic ? -stackView.width : stackView.width
                    duration: 390
                    easing.type: Easing.InCubic
                }
                NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 280 }
            }
        }
    }

    Component {
        id: loginPage

        Page {
            id: loginPageItem

            property bool loggingIn: false

            function checkLogin() {
                if (usernameField.text.trim() === ""
                        || passwordField.text === "") {
                    errorLabel.text = qsTr("Please enter your username and password.")
                    loginShake.restart()
                    return
                }

                errorLabel.text = ""
                loggingIn = true
                window.currentUser = usernameField.text.trim()
                loginTimer.restart()
            }

            background: Rectangle {
                color: window.pageColor

                Rectangle {
                    width: Math.max(parent.width * 0.56, 540)
                    height: width
                    radius: width / 2
                    x: window.isArabic ? parent.width - width * 0.55 : -width * 0.45
                    y: -height * 0.45
                    gradient: Gradient {
                        GradientStop { position: 0; color: "#717BF8" }
                        GradientStop { position: 1; color: "#4552D4" }
                    }
                    opacity: window.darkMode ? 0.30 : 0.92

                    SequentialAnimation on y {
                        loops: Animation.Infinite
                        NumberAnimation { to: -height * 0.41; duration: 3600; easing.type: Easing.InOutSine }
                        NumberAnimation { to: -height * 0.45; duration: 3600; easing.type: Easing.InOutSine }
                    }
                }

                Rectangle {
                    width: 260
                    height: 260
                    radius: 130
                    x: window.isArabic ? 40 : parent.width - width - 40
                    y: parent.height - 190
                    color: window.accentColor
                    opacity: window.darkMode ? 0.12 : 0.16

                    SequentialAnimation on scale {
                        loops: Animation.Infinite
                        NumberAnimation { to: 1.12; duration: 2800; easing.type: Easing.InOutSine }
                        NumberAnimation { to: 1.0; duration: 2800; easing.type: Easing.InOutSine }
                    }
                }
            }

            LanguageButton {
                anchors.top: parent.top
                anchors.topMargin: 22
                anchors.right: window.isArabic ? undefined : parent.right
                anchors.rightMargin: 24
                anchors.left: window.isArabic ? parent.left : undefined
                anchors.leftMargin: 24
                z: 4
            }

            ScrollView {
                anchors.fill: parent
                contentWidth: availableWidth
                contentHeight: loginContent.height + 80
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                clip: true

                Column {
                    id: loginContent
                    width: Math.min(460, parent.width - 42)
                    x: (parent.width - width) / 2
                    y: Math.max(54, (loginPageItem.height - height) / 2)
                    spacing: 0

                    Rectangle {
                        id: loginCard
                        width: parent.width
                        height: loginForm.implicitHeight + 60
                        radius: 30
                        color: window.cardColor
                        border.color: window.borderColor
                        border.width: 1
                        opacity: 0
                        scale: 0.94

                        SoftShadow {
                            shadowRadius: parent.radius
                            shadowOpacity: window.darkMode ? 0.34 : 0.13
                        }

                        transform: Translate { id: loginTranslate }

                        Component.onCompleted: loginEntrance.start()

                        ParallelAnimation {
                            id: loginEntrance
                            NumberAnimation {
                                target: loginCard
                                property: "opacity"
                                from: 0
                                to: 1
                                duration: 600
                            }
                            NumberAnimation {
                                target: loginCard
                                property: "scale"
                                from: 0.94
                                to: 1
                                duration: 620
                                easing.type: Easing.OutBack
                            }
                        }

                        SequentialAnimation {
                            id: loginShake
                            NumberAnimation { target: loginTranslate; property: "x"; to: -10; duration: 55 }
                            NumberAnimation { target: loginTranslate; property: "x"; to: 10; duration: 80 }
                            NumberAnimation { target: loginTranslate; property: "x"; to: -7; duration: 70 }
                            NumberAnimation { target: loginTranslate; property: "x"; to: 7; duration: 65 }
                            NumberAnimation { target: loginTranslate; property: "x"; to: 0; duration: 55 }
                        }

                        ColumnLayout {
                            id: loginForm
                            anchors.fill: parent
                            anchors.margins: 30
                            spacing: 14

                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter
                                Layout.preferredWidth: 92
                                Layout.preferredHeight: 92
                                radius: 28
                                gradient: Gradient {
                                    GradientStop { position: 0; color: "#EFF1FF" }
                                    GradientStop { position: 1; color: "#DDE2FF" }
                                }

                                Image {
                                    width: 66
                                    height: 66
                                    anchors.centerIn: parent
                                    source: "https://img.icons8.com/fluency/240/smart-home-checked.png"
                                    fillMode: Image.PreserveAspectFit

                                    transform: Translate {
                                        id: loginLogoFloat
                                        SequentialAnimation on y {
                                            loops: Animation.Infinite
                                            NumberAnimation { to: -4; duration: 1300; easing.type: Easing.InOutSine }
                                            NumberAnimation { to: 0; duration: 1300; easing.type: Easing.InOutSine }
                                        }
                                    }
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                text: qsTr("Welcome home")
                                color: window.titleColor
                                font.pixelSize: 30
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                            }

                            Text {
                                Layout.fillWidth: true
                                text: qsTr("Sign in to control your smart home devices")
                                color: window.bodyColor
                                font.pixelSize: 14
                                horizontalAlignment: Text.AlignHCenter
                                wrapMode: Text.WordWrap
                            }

                            Item { Layout.preferredHeight: 5 }

                            Text {
                                Layout.fillWidth: true
                                text: qsTr("Username")
                                color: window.titleColor
                                font.pixelSize: 14
                                font.bold: true
                                horizontalAlignment: window.textAlignment
                            }

                            TextField {
                                id: usernameField
                                Layout.fillWidth: true
                                Layout.preferredHeight: 54
                                placeholderText: qsTr("Enter your username")
                                selectByMouse: true
                                leftPadding: window.isArabic ? 16 : 52
                                rightPadding: window.isArabic ? 52 : 16
                                color: window.titleColor
                                placeholderTextColor: window.bodyColor

                                background: Rectangle {
                                    radius: 16
                                    color: window.inputColor
                                    border.color: usernameField.activeFocus
                                                  ? window.primaryColor
                                                  : window.borderColor
                                    border.width: usernameField.activeFocus ? 2 : 1
                                    Behavior on border.color { ColorAnimation { duration: 160 } }
                                }

                                Image {
                                    width: 23
                                    height: 23
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: window.isArabic ? undefined : parent.left
                                    anchors.leftMargin: 16
                                    anchors.right: window.isArabic ? parent.right : undefined
                                    anchors.rightMargin: 16
                                    source: "https://img.icons8.com/fluency-systems-filled/96/user.png"
                                    fillMode: Image.PreserveAspectFit
                                    opacity: 0.74
                                }

                                onAccepted: passwordField.forceActiveFocus()
                            }

                            Text {
                                Layout.fillWidth: true
                                text: qsTr("Password")
                                color: window.titleColor
                                font.pixelSize: 14
                                font.bold: true
                                horizontalAlignment: window.textAlignment
                            }

                            TextField {
                                id: passwordField
                                Layout.fillWidth: true
                                Layout.preferredHeight: 54
                                placeholderText: qsTr("Enter your password")
                                echoMode: showPasswordButton.checked
                                          ? TextInput.Normal
                                          : TextInput.Password
                                selectByMouse: true
                                leftPadding: window.isArabic ? 48 : 52
                                rightPadding: window.isArabic ? 52 : 48
                                color: window.titleColor
                                placeholderTextColor: window.bodyColor

                                background: Rectangle {
                                    radius: 16
                                    color: window.inputColor
                                    border.color: passwordField.activeFocus
                                                  ? window.primaryColor
                                                  : window.borderColor
                                    border.width: passwordField.activeFocus ? 2 : 1
                                    Behavior on border.color { ColorAnimation { duration: 160 } }
                                }

                                Image {
                                    width: 23
                                    height: 23
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: window.isArabic ? undefined : parent.left
                                    anchors.leftMargin: 16
                                    anchors.right: window.isArabic ? parent.right : undefined
                                    anchors.rightMargin: 16
                                    source: "https://img.icons8.com/fluency-systems-filled/96/lock.png"
                                    fillMode: Image.PreserveAspectFit
                                    opacity: 0.74
                                }

                                Button {
                                    id: showPasswordButton
                                    width: 40
                                    height: 40
                                    checkable: true
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: window.isArabic ? undefined : parent.right
                                    anchors.rightMargin: 6
                                    anchors.left: window.isArabic ? parent.left : undefined
                                    anchors.leftMargin: 6

                                    contentItem: Image {
                                        width: 20
                                        height: 20
                                        anchors.centerIn: parent
                                        source: showPasswordButton.checked
                                                ? "https://img.icons8.com/fluency-systems-filled/96/visible.png"
                                                : "https://img.icons8.com/fluency-systems-filled/96/hide.png"
                                        fillMode: Image.PreserveAspectFit
                                        opacity: 0.72
                                    }
                                    background: Rectangle { color: "transparent" }
                                }

                                onAccepted: loginPageItem.checkLogin()
                            }

                            PrimaryButton {
                                id: loginButton
                                Layout.fillWidth: true
                                Layout.preferredHeight: 54
                                text: loginPageItem.loggingIn
                                      ? qsTr("Connecting...")
                                      : qsTr("Enter dashboard")
                                enabled: !loginPageItem.loggingIn
                                onClicked: loginPageItem.checkLogin()
                            }

                            BusyIndicator {
                                Layout.alignment: Qt.AlignHCenter
                                Layout.preferredWidth: 34
                                Layout.preferredHeight: 34
                                running: loginPageItem.loggingIn
                                visible: running
                            }

                            Text {
                                id: errorLabel
                                Layout.fillWidth: true
                                text: ""
                                color: "#EB5368"
                                font.pixelSize: 13
                                horizontalAlignment: Text.AlignHCenter
                                wrapMode: Text.WordWrap
                                visible: text !== ""
                            }
                        }
                    }
                }
            }

            Timer {
                id: loginTimer
                interval: 1100
                repeat: false
                onTriggered: {
                    loginPageItem.loggingIn = false
                    stackView.replace(dashboardPage)
                }
            }
        }
    }

    Component {
        id: dashboardPage

        Page {
            id: dashboardPageItem

            background: Rectangle { color: window.pageColor }

            header: Rectangle {
                height: 76
                color: window.cardColor
                border.color: window.borderColor
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 22
                    anchors.rightMargin: 22
                    spacing: 14

                    Rectangle {
                        Layout.preferredWidth: 46
                        Layout.preferredHeight: 46
                        radius: 15
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#747EFA" }
                            GradientStop { position: 1; color: "#4652D5" }
                        }

                        Image {
                            width: 34
                            height: 34
                            anchors.centerIn: parent
                            source: "https://img.icons8.com/fluency/240/smart-home-checked.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1

                        Text {
                            text: qsTr("Nexa Home")
                            color: window.titleColor
                            font.pixelSize: 20
                            font.bold: true
                        }

                        Text {
                            visible: window.width >= 760
                            text: qsTr("Everything is connected")
                            color: window.bodyColor
                            font.pixelSize: 12
                        }
                    }

                    LanguageButton {
                        visible: window.width >= 770
                    }

                    OutlineButton {
                        compact: window.width < 880
                        text: qsTr("Settings")
                        iconSource: "https://img.icons8.com/fluency-systems-filled/96/settings.png"
                        onClicked: stackView.push(settingsPage)
                    }
                }
            }

            ScrollView {
                id: dashboardScroll
                anchors.fill: parent
                contentWidth: availableWidth
                contentHeight: dashboardContent.implicitHeight + 42
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                clip: true

                ColumnLayout {
                    id: dashboardContent
                    width: Math.min(1160, dashboardScroll.availableWidth - 40)
                    x: (dashboardScroll.availableWidth - width) / 2
                    y: 22
                    spacing: 20

                    Rectangle {
                        id: welcomeCard
                        Layout.fillWidth: true
                        Layout.preferredHeight: window.width < 760 ? 250 : 214
                        radius: 30
                        clip: true
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#6975F5" }
                            GradientStop { position: 0.58; color: "#4652D3" }
                            GradientStop { position: 1; color: "#28318F" }
                        }

                        SoftShadow {
                            shadowRadius: parent.radius
                            shadowOpacity: window.darkMode ? 0.36 : 0.16
                        }

                        Rectangle {
                            width: 260
                            height: 260
                            radius: 130
                            anchors.right: parent.right
                            anchors.rightMargin: -70
                            anchors.top: parent.top
                            anchors.topMargin: -86
                            color: "white"
                            opacity: 0.08

                            SequentialAnimation on scale {
                                loops: Animation.Infinite
                                NumberAnimation { to: 1.12; duration: 3000; easing.type: Easing.InOutSine }
                                NumberAnimation { to: 1.0; duration: 3000; easing.type: Easing.InOutSine }
                            }
                        }

                        Rectangle {
                            width: 145
                            height: 145
                            radius: 73
                            anchors.right: parent.right
                            anchors.rightMargin: 105
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: -82
                            color: window.accentColor
                            opacity: 0.18
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: window.width < 760 ? 22 : 28
                            spacing: 22

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 9

                                Text {
                                    Layout.fillWidth: true
                                    text: window.greetingText() + ", " + window.currentUser
                                    color: "white"
                                    font.pixelSize: window.width < 760 ? 25 : 31
                                    font.bold: true
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: window.textAlignment
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: qsTr("Your home is secure, comfortable and working normally.")
                                    color: "#E6E8FF"
                                    font.pixelSize: 14
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: window.textAlignment
                                }

                                RowLayout {
                                    spacing: 10

                                    Rectangle {
                                        Layout.preferredWidth: 152
                                        Layout.preferredHeight: 36
                                        radius: 18
                                        color: "#26FFFFFF"
                                        border.color: "#38FFFFFF"

                                        Row {
                                            anchors.centerIn: parent
                                            spacing: 8

                                            Rectangle {
                                                width: 9
                                                height: 9
                                                radius: 5
                                                color: "#46E6B7"

                                                SequentialAnimation on opacity {
                                                    loops: Animation.Infinite
                                                    NumberAnimation { to: 0.25; duration: 650 }
                                                    NumberAnimation { to: 1; duration: 650 }
                                                }
                                            }

                                            Text {
                                                text: qsTr("All systems normal")
                                                color: "white"
                                                font.pixelSize: 12
                                                font.bold: true
                                            }
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                visible: window.width >= 760
                                Layout.preferredWidth: 164
                                Layout.preferredHeight: 154
                                radius: 28
                                color: "#18FFFFFF"
                                border.color: "#2CFFFFFF"

                                Column {
                                    anchors.centerIn: parent
                                    spacing: 6

                                    Image {
                                        width: 78
                                        height: 78
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        source: "https://img.icons8.com/fluency/240/smart-home-checked.png"
                                        fillMode: Image.PreserveAspectFit

                                        transform: Translate {
                                            SequentialAnimation on y {
                                                loops: Animation.Infinite
                                                NumberAnimation { to: -5; duration: 1500; easing.type: Easing.InOutSine }
                                                NumberAnimation { to: 0; duration: 1500; easing.type: Easing.InOutSine }
                                            }
                                        }
                                    }

                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: Qt.formatTime(window.currentDate, "hh:mm")
                                        color: "white"
                                        font.pixelSize: 20
                                        font.bold: true
                                    }
                                }
                            }
                        }
                    }

                    GridLayout {
                        id: statsGrid
                        Layout.fillWidth: true
                        columns: dashboardContent.width >= 850 ? 3 : dashboardContent.width >= 520 ? 2 : 1
                        columnSpacing: 14
                        rowSpacing: 14

                        Repeater {
                            model: [
                                {
                                    title: qsTr("Devices online"),
                                    value: window.activeDevices + " / " + devicesModel.count,
                                    icon: "https://img.icons8.com/fluency/240/wifi.png",
                                    tint: "#5B67F1",
                                    bg: "#ECEEFF"
                                },
                                {
                                    title: qsTr("Live energy"),
                                    value: window.liveEnergy.toFixed(2) + " kW",
                                    icon: "https://img.icons8.com/fluency/240/lightning-bolt.png",
                                    tint: "#F3A72F",
                                    bg: "#FFF5D9"
                                },
                                {
                                    title: qsTr("Target temperature"),
                                    value: window.targetTemperature + " °C",
                                    icon: "https://img.icons8.com/fluency/240/temperature.png",
                                    tint: "#20B995",
                                    bg: "#E1F9F2"
                                }
                            ]

                            delegate: Rectangle {
                                required property var modelData

                                Layout.fillWidth: true
                                Layout.preferredHeight: 100
                                radius: 22
                                color: window.cardColor
                                border.color: window.borderColor
                                border.width: 1

                                SoftShadow {
                                    shadowRadius: parent.radius
                                    shadowOpacity: window.darkMode ? 0.19 : 0.055
                                }

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 16
                                    spacing: 13

                                    Rectangle {
                                        Layout.preferredWidth: 58
                                        Layout.preferredHeight: 58
                                        radius: 18
                                        color: modelData.bg

                                        Image {
                                            width: 40
                                            height: 40
                                            anchors.centerIn: parent
                                            source: modelData.icon
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 3

                                        Text {
                                            Layout.fillWidth: true
                                            text: modelData.title
                                            color: window.bodyColor
                                            font.pixelSize: 13
                                            horizontalAlignment: window.textAlignment
                                        }

                                        Text {
                                            Layout.fillWidth: true
                                            text: modelData.value
                                            color: window.titleColor
                                            font.pixelSize: 21
                                            font.bold: true
                                            horizontalAlignment: window.textAlignment
                                        }
                                    }
                                }
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: 4

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 3

                            Text {
                                text: qsTr("My devices")
                                color: window.titleColor
                                font.pixelSize: 24
                                font.bold: true
                            }

                            Text {
                                text: qsTr("Tap a switch to control a connected device")
                                color: window.bodyColor
                                font.pixelSize: 13
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: 92
                            Layout.preferredHeight: 36
                            radius: 18
                            color: window.darkMode ? "#202C44" : "#EAEDFF"

                            Text {
                                anchors.centerIn: parent
                                text: qsTr("%1 total").arg(devicesModel.count)
                                color: window.primaryColor
                                font.pixelSize: 13
                                font.bold: true
                            }
                        }
                    }

                    GridLayout {
                        id: devicesGrid
                        Layout.fillWidth: true
                        columns: dashboardContent.width >= 990 ? 3 : dashboardContent.width >= 620 ? 2 : 1
                        columnSpacing: 16
                        rowSpacing: 16

                        Repeater {
                            model: devicesModel

                            delegate: DeviceCard { }
                        }
                    }

                    Item { Layout.preferredHeight: 14 }
                }
            }
        }
    }

    Component {
        id: settingsPage

        Page {
            id: settingsPageItem

            property bool showSavedMessage: false

            function saveSettings() {
                window.screenBrightness = Math.round(brightnessSlider.value)
                window.targetTemperature = Math.round(temperatureDial.value)
                window.notificationsEnabled = notificationsSwitch.checked
                window.energySaverEnabled = energySaverSwitch.checked
                showSavedMessage = true
                savedTimer.restart()
            }

            background: Rectangle { color: window.pageColor }

            header: Rectangle {
                height: 76
                color: window.cardColor
                border.color: window.borderColor
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 22
                    anchors.rightMargin: 22
                    spacing: 14

                    OutlineButton {
                        compact: window.width < 760
                        text: qsTr("Back")
                        iconSource: window.isArabic
                                    ? "https://img.icons8.com/fluency-systems-filled/96/forward.png"
                                    : "https://img.icons8.com/fluency-systems-filled/96/back.png"
                        onClicked: stackView.pop()
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1

                        Text {
                            text: qsTr("Settings")
                            color: window.titleColor
                            font.pixelSize: 20
                            font.bold: true
                        }

                        Text {
                            visible: window.width >= 720
                            text: qsTr("Personalize your smart home experience")
                            color: window.bodyColor
                            font.pixelSize: 12
                        }
                    }

                    LanguageButton { }
                }
            }

            ScrollView {
                id: settingsScroll
                anchors.fill: parent
                contentWidth: availableWidth
                contentHeight: settingsContent.implicitHeight + 40
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                clip: true

                ColumnLayout {
                    id: settingsContent
                    width: Math.min(860, settingsScroll.availableWidth - 40)
                    x: (settingsScroll.availableWidth - width) / 2
                    y: 22
                    spacing: 16

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 158
                        radius: 28
                        clip: true
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#6571F2" }
                            GradientStop { position: 1; color: "#333DAA" }
                        }

                        Rectangle {
                            width: 210
                            height: 210
                            radius: 105
                            anchors.right: parent.right
                            anchors.rightMargin: -54
                            anchors.top: parent.top
                            anchors.topMargin: -75
                            color: "white"
                            opacity: 0.08
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 24
                            spacing: 18

                            Rectangle {
                                Layout.preferredWidth: 82
                                Layout.preferredHeight: 82
                                radius: 24
                                color: "#24FFFFFF"
                                border.color: "#35FFFFFF"

                                Image {
                                    width: 58
                                    height: 58
                                    anchors.centerIn: parent
                                    source: "https://img.icons8.com/fluency/240/settings.png"
                                    fillMode: Image.PreserveAspectFit
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 7

                                Text {
                                    Layout.fillWidth: true
                                    text: qsTr("Home preferences")
                                    color: "white"
                                    font.pixelSize: 25
                                    font.bold: true
                                    horizontalAlignment: window.textAlignment
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: qsTr("Adjust appearance, language, comfort and notification options.")
                                    color: "#E7E9FF"
                                    font.pixelSize: 13
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: window.textAlignment
                                }
                            }
                        }
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: settingsContent.width >= 700 ? 2 : 1
                        columnSpacing: 16
                        rowSpacing: 16

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 156
                            radius: 22
                            color: window.cardColor
                            border.color: window.borderColor
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 19
                                spacing: 10

                                RowLayout {
                                    Layout.fillWidth: true

                                    Rectangle {
                                        Layout.preferredWidth: 46
                                        Layout.preferredHeight: 46
                                        radius: 14
                                        color: window.darkMode ? "#26324B" : "#ECEEFF"

                                        Image {
                                            width: 30
                                            height: 30
                                            anchors.centerIn: parent
                                            source: "https://img.icons8.com/fluency/240/globe-earth.png"
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 2

                                        Text {
                                            Layout.fillWidth: true
                                            text: qsTr("Application language")
                                            color: window.titleColor
                                            font.pixelSize: 16
                                            font.bold: true
                                            horizontalAlignment: window.textAlignment
                                        }

                                        Text {
                                            Layout.fillWidth: true
                                            text: qsTr("Switch instantly between English and Arabic")
                                            color: window.bodyColor
                                            font.pixelSize: 12
                                            wrapMode: Text.WordWrap
                                            horizontalAlignment: window.textAlignment
                                        }
                                    }
                                }

                                LanguageButton {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 44
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 156
                            radius: 22
                            color: window.cardColor
                            border.color: window.borderColor
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 19
                                spacing: 14

                                Rectangle {
                                    Layout.preferredWidth: 54
                                    Layout.preferredHeight: 54
                                    radius: 17
                                    color: window.darkMode ? "#293149" : "#F0EAFE"

                                    Image {
                                        width: 36
                                        height: 36
                                        anchors.centerIn: parent
                                        source: "https://img.icons8.com/fluency/240/moon-symbol.png"
                                        fillMode: Image.PreserveAspectFit
                                    }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 3

                                    Text {
                                        Layout.fillWidth: true
                                        text: qsTr("Dark appearance")
                                        color: window.titleColor
                                        font.pixelSize: 16
                                        font.bold: true
                                        horizontalAlignment: window.textAlignment
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        text: qsTr("Use a comfortable dark interface")
                                        color: window.bodyColor
                                        font.pixelSize: 12
                                        wrapMode: Text.WordWrap
                                        horizontalAlignment: window.textAlignment
                                    }
                                }

                                ModernSwitch {
                                    checked: window.darkMode
                                    activeColor: window.primaryColor
                                    onToggled: function(newState) {
                                        window.darkMode = newState
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 174
                        radius: 22
                        color: window.cardColor
                        border.color: window.borderColor
                        border.width: 1

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 10

                            RowLayout {
                                Layout.fillWidth: true

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 3

                                    Text {
                                        Layout.fillWidth: true
                                        text: qsTr("Screen brightness")
                                        color: window.titleColor
                                        font.pixelSize: 16
                                        font.bold: true
                                        horizontalAlignment: window.textAlignment
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        text: qsTr("Adjust the simulated dashboard brightness")
                                        color: window.bodyColor
                                        font.pixelSize: 12
                                        horizontalAlignment: window.textAlignment
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 70
                                    Layout.preferredHeight: 36
                                    radius: 18
                                    color: window.darkMode ? "#232F47" : "#ECEEFF"

                                    Text {
                                        anchors.centerIn: parent
                                        text: Math.round(brightnessSlider.value) + "%"
                                        color: window.primaryColor
                                        font.bold: true
                                    }
                                }
                            }

                            Slider {
                                id: brightnessSlider
                                Layout.fillWidth: true
                                from: 30
                                to: 100
                                value: window.screenBrightness
                                stepSize: 1
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Text { text: qsTr("Dim"); color: window.bodyColor; font.pixelSize: 12 }
                                Item { Layout.fillWidth: true }
                                Text { text: qsTr("Bright"); color: window.bodyColor; font.pixelSize: 12 }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 278
                        radius: 22
                        color: window.cardColor
                        border.color: window.borderColor
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 22

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 7

                                Text {
                                    Layout.fillWidth: true
                                    text: qsTr("Preferred temperature")
                                    color: window.titleColor
                                    font.pixelSize: 17
                                    font.bold: true
                                    horizontalAlignment: window.textAlignment
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: qsTr("Turn the dial to set a comfortable room temperature.")
                                    color: window.bodyColor
                                    font.pixelSize: 13
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: window.textAlignment
                                }

                                Rectangle {
                                    Layout.preferredWidth: 154
                                    Layout.preferredHeight: 38
                                    radius: 19
                                    color: window.darkMode ? "#20314A" : "#E6F9F3"

                                    Text {
                                        anchors.centerIn: parent
                                        text: qsTr("Comfort range: 22–25 °C")
                                        color: window.accentColor
                                        font.pixelSize: 12
                                        font.bold: true
                                    }
                                }
                            }

                            Item {
                                Layout.preferredWidth: 210
                                Layout.preferredHeight: 210

                                Dial {
                                    id: temperatureDial
                                    anchors.fill: parent
                                    from: 16
                                    to: 30
                                    value: window.targetTemperature
                                    stepSize: 1
                                }

                                Rectangle {
                                    width: 108
                                    height: 108
                                    radius: 54
                                    anchors.centerIn: parent
                                    color: window.cardColor
                                    border.color: window.borderColor
                                    border.width: 1

                                    Column {
                                        anchors.centerIn: parent
                                        spacing: 1

                                        Text {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: Math.round(temperatureDial.value) + "°"
                                            color: window.primaryColor
                                            font.pixelSize: 30
                                            font.bold: true
                                        }

                                        Text {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: qsTr("Celsius")
                                            color: window.bodyColor
                                            font.pixelSize: 11
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 112
                        radius: 22
                        color: window.cardColor
                        border.color: window.borderColor
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 14

                            Rectangle {
                                Layout.preferredWidth: 52
                                Layout.preferredHeight: 52
                                radius: 16
                                color: window.darkMode ? "#293249" : "#FFF1E4"

                                Image {
                                    width: 35
                                    height: 35
                                    anchors.centerIn: parent
                                    source: "https://img.icons8.com/fluency/240/appointment-reminders.png"
                                    fillMode: Image.PreserveAspectFit
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 3

                                Text {
                                    Layout.fillWidth: true
                                    text: qsTr("Notifications")
                                    color: window.titleColor
                                    font.pixelSize: 16
                                    font.bold: true
                                    horizontalAlignment: window.textAlignment
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: qsTr("Receive important device and security alerts")
                                    color: window.bodyColor
                                    font.pixelSize: 12
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: window.textAlignment
                                }
                            }

                            ModernSwitch {
                                id: notificationsSwitch
                                checked: window.notificationsEnabled
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 112
                        radius: 22
                        color: window.cardColor
                        border.color: window.borderColor
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 14

                            Rectangle {
                                Layout.preferredWidth: 52
                                Layout.preferredHeight: 52
                                radius: 16
                                color: window.darkMode ? "#203B36" : "#E5F8F1"

                                Image {
                                    width: 35
                                    height: 35
                                    anchors.centerIn: parent
                                    source: "https://img.icons8.com/fluency/240/leaf.png"
                                    fillMode: Image.PreserveAspectFit
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 3

                                Text {
                                    Layout.fillWidth: true
                                    text: qsTr("Energy saver")
                                    color: window.titleColor
                                    font.pixelSize: 16
                                    font.bold: true
                                    horizontalAlignment: window.textAlignment
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: qsTr("Reduce unnecessary energy use automatically")
                                    color: window.bodyColor
                                    font.pixelSize: 12
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: window.textAlignment
                                }
                            }

                            ModernSwitch {
                                id: energySaverSwitch
                                checked: window.energySaverEnabled
                                activeColor: window.accentColor
                            }
                        }
                    }

                    PrimaryButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 56
                        text: qsTr("Save settings")
                        onClicked: settingsPageItem.saveSettings()
                    }

                    Item { Layout.preferredHeight: 14 }
                }
            }

            Rectangle {
                id: savedToast
                width: Math.min(360, parent.width - 40)
                height: 58
                radius: 18
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: settingsPageItem.showSavedMessage ? 24 : -80
                color: window.darkMode ? "#1C3A34" : "#E8FAF4"
                border.color: "#75D7BB"
                opacity: settingsPageItem.showSavedMessage ? 1 : 0
                z: 10

                Behavior on anchors.bottomMargin {
                    NumberAnimation { duration: 360; easing.type: Easing.OutBack }
                }
                Behavior on opacity { NumberAnimation { duration: 220 } }

                Row {
                    anchors.centerIn: parent
                    spacing: 10

                    Image {
                        width: 24
                        height: 24
                        source: "https://img.icons8.com/fluency/96/ok.png"
                        fillMode: Image.PreserveAspectFit
                    }

                    Text {
                        text: qsTr("Settings saved successfully")
                        color: window.darkMode ? "#A8F1D7" : "#187A61"
                        font.pixelSize: 14
                        font.bold: true
                    }
                }
            }

            Timer {
                id: savedTimer
                interval: 2300
                repeat: false
                onTriggered: settingsPageItem.showSavedMessage = false
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: Math.max(0, (100 - window.screenBrightness) / 100 * 0.34)
        visible: opacity > 0.001 && !window.showSplash
        enabled: false
        z: 800

        Behavior on opacity { NumberAnimation { duration: 280 } }
    }

    Rectangle {
        id: splashScreen
        anchors.fill: parent
        z: 1000
        visible: opacity > 0
        opacity: window.showSplash ? 1 : 0
        color: "#20296F"

        Behavior on opacity {
            NumberAnimation { duration: 520; easing.type: Easing.InOutCubic }
        }

        Rectangle {
            width: 520
            height: 520
            radius: 260
            anchors.centerIn: parent
            color: "#6571F2"
            opacity: 0.35

            SequentialAnimation on scale {
                loops: Animation.Infinite
                NumberAnimation { to: 1.15; duration: 1400; easing.type: Easing.InOutSine }
                NumberAnimation { to: 1.0; duration: 1400; easing.type: Easing.InOutSine }
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: 18

            Rectangle {
                width: 126
                height: 126
                radius: 38
                anchors.horizontalCenter: parent.horizontalCenter
                color: "white"
                scale: 0.8

                NumberAnimation on scale {
                    from: 0.7
                    to: 1
                    duration: 700
                    easing.type: Easing.OutBack
                }

                Image {
                    width: 92
                    height: 92
                    anchors.centerIn: parent
                    source: "https://img.icons8.com/fluency/240/smart-home-checked.png"
                    fillMode: Image.PreserveAspectFit
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Nexa Home")
                color: "white"
                font.pixelSize: 36
                font.bold: true
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Smart living, beautifully connected")
                color: "#D9DDFF"
                font.pixelSize: 15
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 7

                Repeater {
                    model: 3
                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        color: "white"

                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            PauseAnimation { duration: index * 180 }
                            NumberAnimation { to: 0.25; duration: 430 }
                            NumberAnimation { to: 1; duration: 430 }
                        }
                    }
                }
            }
        }
    }
}
