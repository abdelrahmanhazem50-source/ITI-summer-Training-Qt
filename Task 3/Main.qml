import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window

    width: 800
    height: 600
    visible: true
    title: "Smart Home Control Dashboard"
    color: "whitesmoke"

    // Stores the username after login
    property string currentUser: ""

    // Custom signal for device switches
    signal deviceChanged(string deviceName, bool deviceState)

    onDeviceChanged: function(deviceName, deviceState) {
        if (deviceState === true) {
            console.log(deviceName + " is ON")
        } else {
            console.log(deviceName + " is OFF")
        }
    }

    // Navigation between the pages
    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: loginPage
    }

    // =====================================================
    // PAGE 1: LOGIN PAGE
    // =====================================================

    Component {
        id: loginPage

        Page {
            id: loginPageItem

            function checkLogin() {
                if (usernameField.text !== "" &&
                        passwordField.text !== "") {

                    errorLabel.text = ""
                    window.currentUser = usernameField.text

                    busyIndicator.running = true
                    loginButton.enabled = false

                    loginTimer.start()

                } else {
                    errorLabel.text =
                            "Please enter username and password"
                }
            }

            Rectangle {
                anchors.fill: parent
                color: "lightblue"

                Rectangle {
                    width: 400
                    height: 470
                    anchors.centerIn: parent

                    color: "white"
                    radius: 15

                    border.color: "steelblue"
                    border.width: 3

                    Column {
                        width: 320
                        anchors.centerIn: parent
                        spacing: 18

                        Image {
                            width: 100
                            height: 100

                            anchors.horizontalCenter:
                                parent.horizontalCenter

                            source:
                                "https://api.iconify.design/mdi/account-circle.svg"

                            fillMode: Image.PreserveAspectFit
                            asynchronous: true
                        }

                        Label {
                            text: "Smart Home Login"
                            font.pixelSize: 28
                            font.bold: true
                            color: "steelblue"

                            anchors.horizontalCenter:
                                parent.horizontalCenter
                        }

                        TextField {
                            id: usernameField

                            width: parent.width
                            placeholderText: "Username"
                        }

                        TextField {
                            id: passwordField

                            width: parent.width
                            placeholderText: "Password"
                            echoMode: TextInput.Password
                        }

                        Button {
                            id: loginButton

                            width: parent.width
                            text: "Login"

                            onClicked: {
                                loginPageItem.checkLogin()
                            }
                        }

                        BusyIndicator {
                            id: busyIndicator

                            running: false
                            visible: running

                            anchors.horizontalCenter:
                                parent.horizontalCenter
                        }

                        Label {
                            id: errorLabel

                            width: parent.width
                            text: ""
                            color: "red"

                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }

            Timer {
                id: loginTimer

                interval: 2000
                repeat: false

                onTriggered: {
                    busyIndicator.running = false
                    loginButton.enabled = true

                    stackView.push(dashboardPage)
                }
            }
        }
    }

    // =====================================================
    // PAGE 2: DASHBOARD PAGE
    // =====================================================

    Component {
        id: dashboardPage

        Page {
            id: dashboardPageItem

            header: ToolBar {
                background: Rectangle {
                    color: "steelblue"
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    anchors.topMargin: 6
                    anchors.bottomMargin: 6

                    Label {
                        text: "Smart Home Dashboard"
                        color: "white"
                        font.pixelSize: 22
                        font.bold: true

                        Layout.fillWidth: true
                    }

                    Button {
                        text: "Settings"

                        onClicked: {
                            stackView.push(settingsPage)
                        }
                    }
                }
            }

            ListModel {
                id: devicesModel

                ListElement {
                    deviceName: "Living Room Light"
                    deviceImage:
                        "https://api.iconify.design/mdi/lightbulb.svg"
                    energyUsage: 0.30
                }

                ListElement {
                    deviceName: "Bedroom Light"
                    deviceImage:
                        "https://api.iconify.design/mdi/lightbulb-outline.svg"
                    energyUsage: 0.20
                }

                ListElement {
                    deviceName: "Air Conditioner"
                    deviceImage:
                        "https://api.iconify.design/mdi/air-conditioner.svg"
                    energyUsage: 0.80
                }

                ListElement {
                    deviceName: "Fan"
                    deviceImage:
                        "https://api.iconify.design/mdi/fan.svg"
                    energyUsage: 0.50
                }

                ListElement {
                    deviceName: "Garage Door"
                    deviceImage:
                        "https://api.iconify.design/mdi/garage.svg"
                    energyUsage: 0.65
                }
            }

            ScrollView {
                id: deviceScrollView

                anchors.fill: parent
                anchors.margins: 15

                clip: true

                ScrollBar.horizontal.policy:
                    ScrollBar.AlwaysOff

                Column {
                    id: devicesColumn

                    width: deviceScrollView.availableWidth
                    spacing: 15

                    Image {
                        width: 90
                        height: 90

                        anchors.horizontalCenter:
                            parent.horizontalCenter

                        source:
                            "https://api.iconify.design/mdi/home.svg"

                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                    }

                    Label {
                        text: "Welcome, " + window.currentUser
                        color: "steelblue"

                        font.pixelSize: 25
                        font.bold: true

                        anchors.horizontalCenter:
                            parent.horizontalCenter
                    }

                    Label {
                        text: "Control your smart home devices"
                        color: "gray"
                        font.pixelSize: 17

                        anchors.horizontalCenter:
                            parent.horizontalCenter
                    }

                    Repeater {
                        model: devicesModel

                        Rectangle {
                            width: devicesColumn.width
                            height: 180

                            color: "white"
                            radius: 10

                            border.color: "lightgray"
                            border.width: 2

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 15
                                spacing: 15

                                Image {
                                    source: deviceImage

                                    fillMode:
                                        Image.PreserveAspectFit

                                    asynchronous: true

                                    Layout.preferredWidth: 75
                                    Layout.preferredHeight: 75
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 7

                                    Label {
                                        text: deviceName

                                        font.pixelSize: 19
                                        font.bold: true

                                        Layout.fillWidth: true
                                        wrapMode: Text.WordWrap
                                    }

                                    RowLayout {
                                        Layout.fillWidth: true

                                        Label {
                                            text: "Device Status"
                                            Layout.fillWidth: true
                                        }

                                        Label {
                                            text: deviceSwitch.checked
                                                  ? "ON"
                                                  : "OFF"

                                            color: deviceSwitch.checked
                                                   ? "green"
                                                   : "red"

                                            font.bold: true
                                        }

                                        Switch {
                                            id: deviceSwitch

                                            onCheckedChanged: {
                                                window.deviceChanged(
                                                    deviceName,
                                                    checked
                                                )
                                            }
                                        }
                                    }

                                    Label {
                                        text: "Energy Usage"
                                        color: "gray"
                                    }

                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 10

                                        ProgressBar {
                                            from: 0
                                            to: 1
                                            value: energyUsage

                                            Layout.fillWidth: true
                                        }

                                        Label {
                                            text: Math.round(
                                                      energyUsage * 100
                                                  ) + "%"

                                            Layout.preferredWidth: 45

                                            horizontalAlignment:
                                                Text.AlignRight
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Item {
                        width: 1
                        height: 10
                    }
                }
            }
        }
    }

    // =====================================================
    // PAGE 3: SETTINGS PAGE
    // =====================================================

    Component {
        id: settingsPage

        Page {
            id: settingsPageItem

            function saveSettings() {
                console.log(
                    "Language: " +
                    languageComboBox.currentText
                )

                console.log(
                    "Brightness: " +
                    Math.round(brightnessSlider.value) +
                    "%"
                )

                console.log(
                    "Temperature: " +
                    Math.round(temperatureDial.value) +
                    " degrees"
                )

                console.log(
                    "Notifications: " +
                    notificationCheckBox.checked
                )

                savedLabel.text =
                        "Settings saved successfully"
            }

            header: ToolBar {
                background: Rectangle {
                    color: "steelblue"
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    anchors.topMargin: 6
                    anchors.bottomMargin: 6
                    spacing: 10

                    Button {
                        text: "Back"

                        onClicked: {
                            stackView.pop()
                        }
                    }

                    Label {
                        text: "Settings"
                        color: "white"

                        font.pixelSize: 22
                        font.bold: true

                        Layout.fillWidth: true
                    }
                }
            }

            ScrollView {
                id: settingsScrollView

                anchors.fill: parent
                anchors.margins: 20

                clip: true

                ScrollBar.horizontal.policy:
                    ScrollBar.AlwaysOff

                Column {
                    width: settingsScrollView.availableWidth
                    spacing: 20

                    Label {
                        text: "Application Language"
                        font.pixelSize: 18
                        font.bold: true
                    }

                    ComboBox {
                        id: languageComboBox

                        width: parent.width

                        model: [
                            "English",
                            "Arabic",
                            "French"
                        ]

                        onActivated: {
                            console.log(
                                "Selected language: " +
                                currentText
                            )
                        }
                    }

                    Label {
                        text: "Screen Brightness: " +
                              Math.round(
                                  brightnessSlider.value
                              ) + "%"

                        font.pixelSize: 18
                        font.bold: true
                    }

                    Slider {
                        id: brightnessSlider

                        width: parent.width

                        from: 0
                        to: 100
                        value: 70
                        stepSize: 1

                        onValueChanged: {
                            console.log(
                                "Brightness: " +
                                Math.round(value) +
                                "%"
                            )
                        }
                    }

                    Label {
                        text: "Room Temperature: " +
                              Math.round(
                                  temperatureDial.value
                              ) + " °C"

                        font.pixelSize: 18
                        font.bold: true
                    }

                    Dial {
                        id: temperatureDial

                        width: 150
                        height: 150

                        anchors.horizontalCenter:
                            parent.horizontalCenter

                        from: 16
                        to: 30
                        value: 24
                        stepSize: 1

                        onValueChanged: {
                            console.log(
                                "Temperature: " +
                                Math.round(value) +
                                " °C"
                            )
                        }
                    }

                    CheckBox {
                        id: notificationCheckBox

                        text: "Enable Notifications"
                        checked: true

                        onCheckedChanged: {
                            console.log(
                                "Notifications: " +
                                checked
                            )
                        }
                    }

                    Button {
                        width: parent.width
                        text: "Save Settings"

                        onClicked: {
                            settingsPageItem.saveSettings()
                        }
                    }

                    Label {
                        id: savedLabel

                        width: parent.width
                        text: ""
                        color: "green"
                        font.pixelSize: 17

                        horizontalAlignment:
                            Text.AlignHCenter
                    }

                    Item {
                        width: 1
                        height: 15
                    }
                }
            }
        }
    }
}
