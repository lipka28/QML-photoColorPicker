import QtQuick 2.0
import QtMultimedia 5.9

Rectangle {
    property color passedColor: Qt.rgba(0,0,0,1)
    property double spIndex: 1
    property string passedText: "a"

    color: "black"
    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        color: "black"

        Rectangle {
            id: fill
            color: passedColor
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: parent.width*spIndex

            Text {
                id: colName
                text: passedText
                color: "white"
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.margins: 1

            }
        }
    }
}
