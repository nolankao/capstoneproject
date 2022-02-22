#include <WiFi.h>
#include <WiFiAP.h>
#include <WiFiClient.h>
#include <ESP32DMASPISlave.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
/*설명
   슬레이브 rx buffer 를 serial monitor 에 printf 해서
   확인한다
*/
ESP32DMASPI::Slave slave;
static const uint32_t BUFFER_SIZE = 8192;
uint8_t* spi_slave_tx_buf;
uint8_t* spi_slave_rx_buf;
uint16_t spi_buff[16];

//wifi
const char *ssid = "ECEN403_team36";
const char *password = "12345678";
WiFiServer server(80);

// bluetooth
BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

// set callback function for bluetooth
class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
      BLEDevice::startAdvertising();
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
    }
};

//
void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  // start here setup for SPI slave
  // to use DMA buffer, use these methods to allocate buffer
  spi_slave_tx_buf = slave.allocDMABuffer(BUFFER_SIZE);
  spi_slave_rx_buf = slave.allocDMABuffer(BUFFER_SIZE);

  slave.setDataMode(SPI_MODE3);
  slave.setMaxTransferSize(BUFFER_SIZE);
  slave.setDMAChannel(2); // 1 or 2 only
  slave.setQueueSize(1); // transaction queue size

  // begin() after setting
  // HSPI = CS: 15, CLK: 14, MOSI: 13, MISO: 12
  // VSPI = CS: 5, CLK: 18, MOSI: 23, MISO: 19
  slave.begin(VSPI);

  /* 중간 설명
      slave 에서 버퍼사이즈를  -> 16으로 해서 rx 버퍼로 받는다
      그래서 -> 뭐 ex) int sampleBuff = spi_slave_rx_buf
      하고 loop (for size_t i = 0; i < 16; ++i){ spi_slave_rx_buf -> bt or wifi -> tx
  */
  // start here setup for wifi
  // Serial.println();
  // Serial.println("Configuring access point...");
  WiFi.softAP(ssid, password);
  IPAddress myIP = WiFi.softAPIP();
  // Serial.print("AP IP address: ");
  Serial.println(myIP);
  server.begin();
  // Serial.println("Server started");

  // start here setup for bluetooth
    // Create the BLE Device
  BLEDevice::init("ECEN403_team36");

  // Create the BLE Server
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Create the BLE Service
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Create a BLE Characteristic
  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_READ   |
                      BLECharacteristic::PROPERTY_WRITE  |
                      BLECharacteristic::PROPERTY_NOTIFY |
                      BLECharacteristic::PROPERTY_INDICATE
                    );

  // https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.descriptor.gatt.client_characteristic_configuration.xml
  // Create a BLE Descriptor
  pCharacteristic->addDescriptor(new BLE2902());

  // Start the service
  pService->start();

  // Start advertising
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x0);  // set value to 0x00 to not advertise this parameter
  BLEDevice::startAdvertising();
  Serial.println("Waiting a client connection to notify...");
}

