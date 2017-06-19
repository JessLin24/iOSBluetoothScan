# iOSBluetoothScan
Bluetooth scan iOS app for Walking Bus project.

Notes:
- background scanning does not work.
- All information is printed on the console, not the actual app.

All Walking Bus project SensorTags have the name "WalkingBus" Look at public void onLeScan(final BluetoothDevice device, int rssi, byte[] scanRecord) for examples how to extract data.

Extract manufacturer specific data from scanRecord
Use TI manufacturer ID of 0d00 or integer value 13 to get manufacturer specific data
Manufacturer Specific Data Format: 2 bytes manufacturer ID + 6 bytes MAC address + 1 byte battery level
