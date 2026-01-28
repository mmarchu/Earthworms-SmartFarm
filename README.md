## System Capabilities

The Earthworms SmartFarm Mobile Application provides a mobile interface for monitoring environmental conditions and controlling the water pump in an automated earthworm farming system. The application functions as a client that displays sensor data and sends control commands to the system through MQTT.

### Real-time Environmental Data Display

The application displays environmental data collected from sensors in real time. This includes temperature and soil moisture values transmitted from the IoT gateway. The mobile application is responsible solely for data visualization and does not perform any data processing or analysis.

- Displays real-time temperature data
- Displays real-time soil moisture data
- Receives sensor data via MQTT

### Water Pump Control

The application allows users to control the water pump remotely through two operating modes.

**Auto Mode**
- Default operating mode of the system
- Pump operation is fully controlled by system logic
- Users cannot modify control logic or threshold values

**Manual Mode**
- Allows users to manually turn the water pump on or off
- Control commands are sent from the mobile application to the system via MQTT

### System Communication

The mobile application communicates with the backend system using the MQTT protocol. It subscribes to sensor data topics to receive environmental information and publishes control commands to control the water pump.

### Application Scope

- The application displays only temperature and soil moisture data
- No system status or device status is displayed in the application
- No in-app notifications are provided
- All alert and notification messages are handled externally through LINE Messaging API
- The application does not perform AI processing

<h2>Project Contributors</h2>
<ul>
  <li>Ammar Chuapoodee</li>
    <span>Role: Flutter Mobile Application Development</span>
  <li>Bovornpol Jiturai</li>
   <span>Role: <a href=https://github.com/thirds1000rr/SmatFarm_nodejs_sql>Backend Development</a> & <a href=https://github.com/thirds1000rr/RasberryPi5_MiFlora.git>IoT Integration</a></span>
  
</ul>
