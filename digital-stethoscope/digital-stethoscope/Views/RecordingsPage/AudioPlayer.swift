//
//  AudioPlayer.swift
//  digital-stethoscope
//
//  Created by Shelby Myrman on 5/20/25.
//

import SwiftUI
import AVFoundation
import AVKit

struct AudioPlayerView: View {
    let wavFileURL: URL

    @State private var amplitudes: [CGFloat] = []
    @State private var player: AVPlayer?
    @State private var progress: CGFloat = 0.0
    @State private var timeObserverToken: Any?
    @State private var isDragging = false
    @GestureState private var dragOffset: CGFloat = 0.0

    var body: some View {
        VStack(spacing: 16) {
            // Waveform with red playback indicator
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    HStack(spacing: 2) {
                        ForEach(amplitudes.indices, id: \.self) { i in
                            Capsule()
                                .fill(Color.CTA1)
                                .frame(width: 2, height: max(1, amplitudes[i] * 50))
                        }
                    }
                    
                    ZStack(alignment: .leading) {
                        // Visual red line
                        Rectangle()
                            .fill(Color.accentColor)
                            .frame(width: 2, height: 60)
                            .offset(x: isDragging ? dragOffset : geo.size.width * progress)

                        // Invisible hitbox for easier drag
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 30, height: 60)
                            .contentShape(Rectangle())
                            .offset(x: isDragging ? dragOffset : geo.size.width * progress)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .updating($dragOffset) { value, state, _ in
                                        state = value.location.x.clamped(to: 0...geo.size.width)
                                    }
                                    .onChanged { _ in
                                        isDragging = true
                                    }
                                    .onEnded { value in
                                        let width = geo.size.width
                                        let locationX = value.location.x.clamped(to: 0...width)
                                        let relativePosition = locationX / width
                                        self.progress = relativePosition
                                        isDragging = false

                                        // Seek to new time
                                        if let duration = player?.currentItem?.duration.seconds {
                                            let newTime = CMTime(seconds: Double(relativePosition) * duration, preferredTimescale: 600)
                                            player?.seek(to: newTime)
                                        }
                                    }
                            )
                    }
                }
            }
            .frame(height: 60)
            .background(Color.primary.opacity(0.1))
            .cornerRadius(8)

            // Play button
            HStack {
                Spacer()
                Button("Play") {
                    playAudio()
                }
                .font(.custom("Roboto-Semibold", size: 16))
                .padding(8)
                .background(Color.CTA1)
                .foregroundColor(Color.primary)
                .cornerRadius(6)
            }
        }
        .padding()
        .onAppear {
            loadWaveform()
        }
        .onDisappear {
            if let token = timeObserverToken {
                player?.removeTimeObserver(token)
                timeObserverToken = nil
            }
        }
    }

    private func playAudio() {
        let player = AVPlayer(url: wavFileURL)
        self.player = player
        player.play()
        trackProgress()
    }

    private func trackProgress() {
        guard let player = player else { return }

        let interval = CMTime(seconds: 0.05, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            let duration = player.currentItem?.duration.seconds ?? 1
            let current = time.seconds

            if !isDragging {
                self.progress = CGFloat(current / duration)
            }
        }
    }

    private func loadWaveform() {
        let asset = AVURLAsset(url: wavFileURL)

        guard let track = asset.tracks(withMediaType: .audio).first else {
            print("No audio track found")
            return
        }

        do {
            let reader = try AVAssetReader(asset: asset)

            // Force format to 16-bit linear PCM (safe & reliable)
            let outputSettings: [String: Any] = [
                AVFormatIDKey: kAudioFormatLinearPCM,
                AVLinearPCMBitDepthKey: 16,
                AVLinearPCMIsBigEndianKey: false,
                AVLinearPCMIsFloatKey: false,
                AVLinearPCMIsNonInterleaved: false
            ]

            let output = AVAssetReaderTrackOutput(track: track, outputSettings: outputSettings)
            reader.add(output)
            reader.startReading()

            var sampleData = [Int16]()

            while let buffer = output.copyNextSampleBuffer(),
                  let block = CMSampleBufferGetDataBuffer(buffer) {
                let length = CMBlockBufferGetDataLength(block)
                var data = Data(count: length)
                data.withUnsafeMutableBytes { rawBufferPointer in
                    if let baseAddress = rawBufferPointer.baseAddress {
                        CMBlockBufferCopyDataBytes(block, atOffset: 0, dataLength: length, destination: baseAddress)
                    }
                }

                let samples = data.withUnsafeBytes {
                    Array(UnsafeBufferPointer<Int16>(start: $0.bindMemory(to: Int16.self).baseAddress!,
                                                     count: data.count / MemoryLayout<Int16>.size))
                }

                sampleData.append(contentsOf: samples)
            }

            // Downsample to ~300 bars (adjust for your screen width)
            let downsampleFactor = max(1, sampleData.count / 300)
            let downsampled = stride(from: 0, to: sampleData.count, by: downsampleFactor).map { i -> CGFloat in
                let slice = sampleData[i..<min(i + downsampleFactor, sampleData.count)]
                let maxVal = slice.map { abs(Int($0)) }.max() ?? 0
                return CGFloat(maxVal)
            }

            // Normalize to 0...1
            let normalized: [CGFloat]
            if let max = downsampled.max(), max > 0 {
                normalized = downsampled.map { $0 / max }
            } else {
                normalized = downsampled
            }

            DispatchQueue.main.async {
                self.amplitudes = normalized
            }

        } catch {
            print("Error reading waveform: \(error)")
        }
    }
}

struct TestWAVPlayback: View {
    var body: some View {
        VStack {
            if let url = Bundle.main.url(forResource: "frontend-test-heartbeat", withExtension: "wav") {
                AudioPlayerView(wavFileURL: url)
            } else {
                Text("Failed to load WAV file")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}

#Preview {
    TestWAVPlayback()
}

