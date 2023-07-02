// Import required libraries
#include <Arduino.h>
#include <WiFi.h>
#include <AsyncTCP.h>
#include <ESPAsyncWebServer.h>

#include <spartan-edge-esp32-boot.h>
#include "ESP32IniFile.h"
#include "sea_esp32_qspi.hpp"
#include "parson.h"

// initialize the spartan_edge_esp32_boot library
spartan_edge_esp32_boot esp32Cla;

bool led1_state = 0;
bool led2_state = 0;
uint16_t switches_state = 0xffff;

// const int ledPin[] = {A0, A3, A4, A5};//{36, 39, 32, 33}
// const char* ledPinny[] = {"A0", "A3", "A4", "A5"};//{36, 39, 32, 33}
unsigned long previousMillis = 0;        // will store last time LED was updated

const long interval = 3000;  

// Create AsyncWebServer object on port 80
AsyncWebServer server(80);
AsyncWebSocket ws("/ws");

uint8_t datapoints[16];

void sendPeriodicUpdate() {
  char json[256];
  String array;
  for (int i = 0; i < 15; i++) {
    array += String(datapoints[i]) + ", ";
  }
  array += String(datapoints[15]);

  sprintf(json, "{\"leds\":[%d, %d], \"rgb\": [11211331, 1081587], \"sw\": %d, \"fft\":[%s]}", led1_state, led2_state, switches_state, array.c_str());
  ws.textAll(json);
}

void handleSwitchesCmd(JSON_Object* obj) {
  uint16_t new_switches_value = (uint16_t)json_object_get_number(obj, "sw");
  switches_state = new_switches_value;
  Serial.print("Switches: ");
  Serial.println(switches_state, HEX);
}

void handleToggleCmd(JSON_Object* obj) {
  int led_index = (int)json_object_get_number(obj, "index");
  Serial.print("LED-");
  Serial.print(led_index+1);
  Serial.print(": ");
  if (led_index == 0) {
    led1_state = !led1_state;
    Serial.println(led1_state);
    digitalWrite(A4, led1_state);
  }
  else if (led_index == 1) {
    led2_state = !led2_state;
    Serial.println(led2_state);
    digitalWrite(A5, led2_state);
  }
}

void handleWebSocketMessage(void *arg, uint8_t *data, size_t len) {
  AwsFrameInfo *info = (AwsFrameInfo*)arg;
  if (info->final && info->index == 0 && info->len == len && info->opcode == WS_TEXT) {
    data[len] = 0;
    JSON_Value* raw = json_parse_string((const char*)data);
    JSON_Object* obj = json_value_get_object(raw);
    const char* command = json_object_get_string(obj, "command");
    if (strcmp(command, "switches") == 0) {
      handleSwitchesCmd(obj);
    }
    else if (strcmp(command, "toggle") == 0) {
      handleToggleCmd(obj);
    }
    json_value_free(raw);
  }
}

void onEvent(AsyncWebSocket *server, AsyncWebSocketClient *client, AwsEventType type,
             void *arg, uint8_t *data, size_t len) {
  switch (type) {
    case WS_EVT_CONNECT:
      Serial.printf("WebSocket client #%u connected from %s\n", client->id(), client->remoteIP().toString().c_str());
      break;
    case WS_EVT_DISCONNECT:
      Serial.printf("WebSocket client #%u disconnected\n", client->id());
      break;
    case WS_EVT_DATA:
      handleWebSocketMessage(arg, data, len);
      break;
    case WS_EVT_PONG:
    case WS_EVT_ERROR:
      break;
  }
}

void initWebSocket() {
  ws.onEvent(onEvent);
  server.addHandler(&ws);
}

void sendServerFile(AsyncWebServerRequest *request, const String& contentType, const char* filename, AwsTemplateProcessor callback=nullptr){
    File f = SD_MMC.open(filename);
    size_t f_size = f.size();
    uint8_t file_buffer[f_size+1];
    file_buffer[f_size] = 0;
    f.read(file_buffer, f_size);
    request->send_P(200, contentType, (const char*)file_buffer, callback);
}

String processor(const String& var){
  Serial.println(var);
  return String();
}

void setup(){
  const size_t bufferLen = 80;
  char ssid[bufferLen];
  char password[bufferLen];
  // Serial port for debugging purposes
  Serial.begin(115200);

  // uint8_t data1[2]={42,33};
  // uint8_t data2[2] = {0, 0};
  // Serial.begin(115200);
  // SeaTrans.begin();
  // SeaTrans.write(0, data1, 2);
  // SeaTrans.read(0, data2, 2);
  // Serial.printf("%d %d\r\n",data2[0],data2[1]);

  pinMode(A4, OUTPUT);
  pinMode(A5, OUTPUT);
  digitalWrite(A4, LOW);
  digitalWrite(A5, LOW);

  // initialization 
  esp32Cla.begin();
    // check the .ini file exist or not
  const char *filename = "/board_config.ini";
  IniFile ini(filename);
  if (!ini.open()) {
    Serial.print("Ini file ");
    Serial.print(filename);
    Serial.println(" does not exist");
    while (1);
    
  }
  Serial.println("Ini file exists");

  // check the .ini file valid or not
  if (!ini.validate(ssid, bufferLen)) {
    Serial.print("ini file ");
    Serial.print(ini.getFilename());
    Serial.print(" not valid: ");
    while(1);
  }

  // Fetch a value from a key which is present
  if (ini.getValue("WIFI_config", "ssid", ssid, bufferLen)) {
    Serial.print("section 'WIFI_config' has an entry 'ssid' with value ");
    Serial.println(ssid);
  }
  else {
    Serial.print("Could not read 'WIFI_config' from section 'ssid', error was ");
  }

  // Fetch a value from a key which is present
  if (ini.getValue("WIFI_config", "password", password, bufferLen)) {
    Serial.print("section 'WIFI_config' has an entry 'password' with value ");
    Serial.println(password);
  }
  else {
    Serial.print("Could not read 'WIFI_config' from section 'password', error was ");
  }

  // Connect to Wi-Fi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi..");
  }

  // Print ESP Local IP Address
  Serial.println(WiFi.localIP());

  initWebSocket();
  Serial.println("Initialized web socket");
  // Route for root / web page
  server.on("/", HTTP_GET, [](AsyncWebServerRequest *request){
    sendServerFile(request, "text/html", "/web/index.html", processor);
  });

  // Route for root / web page
  server.on("/script.js", HTTP_GET, [](AsyncWebServerRequest *request){
    sendServerFile(request, "*/*", "/web/script.js");
  });

  // Route for root / web page
  server.on("/style.css", HTTP_GET, [](AsyncWebServerRequest *request){
    sendServerFile(request, "text/css", "/web/style.css");
  });

  Serial.println("Starting server");
  // Start server
  server.begin();
}

void loop() {
  ws.cleanupClients();
  unsigned long currentMillis = millis();

  if (currentMillis - previousMillis >= interval) {

    // save the last time you blinked the LED
    previousMillis = currentMillis;
    for(int i = 0; i < 16; i++) {
      datapoints[i] = rand() % 15;
    }
    sendPeriodicUpdate();
  }
}