import QtQuick.Controls 2.0 as Ctrl
import QtQuick 2.2
import QtCharts 2.0
import QtQuick.Window 2.2

Ctrl.Page {
    id: root

    property var tempData: []
    property string secondaryTextColor: "#A8A8A8"

    property real currentTemp: 42.0
    property alias maxTemp: progressBar.maximumValue
//    property alias estimatedTime: progressBar.text
    property string estimatedMin: "10"
    property string estimatedSec: "00"
    property int estimatedTime: 600

    background: Rectangle {
        color: "#000000"
    }

    Timer {
        interval: 100
        repeat: true
        running: true

        onTriggered: {
            if (estimatedTime < 600) {
                var val = progressBar.currentValue + (progressBar.maximumValue - progressBar.currentValue) / (1000 * estimatedTime / interval)
                if (val < progressBar.maximumValue) {
                    progressBar.currentValue = val;
                }
                else {
                    progressBar.currentValue = progressBar.maximumValue;
                }
            }
            else {
                progressBar.currentValue = 0;
            }
        }
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
            id: progressBar
            width: Screen.width / 1.2
            height: width
            anchors.horizontalCenter: parent.horizontalCenter

            currentValue: 0
            text: estimatedMin + ":" + estimatedSec
        }

        Item {
            height: Screen.height / 28
            width: parent.width
        }

        Text {
            id: currentTempText
            anchors.horizontalCenter: parent.horizontalCenter
            color: secondaryTextColor
            font.pointSize: 60
            text: currentTemp + " °C"
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
    }
}
