import SwiftUI

let videoCategories = ["Match", "Highlight", "Clip", "Interview", "Training", "Other"]

struct VideoLibraryView: View {
    @EnvironmentObject var store: AppStore
    @State private var search = ""
    @State private var showAdd = false
    @State private var showFavOnly = false
    @State private var selectedCategory = "All"

    var categories: [String] { ["All"] + videoCategories }

    var filtered: [SportVideo] {
        store.videos
            .filter { showFavOnly ? $0.isFavorite : true }
            .filter { selectedCategory == "All" || $0.category == selectedCategory }
            .filter { search.isEmpty || $0.title.localizedCaseInsensitiveContains(search) || $0.category.localizedCaseInsensitiveContains(search) }
            .sorted { $0.createdAt > $1.createdAt }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Category filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.self) { cat in
                                Button(cat) { selectedCategory = cat }
                                    .font(.caption.bold())
                                    .padding(.horizontal, 14).padding(.vertical, 7)
                                    .background(selectedCategory == cat ? Color.cyan : Color(hex: "1c1c1e"))
                                    .foregroundColor(selectedCategory == cat ? .black : .white)
                                    .cornerRadius(20)
                                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.cyan.opacity(0.3), lineWidth: selectedCategory == cat ? 0 : 1))
                            }
                        }
                        .padding(.horizontal).padding(.vertical, 8)
                    }

                    Group {
                        if filtered.isEmpty {
                            VStack(spacing: 14) {
                                Spacer()
                                Image(systemName: "play.rectangle")
                                    .font(.system(size: 50))
                                    .foregroundColor(.purple.opacity(0.5))
                                Text("No Videos").font(.headline).foregroundColor(.white)
                                Text("Tap + to add a video to your library")
                                    .font(.caption).foregroundColor(.gray)
                                Spacer()
                            }
                        } else {
                            List {
                                ForEach(filtered) { video in
                                    NavigationLink(destination: VideoDetailView(video: video)) {
                                        VideoRowView(video: video)
                                    }
                                    .listRowBackground(Color(hex: "1c1c1e"))
                                }
                                .onDelete { idx in
                                    idx.forEach { store.deleteVideo(filtered[$0]) }
                                }
                            }
                            .listStyle(.insetGrouped)
                            .scrollContentBackground(.hidden)
                        }
                    }
                }
            }
            .navigationTitle("Video Library")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .searchable(text: $search, prompt: "Search videos...")
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
            .sheet(isPresented: $showAdd) { VideoFormView() }
        }
    }
}

struct VideoRowView: View {
    let video: SportVideo

