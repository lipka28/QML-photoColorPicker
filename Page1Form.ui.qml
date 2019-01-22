import QtQuick 2.9
import QtQuick.Controls 2.2

Page {
    id: page
    width: 600
    height: 400

    header: Label {
        text: qsTr("Color Picker")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Qt.application.font.pixelSize * 2
        padding: 10
    }

    Rectangle {
        id: camImage
        color: "#fff333"
        anchors.fill: parent

        CameraView {
            id: cameraView
            x: 278
            y: 155
        }
    }
}
