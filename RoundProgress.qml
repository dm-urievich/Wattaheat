import QtQuick 2.0

Item {
    id: root
    property color primaryColor: "#E0F6D0"
    property color secondaryColor: "#99E265"

    property real minimumValue: 0
    property real maximumValue: 100
    property real currentValue: 0
    property string text: "00:00"
    property real linewidth: 0.25

    signal clicked()

    Canvas {
        id: knob
        anchors.fill: parent
        antialiasing: true
        property real border: radius * root.linewidth * 0.5
        property real centerWidth: 0.9 * width / 2 + border
        property real centerHeight: 0.9 * height / 2 + border
        property real radius: 0.9 * Math.min(knob.width - 2 * border, knob.height - 2*border) / 2

        // this is the angle that splits the circle in two arcs
        // first arc is drawn from 0 radians to angle radians
        // second arc is angle radians to 2*PI radians
        property real angle: (currentValue - minimumValue) / (maximumValue - minimumValue) * 2 * Math.PI

        // we want both circle to start / end at 12 o'clock
        // without this offset we would start / end at 9 o'clock
        property real angleOffset: -Math.PI / 2

        onPaint: {
            var ctx = getContext("2d");
            ctx.save();

            ctx.clearRect(0, 0, knob.width, knob.height);

            // fills the mouse area when pressed
            // the fill color is a lighter version of the
            // secondary color

//            if (mouseArea.pressed) {
//                ctx.beginPath();
//                ctx.lineWidth = 1;
//                ctx.fillStyle = Qt.lighter(root.secondaryColor, 1.25);
//                ctx.arc(knob.centerWidth,
//                        knob.centerHeight,
//                        knob.radius,
//                        0,
//                        2*Math.PI);
//                ctx.fill();
//            }

            // First, thinner arc
            // From angle to 2*PI

            ctx.beginPath();
            ctx.lineWidth = root.linewidth * radius;
            ctx.strokeStyle = root.primaryColor;
            ctx.arc(knob.centerWidth,
                    knob.centerHeight,
                    knob.radius,
                    angleOffset + knob.angle,
                    angleOffset + 2*Math.PI);
            ctx.stroke();


            // Second, thicker arc
            // From 0 to angle

            ctx.beginPath();
            ctx.lineWidth = root.linewidth * radius;
            ctx.strokeStyle = root.secondaryColor;
            ctx.arc(knob.centerWidth,
                    knob.centerHeight,
                    knob.radius,
                    knob.angleOffset,
                    knob.angleOffset + knob.angle);
            ctx.stroke();

            ctx.restore();
        }


        Text {
            anchors.centerIn: parent
            font.pixelSize: knob.radius * 0.5
            color: "#FFFFFF"
            text: root.text
        }

        MouseArea {
            id: mouseArea

            anchors.fill: parent
            onClicked: root.clicked()
        }
    }

    onPrimaryColorChanged: knob.requestPaint()
    onSecondaryColorChanged: knob.requestPaint()
    onMinimumValueChanged: knob.requestPaint()
    onMaximumValueChanged: knob.requestPaint()
    onCurrentValueChanged: {
        knob.requestPaint();
    }

    Component.objectName: knob.requestPaint()
}
