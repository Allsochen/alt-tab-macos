import Cocoa

struct ShowHideRowInfo {
    let rowId: String!
    var uncheckedImage: String!
    var checkedImage: String!
    var supportedModels: [AppearanceModelPreference]!
    var leftTitle: String!
    var subTitle: String?
    var rightViews = [NSView]()

    init() {
        self.rowId = UUID().uuidString
    }
}

class IllustratedImageThemeView: ClickHoverImageView {
    static let padding = CGFloat(3)
    var model: AppearanceModelPreference!
    var theme: String!
    var imageName: String!
    var isFocused: Bool = true

    init(_ model: AppearanceModelPreference, _ width: CGFloat) {
        // TODO: The appearance theme functionality has not been implemented yet.
        // We will implement it later; for now, use the light theme.
        let theme = "light"
        let imageName = IllustratedImageThemeView.getConcatenatedImageName(model, theme)
        let imageView = NSImageView(image: NSImage(named: imageName)!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.wantsLayer = true
        imageView.layer?.masksToBounds = true
        imageView.layer?.cornerRadius = TableGroupView.cornerRadius

        super.init(imageView: imageView)
        self.model = model
        self.theme = theme
        self.imageName = imageName
        self.translatesAutoresizingMaskIntoConstraints = false
        self.wantsLayer = true


        let imageWidth = width - IllustratedImageThemeView.padding
        let imageHeight = imageWidth / 1.6
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: imageWidth),
            imageView.heightAnchor.constraint(equalToConstant: imageHeight),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: IllustratedImageThemeView.padding),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -IllustratedImageThemeView.padding),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: IllustratedImageThemeView.padding),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -IllustratedImageThemeView.padding),
        ])
        onClick = { (event, view) in
            self.highlight()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setBorder() {
        self.layer?.cornerRadius = TableGroupView.cornerRadius
        self.layer?.borderColor = self.isFocused ? systemAccentColor().cgColor : NSColor.gray.cgColor
        self.layer?.borderWidth = 2
    }

    private func setFocused(_ focused: Bool) {
        self.isFocused = focused
    }

    func highlight(_ highlighted: Bool = true, _ imageName: String = "") {
        if !highlighted && imageName.isEmpty  {
            return
        }

        setFocused(highlighted)
        if highlighted {
            self.imageView.image = NSImage(named: self.imageName)
            setBorder()
        } else {
            updateImage(imageName)
            setBorder()
        }
    }

    private func updateImage(_ imageName: String) {
        imageView.image = NSImage(named: self.getModelThemeImageName(imageName))
    }

    static func getConcatenatedImageName(_ model: AppearanceModelPreference,
                                         _ theme: String ,
                                         _ imageName: String = "") -> String {
        if imageName.isEmpty {
            // thumbnails_light/app_icons_dark
            return model.image.name + "_" + theme
        }
        // thumbnails_show_app_badges_light/app_icons_show_app_badges_light
        return model.image.name + "_" + imageName + "_" + theme
    }

    func getModelThemeImageName(_ imageName: String = "") -> String {
        return IllustratedImageThemeView.getConcatenatedImageName(self.model, self.theme, imageName)
    }

}

class ShowHideIllustratedView {
    private let model: AppearanceModelPreference
    private var showHideRows = [ShowHideRowInfo]()
    var illustratedImageView: IllustratedImageThemeView!
    var table: TableGroupView!

    init(_ model: AppearanceModelPreference, _ illustratedImageView: IllustratedImageThemeView) {
        self.model = model
        self.illustratedImageView = illustratedImageView
        setupItems()
    }

    func makeView() -> TableGroupSetView {
        table = TableGroupView(width: CustomizeModelSettingsWindow.width)
        for row in showHideRows {
            if row.supportedModels.contains(model) {
                _ = table.addRow(leftText: row.leftTitle, rightViews: row.rightViews, onClick: { event, view in
                    self.clickCheckbox(rowId: row.rowId)
                    self.updateImageView(rowId: row.rowId)
                }, onMouseEntered: { event, view in
                    self.updateImageView(rowId: row.rowId)
                })
            }
        }
        table.onMouseExited = { event, view in
            self.illustratedImageView.highlight()
        }
        table.fit()
        let view = TableGroupSetView(originalViews: [table], padding: 0)
        return view
    }

