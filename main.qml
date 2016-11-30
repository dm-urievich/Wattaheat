import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import TeamCook 1.0

Item {
    id: root
    visible: true
    property real current_temp: 25.0
    property bool notifiSent: false

    property real targetTemp: 55.0
    property real preditionTime: 9999

    property var tempArray: []

    NotificationClient {
        id: notificationClient
    }

    BtManager {
        id: btManager

        onDataReceived: {
            console.log(data)
            var gg = JSON.parse(data);

            var flt = Math.round((gg.Tobj * 0.02 - 273) * 10) / 10;

            console.log(flt)

            if (flt && flt > 10) {
                chartPage.newTemp(flt);

                mainPage.currentTemp = low_pass_filter(flt);

                tempArray.push(mainPage.currentTemp);

                if (tempArray.length > 30) {
                    console.log("target time " + targetTemp);
                    preditionTime = notificationClient.prediction(tempArray, targetTemp);
                    console.log("prediction time " + preditionTime);

                    if (preditionTime != 9999) {
                        mainPage.estimatedTime = preditionTime - tempArray.length;
                        chartPage.predictedTime = preditionTime;

                        var min = Math.floor(mainPage.estimatedTime / 60);
                        var sec = mainPage.estimatedTime % 60;
                        if (sec < 0) {
                            sec = 0;
                        }

                        if (min < 0) {
                            min = 0;
                        }

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

//                prediction.add_sample(mainPage.currentTemp);
                console.log("Input: "+ flt + "Filtered: "+ mainPage.currentTemp);

                if (mainPage.currentTemp >= targetTemp && !notifiSent) {
                    notificationClient.notification = "Time to pour white oolung tea!";
                    notifiSent = true;
                }

                if (mainPage.currentTemp < targetTemp - 20) {
                    notifiSent = false;
                }
            }
        }

        onBluetoothDiscovered: {
            developerPage.addBuletoothDevice(macAddr);
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

//            estimatedTime: prediction.estimated_time

            onReset: {
                prediction.reset();
                notifiSent = false;
                current_temp = 25.0;
                tempArray = [];
                chartPage.clearCharts();
            }

            onSetTargetTemp: {
                targetTemp = temp;
                notifiSent = false;
                console.log("new target temp " + targetTemp);
            }
        }

        ChartPage {
            id: chartPage
            targetTemp: root.targetTemp
        }

        DeveloperPage {
            id: developerPage
            btStatus: btManager.debugText

            onConnectTo: {
                btManager.setBtAddr(address);
            }
        }
    }
}
