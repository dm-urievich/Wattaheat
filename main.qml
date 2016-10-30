import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

//ApplicationWindow {
Item {
    visible: true

    BtManager {
        id: btManager

        onDataReceived: {
            var flt = parseFloat(data);

            if (flt) {
                chartPage.newTemp(data);

                mainPage.currentTemp = flt;
                prediction.add_sample(flt);
            }
        }

        onBluetoothDiscovered: {
            chartPage.addBuletoothDevice(macAddr);
        }
    }

    Prediction {
        id: prediction

        targetTemp: mainPage.maxTemp

        onEstimated_timeChanged: {
            var min = Math.floor(prediction.estimated_time / 60);
            var sec = prediction.estimated_time % 60;
            sec = sec < 0 ? 0 : sec;
            min = sec < 0 ? 0 : min;

            if (sec < 10) {
                mainPage.estimatedSec = "0" + sec.toString();
            }
            else {
                mainPage.estimatedSec = sec.toString();
            }

            if (min < 10) {
                mainPage.estimatedMin = "0" + min.toString();
            }
            else {
                mainPage.estimatedMin = min.toString();
            }
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
//        currentIndex: tabBar.currentIndex

        MainPage {
            id: mainPage
        }

        ChartPage {
            id: chartPage
            btStatus: btManager.debugText

            onConnectTo: {
                btManager.setBtAddr(address);
            }
        }
    }
}