    private func setupItems() {
        var hideAppBadges = ShowHideRowInfo()
        hideAppBadges.uncheckedImage = "show_app_badges"
        hideAppBadges.checkedImage = "hide_app_badges"
        hideAppBadges.supportedModels = [.thumbnails, .appIcons, .titles]
        hideAppBadges.leftTitle = NSLocalizedString("Hide app badges", comment: "")
        hideAppBadges.rightViews.append(LabelAndControl.makeCheckbox("hideAppBadges", extraAction: { sender in
            self.onCheckboxClicked(sender: sender, rowId: hideAppBadges.rowId)
        }))
        showHideRows.append(hideAppBadges)

        var hideStatusIcons = ShowHideRowInfo()
        hideStatusIcons.uncheckedImage = "show_status_icons"
        hideStatusIcons.checkedImage = "hide_status_icons"
        hideStatusIcons.supportedModels = [.thumbnails, .titles]
        hideStatusIcons.leftTitle = NSLocalizedString("Hide status icons", comment: "")
        hideStatusIcons.subTitle = NSLocalizedString("AltTab will show if the window is currently minimized or fullscreen with a status icon.", comment: "")
        hideStatusIcons.rightViews.append(LabelAndControl.makeInfoButton(width: 15, height: 15, onMouseEntered: { event, view in
            Popover.shared.show(event: event, positioningView: view, message: hideStatusIcons.subTitle!)
        }, onMouseExited: { event, view in
            Popover.shared.hide()
        }))
        hideStatusIcons.rightViews.append(LabelAndControl.makeCheckbox("hideStatusIcons", extraAction: { sender in
            self.onCheckboxClicked(sender: sender, rowId: hideStatusIcons.rowId)
        }))
        showHideRows.append(hideStatusIcons)

        var hideSpaceNumberLabels = ShowHideRowInfo()
        hideSpaceNumberLabels.uncheckedImage = "show_space_number_labels"
        hideSpaceNumberLabels.checkedImage = "hide_space_number_labels"
        hideSpaceNumberLabels.supportedModels = [.thumbnails, .titles]
        hideSpaceNumberLabels.leftTitle = NSLocalizedString("Hide Space number labels", comment: "")
        hideSpaceNumberLabels.rightViews.append(LabelAndControl.makeCheckbox("hideSpaceNumberLabels", extraAction: { sender in
            self.onCheckboxClicked(sender: sender, rowId: hideSpaceNumberLabels.rowId)
        }))
        showHideRows.append(hideSpaceNumberLabels)

        var hideColoredCircles = ShowHideRowInfo()
        hideColoredCircles.uncheckedImage = "show_colored_circles"
        hideColoredCircles.checkedImage = "hide_colored_circles"
        hideColoredCircles.supportedModels = [.thumbnails]
        hideColoredCircles.leftTitle = NSLocalizedString("Hide colored circles on mouse hover", comment: "")
        hideColoredCircles.rightViews.append(LabelAndControl.makeCheckbox("hideColoredCircles", extraAction: { sender in
            self.onCheckboxClicked(sender: sender, rowId: hideColoredCircles.rowId)
        }))
        showHideRows.append(hideColoredCircles)

        var hideWindowlessApps = ShowHideRowInfo()
        hideWindowlessApps.uncheckedImage = "show_windowless_apps"
        hideWindowlessApps.checkedImage = "hide_windowless_apps"
        hideWindowlessApps.supportedModels = [.thumbnails, .appIcons, .titles]
        hideWindowlessApps.leftTitle = NSLocalizedString("Hide apps with no open window", comment: "")
        hideWindowlessApps.rightViews.append(LabelAndControl.makeCheckbox("hideWindowlessApps", extraAction: { sender in
            self.onCheckboxClicked(sender: sender, rowId: hideWindowlessApps.rowId)
        }))
        showHideRows.append(hideWindowlessApps)

        var showTabsAsWindows = ShowHideRowInfo()
        showTabsAsWindows.uncheckedImage = "hide_tabs_as_windows"
        showTabsAsWindows.checkedImage = "show_tabs_as_windows"
        showTabsAsWindows.supportedModels = [.thumbnails, .appIcons, .titles]
        showTabsAsWindows.leftTitle = NSLocalizedString("Show standard tabs as windows", comment: "")
        showTabsAsWindows.subTitle = NSLocalizedString("Some apps like Finder or Preview use standard tabs which act like independent windows. Some other apps like web browsers use custom tabs which act in unique ways and are not actual windows. AltTab can't list those separately.", comment: "")
        showTabsAsWindows.rightViews.append(LabelAndControl.makeInfoButton(width: 15, height: 15, onMouseEntered: { event, view in
            Popover.shared.show(event: event, positioningView: view, message: showTabsAsWindows.subTitle!)
        }, onMouseExited: { event, view in
            Popover.shared.hide()
        }))
        showTabsAsWindows.rightViews.append(LabelAndControl.makeCheckbox("showTabsAsWindows", extraAction: { sender in
            self.onCheckboxClicked(sender: sender, rowId: showTabsAsWindows.rowId)
        }))
        showHideRows.append(showTabsAsWindows)

        var previewFocusedWindow = ShowHideRowInfo()
        previewFocusedWindow.uncheckedImage = "hide_preview_focused_window"
        previewFocusedWindow.checkedImage = "show_preview_focused_window"
        previewFocusedWindow.supportedModels = [.thumbnails, .appIcons, .titles]
        previewFocusedWindow.leftTitle = NSLocalizedString("Preview selected window", comment: "")
        previewFocusedWindow.rightViews.append(LabelAndControl.makeCheckbox("previewFocusedWindow", extraAction: { sender in
            self.onCheckboxClicked(sender: sender, rowId: previewFocusedWindow.rowId)
        }))
        showHideRows.append(previewFocusedWindow)
    }

