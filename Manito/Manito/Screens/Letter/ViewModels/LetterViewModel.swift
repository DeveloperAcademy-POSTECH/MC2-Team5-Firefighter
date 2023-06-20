//
//  LetterViewModel.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/06/20.
//

import Combine
import Foundation

final class LetterViewModel: ViewModelType {

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let segmentControlValueChanged: CurrentValueSubject<Int, Never>
        let refresh: PassthroughSubject<Void, Never>
    }

    struct Output {
        let messages: PassthroughSubject<[Message], Never>
    }

    // MARK: - property

    private let messageSubject: PassthroughSubject<[Message], Never> = PassthroughSubject()

    private let service: LetterServicable

    // MARK: - init

    init(service: LetterServicable) {
        self.service = service
    }

    // MARK: - Public - func

    func transform(from input: Input) -> Output {
        return Output(messages: self.messageSubject)
    }

    // MARK: - Private - func

    private func fetchSendLetter(roomId: String) {
        Task {
            do {
                let messages = try await self.service.fetchSendLetter(roomId: roomId)
                self.messageSubject.send(messages)
            } catch {
                self.messageSubject.send([])
            }
        }
    }

    private func fetchReceivedLetter(roomId: String) {
        Task {
            do {
                let messages = try await self.service.fetchReceiveLetter(roomId: roomId)
                self.messageSubject.send(messages)
            } catch {
                self.messageSubject.send([])
            }
        }
    }
}
