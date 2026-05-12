import AVFoundation
import ImageIO
import SwiftUI
import UIKit
import Vision

struct CountView: View {
    @EnvironmentObject private var store: RepLockStore
    let exercise: Exercise
    @StateObject private var counter: PoseCounter
    @State private var recordedSessionCount = 0

    init(exercise: Exercise) {
        self.exercise = exercise
        _counter = StateObject(wrappedValue: PoseCounter(exercise: exercise))
    }

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    remainingCard
                    cameraCard
                    controls
                    guidance
                }
                .padding(24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            counter.start()
        }
        .onDisappear {
            counter.stop()
        }
        .onChange(of: counter.sessionCount) { _, newValue in
            let delta = newValue - recordedSessionCount
            if delta > 0 {
                store.addProgress(delta, for: exercise)
                recordedSessionCount = newValue
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(exercise.title.uppercased())
                .font(.caption.weight(.bold))
                .tracking(2)
                .foregroundStyle(AppTheme.secondaryText)
            Text("カメラで姿勢判定")
                .font(.system(size: 32, weight: .semibold))
                .foregroundStyle(AppTheme.primaryText)
            Text(exercise.trackingDescription)
                .font(.footnote)
                .lineSpacing(4)
                .foregroundStyle(AppTheme.secondaryText)
        }
    }

    private var remainingCard: some View {
        MetricCard(
            title: "Remaining",
            value: "\(store.remaining(for: exercise))\(exercise.unit)",
            caption: "今日の目標 + 過去の負債"
        ) {
            ExerciseProgressRow(exercise: exercise)
        }
    }

    private var cameraCard: some View {
        ZStack(alignment: .bottomLeading) {
            CameraPreview(session: counter.session)
                .frame(height: 420)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous)
                        .stroke(AppTheme.hairline, lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 8) {
                Text(counter.permissionMessage)
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)
                Text(counter.statusText)
                    .font(.headline)
                    .foregroundStyle(AppTheme.primaryText)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.black.opacity(0.58))
        }
    }

    private var controls: some View {
        VStack(spacing: 14) {
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("今日の記録")
                        .font(.caption.weight(.semibold))
                        .tracking(1.2)
                        .foregroundStyle(AppTheme.secondaryText)
                    Text("\(store.progress(for: exercise))\(exercise.unit)")
                        .font(.system(size: 42, weight: .semibold))
                        .monospacedDigit()
                        .foregroundStyle(AppTheme.primaryText)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    Text("この画面")
                        .font(.caption.weight(.semibold))
                        .tracking(1.2)
                        .foregroundStyle(AppTheme.secondaryText)
                    Text("\(counter.sessionCount)\(exercise.unit)")
                        .font(.system(size: 42, weight: .semibold))
                        .monospacedDigit()
                        .foregroundStyle(AppTheme.primaryText)
                }
            }

            if exercise == .plank {
                PrimaryButton(title: counter.isPlankActive ? "プランクを終了して1回記録" : "プランクを開始") {
                    counter.togglePlank()
                }
            } else {
                Text("腕立て伏せとスクワットはVisionが動作を検出すると自動で記録されます。")
                    .font(.footnote)
                    .lineSpacing(4)
                    .foregroundStyle(AppTheme.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(22)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous))
    }

    private var guidance: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("端末内処理")
                .font(.headline)
                .foregroundStyle(AppTheme.primaryText)
            Text("Apple Vision framework（VNDetectHumanBodyPoseRequest）で姿勢を検出します。映像や姿勢データを外部APIやクラウドへ送信しません。")
                .font(.footnote)
                .lineSpacing(4)
                .foregroundStyle(AppTheme.secondaryText)
        }
        .padding(.bottom, 24)
    }
}

