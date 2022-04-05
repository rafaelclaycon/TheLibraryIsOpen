import Foundation

class DeviceStorageInformation {

    static func totalCapacityInBytes() -> Int {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String) else {
            return 0
        }
        let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.intValue
        let spaceInDouble = Double(space!)
        return Int(ceil(spaceInDouble))
    }
    
    static func freeSpaceInBytes() -> Int {
        if let simulatedFreeSpace = ProcessInfo.processInfo.environment["SimulatedFreeDiskSpaceInBytes"] {
            return Int(simulatedFreeSpace) ?? 0
        }
        
        guard let freeSpace = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage else {
            return 0
        }
        return Int(freeSpace)
    }

}
