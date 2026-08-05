import QtQuick

Window {
    width: 750
    height: 600
    visible: true
    title: "Student Information"
    color: "lightgray"

    property string studentName: "Abdelrahman Hazem"
    property string studentRole: "Mechatronics Systems Engineering"
    property string university: "MSA University"
    property string cityName: "Giza"
    property string studentAddress: "Sheikh Zayed City"
    property string studentHeight: "178 cm"

    Rectangle {
        width: 550
        height: 420
        anchors.centerIn: parent
        color: "white"
        border.color: "red"
        border.width: 4

        Rectangle {
            width: 500
            height: 370
            anchors.centerIn: parent
            color: "white"
            border.color: "green"
            border.width: 3

            Column {
                anchors.centerIn: parent
                spacing: 18

                Text {
                    text: "Hello World"
                    font.pixelSize: 30
                    font.bold: true
                    color: "blue"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Name: " + studentName
                    font.pixelSize: 22
                    color: "black"
                }

                Text {
                    text: "Role: " + studentRole
                    font.pixelSize: 22
                    color: "black"
                }

                Text {
                    text: "University: " + university
                    font.pixelSize: 22
                    color: "black"
                }

                Text {
                    text: "City: " + cityName
                    font.pixelSize: 22
                    color: "black"
                }

                Text {
                    text: "Address: " + studentAddress
                    font.pixelSize: 22
                    color: "black"
                }

                Text {
                    text: "Height: " + studentHeight
                    font.pixelSize: 22
                    color: "black"
                }
            }
        }
    }
}