    /// Handles the event when a checkbox is clicked.
    /// Updates the image view based on the state of the checkbox.
    ///
    /// - Parameters:
    ///   - sender: The checkbox button that was clicked.
    ///   - rowId: The identifier for the row associated with the checkbox.
    private func onCheckboxClicked(sender: NSControl, rowId: String) {
        if let sender = sender as? NSButton {
            let isChecked = sender.state == .on
            updateImageView(rowId: rowId, isChecked: isChecked)
        }
    }

    private func updateImageView(rowId: String, isChecked: Bool) {
        let row = showHideRows.first { $0.rowId.elementsEqual(rowId) }
        let imageName = isChecked ? row?.checkedImage : row?.uncheckedImage
        illustratedImageView.highlight(false, imageName!)
    }

    private func updateImageView(rowId: String) {
        let row = showHideRows.first { $0.rowId.elementsEqual(rowId) }
        row?.rightViews.forEach { view in
            if let checkbox = view as? NSButton {
                let isChecked = checkbox.state == .on
                let imageName = isChecked ? row?.checkedImage : row?.uncheckedImage
                illustratedImageView.highlight(false, imageName!)
            }
        }
    }

    private func clickCheckbox(rowId: String) {
        let row = showHideRows.first { $0.rowId.elementsEqual(rowId) }
        row?.rightViews.forEach { view in
            if let checkbox = view as? NSButton {
                // Toggle the checkbox state
                checkbox.state = (checkbox.state == .on) ? .off : .on
            }
        }
    }
}

class CustomizeModelSettingsWindow: NSWindow {
    static let width = AppearanceTab.sheetWidth
    static let illustratedImageWidth = width

    var model: AppearanceModelPreference = .thumbnails
    var illustratedImageView: IllustratedImageThemeView!
    var alignThumbnails: TableGroupView.Row!
    var titleTruncation: TableGroupView.Row!
    var showAppsWindows: TableGroupView.Row!
    var showAppNamesWindowTitles: TableGroupView.Row!

    var showHideView: TableGroupSetView!
    var advancedView: TableGroupSetView!
    var doneButton: NSButton!

    convenience init(_ model: AppearanceModelPreference) {
        self.init(contentRect: .zero, styleMask: [.titled, .closable], backing: .buffered, defer: false)
        self.model = model
        setupWindow()
        setupView()
    }

    private func setupWindow() {
        hidesOnDeactivate = false
        makeKeyAndOrderFront(nil)
    }

