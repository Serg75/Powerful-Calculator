import XCTest
import Combine
import Mocker

@testable import BitcoinService

fileprivate let url = URL(string: "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd")

final class BitcoinServiceTests: XCTestCase {
    var bitcoinService: BitcoinService!

    override func setUp() {
        super.setUp()
        Mocker.mode = .optout
    }

    override func tearDown() {
        Mocker.removeAll()
        Mocker.mode = .optout
        super.tearDown()
    }

    func testFetchBitcoinSuccess() async {
        
        let expectation = XCTestExpectation(description: "Fetch Bitcoin data successfully")

        let data = """
        {"bitcoin":{"usd":1234}}
        """
        var mock = Mock(
            url: url!,
            dataType: .json,
            statusCode: 200,
            data: [.get: Data(data.utf8)]
        )
        mock.completion = { expectation.fulfill() }
        mock.register()

        let sut = BitcoinService()

        let bitcoinValue = try? await sut.fetchBitcoin()

        await fulfillment(of: [expectation], timeout: 1)

        XCTAssertEqual(bitcoinValue, 1234)
    }

    func testFetchBitcoinNetworkError() async {
        // Create an expectation for a network error scenario
        let expectation = XCTestExpectation(description: "Fetch Bitcoin data should fail due to a network error")

        var mock = Mock(
            url: url!,
            dataType: .json,
            statusCode: 204,
            data: [.get: Data()]
        )
        mock.completion = { expectation.fulfill() }
        mock.register()

        let sut = BitcoinService()

        do {
            let bitcoinValue = try await sut.fetchBitcoin()
            XCTFail("fetchBitcoin should throws due to a network error")
        } catch { }
    }
}
