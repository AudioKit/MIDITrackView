// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

/// A view representing a MIDI Track.
public struct MIDITrackView: View {
    /// The view model.
    @Binding var model: MIDITrackViewModel

    /// The view zoom level.
    ///
    /// # Description:
    /// This property controls the zoom level of this view. Use the "pinch and drag" gesture on your device screen/trackpad
    /// to adjust the zoom level accordingly. <**Insert instructions for desktop user here**>.
    ///
    /// ### Important values:
    /// __Default:__ 1.0, __Minimum:__ 0.1, __Maximum:__ 5.0.
    ///
    @State public var zoomLevel = 1.0
    @State private var lastZoomLevel = 1.0

    /// The track background color.
    var trackColor = Color.primary
    /// The color of the notes on the track.
    var noteColor = Color.accentColor

    public init(model: Binding<MIDITrackViewModel>,
                trackColor: Color = .primary,
                noteColor: Color = .accentColor) {
        _model = model
        self.trackColor = trackColor
        self.noteColor = noteColor
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            VStack {
                ZStack {
                    ForEach(model.midiNotes) { midiNote in
                        MIDINoteView(
                            midiNote: $model.midiNotes[model.midiNotes.firstIndex(of: midiNote)!],
                            zoomMultiplier: $zoomLevel,
                            color: noteColor
                        )
                    }
                }
            }
            .gesture(MagnificationGesture().onChanged { val in
                let delta = val / self.lastZoomLevel
                self.lastZoomLevel = val
                let newScale = self.zoomLevel * delta
                zoomLevel = max(min(newScale, 5.0), 0.1)
            }.onEnded { val in
              self.lastZoomLevel = 1.0
            })
            .frame(width: model.length * zoomLevel, height: model.height, alignment: .center)
            .background(trackColor)
            .cornerRadius(10.0)
        }
    }
}
