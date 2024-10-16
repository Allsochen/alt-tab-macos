import Cocoa

struct AppearanceSizeParameters: CustomStringConvertible {
    var windowPadding = CGFloat(18)
    var interCellPadding = CGFloat(5)
    var intraCellPadding = CGFloat(1)
    var edgeInsetsSize = CGFloat(5)
    var cellCornerRadius = CGFloat(10)
    var windowCornerRadius = CGFloat(23)

    var hideThumbnails = Bool(false)
    var maxWidthOnScreen = CGFloat(0)
    var maxHeightOnScreen = CGFloat(0)
    var windowMinWidthInRow = CGFloat(0)
    var windowMaxWidthInRow = CGFloat(0)
    var rowsCount = CGFloat(0)
    var iconSize = CGFloat(0)
    var fontHeight = CGFloat(0)

    var description: String {
        return """
               AppearanceSizeParameters(
                   windowPadding: \(windowPadding),
                   interCellPadding: \(interCellPadding),
                   intraCellPadding: \(intraCellPadding),
                   edgeInsetsSize: \(edgeInsetsSize),
                   cellCornerRadius: \(cellCornerRadius),
                   windowCornerRadius: \(windowCornerRadius),
                   hideThumbnails: \(hideThumbnails),
                   maxWidthOnScreen: \(maxWidthOnScreen),
                   maxHeightOnScreen: \(maxHeightOnScreen)
                   windowMinWidthInRow: \(windowMinWidthInRow),
                   windowMaxWidthInRow: \(windowMaxWidthInRow),
                   rowsCount: \(rowsCount),
                   iconSize: \(iconSize),
                   fontHeight: \(fontHeight),
               )
               """
    }
}

class Appearance {
    // size
    static var windowPadding = CGFloat(18)
    static var interCellPadding = CGFloat(5)
    static var intraCellPadding = CGFloat(1)
    static var edgeInsetsSize = CGFloat(5)
    static var cellCornerRadius = CGFloat(10)
    static var windowCornerRadius = CGFloat(23)
    static var hideThumbnails = Bool(false)
    static var maxWidthOnScreen = CGFloat(0)
    static var maxHeightOnScreen = CGFloat(0)
    static var windowMinWidthInRow = CGFloat(0)
    static var windowMaxWidthInRow = CGFloat(0)
    static var rowsCount = CGFloat(0)
    static var iconSize = CGFloat(0)
    static var fontHeight = CGFloat(0)

    // theme
    static var material = NSVisualEffectView.Material.dark
    static var fontColor = NSColor.white
    static var indicatedIconShadowColor: NSColor? = .darkGray
    static var titleShadowColor: NSColor? = .darkGray
    static var imageShadowColor: NSColor? = .gray // for icon, thumbnail and windowless images
    static var highlightMaterial = NSVisualEffectView.Material.selection
    static var highlightFocusedAlphaValue = 1.0
    static var highlightHoveredAlphaValue = 0.8
    static var highlightFocusedBackgroundColor = NSColor.black.withAlphaComponent(0.5)
    static var highlightHoveredBackgroundColor = NSColor.black.withAlphaComponent(0.3)
    static var highlightFocusedBorderColor = NSColor.clear
    static var highlightHoveredBorderColor = NSColor.clear
    static var highlightBorderShadowColor = NSColor.clear
    static var highlightBorderWidth = CGFloat(0)
    static var enablePanelShadow = false

    // derived
    static var font: NSFont {
        NSFont.systemFont(ofSize: fontHeight)
    }

    private static var currentStyle: AppearanceStylePreference {
        Preferences.appearanceStyle
    }
    private static var currentSize: AppearanceSizePreference {
        Preferences.appearanceSize
    }
    private static var currentTheme: AppearanceThemePreference {
        if Preferences.appearanceTheme == .system {
            return NSAppearance.current.getThemeName()
        } else {
            return Preferences.appearanceTheme
        }
    }
    private static var currentVisibility: AppearanceVisibilityPreference {
        Preferences.appearanceVisibility
    }
    private static var enabledCustomizeAppearanceSize: Bool {
        Preferences.enabledCustomizeAppearanceSize
    }

