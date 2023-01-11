import SocketIO

class SocketService {
    
    static let shared = SocketService()
    var socket: SocketIOClient!
    
    let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
    
    private init() {
        socket = manager.defaultSocket
    }
    
    func connectSocket(completion: @escaping(Bool) -> () ) {
        disconnectSocket()
        socket.on(clientEvent: .connect) {[weak self] (data, ack) in
            print("socket connected")
            self?.socket.removeAllHandlers()
            completion(true)
            
        }
        socket.connect()
    }
    
    
    func listen(_ topic:String ,completion: @escaping (Any) -> Void ) {
        SocketService.shared.socket.on(topic) { (response, emitter) in
            
            print("Listened")
            completion(response)
        }
    }
    
    func off(_ topic:String) {
        SocketService.shared.socket.off(topic)
    }
    
    func emit(emitterName: String, params: [String : Any]) {
        SocketService.shared.socket.emit(emitterName, params)
    }
    
    func disconnectSocket() {
        socket.removeAllHandlers()
        socket.disconnect()
        print("socket Disconnected")
    }
    
    func checkConnection() -> Bool {
        if socket.manager?.status == .connected {
            return true
        }
        return false
        
    }
}
