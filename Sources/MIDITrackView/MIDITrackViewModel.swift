// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

public struct MIDITrackViewModel {
    /// The model which holds data for the MIDITrackView
    /// - Parameters:
    ///   - noteRects: the note rectangles rendered in the view
    ///   - length: the length of the longest track
    ///   - height: the height of the MIDI track
    ///   - playhead: the playhead of the MIDI track
    ///   - zoomLevel: the zoom level of the MIDI track
    ///   - minimumZoom: the minimum zoom level for the MIDI track
    ///   - maximumZoom: the maximum zoom level for the MIDI track
    public init(noteRects: [CGRect],
                length: CGFloat,
                height: CGFloat,
                playhead: Double,
                zoomLevel: Double,
                minimumZoom: Double,
                maximumZoom: Double) {
        self.noteRects = noteRects
        self.length = length
        self.height = height
        self.playhead = playhead
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
    public mutating func updatePlayPos(newPos: Double) { playhead = newPos }
    /// Get the zoom level of all the tracks in the view
    public func getZoomLevel() -> Double { return zoomLevel }
    /// Get the length of the longest track.
    public func getLength() -> CGFloat { return length }
    /// Get the height of all the tracks in the view.
    public func getHeight() -> CGFloat { return height }
    /// The view's current play position (also the position which the playhead displays)
    public func getPlayhead() -> Double { return playhead }
    /// Get the note rectangles rendered in the view.
    public func getNoteRects() -> [CGRect] { return noteRects }
    private let noteRects: [CGRect]
    private let length: CGFloat
    private let height: CGFloat
    private var playhead: Double
    private var zoomLevel: Double
    private let minimumZoom: Double
    private let maximumZoom: Double
    private var lastZoomLevel: Double = 1.0
}
