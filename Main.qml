import QtQuick
import QtQuick.Window

Window {
    width: 850
    height: 650
    visible: true
    title: "Online Store"

    // Controls the splash screen
    property bool showSplashScreen: true

    // Controls the product information window
    property bool showProductInformation: false

    // Information about the selected product
    property string selectedProduct: ""
    property string selectedDetails: ""
    property url selectedImage: ""

    // Wait for 3 seconds, then hide the splash screen
    Timer {
        interval: 3000
        running: true
        repeat: false

        onTriggered: {
            showSplashScreen = false
        }
    }

    // ==================================================
    // Home Screen
    // ==================================================

    Rectangle {
        anchors.fill: parent
        color: "lightgray"

        Text {
            id: pageTitle

            text: "Our Products"
            color: "black"
            font.pixelSize: 30
            font.bold: true

            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: instructions

            text: "Click any product image to show its information"
            color: "gray"
            font.pixelSize: 15

            anchors.top: pageTitle.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Grid {
            columns: 3
            spacing: 15

            anchors.top: instructions.bottom
            anchors.topMargin: 15
            anchors.horizontalCenter: parent.horizontalCenter

            // ==================================================
            // Car
            // ==================================================

            Rectangle {
                width: 245
                height: 235
                color: "white"
                border.color: "gray"
                border.width: 2
                radius: 10

                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 8

                    Image {
                        id: carImage

                        width: parent.width
                        height: 155

                        source: "https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=500&q=80"
                        fillMode: Image.PreserveAspectCrop

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                selectedProduct = "Sports Car"
                                selectedDetails =
                                        "Color: Black\n" +
                                        "Type: Sports Car\n" +
                                        "Model: 2025\n" +
                                        "Engine: 3000 CC\n" +
                                        "Price: 75,000 Dollars"

                                selectedImage = carImage.source
                                showProductInformation = true
                            }
                        }
                    }

                    Text {
                        text: "Sports Car"
                        color: "purple"
                        font.pixelSize: 20
                        font.bold: true
                    }

                    Text {
                        text: "Click the picture for details"
                        color: "gray"
                        font.pixelSize: 14
                    }
                }
            }

            // ==================================================
            // Computer
            // ==================================================

            Rectangle {
                width: 245
                height: 235
                color: "white"
                border.color: "gray"
                border.width: 2
                radius: 10

                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 8

                    Image {
                        id: computerImage

                        width: parent.width
                        height: 155

                        source: "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=500&q=80"
                        fillMode: Image.PreserveAspectCrop

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                selectedProduct = "Laptop"
                                selectedDetails =
                                        "Type: Gaming Laptop\n" +
                                        "RAM: 16 GB\n" +
                                        "Storage: 512 GB SSD\n" +
                                        "Screen Size: 15.6 Inches\n" +
                                        "Price: 1,200 Dollars"

                                selectedImage = computerImage.source
                                showProductInformation = true
                            }
                        }
                    }

                    Text {
                        text: "Computer"
                        color: "purple"
                        font.pixelSize: 20
                        font.bold: true
                    }

                    Text {
                        text: "Click the picture for details"
                        color: "gray"
                        font.pixelSize: 14
                    }
                }
            }

            // ==================================================
            // Phone
            // ==================================================

            Rectangle {
                width: 245
                height: 235
                color: "white"
                border.color: "gray"
                border.width: 2
                radius: 10

                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 8

                    Image {
                        id: phoneImage

                        width: parent.width
                        height: 155

                        source: "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=500&q=80"
                        fillMode: Image.PreserveAspectCrop

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                selectedProduct = "Smartphone"
                                selectedDetails =
                                        "Color: Black\n" +
                                        "Storage: 128 GB\n" +
                                        "RAM: 8 GB\n" +
                                        "Screen Size: 6.5 Inches\n" +
                                        "Price: 700 Dollars"

                                selectedImage = phoneImage.source
                                showProductInformation = true
                            }
                        }
                    }

                    Text {
                        text: "Phone"
                        color: "purple"
                        font.pixelSize: 20
                        font.bold: true
                    }

                    Text {
                        text: "Click the picture for details"
                        color: "gray"
                        font.pixelSize: 14
                    }
                }
            }

            // ==================================================
            // Course
            // ==================================================

            Rectangle {
                width: 245
                height: 235
                color: "white"
                border.color: "gray"
                border.width: 2
                radius: 10

                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 8

                    Image {
                        id: courseImage

                        width: parent.width
                        height: 155

                        source: "https://images.unsplash.com/photo-1523240795612-9a054b0db644?auto=format&fit=crop&w=500&q=80"
                        fillMode: Image.PreserveAspectCrop

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                selectedProduct = "Programming Course"
                                selectedDetails =
                                        "Course: Qt and QML\n" +
                                        "Level: Beginner\n" +
                                        "Duration: 30 Hours\n" +
                                        "Number of Lessons: 25\n" +
                                        "Price: 50 Dollars"

                                selectedImage = courseImage.source
                                showProductInformation = true
                            }
                        }
                    }

                    Text {
                        text: "Programming Course"
                        color: "purple"
                        font.pixelSize: 18
                        font.bold: true
                    }

                    Text {
                        text: "Click the picture for details"
                        color: "gray"
                        font.pixelSize: 14
                    }
                }
            }

            // ==================================================
            // House
            // ==================================================

            Rectangle {
                width: 245
                height: 235
                color: "white"
                border.color: "gray"
                border.width: 2
                radius: 10

                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 8

                    Image {
                        id: houseImage

                        width: parent.width
                        height: 155

                        source: "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=500&q=80"
                        fillMode: Image.PreserveAspectCrop

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                selectedProduct = "Modern House"
                                selectedDetails =
                                        "Area: 250 Square Meters\n" +
                                        "Location: Cairo\n" +
                                        "Bedrooms: 4\n" +
                                        "Bathrooms: 3\n" +
                                        "Price: 250,000 Dollars"

                                selectedImage = houseImage.source
                                showProductInformation = true
                            }
                        }
                    }

                    Text {
                        text: "House"
                        color: "purple"
                        font.pixelSize: 20
                        font.bold: true
                    }

                    Text {
                        text: "Click the picture for details"
                        color: "gray"
                        font.pixelSize: 14
                    }
                }
            }

            // ==================================================
            // Villa
            // ==================================================

            Rectangle {
                width: 245
                height: 235
                color: "white"
                border.color: "gray"
                border.width: 2
                radius: 10

                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 8

                    Image {
                        id: villaImage

                        width: parent.width
                        height: 155

                        source: "https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?auto=format&fit=crop&w=500&q=80"
                        fillMode: Image.PreserveAspectCrop

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                selectedProduct = "Luxury Villa"
                                selectedDetails =
                                        "Area: 450 Square Meters\n" +
                                        "Location: New Cairo\n" +
                                        "Bedrooms: 6\n" +
                                        "Bathrooms: 5\n" +
                                        "Price: 600,000 Dollars"

                                selectedImage = villaImage.source
                                showProductInformation = true
                            }
                        }
                    }

                    Text {
                        text: "Villa"
                        color: "purple"
                        font.pixelSize: 20
                        font.bold: true
                    }

                    Text {
                        text: "Click the picture for details"
                        color: "gray"
                        font.pixelSize: 14
                    }
                }
            }
        }
    }

    // ==================================================
    // Splash Screen
    // ==================================================

    Rectangle {
        anchors.fill: parent
        color: "purple"
        visible: showSplashScreen

        Column {
            anchors.centerIn: parent
            spacing: 20

            Image {
                width: 160
                height: 160

                source: "https://cdn-icons-png.flaticon.com/512/3081/3081559.png"
                fillMode: Image.PreserveAspectFit

                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Geddo Store"
                color: "white"
                font.pixelSize: 38
                font.bold: true

                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Everything you need in one place"
                color: "white"
                font.pixelSize: 18

                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    // ==================================================
    // Dark Background Behind the Information Window
    // ==================================================

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.6
        visible: showProductInformation

        MouseArea {
            anchors.fill: parent

            onClicked: {
                showProductInformation = false
            }
        }
    }

    // ==================================================
    // Product Information Window
    // ==================================================

    Rectangle {
        width: 480
        height: 470
        color: "white"
        radius: 15

        border.color: "purple"
        border.width: 4

        anchors.centerIn: parent
        visible: showProductInformation

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 12

            Text {
                text: selectedProduct
                color: "purple"
                font.pixelSize: 28
                font.bold: true

                anchors.horizontalCenter: parent.horizontalCenter
            }

            Image {
                width: 420
                height: 230

                source: selectedImage
                fillMode: Image.PreserveAspectCrop

                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: selectedDetails
                color: "black"
                font.pixelSize: 17
            }

            Rectangle {
                width: 120
                height: 40
                color: "purple"
                radius: 8

                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    text: "Close"
                    color: "white"
                    font.pixelSize: 17
                    font.bold: true

                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        showProductInformation = false
                    }
                }
            }
        }
    }
}
