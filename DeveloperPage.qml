import QtQuick.Controls 2.0 as Ctrl
import QtQuick 2.2
import QtCharts 2.0
import QtQuick.Window 2.2

Ctrl.Page {
    id: root

    property var tempData: []

    property var prevTime: new Date()

    property string btStatus: ""
    property real current_temp: 25.0

    signal connectTo(string address)

    function addBuletoothDevice(macAddress) {
        blueDevModel.append({"macAddr": macAddress});
    }

    background: Rectangle {
        color: "#000000"
    }

    Column {
        anchors.fill: parent
        spacing: 10

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            height: 50
            width: parent.width - 10
            color: "#E0F6D0"
            text: btStatus
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
                    color: "#E0F6D0"
                    text: temp
                }
            }
        }

        ListModel {
            id: blueDevModel
        }

        ListView {
            id: bluetoothDevices
            width: 300
            anchors.left: parent.left
            height: 300
            model: blueDevModel
            clip: true
            delegate: Component {
                Text {
                    color: "#E0F6D0"
                    font.pointSize: 14
                    text: macAddr
                }
            }
        }

        Button {
            id: toMy
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 20
            height: 100
            label: "connect to test"

            onButtonClick: {
                console.log("connect to test");
                connectTo("00:13:03:13:70:83");
            }
        }

        Button {
            id: toDevice
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 20
            height: 100
            label: "connect to device"

            onButtonClick: {
                console.log("connect to device");
                connectTo("98:D3:31:80:75:22");
            }
        }

        Button {
            id: toPc
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 20
            height: 100
            label: "connect to PC"

            onButtonClick: {
                console.log("connect to PC");
                connectTo("20:69:9D:1A:BA:DC");
            }
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 20
            height: 100
            label: "log file debug"

            onButtonClick: {
                notificationClient.logFile("abc");
            }
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 20
            height: 100
            label: "test function"

            onButtonClick: {
                notificationClient.testData("ppp qml");
            }
        }
    }
}
