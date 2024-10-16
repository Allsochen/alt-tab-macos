import Cocoa

class CustomizeSizeView {
    private let style: AppearanceStylePreference
    var table1: TableGroupView!
    var table2: TableGroupView!

    var enabledCustomizeAppearanceSize: TableGroupView.Row!
    var rowsCount: TableGroupView.Row!
    var minWidthInRow: TableGroupView.Row!
    var maxWidthInRow: TableGroupView.Row!
    var maxWidthOnScreen: TableGroupView.Row!
    var maxHeightOnScreen: TableGroupView.Row!
    var iconSize: TableGroupView.Row!
    var fontHeight: TableGroupView.Row!

    var onToggleCustomizeAppearanceSize: (() -> Void)?

    init(_ style: AppearanceStylePreference) {
        self.style = style
        setupItems()
    }

    func makeView() -> TableGroupSetView {
        table1 = TableGroupView(width: CustomizeStyleSheet.width)
        table1.addRow(enabledCustomizeAppearanceSize)

        table2 = TableGroupView(
                subTitle: NSLocalizedString("This will override the default predefine appearance size.", comment: ""),
                width: CustomizeStyleSheet.width)
        if style == .thumbnails {
            table2.addRow(maxWidthOnScreen)
            table2.addRow(maxHeightOnScreen)
            table2.addRow(minWidthInRow)
            table2.addRow(maxWidthInRow)
            table2.addRow(rowsCount)
            table2.addRow(iconSize)
            table2.addRow(fontHeight)
        } else if style == .appIcons {
            table2.addRow(maxWidthOnScreen)
            table2.addRow(maxHeightOnScreen)
            table2.addRow(minWidthInRow)
            table2.addRow(maxWidthInRow)
            table2.addRow(iconSize)
            table2.addRow(fontHeight)
        } else if style == .titles {
            table2.addRow(maxWidthOnScreen)
            table2.addRow(maxHeightOnScreen)
            table2.addRow(minWidthInRow)
            table2.addRow(maxWidthInRow)
            table2.addRow(iconSize)
            table2.addRow(fontHeight)
        }

        let view = TableGroupSetView(originalViews: [table1, table2], tableGroupSpacing: 20, padding: 0)
        return view
    }

    private func setupItems() {
        enabledCustomizeAppearanceSize = TableGroupView.Row(leftTitle: NSLocalizedString("Enabled customize appearance size", comment: ""),
                rightViews: [LabelAndControl.makeSwitch("enabledCustomizeAppearanceSize", extraAction: { _ in
                    self.toggleCustomizeAppearanceSize()
                })])

        let maxWidthOnScreenSlide = LabelAndControl.makeLabelWithSlider("", "maxWidthOnScreen", 10, 100, 20, true, "%")
        maxWidthOnScreen = TableGroupView.Row(leftTitle: NSLocalizedString("Max width on screen", comment: ""),
                rightViews: adaptToRowViews(maxWidthOnScreenSlide))

        let maxHeightOnScreenSlide = LabelAndControl.makeLabelWithSlider("", "maxHeightOnScreen", 10, 100, 20, true, "%")
        maxHeightOnScreen = TableGroupView.Row(leftTitle: NSLocalizedString("Max height on screen", comment: ""),
                rightViews: adaptToRowViews(maxHeightOnScreenSlide))

        let maxWidthInRowSlide = LabelAndControl.makeLabelWithSlider("", "windowMaxWidthInRow", 1, 100, 20, true, "%",
                extraAction: { _ in self.capMinMaxWidthInRow() })
        maxWidthInRow = TableGroupView.Row(leftTitle: NSLocalizedString("Window max width in row", comment: ""),
                rightViews: adaptToRowViews(maxWidthInRowSlide))

        let minWidthInRowSlide = LabelAndControl.makeLabelWithSlider("", "windowMinWidthInRow", 1, 100, 20, true, "%",
                extraAction: { _ in self.capMinMaxWidthInRow() })
        minWidthInRow = TableGroupView.Row(leftTitle: NSLocalizedString("Window min width in row", comment: ""),
                rightViews: adaptToRowViews(minWidthInRowSlide))

        let rowsCountSlide = LabelAndControl.makeLabelWithSlider("", "rowsCount", 1, 20, 20, true)
        rowsCount = TableGroupView.Row(leftTitle: NSLocalizedString("Rows of thumbnails", comment: ""),
                rightViews: adaptToRowViews(rowsCountSlide))

        let iconSizeSlide = LabelAndControl.makeLabelWithSlider("", "iconSize", 0, 128, 21, true, "px")
        iconSize = TableGroupView.Row(leftTitle: NSLocalizedString("Window app icon size", comment: ""),
                rightViews: adaptToRowViews(iconSizeSlide))

        let fontHeightSlide = LabelAndControl.makeLabelWithSlider("", "fontHeight", 0, 64, 21, true, "px")
        fontHeight = TableGroupView.Row(leftTitle: NSLocalizedString("Window title font size", comment: ""),
                rightViews: adaptToRowViews(fontHeightSlide))
    }

