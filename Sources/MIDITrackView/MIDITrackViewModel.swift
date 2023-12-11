// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

public class MIDITrackViewModel: ObservableObject {
    public init(midiNotes: [MIDITrackViewNote] = [], length: CGFloat = 0.0, height: CGFloat = 0.0,
                playPos: Double = 0.0, zoomLevel: Double = 50.0, minimumZoom: Double = 0.01, maximumZoom: Double = 500.0) {
        self.midiNotes = midiNotes
        self.length = length
        self.height = height
        self.playPos = playPos
        self.zoomLevel = zoomLevel
        self.minimumZoom = minimumZoom
        self.maximumZoom = maximumZoom
    }
    func updateZoomLevelMagnify(value: CGFloat) {
        let delta = value / lastZoomLevel
        lastZoomLevel = value
        let newScale = zoomLevel * delta
        zoomLevel = max(min(newScale, maximumZoom), minimumZoom)
    }
    func updateZoomLevelScroll(rot: CGFloat) {
        let delta = rot > 0 ? (1 - rot / 100) : 1.0/(1 + rot/100)
        let newScale = self.zoomLevel * delta
        zoomLevel = max(min(newScale, maximumZoom), minimumZoom)
    }
    func zoomLevelGestureEnded() {
        lastZoomLevel = 1.0
    }

    /// The notes rendered in the view.
    @Published public var midiNotes: [MIDITrackViewNote]
    /// The length of the track.
    public var length: CGFloat
    /// The height of the track.
    public var height: CGFloat
    /// The track's current play position (also the position which the playhead displays)
    @Published public var playPos: Double
    /// The track zoom level
    @Published public var zoomLevel: Double
    /// The track minimum zoom level.
    public var minimumZoom: Double
    /// The track maximum zoom level.
    public var maximumZoom: Double
    private var lastZoomLevel: Double = 1.0
}
