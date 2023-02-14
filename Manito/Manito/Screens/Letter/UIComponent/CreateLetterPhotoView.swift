//
//  CreateLetterPhotoView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/13.
//

import PhotosUI
import UIKit

import SnapKit

final class CreateLetterPhotoView: UIView {

    typealias alertAction = ((UIAlertAction) -> ())
    
    var setSendButtonEnabled: ((_ hasImage: Bool) -> ())?
    
    private enum PhotoType {
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
    private lazy var imagePickerController: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.delegate = self
        return controller
    }()
    private lazy var phPickerController: PHPickerViewController = {
        let controller = PHPickerViewController(configuration: phPickerConfiguration)
        controller.delegate = self
        return controller
    }()
    private let phPickerConfiguration: PHPickerConfiguration = {
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images, .livePhotos])
        return configuration
    }()

    // MARK: - property

    private var hasImage: Bool {
        return self.importPhotosButton.imageView?.image != ImageLiterals.btnCamera
    }
    var image: UIImage? {
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
        return self.hasImage ? [TextLiteral.letterPhotoViewTakePhoto, TextLiteral.letterPhotoViewChoosePhoto, TextLiteral.letterPhotoViewDeletePhoto, TextLiteral.cancel] : [TextLiteral.letterPhotoViewTakePhoto, TextLiteral.letterPhotoViewChoosePhoto, TextLiteral.cancel]
    }

    private func actionStyle() -> [UIAlertAction.Style] {
        return self.hasImage ? [.default, .default, .default, .cancel] : [.default, .default, .cancel]
    }

    private func alertActions() -> [alertAction?] {
        let takePhotoAction: alertAction = { [weak self] _ in
            self?.applyPHPickerWithAuthorization(with: .camera)
        }
        let photoLibraryAction: alertAction = { [weak self] _ in
            self?.applyPHPickerWithAuthorization(with: .library)
        }
        let removePhotoAction: alertAction = { [weak self] _ in
            self?.importPhotosButton.setImage(ImageLiterals.btnCamera, for: .normal)
            self?.setSendButtonEnabled?(self?.hasImage ?? false)
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
    
    private func applyPHPickerWithAuthorization(with state: PhotoType) {
        switch (PHPhotoLibrary.authorizationStatus(), state) {
        case (.denied, .library):
            self.openSettings()
        case (.authorized, .library):
            self.viewController?.present(phPickerController, animated: true, completion: nil)
        case (.notDetermined, .library):
            PHPhotoLibrary.requestAuthorization({ [weak self] photoStatus in
                guard let self = self else { return }
                if photoStatus == .authorized {
                    DispatchQueue.main.async {
                        self.viewController?.present(self.phPickerController, animated: true, completion: nil)
                    }
                }
            })
        case (_, .camera):
            self.imagePickerController.sourceType = .camera
            self.viewController?.present(self.imagePickerController, animated: true, completion: nil)
        default:
            break
        }
    }
    
    private func openSettings() {
        let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "애니또"
        let settingAction: alertAction = { [weak self] _ in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
                self?.viewController?.makeAlert(title: "오류", message: "설정 화면을 연결할 수 없습니다.")
                return
            }
            UIApplication.shared.open(settingURL)
        }

        self.viewController?.makeRequestAlert(title: TextLiteral.letterPhotoViewSetting,
                                              message: "\(appName)가 카메라에 접근이 허용되어 있지 않습니다. 설정화면으로 가시겠습니까?",
                                              okAction: settingAction,
                                              completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension CreateLetterPhotoView: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            DispatchQueue.main.async {
                self.importPhotosButton.setImage(image, for: .normal)
                self.setSendButtonEnabled?(self.importPhotosButton.imageView?.image != ImageLiterals.btnCamera)
            }
        }
        
        self.viewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension CreateLetterPhotoView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    guard let image = image as? UIImage else { return }
                    self.importPhotosButton.setImage(image, for: .normal)
                    self.setSendButtonEnabled?(self.importPhotosButton.imageView?.image != ImageLiterals.btnCamera)
                }
                
                if let error = error {
                    self.viewController?.makeAlert(title: "", message: TextLiteral.letterPhotoViewFail)
                    
                    Logger.debugDescription(error)
                }
            }
        }
    }
}
