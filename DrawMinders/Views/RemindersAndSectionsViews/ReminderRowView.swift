//
//  ReminderRowView.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 19/05/2025.
//

import SwiftUI
import SwiftData


struct ReminderRowView: View {
    @Environment(\.modelContext) private var modelContext

    @Bindable var reminder: Reminder
    @Binding var selectedReminderId: PersistentIdentifier?
    
    @State private var completionProgress: Double = 0
    @State private var completionTimer: Timer?
    @State private var isCompletionInProgress: Bool = false
    @State private var showPopover = false
    @State private var tempTitle: String = ""
    
    private var isSelected: Bool {
        selectedReminderId == reminder.persistentModelID
    }
    
    //wprowadz zeby info button byl widzony wtedy co jestesmy w trakcie pisania/ rysowania
    
    var body: some View {
            HStack {
                // Is Completed przycisk
                Button {
                    handleCirclePress()
                } label: {
                    ZStack {
                        //zewnetrzny
                        Circle()
                            .strokeBorder(isCompletionInProgress ? Color(hex: reminder.list?.hexColor ?? "#007AFF") : .gray, lineWidth: 2)
                            .frame(width: 24, height: 24)
                        
                        //wewnetrzny z aniamcja gratis
                        if isCompletionInProgress {
                            Circle()
                                .fill(Color(hex: reminder.list?.hexColor ?? "#007AFF"))
                                .frame(width: 18, height: 18)
                                .padding(4)
                        }
                        
//                         gdy ukonczone
                        if reminder.isCompleted {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 18, height: 18)
                        }
                    }
                }
                .buttonStyle(.plain)
    
                // Zawartosc przypomnienia
                //Tutaj mozna podzialac cos z isCompleted, na przyklad zrobic szary obrazek bardziej
                VStack {
                    TextField("Reminder title", text: $tempTitle, onCommit: saveTitle)
                        .onAppear {
                            tempTitle = reminder.title
                        }
                        .onChange(of: tempTitle) {
                            reminder.title = tempTitle
                            try? modelContext.save()
                        }
                    
                    if let date = reminder.reminderDate {
                        Text(date.formatted(date: .abbreviated, time: .omitted))
                    }
                    
                    if let time = reminder.reminderTime {
                        Text((time.formatted(date: .omitted, time: .shortened)))
                    }
                }

// Rectangle().fill()
// .frame(maxWidth: .infinity, maxHeight: .infinity)
// .foregroundStyle(.red)

//Moze na view do pisania z gory lewej dac napis jakie to przypomnienie kolorem secondary i allowsHittesting
//Jak bedziemy chcieli tutaj cos z opcjonalnych rzeczy z reminders trzeba odpakowac

                Spacer()
                
                if isSelected {
                    Button {
                        showPopover = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .buttonStyle(.borderless)
                    .transition(.opacity)
                    .popover(isPresented: $showPopover) {
                        NavigationStack {
                            ReminderEditScreen(reminder: reminder)
                                .frame(minWidth: 300, minHeight: 300)
                        }
                    }
                }
            }
            .onDrag {
                reminder.itemProvider
            }
            .contentShape(Rectangle())
            .onTapGesture {
                selectedReminderId = reminder.persistentModelID
            }
//            .swipeActions {
//                Button("Test") {
//                    
//                }
//            }
        }
        
    private func handleCirclePress() {
        // Jesli ukonczone po prostu odznacz
        if reminder.isCompleted {
            reminder.isCompleted = false
            return
        }
        
        // Jesli timer juz uruchomiony, anuluj go i zresetuj
        if isCompletionInProgress {
            cancelCompletionTimer()
            return
        }
        
        // Rozpocznij timer odliczajacy np 2 sek
        isCompletionInProgress = true
        completionProgress = 0
        
        // Utworz timer, ktory aktualizuje progess co np 0.05 sek
        completionTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if completionProgress >= 1.0 {
                // Gdy czas uplynie, oznacz jako wykonane
                reminder.isCompleted = true
                print("isCompleted dla \(reminder.title): \(reminder.isCompleted)")
                cancelCompletionTimer()
            } else {
                // Zwieksz postep ( 2 sek = 40 czynnosci po 0.05sek )
                completionProgress += 0.025
            }
        }
    }
    
    private func cancelCompletionTimer() {
        completionTimer?.invalidate()
        completionTimer = nil
        isCompletionInProgress = false
        completionProgress = 0
    }
    
    private func saveTitle() {
        reminder.title = tempTitle
        try? modelContext.save()
    }
}

struct ReminderRowViewContainer: View {

    @Query private var reminders: [Reminder]
    @State private var selectedReminderId: PersistentIdentifier? = nil

    var body: some View {
        ReminderRowView(reminder: reminders[0], selectedReminderId: $selectedReminderId)
    }
}

#Preview { @MainActor in
    ReminderRowViewContainer()
        .modelContainer(mockPreviewConteiner)
}
