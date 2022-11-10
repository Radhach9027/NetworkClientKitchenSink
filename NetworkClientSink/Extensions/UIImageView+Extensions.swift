import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }

    func bgLoad(url: URL) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    let image: UIImage? = UIImage(data: data)
                    self.image = image
                }
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }
    }

    func loadFromDirectory(path: String) {
        if let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsUrl.appendingPathComponent(path)
            do {
                let imageData = try Data(contentsOf: fileURL)
                image = UIImage(data: imageData)
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }
    }
}
