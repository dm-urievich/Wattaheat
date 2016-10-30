import QtQuick 2.0

import "regression.js" as MathFunction

Item {
    property real targetTemp: 0//100.0 // Target temperature, in degrees
    property int nFitPoints: 20 //10 // Number of points for fitting
    property var temp_arr: []
    property var prediction_time: 1000
    property var estimated_time: 600

    property var prevTime: new Date()

    function reset() {
        estimated_time = 600;
        temp_arr = [];
    }

    function add_sample(temp) {
        var currentTime = new Date()
        var delta = currentTime.getTime() - prevTime.getTime();
//        prevTime = currentTime;

        temp_arr.push([delta, temp]);
        if (temp_arr.length > nFitPoints) {
            temp_arr.shift();
            var result = MathFunction.regression('linear', temp_arr);
            var slope = result.equation[0];
            var yIntercept = result.equation[1];
            prediction_time = (targetTemp - yIntercept) / slope;
            var estTime = prediction_time - delta;
            estimated_time = estTime < 0 ? 0 : Math.round((estTime) / 1000);
        }

        console.log("prediction " + prediction_time)
        console.log(estimated_time);
        console.log("temp " + targetTemp);
    }
}
