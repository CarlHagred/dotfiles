// sbhelper: small native helper for the SketchyBar config. It replaces slow osascript /
// system_profiler calls (about 10 ms instead of 250 ms).
//
//   sbhelper volume          -> "<0-100> <0|1 muted>" for the default output device
//   sbhelper output          -> name of the default output device
//   sbhelper set-volume <N>  -> set the volume to N percent (and unmute)
//   sbhelper toggle-mute
//   sbhelper wifi            -> key=value lines (rssi, rate, channel, band), or "down"
//   sbhelper privacy         -> "mic=<0|1> cam=<0|1>" (default microphone / any camera in use)
//   sbhelper screens         -> "<NSScreen index> <x> <width> <height>" per display
//   sbhelper mouse           -> "<x> <y>" cursor position in global points (top-left origin)

import AppKit
import CoreAudio
import CoreMediaIO
import CoreWLAN
import Foundation

// MARK: - Audio

/// 'vmvc', kAudioHardwareServiceDeviceProperty_VirtualMainVolume (not exposed to Swift)
let virtualMainVolume: AudioObjectPropertySelector = 0x766D_7663

func audioAddress(
	_ selector: AudioObjectPropertySelector,
	scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal
) -> AudioObjectPropertyAddress {
	AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: kAudioObjectPropertyElementMain)
}

/// Reads a property, returning `fallback` when the object does not have it.
func audioGet<T>(
	_ object: AudioObjectID, _ selector: AudioObjectPropertySelector,
	scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal, fallback: T
) -> T {
	var address = audioAddress(selector, scope: scope)
	guard AudioObjectHasProperty(object, &address) else { return fallback }
	var value = fallback
	var size = UInt32(MemoryLayout<T>.size)
	withUnsafeMutablePointer(to: &value) { _ = AudioObjectGetPropertyData(object, &address, 0, nil, &size, $0) }
	return value
}

func audioSet<T>(
	_ object: AudioObjectID, _ selector: AudioObjectPropertySelector,
	scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal, value: T
) {
	var address = audioAddress(selector, scope: scope)
	guard AudioObjectHasProperty(object, &address) else { return }
	var value = value
	withUnsafePointer(to: &value) {
		_ = AudioObjectSetPropertyData(object, &address, 0, nil, UInt32(MemoryLayout<T>.size), $0)
	}
}

func defaultDevice(_ selector: AudioObjectPropertySelector) -> AudioDeviceID {
	audioGet(AudioObjectID(kAudioObjectSystemObject), selector, fallback: AudioDeviceID(0))
}

var outputDevice: AudioDeviceID { defaultDevice(kAudioHardwarePropertyDefaultOutputDevice) }

func deviceName(_ device: AudioDeviceID) -> String {
	let name: Unmanaged<CFString>? = audioGet(device, kAudioObjectPropertyName, fallback: nil)
	return (name?.takeRetainedValue() as String?) ?? ""
}

func outputVolumePercent() -> Int {
	let volume: Float32 = audioGet(outputDevice, virtualMainVolume, scope: kAudioDevicePropertyScopeOutput, fallback: 1)
	return Int((volume * 100).rounded())
}

func isMuted() -> Bool {
	let muted: UInt32 = audioGet(outputDevice, kAudioDevicePropertyMute, scope: kAudioDevicePropertyScopeOutput, fallback: 0)
	return muted != 0
}

func setMuted(_ muted: Bool) {
	audioSet(outputDevice, kAudioDevicePropertyMute, scope: kAudioDevicePropertyScopeOutput, value: UInt32(muted ? 1 : 0))
}

func setVolume(percent: Int) {
	let volume = Float32(max(0, min(100, percent))) / 100
	audioSet(outputDevice, virtualMainVolume, scope: kAudioDevicePropertyScopeOutput, value: volume)
	setMuted(false)
}

// MARK: - Privacy

func microphoneInUse() -> Bool {
	let running: UInt32 = audioGet(
		defaultDevice(kAudioHardwarePropertyDefaultInputDevice),
		kAudioDevicePropertyDeviceIsRunningSomewhere, fallback: 0)
	return running != 0
}

func cameraInUse() -> Bool {
	func address(_ selector: Int) -> CMIOObjectPropertyAddress {
		CMIOObjectPropertyAddress(
			mSelector: CMIOObjectPropertySelector(selector),
			mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeGlobal),
			mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementMain))
	}

	let system = CMIOObjectID(kCMIOObjectSystemObject)
	var devicesAddress = address(kCMIOHardwarePropertyDevices)
	var size: UInt32 = 0
	guard CMIOObjectGetPropertyDataSize(system, &devicesAddress, 0, nil, &size) == 0, size > 0 else { return false }

	var devices = [CMIOObjectID](repeating: 0, count: Int(size) / MemoryLayout<CMIOObjectID>.size)
	var used: UInt32 = 0
	CMIOObjectGetPropertyData(system, &devicesAddress, 0, nil, size, &used, &devices)

	return devices.contains { device in
		var runningAddress = address(kCMIODevicePropertyDeviceIsRunningSomewhere)
		var running: UInt32 = 0
		var runningUsed: UInt32 = 0
		CMIOObjectGetPropertyData(device, &runningAddress, 0, nil, UInt32(MemoryLayout<UInt32>.size), &runningUsed, &running)
		return running != 0
	}
}

// MARK: - Wi-Fi

/// The SSID is hidden from apps without Location permission, so only link details are reported.
func printWifi() {
	guard let interface = CWWiFiClient.shared().interface(), interface.powerOn(), interface.rssiValue() != 0 else {
		print("down")
		return
	}
	print("rssi=\(interface.rssiValue())")
	print("rate=\(Int(interface.transmitRate()))")
	if let channel = interface.wlanChannel() {
		let band: String
		switch channel.channelBand {
		case .band2GHz: band = "2.4 GHz"
		case .band5GHz: band = "5 GHz"
		case .band6GHz: band = "6 GHz"
		default: band = "?"
		}
		print("channel=\(channel.channelNumber)")
		print("band=\(band)")
	}
}

// MARK: - Displays and mouse

func printScreens() {
	for (index, screen) in NSScreen.screens.enumerated() {
		print("\(index + 1) \(Int(screen.frame.origin.x)) \(Int(screen.frame.width)) \(Int(screen.frame.height))")
	}
}

func printMouse() {
	let location = CGEvent(source: nil)?.location ?? .zero
	print("\(Int(location.x)) \(Int(location.y))")
}

// MARK: - Command line

let arguments = CommandLine.arguments.dropFirst()

switch arguments.first ?? "" {
case "volume": print("\(outputVolumePercent()) \(isMuted() ? 1 : 0)")
case "output": print(deviceName(outputDevice))
case "set-volume": setVolume(percent: Int(arguments.dropFirst().first ?? "") ?? 0)
case "toggle-mute": setMuted(!isMuted())
case "wifi": printWifi()
case "privacy": print("mic=\(microphoneInUse() ? 1 : 0) cam=\(cameraInUse() ? 1 : 0)")
case "screens": printScreens()
case "mouse": printMouse()
default:
	FileHandle.standardError.write(
		"usage: sbhelper volume|output|set-volume N|toggle-mute|wifi|privacy|screens|mouse\n".data(using: .utf8)!)
	exit(1)
}
