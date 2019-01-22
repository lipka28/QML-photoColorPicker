import QtQuick 2.0
import QtMultimedia 5.9

Item {
    property alias source: imagePreview.source
    property int xPos: 0
    property int yPos: 0

    property double r: 0
    property double g: 0
    property double b: 0
    property double a: 0

    property double heightFactor: 0.0
    property double widthFactor: 0.0

    property color myColor: Qt.rgba(r, g, b, a)
    property color inverseCol: Qt.rgba(a-r, a-g, a-b, a)


    signal closed

    Image {
        id: imagePreview
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        smooth: true
        onSourceChanged: {
            picker.loadImage(imagePreview.source)
        }
    }

    Canvas {
        id: picker
        anchors.fill: parent
        onImageLoaded: {
            var ctx = getContext("2d")
            ctx.drawImage(imagePreview.source, 0, 0, width, height)
            requestPaint()
        }

        onPaint: {
            var ctx = getContext("2d")
            var ar = ctx.getImageData(0, 0, parent.width, parent.height);
            heightFactor = ar.height/height
            widthFactor = ar.width/width

            console.log("Width: " + width*widthFactor + " Height: " + height*heightFactor)
            console.log("Source Width: " + ar.width + " Source Height: " + ar.height)
            console.log("my Sze: " + width*height*heightFactor*widthFactor*4 + " jejich size: "+ ar.data.length )

            r = ar.data[(yPos*ar.width+xPos)*4]/255
            g = ar.data[((yPos*ar.width+xPos)*4)+1]/255
            b = ar.data[((yPos*ar.width+xPos)*4)+2]/255
            a = ar.data[((yPos*ar.width+xPos)*4)+3]/255

            myColor = Qt.rgba(r, g, b, a)
        }

        Rectangle {
            id: preview
            width: 100
            height: 100
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 8
            color: myColor

            /*onPaint: {
                var ctx = getContext("2d");
                ctx.fillStyle = myColor
                ctx.fillRect(0, 0, width, height);

                console.log("rgba: "+ myColor)
            }*/

            Text {
                anchors.fill: parent
                text: "test"
                color: inverseCol
            }
        }
    }


    MouseArea{
        id: pointerArea
        anchors.fill: parent
        onClicked: {
            xPos = mouseX*widthFactor
            yPos = mouseY*heightFactor
            console.log("mouse x Postion: ", xPos," mouse y Position", yPos)
            picker.requestPaint()
            preview.requestPaint()
        }
    }

}
