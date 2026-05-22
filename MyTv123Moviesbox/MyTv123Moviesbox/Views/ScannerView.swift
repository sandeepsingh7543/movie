//
//  ScannerView.swift
//  MyTv123Moviesbox
//
//  Created by Mobi iOS on 28/10/25.
//
import Foundation
import SwiftUI
import VisionKit
import Vision
import CoreImage
import PhotosUI
import UIKit

class AppEnvironmentManager: ObservableObject {
    static let shared = AppEnvironmentManager()
    
    @Published var currentSection: Int = 0
    @Published var isTabViewVisible: Bool = true
    @Published var selectedTheme: AppTheme = .aurora
    @Published var isFirstLaunch: Bool = true
    
    enum AppTheme: String, CaseIterable {
        case aurora = "Aurora"
        case midnight = "Midnight"
        case sunset = "Sunset"
        case ocean = "Ocean"
        
        var primaryColors: [Color] {
            switch self {
            case .aurora:
                return [Color.purple, Color.blue, Color.pink]
            case .midnight:
                return [Color.black, Color.gray, Color.blue]
            case .sunset:
                return [Color.orange, Color.red, Color.yellow]
            case .ocean:
                return [Color.blue, Color.teal, Color.cyan]
            }
        }
        
        var backgroundGradient: LinearGradient {
            LinearGradient(
                gradient: Gradient(colors: primaryColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private init() {
        loadSettings()
    }
    
    func hideTabView() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isTabViewVisible = false
        }
    }
    
    func showTabView() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isTabViewVisible = true
        }
    }
    
    func changeTheme(_ theme: AppTheme) {
        withAnimation(.easeInOut(duration: 0.5)) {
            selectedTheme = theme
        }
        saveSettings()
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(selectedTheme.rawValue, forKey: "SelectedTheme")
        UserDefaults.standard.set(false, forKey: "IsFirstLaunch")
    }
    
    private func loadSettings() {
        if let themeString = UserDefaults.standard.string(forKey: "SelectedTheme"),
           let theme = AppTheme(rawValue: themeString) {
            selectedTheme = theme
        }
        isFirstLaunch = UserDefaults.standard.bool(forKey: "IsFirstLaunch")
    }
}

import Foundation
import SwiftUI
import VisionKit
import Vision
import CoreImage
import PhotosUI
import UIKit

struct ScannerView: View {
    @StateObject private var appEnvironment = AppEnvironmentManager.shared
    @State private var showingScanner = false
    @State private var showingImagePicker = false
    @State private var scannedImage: UIImage?
    @State private var isProcessing = false
    @State private var showingTips = false
    @State private var showingShareSheet = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Scanned Image Display
                imageDisplaySection
                
                // Action Buttons
                actionButtonsSection
                
