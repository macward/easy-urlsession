//
//  ViewController.swift
//  NetworkWrapper
//
//  Created by Max Ward on 08/06/2021.
//

import UIKit

struct BankTransferModel: Codable {
    
    var id: Int
    var uid: String
    var accountNumber: String
    var bankName: String
    var routingNumber: String
    var swiftBic: String
    
    enum CodingKeys: String, CodingKey {
        case id, uid
        case accountNumber = "account_number"
        case bankName = "bank_name"
        case routingNumber = "routing_number"
        case swiftBic = "swift_bic"
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiDispatcher = RequestDispatcher(networkSession: NetworkSession(), environment: nil)
        apiDispatcher.execute(request: BooksEndpoint.index, of: BankTransferModel.self) { response in
            switch response {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }


}

