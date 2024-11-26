//
//  Player.swift
//  XC
//
//  Created by Eric de Quartel on 26/11/2024.
//
import SwiftUI
import SwiftAudioEx
import Foundation
import MediaPlayer

class Player: ObservableObject {
  private var queuedAudioPlayer: QueuedAudioPlayer

  @Published var status: AudioPlayerState = .idle
  @Published var title: String = "unknown"
  @Published var artist: String = "unknown"

  @Published var currentTime: Double = 0
  @Published var currentIndex: Int = 0
  @Published var duration: Double = 0

  init() {
    queuedAudioPlayer = QueuedAudioPlayer()
    queuedAudioPlayer.nowPlayingInfoController.set(keyValue: NowPlayingInfoProperty.isLiveStream(true))
    queuedAudioPlayer.event.stateChange.addListener(self, handleAudioPlayerStateChange)
    queuedAudioPlayer.event.updateDuration.addListener(self, handleDuration)
    queuedAudioPlayer.event.secondElapse.addListener(self, handleSecondElapse)
    queuedAudioPlayer.event.currentItem.addListener(self, handleData)
  }

  private func handleData(
    currentItemEventData:
    ( item: AudioItem?,
      index: Int?,
      lastItem: AudioItem?,
      lastIndex: Int?,
      lastPosition: Double?
    )) {
    DispatchQueue.main.async {
      self.currentIndex = currentItemEventData.index ?? 0
    }
  }

  private func handleAudioPlayerStateChange(state: AudioPlayerState) {
    DispatchQueue.main.async {
      self.status = state
      if state == .ended {
        self.stop()
      }
    }
  }

  private func handleDuration(duration: Double) {
    DispatchQueue.main.async {
      self.duration = duration
    }
  }

  private func handleSecondElapse(currentTime: Double) {
    DispatchQueue.main.async {
      self.currentTime = currentTime
    }
  }

  func fill(_ audioUrls: [String]) {
    queuedAudioPlayer.clear()
    for audioUrl in audioUrls {
      let audioItem = DefaultAudioItem(
        audioUrl: audioUrl,
        sourceType: .stream
      )
      queuedAudioPlayer.add(item: audioItem, playWhenReady: false)
    }
  }

  func play() {
    queuedAudioPlayer.play()
  }

  func pause() {
    queuedAudioPlayer.pause()
  }

  func stop() {
    queuedAudioPlayer.stop()
  }

  func previous() {
    queuedAudioPlayer.previous()
  }

  func next() {
    queuedAudioPlayer.next()
  }
}

extension View {
  @ViewBuilder
  func hidden(_ shouldHide: Bool) -> some View {
    switch shouldHide {
    case true:
      self.hidden()
    case false:
      self
    }
  }
}

