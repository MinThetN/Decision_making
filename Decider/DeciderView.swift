//
//  ContentView.swift
//  Decider
//
//  Created by Min Thet Naung on 19/08/2025.
//

import SwiftUI

struct DeciderView: View {
    @State private var selectedCategory: Category?
    @State private var options: [Option] = []
    @State private var isDeciding = false
    @State private var selectedOption: Option?
    @State private var showResult = false
    @State private var decisions: [Decision] = []
    @State private var showCustomInput = false
    @State private var customOptionText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    if selectedCategory == nil {
                        categorySelectionView
                    } else if !showResult {
                        decisionView
                    } else {
                        resultView
                    }
                }
                .padding()
            }
            .navigationTitle("Decider")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showCustomInput) {
            customInputView
        }
    }
    
    // MARK: - Category Selection View
    private var categorySelectionView: some View {
        VStack(spacing: 30) {
            Text("What do you need help deciding?")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
                ForEach(CategoryData.categories) { category in
                    CategoryCard(category: category) {
                        selectCategory(category)
                    }
                }
            }
            
            if !decisions.isEmpty {
                Button("View History") {
                    // TODO: Implement history view
                }
                .foregroundColor(.secondary)
            }
        }
    }
    
    // MARK: - Decision View
    private var decisionView: some View {
        VStack(spacing: 30) {
            HStack {
                Button("← Back") {
                    selectedCategory = nil
                    options = []
                }
                .foregroundColor(.blue)
                
                Spacer()
                
                Text(selectedCategory?.name ?? "")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("+ Add") {
                    showCustomInput = true
                }
                .foregroundColor(.blue)
            }
            
            if options.isEmpty {
                Text("No options available")
                    .foregroundColor(.secondary)
            } else {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
                        ForEach(options) { option in
                            OptionCard(option: option, isSelected: false)
                        }
                    }
                }
                
                Button(action: startDecision) {
                    HStack {
                        Image(systemName: "sparkles")
                        Text("Decide for Me!")
                        Image(systemName: "sparkles")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: [selectedCategory?.color ?? .blue, (selectedCategory?.color ?? .blue).opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(15)
                }
                .disabled(isDeciding)
            }
        }
    }
    
    // MARK: - Result View
    private var resultView: some View {
        VStack(spacing: 30) {
            Text("🎉")
                .font(.system(size: 60))
                .scaleEffect(showResult ? 1.2 : 0.8)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showResult)
            
            Text("Your choice is...")
                .font(.title2)
                .foregroundColor(.secondary)
            
            if let selected = selectedOption {
                Text(selected.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(selectedCategory?.color ?? .blue)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill((selectedCategory?.color ?? .blue).opacity(0.1))
                    )
                    .scaleEffect(showResult ? 1.0 : 0.5)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.3), value: showResult)
            }
            
            HStack(spacing: 20) {
                Button("Decide Again") {
                    resetForNewDecision()
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
                Button("New Category") {
                    resetToCategories()
                }
                .padding()
                .background((selectedCategory?.color ?? .blue).opacity(0.2))
                .cornerRadius(10)
            }
        }
    }
    
    // MARK: - Custom Input View
    private var customInputView: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Add Custom Option")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                TextField("Enter your option...", text: $customOptionText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Add Option") {
                    addCustomOption()
                }
                .disabled(customOptionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding()
                .frame(maxWidth: .infinity)
                .background(customOptionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray.opacity(0.3) : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Custom Option")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    showCustomInput = false
                    customOptionText = ""
                }
            )
        }
    }
    
    // MARK: - Helper Functions
    private func selectCategory(_ category: Category) {
        selectedCategory = category
        options = category.defaultOptions.map { Option(name: $0, category: category.name) }
    }
    
    private func startDecision() {
        isDeciding = true
        
        // Simulate decision animation delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            selectedOption = options.randomElement()
            
            if let selected = selectedOption, let category = selectedCategory {
                let decision = Decision(
                    selectedOption: selected,
                    allOptions: options,
                    timestamp: Date(),
                    category: category.name
                )
                decisions.append(decision)
            }
            
            isDeciding = false
            showResult = true
        }
    }
    
    private func addCustomOption() {
        let trimmedText = customOptionText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedText.isEmpty {
            let newOption = Option(
                name: trimmedText,
                category: selectedCategory?.name ?? "",
                isCustom: true
            )
            options.append(newOption)
            customOptionText = ""
            showCustomInput = false
        }
    }
    
    private func resetForNewDecision() {
        selectedOption = nil
        showResult = false
    }
    
    private func resetToCategories() {
        selectedCategory = nil
        selectedOption = nil
        showResult = false
        options = []
    }
}

// MARK: - Category Card Component
struct CategoryCard: View {
    let category: Category
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                Image(systemName: category.icon)
                    .font(.system(size: 30))
                    .foregroundColor(category.color)
                
                Text(category.name)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(category.color.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(category.color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Option Card Component
struct OptionCard: View {
    let option: Option
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Text(option.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(height: 80)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    DeciderView()
}