    private func setupView() {
        makeComponents()
        showHideView = ShowHideIllustratedView(model, illustratedImageView).makeView()

        if model == .thumbnails {
            advancedView = makeThumbnailsView()
        } else if model == .appIcons {
            advancedView = makeAppIconsView()
        } else if model == .titles {
            advancedView = makeTitlesView()
        }
        let control = NSSegmentedControl(labels: [
            NSLocalizedString("Show & Hide", comment: ""),
            NSLocalizedString("Advanced", comment: "")
        ], trackingMode: .selectOne, target: self, action: #selector(switchTab(_:)))
        control.selectedSegment = 0
        control.segmentStyle = .automatic
        control.widthAnchor.constraint(equalToConstant: CustomizeModelSettingsWindow.width).isActive = true

        let view = TableGroupSetView(originalViews: [illustratedImageView, control, showHideView, advancedView],
                toolsViews: [doneButton],
                othersAlignment: NSLayoutConstraint.Attribute.centerX)
        contentView = view
        switchTab(control)
    }

    private func makeComponents() {
        illustratedImageView = IllustratedImageThemeView(model, CustomizeModelSettingsWindow.illustratedImageWidth)
        alignThumbnails = TableGroupView.Row(leftTitle: NSLocalizedString("Align windows", comment: ""),
                rightViews: [LabelAndControl.makeDropdown(
                        "alignThumbnails", AlignThumbnailsPreference.allCases, extraAction: { _ in
                    self.showAlignThumbnailsIllustratedImage()
                })])
        titleTruncation = TableGroupView.Row(leftTitle: NSLocalizedString("Window title truncation", comment: ""),
                rightViews: [LabelAndControl.makeDropdown("titleTruncation", TitleTruncationPreference.allCases)])
        showAppsWindows = TableGroupView.Row(leftTitle: NSLocalizedString("Show running", comment: ""),
                rightViews: LabelAndControl.makeRadioButtons(ShowAppsWindowsPreference.allCases,
                        "showAppsWindows", extraAction: { _ in
                    self.toggleAppNamesWindowTitles()
                    self.showAppsOrWindowsIllustratedImage()
                }))
        showAppNamesWindowTitles = TableGroupView.Row(leftTitle: NSLocalizedString("Show titles", comment: ""),
                rightViews: [LabelAndControl.makeDropdown(
                        "showAppNamesWindowTitles", ShowAppNamesWindowTitlesPreference.allCases, extraAction: { _ in
                    self.showAppsOrWindowsIllustratedImage()
                })])

        doneButton = NSButton(title: NSLocalizedString("Done", comment: ""), target: self, action: #selector(closeWindow(_:)))
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        if #available(macOS 10.14, *) {
            doneButton.bezelColor = NSColor.controlAccentColor
        }
    }

    private func makeThumbnailsView() -> TableGroupSetView {
        let table = TableGroupView(width: CustomizeModelSettingsWindow.width)
        _ = table.addRow(alignThumbnails, onMouseEntered: { event, view in
            self.showAlignThumbnailsIllustratedImage()
        }, onMouseExited: { event, view in
            self.illustratedImageView.highlight()
        })
        _ = table.addRow(titleTruncation)
        table.onMouseExited = { event, view in
            self.illustratedImageView.highlight()
        }
        table.fit()

        let view = TableGroupSetView(originalViews: [table], padding: 0)
        return view
    }

    private func makeAppIconsView() -> TableGroupSetView {
        let table1 = makeAppWindowTableGroupView()
        table1.fit()

        let table2 = TableGroupView(width: CustomizeModelSettingsWindow.width)
        _ = table2.addRow(alignThumbnails, onMouseEntered: { event, view in
            self.showAlignThumbnailsIllustratedImage()
        })
        table2.onMouseExited = { event, view in
            self.illustratedImageView.highlight()
        }
        table2.fit()

        let view = TableGroupSetView(originalViews: [table1, table2], padding: 0)
        toggleAppNamesWindowTitles()
        return view
    }

    private func makeTitlesView() -> TableGroupSetView {
        let table1 = makeAppWindowTableGroupView()
        table1.fit()

        let table2 = TableGroupView(width: CustomizeModelSettingsWindow.width)
        _ = table2.addRow(titleTruncation)
        table2.fit()

        let view = TableGroupSetView(originalViews: [table1, table2], padding: 0)
        toggleAppNamesWindowTitles()
        return view
    }

    private func makeAppWindowTableGroupView() -> TableGroupView {
        let view = TableGroupView(title: NSLocalizedString("Applications & Windows", comment: ""),
                subTitle: NSLocalizedString("Provide the ability to switch between displaying applications in a windowed form (allowing an application to contain multiple windows) or in an application form (where each application can only have one window).", comment: ""),
                width: CustomizeModelSettingsWindow.width)
        _ = view.addRow(showAppsWindows, onMouseEntered: { event, view in
            self.showAppsOrWindowsIllustratedImage()
        })
        _ = view.addRow(showAppNamesWindowTitles, onMouseEntered: { event, view in
            self.showAppsOrWindowsIllustratedImage()
        })
        view.onMouseExited = { event, view in
            self.illustratedImageView.highlight()
        }
        return view
    }

    private func toggleAppNamesWindowTitles() {
        let button = showAppNamesWindowTitles.rightViews[0] as? NSControl
        if Preferences.showAppsWindows == .windows {
            button?.isEnabled = true
        } else {
            button?.isEnabled = false
        }
    }

    private func showAlignThumbnailsIllustratedImage() {
        self.illustratedImageView.highlight(false, Preferences.alignThumbnails.image.name)
    }

    private func showAppsOrWindowsIllustratedImage() {
        var imageName = ShowAppNamesWindowTitlesPreference.windowTitles.image.name
        if Preferences.showAppsWindows == .applications || Preferences.showAppNamesWindowTitles == .applicationNames {
            imageName = ShowAppNamesWindowTitlesPreference.applicationNames.image.name
        } else if Preferences.showAppNamesWindowTitles == .applicationNamesAndWindowTitles {
            imageName = ShowAppNamesWindowTitlesPreference.applicationNamesAndWindowTitles.image.name
        }
        self.illustratedImageView.highlight(false, imageName)
    }

    func reset() {
        illustratedImageView.highlight()
        [showHideView, advancedView].forEach { tableGroupSetView in
            tableGroupSetView.originalViews.forEach { view in
                if let view = view as? TableGroupView {
                    view.removeLastMouseEnteredEffects()
                }
            }
        }
    }

    @objc func switchTab(_ sender: NSSegmentedControl) {
        if sender.selectedSegment == 0 {
            showHideView.isHidden = false
            advancedView.isHidden = true
        } else if sender.selectedSegment == 1 {
            advancedView.isHidden = false
            showHideView.isHidden = true
        }
        reset()
        adjustWindowHeight()
    }

    private func adjustWindowHeight() {
        let newHeight = contentView?.intrinsicContentSize.height ?? 0
        var windowFrame = frame
        windowFrame.size.height = newHeight
        setFrame(windowFrame, display: true, animate: false)
    }

    @objc func closeWindow(_ sender: NSButton) {
        if let sheetWindow = sender.window {
            if let mainWindow = sheetWindow.sheetParent {
                mainWindow.endSheet(sheetWindow)
            }
        }
    }
}

class AdvancedSettingsWindow: NSWindow {
    static let width = AppearanceTab.sheetWidth

