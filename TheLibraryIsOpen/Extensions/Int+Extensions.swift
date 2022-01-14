import Foundation

extension Int {

    func toFormattedFileSize() -> String {
        // Only episodes with the wrong reported size will have less than a MB.
        guard self > 999999 else {
            return LocalizableStrings.sizeNotReportedByAuthor
        }
        return "\(ByteCountFormatter.string(fromByteCount: Int64(self), countStyle: .file))"
    }

}
