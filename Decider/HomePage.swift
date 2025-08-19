import SwiftUI

struct HomePage: View {
    @State private var showDecider = false
    @State private var animateTitle = false
    @State private var animateSubtitle = false
    @State private var animateButton = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color.purple.opacity(0.3),
                        Color.blue.opacity(0.4),
                        Color.cyan.opacity(0.2)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // App Icon/Logo
                    VStack(spacing: 20) {
                        Image(systemName: "questionmark.diamond.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.purple, .blue, .cyan],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .scaleEffect(animateTitle ? 1.0 : 0.5)
                            .animation(.spring(response: 0.8, dampingFraction: 0.6), value: animateTitle)
                        
                        Text("Decider")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .opacity(animateTitle ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.8).delay(0.3), value: animateTitle)
                    }
                    
                    // Subtitle
                    VStack(spacing: 15) {
                        Text("Can't decide what to choose?")
                            .font(.title2)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.primary)
                            .opacity(animateSubtitle ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.8).delay(0.6), value: animateSubtitle)
                        
                        Text("Let us help you make the perfect choice!")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .opacity(animateSubtitle ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.8).delay(0.8), value: animateSubtitle)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Features preview
                    VStack(spacing: 15) {
                        HStack(spacing: 20) {
                            FeatureIcon(icon: "fork.knife", color: .orange, text: "Food")
                            FeatureIcon(icon: "location.fill", color: .blue, text: "Places")
                            FeatureIcon(icon: "gamecontroller.fill", color: .green, text: "Activities")
                            FeatureIcon(icon: "tv.fill", color: .purple, text: "Entertainment")
                        }
                        .opacity(animateButton ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.8).delay(1.0), value: animateButton)
                    }
                    
                    Spacer()
                    
                    // Start Button
                    Button(action: {
                        showDecider = true
                    }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Start Deciding")
                            Image(systemName: "arrow.right")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 40)
                        .background(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .scaleEffect(animateButton ? 1.0 : 0.8)
                    .opacity(animateButton ? 1.0 : 0.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.2), value: animateButton)
                    
                    Spacer()
                }
                .padding()
            }
        }
        .fullScreenCover(isPresented: $showDecider) {
            DeciderView()
        }
        .onAppear {
            // Trigger animations on appear
            withAnimation {
                animateTitle = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    animateSubtitle = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation {
                    animateButton = true
                }
            }
        }
    }
}

// MARK: - Feature Icon Component
struct FeatureIcon: View {
    let icon: String
    let color: Color
    let text: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
        .frame(width: 60)
    }
}

#Preview {
    HomePage()
}