final class PoseCounter: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var sessionCount = 0
    @Published var statusText = "カメラを準備しています"
    @Published var permissionMessage = "カメラ映像は端末内でのみ処理されます"
    @Published var isPlankActive = false

    let session = AVCaptureSession()

    private let exercise: Exercise
    private let visionQueue = DispatchQueue(label: "dopamine-lock.vision")
    private let videoQueue = DispatchQueue(label: "dopamine-lock.camera")
    private var request = VNDetectHumanBodyPoseRequest()
    private var isProcessingFrame = false
    private var movementPhase: MovementPhase = .ready
    private var highY: CGFloat?
    private var lowY: CGFloat?

    init(exercise: Exercise) {
        self.exercise = exercise
        super.init()
    }

    func start() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureAndStartSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.configureAndStartSession()
                    } else {
                        self?.permissionMessage = "カメラ権限が必要です"
                        self?.statusText = "設定アプリでカメラを許可してください"
                    }
                }
            }
        default:
            permissionMessage = "カメラ権限が必要です"
            statusText = "設定アプリでカメラを許可してください"
        }
    }

    func stop() {
        videoQueue.async { [weak self] in
            guard let self else { return }
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }

    func togglePlank() {
        guard exercise == .plank else { return }
        if isPlankActive {
            sessionCount += 1
            statusText = "プランクを1回記録しました"
            isPlankActive = false
        } else {
            statusText = "姿勢を保ち、終わったら終了を押してください"
            isPlankActive = true
        }
    }

    private func configureAndStartSession() {
        permissionMessage = "Visionで姿勢を端末内解析中"
        guard !session.isRunning else { return }

        videoQueue.async { [weak self] in
            guard let self else { return }
            self.session.beginConfiguration()
            self.session.sessionPreset = .high

            if self.session.inputs.isEmpty {
                guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
                      let input = try? AVCaptureDeviceInput(device: device),
                      self.session.canAddInput(input) else {
                    DispatchQueue.main.async {
                        self.statusText = "カメラを開始できませんでした"
                    }
                    self.session.commitConfiguration()
                    return
                }
                self.session.addInput(input)
            }

            if self.session.outputs.isEmpty {
                let output = AVCaptureVideoDataOutput()
                output.alwaysDiscardsLateVideoFrames = true
                output.setSampleBufferDelegate(self, queue: self.visionQueue)
                if self.session.canAddOutput(output) {
                    self.session.addOutput(output)
                }
            }

            self.session.commitConfiguration()
            self.session.startRunning()
            DispatchQueue.main.async {
                self.statusText = self.exercise == .plank ? "開始ボタンでプランクを記録できます" : "全身が映る位置で動作を始めてください"
            }
        }
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard exercise != .plank else { return }
        guard !isProcessingFrame else { return }
        isProcessingFrame = true
        defer { isProcessingFrame = false }

        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .leftMirrored)
        do {
            try handler.perform([request])
            guard let observation = request.results?.first else {
                updateStatus("体が見つかりません。全身を映してください")
                return
            }
            evaluate(observation)
        } catch {
            updateStatus("姿勢判定を実行できませんでした")
        }
    }

    private func evaluate(_ observation: VNHumanBodyPoseObservation) {
        switch exercise {
        case .pushUps:
            evaluatePushUp(observation)
        case .squats:
            evaluateSquat(observation)
        case .plank:
            break
        }
    }

    private func evaluatePushUp(_ observation: VNHumanBodyPoseObservation) {
        guard let shoulder = averagePoint([.leftShoulder, .rightShoulder], in: observation),
              let hip = averagePoint([.leftHip, .rightHip], in: observation) else {
            updateStatus("肩と腰が映るように調整してください")
            return
        }

        let bodyCenterY = (shoulder.y + hip.y) / 2
        highY = max(highY ?? bodyCenterY, bodyCenterY)
        lowY = min(lowY ?? bodyCenterY, bodyCenterY)
        guard let highY, let lowY else { return }

        if movementPhase == .ready, bodyCenterY < highY - 0.08 {
            movementPhase = .down
            updateStatus("下げを検出しました。上げてください")
        } else if movementPhase == .down, bodyCenterY > lowY + 0.07 {
            increment("腕立て伏せを1回記録しました")
            movementPhase = .ready
            self.highY = bodyCenterY
            self.lowY = bodyCenterY
        } else {
            updateStatus("腕立て伏せを判定中")
        }
    }

    private func evaluateSquat(_ observation: VNHumanBodyPoseObservation) {
        guard let hip = averagePoint([.leftHip, .rightHip], in: observation),
              let knee = averagePoint([.leftKnee, .rightKnee], in: observation) else {
            updateStatus("腰と膝が映るように調整してください")
            return
        }

        let standing = hip.y > knee.y + 0.12
        let squatting = hip.y < knee.y + 0.05

        if movementPhase == .ready, squatting {
            movementPhase = .down
            updateStatus("しゃがみを検出しました。立ち上がってください")
        } else if movementPhase == .down, standing {
            increment("スクワットを1回記録しました")
            movementPhase = .ready
        } else {
            updateStatus("スクワットを判定中")
        }
    }

    private func averagePoint(_ joints: [VNHumanBodyPoseObservation.JointName], in observation: VNHumanBodyPoseObservation) -> CGPoint? {
        let points = joints.compactMap { joint -> CGPoint? in
            guard let point = try? observation.recognizedPoint(joint), point.confidence > 0.35 else { return nil }
            return point.location
        }
        guard !points.isEmpty else { return nil }
        let x = points.reduce(CGFloat(0)) { $0 + $1.x } / CGFloat(points.count)
        let y = points.reduce(CGFloat(0)) { $0 + $1.y } / CGFloat(points.count)
        return CGPoint(x: x, y: y)
    }

    private func increment(_ message: String) {
        DispatchQueue.main.async {
            self.sessionCount += 1
            self.statusText = message
        }
    }

    private func updateStatus(_ message: String) {
        DispatchQueue.main.async {
            self.statusText = message
        }
    }
}

private enum MovementPhase {
    case ready
    case down
}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {
        uiView.videoPreviewLayer.session = session
    }
}

final class PreviewView: UIView {
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
}
