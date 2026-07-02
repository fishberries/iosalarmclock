import AVFoundation

@MainActor
final class FlashlightManager: NSObject, ObservableObject {
    static let shared = FlashlightManager()
    @Published private(set) var isAvailable = false
    @Published private(set) var isOn = false

    override init() {
        super.init()
        isAvailable = UIDevice.current.hasFlashlight
    }

    func toggleFlashlight() {
        guard isAvailable else { return }

        do {
            guard let device = AVCaptureDevice.default(for: .video) else { return }
            try device.lockForConfiguration()
            device.torchMode = isOn ? .off : .on
            device.unlockForConfiguration()
            isOn.toggle()
        } catch {
            print("Could not control flashlight: \(error)")
        }
    }

    func turnOff() {
        guard isOn else { return }
        toggleFlashlight()
    }
}

extension UIDevice {
    var hasFlashlight: Bool {
        AVCaptureDevice.default(for: .video)?.hasTorch ?? false
    }
}
