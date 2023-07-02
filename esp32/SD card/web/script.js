var gateway = `ws://${window.location.hostname}:5000/ws`;
//var gateway = `ws://${window.location.hostname}/ws`;
var websocket = new WebSocket(gateway);

websocket.onopen = function() {
    console.log('Connection opened');
}

websocket.onclose = function() {
    console.log('Connection closed');
    //setTimeout(initWebSocket, 2000);
}

var switches = 0xFFFF;

websocket.onmessage = function(event) {
    console.log(event.data)
    var json = JSON.parse(event.data);

    json.leds.forEach(function(value, index) {
        document.getElementById(`led${index+1}-state`).innerHTML = value == 1 ? 'ON' : 'OFF';
    });
    // json.rgb.forEach(function(value, index) {
    //     document.getElementById(`rgb${index}-state`).innerHTML = value > 0 ? 'ON' : 'OFF';
    // });
    switches = json.sw;
    for (var i = 15; i >= 0; i--) {
        sw = document.getElementById(`sw${i}`);
        sw.checked = (switches >> i) & 1 != 0 ? true : false;
    }
    // plotly
    trace1.y = json.fft;
    var data = [trace1];
    gram.shift();
    gram.push(json.fft);
    Plotly.newPlot('fft-plot', data, layout);
    Plotly.newPlot('spectrogram', spectrogram);
}

function onLoad(event) {
    initButton();
}

window.addEventListener('load', onLoad);

// BUTTONS
function initButton() {
    document.getElementById('button1').addEventListener('click', () => { toggle(0) });
    document.getElementById('button2').addEventListener('click', () => { toggle(1) });
}

function toggle(led) {
    var cmd = {
        command: 'toggle',
        index: led,
    };
    websocket.send(JSON.stringify(cmd));
}


function switchHandler(ch, num) {
    if (ch.checked) {
        switches |= (1 << num);
    } else {
        switches &= ~(1 << num);
    }
    var cmd = {
        command: 'switches',
        sw: switches,
    };
    websocket.send(JSON.stringify(cmd));
}

var sws = document.getElementById("switches")
for (var i = 15; i >= 0; i--) {
    var html = `<label class="switch">
                <input id="sw${i}" onclick="switchHandler(this, ${i})" type="checkbox" checked>
                <span class="slider"></span>
                </label>`
    sws.insertAdjacentHTML('afterbegin', html)
}


// GRAPHS
var gram = []

var spectrogram = [{
    z: gram,
    type: 'heatmap'
}];

var x1 = ['L1', 'L2', 'L4', 'L4', 'L5', 'L6', 'L8', 'L9', 'L10', 'L11', 'L12', 'L13', 'L14', 'L15', 'L16']
var y1 = [0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0];
for (var i = 0; i < 100; i++) {
    gram.push(y1);
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