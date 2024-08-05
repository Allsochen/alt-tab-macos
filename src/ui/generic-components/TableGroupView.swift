import Cocoa

class TableGroupView: NSStackView {
    static let padding = CGFloat(10)
    static let backgroundColor = NSColor.lightGray.withAlphaComponent(0.1).cgColor
    static let borderColor = NSColor.lightGray.withAlphaComponent(0.2).cgColor
    static let cornerRadius = CGFloat(5)
    static let borderWidth = CGFloat(1)

    private var lastMouseEnteredRowInfo: RowInfo?

    var title: String?
    var subTitle: String?

    var width: CGFloat = 500
    private let titleLabel = NSTextField(labelWithString: "")
    private let subTitleLabel = NSTextField(labelWithString: "")
    private let tableView = NSStackView()
    private var rows = [RowInfo]()

    struct Row {
        let leftTitle: String
        let subTitle: String?
        let rightViews: [NSView]

        init(leftTitle: String, subTitle: String? = nil, rightViews: [NSView]) {
            self.leftTitle = leftTitle
            self.subTitle = subTitle
            self.rightViews = rightViews
        }
    }

    struct RowInfo {
        let id: Int
        let view: NSView
        var previousSeparator: NSBox?
        var nextSeparator: NSBox?

        init(id: Int, view: NSView, previousSeparator: NSBox? = nil, nextSeparator: NSBox? = nil) {
            self.id = id
            self.view = view
            self.previousSeparator = previousSeparator
            self.nextSeparator = nextSeparator
        }
    }

    init(title: String? = nil, subTitle: String? = nil, width: CGFloat = 500) {
        self.width = width
        self.title = title
        self.subTitle = subTitle
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        orientation = .vertical
        spacing = 3

        if let title = title {
            titleLabel.stringValue = title
            titleLabel.font = NSFont.boldSystemFont(ofSize: 13)
            titleLabel.alignment = .left
            titleLabel.lineBreakMode = .byWordWrapping
            titleLabel.maximumNumberOfLines = 0

            addArrangedSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: TableGroupView.padding).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -TableGroupView.padding).isActive = true

