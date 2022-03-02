// Import required libraries
#include <WiFi.h>
#include <AsyncTCP.h>
#include <ESPAsyncWebServer.h>

#include <spartan-edge-esp32-boot.h>
#include "ESP32IniFile.h"

// initialize the spartan_edge_esp32_boot library
spartan_edge_esp32_boot esp32Cla;

bool ledState = 0;
int counter = 2;
bool connected = false;
const int ledPin = A5;
unsigned long previousMillis = 0;        // will store last time LED was updated

// constants won't change:
const long interval = 3000;  

// Create AsyncWebServer object on port 80
AsyncWebServer server(80);
AsyncWebSocket ws("/ws");

uint8_t datapoints[16];

void sendCounter() {
  String json = "{\n\"ledState\": \""+String(ledState) + "\",\n";
  for (int i = 0; i < 15; i++) {
    json += "\"x" + String(i) + "\": \"" + String(datapoints[i]) + "\",\n";
  }
      json += "\"x" + String(15) + "\": \"" + String(datapoints[15]) + "\"\n}";
  ws.textAll(String(json));
}

void notifyClients() {
  ws.textAll(String(ledState));
}

void handleWebSocketMessage(void *arg, uint8_t *data, size_t len) {
  AwsFrameInfo *info = (AwsFrameInfo*)arg;
  if (info->final && info->index == 0 && info->len == len && info->opcode == WS_TEXT) {
    data[len] = 0;
    if (strcmp((char*)data, "toggle") == 0) {
      ledState = !ledState;
      Serial.println("Toggling LED");
      notifyClients();
    }
  }
}

void onEvent(AsyncWebSocket *server, AsyncWebSocketClient *client, AwsEventType type,
             void *arg, uint8_t *data, size_t len) {
  switch (type) {
    case WS_EVT_CONNECT:
      connected = true;
      Serial.printf("WebSocket client #%u connected from %s\n", client->id(), client->remoteIP().toString().c_str());
      break;
    case WS_EVT_DISCONNECT:
      connected = false;
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

String processor(const String& var){
  Serial.println(var);
  if(var == "STATE"){
    if (ledState){
      return "ON";
    }
    else{
      return "OFF";
    }
  }
  return String();
}

void sendServerFile(AsyncWebServerRequest *request, const String& contentType, const char* filename, AwsTemplateProcessor callback=nullptr){
    File f = SD_MMC.open(filename);
    size_t f_size = f.size();
    uint8_t file_buffer[f_size+1];
    file_buffer[f_size] = 0;
    f.read(file_buffer, f_size);
    request->send_P(200, contentType, (const char*)file_buffer, callback);
}

void setup(){
  const size_t bufferLen = 80;
  char ssid[bufferLen];
  char password[bufferLen];
  // Serial port for debugging purposes
  Serial.begin(115200);
  delay(2000);

  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);
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

  // Start server
  server.begin();
}

void loop() {
  ws.cleanupClients();
  digitalWrite(ledPin, ledState);
    unsigned long currentMillis = millis();

  if (currentMillis - previousMillis >= interval) {
    // save the last time you blinked the LED
    previousMillis = currentMillis;
    for(int i = 0; i < 16; i++) {
      datapoints[i] = rand() % 15;
    }
    sendCounter();
  }
}