//
//  CreateLetterPhotoView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/13.
//

import AVFoundation
import PhotosUI
import UIKit

import SnapKit

final class CreateLetterPhotoView: UIView {

    typealias alertAction = ((UIAlertAction) -> ())
    
    private enum PHLibraryError: Error {
        case loadError

        var errorDescription: String {
            switch self {
            case .loadError:
                return TextLiteral.letterPhotoViewFail
            }
        }
    }

    private enum SourceType {
        case camera
        case library
    }

    
    // MARK: - ui component
    
    private let importPhotosButton: UIButton = {
        let button = UIButton()
        button.makeBorderLayer(color: .white)
        button.clipsToBounds = true
        button.setImage(ImageLiterals.btnCamera, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
        button.tintColor = .white
        button.backgroundColor = .darkGrey004
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.letterPhotoViewTitleLabel
        label.font = .font(.regular, ofSize: 16)
        return label
    }()

    // MARK: - property

    var sendHasImageValue: ((_ hasImage: Bool) -> ())?

    private var hasImage: Bool {
        return self.importPhotosButton.imageView?.image != ImageLiterals.btnCamera
    }
    var image: UIImage? {
        if self.importPhotosButton.imageView?.image == ImageLiterals.btnCamera { return nil }
        return self.importPhotosButton.imageView?.image
    }

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - func
    
    private func setupLayout() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        self.addSubview(self.importPhotosButton)
        self.importPhotosButton.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(17)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(209)
        }
    }
    
    private func setupButtonAction() {
        let photoAction = UIAction { [weak self] _ in
            self?.presentActionSheet(actionTitles: self?.actionTitles() ?? [],
                                     actionStyle: self?.actionStyle() ?? [],
                                     actions: self?.alertActions() ?? [])
        }
        self.importPhotosButton.addAction(photoAction, for: .touchUpInside)
    }

    private func actionTitles() -> [String] {
        return self.hasImage ? [TextLiteral.letterPhotoViewTakePhoto,
                                TextLiteral.letterPhotoViewChoosePhoto,
                                TextLiteral.letterPhotoViewDeletePhoto,
                                TextLiteral.cancel]
                             : [TextLiteral.letterPhotoViewTakePhoto,
                                TextLiteral.letterPhotoViewChoosePhoto,
                                TextLiteral.cancel]
    }

    private func actionStyle() -> [UIAlertAction.Style] {
        return self.hasImage ? [.default, .default, .default, .cancel] : [.default, .default, .cancel]
    }

    private func alertActions() -> [alertAction?] {
        let takePhotoAction: alertAction = { [weak self] _ in
            self?.openPickerAccordingTo(.camera)
        }
        let photoLibraryAction: alertAction = { [weak self] _ in
            self?.openPickerAccordingTo(.library)
        }
        let removePhotoAction: alertAction = { [weak self] _ in
            self?.importPhotosButton.setImage(ImageLiterals.btnCamera, for: .normal)
            self?.sendHasImageValue?(self?.hasImage ?? false)
        }

        return self.hasImage ? [takePhotoAction, photoLibraryAction, removePhotoAction, nil]
                             : [takePhotoAction, photoLibraryAction, nil]
    }

    private func presentActionSheet(message: String = TextLiteral.letterPhotoViewChoosePhotoToManitto,
                                    actionTitles: [String],
                                    actionStyle: [UIAlertAction.Style],
                                    actions: [alertAction?]) {
        self.viewController?.makeActionSheet(message: message,
                                             actionTitles: actionTitles,
                                             actionStyle: actionStyle,
                                             actions: actions)
    }
    
    private func openPickerAccordingTo(_ sourceType: SourceType) {
        switch sourceType {
        case .library:
            let authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .addOnly)
            self.checkPHPickerControllerAuthorizationStatus(authorizationStatus)
        case .camera:
            self.checkImagePickerControllerAccessRight()
        }
    }

    private func checkPHPickerControllerAuthorizationStatus(_ authorizationStatus: PHAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] authorizationStatus in
                if authorizationStatus == .authorized {
                    self?.phPickerControllerDidShow()
                }
            }
        case .authorized:
            self.phPickerControllerDidShow()
        default:
            self.openSettings()
        }
    }

    private func phPickerControllerDidShow() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images, .livePhotos])
        let phPickerController = PHPickerViewController(configuration: configuration)
        phPickerController.delegate = self

        DispatchQueue.main.async {
            self.viewController?.present(phPickerController, animated: true)
        }
    }
    
    private func openSettings() {
        let settingAction: alertAction = { [weak self] _ in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
                self?.viewController?.makeAlert(title: TextLiteral.letterPhotoViewErrorTitle,
                                                message: TextLiteral.letterPhotoViewSettingFail)
                return
            }
            UIApplication.shared.open(settingURL)
        }

        self.viewController?.makeRequestAlert(title: TextLiteral.letterPhotoViewSetting,
                                              message: TextLiteral.letterPhotoViewSettingAuthorization,
                                              okTitle: "설정",
                                              okStyle: .default,
                                              okAction: settingAction,
                                              completion: nil)
    }

    private func checkImagePickerControllerAccessRight() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            self.viewController?.makeAlert(title: TextLiteral.letterPhotoViewErrorTitle,
                                           message: TextLiteral.letterPhotoViewDeviceFail)
            return
        }

        AVCaptureDevice.requestAccess(for: .video) { [weak self] hasGranted in
            DispatchQueue.main.async {
                hasGranted ? self?.imagePickerControllerDidShow() : self?.openSettings()
            }
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
extension CreateLetterPhotoView: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            DispatchQueue.main.async {
                self.importPhotosButton.setImage(image, for: .normal)
                self.sendHasImageValue?(self.importPhotosButton.imageView?.image != ImageLiterals.btnCamera)
                picker.dismiss(animated: true)
            }
        }
    }
}

// MARK: - PHPickerViewControllerDelegate
extension CreateLetterPhotoView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let itemProvider = results.first?.itemProvider {
            self.loadUIImage(for: itemProvider) { [weak self] result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.importPhotosButton.setImage(image, for: .normal)
                        self?.sendHasImageValue?(self?.importPhotosButton.imageView?.image != ImageLiterals.btnCamera)
                        picker.dismiss(animated: true)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.viewController?.makeAlert(title: "", message: error.errorDescription, okAction: { _ in
                            picker.dismiss(animated: true)
                        })
                    }
                }
            }
        }
    }

    private func loadUIImage(for itemProvider: NSItemProvider, completionHandler: @escaping ((Result<UIImage, PHLibraryError>) -> ())) {
        guard itemProvider.canLoadObject(ofClass: UIImage.self) else { completionHandler(.failure(.loadError)); return }

        itemProvider.loadObject(ofClass: UIImage.self) { image, error in
            if error != nil {
                completionHandler(.failure(.loadError))
            }

            if let image = image as? UIImage {
                completionHandler(.success(image))
            }
        }
    }
}
