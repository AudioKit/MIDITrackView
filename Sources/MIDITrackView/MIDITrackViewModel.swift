// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

public struct MIDITrackViewModel {
    public init(midiNotes: [CGRect], length: CGFloat, height: CGFloat, playPos: Double, zoomLevel: Double, minimumZoom: Double, maximumZoom: Double) {
        self.midiNotes = midiNotes
        self.length = length
        self.height = height
        self.playPos = playPos
        self.zoomLevel = zoomLevel
        self.minimumZoom = minimumZoom
        self.maximumZoom = maximumZoom
    }
    public mutating func updateZoomLevelMagnify(value: CGFloat) {
        let delta = value / lastZoomLevel
        lastZoomLevel = value
        let newScale = zoomLevel * delta
        zoomLevel = max(min(newScale, maximumZoom), minimumZoom)
    }
    public mutating func updateZoomLevelScroll(rot: CGFloat) {
        let delta = rot > 0 ? (1 - rot / 100) : 1.0/(1 + rot/100)
        let newScale = self.zoomLevel * delta
        zoomLevel = max(min(newScale, maximumZoom), minimumZoom)
    }
    public mutating func zoomLevelGestureEnded() { lastZoomLevel = 1.0 }
    public mutating func updatePlayPos(newPos: Double) { playPos = newPos }
    public func getZoomLevel() -> Double { return zoomLevel }
    public func getLength() -> CGFloat { return length }
    public func getHeight() -> CGFloat { return height }
    public func getPlayPos() -> Double { return playPos }
    public func getMIDINotes() -> [CGRect] { return midiNotes }
    /// The notes rendered in the view.
    private let midiNotes: [CGRect]
    /// The length of the longest track.
    private let length: CGFloat
    /// The height of all the tracks in the view.
    private let height: CGFloat
    /// The view's current play position (also the position which the playhead displays)
    private var playPos: Double
    /// The zoom level of all the tracks in the view
    private var zoomLevel: Double
    /// The minimum zoom level.
    private let minimumZoom: Double
    /// The maximum zoom level.
    private let maximumZoom: Double
    private var lastZoomLevel: Double = 1.0
}
