
import UIKit

final class NewPromocodeView: UIView {
    
    private enum Constants {
        static let textFieldLabel = "Введите код"
        static let activatePromocodeButtonTitle = "Применить"
        static let errorInputTextFieldLabel = "К сожалению, данного промокода не существует"
    }
    
    private lazy var inputTextField: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clearButtonMode = .whileEditing
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        textField.tintColor = .orange
        textField.leftViewMode = .always
        textField.delegate = self
        return textField
    }()
    
    private lazy var textFieldLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.textFieldLabel
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var activatePromocodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.activatePromocodeButtonTitle, for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColorProperties.makeAnOrderButtonColorsProperties
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
        button.addTarget(self, action: #selector(checkPromocode), for: .touchUpInside)
        return button
    }()
    
    private lazy var errorInputTextFieldLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.errorInputTextFieldLabel
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .red
        label.isHidden = true
        return label
    }()
    
    private var buttonToTextFieldMargin: NSLayoutConstraint!
    private var buttonToLabelMargin: NSLayoutConstraint!
    private let viewModel: NewPromocodeViewModel
    private var isErrorShown = false
    
    init(frame: CGRect, viewModel: NewPromocodeViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showErrorLabel(_ errorMessage: String) {
        errorInputTextFieldLabel.text = errorMessage
        errorInputTextFieldLabel.isHidden = false
        buttonToTextFieldMargin.isActive = false
        buttonToLabelMargin.isActive = true
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
            self.inputTextField.layer.borderColor = UIColor.red.cgColor
            self.textFieldLabel.textColor = .red
        }
    }
    
}

extension NewPromocodeView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        clearTextField()
        return true
    }
}

private extension NewPromocodeView {
    
    @objc
    func checkPromocode() {
        guard let promocodeName = inputTextField.text else { return }
        viewModel.addNewPromocode(promocodeName)
    }
    
    func clearTextField() {
        errorInputTextFieldLabel.isHidden = true
        buttonToTextFieldMargin.isActive = true
        buttonToLabelMargin.isActive = false
        inputTextField.layer.borderColor = UIColor.black.cgColor
        textFieldLabel.textColor = .lightGray
    }
    
    func setupView() {
        addSubview(inputTextField)
        addSubview(textFieldLabel)
        addSubview(activatePromocodeButton)
        addSubview(errorInputTextFieldLabel)
        setupConstraints()
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            inputTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            inputTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            inputTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            inputTextField.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        NSLayoutConstraint.activate([
            textFieldLabel.topAnchor.constraint(equalTo: inputTextField.topAnchor, constant: -16),
            textFieldLabel.leadingAnchor.constraint(equalTo: inputTextField.leadingAnchor, constant: 16),
            textFieldLabel.trailingAnchor.constraint(greaterThanOrEqualTo: inputTextField.trailingAnchor, constant: -16),
            textFieldLabel.bottomAnchor.constraint(greaterThanOrEqualTo: inputTextField.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            errorInputTextFieldLabel.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 6),
            errorInputTextFieldLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18),
            errorInputTextFieldLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])
        
        buttonToTextFieldMargin = activatePromocodeButton.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 16)
        buttonToTextFieldMargin.isActive = true
        
        buttonToLabelMargin = activatePromocodeButton.topAnchor.constraint(equalTo: errorInputTextFieldLabel.bottomAnchor, constant: 8)
        buttonToLabelMargin.isActive = false
        
        NSLayoutConstraint.activate([
            activatePromocodeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            activatePromocodeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            activatePromocodeButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
}

