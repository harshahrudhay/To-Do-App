//
//  ListView.swift
//  To-Do
//
//  Created by HarshaHrudhay on 12/09/25.
//


import SwiftUI

struct ListView: View {
    
    @ObservedObject var note: NoteViewModel
    var store: NotesStore
    
    var body: some View {
        
        VStack {
            
            
            HStack (spacing:10){
                
                Image(systemName: note.selectedCategory?.rawValue ?? "square.and.pencil")
                    .resizable()
                //                    .font(.system(size: 30, weight: .bold))
                    .frame(width: 30, height: 30)
                    .foregroundStyle(note.selectedCategory?.color ?? .black)
                
                VStack(alignment: .leading, spacing: 5){
                    
                    Text(note.title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.black)
                    
                    Text(note.description)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.black)
                        .lineLimit(1)
                    
                    
                }
                
                .padding(.vertical)
                
                Spacer()
                VStack{
                    Button {
                        store.toggleCompletion(for: note)
                    } label: {
                        Image(systemName: note.isCompleted ? "checkmark.square.fill" : "square")
                            .resizable()
                            //.font(.system(size: 30))
                            .frame(width: 15, height: 15)
                            .foregroundStyle(.black)
                        
                    }
                    Text(note.taskDate, style: .time)
                        .font(.system(size: 13))
                        .foregroundStyle(.black)

                }
                
                
            }
            .padding(.horizontal)
            .background(Color.listbg.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
}

#Preview {
    ListView(note: NoteViewModel(id: UUID(), title: "apple", description: "ftytutuiuyiktui", reminderDate: Date()), store: NotesStore())
}

