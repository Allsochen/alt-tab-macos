import Cocoa

class ImageTextButtonView: NSStackView {
    static let spacing = CGFloat(5)
    static let cornerRadius = CGFloat(5)
    static let borderWidth = CGFloat(2)
    static let padding = CGFloat(1)

    var onClick: ActionClosure?
    var button: NSButton!
    var label: NSTextField!

    var state: NSControl.StateValue = .off {
        didSet {
            button.state = state
            updateStyle()
        }
    }

    init(title: String, rawName: String, image: WidthHeightImage,
         state: NSControl.StateValue = .off,
         onClick: ActionClosure? = nil,
         spacing: CGFloat = ImageTextButtonView.spacing,
         padding: CGFloat = ImageTextButtonView.padding,
         cornerRadius: CGFloat = ImageTextButtonView.cornerRadius) {
        super.init(frame: .zero)

        self.orientation = .vertical
        self.alignment = .centerX
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = false

        makeButton(rawName, state, image, cornerRadius: cornerRadius)
        makeLabel(title)
        self.state = state
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeButton(_ rawName: String, _ state: NSControl.StateValue, _ image: WidthHeightImage,
                            padding: CGFloat = ImageTextButtonView.padding,
                            cornerRadius: CGFloat = ImageTextButtonView.cornerRadius) {
        button = NSButton(radioButtonWithTitle: "", target: nil, action: nil)
        button.imagePosition = .imageOnly
        button.focusRingType = .none
        button.translatesAutoresizingMaskIntoConstraints = false
        button.wantsLayer = true
        button.layer?.cornerRadius = 7.0
        button.layer?.borderWidth = ImageTextButtonView.borderWidth
        button.state = state
        addArrangedSubview(button)

        // Create an NSView to contain the image and provide padding
        let imageContainer = NSView()
        imageContainer.translatesAutoresizingMaskIntoConstraints = false

        // TODO: The appearance theme functionality has not been implemented yet.
        // We will implement it later; for now, use the light theme.
        let imageView = NSImageView(image: NSImage(named: image.name + "_light")!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.wantsLayer = true
        imageView.layer?.cornerRadius = cornerRadius
        imageContainer.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: image.width),
            imageView.heightAnchor.constraint(equalToConstant: image.height),
            imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: padding),
            imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: -padding),
            imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: -padding),
        ])

        button.addSubview(imageContainer)
        NSLayoutConstraint.activate([
            imageContainer.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            imageContainer.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            imageContainer.widthAnchor.constraint(equalTo: button.widthAnchor),
            imageContainer.heightAnchor.constraint(equalTo: button.heightAnchor),
            button.topAnchor.constraint(equalTo: topAnchor, constant: ImageTextButtonView.borderWidth),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ImageTextButtonView.borderWidth),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ImageTextButtonView.borderWidth),
        ])

        button.identifier = NSUserInterfaceItemIdentifier(rawName)
        button.onAction = { control in
            self.state = .on
            self.onClick?(control)
        }
    }

    private func makeLabel(_ labelText: String) {
        label = NSTextField(labelWithString: labelText)
        label.alignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(label)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        updateStyle()
    }

    func updateStyle() {
        let isSelected = button.state == .on
        button.layer?.borderColor = isSelected ? NSColor.systemAccentColor.cgColor : NSColor.lightGray.withAlphaComponent(0.5).cgColor
        button.layer?.borderWidth = isSelected ? ImageTextButtonView.borderWidth : ImageTextButtonView.borderWidth
        label.font = isSelected ? NSFont.boldSystemFont(ofSize: 12) : NSFont.systemFont(ofSize: 12)
    }
}
