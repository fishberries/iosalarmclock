import AVFoundation

@MainActor
final class AudioManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    static let shared = AudioManager()
    @Published private(set) var isPlaying = false

    private var audioPlayer: AVAudioPlayer?

    override init() {
        super.init()
        setupAudioSession()
    }

    func play(sound: String, volume: Double = 0.8) {
        playSystemSound()
    }

    func stop() {
        audioPlayer?.stop()
        isPlaying = false
    }

    private func playSystemSound() {
        let systemSoundID: SystemSoundID = 1005
        AudioServicesPlayAlertSoundWithCompletion(systemSoundID) { }
        isPlaying = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isPlaying = false
        }
    }

    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.duckOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session setup failed: \(error)")
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.isPlaying = false
        }
    }
}
