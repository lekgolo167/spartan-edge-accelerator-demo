function switchHandler(ch, num) {
    console.log(num)
    console.log(ch.checked)
}
var sws = document.getElementById("switches")
for (var i = 15; i >= 0; i--) {
    var html = `<label class="switch">
                <input onclick="switchHandler(this, ${i})" type="checkbox" checked>
                <span class="slider"></span>
                </label>`
    sws.insertAdjacentHTML('afterbegin', html)
}

var gram = []

var spectrogram = [{
    z: gram,
    type: 'heatmap'
}];


var x1 = ['L1', 'L2', 'L3', 'L4', 'L4', 'L5', 'L6', 'L8', 'L9', 'L10', 'L11', 'L12', 'L13', 'L14', 'L15', 'L16'];
var y1 = [1, 0, 0, 0, 1, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 2];
for (var i = 0; i < 100; i++) {

    gram.push(y1)
}

var layout = {
    bargap: 0.05,
    bargroupgap: 0.2,
    barmode: "overlay",
    title: "Sampled Results",
    xaxis: { title: "Value" },
    yaxis: { title: "Count", range: [0, 15] }
};

var trace1 = {
    x: x1,
    y: y1,
    name: 'control',
    histfunc: 'sum',
    marker: {
        color: "#0f8b8d",
        line: {
            color: "rgba(255, 100, 102, 1)",
            width: 1
        }
    },
    opacity: 0.5,
    type: "histogram"
};

var inverval_timer;
var data = [trace1];

//Time in milliseconds [1 second = 1000 milliseconds ]    
inverval_timer = setInterval(function() {
    gram.shift()
    var d = []
    for (var i = 0; i < 16; i++) {
        d.push(Math.random() * 15)
    }
    gram.push(d)
    trace1.y = d
    var data = [trace1];
    Plotly.newPlot('spectrogram', spectrogram);
    Plotly.newPlot('fft-plot', data, layout);

}, 1000);

Plotly.newPlot('spectrogram', spectrogram);

Plotly.newPlot('fft-plot', data, layout);

var gateway = `ws://${window.location.hostname}/ws`;
var websocket;
window.addEventListener('load', onLoad);

function initWebSocket() {
    console.log('Trying to open a WebSocket connection...');
    websocket = new WebSocket(gateway);
    websocket.onopen = onOpen;
    websocket.onclose = onClose;
    websocket.onmessage = onMessage;
}

function onOpen(event) {
    console.log('Connection opened');
}

function onClose(event) {
    console.log('Connection closed');
    //setTimeout(initWebSocket, 2000);
}

function onMessage(event) {
    var state;
    console.log(event.data)
    var json = JSON.parse(event.data);
    if (json.ledState == "1") {
        state = "ON";
        document.getElementById('state').innerHTML = state;
    } else if (json.ledState == "0") {
        state = "OFF";
        document.getElementById('state').innerHTML = state;
    }

    // plotly
    trace1.y = [json.x0, json.x1, json.x2, json.x3, json.x4, json.x5, json.x6, json.x7, json.x8, json.x9, json.x10, json.x11, json.x12, json.x13, json.x14, json.x15]
    var data = [trace1];

    Plotly.newPlot('fft-plot', data, layout);
}

function onLoad(event) {
    initWebSocket();
    initButton();
}

function initButton() {
    document.getElementById('button').addEventListener('click', toggle);
}

function toggle() {
    console.log("button pressed")
    websocket.send('toggle');
}