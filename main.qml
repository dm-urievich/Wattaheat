import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

//ApplicationWindow {
Item {
    id: root
    visible: true
    property real current_temp: 25.0
    property bool notifiSent: false

    property real targetTemp: 65.0

    BtManager {
        id: btManager

        onDataReceived: {
            var flt = parseFloat(data);

            if (flt && flt > 20) {
                chartPage.newTemp(data);

                mainPage.currentTemp = low_pass_filter(flt);
                prediction.add_sample(mainPage.currentTemp);
                console.log("Input: "+ flt + "Filtered: "+ mainPage.currentTemp);

                if (mainPage.currentTemp >= targetTemp && !notifiSent) {
                    notificationClient.notification = "Time to put your white oolong tea to teapot!";
                    notifiSent = true;
                }

                if (mainPage.currentTemp < targetTemp - 20) {
                    notifiSent = false;
                }
            }
        }

        onBluetoothDiscovered: {
            chartPage.addBuletoothDevice(macAddr);
        }
    }

    function low_pass_filter(input_value) {
        var alpha = 0.4;
        current_temp = current_temp + (alpha * (input_value - current_temp));
        return Math.round(10 * current_temp) / 10;
    }

    Prediction {
        id: prediction

        targetTemp: root.targetTemp

        onEstimated_timeChanged: {
            var min = Math.floor(prediction.estimated_time / 60);
            var sec = prediction.estimated_time % 60;

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

            maxTemp: targetTemp

            estimatedTime: prediction.estimated_time
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
