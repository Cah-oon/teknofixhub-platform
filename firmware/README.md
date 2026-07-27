# TeknoFixHub Firmware

Firmware untuk IoT devices dan hardware yang terintegrasi dengan platform TeknoFixHub.

## 📋 Supported Devices

- Arduino
- ESP8266
- ESP32
- Raspberry Pi
- Custom IoT devices

## 📦 Firmware Versions

### Latest
- Version: 2.1.0
- Release: 2024-01-15
- Status: Stable

## 🚀 Installation

### Arduino
1. Upload firmware ke Arduino menggunakan Arduino IDE
2. Configure WiFi credentials
3. Configure API endpoint
4. Restart device

### ESP8266/ESP32
1. Gunakan esptool untuk flash firmware
2. Configure WiFi & API endpoint via web interface
3. Device akan auto-connect

## 📡 API Integration

Devices akan mengirim data ke API endpoint:
```
POST /api/devices/data
Content-Type: application/json

{
  "device_id": "ESP32_001",
  "sensor_data": {
    "temperature": 25.5,
    "humidity": 60,
    "light": 800
  },
  "timestamp": "2024-01-15T10:30:00Z"
}
```

## 🔐 Security

- Device authentication via token
- HTTPS untuk data transmission
- Data encryption
- Regular security updates

## 📝 Documentation

- [Arduino Setup](./arduino/README.md)
- [ESP8266 Setup](./esp8266/README.md)
- [API Reference](./API.md)

## 📊 OTA Updates

Firmware support Over-The-Air (OTA) updates untuk easy deployment.

Lihat folder untuk firmware source code dan dokumentasi.
