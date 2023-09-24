//
//  SendLetterPhotoView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/13.
//

import AVFoundation
import Combine
import PhotosUI
import UIKit

import SnapKit

final class SendLetterPhotoView: UIView {

    typealias AlertAction = ((UIAlertAction) -> ())
    typealias ActionDetail = (message: String,
                              titles: [String],
                              styles: [UIAlertAction.Style],
                              actions: [((UIAlertAction) -> Void)?])

    private enum SourceType {
        case camera
        case library
    }
    
    // MARK: - ui component
    
    private let importPhotosButton: UIButton = {
        let button = UIButton()
        button.makeBorderLayer(color: .white)
        button.clipsToBounds = true
        button.setImage(UIImage.Button.camera, for: .normal)
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

    var photoButtonPublisher: AnyPublisher<ActionDetail, Never> {
        return self.importPhotosButton.tapPublisher
            .map { [weak self] _ -> ActionDetail in
                guard let self else { return (message: "", titles: [], styles: [], actions: []) }
                return (
                    message: TextLiteral.letterPhotoViewChoosePhotoToManitto,
                    titles: self.actionTitles(),
                    styles: self.actionStyles(),
                    actions: self.alertActions()
                )
            }
            .eraseToAnyPublisher()
    }
    var imageSubject: CurrentValueSubject<UIImage?, Never> = CurrentValueSubject(nil)
    var hasImageSubject: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)

    private var cancelBag: Set<AnyCancellable> = Set()

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }

    @available(*, unavailable)
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

    private func actionTitles() -> [String] {
        return self.hasImageSubject.value ? [TextLiteral.letterPhotoViewTakePhoto,
                                             TextLiteral.letterPhotoViewChoosePhoto,
                                             TextLiteral.letterPhotoViewDeletePhoto,
                                             TextLiteral.cancel]
                                          : [TextLiteral.letterPhotoViewTakePhoto,
                                             TextLiteral.letterPhotoViewChoosePhoto,
                                             TextLiteral.cancel]
    }

    private func actionStyles() -> [UIAlertAction.Style] {
        return self.hasImageSubject.value ? [.default, .default, .default, .cancel]
                                          : [.default, .default, .cancel]
    }

    private func alertActions() -> [AlertAction?] {
        let takePhotoAction: AlertAction = { [weak self] _ in
            self?.openPickerAccordingTo(.camera)
        }
        let photoLibraryAction: AlertAction = { [weak self] _ in
            self?.openPickerAccordingTo(.library)
        }
        let removePhotoAction: AlertAction = { [weak self] _ in
            self?.importPhotosButton.setImage(UIImage.Button.camera, for: .normal)
            self?.hasImageSubject.send(false)
        }

        return self.hasImageSubject.value ? [takePhotoAction, photoLibraryAction, removePhotoAction, nil]
                                          : [takePhotoAction, photoLibraryAction, nil]
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

        DispatchQueue.main.async {
            let phPickerController = PHPickerViewController(configuration: configuration)
            phPickerController.delegate = self
            self.viewController?.present(phPickerController, animated: true)
        }
    }
    
    private func openSettings() {
        let settingAction: AlertAction = { [weak self] _ in
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
extension SendLetterPhotoView: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            DispatchQueue.main.async {
                self.importPhotosButton.setImage(image, for: .normal)
                self.hasImageSubject.send(self.importPhotosButton.imageView?.image != UIImage.Button.camera)
                picker.dismiss(animated: true)
            }
        }
    }
}

// MARK: - PHPickerViewControllerDelegate
extension SendLetterPhotoView: PHPickerViewControllerDelegate {
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
        self.loadUIImage(for: asset) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.importPhotosButton.setImage(image, for: .normal)
                    self?.hasImageSubject.send(self?.importPhotosButton.imageView?.image != UIImage.Button.camera)
                    picker.dismiss(animated: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    picker.makeAlert(title: "", message: error.errorDescription, okAction: { _ in
                        picker.dismiss(animated: true)
                    })
                }
            }
        }
    }

    private func loadUIImage(for itemProvider: NSItemProvider, completionHandler: @escaping ((Result<UIImage, LetterImageError>) -> ())) {
        guard itemProvider.canLoadObject(ofClass: UIImage.self) else { completionHandler(.failure(.cantloadPhoto)); return }

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