                // Tips Section
                tipsSection
            }
            .padding(.bottom, 100)
        }
    }
    
    private var imageDisplaySection: some View {
        VStack(spacing: 16) {
            if let image = scannedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.1)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .contextMenu {
                        Button(action: saveImageToGallery) {
                            Label("Save to Gallery", systemImage: "square.and.arrow.down")
                        }
                        Button(action: { showingShareSheet = true }) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    }
            } else {
                emptyStateView
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: appEnvironment.selectedTheme.primaryColors),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .opacity(0.3)
                
                Image(systemName: "doc.viewfinder")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Text("Ready to Scan")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text("Capture documents with professional quality")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(height: 300)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            // Primary Actions
            HStack(spacing: 12) {
                ScannerActionButton(
                    title: "Scan",
                    icon: "doc.viewfinder",
                    color: appEnvironment.selectedTheme.primaryColors.first ?? .blue
                ) {
                    showingScanner = true
                }
                
                ScannerActionButton(
                    title: "Upload",
                    icon: "photo.on.rectangle",
                    color: .green
                ) {
                    showingImagePicker = true
                }
            }
            
            if scannedImage != nil {
                // Processing Action
                ScannerActionButton(
                    title: "Convert to Scan",
                    icon: "wand.and.stars",
                    color: .purple,
                    fullWidth: true
                ) {
                    processImage()
                }
                
                // Secondary Actions
                HStack(spacing: 12) {
                    ScannerActionButton(
                        title: "Download",
                        icon: "square.and.arrow.down",
                        color: .blue
                    ) {
                        saveImageToGallery()
                    }
                    
                    ScannerActionButton(
                        title: "Share",
                        icon: "square.and.arrow.up",
                        color: .orange
                    ) {
                        showingShareSheet = true
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var tipsSection: some View {
        Button(action: {
            showingTips = true
        }) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.yellow)
                
                Text("Scanning Tips")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $showingScanner) {
            DocumentScannerView(scannedImage: $scannedImage, isProcessing: $isProcessing)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePickerScanner(image: $scannedImage)
        }
        .sheet(isPresented: $showingTips) {
            ScanningTipsView()
        }
        .sheet(isPresented: $showingShareSheet) {
            if let image = scannedImage {
                ShareSheet(items: [image])
            }
        }
        .overlay {
            if isProcessing {
                processingOverlay
            }
        }
        .alert("Scanner", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var processingOverlay: some View {
        Color.black.opacity(0.6)
            .ignoresSafeArea()
            .overlay {
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.2)
                        .tint(.white)
                    
                    Text("Processing...")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                )
            }
    }
    
    private func processImage() {
        guard let image = scannedImage else { return }
        isProcessing = true
        
        processImageForScan(image) { processedImage in
            DispatchQueue.main.async {
                if let processedImage = processedImage {
                    self.scannedImage = processedImage
                    self.alertMessage = "Image successfully converted to scan format!"
                } else {
                    self.alertMessage = "Failed to process image. Please try again."
                }
                self.isProcessing = false
                self.showAlert = true
            }
        }
    }
    
    private func processImageForScan(_ image: UIImage, completion: @escaping (UIImage?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        let request = VNDetectRectanglesRequest { request, error in
            if let error = error {
                print("Rectangle detection error: \(error.localizedDescription)")
                let processedImage = self.applyScanEffect(to: image)
                completion(processedImage)
                return
            }
            
            guard let observations = request.results as? [VNRectangleObservation],
                  let observation = observations.first else {
                let processedImage = self.applyScanEffect(to: image)
                completion(processedImage)
                return
            }
            
            let ciImage = CIImage(cgImage: cgImage)
            let perspectiveFilter = CIFilter(name: "CIPerspectiveCorrection")
            perspectiveFilter?.setValue(ciImage, forKey: kCIInputImageKey)
            
            let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
            let topLeft = CGPoint(x: observation.topLeft.x * imageSize.width,
                                y: observation.topLeft.y * imageSize.height)
            let topRight = CGPoint(x: observation.topRight.x * imageSize.width,
                                 y: observation.topRight.y * imageSize.height)
            let bottomLeft = CGPoint(x: observation.bottomLeft.x * imageSize.width,
                                   y: observation.bottomLeft.y * imageSize.height)
            let bottomRight = CGPoint(x: observation.bottomRight.x * imageSize.width,
                                    y: observation.bottomRight.y * imageSize.height)
            
            perspectiveFilter?.setValue(CIVector(cgPoint: topLeft), forKey: "inputTopLeft")
            perspectiveFilter?.setValue(CIVector(cgPoint: topRight), forKey: "inputTopRight")
            perspectiveFilter?.setValue(CIVector(cgPoint: bottomLeft), forKey: "inputBottomLeft")
            perspectiveFilter?.setValue(CIVector(cgPoint: bottomRight), forKey: "inputBottomRight")
            
            if let outputImage = perspectiveFilter?.outputImage,
               let correctedCGImage = CIContext().createCGImage(outputImage, from: outputImage.extent) {
                let processedImage = self.applyScanEffect(to: UIImage(cgImage: correctedCGImage))
                completion(processedImage)
            } else {
                let processedImage = self.applyScanEffect(to: image)
                completion(processedImage)
            }
        }
        
        request.minimumAspectRatio = 0.3
        request.maximumAspectRatio = 3.0
        request.minimumSize = 0.2
        request.maximumObservations = 1
        request.quadratureTolerance = 20
        
        do {
            try VNImageRequestHandler(cgImage: cgImage, options: [:]).perform([request])
        } catch {
            print("Failed to perform rectangle detection: \(error.localizedDescription)")
            let processedImage = applyScanEffect(to: image)
            completion(processedImage)
        }
    }
    
    private func applyScanEffect(to image: UIImage) -> UIImage {
        guard let ciImage = CIImage(image: image) else { return image }
        
        let context = CIContext()
        let grayscaleFilter = CIFilter(name: "CIColorControls")
        grayscaleFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        grayscaleFilter?.setValue(0.0, forKey: kCIInputSaturationKey)
        grayscaleFilter?.setValue(1.1, forKey: kCIInputContrastKey)
        grayscaleFilter?.setValue(0.1, forKey: kCIInputBrightnessKey)
        
        if let outputImage = grayscaleFilter?.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        
        return image
    }
    
    private func saveImageToGallery() {
        guard let image = scannedImage else { return }
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    alertMessage = "Image saved successfully to your gallery."
                    showAlert = true
                }
            }
        }
    }
}

struct ScannerActionButton: View {
    let title: String
    let icon: String
    let color: Color
    var fullWidth: Bool = false
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, fullWidth ? 24 : 16)
            .padding(.vertical, 12)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color, color.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct ScanningTipsView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(scanningTips, id: \.title) { tip in
                        TipCard(tip: tip)
                    }
                }
                .padding(20)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0.9),
                        Color.purple.opacity(0.3)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationTitle("Scanning Tips")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var scanningTips: [ScanTip] {
        [
            ScanTip(icon: "lightbulb.fill", title: "Good Lighting", description: "Ensure the document is well-lit for better results"),
            ScanTip(icon: "hand.raised.fill", title: "Steady Hand", description: "Hold the camera steady and parallel to the document"),
            ScanTip(icon: "rectangle.fill", title: "Clear Background", description: "Place the document on a contrasting background"),
            ScanTip(icon: "viewfinder", title: "Full Frame", description: "Make sure the entire document is visible in the frame")
        ]
    }
}

struct ScanTip {
    let icon: String
    let title: String
    let description: String
}

struct TipCard: View {
    let tip: ScanTip
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: tip.icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(tip.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Text(tip.description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// Supporting Views
struct DocumentScannerView: UIViewControllerRepresentable {
    @Binding var scannedImage: UIImage?
    @Binding var isProcessing: Bool
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let parent: DocumentScannerView
        
        init(_ parent: DocumentScannerView) {
            self.parent = parent
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let image = scan.imageOfPage(at: 0)
            parent.scannedImage = image
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

import SwiftUI

struct ImagePickerScanner: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePickerScanner
        
        init(_ parent: ImagePickerScanner) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ScannerView()
        .background(Color.purple)
}