    public func toggleCustomizeAppearanceSize() {
        // toggle the slider
        table2.isHidden = !Preferences.enabledCustomizeAppearanceSize
        resetCustomizeSize()
        onToggleCustomizeAppearanceSize?()
    }

    private func adaptToRowViews(_ slide: [NSView]) -> [NSView] {
        slide[2].fit(40, slide[2].fittingSize.height)
        // [rule, indicator]
        return [slide[1], slide[2]]
    }

    func resetCustomizeSize() {
        let parameters = Appearance.getDefaultAppearanceSizeParameters(Preferences.appearanceStyle,
                AppearanceSizePreference.medium,
                Preferences.appearanceVisibility)
        logger.d("parameters", parameters)
        Preferences.maxWidthOnScreen = parameters.maxWidthOnScreen
        Preferences.maxHeightOnScreen = parameters.maxHeightOnScreen
        Preferences.windowMinWidthInRow = parameters.windowMinWidthInRow
        Preferences.windowMaxWidthInRow = parameters.windowMaxWidthInRow
        Preferences.rowsCount = parameters.rowsCount
        Preferences.iconSize = parameters.iconSize
        Preferences.fontHeight = parameters.fontHeight
    }

    private func capMinMaxWidthInRow() {
        let minSlider = minWidthInRow.rightViews[0] as! NSSlider
        let maxSlider = maxWidthInRow.rightViews[0] as! NSSlider
        maxSlider.minValue = minSlider.doubleValue
        LabelAndControl.controlWasChanged(maxSlider, "windowMaxWidthInRow")
    }
}

class CustomizeStyleSheet: SheetWindow {
    static let illustratedImageWidth = width

    let style = Preferences.appearanceStyle
    var illustratedImageInstance: IllustratedImageThemeView!
    var showHideIllustratedInstance: ShowHideIllustratedView!
    var customizeSizeViewInstance: CustomizeSizeView!

    var alignThumbnails: TableGroupView.Row!
    var titleTruncation: TableGroupView.Row!
    var showAppsOrWindows: TableGroupView.Row!
    var showTitles: TableGroupView.Row!
    var showTitlesRowInfo: TableGroupView.RowInfo!

    var showHideView: TableGroupSetView!
    var advancedView: TableGroupSetView!
    var customizeSizeView: TableGroupSetView!
    var control: NSSegmentedControl!