            // Ensure height adjusts to content by setting priorities
            titleLabel.setContentHuggingPriority(.required, for: .vertical)
            titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        } else {
            titleLabel.isHidden = true
        }

        if let subTitle = subTitle {
            subTitleLabel.stringValue = subTitle
            subTitleLabel.font = NSFont.systemFont(ofSize: 12)
            subTitleLabel.textColor = .gray
            subTitleLabel.alignment = .left
            subTitleLabel.lineBreakMode = .byWordWrapping
            subTitleLabel.maximumNumberOfLines = 0

            addArrangedSubview(subTitleLabel)
            subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: TableGroupView.padding).isActive = true
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -TableGroupView.padding).isActive = true

            // Ensure height adjusts to content by setting priorities
            subTitleLabel.setContentHuggingPriority(.required, for: .vertical)
            subTitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
            // Calculate the fitting height for subLabel and activate the height constraint
            let subLabelHeight = calculateHeightForLabel(subTitleLabel, width: self.width - 2 * TableGroupView.padding)
            subTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: subLabelHeight).isActive = true
        } else {
            subTitleLabel.isHidden = true
        }

        tableView.orientation = .vertical
        tableView.spacing = 0
        tableView.wantsLayer = true
        tableView.layer?.backgroundColor = TableGroupView.backgroundColor
        tableView.layer?.cornerRadius = TableGroupView.cornerRadius
        tableView.layer?.borderColor = TableGroupView.borderColor
        tableView.layer?.borderWidth = TableGroupView.borderWidth
        addArrangedSubview(tableView)

        // Add constraints to ensure tableView takes up the full width
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: self.width).isActive = true
    }

    func addRow(_ row: Row, onClick: EventClosure? = nil, onMouseEntered: EventClosure? = nil, onMouseExited: EventClosure? = nil) -> RowInfo {
        return addRow(leftText: row.leftTitle, rightViews: row.rightViews, subText: row.subTitle, onClick: onClick, onMouseEntered: onMouseEntered, onMouseExited: onMouseExited)
    }

    func addRow(leftText: String? = nil, rightViews: NSView, subText: String? = nil,
                onClick: EventClosure? = nil,
                onMouseEntered: EventClosure? = nil,
                onMouseExited: EventClosure? = nil) -> RowInfo {
        return addRow(leftText: leftText, rightViews: [rightViews], subText: subText, onClick: onClick, onMouseEntered: onMouseEntered, onMouseExited: onMouseExited)
    }

    func addRow(leftText: String? = nil, rightViews: [NSView]? = nil, subText: String? = nil,
                onClick: EventClosure? = nil,
                onMouseEntered: EventClosure? = nil,
                onMouseExited: EventClosure? = nil) -> RowInfo {
        let rowView = ClickHoverStackView()
        rowView.orientation = .vertical
        rowView.spacing = 2

        let mainRow = NSStackView()
        mainRow.orientation = .horizontal
        mainRow.spacing = 0

        let rightStackView = NSStackView()
        rightStackView.orientation = .horizontal
        rightStackView.spacing = 2

        if let rightViews = rightViews {
//            rightViews.forEach { view in
//                if let button = view as? NSButton {
//                    button.isBordered = false
//                }
//            }

            rightStackView.setViews(rightViews, in: .leading)
        }

        let leftLabel = NSTextField(labelWithString: leftText ?? "")
        leftLabel.alignment = .left
        leftLabel.lineBreakMode = .byWordWrapping
        leftLabel.maximumNumberOfLines = 0

        let spacer = NSView() // Spacer to fill the middle space

        mainRow.addArrangedSubview(leftLabel)
        mainRow.addArrangedSubview(spacer)
        mainRow.addArrangedSubview(rightStackView)

        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightStackView.translatesAutoresizingMaskIntoConstraints = false
        spacer.translatesAutoresizingMaskIntoConstraints = false

        leftLabel.leadingAnchor.constraint(equalTo: mainRow.leadingAnchor).isActive = true
        rightStackView.trailingAnchor.constraint(equalTo: mainRow.trailingAnchor).isActive = true
        spacer.widthAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true

        rowView.addArrangedSubview(mainRow)

        mainRow.translatesAutoresizingMaskIntoConstraints = false
        mainRow.topAnchor.constraint(equalTo: rowView.topAnchor, constant: TableGroupView.padding).isActive = true
        mainRow.leadingAnchor.constraint(equalTo: rowView.leadingAnchor, constant: TableGroupView.padding).isActive = true
        mainRow.trailingAnchor.constraint(equalTo: rowView.trailingAnchor, constant: -TableGroupView.padding).isActive = true
        mainRow.heightAnchor.constraint(equalToConstant: mainRow.fittingSize.height).isActive = true

        if let subText = subText {
            let subLabel = NSTextField(wrappingLabelWithString: subText)
            subLabel.font = NSFont.systemFont(ofSize: 12)
            subLabel.textColor = .gray
            subLabel.alignment = .left
            subLabel.lineBreakMode = .byWordWrapping
            subLabel.maximumNumberOfLines = 0 // Allow unlimited lines
            subLabel.setContentHuggingPriority(.required, for: .vertical)
            subLabel.setContentCompressionResistancePriority(.required, for: .vertical)

            rowView.addArrangedSubview(subLabel)
            subLabel.translatesAutoresizingMaskIntoConstraints = false
            subLabel.leadingAnchor.constraint(equalTo: rowView.leadingAnchor, constant: TableGroupView.padding).isActive = true
            subLabel.trailingAnchor.constraint(equalTo: rowView.trailingAnchor, constant: -rightStackView.fittingSize.width - 2 * TableGroupView.padding).isActive = true
            subLabel.topAnchor.constraint(equalTo: mainRow.bottomAnchor, constant: 2).isActive = true
            subLabel.bottomAnchor.constraint(equalTo: rowView.bottomAnchor, constant: -TableGroupView.padding).isActive = true

            // Calculate the fitting height for subLabel and activate the height constraint
            let subLabelHeight = calculateHeightForLabel(subLabel, width: self.width - 2 * TableGroupView.padding)
            subLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: subLabelHeight).isActive = true
        } else {
            mainRow.bottomAnchor.constraint(equalTo: rowView.bottomAnchor, constant: -TableGroupView.padding).isActive = true
        }

        let previousSeparator: NSBox?
        if rows.count > 0 {
            previousSeparator = NSBox()
            previousSeparator?.translatesAutoresizingMaskIntoConstraints = false
            previousSeparator?.boxType = .separator
            // Add separator only if there are already rows present
            tableView.addArrangedSubview(previousSeparator!)
            previousSeparator?.heightAnchor.constraint(equalToConstant: TableGroupView.borderWidth).isActive = true
            previousSeparator?.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
            self.adjustSeparatorWidth(separator: previousSeparator, isMouseInside: false)
        } else {
            previousSeparator = nil
        }

        let rowId = rows.count
        var rowInfo = RowInfo(id: rowId, view: rowView, previousSeparator: previousSeparator, nextSeparator: nil)
        if rows.count > 0 {
            // Update the nextSeparator of the previous row
            rows[rows.count - 1].nextSeparator = previousSeparator
        }

        rows.append(rowInfo)
        tableView.addArrangedSubview(rowView)

        rowView.onClick = { event, view in
            onClick?(event, view)
        }

        rowView.onMouseEntered = { (event, view) in
            if let onMouseEntered = onMouseEntered {
                if let rowInfo = self.rows.first(where: { $0.view === rowView }) {
                    self.removeLastMouseEnteredEffects()
                    self.lastMouseEnteredRowInfo = rowInfo
                    self.addMouseEnteredEffects(rowInfo)
                    onMouseEntered(event, view)
                }
            }
        }

        rowView.onMouseExited = { (event, view) in
            if let onMouseExited = onMouseExited {
                if let rowInfo = self.rows.first(where: { $0.view === rowView }) {
                    self.addMouseExitedEffects(rowInfo)
                    onMouseExited(event, view)
                }
            }
        }
        return rowInfo
    }

    func removeLastMouseEnteredEffects() {
        if let lastMouseEnteredRowInfo = lastMouseEnteredRowInfo {
            self.addMouseExitedEffects(lastMouseEnteredRowInfo)
        }
    }

    private func addMouseEnteredEffects(_ rowInfo: RowInfo) {
        rowInfo.view.layer?.backgroundColor = NSColor.lightGray.withAlphaComponent(0.2).cgColor
        self.adjustSeparatorWidth(separator: rowInfo.previousSeparator, isMouseInside: true)
        self.adjustSeparatorWidth(separator: rowInfo.nextSeparator, isMouseInside: true)
    }

    private func addMouseExitedEffects(_ rowInfo: RowInfo) {
        rowInfo.view.layer?.backgroundColor = NSColor.clear.cgColor
        self.adjustSeparatorWidth(separator: rowInfo.previousSeparator, isMouseInside: false)
        self.adjustSeparatorWidth(separator: rowInfo.nextSeparator, isMouseInside: false)
    }

    private func adjustSeparatorWidth(separator: NSBox?, isMouseInside: Bool) {
        let width = isMouseInside ? self.width : (self.width - 2 * TableGroupView.padding)

        if let separator = separator {
            if let existingWidthConstraint = separator.constraints.first(where: { $0.firstAttribute == .width }) {
                separator.removeConstraint(existingWidthConstraint)
            }
            separator.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }

    func removeRow(byId id: Int) {
        if let index = rows.firstIndex(where: { $0.id == id }) {
            rows[index].view.removeFromSuperview()
            rows.remove(at: index)
        }
    }

    private func calculateHeightForLabel(_ label: NSTextField, width: CGFloat) -> CGFloat {
        let fittingSize = NSSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingRect = label.attributedStringValue.boundingRect(with: fittingSize, options: [.usesLineFragmentOrigin, .usesFontLeading])
        return ceil(boundingRect.height)
    }

}

class ClickHoverStackView: NSStackView {
    var onClick: EventClosure?
    var onMouseEntered: EventClosure?
    var onMouseExited: EventClosure?

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        for trackingArea in trackingAreas {
            removeTrackingArea(trackingArea)
        }
        let newTrackingArea = NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
        addTrackingArea(newTrackingArea)

        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleClick(_:)))
        clickGesture.delaysPrimaryMouseButtonEvents = false
        addGestureRecognizer(clickGesture)
    }

    override func mouseEntered(with event: NSEvent) {
        onMouseEntered?(event, self)
    }

    override func mouseExited(with event: NSEvent) {
        onMouseExited?(event, self)
    }

    @objc private func handleClick(_ sender: NSClickGestureRecognizer) {
        if let event = sender.view?.window?.currentEvent {
            onClick?(event, self)
        }
    }
}
