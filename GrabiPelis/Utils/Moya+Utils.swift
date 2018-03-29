import Moya
import Moya_ModelMapper


extension MoyaError {
    public var backendError: APIError? {
        return response.flatMap {
            try? $0.map(to: APIError.self)
        }
    }
}

