Qt.include("regression.js")

var targetTemp = 100.0; // Target temperature, in degrees
var nFitPoints = 10; // Number of points for fitting
var temp_arr = [];
var prediction_time = 1000;
var estimated_time = 1000;

function add_sample(temp, time) {
    temp_arr.push([time, temp]);
    if (temp_arr.length > nFitPoints) {
        temp_arr.shift();
        var result = regression('linear', temp_arr);
        var slope = result.equation[0];
        var yIntercept = result.equation[1];
        prediction_time = (targetTemp - yIntercept) / slope;
        estimated_time = prediction_time - time;
    }



    console.log(estimated_time);
    console.log(temp);
    //console.log(temp_arr.length);
}

function get_prediction_time() {
    return prediction_time;
}
