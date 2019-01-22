import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow {
    visible: true
    width: 720
    height: 1280
    title: qsTr("noTabs")

    SwipeView {
        id: swipeView
        anchors.fill: parent

        Page1Form {
        }
    }
}
