//
//  BitelSocket.swift
//  Pods
//
//  Created by mohsen shakiba on 5/29/1396 AP.
//
//

import SocketIO
import SwiftyJSON

class BitelSocket {
    
    weak var socketDelegate: SocketDelegate?
    
    static var `default` = BitelSocket()
    let socket = SocketIOClient(socketURL: URL(string: "http://185.20.163.147:11981")!, config: [.log(false), .compress])

    func initConnection(uuid: String) {
        socket.connect()
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            self.socket.emit("subscribe", ["channel": "notifications." + uuid])
            self.socket.on("call.status.updated", callback: { (data, data1) in
                print("socket_data", data[1])
                let jsonData = data[1]
                let json = JSON(jsonData)
                let type = json["type"].stringValue
                let content = json["content"]
                self.socketDelegate?.onSocketData(event: type, content: content)
            })
        }
    }
    
    func close() {
        socket.disconnect()
    }
    
    
}

protocol SocketDelegate: class {
    
    func onSocketData(event: String, content: JSON)
    
}