    var body: some View {
        HStack(spacing: 12) {
            Group {
                if let data = video.thumbnailData, let ui = UIImage(data: data) {
                    Image(uiImage: ui).resizable().scaledToFill()
                } else {
                    ZStack {
                        Color(hex: "1a1a2e")
                        Image(systemName: "play.rectangle.fill").foregroundColor(.purple).font(.title2)
                    }
                }
            }
            .frame(width: 70, height: 50)
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(video.title).font(.headline).foregroundColor(.white).lineLimit(1)
                    if video.isFavorite { Image(systemName: "star.fill").foregroundColor(.yellow).font(.caption) }
                }
                HStack {
                    Text(video.category)
                        .font(.caption2).padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color.purple.opacity(0.25)).cornerRadius(8).foregroundColor(.purple)
                    if !video.url.isEmpty {
                        Image(systemName: "link").font(.caption2).foregroundColor(.gray)
                    }
                }
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct VideoDetailView: View {
    @EnvironmentObject var store: AppStore
    let video: SportVideo
    @State private var showEdit = false

    var current: SportVideo { store.videos.first(where: { $0.id == video.id }) ?? video }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Group {
                        if let data = current.thumbnailData, let ui = UIImage(data: data) {
                            Image(uiImage: ui).resizable().scaledToFit()
                        } else {
                            ZStack {
                                Color(hex: "1a1a2e")
                                Image(systemName: "play.rectangle.fill").font(.system(size: 60)).foregroundColor(.purple)
                            }
                            .frame(height: 200)
                        }
                    }
                    .cornerRadius(14)
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 14) {
                        Text(current.title).font(.title3.bold()).foregroundColor(.white)

                        Text(current.category)
                            .font(.caption.bold()).padding(.horizontal, 12).padding(.vertical, 5)
                            .background(Color.purple.opacity(0.25)).cornerRadius(10).foregroundColor(.purple)

                        if !current.url.isEmpty {
                            infoBlock(icon: "link", title: "URL / Reference") {
                                Text(current.url).font(.caption).foregroundColor(.cyan).lineLimit(2)
                            }
                        }

                        if !current.notes.isEmpty {
                            infoBlock(icon: "note.text", title: "Notes") {
                                Text(current.notes).font(.body).foregroundColor(.gray)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
        }
        .navigationTitle(current.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button { store.toggleFavoriteVideo(current) } label: {
                        Image(systemName: current.isFavorite ? "star.fill" : "star").foregroundColor(.yellow)
                    }
                    Button { showEdit = true } label: { Image(systemName: "pencil").foregroundColor(.cyan) }
                }
            }
        }
        .sheet(isPresented: $showEdit) { VideoFormView(video: current) }
    }

    func infoBlock<Content: View>(icon: String, title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: icon).font(.subheadline.bold()).foregroundColor(.white)
            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "1c1c1e"))
        .cornerRadius(12)
    }
}

struct VideoFormView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) var dismiss

    var video: SportVideo?

    @State private var title = ""
    @State private var category = videoCategories[0]
    @State private var url = ""
    @State private var notes = ""
    @State private var thumbnailData: Data?
    @State private var showPicker = false

    var isEdit: Bool { video != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("Thumbnail") {
                    HStack {
                        Spacer()
                        Button { showPicker = true } label: {
                            Group {
                                if let data = thumbnailData, let ui = UIImage(data: data) {
                                    Image(uiImage: ui).resizable().scaledToFill()
                                } else {
                                    ZStack {
                                        Color(hex: "1a1a2e")
                                        Image(systemName: "photo.badge.plus").resizable()
                                            .scaledToFit().padding(20).foregroundColor(.purple)
                                    }
                                }
                            }
                            .frame(width: 120, height: 80).cornerRadius(10)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 4)
                    .listRowBackground(Color(hex: "1c1c1e"))
                }

                Section("Details") {
                    TextField("Video Title *", text: $title)
                    Picker("Category", selection: $category) {
                        ForEach(videoCategories, id: \.self) { Text($0) }
                    }
                    TextField("URL / Reference (optional)", text: $url)
                        .keyboardType(.URL).autocapitalization(.none)
                }
                .listRowBackground(Color(hex: "1c1c1e"))

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .overlay(
                            Group {
                                if notes.isEmpty {
                                    Text("Add notes about this video...").foregroundColor(.gray).padding(4)
                                }
                            }, alignment: .topLeading
                        )
                }
                .listRowBackground(Color(hex: "1c1c1e"))
            }
            .scrollContentBackground(.hidden)
            .background(Color.black)
            .navigationTitle(isEdit ? "Edit Video" : "New Video")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .sheet(isPresented: $showPicker) { ImagePickerView(imageData: $thumbnailData) }
            .onAppear { prefill() }
        }
    }

    func prefill() {
        guard let v = video else { return }
        title = v.title; category = v.category; url = v.url
        notes = v.notes; thumbnailData = v.thumbnailData
    }

    func save() {
        var v = video ?? SportVideo(title: "", category: videoCategories[0], notes: "", url: "")
        v.title = title.trimmingCharacters(in: .whitespaces)
        v.category = category; v.url = url; v.notes = notes
        v.thumbnailData = thumbnailData
        isEdit ? store.updateVideo(v) : store.addVideo(v)
        dismiss()
    }
}
