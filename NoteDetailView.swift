//
//  NoteDetailView.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 12/3/25.
//
import SwiftUI

struct NoteDetailView: View {
    let note: Note
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(note.title)
                    .font(.title)
                    .bold()
                
                Text(note.dateCreated, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Divider()
                
                Text(note.content)
                    .font(.body)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Note")
        .navigationBarTitleDisplayMode(.inline)
    }
}
