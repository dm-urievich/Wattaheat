/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the QtBluetooth module.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2
import QtBluetooth 5.3

Item {
    id: top

    property string remoteDeviceName: ""
    property bool serviceFound: false

    signal dataReceived(string data)

    BluetoothService {
        id: btService

        serviceProtocol: BluetoothService.RfcommProtocol

        onDeviceNameChanged: {
            console.log("bt sevice " + deviceName);
        }

        onDetailsChanged: {
            console.log("name " + btService.deviceName)

            socket.setService(btService)
        }

        serviceUuid: "00001101-0000-1000-8000-00805F9B34FB"
    }

    BluetoothDiscoveryModel {
        id: btModel
        running: true
        discoveryMode: BluetoothDiscoveryModel.DeviceDiscovery
        onRunningChanged : {
            console.log("bt model running " + running)
        }

        onErrorChanged: {
            if (error != BluetoothDiscoveryModel.NoError && !btModel.running) {
                debugText.text = "Discovery failed.\nPlease ensure Bluetooth is available."
            }
        }

        onDeviceDiscovered: {
            console.log(device);

            if (device == "00:13:03:13:70:83") {
                console.log("set address to service")
                btService.deviceAddress = device;
            }
        }

        onServiceDiscovered: {
            if (serviceFound)
                return
            serviceFound = true
            console.log("Found new service " + service.deviceAddress + " " + service.deviceName + " " + service.serviceName);
            debugText.text = "Connecting to server...";
            remoteDeviceName = service.deviceName
            socket.setService(service)
        }
    }

    BluetoothSocket {
        id: socket
        connected: true

        onSocketStateChanged: {
            console.log("Connected to server")
            debugText.text = "Connected to server";
            top.state = "chatActive"
        }

        onStringDataChanged: {
            console.log("Received data: " );
//            var str = JSON.stringify(stringData);
            var str = stringData
//            console.log(str)
//            str = str.substring(0, data.indexOf('\n'))
//            var str = stringData.toString();

//            console.log("len " + str.length)
            console.log(str)


//            for (var i = 0; i < str.length; i++) {
//                console.log(str[i])
//            }

            dataReceived(str)
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "yellow"
        opacity: 0.2
    }

    Text {
        id: debugText
        anchors.fill: parent
    }

    Button {
        anchors.right: parent.right
        width: 30
        height: 30
        label: "tt"

        property int tstData: 0

        onButtonClick: {
            dataReceived(tstData.toString());
            tstData = tstData + 1
        }
    }
}
