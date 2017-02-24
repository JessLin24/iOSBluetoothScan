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
        expectedTags.append("CB4C2E61-FEF3-47FF-8AEC-67A9B883016C")
    }
}

extension ViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn){
            startScanning()
        }
        else {
            // do something like alert the user that ble is not on
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if(expectedTags.contains(peripheral.identifier.uuidString)
            && !peripherals.contains(peripheral)){
            print("New expected tag found! \(peripheral)")
            peripherals.append(peripheral)
        }
    }
    func startScanning(){
        let scanPeriod = 5
        print("Scan Started. Scan period of \(scanPeriod)")
        self.centralManager?.scanForPeripherals(withServices : nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        self.perform(#selector(stopScanning), with: self, afterDelay: Double(scanPeriod))
    }
    
    func stopScanning(){
        print("Scan Stopped")
        print("There are \(peripherals.count) of expected tags found")
        print("Expected tags that were found \(peripherals)")
        peripherals.removeAll()
        startScanning()
    }
}
