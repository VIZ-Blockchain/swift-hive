@testable import VIZ
import XCTest

class TransactionTest: XCTestCase {
    override class func setUp() {
        PrivateKey.determenisticSignatures = true
    }

    override class func tearDown() {
        PrivateKey.determenisticSignatures = false
    }
    
    func testInitWithOp() throws {
        let transferOp = VIZ.Operation.Transfer(from: "foo", to: "bar", amount: Asset(10, .viz), memo: "baz")
        let expiration = Date(timeIntervalSince1970: 0)
        let initTx = VIZ.Transaction.init(refBlockNum: 12345, refBlockPrefix: 1122334455, expiration: expiration, operations:[transferOp] )
        XCTAssertEqual(initTx.refBlockNum, 12345)
        XCTAssertEqual(initTx.refBlockPrefix, 1_122_334_455)
        XCTAssertEqual(initTx.expiration, Date(timeIntervalSince1970: 0))
        XCTAssertEqual(initTx.operations.count, 1)
        let transfer = initTx.operations.first as? VIZ.Operation.Transfer
        XCTAssertEqual(transfer, VIZ.Operation.Transfer(from: "foo", to: "bar", amount: Asset(10, .viz), memo: "baz"))
    }
    
    func testAppend() throws {
        let transferOp = VIZ.Operation.Transfer(from: "foo", to: "bar", amount: Asset(10, .viz), memo: "baz")
        let expiration = Date(timeIntervalSince1970: 0)
        var initTx = VIZ.Transaction.init(refBlockNum: 12345, refBlockPrefix: 1122334455, expiration: expiration)
        XCTAssertEqual(initTx.refBlockNum, 12345)
        XCTAssertEqual(initTx.refBlockPrefix, 1_122_334_455)
        XCTAssertEqual(initTx.expiration, Date(timeIntervalSince1970: 0))
        XCTAssertEqual(initTx.operations.count, 0)
        initTx.append(operation: transferOp)
        XCTAssertEqual(initTx.operations.count, 1)
        let transfer = initTx.operations.first as? VIZ.Operation.Transfer
        XCTAssertEqual(transfer, VIZ.Operation.Transfer(from: "foo", to: "bar", amount: Asset(10, .viz), memo: "baz"))
    }

    func testDecodable() throws {
        let tx = try TestDecode(Transaction.self, json: txJson)
        XCTAssertEqual(tx.refBlockNum, 12345)
        XCTAssertEqual(tx.refBlockPrefix, 1_122_334_455)
        XCTAssertEqual(tx.expiration, Date(timeIntervalSince1970: 0))
        XCTAssertEqual(tx.extensions.count, 0)
        XCTAssertEqual(tx.operations.count, 2)
        let vote = tx.operations.first as? VIZ.Operation.Vote
        let transfer = tx.operations.last as? VIZ.Operation.Transfer
        XCTAssertEqual(vote, VIZ.Operation.Vote(voter: "foo", author: "bar", permlink: "baz", weight: 1000))
        XCTAssertEqual(transfer, VIZ.Operation.Transfer(from: "foo", to: "bar", amount: Asset(10, .viz), memo: "baz"))
    }

    func testSigning() throws {
        guard let key = PrivateKey("5JEB2fkmEqHSfGqL96eTtQ2emYodeTBBnXvETwe2vUSMe4pxdLj") else {
            return XCTFail("Unable to parse private key")
        }
        let operations: [OperationType] = [
            Operation.Vote(voter: "foo", author: "foo", permlink: "baz", weight: 1000),
            Operation.Transfer(from: "foo", to: "bar", amount: Asset(10, .viz), memo: "baz"),
        ]
        let expiration = Date(timeIntervalSince1970: 0)
        let transaction = Transaction(refBlockNum: 0, refBlockPrefix: 0, expiration: expiration, operations: operations)
        AssertEncodes(transaction, Data("00000000000000000000020003666f6f03666f6f0362617ae8030203666f6f0362617210270000000000000356495a000000000362617a00"))
//        XCTAssertEqual(try transaction.digest(forChain: .mainNet), Data("44424a1259aba312780ca6957a91dbd8a8eef8c2c448d89eccee34a425c77512"))
        let customChain = Data("79276aea5d4877d9a25892eaa01b0adf019d3e5cb12a97478df3298ccdd01673")
//        XCTAssertEqual(try transaction.digest(forChain: .custom(customChain)), Data("43ca08db53ad0289ccb268654497e0799c02b50ac8535e0c0f753067417be953"))
        var signedTransaction = try transaction.sign(usingKey: key)
        try signedTransaction.appendSignature(usingKey: key, forChain: .custom(customChain))
        XCTAssertEqual(signedTransaction.signatures, [
            Signature("202d2588ff712d543dfa0febfc90ae52266fb2c6bddd1b796d658c687f0382de621ec0afc5614c723cdd64329a485bc9ce5c93ecdb7dd05b3dfe1d056c3856d9ae"),
            Signature("200c74be0f0c74302efd661deb1014422218fb9704d88cf5f0b59c9c1b44c42d5761e165968959ba6f25ff4a2c0dae3693ea62a761bdd4caa260a0cad32f93bc14"),
        ])
    }
}

fileprivate let txJson = """
{
  "ref_block_num": 12345,
  "ref_block_prefix": 1122334455,
  "expiration": "1970-01-01T00:00:00",
  "extensions": [],
  "operations": [
    ["vote", {"voter": "foo", "author": "bar", "permlink": "baz", "weight": 1000}],
    ["transfer", {"from": "foo", "to": "bar", "amount": "10.000 VIZ", "memo": "baz"}]
  ]
}
"""
