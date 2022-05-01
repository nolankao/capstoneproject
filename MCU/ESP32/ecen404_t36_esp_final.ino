
#include <WiFi.h>
#include <WiFiAP.h>
#include <WiFiClient.h>
#include <ESP32DMASPISlave.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

ESP32DMASPI::Slave slave;
static const uint32_t BUFFER_SIZE = 32;
uint8_t* spi_slave_tx_buf;
uint8_t* spi_slave_rx_buf;
uint16_t spi_buff[4];
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

  // VSPI = CS: 5, CLK: 18, MOSI: 23, MISO: 19
  slave.begin(VSPI);

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
  BLEDevice::init("ECEN403_team36_proto");

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
      
     delay(100);
    // do something here with received data
      
      slave.pop();
    }
  

  //wifi
  WiFiClient client = server.available(); 
    if (client) {                           
    Serial.println("New Client.");        
    String currentLine = "";              
    while (client.connected()) {  
      if (client.available()) {           
        char c = client.read();        
        Serial.write(c);                  
        if (c == '\n') {                  
           // code for check stored buffers on wifi communication
           client.printf("example buffer 1: %x%x%x%x<br>",spi_slave_rx_buf[3],
           spi_slave_rx_buf[2],spi_slave_rx_buf[1],spi_slave_rx_buf[0]);
           client.printf("example buffer 2: %x%x%x%x<br>",spi_slave_rx_buf[7],
           spi_slave_rx_buf[6],spi_slave_rx_buf[5],spi_slave_rx_buf[4]);
           client.printf("example buffer 3: %x%x%x%x<br>",spi_slave_rx_buf[11],
           spi_slave_rx_buf[10],spi_slave_rx_buf[9],spi_slave_rx_buf[8]);
           client.printf("example buffer 4: %x%x%x%x<br>",spi_slave_rx_buf[15],
           spi_slave_rx_buf[14],spi_slave_rx_buf[13],spi_slave_rx_buf[12]);

           
           memset(spi_slave_tx_buf, 0, sizeof(spi_slave_tx_buf)); // reset buffer for deleting garbage data 
    
         break; // break out of the while loop:
          } else { 
            currentLine = "";
          }
        } else if (c != '\r') {
          currentLine += c;     
        }
        }
    }
    client.stop();
    Serial.println("Client Disconnected.");
    } // wifi if 끝

// bluetooth

    if (deviceConnected) {
     // for(unsigned int i=0; i <10; i++){
          pCharacteristic->setValue((uint8_t*)&spi_slave_rx_buf[0],32);
          pCharacteristic->notify();
 
   // }
    }
    // disconnecting
    if (!deviceConnected && oldDeviceConnected) {
        delay(500); // give the bluetooth stack the chance to get things ready
        pServer->startAdvertising(); // restart advertising
        Serial.println("start advertising");
        oldDeviceConnected = deviceConnected;
    }
    // connecting again
    if (deviceConnected && !oldDeviceConnected) {
        oldDeviceConnected = deviceConnected;
  }
}
}
