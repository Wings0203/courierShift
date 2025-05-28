import UIKit

class vc: UIViewController {
    
    var dropdownMenu = DropdownMenu()
    private var dropdownHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setDropdownMenu()
        
    }
    private func setDropdownMenu() {
        view.addSubview(dropdownMenu)

        dropdownMenu.translatesAutoresizingMaskIntoConstraints = false
        
        dropdownHeightConstraint = dropdownMenu.heightAnchor.constraint(equalToConstant: dropdownMenu.currentHeight)

        NSLayoutConstraint.activate([
            dropdownMenu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dropdownMenu.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dropdownMenu.widthAnchor.constraint(equalToConstant: 235),
            dropdownHeightConstraint
        ])

        dropdownMenu.configure(with: ["Active", "Inactive", "Active 2", "Inactive 2"])
        
        // Реакция на изменение высоты
        dropdownMenu.onHeightChange = { [weak self] newHeight in
            self?.dropdownHeightConstraint.constant = newHeight
            UIView.animate(withDuration: 0.3) {
                self?.view.layoutIfNeeded()
            }
        }
    }
}
