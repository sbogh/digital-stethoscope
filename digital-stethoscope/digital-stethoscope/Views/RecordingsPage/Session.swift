//
//  Session.swift
//  digital-stethoscope
//
//  Created by Shelby Myrman on 5/20/25.
//
//  Defines the `SessionOverview` view that displays information about
//  an individual recording session, including title, date, time, audio playback,
//  and session notes. It also includes a `RecordingsView` to render lists of these.
//

import SwiftUI

// MARK: - SessionOverview

/// View representing a single session card with title, notes, audio player, and metadata.
/*
 This takes in individual recording sessions and displays
 title, notes, date, time, waveform, and play button.
 Title and notes are editable. Once edited we will send
 the title and notes to the database.
 */
struct SessionOverview: View {
    @State private var isExpanded = false
    @State private var editedTitle: String
    @State private var notes: String

    var recording: RecordingInfo
    var defaultTitle: String

    @State private var messageTitle = ""
    @State private var successTitle = false
    @State private var hasTriggeredOnPlay = false

    var onPlay: (() -> Void)? = nil

    /// Custom initializer to bind recording data to UI
    init(sessionTitle: String, recording: RecordingInfo, onPlay: (() -> Void)? = nil) {
        self.recording = recording
        defaultTitle = sessionTitle
        self.onPlay = onPlay
        _editedTitle = State(initialValue: sessionTitle)
        _notes = State(initialValue: recording.notes)
    }

    var body: some View {
        VStack {
            // MARK: - Header with editable title and expand button

            HStack {
                TextField("Session Title", text: $editedTitle)
                    .font(.custom("Roboto-Medium", size: 18))
                    .foregroundColor(.CTA2)
                    .accessibilityIdentifier("SessionTitle")
                    .onChange(of: editedTitle) { _, newTitle in
                        Task {
                            await changeTitle(recordingID: recording.id, newTitle: newTitle)
                        }
                        // TODO: add more error checking/a message for when there was an error with the update
                    }
                Spacer()

                Button(action: {
                    withAnimation {
                        // If expanding for the first time, mark session as viewed
                        if isExpanded, !recording.viewed {
                            Task {
                                await changeView(recordingID: recording.id, viewBool: true)
                            }
                            onPlay?()
                        }
                        isExpanded.toggle()
                    }

                }) {
                    Image(systemName: isExpanded ? "xmark" : "chevron.down")
                        .foregroundColor(.CTA2)
                }
                .accessibilityIdentifier("ExpandSessionButton")
            }

            // MARK: - Date & Time

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

            // MARK: - Expanded View Content

            if isExpanded {
                Divider()

                // MARK: Audio Player

                if let url = recording.wavFileURL {
                    VStack(alignment: .leading) {
                        FirebaseAudioPlayer(firebasePath: url)
                            .frame(height: 50)
                            .padding(.vertical, 5)
                            .accessibilityIdentifier("FirebaseAudioPlayer")
                    }
                    .padding(.bottom)
                    .padding(.top)
                } else {
                    HStack {
                        Text("No audio available.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .accessibilityIdentifier("FirebaseAudioPlayer")
                        Spacer()
                    }
                    .padding(.bottom, 2)
                }

                // MARK: Notes Section

                HStack {
                    Text("Session Notes:")
                        .font(.custom("Roboto-Medium", size: 14))
                        .accessibilityIdentifier("NoteHeader")
                        .foregroundColor(.CTA2)
                    Spacer()
                }

                TextEditor(text: $notes)
                    .accessibilityIdentifier("NoteField")
                    .frame(height: 80)
                    .padding(5)
                    .background(Color.primary.opacity(0.1))
                    .cornerRadius(8)
                    .onChange(of: notes) { _, newNotes in
                        Task {
                            await changeNote(recordingID: recording.id, newNote: newNotes)
                        }

                        // TODO: more robust error checking??
                    }
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

    // MARK: - Backend Update Helpers

    /// Updates the session title for a specific recording in the backend.
    ///
    /// - Parameters:
    ///   - recordingID: The unique identifier for the recording to update.
    ///   - newTitle: The new title string to assign.
    func changeTitle(recordingID: String, newTitle: String) async {
        do {
            let token = try await getFirebaseToken()
            // print("[CHANGE TITLE] Got token: \(token)")
            let (message, success) = await updateRecordingTitle(
                token: token,
                recordingID: recordingID,
                newTitle: newTitle
            )
            // print("[CHANGE TITLE] got response: \(message), \(success)")
            DispatchQueue.main.async {
                if success {
                    print("Title updated: \(message)")
                } else {
                    print("Failed to update: \(message)")
                }
            }
        } catch {
            print("Auth error: \(error.localizedDescription)")
        }
    }

    /// Updates the session notes for a specific recording in the backend.
    ///
    /// - Parameters:
    ///   - recordingID: The unique identifier for the recording to update.
    ///   - newNote: The updated session notes to store.
    func changeNote(recordingID: String, newNote: String) async {
        do {
            let token = try await getFirebaseToken()
            // print("[CHANGE Note] Got token: \(token)")
            let (message, success) = await updateRecordingNote(
                token: token,
                recordingID: recordingID,
                newNote: newNote
            )
            // print("[CHANGE NOTE] got response: \(message), \(success)")
            DispatchQueue.main.async {
                if success {
                    print("Note updated: \(message)")
                } else {
                    print("Failed to update: \(message)")
                }
            }
        } catch {
            print("Auth error: \(error.localizedDescription)")
        }
    }

    /// Marks the recording as viewed or unviewed in the backend.
    ///
    /// - Parameters:
    ///   - recordingID: The unique identifier of the recording to update.
    ///   - viewBool: A Boolean flag indicating whether the session has been viewed.
    func changeView(recordingID: String, viewBool: Bool) async {
        do {
            let token = try await getFirebaseToken()
            print("[CHANGE VIEW BOOL] Got token: \(token)")
            let (message, success) = await updateRecordingView(
                token: token,
                recordingID: recordingID,
                viewBool: viewBool
            )
            print("[CHANGE VIEW BOOL] got response: \(message), \(success)")
            DispatchQueue.main.async {
                if success {
                    print("View Bool updated: \(message)")
                } else {
                    print("Failed to update: \(message)")
                }
            }
        } catch {
            print("Auth error: \(error.localizedDescription)")
        }
    }
}

// MARK: - RecordingsView

/// This takes in a list of recordings and turns them into sessionoverviews.
/// The input for these should be separated into a list of
/// viewed sessions and a list of new sessions. Don't input them together
struct RecordingsView: View {
    var type: String
    var recordings: [RecordingInfo]
    var onPlay: ((RecordingInfo) -> Void)? = nil

    var body: some View {
        HStack {
            // Section Title
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

        // List of Sessions
        ForEach(recordings) { recording in
            let sessionTitle = recording.sessionTitle.isEmpty
                ? (recording.viewed ? "Viewed Session" : "New Session")
                : recording.sessionTitle

            SessionOverview(
                sessionTitle: sessionTitle,
                recording: recording,
                onPlay: {
                    onPlay?(recording)
                }
            )
        }
    }
}
