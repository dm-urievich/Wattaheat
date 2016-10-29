import QtQuick.Controls 2.0 as Ctrl
import QtQuick 2.2
import QtCharts 2.0
import QtQuick.Window 2.2

Ctrl.Page {
    id: root

    property var tempData: []
    property string secondaryTextColor: "#A8A8A8"

    background: Rectangle {
        color: "#000000"
    }

    Column {
        anchors.fill: parent

        Rectangle {
            height: Screen.height / 10
            width: parent.width
            color: "#99E265"
        }

        Item {
            height: Screen.height / 15
            width: parent.width
        }

        RoundProgress {
            width: Screen.width / 1.2
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item {
            height: Screen.height / 28
            width: parent.width
        }

        Text {
            id: currentTempText
            anchors.horizontalCenter: parent.horizontalCenter
            color: secondaryTextColor
//            font.family: "Helvetica"
            font.pointSize: 60
//            font.bold: true
            text: "42 °C"
        }

        Item {
            height: Screen.height / 28
            width: parent.width
        }

        Text {
            id: joke
            anchors.horizontalCenter: parent.horizontalCenter
            color: secondaryTextColor
            font.pointSize: 22
            text: "Enough time for facebook feed"
        }

//        BtManager {
//            id: btManager
//            anchors.horizontalCenter: parent.horizontalCenter
//            height: 50
//            width: parent.width - 10

//            property var prevTime: new Date()

//            onDataReceived: {
//                var flt = parseFloat(data)

//                if (flt) {
//                    tempData.push(flt);

//                    var currentTime = new Date
//                    var delta = currentTime.getTime() - prevTime.getTime()
//                    prevTime = currentTime;

//                    var x = mainChart.lastX + delta / 1000

//                    if (mainChart.count === 0) {
//                        x = 0;
//                    }

//                    mainChart.append(x, flt);
//                    mainChart.lastX = x //mainChart.lastX + delta / 1000

//                    tempModel.append({"temp": flt});

//                    axisX.max = Math.max(120, mainChart.lastX);
//                    currentTempText.text = flt + " °C"

//                    console.log(tempData)
//                }
//                else {
//                    console.log("bad data")
//                }
//            }
//        }

//        Item {
//            id: tempChart
//            height: Screen.height / 2
//            width: parent.width - 10
//            anchors.horizontalCenter: parent.horizontalCenter

//    Rectangle {
//        anchors.fill: parent
//        color: "green"
//        opacity: 0.2
//    }
//            ChartView {
//                anchors.fill: tempChart
//                antialiasing: true
//                animationOptions: ChartView.SeriesAnimations
//                legend.visible: false

//                ValueAxis {
//                    id: axisX
//                    min: 0
//                    max: 120
//                }

//                ValueAxis {
//                    id: axisY
//                    min: 0
//                    max: 105
//                }

//                SplineSeries {
//                    id: mainChart
//                    axisX: axisX
//                    axisY: axisY
//                    pointLabelsVisible: false

//                    property real lastX: 0
//                }
//            }
//        }

    }
}
