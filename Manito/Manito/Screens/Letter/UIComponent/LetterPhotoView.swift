//
//  LetterPhotoView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/13.
//

import PhotosUI
import UIKit

import SnapKit

final class LetterPhotoView: UIView {
    
    var applySendButtonEnabled: (() -> ())?
    
    private enum PhotoType {
        case camera
        case library
    }
    
    // MARK: - property
    
    let importPhotosButton: UIButton = {
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
        label.text = "사진 추가"
        label.font = .font(.regular, ofSize: 16)
        return label
    }()
    private lazy var imagePickerController: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.delegate = self
        return controller
    }()
    private lazy var phPickerController: PHPickerViewController = {
        let controller = PHPickerViewController(configuration: photoConfiguration)
        controller.delegate = self
        return controller
    }()
    private var photoConfiguration: PHPickerConfiguration = {
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images, .livePhotos])
        return configuration
    }()

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        setupButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - func
    
    private func render() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        addSubview(importPhotosButton)
        importPhotosButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(17)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(209)
        }
    }
    
    private func setupButtonAction() {
        let photoAction = UIAction { [weak self] _ in
            self?.presentActionSheet()
        }
        
        importPhotosButton.addAction(photoAction, for: .touchUpInside)
    }
    
    private func presentActionSheet() {
        let hasImage = importPhotosButton.imageView?.image != ImageLiterals.btnCamera
        let actionTitles = hasImage ? ["사진 촬영", "사진 보관함에서 선택", "사진 지우기", "취소"] : ["사진 촬영", "사진 보관함에서 선택", "취소"]
        let actionStyle: [UIAlertAction.Style] = hasImage ? [.default, .default, .default, .cancel] : [.default, .default, .cancel]
        let actions = getAlertAction(with: hasImage)
        
        viewController?.makeActionSheet(message: "마니또에게 보낼 사진을 선택해봐요.",
                                       actionTitles: actionTitles,
                                       actionStyle: actionStyle,
                                       actions: actions)
    }
    
    private func getAlertAction(with state: Bool) -> [((UIAlertAction) -> ())?] {
        let takePhotoAction: ((UIAlertAction) -> ()) = { [weak self] _ in
            self?.applyPHPickerWithAuthorization(with: .camera)
        }
        let photoLibraryAction: ((UIAlertAction) -> ()) = { [weak self] _ in
            self?.applyPHPickerWithAuthorization(with: .library)
        }
        let removePhotoAction: ((UIAlertAction) -> ()) = { [weak self] _ in
            self?.importPhotosButton.setImage(ImageLiterals.btnCamera, for: .normal)
        }
        
        return state ? [takePhotoAction, photoLibraryAction, removePhotoAction, nil]
                     : [takePhotoAction, photoLibraryAction, nil]
    }
    
    private func applyPHPickerWithAuthorization(with state: PhotoType) {
        switch (PHPhotoLibrary.authorizationStatus(), state) {
        case (.denied, .library):
            didMoveToSetting()
        case (.authorized, .library):
            viewController?.present(phPickerController, animated: true, completion: nil)
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
    
    private func didMoveToSetting() {
        let settingAction: ((UIAlertAction) -> ()) = { _ in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingURL)
        }
        if let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
            viewController?.makeRequestAlert(title: "설정",
                                            message: "\(appName)가 카메라에 접근이 허용되어 있지 않습니다. 설정화면으로 가시겠습니까?",
                                            okAction: settingAction,
                                            completion: nil)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension LetterPhotoView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            importPhotosButton.setImage(image, for: .normal)
            applySendButtonEnabled?()
        }
        
        viewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension LetterPhotoView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self else { return }
                
                DispatchQueue.main.sync {
                    guard let image = image as? UIImage else { return }

                    self.importPhotosButton.setImage(image, for: .normal)
                    self.applySendButtonEnabled?()
                }
                
                if let error = error {
                    self.viewController?.makeAlert(title: "", message: "사진을 불러올 수 없습니다.")
                    
                    Logger.debugDescription(error)
                }
            }
        }
    }
}