    static func update() {
        updateSize()
        updateTheme()
    }

    private static func updateSize() {
        var parameters = getDefaultAppearanceSizeParameters(currentStyle, currentSize, currentVisibility)
        setUserCustomizeSizeParameters(&parameters)
        assignSizeParameters(parameters)
    }

    private static func updateTheme() {
        if currentTheme == .dark {
            darkTheme()
        } else {
            lightTheme()
        }
    }

    static func getDefaultAppearanceSizeParameters(
            _ style: AppearanceStylePreference,
            _ size: AppearanceSizePreference,
            _ visibility: AppearanceVisibilityPreference) -> AppearanceSizeParameters {
        if currentStyle == .appIcons {
            return getAppIconsSize(currentSize, currentVisibility)
        } else if currentStyle == .titles {
            return getTitlesSize(currentSize, currentVisibility)
        }
        return getThumbnailsSize(currentSize, currentVisibility)
    }

    private static func setUserCustomizeSizeParameters(_ parameters: inout AppearanceSizeParameters) {
        if enabledCustomizeAppearanceSize {
            parameters.maxWidthOnScreen = Preferences.maxWidthOnScreen
            parameters.maxHeightOnScreen = Preferences.maxHeightOnScreen
            parameters.windowMinWidthInRow = Preferences.windowMinWidthInRow
            parameters.windowMaxWidthInRow = Preferences.windowMaxWidthInRow
            parameters.rowsCount = Preferences.rowsCount
            parameters.iconSize = Preferences.iconSize
            parameters.fontHeight = Preferences.fontHeight
        }
    }

    static func getThumbnailsSize(_ size: AppearanceSizePreference,
                                  _ visibility: AppearanceVisibilityPreference) -> AppearanceSizeParameters {
        var parameters = AppearanceSizeParameters()
        let isHorizontalScreen = NSScreen.preferred().isHorizontal()

        parameters.hideThumbnails = false
        parameters.windowPadding = 18
        parameters.cellCornerRadius = 10
        parameters.windowCornerRadius = 23
        parameters.intraCellPadding = 5
        parameters.interCellPadding = 1
        parameters.edgeInsetsSize = 12

        parameters.maxWidthOnScreen = 0.9
        parameters.maxHeightOnScreen = 0.8
        parameters.windowMinWidthInRow = 0.1
        parameters.windowMaxWidthInRow = 0.9



        switch size {
            case .small:
                parameters.rowsCount = isHorizontalScreen ? 5 : 8
                parameters.windowMinWidthInRow = 0.08
                parameters.windowMaxWidthInRow = 0.9
                parameters.iconSize = 30
                parameters.fontHeight = 14
            case .medium:
                parameters.rowsCount = isHorizontalScreen ? 4 : 7
                parameters.iconSize = 30
                parameters.fontHeight = 15
            case .large:
                parameters.rowsCount = isHorizontalScreen ? 3 : 6
                parameters.iconSize = 40
                parameters.fontHeight = 18
        }
        if visibility == .highest {
            parameters.edgeInsetsSize = 10
            parameters.cellCornerRadius = 12
        }
        return parameters
    }

