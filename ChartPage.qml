import QtQuick.Controls 2.0 as Ctrl
import QtQuick 2.2
import QtCharts 2.0
import QtQuick.Window 2.2

Ctrl.Page {
    id: root

    property var tempData: []

    property var prevTime: new Date()

    property string btStatus: ""

    signal connectTo(string address)

    function addBuletoothDevice(macAddress) {
        blueDevModel.append({"macAddr": macAddress});
    }

    function newTemp(data) {
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

    Column {
        anchors.fill: parent
        spacing: 5

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            height: 50
            width: parent.width - 10
            text: btStatus
        }


        Item {
            id: tempChart
            height: Screen.height / 2
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

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 300
            height: 100
            label: "make happy"

            onButtonClick: {
                console.log("send notification")
                notificationClient.notification = "User is happy!"
            }
        }

        ListModel {
            id: blueDevModel
        }

        Item {
            width: parent.width
            height: 300

            ListView {
                id: bluetoothDevices
                width: 300
                anchors.left: parent.left
                height: 300
                model: blueDevModel
                clip: true
                delegate: Component {
                    Text {
                        font.pointSize: 14
                        text: macAddr
                    }
                }
            }

            Button {
                id: toMy
                anchors.right: parent.right
                anchors.top: parent.top
                width: 200
                height: 100
                label: "to test"

                onButtonClick: {
                    console.log("connect to test");
                    connectTo("00:13:03:13:70:83");
                }
            }

            Button {
                id: toDevice
                anchors.right: parent.right
                anchors.top: toMy.bottom
                width: 200
                height: 100
                label: "to device"

                onButtonClick: {
                    console.log("connect to device");
                    connectTo("98:D3:31:80:75:22");
                }
            }
        }
    }
}
