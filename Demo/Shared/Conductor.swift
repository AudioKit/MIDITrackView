// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import AudioKit
import Foundation

/// A class to manage audio playback within the view
struct Conductor {
    let midiInstrument = AppleSequencer()
    let arpeggioSynthesizer = MIDISampler(name: "Arpeggio Synth")
    let padSynthesizer = MIDISampler(name: "Pad Synth")
    let bassSynthesizer = MIDISampler(name: "Bass Synth")
    let drumKit = MIDISampler(name: "Drums")
    let engine = AudioEngine()
    var arpData: MIDITrackData
    var bassData: MIDITrackData
    var chordsData: MIDITrackData
    var drumsData: MIDITrackData
    var data5: MIDITrackData
    var data6: MIDITrackData
    var data7: MIDITrackData
    var data8: MIDITrackData
    var data9: MIDITrackData
    var data10: MIDITrackData
    var data11: MIDITrackData
    var data12: MIDITrackData
    var data13: MIDITrackData
    var data14: MIDITrackData
    var data15: MIDITrackData
    var data16: MIDITrackData
    var data17: MIDITrackData
    var data18: MIDITrackData
    var data19: MIDITrackData
    var data20: MIDITrackData
    var data21: MIDITrackData
    var data22: MIDITrackData
    var data23: MIDITrackData
    var data24: MIDITrackData
    var data25: MIDITrackData
    var data26: MIDITrackData
    var data27: MIDITrackData
    var data28: MIDITrackData
    var data29: MIDITrackData
    var data30: MIDITrackData
    init() {
        guard let url = Bundle.main.url(forResource: "RUSH_E_FINAL", withExtension: "mid") else {
            print("No URL found for MIDI file")
            arpData = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            bassData = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            chordsData = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            drumsData = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data5 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data6 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data7 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data8 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data9 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data10 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data11 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data12 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data13 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data14 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data15 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data16 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data17 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data18 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data19 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data20 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data21 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data22 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data23 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data24 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data25 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data26 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data27 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data28 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data29 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            data30 = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            return
        }

        midiInstrument.loadMIDIFile(fromURL: url)
        let arpNotes = midiInstrument.tracks[1].getMIDINoteData()
        let arpLength = midiInstrument.tracks[1].length
        let bassNotes = midiInstrument.tracks[2].getMIDINoteData()
        let bassLength = midiInstrument.tracks[2].length
        let padNotes = midiInstrument.tracks[3].getMIDINoteData()
        let padLength = midiInstrument.tracks[3].length
        let drumNotes = midiInstrument.tracks[4].getMIDINoteData()
        let drumLength = midiInstrument.tracks[4].length
        let data5Notes = midiInstrument.tracks[5].getMIDINoteData()
        let data5Length = midiInstrument.tracks[5].length
        let data6Notes = midiInstrument.tracks[6].getMIDINoteData()
        let data6Length = midiInstrument.tracks[6].length
        let data7Notes = midiInstrument.tracks[7].getMIDINoteData()
        let data7Length = midiInstrument.tracks[7].length
        let data8Notes = midiInstrument.tracks[8].getMIDINoteData()
        let data8Length = midiInstrument.tracks[8].length
        let data9Notes = midiInstrument.tracks[9].getMIDINoteData()
        let data9Length = midiInstrument.tracks[9].length
        let data10Notes = midiInstrument.tracks[10].getMIDINoteData()
        let data10Length = midiInstrument.tracks[10].length
        let data11Notes = midiInstrument.tracks[11].getMIDINoteData()
        let data11Length = midiInstrument.tracks[11].length
        let data12Notes = midiInstrument.tracks[12].getMIDINoteData()
        let data12Length = midiInstrument.tracks[12].length
        let data13Notes = midiInstrument.tracks[13].getMIDINoteData()
        let data13Length = midiInstrument.tracks[13].length
        let data14Notes = midiInstrument.tracks[14].getMIDINoteData()
        let data14Length = midiInstrument.tracks[14].length
        let data15Notes = midiInstrument.tracks[15].getMIDINoteData()
        let data15Length = midiInstrument.tracks[15].length
        let data16Notes = midiInstrument.tracks[16].getMIDINoteData()
        let data16Length = midiInstrument.tracks[16].length
        let data17Notes = midiInstrument.tracks[17].getMIDINoteData()
        let data17Length = midiInstrument.tracks[17].length
        let data18Notes = midiInstrument.tracks[18].getMIDINoteData()
        let data18Length = midiInstrument.tracks[18].length
        let data19Notes = midiInstrument.tracks[19].getMIDINoteData()
        let data19Length = midiInstrument.tracks[19].length
        let data20Notes = midiInstrument.tracks[20].getMIDINoteData()
        let data20Length = midiInstrument.tracks[20].length
        let data21Notes = midiInstrument.tracks[21].getMIDINoteData()
        let data21Length = midiInstrument.tracks[21].length
        let data22Notes = midiInstrument.tracks[22].getMIDINoteData()
        let data22Length = midiInstrument.tracks[22].length
        let data23Notes = midiInstrument.tracks[23].getMIDINoteData()
        let data23Length = midiInstrument.tracks[23].length
        let data24Notes = midiInstrument.tracks[24].getMIDINoteData()
        let data24Length = midiInstrument.tracks[24].length
        let data25Notes = midiInstrument.tracks[25].getMIDINoteData()
        let data25Length = midiInstrument.tracks[25].length
        let data26Notes = midiInstrument.tracks[26].getMIDINoteData()
        let data26Length = midiInstrument.tracks[26].length
        let data27Notes = midiInstrument.tracks[27].getMIDINoteData()
        let data27Length = midiInstrument.tracks[27].length
        let data28Notes = midiInstrument.tracks[28].getMIDINoteData()
        let data28Length = midiInstrument.tracks[28].length
        let data29Notes = midiInstrument.tracks[29].getMIDINoteData()
        let data29Length = midiInstrument.tracks[29].length
        let data30Notes = midiInstrument.tracks[30].getMIDINoteData()
        let data30Length = midiInstrument.tracks[30].length
        arpData = MIDITrackData(length: arpLength, height: 200.0, noteData: arpNotes)
        bassData = MIDITrackData(length: bassLength, height: 200.0, noteData: bassNotes)
        chordsData = MIDITrackData(length: padLength, height: 200.0, noteData: padNotes)
        drumsData = MIDITrackData(length: drumLength, height: 200.0, noteData: drumNotes)
        data5 = MIDITrackData(length: data5Length, height: 200.0, noteData: data5Notes)
        data6 = MIDITrackData(length: data6Length, height: 200.0, noteData: data6Notes)
        data7 = MIDITrackData(length: data7Length, height: 200.0, noteData: data7Notes)
        data8 = MIDITrackData(length: data8Length, height: 200.0, noteData: data8Notes)
        data9 = MIDITrackData(length: data9Length, height: 200.0, noteData: data9Notes)
        data10 = MIDITrackData(length: data10Length, height: 200.0, noteData: data10Notes)
        data11 = MIDITrackData(length: data11Length, height: 200.0, noteData: data11Notes)
        data12 = MIDITrackData(length: data12Length, height: 200.0, noteData: data12Notes)
        data13 = MIDITrackData(length: data13Length, height: 200.0, noteData: data13Notes)
        data14 = MIDITrackData(length: data14Length, height: 200.0, noteData: data14Notes)
        data15 = MIDITrackData(length: data15Length, height: 200.0, noteData: data15Notes)
        data16 = MIDITrackData(length: data16Length, height: 200.0, noteData: data16Notes)
        data17 = MIDITrackData(length: data17Length, height: 200.0, noteData: data17Notes)
        data18 = MIDITrackData(length: data18Length, height: 200.0, noteData: data18Notes)
        data19 = MIDITrackData(length: data19Length, height: 200.0, noteData: data19Notes)
        data20 = MIDITrackData(length: data20Length, height: 200.0, noteData: data20Notes)
        data21 = MIDITrackData(length: data21Length, height: 200.0, noteData: data21Notes)
        data22 = MIDITrackData(length: data22Length, height: 200.0, noteData: data22Notes)
        data23 = MIDITrackData(length: data23Length, height: 200.0, noteData: data23Notes)
        data24 = MIDITrackData(length: data24Length, height: 200.0, noteData: data24Notes)
        data25 = MIDITrackData(length: data25Length, height: 200.0, noteData: data25Notes)
        data26 = MIDITrackData(length: data26Length, height: 200.0, noteData: data26Notes)
        data27 = MIDITrackData(length: data27Length, height: 200.0, noteData: data27Notes)
        data28 = MIDITrackData(length: data28Length, height: 200.0, noteData: data28Notes)
        data29 = MIDITrackData(length: data29Length, height: 200.0, noteData: data29Notes)
        data30 = MIDITrackData(length: data30Length, height: 200.0, noteData: data30Notes)


        midiInstrument.tracks[1].setMIDIOutput(arpeggioSynthesizer.midiIn)
        midiInstrument.tracks[2].setMIDIOutput(bassSynthesizer.midiIn)
        midiInstrument.tracks[3].setMIDIOutput(padSynthesizer.midiIn)
        //midiInstrument.tracks[4].setMIDIOutput(drumKit.midiIn)
        engine.output = Mixer(arpeggioSynthesizer,
                              padSynthesizer,
                              bassSynthesizer,
                              drumKit)
        let samplerInstruments = [(arpeggioSynthesizer, "Sounds/Sampler Instruments/sqrTone1"),
                                  (padSynthesizer, "Sounds/Sampler Instruments/sawPiano1"),
                                  (bassSynthesizer, "Sounds/Sampler Instruments/sawPiano1"),
                                  (drumKit, "Sounds/Sampler Instruments/drumSimp")]
        for (sampler,path) in samplerInstruments {
            if let fileURL = Bundle.main.url(forResource: path, withExtension: "exs") {
                do {
                    try sampler.loadInstrument(url: fileURL)
                } catch {
                    Log("A file was not found.")
                }
            } else {
                Log("Could not find file")
            }
        }
        do {
            try engine.start()
        } catch {
            print(error.localizedDescription, " - (The audio engine could not start.)")
        }
    }
}
