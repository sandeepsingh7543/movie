import SwiftUI

// MARK: - Movie Detail View
struct MovieDetailView: View {
    let movie: Movie
    @StateObject private var vm = DetailViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackground.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    heroSection
                    detailContent
                }
            }
            .ignoresSafeArea(edges: .top)
            backButton
        }
        .navigationBarHidden(true)
        .onAppear { vm.load(movie: movie) }
    }

    // MARK: - Hero
    private var heroSection: some View {
        ZStack(alignment: .bottom) {
            posterHero
                .frame(height: 320)
                .clipped()

            LinearGradient(
                colors: [.clear, .appBackground],
                startPoint: .center, endPoint: .bottom
            )
            .frame(height: 200)
        }
        .frame(height: 320)
    }

    @ViewBuilder
    private var posterHero: some View {
        PosterImageView(url: movie.posterURL, width: UIScreen.main.bounds.width, height: 320)
    }

    // MARK: - Detail Content
    private var detailContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.appTitle)
                    .foregroundColor(.white)

                HStack(spacing: 16) {
                    Label(movie.ratingFormatted, systemImage: "star.fill")
                        .foregroundColor(.appGold)
                    Text(movie.releaseYear)
                        .foregroundColor(.appSecondary)
                }
                .font(.appCaption)
            }

            actionButtons

            VStack(alignment: .leading, spacing: 8) {
                Text("Overview")
                    .font(.appHeadline)
                    .foregroundColor(.white)
                Text(movie.overview.isEmpty ? "No overview available." : movie.overview)
                    .font(.appBody)
                    .foregroundColor(.appSecondary)
                    .lineSpacing(4)
            }

            Spacer(minLength: 40)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    // MARK: - Action Buttons
    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button {
                haptic(.medium)
                vm.toggleWatchlist(movie: movie)
            } label: {
                Label(
                    vm.isInWatchlist ? "In Watchlist" : "Watchlist",
                    systemImage: vm.isInWatchlist ? "checkmark" : "plus"
                )
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(vm.isInWatchlist ? Color.appAccent : Color.appSurface)
                .cornerRadius(10)
            }
            .pressEffect()
            .animation(.spring(response: 0.3), value: vm.isInWatchlist)

            Button {
                haptic(.medium)
                vm.toggleFavorite(movie: movie)
            } label: {
                Image(systemName: vm.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 18))
                    .foregroundColor(vm.isFavorite ? .appAccent : .white)
                    .frame(width: 48, height: 48)
                    .background(Color.appSurface)
                    .cornerRadius(10)
            }
            .pressEffect()
            .animation(.spring(response: 0.3), value: vm.isFavorite)
        }
    }

    // MARK: - Back Button
    private var backButton: some View {
        Button {
            haptic(.light)
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
        .padding(.leading, 16)
        .padding(.top, 56)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
