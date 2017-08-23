//
//  ViewController.swift
//  BitelSDK
//
//  Created by mohsenShakiba on 08/20/2017.
//  Copyright (c) 2017 mohsenShakiba. All rights reserved.
//

import UIKit
import BitelSDK

class ViewController: UIViewController {

    var token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI1N2UwMDMwOTBiMWEzNWUyZjY4NjZhZDdiZjZkNGUwNSIsImlzcyI6Imh0dHA6Ly8xODUuMjAuMTYzLjE0NzoxMTk4MC9hcGkvdjIvbG9naW4td2l0aC11c2VyLWlkIiwiaWF0IjoxNTAzMjM0NzkyLCJleHAiOjE4MTg1OTQ3OTIsIm5iZiI6MTUwMzIzNDc5MiwianRpIjoiYWlOR2duZ0h0eDZDNTdhNiIsInVzZXJfaWQiOjIyLCJmb3JldmVyIjpmYWxzZX0.ZSjrJxP6k3uTLh5abRKrShFRIhcQqzcwwgbJDSfsb4B"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let provider = BitelCallProvider(token: token, sourceNumber: "09124986385", destinationNumber: "09107611724", visibleName: "محسن شکیبا", voiceID: nil, visibleNumber: "09124986385", visibleThumbnail: UIImage())
        provider.present(in: self)
        provider.onCallStatusChange { (status) in
            print("status", status)
        }
    }

}

