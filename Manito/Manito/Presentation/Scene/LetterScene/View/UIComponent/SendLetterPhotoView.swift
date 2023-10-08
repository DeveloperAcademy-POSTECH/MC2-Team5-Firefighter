//
//  SendLetterPhotoView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/13.
//

import Combine
import UIKit

import SnapKit

final class SendLetterPhotoView: UIView {

    typealias AlertAction = ((UIAlertAction) -> ())
    typealias ActionDetail = (message: String,
                              titles: [String],
                              styles: [UIAlertAction.Style],
                              actions: [((UIAlertAction) -> Void)?])
    
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
        label.text = TextLiteral.SendLetter.photoTitle.localized()
        label.font = .font(.regular, ofSize: 16)
        return label
    }()

    // MARK: - property

    var photoButtonPublisher: AnyPublisher<ActionDetail, Never> {
        return self.importPhotosButton.tapPublisher
            .map { [weak self] _ -> ActionDetail in
                guard let self else { return (message: "", titles: [], styles: [], actions: []) }
                return (
                    message: TextLiteral.SendLetter.photoMenuTitle.localized(),
                    titles: self.actionTitles(),
                    styles: self.actionStyles(),
                    actions: self.alertActions()
                )
            }
            .eraseToAnyPublisher()
    }
    
    var openCameraMenuSubject: PassthroughSubject<Void, Never> = PassthroughSubject()
    var openPhotosMenuSubject: PassthroughSubject<Void, Never> = PassthroughSubject()
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
        return self.hasImageSubject.value ? [TextLiteral.SendLetter.photoMenuTakePhoto.localized(),
                                             TextLiteral.SendLetter.photoMenuChoosePhoto.localized(),
                                             TextLiteral.SendLetter.photoMenuDeletePhoto.localized(),
                                             TextLiteral.Common.cancel.localized()]
                                          : [TextLiteral.SendLetter.photoMenuTakePhoto.localized(),
                                             TextLiteral.SendLetter.photoMenuChoosePhoto.localized(),
                                             TextLiteral.Common.cancel.localized()]
    }

    private func actionStyles() -> [UIAlertAction.Style] {
        return self.hasImageSubject.value ? [.default, .default, .default, .cancel]
                                          : [.default, .default, .cancel]
    }

    private func alertActions() -> [AlertAction?] {
        let openCameraAction: AlertAction = { [weak self] _ in
            self?.openCameraMenuSubject.send(())
        }
        let openPhotosAction: AlertAction = { [weak self] _ in
            self?.openPhotosMenuSubject.send(())
        }
        let removePhotoAction: AlertAction = { [weak self] _ in
            self?.removePhoto()
        }

        return self.hasImageSubject.value ? [openCameraAction, openPhotosAction, removePhotoAction, nil]
                                          : [openCameraAction, openPhotosAction, nil]
    }

    private func removePhoto() {
        self.importPhotosButton.setImage(UIImage.Button.camera, for: .normal)
        self.hasImageSubject.send(false)
    }
    
    func updatePhoto(to image: UIImage) {
        self.importPhotosButton.setImage(image, for: .normal)
        self.hasImageSubject.send(true)
    }
}
