//
//  NoteDetailView.swift
//  To-Do
//
//  Created by HarshaHrudhay on 12/09/25.
//



import SwiftUI

struct NoteDetailView: View {
    
    @ObservedObject var note: NoteViewModel
    var onDelete: () -> Void
    
    @Environment(\.dismiss) var dismiss
    @State private var showEditView = false
    @ObservedObject var store: NotesStore
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {

                LinearGradient(colors: [.bg2, .bg1], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        

                        if let category = note.selectedCategory {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Category :")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                
                                Image(systemName: category.rawValue)
                                    .font(.system(size: 30))
                                    .foregroundColor(category.color)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                        

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title :")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            Text(note.title)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description :")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            Text(note.description)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 4)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Reminder :")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            Text(note.taskDate.formatted(date: .abbreviated, time: .shortened))
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        
                        Spacer(minLength: 20)
                        

                        Button {
                            showEditView = true
                        } label: {
                            Text("Edit Task")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.bg2)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        

                        Button(role: .destructive) {
                            onDelete()
                            dismiss()
                        } label: {
                            Text("Delete Task")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                    }
                    .padding()
                }
            }
            .navigationTitle("Task Details")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showEditView) {
                ToDoAddView(note: note, store: store, isEditing: true)
            }
        }
    }
}

#Preview {
    NoteDetailView(
        note: NoteViewModel(id: UUID(), title: "Sample", description: "Sample Description"),
        onDelete: {},
        store: NotesStore()
    )
}
