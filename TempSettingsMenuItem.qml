import QtQuick 2.0
import QtQuick.Controls 2.0 as Ctrl
import QtQuick.Window 2.2

Ctrl.MenuItem {
    id: menuItem
    height: Screen.height / 10
    width: parent.width

    property real temp: 25

    Rectangle {
        anchors.fill: parent
        color: "#99E265"
    }
    Text {
        anchors.centerIn: parent
        text: menuItem.temp.toString() + " °C"
        color: "#FFFFFF"
        font.pointSize: 22
    }
    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height / 10
        color: "#E0F6D0"
    }
}
