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
    property string estimatedMin: "00"
    property string estimatedSec: "00"

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
            id: progressBar
            width: Screen.width / 1.2
            height: width
            anchors.horizontalCenter: parent.horizontalCenter

            currentValue: currentTemp
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