    static func getAppIconsSize(_ size: AppearanceSizePreference,
                                _ visibility: AppearanceVisibilityPreference) -> AppearanceSizeParameters {
        var parameters = AppearanceSizeParameters()
        let isHorizontalScreen = NSScreen.preferred().isHorizontal()

        parameters.hideThumbnails = true
        parameters.windowPadding = 25
        parameters.cellCornerRadius = 10
        parameters.windowCornerRadius = 23
        parameters.intraCellPadding = 5
        parameters.interCellPadding = 1
        parameters.edgeInsetsSize = 5

        parameters.maxWidthOnScreen = 0.95
        parameters.maxHeightOnScreen = 0.9
        parameters.windowMinWidthInRow = 0.04
        parameters.windowMaxWidthInRow = 0.3
        parameters.rowsCount = 1

//        if enabledCustomizeAppearanceSize {
//            maxWidthOnScreen = Preferences.maxWidthOnScreen
//            maxHeightOnScreen = Preferences.maxHeightOnScreen
//            windowMinWidthInRow = Preferences.windowMinWidthInRow
//            windowMaxWidthInRow = Preferences.windowMaxWidthInRow
//            iconSize = Preferences.iconSize
//            fontHeight = Preferences.fontHeight
//            return
//        }

        switch currentSize {
            case .small:
                parameters.iconSize = 88
                parameters.fontHeight = 15
            case .medium:
                parameters.iconSize = 128
                parameters.fontHeight = 15
            case .large:
                parameters.windowPadding = 28
                parameters.iconSize = 168
                parameters.fontHeight = 20
        }
        return parameters
    }

    static func getTitlesSize(_ size: AppearanceSizePreference,
                              _ visibility: AppearanceVisibilityPreference) -> AppearanceSizeParameters {
        var parameters = AppearanceSizeParameters()
        let isHorizontalScreen = NSScreen.preferred().isHorizontal()

        parameters.hideThumbnails = true
        parameters.windowPadding = 18
        parameters.cellCornerRadius = 10
        parameters.windowCornerRadius = 23
        parameters.intraCellPadding = 5
        parameters.interCellPadding = 1
        parameters.edgeInsetsSize = 7

        parameters.maxWidthOnScreen = isHorizontalScreen ? 0.6 : 0.85
        parameters.maxHeightOnScreen = 0.8
        parameters.windowMinWidthInRow = 0.6
        parameters.windowMaxWidthInRow = 0.9
        parameters.rowsCount = 1

//        if enabledCustomizeAppearanceSize {
//            maxWidthOnScreen = Preferences.maxWidthOnScreen
//            maxHeightOnScreen = Preferences.maxHeightOnScreen
//            windowMinWidthInRow = Preferences.windowMinWidthInRow
//            windowMaxWidthInRow = Preferences.windowMaxWidthInRow
//            iconSize = Preferences.iconSize
//            fontHeight = Preferences.fontHeight
//            return
//        }

        switch currentSize {
            case .small:
                parameters.iconSize = 25
                parameters.fontHeight = 13
            case .medium:
                parameters.iconSize = 30
                parameters.fontHeight = 15
            case .large:
                parameters.iconSize = 40
                parameters.fontHeight = 18
        }
        return parameters
    }

    private static func assignSizeParameters(_ parameters: AppearanceSizeParameters) {
        windowPadding = parameters.windowPadding
        interCellPadding = parameters.interCellPadding
        intraCellPadding = parameters.intraCellPadding
        edgeInsetsSize = parameters.edgeInsetsSize
        cellCornerRadius = parameters.cellCornerRadius
        windowCornerRadius = parameters.windowCornerRadius

        hideThumbnails = parameters.hideThumbnails
        maxWidthOnScreen = parameters.maxWidthOnScreen
        maxHeightOnScreen = parameters.maxHeightOnScreen
        windowMinWidthInRow = parameters.windowMinWidthInRow
        windowMaxWidthInRow = parameters.windowMaxWidthInRow
        rowsCount = parameters.rowsCount
        iconSize = parameters.iconSize
        fontHeight = parameters.fontHeight
    }

