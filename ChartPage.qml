import QtQuick.Controls 2.0 as Ctrl
import QtQuick 2.2
import QtCharts 2.0
import QtQuick.Window 2.2

Ctrl.Page {
    id: root

    property var tempData: []

    property var prevTime: new Date()

    property real current_temp: 25.0

    property int predictedTime
    property real targetTemp

    function clearCharts() {
        tempData = [];
        filteredChart.clear();
        mainChart.clear();
    }

    function newTemp(data) {
        var flt = data;

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

            filteredChart.clear();
            for (var i = 0; i < predictedTime; i++) {
                filteredChart.append(i, notificationClient.model(i));
            }

            tempModel.append({"temp": flt});

//            axisX.max = Math.max(120, mainChart.lastX);
            axisX.max = Math.max(120, predictedTime);
            currentTempText.text = flt + " °C"

            //console.log(tempData)
        }
        else {
            console.log("bad data")
        }
    }

    background: Rectangle {
        color: "#000000"
    }

    Column {
        anchors.fill: parent
        spacing: 5

        Item {
            id: tempChart
            height: Screen.height / 2
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter

            ChartView {
                anchors.fill: tempChart
                antialiasing: true
                animationOptions: ChartView.SeriesAnimations
                legend.visible: false
                backgroundColor: "#000000"

                ValueAxis {
                    id: axisX
                    min: 0
                    max: 120
//                    gridVisible: false
                    color: "#A8A8A8"
                    labelsColor: "#E0F6D0"
                }

                ValueAxis {
                    id: axisY
                    min: 0
                    max: targetTemp + 10
//                    gridVisible: false
                    color: "#A8A8A8"
                    labelsColor: "#E0F6D0"
                }

                ScatterSeries {
                    id: mainChart
                    axisX: axisX
                    axisY: axisY
                    pointLabelsVisible: false
                    markerSize: 2
                    color: "#99E265"

                    property real lastX: 0
                }
                LineSeries {
                    id: filteredChart
                    axisX: axisX
                    axisY: axisY
                    pointLabelsVisible: false

                    property real lastX: 0
                }
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
