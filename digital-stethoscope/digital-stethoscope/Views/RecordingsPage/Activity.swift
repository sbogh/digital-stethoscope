//
//  Activity.swift
//  digital-stethoscope
//
//  Created by Shelby Myrman on 5/19/25.
//

// TODO: (FOR SHELBY) need to add expanded view of recordings where user can take notes, rename recording, listen to recording, see waveform
// TODO: (FOR SHELBY) need to add button that goes back to loading screen to listen for new recordings


import SwiftUI
import AVKit // TODO: (FOR SIYA) idk if we will need this lol

struct RecordingInfo: Identifiable {
    let id: String // unique recording ID from database, must be included or it will break
    let sessionDate: String // everything works a lot better if we convert this to string on backend and pass in as string here
    let sessionTime: String // same as above
    var viewed: Bool
    var sessionTitle: String = "" // optional, don't include for new sessions but do include for viewed sessions
    var notes: String = "" // optional
    var wavFileURL: URL? = nil // might need to change
}

// TODO: (FOR SIYA) REPLACE HARDCODED LISTs BELOW WITH FETCH FROM BACKEND
// replace this with new recordings
// make sure to include the id or it will break
// also a note I think we should force users to have a device so we don't have to build acct view, I will txt u but adding this here in case I forget
// we'll have to have something in the db to denote whether a session is new or viewed so we can handle this in the backend
let NewRecordings: [RecordingInfo] = [
    RecordingInfo(id: "r1", sessionDate: "5/20/24", sessionTime: "12:59pm", viewed: false),
    RecordingInfo(id: "r2", sessionDate: "5/20/24", sessionTime: "11:02am", viewed: false)
]

// replace this with viewed recordings
let ViewedRecordings: [RecordingInfo] = [
    RecordingInfo(id: "r3", sessionDate: "5/16/24", sessionTime: "3:47pm", viewed: true, sessionTitle: "Shelby Myrman", notes: "wow this heartbeat is awesome I think is invincible"),
    RecordingInfo(id: "r4", sessionDate: "5/14/24", sessionTime: "8:12am", viewed: true, sessionTitle: "Jack Frost", notes: "his heart is frozen!!!!!! I hope he doesn't die lol"),
]


// TODO: (for Siya) I messed around with an audio player view just based on some stuff I found online + chatgpt, I have literally no idea if this will work so feel free to change LOL
// I think in theory we'll put the waveform view in here? It looks like there are some libraries that can accomplish this
struct AudioPlayerView: View {
    let wavFileURL: URL

    var body: some View {
        Button("Play") {
            let player = AVPlayer(url: wavFileURL)
            player.play()
        }
        .font(.custom("Roboto-Regular", size: 14))
        .padding(8)
        .background(Color.CTA1)
        .foregroundColor(Color.primary)
        .cornerRadius(6)
    }
}

struct SessionOverview: View {
    @State private var isExpanded = false
    @State private var editedTitle: String
    @State private var notes: String

    var recording: RecordingInfo
    var defaultTitle: String

    init(sessionTitle: String, recording: RecordingInfo) {
        self.recording = recording
        self.defaultTitle = sessionTitle
        _editedTitle = State(initialValue: sessionTitle)
        _notes = State(initialValue: recording.notes)
    }
    
    var body: some View {
        VStack {
            HStack {
                // TODO: (FOR SIYA) we need to send the editedTitle to the database. In theory we'll do this once they're done editing, ig we can add a save button tho if needed?
                TextField("Session Title", text: $editedTitle)
                    .font(.custom("Roboto-Medium", size: 18))
                    .foregroundColor(.CTA2)
                Spacer()
                
                Button(action: { withAnimation { isExpanded.toggle() } }) {
                    Image(systemName: isExpanded ? "xmark" : "chevron.down")
                        .foregroundColor(.CTA2)
                }
            }
            
            HStack {
                Text(recording.sessionTime)
                    .font(
                        Font.custom("Roboto", size: 16)
                    )
                    .foregroundColor(.CTA2)
                Text(recording.sessionDate)
                    .font(
                        Font.custom("Roboto", size: 16)
                    )
                    .foregroundColor(.CTA2)
                Spacer()
            }
            
            if isExpanded {
                Divider()

                // Audio Player Placeholder
                // TODO: (FOR SIYA) idk how this is actually going to look once the file is in here so we might want to edit this, just lmk if it looks weird and i can help fix
                if let url = recording.wavFileURL {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Recording:")
                                .font(.custom("Roboto-Medium", size: 16))
                                .foregroundColor(.CTA2)
                            
                            Spacer()
                        }

                        // TODO: (FORE SIYA) Replace with waveform visualization if needed
                        AudioPlayerView(wavFileURL: url)
                            .frame(height: 50)
                            .padding(.vertical, 5)
                    }
                } else {
                    HStack {
                        Text("No audio available.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.bottom, 2)
                }
                
                HStack {
                    Text("Session Notes:")
                        .font(.custom("Roboto-Medium", size: 14))
                        .foregroundColor(.CTA2)
                    Spacer()
                }

                // TODO: (FOR SIYA) we need to send the updated notes text to the database. It'd be cool if we could just do this immediately but we could add a save button if needed too
                TextEditor(text: $notes)
                    .frame(height: 80)
                    .padding(5)
                    .background(Color.primary.opacity(0.1))
                    .cornerRadius(8)
            }
            
        }
        .frame(maxWidth: 500)
        .padding()
        .background(Color("sessionbg"))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color("sessionborder"), lineWidth: 1)
        )
        .cornerRadius(12)
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.bottom, 3)
    }
}

struct RecordingsView: View {
    var type: String
    var recordings: [RecordingInfo]
    
    var body: some View {
        HStack {
            Text(type)
                .font(
                    Font.custom("Roboto-ExtraBold", size: 30)
                )
                .foregroundColor(.CTA2)
                .padding(.leading, 30)
                .padding(.top, 10)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        
        
        ForEach(recordings) { recording in
            if recording.sessionTitle == "" {
                recording.viewed ? SessionOverview(sessionTitle: "Viewed Session", recording: recording) : SessionOverview(sessionTitle: "New Session", recording: recording)
            } else {
                SessionOverview(sessionTitle: recording.sessionTitle, recording: recording)
            }
        }
    }
}

struct Activity: View {
    var body: some View {
        ScrollView{
            VStack(spacing: 5) {
                Image("Logo")
                    .resizable()
                    .frame(width: 62.46876, height: 87, alignment: .top)
                    .padding(.top)
                
                Text("Activity")
                    .font(
                        Font.custom("Roboto-ExtraBold", size: 40)
                            .weight(.heavy)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.CTA2)
                    .frame(width: 248, alignment: .top)
                
                Text("Unassigned sessions will clear after 24 hours.")
                    .font(Font.custom("Roboto-Regular", size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.CTA2)
                    .lineLimit(nil)
                
                if NewRecordings.count > 0 {
                    RecordingsView(type: "New", recordings: NewRecordings)
                }
                
                
                if ViewedRecordings.count > 0 {
                    RecordingsView(type: "Viewed", recordings: ViewedRecordings)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top)
            .background(Color.primary)
        }
        .background(Color.primary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    Activity()
}
