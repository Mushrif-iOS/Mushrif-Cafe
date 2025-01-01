
import UIKit
import CoreLocation

protocol AddMoneyDelegate {
    func completed()
}

protocol SelectDelegate {
    func onSelect(index: Int)
}

protocol SelectAddressDelegate {
    func onSelect(id: String, title: String)
}

protocol ToastDelegate {
    func dismissed()
}

protocol MainMenuDelegate {
    func onSelectMenu(index: Int)
}

protocol InputBoxDelegate {
    func onInput(text: String)
}

protocol PaymentDelegate {
    func onSuccess()
    func onFail()
}

protocol PayDelegate {
    func onSuccess(payAmount: Double)
    func onFail()
}

protocol SetLocationDelegate {
    func onSelect(location: CLLocation, address: String)
}

protocol PayNowDelegate {
    func onSelect(type: String, paymentId: String)
}
