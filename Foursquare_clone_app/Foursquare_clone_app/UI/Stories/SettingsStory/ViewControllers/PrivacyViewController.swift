//
//  PrivacyViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 03.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

protocol PrivacyViewControllerDelegate: class {
    func privacyViewController(_ viewController: PrivacyViewController,
                               didTapBack button: UIBarButtonItem)
}

class PrivacyViewController: UIViewController {

    @IBOutlet private weak var textView: UITextView!

    private lazy var backButton: UIBarButtonItem = {
        let image = UIImage(named: "backWhiteArrow")
        let button = UIBarButtonItem(image: image, style: .plain, target: self,
                                     action: #selector(screenCloseButtonPressed(_:)))
        button.tintColor = .white
        return button
    }()

    weak var delegate: PrivacyViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTextView()
        textFormatting()
    }
}

// MARK: - setup UI
private extension PrivacyViewController {

    func setupTextView() {

        textView.text = getTextTextView()
        if let fontUnwrapped = textView.font {
            print(Int(textView.contentSize.height / fontUnwrapped.lineHeight))
        }
    }

    func textFormatting() {
        let fontName = "American Typewriter"
        let textArray = textView.text.split(separator: "\n").map { $0.description }

        let range = (textView.text as NSString).range(of: getText())
        let mutableAttributed = NSMutableAttributedString(string: textView.text)
        mutableAttributed.addAttributes([.font: UIFont.systemFont(ofSize: 20),
                                         .backgroundColor: UIColor.blue],
                                        range: NSRange(location: 0,
                                                       length: textArray[0].count))

        mutableAttributed.addAttributes([.foregroundColor: UIColor.systemRed,
                                         .strokeWidth: -5,
                                         .strokeColor: UIColor.black,
                                         .font: UIFont(name: fontName, size: 30) ?? UIFont.systemFont(ofSize: 30)],
                                        range: NSRange(location: textArray[0].count + 1,
                                                       length: textArray[1].count))

        mutableAttributed.addAttributes([.font: UIFont.systemFont(ofSize: 25),
                                  .backgroundColor: UIColor.yellow,
                                  .obliqueness: 3.0],
                                 range: range)

        textView.attributedText = mutableAttributed
    }

    func setupNavigationBar() {
        let navBar = navigationController?.navigationBar
        title = "Privacy".localized(name: "SettingsVCLocalization")
        navigationItem.leftBarButtonItem = backButton
        navBar?.barTintColor = .systemBlue
        navBar?.backgroundColor = .systemBlue
        navBar?.barTintColor = .systemBlue
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white,
                                       .font: UIFont.boldSystemFont(ofSize: 22)]
    }

    @objc func screenCloseButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.privacyViewController(self, didTapBack: sender)
    }
}

// MARK: - Text
// swiftlint:disable line_length
private extension PrivacyViewController {

    func getText() -> String {
        let text =
            """
            Идейные соображения высшего порядка, а также постоянное информационно-пропагандистское обеспечение нашей деятельности представляет собой интересный эксперимент
            проверки позиций, занимаемых участниками в отношении поставленных задач.
            """
        return text
    }

    func getTextTextView() -> String {
        let text =
        """
        Идейные соображения высшего порядка, а также сложившаяся структура организации требуют определения и уточнения соответствующий условий активизации. С другой
        стороны рамки и место обучения кадров играет важную роль в формировании существенных финансовых и административных условий. С другой стороны новая модель
        организационной деятельности представляет собой интересный эксперимент проверки форм развития. Повседневная практика показывает, что рамки и место обучения кадров
        требуют определения и уточнения позиций, занимаемых участниками в отношении поставленных задач.
        Таким образом укрепление и развитие структуры требуют определения и уточнения новых предложений. С другой стороны новая модель организационной деятельности
        требуют от нас анализа направлений прогрессивного развития. Не следует, однако забывать, что начало повседневной работы по формированию позиции влечет за собой
        процесс внедрения и модернизации новых предложений. Задача организации, в особенности же реализация намеченных плановых заданий влечет за собой процесс внедрения и
        модернизации дальнейших направлений развития.
        Значимость этих проблем настолько очевидна, что сложившаяся структура организации позволяет оценить значение дальнейших направлений развития. Задача
        организации, в особенности же сложившаяся структура организации требуют определения и уточнения позиций, занимаемых участниками в отношении поставленных задач.
        Задача организации, в особенности же начало повседневной работы по формированию позиции требуют от нас анализа соответствующий условий активизации. Задача
        организации, в особенности же дальнейшее развитие различных форм деятельности в значительной степени обуславливает создание форм развития.
        С другой стороны укрепление и развитие структуры позволяет выполнять важные задания по разработке модели развития. С другой стороны укрепление и развитие
        структуры требуют от нас анализа существенных финансовых и административных условий. Не следует, однако забывать, что постоянный количественный рост и сфера
        нашей активности обеспечивает широкому кругу (специалистов) участие в формировании соответствующий условий активизации. Товарищи! реализация намеченных плановых
        заданий требуют от нас анализа форм развития. Таким образом новая модель организационной деятельности способствует подготовки и реализации новых предложений.
        Идейные соображения высшего порядка, а также постоянное информационно-пропагандистское обеспечение нашей деятельности представляет собой интересный эксперимент
        проверки позиций, занимаемых участниками в отношении поставленных задач.
        """

        return text
    }
}
