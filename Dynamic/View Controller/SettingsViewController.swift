//
//  SettingsViewController.swift
//  Dynamic
//
//  Created by Apollo Zhu on 6/9/18.
//  Copyright © 2018 Apollonian. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController {
    private static weak var window: NSWindow? = nil
    public static func show() {
        if window == nil {
            ValueTransformer.setValueTransformer(
                UsesCustomRange(), forName: .usesCustomRangeTransformerName
            )
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            let windowController = storyboard
                .instantiateController(withIdentifier: "window")
                as! NSWindowController
            windowController.showWindow(nil)
            window = windowController.window
        }
        NSApp.activate(ignoringOtherApps: true)
        window?.makeKeyAndOrderFront(nil)
    }
    
    deinit {
        NSUserDefaultsController.shared.save(nil)
        Preferences.reload()
    }
}

class UsesCustomRange: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSNumber.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        return (value as? NSNumber)?.intValue
            == Scheduler.Zenith.custom.rawValue
    }
}

extension NSValueTransformerName {
    static let usesCustomRangeTransformerName
        = NSValueTransformerName(rawValue: "UsesCustomRange")
}

extension Preferences {
    public static func reload() {
        Preferences.adjustForBrightness = Preferences.adjustForBrightness
        Preferences.brightnessThreshold = Preferences.brightnessThreshold
        Preferences.scheduled = Preferences.scheduled
        Preferences.scheduleType = Preferences.scheduleType
        Preferences.opensAtLogin = Preferences.opensAtLogin
    }
    
    public static func setup() {
        Preferences.adjustForBrightness = true
        Preferences.brightnessThreshold = 0.5
        #warning("TODO: Implement SunsetSunriseProvider")
        Preferences.scheduled = true
        Preferences.scheduleType = .official
        Preferences.opensAtLogin = true
        Preferences.hasLaunchedBefore = true
    }
}