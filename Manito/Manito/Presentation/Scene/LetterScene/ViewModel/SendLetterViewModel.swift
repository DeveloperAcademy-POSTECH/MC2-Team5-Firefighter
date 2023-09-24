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
    typealias MessageDetail = (roomId: String, mission: String, missionId: String, manitteeId: String)

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let sendLetterButtonDidTap: AnyPublisher<Message, Never>
    }

    struct Output {
        let mission: AnyPublisher<String, Never>
        let letterResponse: AnyPublisher<Result<Void, Error>, Never>
    }

    // MARK: - property

    private let messageDetailSubject: PassthroughSubject<MessageDetail, Never> = PassthroughSubject()

    private var cancelBag: Set<AnyCancellable> = Set()

    private let usecase: SendLetterUsecase

    // MARK: - init

    init(usecase: SendLetterUsecase,
         mission: String,
         manitteeId: String,
         roomId: String,
         missionId: String) {
        self.usecase = usecase
        self.messageDetailSubject.send((roomId, mission, missionId, manitteeId))
    }

    // MARK: - Public - func

    func transform(from input: Input) -> Output {
        let mission = Publishers.CombineLatest(input.viewDidLoad, self.messageDetailSubject)
            .map { $1.mission }
            .eraseToAnyPublisher()

        let letterResponse = Publishers.CombineLatest(input.sendLetterButtonDidTap, self.messageDetailSubject)
            .asyncMap { [weak self] (data, detail) -> Result<Void, Error> in
                do {
                    guard let self else { return .failure(CommonError.invalidAccess) }
                    let letter = LetterRequestDTO(manitteeId: detail.manitteeId, messageContent: data.content)
                    let _ = try await self.usecase.dispatchLetter(roomId: detail.roomId,
                                                                 image: data.image,
                                                                 letter: letter,
                                                                 missionId: detail.missionId)
                    return .success(())
                } catch(let error) {
                    return .failure(error)
                }
            }
            .eraseToAnyPublisher()

        return Output(mission: mission,
                      letterResponse: letterResponse)
    }

}
