import QtQuick.Controls 2.0
import QtQuick 2.2
import QtCharts 2.0

Page {
    id: root

    property var tempData: []

    Column {
        anchors.fill: parent
        spacing: 5

        BtManager {
            id: btManager
            anchors.horizontalCenter: parent.horizontalCenter
            height: 50
            width: parent.width - 10

            property var prevTime: new Date()

            onDataReceived: {
                var flt = parseFloat(data)

                if (flt) {
                    tempData.push(flt);

                    var currentTime = new Date
                    var delta = currentTime.getTime() - prevTime.getTime()
                    prevTime = currentTime;

                    var x = mainChart.lastX + delta / 1000

                    if (mainChart.count === 0) {
                        x = 0;
                    }

                    mainChart.append(x, flt);
                    mainChart.lastX = x //mainChart.lastX + delta / 1000

                    tempModel.append({"temp": flt});

                    axisX.max = Math.max(120, mainChart.lastX);
                    currentTempText.text = flt + " °C"

                    console.log(tempData)
                }
                else {
                    console.log("bad data")
                }
            }
        }

        Item {
            id: tempChart
            height: 300
            width: parent.width - 10
            anchors.horizontalCenter: parent.horizontalCenter

    Rectangle {
        anchors.fill: parent
        color: "green"
        opacity: 0.2
    }
            ChartView {
                anchors.fill: tempChart
                antialiasing: true
                animationOptions: ChartView.SeriesAnimations
                legend.visible: false

                ValueAxis {
                    id: axisX
                    min: 0
                    max: 120
                }

                ValueAxis {
                    id: axisY
                    min: 0
                    max: 105
                }

                SplineSeries {
                    id: mainChart
                    axisX: axisX
                    axisY: axisY
                    pointLabelsVisible: false

                    property real lastX: 0
                }


//                SplineSeries {
//                    name: "SplineSeries"
//                    XYPoint { x: 0; y: 0.0 }
//                    XYPoint { x: 2.1; y: 3.2 }
//                    XYPoint { x: 2.9; y: 2.4 }
//                    XYPoint { x: 2.1; y: 2.1 }
//                    XYPoint { x: 2.9; y: 2.6 }
//                    XYPoint { x: 3.4; y: 2.3 }
//                    XYPoint { x: 4.1; y: 3.1 }
//                }
            }
        }


        Text {
            id: currentTempText
            anchors.horizontalCenter: parent.horizontalCenter
            color: "green"
            font.family: "Helvetica"
            font.pointSize: 24
        }


        ListModel {
            id: tempModel
        }

        ListView {
            id: tempDataView
            width: 100
            anchors.horizontalCenter: parent.horizontalCenter
            height: 100
            model: tempModel
            clip: true
            delegate: Component {
                Text {
                    font.pointSize: 14
                    text: temp
                }
            }
        }
    }
}
