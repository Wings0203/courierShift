//
//  CustomSegmentControl.swift
//  courierShift
//
//  Created by Татьяна Федотова on 09.05.2025.
//

import UIKit

/*
 it has 2 styles: .light, .dark
 usage:
 let segmentControl = CustomSegmentControl()
 segmentControl.translatesAutoresizingMaskIntoConstraints = false
 segmentControl.commaSeparatedButtonTitles = ""
 segmentControl.style = .light
*/

class CustomSegmentControl: UIControl {
    
    enum Style {
        case light
        case dark
    }
    
    var buttons = [UIButton]()
    var selector: UIView!
    var selectedSegmentIndex = 0
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var commaSeparatedButtonTitles: String = "" {
        didSet {
            configureView()
        }
    }
    
    @IBInspectable
    var textColor: UIColor = .black {
        didSet {
            updateButtonColors()
        }
    }
    
    @IBInspectable
    var selectorColor: UIColor = .blue {
        didSet {
            selector.backgroundColor = selectorColor
        }
    }
    
    @IBInspectable
    var selectorTextColor: UIColor = .white {
        didSet {
            updateButtonColors()
        }
    }
    
    var selectorInset: CGFloat = 8 // Общий отступ для всех кнопок (равен левому отступу крайней левой кнопки)
    var selectorVerticalInset: CGFloat = 4 // Отступ сверху и снизу
    
    var mainBackgroundColor: UIColor = .white
    
    // Стиль
    var style: Style = .light {
        didSet {
            applyStyle(style)
        }
    }
    
    // Применение стиля
    private func applyStyle(_ style: Style) {
        switch style {
        case .light:
            borderColor = .white
            textColor = .black
            selectorColor = .darkGray
            selectorTextColor = .white
            mainBackgroundColor = .white
        case .dark:
            borderColor = .black
            textColor = .gray
            selectorColor = .systemGray3
            selectorTextColor = .white
            mainBackgroundColor = .systemGray5
        }
        
        // Обновить отображение кнопок и слоя
        updateButtonColors()
        setNeedsLayout() // Перестроить слой
    }
    
    private func configureView() {
        // Удаление старых кнопок и подложки
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        selector?.removeFromSuperview()
        
        // Создание кнопок
        let buttonTitles = commaSeparatedButtonTitles.components(separatedBy: ",")
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.font = UIFont(name: "Verdana-SemiBold",size: 19)
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        // Добавление `selector`
        selector = UIView()
        selector.backgroundColor = selectorColor
        selector.layer.cornerRadius = (frame.height - (2 * selectorVerticalInset)) / 2
        addSubview(selector)
        
        // Создание StackView для кнопок
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        // Установка цвета для первой кнопки
        buttons.first?.setTitleColor(selectorTextColor, for: .normal)
    }
    
    private func updateButtonColors() {
        for (index, button) in buttons.enumerated() {
            if index == selectedSegmentIndex {
                button.setTitleColor(selectorTextColor, for: .normal)
            } else {
                button.setTitleColor(textColor, for: .normal)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.backgroundColor = mainBackgroundColor.cgColor
        
        // Обновляем селектор с учетом текущих размеров
        updateSelectorFrame()
    }
    
    private func updateSelectorFrame() {
        guard !buttons.isEmpty else { return }
        
        let selectedButton = buttons[selectedSegmentIndex]
        
        let buttonCenterX = selectedButton.frame.midX
        let titleSize = selectedButton.titleLabel?.intrinsicContentSize ?? CGSize.zero
        
        let desiredWidth = titleSize.width + 2 * selectorInset
        
        let buttonWidth = selectedButton.frame.width
        let selectorWidth = min(desiredWidth, buttonWidth)
        
        let selectorX = buttonCenterX - (selectorWidth / 2)
        
        selector.frame = CGRect(
            x: selectorX,
            y: selectorVerticalInset,
            width: selectorWidth,
            height: frame.height - 2 * selectorVerticalInset
        )

        selector.layer.cornerRadius = selector.frame.height / 2
    }

    
    @objc func buttonTapped(button: UIButton) {
        guard let index = buttons.firstIndex(of: button) else { return }
        selectedSegmentIndex = index
        
        UIView.animate(withDuration: 0.3) {
            self.updateSelectorFrame()
        }
        
        updateButtonColors()
        sendActions(for: .valueChanged)
    }
}


