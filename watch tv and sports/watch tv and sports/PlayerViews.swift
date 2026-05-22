import SwiftUI

struct PlayerListView: View {
    @EnvironmentObject var store: AppStore
    @State private var search = ""
    @State private var showAdd = false
    @State private var showFavOnly = false

    var filtered: [Player] {
        store.players
            .filter { showFavOnly ? $0.isFavorite : true }
            .filter { search.isEmpty || $0.name.localizedCaseInsensitiveContains(search) || $0.sport.localizedCaseInsensitiveContains(search) }
            .sorted { $0.createdAt > $1.createdAt }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                Group {
                    if filtered.isEmpty {
                        VStack(spacing: 14) {
                            Image(systemName: "person.3")
                                .font(.system(size: 50))
                                .foregroundColor(.cyan.opacity(0.5))
                            Text("No Players").font(.headline).foregroundColor(.white)
                            Text("Tap + to add a player profile").font(.caption).foregroundColor(.gray)
                        }
                    } else {
                        List {
                            ForEach(filtered) { player in
                                NavigationLink(destination: PlayerDetailView(player: player)) {
                                    PlayerRowView(player: player)
                                }
                                .listRowBackground(Color(hex: "1c1c1e"))
                            }
                            .onDelete { idx in
                                idx.forEach { store.deletePlayer(filtered[$0]) }
                            }
                        }
                        .listStyle(.insetGrouped)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle("Players")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .searchable(text: $search, prompt: "Search players...")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { showFavOnly.toggle() } label: {
                        Image(systemName: showFavOnly ? "star.fill" : "star").foregroundColor(.yellow)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showAdd = true } label: {
                        Image(systemName: "plus").foregroundColor(.cyan)
                    }
                }
            }
            .sheet(isPresented: $showAdd) { PlayerFormView() }
        }
    }
}

struct PlayerRowView: View {
    @EnvironmentObject var store: AppStore
    let player: Player

    var body: some View {
        HStack(spacing: 12) {
            Group {
                if let data = player.imageData, let ui = UIImage(data: data) {
                    Image(uiImage: ui).resizable().scaledToFill()
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable().foregroundColor(.cyan.opacity(0.6))
                }
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(player.name).font(.headline).foregroundColor(.white)
                    if player.isFavorite { Image(systemName: "star.fill").foregroundColor(.yellow).font(.caption) }
                }
                Text("\(player.sport) • \(player.team)").font(.caption).foregroundColor(.gray)
                if !player.position.isEmpty {
                    Text(player.position).font(.caption2).foregroundColor(.gray.opacity(0.7))
                }
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct PlayerDetailView: View {
    @EnvironmentObject var store: AppStore
    let player: Player
    @State private var showEdit = false

    var current: Player { store.players.first(where: { $0.id == player.id }) ?? player }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Group {
                        if let data = current.imageData, let ui = UIImage(data: data) {
                            Image(uiImage: ui).resizable().scaledToFill()
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable().foregroundColor(.cyan.opacity(0.5))
                        }
                    }
                    .frame(width: 110, height: 110)
                    .clipShape(Circle())
                    .shadow(color: .cyan.opacity(0.4), radius: 10)
                    .padding(.top)

                    Text(current.name).font(.title2.bold()).foregroundColor(.white)

                    VStack(spacing: 0) {
                        infoRow("Sport", current.sport, "sportscourt")
                        Divider().background(Color.gray.opacity(0.3))
                        infoRow("Team", current.team, "person.3")
                        Divider().background(Color.gray.opacity(0.3))
                        infoRow("Position", current.position, "figure.run")
                        Divider().background(Color.gray.opacity(0.3))
                        infoRow("Nationality", current.nationality, "flag")
                        Divider().background(Color.gray.opacity(0.3))
                        infoRow("Age", current.age, "calendar")
                    }
                    .background(Color(hex: "1c1c1e"))
                    .cornerRadius(14)
                    .padding(.horizontal)

                    if !current.stats.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Match Stats & Notes", systemImage: "chart.bar")
                                .font(.headline).foregroundColor(.white)
                            Text(current.stats).font(.body).foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(hex: "1c1c1e"))
                        .cornerRadius(14)
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .navigationTitle(current.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button { store.toggleFavoritePlayer(current) } label: {
                        Image(systemName: current.isFavorite ? "star.fill" : "star").foregroundColor(.yellow)
                    }
                    Button { showEdit = true } label: { Image(systemName: "pencil").foregroundColor(.cyan) }
                }
            }
        }
        .sheet(isPresented: $showEdit) { PlayerFormView(player: current) }
    }

    func infoRow(_ label: String, _ value: String, _ icon: String) -> some View {
        HStack {
            Label(label, systemImage: icon).foregroundColor(.gray).font(.subheadline)
            Spacer()
            Text(value.isEmpty ? "—" : value).font(.subheadline).foregroundColor(.white)
        }
        .padding(.horizontal).padding(.vertical, 10)
    }
}

struct PlayerFormView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) var dismiss

    var player: Player?

    @State private var name = ""
    @State private var sport = ""
    @State private var team = ""
    @State private var position = ""
    @State private var nationality = ""
    @State private var age = ""
    @State private var stats = ""
    @State private var imageData: Data?
    @State private var showPicker = false

    var isEdit: Bool { player != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("Photo") {
                    HStack {
                        Spacer()
                        Button { showPicker = true } label: {
                            Group {
                                if let data = imageData, let ui = UIImage(data: data) {
                                    Image(uiImage: ui).resizable().scaledToFill()
                                } else {
                                    Image(systemName: "person.crop.circle.badge.plus")
                                        .resizable().foregroundColor(.cyan)
                                }
                            }
                            .frame(width: 90, height: 90)
                            .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(.vertical, 6)
                    .listRowBackground(Color(hex: "1c1c1e"))
                }

                Section("Basic Info") {
                    TextField("Player Name *", text: $name)
                    TextField("Sport (e.g. Cricket, Football)", text: $sport)
                    TextField("Team", text: $team)
                    TextField("Position / Role", text: $position)
                    TextField("Nationality", text: $nationality)
                    TextField("Age", text: $age).keyboardType(.numberPad)
                }
                .listRowBackground(Color(hex: "1c1c1e"))

                Section("Match Stats & Notes") {
                    TextEditor(text: $stats)
                        .frame(minHeight: 80)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .overlay(
                            Group {
                                if stats.isEmpty {
                                    Text("Add stats, performance notes...").foregroundColor(.gray).padding(4)
                                }
                            }, alignment: .topLeading
                        )
                }
                .listRowBackground(Color(hex: "1c1c1e"))
            }
            .scrollContentBackground(.hidden)
            .background(Color.black)
            .navigationTitle(isEdit ? "Edit Player" : "New Player")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .sheet(isPresented: $showPicker) { ImagePickerView(imageData: $imageData) }
            .onAppear { prefill() }
        }
    }

    func prefill() {
        guard let p = player else { return }
        name = p.name; sport = p.sport; team = p.team
        position = p.position; nationality = p.nationality
        age = p.age; stats = p.stats; imageData = p.imageData
    }

    func save() {
        var p = player ?? Player(name: "", sport: "", team: "", position: "", nationality: "", age: "", stats: "")
        p.name = name.trimmingCharacters(in: .whitespaces)
        p.sport = sport; p.team = team; p.position = position
        p.nationality = nationality; p.age = age; p.stats = stats
        p.imageData = imageData
        isEdit ? store.updatePlayer(p) : store.addPlayer(p)
        dismiss()
    }
}
