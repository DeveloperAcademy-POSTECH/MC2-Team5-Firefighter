//
//  Publisher+Extension.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/07/25.
//
// https://github.com/boostcampwm-2022/iOS09-burstcamp/blob/develop/burstcamp/burstcamp/Util/Extension/AsyncCompatible/Publisher%2BAsync.swift

import Combine

extension Publisher {
    func asyncMap<T>(_ transform: @escaping (Output) async -> T)
    -> Publishers.FlatMap<Future<T, Never>, Self> {
        self.flatMap { value in
            Future { promise in
                Task {
                    let output = await transform(value)
                    promise(.success(output))
                }
            }
        }
    }

    func asyncMap<T>(_ transform: @escaping (Output) async throws -> T)
    -> Publishers.FlatMap<Future<T, Error>, Self> {
        self.flatMap { value in
            Future { promise in
                Task {
                    do {
                        let output = try await transform(value)
                        promise(.success(output))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
    }

    func asyncMap<T>(
        _ transform: @escaping (Output) async throws -> T)
    -> Publishers.FlatMap<Future<T, Error>, Publishers.SetFailureType<Self, Error>> {
        flatMap { value in
            Future { promise in
                Task {
                    do {
                        let output = try await transform(value)
                        promise(.success(output))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
    }
}