    var doneButton: NSButton!

    convenience init() {
        self.init(contentRect: .zero, styleMask: [.titled, .closable], backing: .buffered, defer: false)
        setupWindow()
        setupView()
    }

    private func setupWindow() {
        hidesOnDeactivate = false
        makeKeyAndOrderFront(nil)
    }

    private func setupView() {
        makeComponent()
        let animationView = makeAnimationView()

        let view = TableGroupSetView(originalViews: [animationView], toolsViews: [doneButton])
        view.widthAnchor.constraint(equalToConstant: AdvancedSettingsWindow.width + TableGroupSetView.leftRightPadding).isActive = true
        contentView = view
    }

    private func makeAnimationView() -> NSStackView {
        let table = TableGroupView(title: "Animation", width: AdvancedSettingsWindow.width)
        _ = table.addRow(leftText: NSLocalizedString("Apparition delay millisecond", comment: ""),
                rightViews: Array(LabelAndControl.makeLabelWithSlider("", "windowDisplayDelay", 0, 2000, 11, true, "ms", width: 300)[1...2]))
        _ = table.addRow(leftText: NSLocalizedString("Fade out animation", comment: ""),
                rightViews: LabelAndControl.makeCheckbox("fadeOutAnimation"))
        table.fit()
        return table
    }

    private func makeComponent() {
        doneButton = NSButton(title: NSLocalizedString("Done", comment: ""), target: self, action: #selector(closeWindow(_:)))
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        if #available(macOS 10.14, *) {
            doneButton.bezelColor = NSColor.controlAccentColor
        }
    }

    @objc func closeWindow(_ sender: NSButton) {
        if let sheetWindow = sender.window {
            if let mainWindow = sheetWindow.sheetParent {
                mainWindow.endSheet(sheetWindow)
            }
        }
    }
}

class Popover: NSPopover {
    static let shared = Popover()

