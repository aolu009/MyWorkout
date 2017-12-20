//
//  Bluetooth.swift
//  MyWorkout
//
//  Created by Lu Ao on 11/9/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//

import CoreBluetooth
import ReactiveSwift

class Bluetooth: NSObject,CBCentralManagerDelegate, CBPeripheralDelegate {
    /** Singleton accessor */
    static let manage = Bluetooth()
    private override init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil)
        print("Bluetooth: Initiating Bluetooth")
    }
    
    var manager:CBCentralManager!
    var peripheral:CBPeripheral!
    private (set) var heartRate = MutableProperty<String>("0")
    private (set) var heartRateDouble = MutableProperty<Double>(0.0)
    private (set) var isAvailable = MutableProperty<Bool>(false)
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth: Scanning")
            central.scanForPeripherals(withServices: nil, options: nil)
        } else {
            self.isAvailable.value = false
            print("Bluetooth: Bluetooth not available.")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
        if let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String{
            print("Bluetooth: \(localName)")
            if localName.starts(with: "Polar ") {
                let items = localName.split(separator: " ")
                if items.count > 2 {
                    let polarDeviceId = items.last
                    if polarDeviceId == "0B841323" && peripheral.state == .disconnected{
                        central.stopScan()
                        self.peripheral = peripheral
                        self.peripheral.delegate = self
                        central.connect(peripheral, options: nil)
                        print("Bluetooth: Connected")
                    }
                }
            }
        }
    }
    
    func centralManager(_ manager: CBCentralManager, didConnect peripheral: CBPeripheral){
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ manager: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?){
        self.manager.scanForPeripherals(withServices: [CBUUID.init(string: "180D")], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true]);
    }
    
    func centralManager(_ manager: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?){
        self.manager.scanForPeripherals(withServices: [CBUUID.init(string: "180D")], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true]);
    }
    
    let HR_SERVICE     = CBUUID(string: "180D");
    let HR_MEASUREMENT = CBUUID(string: "2a37");
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?){
        if error == nil {
            for service in peripheral.services! {
                if service.uuid.isEqual(HR_SERVICE){
                    peripheral.discoverCharacteristics(nil, for: service);
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?){
        //BleLogger.trace_if_error("didDiscoverCharacteristicsForService: ", error: error as NSError!)
        if error == nil {
            for chr in service.characteristics! {
                if chr.uuid.isEqual(HR_MEASUREMENT){
                    peripheral.setNotifyValue(true, for: chr)
                    print("Bluetooth: HR_MEASUREMENT")
                }
            }
        }
    }
     // Process recieved data
     // Reference: https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.characteristic.heart_rate_measurement.xml&u=org.bluetooth.characteristic.heart_rate_measurement.xml
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        if error == nil {
            let data = characteristic.value
            var offset = 0
            
            let hrFormat = data![0] & 0x01 //                            0000 0001 | 0th bit | UINT8/UINT16 (Beats/mintute) 0,1
            let sensorContactBits = Int((data![0] & 0x06) >> 1) //       0000 0110 | 1st to 2nd bit | Support/Detected      0,1,2,3
            let energyExpended = (data![0] & 0x08) >> 3 //               0000 1000 | 3rd bit | Present kJoules              0,1
            let rrPresent = (data![0] & 0x10) >> 4//                     0001 0000 | 4th bit | Present second (Resolution of 1/1024 second) 0,1
            
            var sensorContact = sensorContactBits == 3
            var contactSupported = true
            
            if sensorContactBits == 0 {
                contactSupported = false
                sensorContact = true
            }
            
            print("Bluetooth: SensorContacted: \(sensorContact)")
            self.isAvailable.value = true
            let hrValue = hrFormat == 1 ? (Int(data![1]) + (Int(data![2]) << 8)) : Int(data![1]);
            self.heartRate.value = String(hrValue)
            heartRateDouble.value = Double(hrValue)
            print("Bluetooth: Format: \(hrFormat) = \(Int(hrFormat)) = UINT8")
            print("Bluetooth: HR_MEASUREMENT: \(hrValue)")
            
            if contactSupported == false && hrValue == 0 {
                sensorContact = false
            }
            
            
            offset = Int(hrFormat) + 2 //[Settings, hrValue, energy, energy, RR, RR] // offset = 2
            
            var energy = 0
            
            if (energyExpended == 1) {
                energy = Int(data![offset]) + (Int(data![offset + 1]) << 8);
                offset += 2;
            }
            print("Bluetooth: ENERGY: \(energy) KJ")
            
            var rrs = [Int]()
            if( rrPresent == 1 ){
                let len = data!.count
                while (offset < len) {
                    let rrValueRaw = Int(data![offset]) | (Int(data![offset + 1]) << 8)
                    let rrValue = Int((Double(rrValueRaw) / 1024.0) * 1000.0);
                    offset += 2;
                    rrs.append(rrValue);
                }
                print("Bluetooth: RRS: \(rrs[0])")
            }
        }
    }
}
