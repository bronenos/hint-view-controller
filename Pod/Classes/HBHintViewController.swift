import UIKit

open class HBHintViewController: UIViewController {
    private var holeElements = [HoleElement]()
    private var hintElements = [HintElement]()
    private var hintViews = [UIView]()
    
    private let backgroundView: HBHintBackgroundView
    private let closeButton: UIButton
    private let tapGesture: UITapGestureRecognizer
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        backgroundView = HBHintBackgroundView(frame: .zero)
        closeButton = UIButton(type: .custom)
        tapGesture = UITapGestureRecognizer()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        let closeIconPath = Bundle.frameworkFilePath("close_icon@2x.png")
        closeButton.setImage(UIImage(contentsOfFile: closeIconPath), for: .normal)
        closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        closeButton.sizeToFit()
        
        tapGesture.addTarget(self, action: #selector(handleTapGeture))
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        view.addSubview(backgroundView)
        view.addSubview(closeButton)
        view.addGestureRecognizer(tapGesture)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(opacity: CGFloat, dismissMode: HBHintDismissMode) {
        backgroundView.fillingColor = UIColor(white: 0, alpha: opacity)
        
        closeButton.isHidden = true
        tapGesture.isEnabled = false
        
        switch dismissMode {
        case .button: closeButton.isHidden = false
        case .tap: tapGesture.isEnabled = true
        }
    }
    
    public func addHole(type: HBHintHoleType, layoutProvider: @escaping HBHintLayoutProvider) {
        let element: HoleElement
        switch type {
        case .ellipse: element = .ellipse(layoutProvider)
        case .rectangle: element = .rectangle(layoutProvider)
        }
        
        backgroundView.holeElements.append(element)
    }
    
    public func addHint(image: UIImage, layoutProvider: @escaping HBHintLayoutProvider) {
        let imageView = UIImageView(image: image)
        view.addSubview(imageView)
        hintViews.append(imageView)
        
        let element = HintElement.imageView(imageView, layoutProvider)
        hintElements.append(element)
    }
    
    public func addHint(text: NSAttributedString, layoutProvider: @escaping HBHintLayoutProvider) {
        let label = UILabel(frame: .zero)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.attributedText = text
        label.numberOfLines = 0
        view.addSubview(label)
        hintViews.append(label)
        
        let element = HintElement.label(label, layoutProvider)
        hintElements.append(element)
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let layout = Layout(
            bounds: view.bounds,
            closeButton: closeButton,
            hintElements: hintElements
        )
        
        backgroundView.frame = layout.backgroundViewFrame
        closeButton.frame = layout.closeButtonFrame
        zip(hintViews, layout.hintElementsFrames).forEach { view, frame in view.frame = frame}
    }
    
    @objc private func handleCloseButton() {
        dismiss()
    }
    
    @objc private func handleTapGeture() {
        dismiss()
    }
    
    private func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}

fileprivate struct Layout {
    let bounds: CGRect
    let closeButton: UIButton
    let hintElements: [HintElement]
    
    var backgroundViewFrame: CGRect {
        return bounds
    }
    
    var closeButtonFrame: CGRect {
        return CGRect(
            origin: CGPoint(x: 20, y: 35),
            size: closeButton.sizeThatFits(.zero)
        )
    }
    
    var hintElementsFrames: [CGRect] {
        return hintElements.map { element -> CGRect in
            switch element {
            case let .imageView(_, layoutProvider): return layoutProvider(bounds.size)
            case let .label(_, layoutProvider): return layoutProvider(bounds.size)
            }
        }
    }
}
