import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

//ApplicationWindow {
Item {
    visible: true
//    width: 640
//    height: 480
//    title: qsTr("TeamCook")

    SwipeView {
        id: swipeView
        anchors.fill: parent
//        currentIndex: tabBar.currentIndex

        MainPage {

        }

//        ChartPage {

//        }
    }

//    footer: TabBar {
//        id: tabBar
//        currentIndex: swipeView.currentIndex
//        TabButton {
//            text: qsTr("First")
//        }
//        TabButton {
//            text: qsTr("Second")
//        }
//    }
}
