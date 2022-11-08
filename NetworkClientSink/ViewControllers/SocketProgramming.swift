import Combine
import NetworkClient
import UIKit

final class SocketProgramming: UIViewController {
    private var cancellable = Set<AnyCancellable>()
    private lazy var service = SocketService(network: Network.defaultSession)
    @IBOutlet private var start: UIButton!
    @IBOutlet private var send: UIButton!
    @IBOutlet private var sendMessageTextFiled: UITextField!
    @IBOutlet private var receiveMessage: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        recivePong()
    }
    
    @IBAction func start(sender: UIButton) {
        service.startSession(endPoint: .start) { [weak self] error in
            if let error = error {
                self?.sendMessageTextFiled.isHidden = true
                self?.present(
                    withTitle: error.title.value,
                    message: error.userMessage
                )
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
                    self?.present(
                        withTitle: error.title.value,
                        message: error.userMessage
                    )
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
                case let .failure(error):
                    self?.present(
                        withTitle: error.title.value,
                        message: error.errorMessage.value
                    )
                case .finished:
                    debugPrint("finished")
                }
            } receiveValue: { message in
                switch message {
                case let .text(string):
                    debugPrint(string)
                case let .data(data):
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
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(
                in: textRange,
                with: string
            )
            send.isHidden = updatedText.isEmpty ? true : false
        }
        return true
    }
}
