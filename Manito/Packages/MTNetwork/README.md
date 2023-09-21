# MTNetwork

더 많은 케이스들을 적용할 수 있는 네트워크 라이브러리가 될 수 있도록 계속 업데이트하겠습니다.🙇‍♂️

![MTNetwork](https://github.com/YoonAh-dev/URLSession-Example/assets/55099365/613184e4-feea-4a5d-bf33-7fd2cd857cb5)

## Requestable

Requestable은 프로젝트에서 사용하던 EndPointable이 하던 일을 합니다. Moya에 있는 [TargetType](https://github.com/Moya/Moya/blob/master/Sources/Moya/TargetType.swift) 프로토콜을 참고했습니다.

Requestable은 **URLRequest에 담을 요청에 필요한 내용들**을 가지고 있습니다. Requestable를 준수하는 타입은 요구 사항에 있는 내용들을 채워줘야 합니다.

**(작성 예시)**

```swift
import Foundation
import MTNetwork

enum PhotoRequest {
    case fetchImages(query: [String: Any])
}

extension PhotoRequest: Requestable {

    var baseURL: URL {
        return APIEnvironment.baseURL
    }

    var path: String {
        switch self {
        case .fetchImages:
            return "/photos"
        }
    }

    var method: MTNetwork.HTTPMethod {
        switch self {
        case .fetchImages:
            return .get
        }
    }

    var task: MTNetwork.HTTPTask {
        switch self {
        case let .fetchImages(query):
            return .requestParameters(query)
        }
    }

    var headers: MTNetwork.HTTPHeaders {
        switch self {
        case .fetchImages:
            let token = "\(KeyProvider.appKey(of: .clientId))"
            let authorization = HTTPHeader.authorization(token)
            return HTTPHeaders([authorization])
        }
    }

    var requestTimeout: Float {
        return 20
    }

    var sampleData: Data? {
        return Data()
    }

}
```

<br>

Requestable에 있는 프로퍼티 중 3가지는 MTNetwork 패키지 내부에 있는 커스텀 타입을 가집니다.

HTTPMethod, HTTPHeaders, HTTPTask 입니다. HTTPHeaders는 Alamofire에 있는 **[HTTPHeaders](https://github.com/Alamofire/Alamofire/blob/master/Source/HTTPHeaders.swift)** 타입을 참고했습니다. HTTPTask는 Moya에 있는 **[Task](https://github.com/Moya/Moya/blob/master/Sources/Moya/Task.swift)** 타입을 참고했습니다.

### **HTTPMethod**

기본적인 **HTTPMethod** 값을 가지고 있습니다.

```swift
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
```

### **HTTPHeaders**

HTTPHeader 타입을 배열로 가지고 있습니다. HTTPHeader는 헤더 필드에 들어가는 값을 name, value로 받습니다. dictionary 메서드를 사용해서 URLRequest의 allHTTPHeaderFields 프로퍼티에 Dictionary 형식으로 넣어줍니다.

```swift
public struct HTTPHeader {

    /// Name of the header.
    let name: String

    /// Value of the header.
    let value: String

    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
```

### **HTTPTask**

HTTPTask에는 6가지 케이스가 존재합니다.(케이스 추가 예정)

| Type | Description |
| --- | --- |
| requestPlain | 추가 데이터가 없는 상황에서 사용합니다.<br><br>예시) Query Parameter가 없는 GET 요청 |
| requestJSONEncodable(Encodable) | Encodable를 준수하는 데이터를 Request body로 보내야 하는 상황에서 사용합니다.<br><br>예시) Encodable를 따르는 User 구조체를 요청 바디로 넣어서 POST 요청 |
| requestParameters(_ parameters: [String: Any]) | Dictionary 형식의 Query Parameter를 URL QueryItem으로 추가해야 하는 상황에서 사용합니다.<br><br>예시) 정렬 형식을 [”order_by”: “popular”] 쿼리 파라미터로 설정해서 GET 요청 |
| requestCompositeParameters(body: Encodable, query: [String: Any]) | request body와 URL QueryItem를 모두 사용해야 하는 상황에서 사용합니다.<br><br>예시) [”user_id”: “mtnetwork123”] 쿼리 파라미터를 가진 URL로 User 구조체를 요청 바디로 넣어서 PATCH 요청 |
| uploadMultipart([MultipartFormData]) | multipart/form-data 타입일 때, MultipartFormData를 Request body로 보내야 하는 상황에서 사용합니다.<br><br>예시) 이미지 데이터를 요청 바디로 넣어서 POST 요청 |
| uploadCompositeMultipart([MultipartFormData], query: [String: Any]) | multipart/form-data 타입일 때, MultipartFormData를 Request body로 보내면서 쿼리 파라미터를 보내야 하는 상황에서 사용합니다.<br><br>예시)  [”user_id”: “mtnetwork123”] 쿼리 파라미터를 가진 URL로 이미지 데이터를 요청 바디로 넣어서 PUT 요청 |

<br>

## EndPoint

EndPoint는 Requestable를 준수하는 타입을 URLRequest 타입으로 만들기 전에 한 번 더 감싸주는 역할 합니다. EndPoint 내부에 있는 `urlRequest` 메서드를 사용해서 URLRequest 타입으로 EndPoint를 변환합니다.

urlRequest 메서드 내부에서는 URLRequest 인스턴스 내부에 있는 프로퍼티에 적절한 값을 설정해줍니다. httpBody, queryItems 값은 HTTPTask 별로 나누어서 설정해줍니다.

### URLRequest+MTNetwork

URLRequest를 확장하여 encode 메서드를 총 3개 추가했습니다.

- Encodable를 준수하는 타입을 받아서 **Data 타입으로 변환하여 httpBody에 넣어주는** encode 메서드
- Parameter를 받아서 **URLComponent의 queryItems에 넣어주는** encode 메서드
- MultipartFormData를 받아서 **Data 타입으로 변환하여 httpBody에 넣어주는** encode 메서드

<br>

## Providable

Providable 프로토콜을 준수하는 Provider는 `request` 메서드를 가집니다. 해당 메서드는 Request 요청을 생성하여 URLSession에 요청을 태워보내고 Response 데이터를 받습니다. Response 데이터는 200대 상태 코드가 들어오면 반환됩니다. 그 외의 코드가 들어오면 MTError가 반환됩니다.

request 메서드 내부에서 EndPoint와 URLSession를 생성합니다. URLSession은 URLSessionConfiguration.default를 URLSessionConfiguration으로 가집니다. 다른 타입의 URLSessionConfiguration를 추가하게 되면 Session 타입을 선택할 수 있도록 개발해보겠습니다. 🙇‍♂️

<br>

## Response

Response 타입은 네트워크 응답 관련 내용들을 담고 있습니다. 

statusCode, HTTPURLResponse, Data 정보를 가지고 있기 때문에 사용자가 원하는 값을 가져다가 사용할 수 있습니다.

```swift
public struct Response {

    ///  The status code of the response.
    public let statusCode: Int

    ///  The HTTPURLResponse object.
    public let response: HTTPURLResponse?

    ///  The response data.
    public let data: Data

    ///  A text description of the `Response`.
    public var description: String {
        return "Status Code: \(self.statusCode), Data Length: \(self.data.count)"
    }

}
```

내부에 있는 `decode` 메서드를 사용해서 Response data를 Decodable를 준수하는 타입으로 디코딩할 수 있습니다.