void loop() {
while(1){
    // set buffer (reply to master) data here
    // if there is no transaction in queue, add transaction
    if (slave.remained() == 0)
    slave.queue(spi_slave_rx_buf, spi_slave_tx_buf, BUFFER_SIZE);
    

    // if transaction has completed from master,
    // available() returns size of results of transaction,
    // and buffer is automatically updated
    while (slave.available()) {
    //  delay(50);
    // do something here with received data
    //*****for (size_t i = 0; i < BUFFER_SIZE; ++i) 주석 테스트용
      Serial.println(spi_slave_rx_buf[0], HEX);
      Serial.println(spi_slave_rx_buf[1]); 
      Serial.println(spi_slave_rx_buf[2]); 
      Serial.println(spi_slave_rx_buf[3]); 
      Serial.println(spi_slave_rx_buf[4]); 
      Serial.println(spi_slave_rx_buf[5]); 
      Serial.println(spi_slave_rx_buf[6]); 
      Serial.println(spi_slave_rx_buf[7]); 
      Serial.println(spi_slave_rx_buf[8]); 
      Serial.println(spi_slave_rx_buf[9]); 
      Serial.println(spi_slave_rx_buf[10]); 
      Serial.println(spi_slave_rx_buf[11]); 
      Serial.println(spi_slave_rx_buf[12]); 
      Serial.println(spi_slave_rx_buf[13]); 
      Serial.println(spi_slave_rx_buf[14]); 
      Serial.println(spi_slave_rx_buf[15]); /// test slave done or not
      printf("\n");
      
      slave.pop();
    }
  

  //wifi
  WiFiClient client = server.available(); // 접속 감지
    if (client) {                           // 만약 사용자가 감지되면,
    Serial.println("New Client.");        // 시리얼 포트에 메시지 출력
    String currentLine = "";              // 클라이언트에서 들어오는 데이터를 저장할 문자열 만듦
    while (client.connected()) {          // 사용자가 연결되어 있는 동안 무한 루프
      if (client.available()) {           // 만약 클라이언트에서 읽을 바이트가 있으면,
        char c = client.read();           // 그 바이트를 읽고,
        Serial.write(c);                  // 그 읽은 바이트를 시리얼 모니터에 출력해줌.
        if (c == '\n') {                  // 바이트가 줄 바꿈 문자일 경우

          // 현재 행이 비어 있는 경우, 두 개의 새 행 문자를 연속해서 입력
          // 클라이언트 HTTP 요청의 끝인 경우, 응답을 보냄
          if (currentLine.length() == 0) {
            // HTTP 헤더는 항상 응답 코드(예: HTTP/1.1 200 확인)로 시작함
            //고객이 무엇이 올지 알 수 있도록 컨텐츠 유형을 선택한 후 다음 빈 줄:
            client.println("HTTP/1.1 200 OK");
            client.println("Content-type:text/html");
            client.println();

            // HTTP 응답의 내용은 헤더를 따른다:
           // ****for(size_t i = 0; i < 16 ; ++i){  주석 테스트용
           client.printf("example buffer 1: %x%x%x%x<br>",spi_slave_rx_buf[3],
           spi_slave_rx_buf[2],spi_slave_rx_buf[1],spi_slave_rx_buf[0]);
           client.printf("example buffer 2: %x%x%x%x<br>",spi_slave_rx_buf[7],
           spi_slave_rx_buf[6],spi_slave_rx_buf[5],spi_slave_rx_buf[4]);
           client.printf("example buffer 3: %x%x%x%x<br>",spi_slave_rx_buf[11],
           spi_slave_rx_buf[10],spi_slave_rx_buf[9],spi_slave_rx_buf[8]);
           client.printf("example buffer 4: %x%x%x%x<br>",spi_slave_rx_buf[15],
           spi_slave_rx_buf[14],spi_slave_rx_buf[13],spi_slave_rx_buf[12]);
           memset(spi_slave_tx_buf, 0, sizeof(spi_slave_tx_buf)); // reset buffer for deleting garbage data
           if (deviceConnected) {
          pCharacteristic->setValue((uint8_t*)spi_slave_rx_buf, 16);
          pCharacteristic->notify();
          delay(10); // bluetooth stack will go into congestion, if too many packets are sent, in 6 hours test i was able to go as low as 3ms
          }
    // disconnecting
    if (!deviceConnected && oldDeviceConnected) {
        delay(500); // give the bluetooth stack the chance to get things ready
        pServer->startAdvertising(); // restart advertising
        Serial.println("start advertising");
        oldDeviceConnected = deviceConnected;
    }
    // connecting
    if (deviceConnected && !oldDeviceConnected) {
        // do stuff here on connecting
        oldDeviceConnected = deviceConnected;
  }
            break; // break out of the while loop:
          } else {    // 새 회선이 있으면 current line 삭제:
            currentLine = "";
          }
        } else if (c != '\r') {  // 리턴 문자 말고 다른 것이 있으면
          currentLine += c;      // currentLine의 끝에 추가함
        }
        }
    }
    client.stop();
    Serial.println("Client Disconnected.");
    } // wifi if 끝

// bluetooth
// notify changed value

}
}
