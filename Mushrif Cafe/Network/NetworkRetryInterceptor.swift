import Foundation
import Alamofire

final class NetworkRetryInterceptor: RequestInterceptor {

    private let retryLimit: Int
    private let baseDelay: TimeInterval
    private let maxDelay: TimeInterval

    init(retryLimit: Int = 3, baseDelay: TimeInterval = 1.0, maxDelay: TimeInterval = 8.0) {
        self.retryLimit = retryLimit
        self.baseDelay = baseDelay
        self.maxDelay = maxDelay
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {

        guard Int(request.retryCount) < retryLimit else {
            completion(.doNotRetry)
            return
        }

        if let response = request.task?.response as? HTTPURLResponse {
            switch response.statusCode {
            case 429:
                let serverSuggestedDelay = parseRetryAfter(from: response)
                let delay = serverSuggestedDelay ?? backoffDelay(for: Int(request.retryCount))
                completion(.retryWithDelay(delay))
                return
            case 500...599:
                let delay = backoffDelay(for: Int(request.retryCount))
                completion(.retryWithDelay(delay))
                return
            default:
                break
            }
        }

        if let urlError = error as? URLError {
            switch urlError.code {
            case .timedOut, .networkConnectionLost, .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed, .notConnectedToInternet:
                let delay = backoffDelay(for: Int(request.retryCount))
                completion(.retryWithDelay(delay))
                return
            default:
                break
            }
        }

        completion(.doNotRetry)
    }

    private func backoffDelay(for retryCount: Int) -> TimeInterval {
        let exp = pow(2.0, Double(retryCount))
        let jitter = Double.random(in: 0...0.5)
        return min(exp * baseDelay + jitter, maxDelay)
    }

    private func parseRetryAfter(from response: HTTPURLResponse) -> TimeInterval? {
        guard let value = headerValue(named: "Retry-After", in: response) else { return nil }
        if let seconds = TimeInterval(value) {
            return min(seconds, maxDelay)
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "EEE',' dd MMM yyyy HH':'mm':'ss z"
        if let date = formatter.date(from: value) {
            return min(max(0, date.timeIntervalSinceNow), maxDelay)
        }
        return nil
    }

    private func headerValue(named name: String, in response: HTTPURLResponse) -> String? {
        for (key, value) in response.allHeaderFields {
            if let keyStr = key as? String, keyStr.caseInsensitiveCompare(name) == .orderedSame {
                return value as? String
            }
        }
        return nil
    }
}


