//
//  HomeView.swift
//  To-Do
//
//  Created by HarshaHrudhay on 12/09/25.
//



import SwiftUI

struct HomeView: View {
    
    @State var searchedNote : String = ""
    
    @State private var selectedNote: NoteViewModel? = nil
    @State private var showAddView = false
    
    @StateObject var store = NotesStore()
    
    @State private var selectedTab: Int = 0
    
    
    var filteredNotes: [NoteViewModel] {
        let baseNotes = store.notes.filter { note in
            if searchedNote.isEmpty { return true }
            return note.title.localizedCaseInsensitiveContains(searchedNote)
        }
        
        if selectedTab == 0 {
            return baseNotes.filter { !$0.isCompleted }
        } else {
            return baseNotes.filter { $0.isCompleted }
        }
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack{
                
                LinearGradient(colors: [.bg2, .bg1], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack{
                    
                    Text("My Todo List")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.textbg)
                    

                    ZStack{
                        TextField("Search", text: $searchedNote)
                            .padding(.horizontal, 50)
                            .padding(7)
                            .glassEffect(.clear.interactive())
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(29)
                            .padding()
                            .padding(.top, -30)
                        
                        Image(systemName: "magnifyingglass")
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                            .padding(.trailing, 290)
                            .padding(.bottom, 30)
                        
                    }
                    .padding(.top, 5)
                    
                    

                    HStack(spacing: 16) {
                        Button(action: {
                            selectedTab = 0
                        }) {
                            Text("Not Completed")
                                .font(.headline)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .glassEffect(.clear.interactive())
//                                .background(selectedTab == 0 ? Color.white.opacity(0.5) : Color.clear)
                                .foregroundColor(selectedTab == 0 ? .black : .white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            selectedTab = 1
                        }) {
                            Text("Completed")
                                .font(.headline)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .glassEffect(.clear.interactive())
//                                .background(selectedTab == 1 ? Color.white.opacity(0.5) : Color.clear)
                                .foregroundColor(selectedTab == 1 ? .black : .white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                    
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(filteredNotes) { note in
                                Button {
                                    selectedNote = note
                                } label: {
                                    ListView(note: note, store: store)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.top, 10)
                    }
                    
                    Spacer()
                }
                
                floatButton()
                
            }
            
            .sheet(item: $selectedNote) { note in
                NoteDetailView(
                    note: note,
                    onDelete: { store.delete(note: note) },
                    store: store
                )
            }
        }
    }
    

    fileprivate func floatButton() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                NavigationLink {
                    ToDoAddView(
                        note: NoteViewModel(id: UUID(), title: "", description: ""),
                        store: store
                    )
                } label: {
                    Text("Add New Task")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .glassEffect(.clear.interactive())
//                        .background(Color.bg2)
                        .cornerRadius(30)
                        .shadow(radius: 4)
                }
                .padding(.bottom, 16)
                .padding(.trailing, 16)
                Spacer()
            }
            
        }
    }
}

#Preview {
    HomeView()
}
