import ImageViewer
import Foundation
import Nuke
 
class GalleryDelegate: GalleryItemsDataSource {
    private let items: [GalleryItem]
    // 一応ギャラリーとしても使えるように複数のURL読み込みに対応してます。
    init(imageUrls: [String]) {
        items = imageUrls.map { URL(string: $0) }.compactMap { $0 }.map { imageUrl in
            GalleryItem.image { imageCompletion in
                // Nukeのモジュールで非同期に画像を読み込んでます。
                ImagePipeline.shared.loadImage(with: imageUrl, progress: nil, completion: { (response, error) in
                    imageCompletion(response?.image) // 読み込んだ画像をImageViewerに渡してます
                })
            }
        }
    }
    // 何個表示するか
    func itemCount() -> Int {
        return items.count
    }
    // 実際に表示する画像を指定
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return items[index]
    }
}
