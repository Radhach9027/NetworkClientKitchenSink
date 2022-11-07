import Combine
import NetworkClient
import UIKit

class SocketProgramming: UIViewController {
    private var cancellable = Set<AnyCancellable>()
    private lazy var service = SocketService()
    @IBOutlet var start: UIButton!
    @IBOutlet var send: UIButton!
    @IBOutlet var sendMessageTextFiled: UITextField!
    @IBOutlet var receiveMessage: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        recivePong()
    }
    
    @IBAction func start(sender: UIButton) {
        service.startSession(endPoint: .start) { [weak self] error in
            if let error = error {
                self?.sendMessageTextFiled.isHidden = true
                self?.present(withTitle: error.title.value, message: error.userMessage)
            } else {
                self?.sendMessageTextFiled.isHidden = false
            }
        }
    }
    
    @IBAction func send(sender: UIButton) {
        if let text = sendMessageTextFiled.text {
            service.send(message: .text(text)) { [weak self] error in
                if let error = error {
                    self?.receiveMessage.isHidden = true
                    self?.present(withTitle: error.title.value, message: error.userMessage)
                } else {
                    self?.receiveMessage.isHidden = false
                }
            }
        }
    }
    
    func recivePong() {
        service.receive()
            .sink { [weak self] result in
                switch result {
                    case .failure(let error):
                        self?.present(
                            withTitle: error.title.value,
                            message: error.errorMessage.value
                        )
                    case .finished:
                        debugPrint("finished")
                }
            } receiveValue: { message in
                switch message {
                    case .text(let string):
                        debugPrint(string)
                    case .data(let data):
                        debugPrint(data)
                }
            }
            .store(in: &cancellable)
    }
}


extension SocketProgramming: UITextFieldDelegate {
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        send.isHidden = currentText.isEmpty ? true : false
        return true
    }
}
