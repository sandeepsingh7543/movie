import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.starmaxPalette) private var palette

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Privacy Policy")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(palette.textPrimary)

                    policyParagraph("Starmax stores all movie data locally on your device using on-device persistence and file storage.")
                    policyParagraph("The app does not use external movie APIs, tracking SDKs, analytics SDKs, or network-based data collection.")
                    policyParagraph("Poster images are saved only after you choose them from your device library. They remain on-device unless you delete them or reset the app.")
                    policyParagraph("No account is required. No personal data is transmitted off-device.")
                    policyParagraph("If you delete the app or reset data, local records and posters are removed from your device.")
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
            .background(StarmaxBackground().ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func policyParagraph(_ text: String) -> some View {
        Text(text)
            .foregroundStyle(palette.textSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .starmaxCard()
    }
}
