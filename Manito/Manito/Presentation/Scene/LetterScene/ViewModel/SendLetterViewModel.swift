//
//  SendLetterViewModel.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/23.
//

import Combine
import Foundation

final class SendLetterViewModel: BaseViewModelType {

    typealias Message = (content: String?, image: Data?)
    typealias MessageDetail = (roomId: String, missionId: String, manitteeId: String)

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let sendLetterButtonDidTap: AnyPublisher<Message, Never>
        let letterTextDidChange: AnyPublisher<String, Never>
    }

    struct Output {
        let mission: AnyPublisher<String, Never>
        let letterResponse: AnyPublisher<Result<Void, Error>, Never>
        let textCount: AnyPublisher<(count: Int, maxCount: Int), Never>
        let text: AnyPublisher<String, Never>
    }

    // MARK: - property

    private var cancelBag: Set<AnyCancellable> = Set()

    private let maximumTextCount: Int = 100

    private let usecase: SendLetterUsecase
    private let mission: String
    private let messageDetail: MessageDetail

    // MARK: - init

    init(usecase: SendLetterUsecase,
         mission: String,
         manitteeId: String,
         roomId: String,
         missionId: String) {
        self.usecase = usecase
        self.mission = mission
        self.messageDetail = (roomId, missionId, manitteeId)
    }

    // MARK: - Public - func

    func transform(from input: Input) -> Output {
        let mission = input.viewDidLoad
            .compactMap { [weak self] in self?.mission }
            .eraseToAnyPublisher()

        let letterResponse = input.sendLetterButtonDidTap
            .asyncMap { [weak self] data -> Result<Void, Error> in
                do {
                    let _ = try await self?.dispatchLetter(content: data.content, image: data.image)
                    return .success(())
                } catch(let error) {
                    return .failure(error)
                }
            }
            .eraseToAnyPublisher()

        let truncatedText = input.letterTextDidChange
            .map { [weak self] in
                guard let self else { return $0 }
                return self.truncateText($0)
            }
            .eraseToAnyPublisher()

        let textCount = truncatedText
            .map { [weak self] in
                guard let self else { return (count: 0, maxCount: 0) }
                return (count: $0.count, maxCount: self.maximumTextCount)
            }
            .eraseToAnyPublisher()

        return Output(mission: mission,
                      letterResponse: letterResponse,
                      textCount: textCount,
                      text: truncatedText)
    }
}

// MARK: - Helper
extension SendLetterViewModel {
    private func dispatchLetter(content: String?, image: Data?) async throws -> Int {
        let letter = LetterRequestDTO(manitteeId: self.messageDetail.manitteeId, messageContent: content)
        return try await self.usecase.dispatchLetter(roomId: self.messageDetail.roomId,
                                                     image: image,
                                                     letter: letter,
                                                     missionId: self.messageDetail.missionId)
    }
    
    private func truncateText(_ text: String) -> String {
        if text.count > self.maximumTextCount {
            let prefixText = text[text.startIndex..<text.index(text.startIndex, offsetBy: self.maximumTextCount)]
            return String(prefixText)
        } else {
            return text
        }
    }
}