    override func makeContentView() -> NSView {
        makeComponents()
        showHideView = showHideIllustratedInstance.makeView()
        customizeSizeView = customizeSizeViewInstance.makeView()

        if style == .thumbnails {
            advancedView = makeThumbnailsView()
        } else if style == .appIcons {
            advancedView = makeAppIconsView()
        } else if style == .titles {
            advancedView = makeTitlesView()
        }
        control = NSSegmentedControl(labels: [
            NSLocalizedString("Show & Hide", comment: ""),
            NSLocalizedString("Advanced", comment: ""),
            NSLocalizedString("Customize size", comment: ""),
        ], trackingMode: .selectOne, target: self, action: #selector(switchTab(_:)))
        control.selectedSegment = 0
        control.segmentStyle = .automatic
        control.widthAnchor.constraint(equalToConstant: CustomizeStyleSheet.width).isActive = true

        let view = TableGroupSetView(originalViews: [illustratedImageInstance, control, showHideView, advancedView, customizeSizeView], padding: 0)
        return view
    }

    override func setupView() {
        super.setupView()
        switchTab(control)
    }

    private func makeComponents() {
        illustratedImageInstance = IllustratedImageThemeView(style, CustomizeStyleSheet.illustratedImageWidth)
        customizeSizeViewInstance = CustomizeSizeView(style)
        customizeSizeViewInstance.onToggleCustomizeAppearanceSize = { [weak self] in
            self?.adjustWindowHeight()
            self?.contentView?.needsDisplay = true
        }
        showHideIllustratedInstance = ShowHideIllustratedView(style, illustratedImageInstance)
        alignThumbnails = TableGroupView.Row(leftTitle: NSLocalizedString("Align windows", comment: ""),
                rightViews: LabelAndControl.makeRadioButtons(
                        "alignThumbnails", AlignThumbnailsPreference.allCases, extraAction: { _ in
                    self.showAlignThumbnailsIllustratedImage()
                }))
        titleTruncation = TableGroupView.Row(leftTitle: NSLocalizedString("Title truncation", comment: ""),
                rightViews: LabelAndControl.makeRadioButtons("titleTruncation", TitleTruncationPreference.allCases))
        let showAppWindowsInfo = LabelAndControl.makeInfoButton(onMouseEntered: { (event, view) in
            Popover.shared.show(event: event, positioningView: view,
                    message: NSLocalizedString("Show an item in the switcher for each window, or for each application. Windows will be focused, whereas applications will be activated.", comment: ""))
        }, onMouseExited: { (event, view) in
            Popover.shared.hide()
        })
        showAppsOrWindows = TableGroupView.Row(leftTitle: NSLocalizedString("Show in switcher", comment: ""),
                rightViews: LabelAndControl.makeRadioButtons("showAppsOrWindows", ShowAppsOrWindowsPreference.allCases, extraAction: { _ in
                    self.showHideIllustratedInstance.setStateOnApplications()
                    self.toggleAppNamesWindowTitles()
                    self.showAppsOrWindowsIllustratedImage()
                }) + [showAppWindowsInfo])
        showTitles = TableGroupView.Row(leftTitle: NSLocalizedString("Show titles", comment: ""),
                rightViews: [LabelAndControl.makeDropdown(
                        "showTitles", ShowTitlesPreference.allCases, extraAction: { _ in
                    self.showAppsOrWindowsIllustratedImage()
                })])
    }

    private func makeThumbnailsView() -> TableGroupSetView {
        let table = TableGroupView(width: CustomizeStyleSheet.width)
        showTitlesRowInfo = table.addRow(showTitles, onMouseEntered: { event, view in
            self.showAppsOrWindowsIllustratedImage()
        })
        table.addNewTable()
        table.addRow(alignThumbnails, onMouseEntered: { event, view in
            self.showAlignThumbnailsIllustratedImage()
        }, onMouseExited: { event, view in
            IllustratedImageThemeView.resetImage(self.illustratedImageInstance, event, view)
        })
        table.addRow(titleTruncation)
        table.onMouseExited = { event, view in
            IllustratedImageThemeView.resetImage(self.illustratedImageInstance, event, view)
        }
        table.fit()

        let view = TableGroupSetView(originalViews: [table], padding: 0)
        return view
    }

    private func makeAppIconsView() -> TableGroupSetView {
        let table = makeAppWindowTableGroupView()
        table.addNewTable()
        table.addRow(alignThumbnails, onMouseEntered: { event, view in
            self.showAlignThumbnailsIllustratedImage()
        })
        table.onMouseExited = { event, view in
            IllustratedImageThemeView.resetImage(self.illustratedImageInstance, event, view)
        }
        table.fit()

        let view = TableGroupSetView(originalViews: [table], padding: 0)
        toggleAppNamesWindowTitles()
        return view
    }

    private func makeTitlesView() -> TableGroupSetView {
        let table = makeAppWindowTableGroupView()
        table.addNewTable()
        table.addRow(titleTruncation)
        table.fit()

        let view = TableGroupSetView(originalViews: [table], padding: 0)
        toggleAppNamesWindowTitles()
        return view
    }

    private func makeAppWindowTableGroupView() -> TableGroupView {
        let view = TableGroupView(width: CustomizeStyleSheet.width)
        view.addRow(showAppsOrWindows, onMouseEntered: { event, view in
            self.showAppsOrWindowsIllustratedImage()
        })
        view.addNewTable()
        showTitlesRowInfo = view.addRow(showTitles, onMouseEntered: { event, view in
            self.showAppsOrWindowsIllustratedImage()
        })
        view.onMouseExited = { event, view in
            IllustratedImageThemeView.resetImage(self.illustratedImageInstance, event, view)
        }
        return view
    }

    private func toggleAppNamesWindowTitles() {
        var isEnabled = false
        if Preferences.showAppsOrWindows == .windows || Preferences.appearanceStyle == .thumbnails {
            isEnabled = true
        }
        showTitlesRowInfo.leftViews?.forEach { view in
            if let view = view as? NSTextField {
                view.textColor = isEnabled ? NSColor.textColor : NSColor.gray
            }
        }
        showTitlesRowInfo.rightViews?.forEach { view in
            if let view = view as? NSControl {
                view.isEnabled = isEnabled
            }
        }
    }

    private func showAlignThumbnailsIllustratedImage() {
        self.illustratedImageInstance.highlight(true, Preferences.alignThumbnails.image.name)
    }

    private func showAppsOrWindowsIllustratedImage() {
        var imageName = Preferences.showTitles.image.name
        if Preferences.onlyShowApplications() {
            imageName = ShowTitlesPreference.appName.image.name
        }
        self.illustratedImageInstance.highlight(true, imageName)
    }

    @objc func switchTab(_ sender: NSSegmentedControl) {
        let selectedIndex = sender.selectedSegment
        [showHideView, advancedView, customizeSizeView].enumerated().forEach { (index, view) in
            if selectedIndex == index {
                view!.isHidden = false
            } else {
                view!.isHidden = true
            }
        }
        customizeSizeViewInstance.toggleCustomizeAppearanceSize()
        adjustWindowHeight()
    }

    private func adjustWindowHeight() {
        guard let contentView = self.contentView else { return }

        // Calculate the fitting height of the content view
        let fittingSize = contentView.fittingSize
        var windowFrame = frame
        windowFrame.size.height = fittingSize.height
        setFrame(windowFrame, display: true, animate: false)
    }
}
