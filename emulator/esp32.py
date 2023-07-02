from flask import Flask, current_app
from flask_sock import Sock, Server
import json
import random
import time
import threading

periodic_data = {
    "leds": [1, 0],
    "rgb": [11211331, 1081587],
    "sw": 43981,
    "fft": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
}

app = Flask(__name__)
app.static_folder = '../esp32/SD card/web/'
app.config['SECRET_KEY'] = 'your_secret_key'
sock = Sock(app)

@app.route('/style.css')
def style():
    return current_app.send_static_file('style.css')

@app.route('/script.js')
def script():
    return current_app.send_static_file('script.js')

@app.route('/')
def index():
    return current_app.send_static_file('index.html')

def send_periodic(ws:Server):
    while ws.connected:
        periodic_data['fft'] = [random.randint(0, 15) for _ in range(16)]
        ws.send(json.dumps(periodic_data))
        time.sleep(1)

@sock.route('/ws')
def ws(ws:Server):
    if ws.connected:
        print('Connected!\n Starting periodic notices')
        t = threading.Thread(target=send_periodic, args=[ws])
        t.start()
    while ws.connected:
        message = ws.receive()
        print('Received message:', message)
        cmd = json.loads(message)
        if cmd['command'] == 'toggle':
            periodic_data['leds'][cmd['index']] = not periodic_data['leds'][cmd['index']]
        elif cmd['command'] == 'rgb':
            periodic_data['rgb'][cmd['index']] = cmd.value
        elif cmd['command'] == 'switches':
            periodic_data['sw'] = cmd['sw']


if __name__ == '__main__':
    app.run(host='192.168.0.225')
