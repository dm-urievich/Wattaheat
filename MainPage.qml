import QtQuick.Controls 2.0
import QtQuick 2.2
import QtCharts 2.0

Page {
    id: root

    property var tempData: ["aa", "bb", "cc"]

    Column {
        anchors.fill: parent
        spacing: 5

        BtManager {
            id: btManager
            anchors.horizontalCenter: parent.horizontalCenter
            height: 100
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

                SplineSeries {
                    name: "SplineSeries"
                    XYPoint { x: 0; y: 0.0 }
                    XYPoint { x: 1.1; y: 3.2 }
                    XYPoint { x: 1.9; y: 2.4 }
                    XYPoint { x: 2.1; y: 2.1 }
                    XYPoint { x: 2.9; y: 2.6 }
                    XYPoint { x: 3.4; y: 2.3 }
                    XYPoint { x: 4.1; y: 3.1 }
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


        ListView {
            id: tempDataView
            width: 100
            anchors.horizontalCenter: parent.horizontalCenter
            height: 400
            model: tempData
            clip: true
            delegate: Component {
                Text {
                    font.pointSize: 14
                    text: modelData
                }
            }
        }
    }



    Component.onCompleted: {
        console.log("aaa = " + parseFloat("3.6"));
    }

/*
    Label {
        text: qsTr("First page")
        anchors.centerIn: parent
    }
    */
}
