import Foundation

fileprivate let DEBUG = false   // Use to simulate poor responsiveness

public struct BitcoinService {

    public init() {}

    public func fetchBitcoin() async throws -> Double {
        let url = URL(string: "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd")!

        let (data, _) = try await URLSession.shared.data(from: url)

        do {
            let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]

            if let bitcoinData = json["bitcoin"] as? [String: Double],
               let bitcoinValue = bitcoinData["usd"] {

                if DEBUG {
                    if Bool.random() {
                        throw BitcoinError.dataParsingError
                    }
                    print("Current Bitcoin value in USD: \(bitcoinValue)")
                    try await Task.sleep(nanoseconds: 3_000_000_000)
                }
                
                return bitcoinValue
            } else {
                throw BitcoinError.dataParsingError
            }
        } catch {
            throw BitcoinError.dataParsingError
        }
    }
}
