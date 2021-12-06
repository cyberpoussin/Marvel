//
//  ImageLoader.swift
//  Marvel
//
//  Created by Adrien S on 06/12/2021.
//

import Combine
import SwiftUI

class ImageLoaderViewModel: ObservableObject {
    let imageUrl: URL?
    var cancellable: AnyCancellable?
    @Published var uiImage: UIImage?
    @Published var progress: Double = 0
    func loadImage() {
        guard let imageUrl = imageUrl else {
            return
        }
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let imageInCache = cachesDirectory.appendingPathComponent(imageUrl.lastPathComponent)
        let path = imageInCache.path

        if FileManager.default.fileExists(atPath: path), let data = try? Data(contentsOf: imageInCache) {
            uiImage = UIImage(data: data)
            return
        }
        cancellable = URLSession.shared
            .downloadTaskPublisher(request: URLRequest(url: imageUrl))
            .map { $0 }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
            guard let (data, _, progress) = result else {
                self?.progress = 0
                return
            }
            guard let data = data else {
                print("data received", progress)
                withAnimation {
                    self?.progress = progress
                }
                return
            }
            self?.progress = 1
            self?.uiImage = UIImage(data: data)
            try? data.write(to: URL(fileURLWithPath: path))
        }
    }

    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
}

struct ImageLoader<Mask: Shape, PlaceHolder: View>: View {
    @ViewBuilder var placeHolder: () -> PlaceHolder
    var mask: Mask

    @State private var image: Image?
    @StateObject private var vm: ImageLoaderViewModel
    init(imageUrl: URL?, mask: Mask, placeHolder: @escaping () -> PlaceHolder) {
        _vm = StateObject(wrappedValue: ImageLoaderViewModel(imageUrl: imageUrl))
        self.placeHolder = placeHolder
        self.mask = mask
    }

    var body: some View {
        if let image = image {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(mask)
        } else {
            placeHolder()
                .overlay(
                    mask
                        .trim(from: 0, to: vm.progress)
                        .stroke(lineWidth: 10)
                        .rotationEffect(.degrees(180))
                        .foregroundColor(Color.button)
                        .padding(5)
                        .mask(mask)
                )
                .onAppear(perform: vm.loadImage)
                .onReceive(vm.$uiImage) { newUiImage in
                    guard let uiImage = newUiImage else { return }
                    image = Image(uiImage: uiImage)
                }
        }
    }
}

struct ImageLoader_Previews: PreviewProvider {
    static var previews: some View {
        ImageLoader(imageUrl: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/2/80/511a79a0451a3.jpg"), mask: Circle()) {
            Circle()
        }
        ImageLoader(imageUrl: URL(string: "https://images.unsplash.com/photo-1453733190371-0a9bedd82893?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=3264&q=80"), mask: Rectangle()) {
            Rectangle()
        }
    }
}
