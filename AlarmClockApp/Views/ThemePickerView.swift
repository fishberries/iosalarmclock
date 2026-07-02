import SwiftUI

struct ThemePickerView: View {
    @ObservedObject var themeManager = ThemeManager.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Choose your theme") {
                    ForEach(AppTheme.allCases) { theme in
                        HStack {
                            Circle()
                                .fill(theme.accentColor)
                                .frame(width: 20, height: 20)
                            Text(theme.name)
                            Spacer()
                            if themeManager.currentTheme == theme {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            themeManager.setTheme(theme)
                        }
                    }
                }
            }
            .navigationTitle("Themes")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
