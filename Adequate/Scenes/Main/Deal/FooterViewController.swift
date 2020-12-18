//
//  FooterViewController.swift
//  Adequate
//
//  Created by Mathew Gacy on 4/24/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

// MARK: - Delegate

protocol DealFooterDelegate: AnyObject {
    func buy()
}

// MARK: - View Controller

class FooterViewController: UIViewController {

    private lazy var formatter: PriceFormatting = PriceFormatter()

    // TODO: replace delegate with simple closure? Delegate works well for future expansion
    weak var delegate: DealFooterDelegate?
    //var buttonTapHandler: (() -> Void)?

    // MARK: - Subviews

    private let priceLabel = UILabel(style:
        StyleBook.Label.centered <> StyleBook.Label.primary)

    private let priceComparisonLabel = UILabel(style:
        StyleBook.Label.centered <> StyleBook.Label.secondary)

    private lazy var priceStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [priceLabel, priceComparisonLabel])
        StyleBook.StackView.vertical().apply(to: view)
        return view
    }()

    private let buyButton: UIButton = {
        let button = UIButton(style: StyleBook.Button.standard)
        button.backgroundColor = ColorCompatibility.systemBackground
        button.setTitleColor(button.tintColor, for: .normal)
        button.setTitle(L10n.buy, for: .normal)
        button.setTitle(L10n.soldOut, for: .disabled)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceStack, buyButton])
        // FIXME: isn't this `spacing` value pretty arbitrary?
        StyleBook.StackView.horizontal(spacing: 5.0).apply(to: stackView)
        return stackView
    }()

    //private var initialSetupDone = false
    /*
    // Gradient

    // TODO: add `didSet` and call function to set gradient(?)
    public var gradientMaskHeight: CGFloat = 8.0

    private lazy var gradientMaskLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        return gradient
    }()
    */
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - View Methods

    func setupView() {
        buyButton.addTarget(self, action: #selector(buy(_:)), for: .touchUpInside)
        buyButton.isHidden = true
        view.addSubview(stackView)
        //layer.mask = gradientMaskLayer
        view.layer.cornerRadius = AppTheme.CornerRadius.small
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        setupConstraints()
    }

    private func setupConstraints() {
        let guide = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: guide.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func buy(_ sender: UIButton) {
        delegate?.buy()
        //buttonTapHandler?()
    }
}

// MARK: - ViewStateRenderable
extension FooterViewController: ViewStateRenderable {

    func render(_ viewState: ViewState<Deal>) {
        switch viewState {
        case .empty:
            view.isHidden = true
        case .loading:
            view.isHidden = true
        case .result(let deal):
            do {
                let priceData: PriceFormatter.PriceData
                priceData = try formatter.parsePriceData(from: deal)
                view.isHidden = false

                // Price Comparison
                if let priceComparison = priceData.priceComparison {
                    priceComparisonLabel.text = priceComparison
                    priceComparisonLabel.isHidden = false
                    //stackView.alignment = .center
                    priceLabel.font = FontBook.compactFooter
                } else {
                    priceComparisonLabel.isHidden = true
                    //stackView.alignment = .firstBaseline
                    priceLabel.font = FontBook.expandedFooter
                }

                // LaunchStatus
                let launchStatus = deal.launchStatus ?? (deal.soldOutAt == nil ? .launch : .soldOut)
                updateStatus(launchStatus: launchStatus, priceText: priceData.priceText)
            } catch {
                log.error("Unable to parse price data: \(error)")
                render(.error(error))
            }
        case .error:
            // TODO: is this the best way to handle?
            view.isHidden = true
        }
    }

    // MARK: Helpers

    private func updateStatus(launchStatus: LaunchStatus, priceText: String) {
        buyButton.isHidden = false

        switch launchStatus {
        case .launch, .relaunch:
            buyButton.isEnabled = true
            priceLabel.isHidden = false
            priceLabel.removeStrikethrough()
            priceLabel.text = priceText
        case .launchSoldOut:
            buyButton.isEnabled = false
            priceLabel.isHidden = false
            priceLabel.setStrikethrough(text: priceText)
            // TODO: show button to schedule reminder for when relaunch occurs
        case .relaunchSoldOut:
            buyButton.isEnabled = false
            priceLabel.isHidden = false
            priceLabel.setStrikethrough(text: priceText)
        case .reserve:
            // TODO: check UserDefaults to see if `isMehVmp`; if so, enable
            buyButton.isEnabled = false
            priceLabel.isHidden = false
            priceLabel.setStrikethrough(text: priceText)
        case .soldOut:
            buyButton.isEnabled = false
            priceLabel.isHidden = false
            priceLabel.setStrikethrough(text: priceText)
        case .expired:
            priceLabel.isHidden = true
            // TODO: display with strikethrough or different color?
            //priceLabel.text = priceText
        case .unknown(let rawValue):
            log.error("Unknown LaunchStatus: \(rawValue)")
            // FIXME: how to handle?
            priceLabel.isHidden = true
        }
    }
}

// MARK: - Themeable
extension FooterViewController: Themeable {
    func apply(theme: ColorTheme) {
        priceLabel.textColor = theme.label
        priceComparisonLabel.textColor = theme.secondaryLabel

        view.backgroundColor = theme.secondarySystemBackground

        buyButton.setTitleColor(theme.secondarySystemBackground, for: .normal)
        buyButton.setTitleColor(ColorCompatibility.systemBlue, for: .selected)
        buyButton.backgroundColor = theme.tint
    }
}
/*
// MARK: - GradientMask
extension FooterViewController {

    enum GradientMaskConstants {
        static let height: CGFloat = 8.0
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutGradientMask()
    }

    private func layoutGradientMask() {
        // Adjust gradient
        gradientMaskLayer.frame = view.bounds
        // TODO: move the following into a separate function? - `foo(height: CGFloat, frame: CGRect)`
        let gradientEndLocation = gradientMaskHeight / view.frame.height
        gradientMaskLayer.locations = [0, NSNumber(value: Double(gradientEndLocation))]
    }
}
*/
