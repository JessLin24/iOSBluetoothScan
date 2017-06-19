//
//  ViewController.swift
//  iOSBluetoothScan
//
//  Created by Guest User on 2/23/17.
//  Copyright © 2017 walkingbus. All rights reserved.
//

import CoreBluetooth
import UIKit

class ViewController: UIViewController {
    var centralManager: CBCentralManager?
    var peripherals = Array<CBPeripheral>()
    var expectedTags = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Initialise CoreBluetooth Central Manager
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        //expectedTags.append("CB4C2E61-FEF3-47FF-8AEC-67A9B883016C")
        expectedTags.append("WalkingBus")
    }
}

extension ViewController: CBCentralManagerDelegate {
    func startScanning(){
        let scanPeriod = 5
        print("Scan Started. Scan period of \(scanPeriod)")
        self.centralManager?.scanForPeripherals(withServices : nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        self.perform(#selector(stopScanning), with: self, afterDelay: Double(scanPeriod))
        //stopScanning()
    }
    
    func stopScanning(){
        print("\nScan Stopped")
        print("There are \(peripherals.count) of expected tags found")
        print("Expected tags that were found \(peripherals)\n")
        peripherals.removeAll()
        startScanning()
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn){
            startScanning()
        }
        else {
            // do something like alert the user that ble is not on
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let pName = peripheral.name{
            if(expectedTags.contains(pName) && !peripherals.contains(peripheral)){
                print("\nNew expected tag found! \(peripheral)")
                peripherals.append(peripheral)
                if let manufacturerData = advertisementData["kCBAdvDataManufacturerData"] as? Data{
                    assert(manufacturerData.count>=7)
                    
                    //0d00 - TI manufacturer ID - 2 byte
                    var manufacturerID = String(format: "%02X", (manufacturerData[0]))
                    manufacturerID += String(format: "%02X", (manufacturerData[1]))
                    print("Manufacturer ID: \(manufacturerID)")
                    
                    //6 byte MAC address
                    var MACAddress = String(format: "%02X", manufacturerData[2])
                    for i in 3...7  {
                        MACAddress += ":"
                        MACAddress += String(format: "%02X", manufacturerData[i])
                    }
                    print("MAC Address: \(MACAddress)")
                    
                    //1 byte battery level
                    let batteryLevel = Int(manufacturerData[8])
                    print("Battery Level: \(batteryLevel)%")
                }
            }
        }
    }
}
