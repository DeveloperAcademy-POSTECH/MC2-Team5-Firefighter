//
//  UIControl+Extension.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/06/10.
//

import Combine
import UIKit

extension UIControl {
    func controlPublisher(for event: UIControl.Event) -> UIControl.EventPublisher {
        return UIControl.EventPublisher(control: self, event: event)
      }

    // Publisher
    struct EventPublisher: Publisher {
        typealias Output = UIControl
        typealias Failure = Never

        let control: UIControl
        let event: UIControl.Event

        func receive<S>(subscriber: S)
        where S: Subscriber, Never == S.Failure, UIControl == S.Input {
            let subscription = EventSubscription(
                control: control,
                subscriber: subscriber,
                event: event
            )
            subscriber.receive(subscription: subscription)
        }
    }

    // Subscription
    fileprivate class EventSubscription<EventSubscriber: Subscriber>: Subscription
    where EventSubscriber.Input == UIControl, EventSubscriber.Failure == Never {

        let control: UIControl
        let event: UIControl.Event
        var subscriber: EventSubscriber?

        init(control: UIControl, subscriber: EventSubscriber, event: UIControl.Event) {
            self.control = control
            self.subscriber = subscriber
            self.event = event

            control.addTarget(self, action: #selector(eventDidOccur), for: event)
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            subscriber = nil
            control.removeTarget(self, action: #selector(eventDidOccur), for: event)
        }

        @objc func eventDidOccur() {
            _ = subscriber?.receive(control)
        }
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        controlPublisher(for: .editingChanged)
            .map { $0 as! UITextField }
            .map { $0.text! }
            .eraseToAnyPublisher()
    }
}

extension UIButton {
    var tapPublisher: AnyPublisher<Void, Never> {
        controlPublisher(for: .touchUpInside)
            .map { _ in }
            .eraseToAnyPublisher()
    }
}

extension UISegmentedControl {
    var selectionPublisher: AnyPublisher<Int, Never> {
        controlPublisher(for: .valueChanged)
            .map { $0 as! UISegmentedControl }
            .map { $0.selectedSegmentIndex }
            .eraseToAnyPublisher()
    }
}

extension UISlider {
    var valuePublisher: AnyPublisher<Float, Never> {
        controlPublisher(for: .valueChanged)
            .map { $0 as! UISlider }
            .map { $0.value }
            .eraseToAnyPublisher()
    }
}

//출처:https://velog.io/@aurora_97/Combine-UIKit%EC%97%90%EC%84%9C-Combine-%ED%8E%B8%ED%95%98%EA%B2%8C-%EC%93%B0%EA%B8%B0