    override init() {
        super.init()
        contentViewController = NSViewController()
        behavior = .semitransient
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func hide() {
        performClose(nil)
    }

    func show(event: NSEvent, positioningView: NSView, message: String) {
        hide()
        let view = NSView()

        let label = NSTextField(labelWithString: message)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.maximumNumberOfLines = 0
        label.isEditable = false
        label.isSelectable = true
        label.textColor = NSColor.gray
        label.font = NSFont.systemFont(ofSize: 12)
        view.addSubview(label)

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 400),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
        contentViewController?.view = view

        // Convert the mouse location to the positioning view's coordinate system
        let locationInWindow = event.locationInWindow
        let locationInPositioningView = positioningView.convert(locationInWindow, from: nil)
        let rect = CGRect(origin: locationInPositioningView, size: .zero)

        show(relativeTo: rect, of: positioningView, preferredEdge: .minX)
    }
}

class AppearanceTab: NSObject {
    static var shared = AppearanceTab()
    static let width = CGFloat(650)
    static let sheetWidth = CGFloat(512)

    static var modelAdvancedButton: NSButton!
    static var advancedButton: NSButton!

    static func initTab() -> NSView {
        makeModelAdvancedButton()
        makeAdvancedButton()
        return makeView()
    }

    private static func makeView() -> NSStackView {
        let appearanceView = makeAppearanceView()
        let positionView = makePositionView()

        let view = TableGroupSetView(originalViews: [appearanceView, positionView, advancedButton])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: view.fittingSize.width).isActive = true
        return view
    }

    private static func makeAppearanceView() -> NSView {
        let table = TableGroupView(title: "Appearance",
                subTitle: "The appearance feature enables the switcher to switch among multiple modes, each with a different UI. It is capable of adjusting various display aspects such as size, color, and layout. Each appearance mode has its own unique settings.",
                width: AppearanceTab.width)
        _ = table.addRow(leftText: NSLocalizedString("Appearance model", comment: ""),
                rightViews: LabelAndControl.makeLabelWithImageRadioButtons("", "appearanceModel", AppearanceModelPreference.allCases, extraAction: { _ in
            toggleModelAdvancedButton()
        }, buttonSpacing: 20)[1])
        _ = table.addRow(leftText: NSLocalizedString("Appearance size", comment: ""),
                rightViews: LabelAndControl.makeLabelWithRadioButtons("", "appearanceSize", AppearanceSizePreference.allCases)[1])
        _ = table.addRow(rightViews: modelAdvancedButton)

        table.fit()
        return table
    }

    private static func makePositionView() -> NSView {
        let table = TableGroupView(title: "Position", subTitle: "When we have multiple monitors, the position feature allows us to decide on which monitor the switcher is displayed, enabling a seamless window moving experience.", width: AppearanceTab.width)
        _ = table.addRow(leftText: NSLocalizedString("Show on screen", comment: ""),
                rightViews: LabelAndControl.makeDropdown("showOnScreen", ShowOnScreenPreference.allCases))
        table.fit()
        return table
    }

    private static func makeAdvancedButton() {
        advancedButton = NSButton(title: NSLocalizedString("Advanced…", comment: ""), target: self, action: #selector(AppearanceTab.showAdvancedSettings))
    }

    private static func makeModelAdvancedButton() {
        modelAdvancedButton = NSButton(title: getModelAdvancedButtonTitle(), target: self, action: #selector(showModelAdvancedSettings))
        modelAdvancedButton.widthAnchor.constraint(equalToConstant: 170).isActive = true
    }

    private static func getModelAdvancedButtonTitle() -> String {
        if Preferences.appearanceModel == .thumbnails {
            return NSLocalizedString("Customize Thumbnails…", comment: "")
        } else if Preferences.appearanceModel == .appIcons {
            return NSLocalizedString("Customize App Icons…", comment: "")
        } else if Preferences.appearanceModel == .titles {
            return NSLocalizedString("Customize Titles…", comment: "")
        }
        return NSLocalizedString("Advanced…", comment: "")
    }

    @objc static func toggleModelAdvancedButton() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(handleToggleAdvancedButton), object: nil)
        self.perform(#selector(handleToggleAdvancedButton), with: nil, afterDelay: 0.1)
    }

    @objc static func handleToggleAdvancedButton() {
        modelAdvancedButton.animator().title = getModelAdvancedButtonTitle()
    }

    @objc static func showModelAdvancedSettings() {
        let advancedSettingsSheetWindow = CustomizeModelSettingsWindow(Preferences.appearanceModel)
        App.app.preferencesWindow.beginSheet(advancedSettingsSheetWindow)
    }

    @objc static func showAdvancedSettings() {
        App.app.preferencesWindow.beginSheet(AdvancedSettingsWindow())
    }
}
