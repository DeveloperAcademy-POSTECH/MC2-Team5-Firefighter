//
//  PhotoPickerManager.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/27.
//

import AVFoundation
import Combine
import PhotosUI
import UIKit

final class PhotoPickerManager: NSObject {

    // MARK: - property

    private var authorizationStatus: PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus(for: .addOnly)
    }

    var loadImage: ((Result<UIImage, PHPickerError>) -> Void)?

    weak var viewController: UIViewController?

    // MARK: - func

    func openPhotos() {
        switch self.authorizationStatus {
        case .notDetermined:
            self.requestAuthorizationToPHPhotoLibrary()
        case .authorized:
            self.phPickerControllerDidShow()
        default:
            self.openSettings()
        }
    }

    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            self.loadImage?(.failure(.cantloadDevice))
            return
        }

        AVCaptureDevice.requestAccess(for: .video) { [weak self] hasGranted in
            DispatchQueue.main.async {
                hasGranted ? self?.imagePickerControllerDidShow() : self?.openSettings()
            }
        }
    }
}

extension PhotoPickerManager {

    // MARK: - Private - func

    private func requestAuthorizationToPHPhotoLibrary() {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] authorizationStatus in
            if authorizationStatus == .authorized {
                self?.phPickerControllerDidShow()
            } else {
                self?.loadImage?(.failure(.deniedAuthorization))
            }
        }
    }

    private func phPickerControllerDidShow() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images, .livePhotos])

        DispatchQueue.main.async {
            let phPickerController = PHPickerViewController(configuration: configuration)
            phPickerController.delegate = self
            self.viewController?.present(phPickerController, animated: true)
        }
    }

    private func openSettings() {
        let settingAction: ((UIAlertAction) -> Void)? = { [weak self] _ in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
                self?.loadImage?(.failure(.cantOpenSetting))
                return
            }
            UIApplication.shared.open(settingURL)
        }

        DispatchQueue.main.async {
            self.viewController?.makeRequestAlert(title: TextLiteral.Common.Error.title.localized(),
                                                  message: TextLiteral.SendLetter.Error.authorizationMessage.localized(with: Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "애니또"),
                                                  okTitle: TextLiteral.SendLetter.Error.buttonSetting.localized(),
                                                  okStyle: .default,
                                                  okAction: settingAction)
        }
    }

    private func imagePickerControllerDidShow() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera

        DispatchQueue.main.async {
            self.viewController?.present(imagePickerController, animated: true)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension PhotoPickerManager: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.loadImage?(.success(image))
        } else {
            self.loadImage?(.failure(.cantloadPhoto))
        }
    }
}

// MARK: - PHPickerViewControllerDelegate
extension PhotoPickerManager: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let selectedAsset = results.first?.itemProvider {
            self.pickerController(picker, didFinishPicking: selectedAsset)
        } else {
            self.pickerControllerDidCancel(picker)
        }
    }

    private func pickerControllerDidCancel(_ picker: PHPickerViewController) {
        DispatchQueue.main.async {
            picker.dismiss(animated: true)
        }
    }

    private func pickerController(_ picker: PHPickerViewController, didFinishPicking asset: NSItemProvider) {
        self.loadObject(for: asset) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    picker.dismiss(animated: true, completion: {
                        self?.loadImage?(.success(image))
                    })
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    picker.dismiss(animated: true, completion: {
                        self?.loadImage?(.failure(error))
                    })
                }
            }
        }
    }

    private func loadObject(for itemProvider: NSItemProvider,
                             completionHandler: @escaping ((Result<UIImage, PHPickerError>) -> ())) {
        guard itemProvider.canLoadObject(ofClass: UIImage.self) else { completionHandler(.failure(.cantloadPhoto))
            return
        }

        itemProvider.loadObject(ofClass: UIImage.self) { image, error in
            if error != nil {
                completionHandler(.failure(.cantloadPhoto))
            }

            if let image = image as? UIImage {
                completionHandler(.success(image))
            }
        }
    }
}
