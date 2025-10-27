//
//  ToDoAddView.swift
//  To-Do
//
//  Created by HarshaHrudhay on 12/09/25.
//


import SwiftUI

struct ToDoAddView: View {
    
    @StateObject var note: NoteViewModel
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var store: NotesStore
    var isEditing: Bool = false
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(colors: [.bg2, .bg1], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Add Title Here :")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black)
                            .padding(.top)
                        
                        TextField("Add Title", text: $note.title)
                            .padding()
//                            .textFieldStyle(.roundedBorder)
                            .glassEffect(.clear.interactive())
                    }
                    .padding(.horizontal)
                    
                    

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Category")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        floatCategory()
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Set Reminder")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        VStack(spacing: 16) {
                            HStack {
                                Text("Date")
                                    .foregroundStyle(Color.black)
                                    .font(.headline)
                                
                                Spacer()
                                
                                DatePicker("", selection: $note.taskDate, displayedComponents: .date)
                                    .labelsHidden()
                            }
                            
                            HStack {
                                Text("Time")
                                    .font(.headline)
                                    .foregroundStyle(Color.black)
                                
                                Spacer()
                                
                                DatePicker("", selection: $note.taskDate, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Add Description Here :")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black)
                        
                        TextEditor(text: $note.description)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 0.5)
                            )
                            .foregroundStyle(Color.black)
                            .scrollContentBackground(.hidden)
                            .frame(height: 150)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.horizontal)
                    
                    

                    Button {
                        if !note.title.isEmpty && !note.description.isEmpty {
                            if isEditing {
                                store.update(note: note)
                            } else {
                                store.add(note: note)
                            }
                            dismiss()
                        }
                    } label: {
                        Text(isEditing ? "Update" : "Create")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.black)
                            .frame(height: 45)
                            .frame(maxWidth: .infinity)
                            .background(
                                (note.title.isEmpty || note.description.isEmpty)
                                ? Color.gray.opacity(0.5)   
                                : Color.bg2
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                    }
                    .disabled(note.title.isEmpty || note.description.isEmpty)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationTitle(isEditing ? "Edit Task" : "Add New Task Here")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.textbg)
                        .font(.system(size: 18, weight: .semibold))
                }
            }
        }
    }
    
    
    fileprivate func floatCategory() -> some View {
        HStack(spacing: 20) {
            ForEach(NoteViewModel.Category.allCases, id: \.self) { category in
                categoryButton(for: category)
            }
        }
    }
    
    fileprivate func categoryButton(for category: NoteViewModel.Category) -> some View {
        let isSelected = category == note.selectedCategory
        
        return Button {
            note.selectedCategory = category
        } label: {
            Image(systemName: category.rawValue)
                .font(.system(size: 20))
                .foregroundColor(isSelected ? .white : category.color)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(isSelected ? category.color : Color.gray.opacity(0.2))
                )
                .overlay(
                    Circle()
                        .stroke(isSelected ? category.color : Color.clear, lineWidth: 2)
                )
        }
    }
}

#Preview {
    ToDoAddView(
        note: NoteViewModel(id: UUID(), title: "", description: ""),
        store: NotesStore()
    )
}
