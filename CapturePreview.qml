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

    property double compr: 0
    property double compg: 0
    property double compb: 0

    property double h: 0
    property double s: 0
    property double l: 0

    property double lWrong: 0
    property double lMoreWrong: 0

    property double heightFactor: 0.0
    property double widthFactor: 0.0

    property color myColor: Qt.rgba(r, g, b, a)
    property color inverseCol: Qt.rgba(a-r, a-g, a-b, a)
    property color textColor: Qt.hsla(0,0,lWrong,1)
    property color textInvColor: Qt.hsla(0,0,lMoreWrong,1)
    property color compColor: Qt.rgba(compr, compg, compb, 1)

    function movebyHalf(num){
        var newNum = (360*num)+180;
        if(newNum > 360) return newNum - 360;
        else return newNum/360;
    }

    function hue2rgb(p, q, t){
        if(t < 0) t += 1;
        if(t > 1) t -= 1;
        if(t < 1/6) return p + (q - p) * 6 * t;
        if(t < 1/2) return q;
        if(t < 2/3) return p + (q - p) * (2/3 - t) * 6;
        return p;
    }


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

            r = ar.data[(yPos*ar.width+xPos)*4]/255
            g = ar.data[((yPos*ar.width+xPos)*4)+1]/255
            b = ar.data[((yPos*ar.width+xPos)*4)+2]/255
            a = ar.data[((yPos*ar.width+xPos)*4)+3]/255

            var max = Math.max(r, g, b), min = Math.min(r, g, b);
                var h, s, l = (max + min) / 2;

                if(max == min){
                    h = s = 0; // achromatic
                }else{
                    var d = max - min;
                    s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
                    switch(max){
                        case r: h = (g - b) / d + (g < b ? 6 : 0); break;
                        case g: h = (b - r) / d + 2; break;
                        case b: h = (r - g) / d + 4; break;
                    }
                    h /= 6;
                }

            if (l < 0.4) {lWrong = 1; lMoreWrong = 0;}
            else {lWrong = 0; lMoreWrong = 1;}

            var newH = movebyHalf(h)

            if(s === 0){
                    compr = compg = compb = l;
                }else{
                    var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
                    var p = 2 * l - q;
                    compr = hue2rgb(p, q, newH + 1/3);
                    compg = hue2rgb(p, q, newH);
                    compb = hue2rgb(p, q, newH - 1/3);
                }

            //compColor = Qt.rgba(compr, compg, compb, compa)
            //myColor = Qt.rgba(r, g, b, a)

        }

        Rectangle {
            id: previewCol
            width: 150
            height: 25
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 8
            color: myColor

            Text {
                anchors.fill: parent
                text: "color: " + myColor
                color: textColor
            }
        }

        Rectangle {
            id: previewInvCol
            width: 150
            height: 25
            anchors.top: previewCol.bottom
            anchors.left: parent.left
            anchors.leftMargin: 8

            color: inverseCol

            Text {
                anchors.fill: parent
                text: "inv. color: " + inverseCol
                color: textInvColor
            }
        }

        Rectangle {
            id: previewCompCol
            width: 150
            height: 25
            anchors.top: previewInvCol.bottom
            anchors.left: parent.left
            anchors.leftMargin: 8

            color: compColor

            Text {
                anchors.fill: parent
                text: "com. color: " + compColor
                color: textColor
            }
        }

        Rectangle {
            id: rgbGraphs
            width: 150
            height: 75
            anchors.top: parent.top
            anchors.left: previewCompCol.right
            anchors.topMargin: 8
            anchors.leftMargin: 8

            color: "#00000000"

            LoadBar {
                id: rgbR
                anchors.top: parent.top
                anchors.topMargin: 2
                anchors.left: parent.left
                anchors.right: parent.right
                height: ((parent.height-4)/10)*3

                passedColor: "red"
                spIndex: r
                passedText: "R"

            }

            LoadBar {
                id: rgbG
                anchors.top: rgbR.bottom
                anchors.topMargin: ((parent.height-4)/10)/2
                anchors.left: parent.left
                anchors.right: parent.right
                height: ((parent.height-4)/10)*3

                passedColor: "green"
                spIndex: g
                passedText: "G"

            }

            LoadBar {
                id: rgbB
                anchors.top: rgbG.bottom
                anchors.topMargin: ((parent.height-4)/10)/2
                anchors.left: parent.left
                anchors.right: parent.right
                height: ((parent.height-4)/10)*3

                passedColor: "blue"
                spIndex: b
                passedText: "B"

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
        }
    }

}
