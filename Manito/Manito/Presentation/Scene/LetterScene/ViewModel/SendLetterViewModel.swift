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

    struct Input {
        let sendLetterButtonDidTap: AnyPublisher<Message, Never>
    }

    struct Output {
        let letterResponse: AnyPublisher<Result<Void, Error>, Never>
    }

    // MARK: - property

    private var cancelBag: Set<AnyCancellable> = Set()

    private let usecase: SendLetterUsecase
    private let manitteeId: String
    private let roomId: String
    private let missionId: String

    // MARK: - init

    init(usecase: SendLetterUsecase,
         mission: String,
         manitteeId: String,
         roomId: String,
         missionId: String) {
        self.usecase = usecase
        self.manitteeId = manitteeId
        self.roomId = roomId
        self.missionId = missionId
    }

    // MARK: - Public - func

    func transform(from input: Input) -> Output {
        let letterResponse = input.sendLetterButtonDidTap
            .asyncMap { [weak self] data -> Result<Void, Error> in
                do {
                    guard let self else { return .failure(CommonError.invalidAccess) }
                    let letter = LetterRequestDTO(manitteeId: self.manitteeId, messageContent: data.content)
                    let _ = try await self.usecase.dispatchLetter(roomId: self.roomId,
                                                                 image: data.image,
                                                                 letter: letter,
                                                                 missionId: self.missionId)
                    return .success(())
                } catch(let error) {
                    return .failure(error)
                }
            }
            .eraseToAnyPublisher()

        return Output(letterResponse: letterResponse)
    }

}
