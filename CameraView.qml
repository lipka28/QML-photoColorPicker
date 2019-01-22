import QtQuick 2.0
import QtMultimedia 5.9

Rectangle {
    id: completView

    anchors.fill: parent

    Rectangle {
        id: cameraView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        height: (parent.height / 100)*80

        color: "black"
        state: "PhotoCapture"

        states: [
            State {
                name: "PhotoCapture"
                StateChangeScript {
                    script: {
                        camera.captureMode = Camera.CaptureStillImage
                        camera.start()
                    }
                }
            },

            State {
                name: "PhotoPreview"
            }
        ]

        VideoOutput {
            id: viewfinder
            visible: cameraView.state == "PhotoCapture"

            anchors.fill: parent

            source: camera
            autoOrientation: true
        }

        CapturePreview {
            id: capturePreview
            anchors.fill: parent
            onClosed: cameraView.state = "PhotoCapture"
            visible: cameraView.state == "PhotoPreview"
            focus: visible

        }
    }

    Rectangle {
        id: controlsUI

        anchors.top: cameraView.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        color: "#232323"

        Rectangle {
            id: buttonTakePhoto
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 18
            anchors.left: parent.left
            color: "DarkOrange"
            width: (parent.width/5)
            radius: 180

            Image {
                id: camImage
                anchors.fill: parent
                anchors.margins: 10
                source: "qrc:/images/baseline_photo_camera_black_48dp.png"
            }

            MouseArea {
                id: clickArea
                anchors.fill: parent
                onClicked: {
                    camera.imageCapture.capture()
                }
            }

        }

        Rectangle {
            id: buttonScrapPhoto
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 18
            anchors.leftMargin: (parent.width/5)-18
            anchors.left: buttonTakePhoto.right
            color: "DarkOrange"
            width: parent.width/5
            radius: 180

            Image {
                id: scrapImage
                anchors.fill: parent
                anchors.margins: 10
                source: "qrc:/images/baseline_delete_forever_black_48dp.png"
            }

            MouseArea {
                id: clickArea2
                anchors.fill: parent
                onClicked: {
                    capturePreview.closed()
                }
            }

        }

        Rectangle {
            id: focusButton
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 18
            anchors.leftMargin: (parent.width/5)-18
            anchors.left: buttonScrapPhoto.right
            color: "DarkOrange"
            width: parent.width/5
            radius: 180

            Image {
                id: focusImage
                anchors.fill: parent
                anchors.margins: 10
                source: "qrc:/images/baseline_center_focus_strong_black_48dp.png"
            }

            MouseArea {
                id: clickArea3
                anchors.fill: parent
                onClicked: {
                        camera.unlock()
                        camera.searchAndLock()

                }
            }

        }


    }

    Camera {
        id: camera
        captureMode: Camera.CaptureStillImage

        imageCapture {
            onImageCaptured: {
                capturePreview.source = preview
                cameraView.state = "PhotoPreview"
            }
        }
    }

}
