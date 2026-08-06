pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

ApplicationWindow {
    id: app

    width: 1180
    height: 780
    minimumWidth: 760
    minimumHeight: 560
    visible: true
    title: qsTr("Geddo Store")
    color: "whitesmoke"

    property bool showSplashScreen: true
    property bool isArabic: languageManager.currentLanguage === "ar"

    property string selectedProduct: ""
    property string selectedSubtitle: ""
    property url selectedImage: ""
    property var selectedDetails: []

    property int cardColumns: width >= 1050 ? 3 : (width >= 720 ? 2 : 1)

    LayoutMirroring.enabled: isArabic
    LayoutMirroring.childrenInherit: true

    function openProduct(name, subtitle, image, details) {
        selectedProduct = name
        selectedSubtitle = subtitle
        selectedImage = image
        selectedDetails = details
        productPopup.open()
    }

    function changeLanguage(languageCode) {
        productPopup.close()
        languageManager.setLanguage(languageCode)
    }

    Timer {
        interval: 1800
        running: true
        repeat: false

        onTriggered: app.showSplashScreen = false
    }

    // =========================================================
    // Reusable modern product card
    // =========================================================

    component ProductCard: Item {
        id: productCard

        property string productName: ""
        property string productSubtitle: ""
        property string productPrice: ""
        property url productImage: ""
        property var productDetails: []

        width: (productsFlow.width - productsFlow.spacing * (app.cardColumns - 1)) / app.cardColumns
        height: 340

        Rectangle {
            id: cardShadow

            anchors.fill: cardSurface
            anchors.topMargin: 10
            radius: 26
            color: "black"
            opacity: cardMouseArea.containsMouse ? 0.14 : 0.07

            Behavior on opacity {
                NumberAnimation { duration: 220 }
            }
        }

        Rectangle {
            id: cardSurface

            anchors.fill: parent
            radius: 26
            color: "white"
            border.color: cardMouseArea.containsMouse ? app.primaryColor : "gainsboro"
            border.width: cardMouseArea.containsMouse ? 2 : 1
            clip: true
            opacity: 0
            scale: 0.94

            transform: Translate {
                y: cardMouseArea.containsMouse ? -7 : 0

                Behavior on y {
                    NumberAnimation {
                        duration: 220
                        easing.type: Easing.OutCubic
                    }
                }
            }

            Behavior on border.color {
                ColorAnimation { duration: 220 }
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 220
                    easing.type: Easing.OutCubic
                }
            }

            Column {
                anchors.fill: parent
                spacing: 0

                Rectangle {
                    id: imageContainer

                    width: parent.width
                    height: 205
                    color: "lavender"
                    clip: true

                    Image {
                        id: cardImage

                        anchors.fill: parent
                        source: productCard.productImage
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                        cache: true
                        scale: cardMouseArea.containsMouse ? 1.08 : 1.0

                        Behavior on scale {
                            NumberAnimation {
                                duration: 420
                                easing.type: Easing.OutCubic
                            }
                        }
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: "black"
                        opacity: cardMouseArea.containsMouse ? 0.04 : 0.0

                        Behavior on opacity {
                            NumberAnimation { duration: 220 }
                        }
                    }

                    Rectangle {
                        width: priceText.implicitWidth + 24
                        height: 38
                        radius: 19
                        color: "white"
                        opacity: 0.96

                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.topMargin: 14
                        anchors.rightMargin: 14

                        Text {
                            id: priceText

                            anchors.centerIn: parent
                            text: productCard.productPrice
                            color: app.primaryColor
                            font.pixelSize: 15
                            font.bold: true
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: parent.height - imageContainer.height

                    Column {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: 20
                        spacing: 6

                        Text {
                            width: parent.width
                            text: productCard.productName
                            color: app.textColor
                            font.pixelSize: 21
                            font.bold: true
                            elide: Text.ElideRight
                            horizontalAlignment: app.isArabic ? Text.AlignRight : Text.AlignLeft
                        }

                        Text {
                            width: parent.width
                            text: productCard.productSubtitle
                            color: app.mutedTextColor
                            font.pixelSize: 14
                            elide: Text.ElideRight
                            horizontalAlignment: app.isArabic ? Text.AlignRight : Text.AlignLeft
                        }
                    }

                    Row {
                        spacing: 8
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        anchors.leftMargin: 20
                        anchors.bottomMargin: 18
                        layoutDirection: app.isArabic ? Qt.RightToLeft : Qt.LeftToRight

                        Text {
                            text: qsTr("View details")
                            color: app.primaryColor
                            font.pixelSize: 15
                            font.bold: true
                        }

                        Text {
                            text: app.isArabic ? "←" : "→"
                            color: app.primaryColor
                            font.pixelSize: 18
                            font.bold: true

                            transform: Translate {
                                x: cardMouseArea.containsMouse ? (app.isArabic ? -4 : 4) : 0

                                Behavior on x {
                                    NumberAnimation {
                                        duration: 180
                                        easing.type: Easing.OutCubic
                                    }
                                }
                            }
                        }
                    }
                }
            }

            MouseArea {
                id: cardMouseArea

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onPressed: cardSurface.scale = 0.98
                onReleased: cardSurface.scale = 1.0
                onCanceled: cardSurface.scale = 1.0

                onClicked: {
                    app.openProduct(productCard.productName,
                                    productCard.productSubtitle,
                                    productCard.productImage,
                                    productCard.productDetails)
                }
            }

            ParallelAnimation {
                id: cardEntryAnimation

                NumberAnimation {
                    target: cardSurface
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 460
                    easing.type: Easing.OutCubic
                }

                NumberAnimation {
                    target: cardSurface
                    property: "scale"
                    from: 0.94
                    to: 1.0
                    duration: 460
                    easing.type: Easing.OutBack
                }
            }

            Component.onCompleted: cardEntryAnimation.start()
        }
    }

    // =========================================================
    // Theme colors
    // =========================================================

    property color primaryColor: "slateblue"
    property color accentColor: "mediumpurple"
    property color textColor: "darkslategray"
    property color mutedTextColor: "slategray"

    // =========================================================
    // Animated background graphics
    // =========================================================

    Rectangle {
        anchors.fill: parent
        color: "whitesmoke"
    }

    Rectangle {
        id: floatingCircleOne

        width: 310
        height: 310
        radius: 155
        x: -110
        y: 100
        color: "mediumpurple"
        opacity: 0.07

        SequentialAnimation on y {
            loops: Animation.Infinite

            NumberAnimation {
                to: 155
                duration: 4200
                easing.type: Easing.InOutSine
            }

            NumberAnimation {
                to: 100
                duration: 4200
                easing.type: Easing.InOutSine
            }
        }
    }

    Rectangle {
        id: floatingCircleTwo

        width: 240
        height: 240
        radius: 120
        x: app.width - 120
        y: app.height - 260
        color: "slateblue"
        opacity: 0.06

        SequentialAnimation on x {
            loops: Animation.Infinite

            NumberAnimation {
                to: app.width - 170
                duration: 5200
                easing.type: Easing.InOutSine
            }

            NumberAnimation {
                to: app.width - 120
                duration: 5200
                easing.type: Easing.InOutSine
            }
        }
    }

    // =========================================================
    // Main scrollable page
    // =========================================================

    Flickable {
        id: pageFlickable

        anchors.fill: parent
        contentWidth: width
        contentHeight: pageColumn.height + 40
        clip: true
        boundsBehavior: Flickable.DragOverBounds
        flickDeceleration: 1450
        maximumFlickVelocity: 2800

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }

        Column {
            id: pageColumn

            width: pageFlickable.width
            spacing: 28

            Item {
                id: topArea

                width: parent.width
                height: 292

                RowLayout {
                    id: topBar

                    width: Math.min(parent.width - 44, 1120)
                    height: 64
                    anchors.top: parent.top
                    anchors.topMargin: 18
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 14

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        Rectangle {
                            width: 46
                            height: 46
                            radius: 15
                            color: app.primaryColor

                            Text {
                                anchors.centerIn: parent
                                text: "G"
                                color: "white"
                                font.pixelSize: 25
                                font.bold: true
                            }
                        }

                        Column {
                            spacing: 1

                            Text {
                                text: qsTr("Geddo Store")
                                color: app.textColor
                                font.pixelSize: 21
                                font.bold: true
                            }

                            Text {
                                text: qsTr("Everything you need in one place")
                                color: app.mutedTextColor
                                font.pixelSize: 12
                            }
                        }
                    }

                    Rectangle {
                        id: languageSwitch

                        Layout.preferredWidth: 126
                        Layout.preferredHeight: 44
                        radius: 22
                        color: "white"
                        border.color: "gainsboro"
                        border.width: 1

                        LayoutMirroring.enabled: false
                        LayoutMirroring.childrenInherit: false

                        Rectangle {
                            id: languageSlider

                            width: 58
                            height: 36
                            radius: 18
                            y: 4
                            x: app.isArabic ? 64 : 4
                            color: app.primaryColor

                            Behavior on x {
                                NumberAnimation {
                                    duration: 280
                                    easing.type: Easing.OutCubic
                                }
                            }
                        }

                        Text {
                            width: 58
                            height: parent.height
                            anchors.left: parent.left
                            text: "EN"
                            color: app.isArabic ? app.mutedTextColor : "white"
                            font.pixelSize: 13
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            Behavior on color {
                                ColorAnimation { duration: 180 }
                            }
                        }

                        Text {
                            width: 58
                            height: parent.height
                            anchors.right: parent.right
                            text: "ع"
                            color: app.isArabic ? "white" : app.mutedTextColor
                            font.pixelSize: 17
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            Behavior on color {
                                ColorAnimation { duration: 180 }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor

                            onClicked: app.changeLanguage(app.isArabic ? "en" : "ar")
                        }
                    }
                }

                Rectangle {
                    id: heroCard

                    width: Math.min(parent.width - 44, 1120)
                    height: 188
                    radius: 32
                    anchors.top: topBar.bottom
                    anchors.topMargin: 16
                    anchors.horizontalCenter: parent.horizontalCenter
                    clip: true

                    gradient: Gradient {
                        orientation: Gradient.Horizontal

                        GradientStop {
                            position: 0.0
                            color: app.primaryColor
                        }

                        GradientStop {
                            position: 1.0
                            color: app.accentColor
                        }
                    }

                    Rectangle {
                        width: 240
                        height: 240
                        radius: 120
                        x: app.isArabic ? -70 : parent.width - 150
                        y: -85
                        color: "white"
                        opacity: 0.10
                    }

                    Rectangle {
                        width: 125
                        height: 125
                        radius: 63
                        x: app.isArabic ? parent.width - 40 : -30
                        y: 105
                        color: "white"
                        opacity: 0.08
                    }

                    Column {
                        width: Math.min(parent.width - 64, 720)
                        anchors.left: parent.left
                        anchors.leftMargin: 34
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 9

                        Text {
                            width: parent.width
                            text: qsTr("Featured collection")
                            color: "lavender"
                            font.pixelSize: 14
                            font.bold: true
                            horizontalAlignment: app.isArabic ? Text.AlignRight : Text.AlignLeft
                        }

                        Text {
                            width: parent.width
                            text: qsTr("Our Products")
                            color: "white"
                            font.pixelSize: 35
                            font.bold: true
                            horizontalAlignment: app.isArabic ? Text.AlignRight : Text.AlignLeft
                        }

                        Text {
                            width: parent.width
                            text: qsTr("Discover hand-picked products across technology, learning, cars and properties.")
                            color: "white"
                            opacity: 0.90
                            font.pixelSize: 15
                            wrapMode: Text.WordWrap
                            horizontalAlignment: app.isArabic ? Text.AlignRight : Text.AlignLeft
                        }
                    }
                }
            }

            RowLayout {
                width: Math.min(parent.width - 44, 1120)
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 12

                Column {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        width: parent.width
                        text: qsTr("Browse products")
                        color: app.textColor
                        font.pixelSize: 27
                        font.bold: true
                        horizontalAlignment: app.isArabic ? Text.AlignRight : Text.AlignLeft
                    }

                    Text {
                        width: parent.width
                        text: qsTr("Tap any card to view full details")
                        color: app.mutedTextColor
                        font.pixelSize: 14
                        horizontalAlignment: app.isArabic ? Text.AlignRight : Text.AlignLeft
                    }
                }

                Rectangle {
                    Layout.preferredWidth: productCountText.implicitWidth + 28
                    Layout.preferredHeight: 38
                    radius: 19
                    color: "lavender"

                    Text {
                        id: productCountText

                        anchors.centerIn: parent
                        text: qsTr("6 curated products")
                        color: app.primaryColor
                        font.pixelSize: 13
                        font.bold: true
                    }
                }
            }

            Flow {
                id: productsFlow

                width: Math.min(parent.width - 44, 1120)
                height: childrenRect.height
                spacing: 22
                anchors.horizontalCenter: parent.horizontalCenter

                ProductCard {
                    productName: qsTr("Sports Car")
                    productSubtitle: qsTr("Performance and luxury")
                    productPrice: "$75,000"
                    productImage: "https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=900&q=85"
                    productDetails: [
                        { "label": qsTr("Color"), "value": qsTr("Black") },
                        { "label": qsTr("Type"), "value": qsTr("Sports car") },
                        { "label": qsTr("Model"), "value": "2025" },
                        { "label": qsTr("Engine"), "value": "3000 CC" },
                        { "label": qsTr("Price"), "value": "$75,000" }
                    ]
                }

                ProductCard {
                    productName: qsTr("Laptop")
                    productSubtitle: qsTr("Power for work and play")
                    productPrice: "$1,200"
                    productImage: "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=900&q=85"
                    productDetails: [
                        { "label": qsTr("Type"), "value": qsTr("Gaming laptop") },
                        { "label": qsTr("RAM"), "value": "16 GB" },
                        { "label": qsTr("Storage"), "value": "512 GB SSD" },
                        { "label": qsTr("Screen size"), "value": qsTr("15.6 inches") },
                        { "label": qsTr("Price"), "value": "$1,200" }
                    ]
                }

                ProductCard {
                    productName: qsTr("Smartphone")
                    productSubtitle: qsTr("Fast, smart and connected")
                    productPrice: "$700"
                    productImage: "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=900&q=85"
                    productDetails: [
                        { "label": qsTr("Color"), "value": qsTr("Black") },
                        { "label": qsTr("Storage"), "value": "128 GB" },
                        { "label": qsTr("RAM"), "value": "8 GB" },
                        { "label": qsTr("Screen size"), "value": qsTr("6.5 inches") },
                        { "label": qsTr("Price"), "value": "$700" }
                    ]
                }

                ProductCard {
                    productName: qsTr("Programming Course")
                    productSubtitle: qsTr("Build modern Qt applications")
                    productPrice: "$50"
                    productImage: "https://images.unsplash.com/photo-1523240795612-9a054b0db644?auto=format&fit=crop&w=900&q=85"
                    productDetails: [
                        { "label": qsTr("Course"), "value": qsTr("Qt and QML") },
                        { "label": qsTr("Level"), "value": qsTr("Beginner") },
                        { "label": qsTr("Duration"), "value": qsTr("30 hours") },
                        { "label": qsTr("Lessons"), "value": qsTr("25 lessons") },
                        { "label": qsTr("Price"), "value": "$50" }
                    ]
                }

                ProductCard {
                    productName: qsTr("Modern House")
                    productSubtitle: qsTr("Comfortable city living")
                    productPrice: "$250,000"
                    productImage: "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=900&q=85"
                    productDetails: [
                        { "label": qsTr("Area"), "value": "250 m²" },
                        { "label": qsTr("Location"), "value": qsTr("Cairo") },
                        { "label": qsTr("Bedrooms"), "value": qsTr("4 bedrooms") },
                        { "label": qsTr("Bathrooms"), "value": qsTr("3 bathrooms") },
                        { "label": qsTr("Price"), "value": "$250,000" }
                    ]
                }

                ProductCard {
                    productName: qsTr("Luxury Villa")
                    productSubtitle: qsTr("Premium space and privacy")
                    productPrice: "$600,000"
                    productImage: "https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?auto=format&fit=crop&w=900&q=85"
                    productDetails: [
                        { "label": qsTr("Area"), "value": "450 m²" },
                        { "label": qsTr("Location"), "value": qsTr("New Cairo") },
                        { "label": qsTr("Bedrooms"), "value": qsTr("6 bedrooms") },
                        { "label": qsTr("Bathrooms"), "value": qsTr("5 bathrooms") },
                        { "label": qsTr("Price"), "value": "$600,000" }
                    ]
                }
            }

            Item {
                width: parent.width
                height: 28
            }
        }
    }

    // =========================================================
    // Product details popup
    // =========================================================

    Popup {
        id: productPopup

        width: Math.min(app.width - 44, 610)
        height: Math.min(app.height - 54, 690)
        x: (app.width - width) / 2
        y: (app.height - height) / 2
        padding: 0
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        Overlay.modal: Rectangle {
            color: "black"
            opacity: 0.58

            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
        }

        background: Rectangle {
            radius: 30
            color: "white"
            border.color: "gainsboro"
            border.width: 1
        }

        enter: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 230
                    easing.type: Easing.OutCubic
                }

                NumberAnimation {
                    property: "scale"
                    from: 0.88
                    to: 1.0
                    duration: 300
                    easing.type: Easing.OutBack
                }
            }
        }

        exit: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 170
                    easing.type: Easing.InCubic
                }

                NumberAnimation {
                    property: "scale"
                    from: 1.0
                    to: 0.94
                    duration: 170
                    easing.type: Easing.InCubic
                }
            }
        }

        contentItem: Flickable {
            id: popupFlickable

            contentWidth: width
            contentHeight: popupColumn.height + 38
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            Column {
                id: popupColumn

                width: popupFlickable.width
                spacing: 18

                Rectangle {
                    width: parent.width
                    height: 250
                    radius: 30
                    color: "lavender"
                    clip: true

                    Image {
                        anchors.fill: parent
                        source: app.selectedImage
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: "black"
                        opacity: 0.12
                    }

                    Rectangle {
                        width: 42
                        height: 42
                        radius: 21
                        color: "white"
                        opacity: 0.94

                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.topMargin: 16
                        anchors.rightMargin: 16

                        Text {
                            anchors.centerIn: parent
                            text: "×"
                            color: app.textColor
                            font.pixelSize: 27
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: productPopup.close()
                        }
                    }
                }

                Column {
                    width: parent.width - 48
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 5

                    Text {
                        width: parent.width
                        text: qsTr("Product details")
                        color: app.primaryColor
                        font.pixelSize: 13
                        font.bold: true
                        horizontalAlignment: app.isArabic ? Text.AlignRight : Text.AlignLeft
                    }

                    Text {
                        width: parent.width
                        text: app.selectedProduct
                        color: app.textColor
                        font.pixelSize: 28
                        font.bold: true
                        wrapMode: Text.WordWrap
                        horizontalAlignment: app.isArabic ? Text.AlignRight : Text.AlignLeft
                    }

                    Text {
                        width: parent.width
                        text: app.selectedSubtitle
                        color: app.mutedTextColor
                        font.pixelSize: 15
                        wrapMode: Text.WordWrap
                        horizontalAlignment: app.isArabic ? Text.AlignRight : Text.AlignLeft
                    }
                }

                Column {
                    id: detailsColumn

                    width: parent.width - 48
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8

                    Repeater {
                        model: app.selectedDetails

                        delegate: Rectangle {
                            required property var modelData

                            width: detailsColumn.width
                            height: 50
                            radius: 14
                            color: "whitesmoke"

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 16
                                spacing: 12

                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.label
                                    color: app.mutedTextColor
                                    font.pixelSize: 14
                                    horizontalAlignment: app.isArabic ? Text.AlignRight : Text.AlignLeft
                                }

                                Text {
                                    text: modelData.value
                                    color: app.textColor
                                    font.pixelSize: 15
                                    font.bold: true
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    width: parent.width - 48
                    height: 50
                    radius: 16
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: closeMouseArea.containsMouse ? app.accentColor : app.primaryColor

                    Behavior on color {
                        ColorAnimation { duration: 180 }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Close")
                        color: "white"
                        font.pixelSize: 16
                        font.bold: true
                    }

                    MouseArea {
                        id: closeMouseArea

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: productPopup.close()
                    }
                }
            }
        }
    }

    // =========================================================
    // Animated splash screen
    // =========================================================

    Rectangle {
        id: splashScreen

        anchors.fill: parent
        z: 1000
        visible: opacity > 0.01
        opacity: app.showSplashScreen ? 1 : 0

        gradient: Gradient {
            orientation: Gradient.Horizontal

            GradientStop {
                position: 0.0
                color: app.primaryColor
            }

            GradientStop {
                position: 1.0
                color: app.accentColor
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 520
                easing.type: Easing.OutCubic
            }
        }

        Rectangle {
            width: 330
            height: 330
            radius: 165
            x: -120
            y: -90
            color: "white"
            opacity: 0.08
        }

        Rectangle {
            width: 260
            height: 260
            radius: 130
            x: parent.width - 110
            y: parent.height - 120
            color: "white"
            opacity: 0.07
        }

        Column {
            anchors.centerIn: parent
            spacing: 18

            Rectangle {
                id: splashLogo

                width: 122
                height: 122
                radius: 38
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    anchors.centerIn: parent
                    text: "G"
                    color: app.primaryColor
                    font.pixelSize: 63
                    font.bold: true
                }

                SequentialAnimation on scale {
                    loops: Animation.Infinite

                    NumberAnimation {
                        to: 1.06
                        duration: 700
                        easing.type: Easing.InOutSine
                    }

                    NumberAnimation {
                        to: 1.0
                        duration: 700
                        easing.type: Easing.InOutSine
                    }
                }
            }

            Text {
                text: qsTr("Geddo Store")
                color: "white"
                font.pixelSize: 39
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: qsTr("Loading your experience")
                color: "white"
                opacity: 0.86
                font.pixelSize: 15
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                spacing: 8
                anchors.horizontalCenter: parent.horizontalCenter

                Repeater {
                    model: 3

                    Rectangle {
                        width: 9
                        height: 9
                        radius: 5
                        color: "white"
                        opacity: 0.35

                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            PauseAnimation { duration: index * 180 }
                            NumberAnimation { to: 1.0; duration: 340 }
                            NumberAnimation { to: 0.35; duration: 340 }
                            PauseAnimation { duration: (2 - index) * 180 }
                        }
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
        }
    }
}
