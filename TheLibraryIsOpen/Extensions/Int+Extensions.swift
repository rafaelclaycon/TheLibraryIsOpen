import Foundation

extension Int {

    func toFormattedFileSize() -> String {
        guard self > 0 else {
            return "Tamanho não informado pelo autor"
        }
        return "\(ByteCountFormatter.string(fromByteCount: Int64(self), countStyle: .file))"
    }

}