    private static func lightTheme() {
        fontColor = .black.withAlphaComponent(0.8)
        titleShadowColor = nil
        indicatedIconShadowColor = nil
        imageShadowColor = .lightGray.withAlphaComponent(0.4)
        highlightMaterial = .mediumLight
        switch currentVisibility {
            case .normal:
                material = .light
                highlightFocusedBackgroundColor = .lightGray.withAlphaComponent(0.7)
                highlightHoveredBackgroundColor = .lightGray.withAlphaComponent(0.5)
                enablePanelShadow = false
                highlightFocusedAlphaValue = 1.0
                highlightHoveredAlphaValue = 0.8
                highlightFocusedBorderColor = NSColor.clear
                highlightHoveredBorderColor = NSColor.clear
                highlightBorderShadowColor = NSColor.clear
                highlightBorderWidth = 0
            case .high:
                material = .mediumLight
                highlightFocusedBackgroundColor = .lightGray.withAlphaComponent(0.7)
                highlightHoveredBackgroundColor = .lightGray.withAlphaComponent(0.5)
                enablePanelShadow = true
                highlightFocusedAlphaValue = 1.0
                highlightHoveredAlphaValue = 0.8
                highlightFocusedBorderColor = .lightGray.withAlphaComponent(0.9)
                highlightHoveredBorderColor = .lightGray.withAlphaComponent(0.8)
                highlightBorderShadowColor = .black.withAlphaComponent(0.5)
                highlightBorderWidth = 1

            case .highest:
                material = .mediumLight
                highlightFocusedBackgroundColor = .lightGray.withAlphaComponent(0.4)
                highlightHoveredBackgroundColor = .lightGray.withAlphaComponent(0.3)
                enablePanelShadow = true
                highlightFocusedAlphaValue = 0.4
                highlightHoveredAlphaValue = 0.2
                highlightFocusedBorderColor = NSColor.systemAccentColor
                highlightHoveredBorderColor = NSColor.systemAccentColor.withAlphaComponent(0.8)
                highlightBorderShadowColor = .black.withAlphaComponent(0.5)
                highlightBorderWidth = currentStyle == .titles ? 2 : 4
        }
    }

    private static func darkTheme() {
        fontColor = .white.withAlphaComponent(0.9)
        indicatedIconShadowColor = .darkGray
        titleShadowColor = .darkGray
        highlightMaterial = .ultraDark
        switch currentVisibility {
            case .normal:
                material = .dark
                imageShadowColor = .gray.withAlphaComponent(0.8)
                highlightFocusedBackgroundColor = .black.withAlphaComponent(0.6)
                highlightHoveredBackgroundColor = .black.withAlphaComponent(0.5)
                enablePanelShadow = false
                highlightFocusedAlphaValue = 1.0
                highlightHoveredAlphaValue = 0.8
                highlightFocusedBorderColor = NSColor.clear
                highlightHoveredBorderColor = NSColor.clear
                highlightBorderShadowColor = NSColor.clear
                highlightBorderWidth = 0
            case .high:
                material = .ultraDark
                imageShadowColor = .gray.withAlphaComponent(0.4)
                highlightFocusedBackgroundColor = .gray.withAlphaComponent(0.6)
                highlightHoveredBackgroundColor = .gray.withAlphaComponent(0.4)
                enablePanelShadow = true
                highlightFocusedAlphaValue = 1.0
                highlightHoveredAlphaValue = 0.8
                highlightFocusedBorderColor = .gray.withAlphaComponent(0.8)
                highlightHoveredBorderColor = .gray.withAlphaComponent(0.7)
                highlightBorderShadowColor = .white.withAlphaComponent(0.5)
                highlightBorderWidth = 1
            case .highest:
                material = .ultraDark
                imageShadowColor = .gray.withAlphaComponent(0.4)
                highlightFocusedBackgroundColor = .black.withAlphaComponent(0.4)
                highlightHoveredBackgroundColor = .black.withAlphaComponent(0.2)
                enablePanelShadow = true
                highlightFocusedAlphaValue = 0.4
                highlightHoveredAlphaValue = 0.2
                highlightFocusedBorderColor = NSColor.systemAccentColor
                highlightHoveredBorderColor = NSColor.systemAccentColor.withAlphaComponent(0.8)
                highlightBorderShadowColor = .white.withAlphaComponent(0.5)
                highlightBorderWidth = currentStyle == .titles ? 2 : 4
        }
    }

}
