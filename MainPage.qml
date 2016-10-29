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

            onDataReceived: {
                console.log("daaaaaaaaaa" + data)
                tempData.push(data);
                mainChart.append(mainChart.lastX, parseFloat(data));
                mainChart.lastX = mainChart.lastX + 1
                tempModel.append({"temp": data});

                axisX.max = parseFloat(data)
                currentTempText.text = data

                console.log(tempData)
            }
        }

        Item {
            id: tempChart
            height: 300
            width: 200
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

                ValueAxis {
                    id: axisX
                    min: 0
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

                    property int lastX: 0
                }


    //            SplineSeries {
    //                name: "SplineSeries"
    //                XYPoint { x: 0; y: 0.0 }
    //                XYPoint { x: 2.1; y: 3.2 }
    //                XYPoint { x: 2.9; y: 2.4 }
    //                XYPoint { x: 2.1; y: 2.1 }
    //                XYPoint { x: 2.9; y: 2.6 }
    //                XYPoint { x: 3.4; y: 2.3 }
    //                XYPoint { x: 4.1; y: 3.1 }
    //            }
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
