import Cocoa
import Carbon.HIToolbox.Events
import ShortcutRecorder

let defaults = UserDefaults.standard

class Preferences {
    // default values
    static var defaultValues: [String: String] = [
        "maxWidthOnScreen": "80",
        "maxHeightOnScreen": "80",
        "iconSize": "32",
        "fontHeight": "15",
        "holdShortcut": "⌥",
        "holdShortcut2": "⌥",
        "holdShortcut3": "⌥",
        "holdShortcut4": "⌥",
        "holdShortcut5": "⌥",
        "nextWindowShortcut": "⇥",
        "nextWindowShortcut2": keyAboveTabDependingOnInputSource(),
        "nextWindowShortcut3": "",
        "nextWindowShortcut4": "",
        "nextWindowShortcut5": "",
        "focusWindowShortcut": "Space",
        "previousWindowShortcut": "⇧",
        "cancelShortcut": "⎋",
        "closeWindowShortcut": "W",
        "minDeminWindowShortcut": "M",
        "toggleFullscreenWindowShortcut": "F",
        "quitAppShortcut": "Q",
        "hideShowAppShortcut": "H",
        "arrowKeysEnabled": "true",
        "vimKeysEnabled": "false",
        "mouseHoverEnabled": "false",
        "cursorFollowFocusEnabled": "false",
        "showMinimizedWindows": ShowHowPreference.show.rawValue,
        "showMinimizedWindows2": ShowHowPreference.show.rawValue,
        "showMinimizedWindows3": ShowHowPreference.show.rawValue,
        "showMinimizedWindows4": ShowHowPreference.show.rawValue,
        "showMinimizedWindows5": ShowHowPreference.show.rawValue,
        "showHiddenWindows": ShowHowPreference.show.rawValue,
        "showHiddenWindows2": ShowHowPreference.show.rawValue,
        "showHiddenWindows3": ShowHowPreference.show.rawValue,
        "showHiddenWindows4": ShowHowPreference.show.rawValue,
        "showHiddenWindows5": ShowHowPreference.show.rawValue,
        "showFullscreenWindows": ShowHowPreference.show.rawValue,
        "showFullscreenWindows2": ShowHowPreference.show.rawValue,
        "showFullscreenWindows3": ShowHowPreference.show.rawValue,
        "showFullscreenWindows4": ShowHowPreference.show.rawValue,
        "showFullscreenWindows5": ShowHowPreference.show.rawValue,
        "windowOrder": WindowOrderPreference.recentlyFocused.rawValue,
        "windowOrder2": WindowOrderPreference.recentlyFocused.rawValue,
        "windowOrder3": WindowOrderPreference.recentlyFocused.rawValue,
        "windowOrder4": WindowOrderPreference.recentlyFocused.rawValue,
        "windowOrder5": WindowOrderPreference.recentlyFocused.rawValue,
        "showTabsAsWindows": "false",
        "hideColoredCircles": "false",
        "windowDisplayDelay": "100",
        "appearanceStyle": AppearanceStylePreference.thumbnails.rawValue,
        "appearanceSize": AppearanceSizePreference.medium.rawValue,
        "appearanceTheme": AppearanceThemePreference.system.rawValue,
        "appearanceVisibility": AppearanceVisibilityPreference.normal.rawValue,
        "theme": ThemePreference.macOs.rawValue,
        "showOnScreen": ShowOnScreenPreference.active.rawValue,
        "titleTruncation": TitleTruncationPreference.end.rawValue,
        "alignThumbnails": AlignThumbnailsPreference.center.rawValue,
        "showAppsOrWindows": ShowAppsOrWindowsPreference.windows.rawValue,
        "showTitles": ShowTitlesPreference.windowTitle.rawValue,
        "appsToShow": AppsToShowPreference.all.rawValue,
        "appsToShow2": AppsToShowPreference.active.rawValue,
        "appsToShow3": AppsToShowPreference.all.rawValue,
        "appsToShow4": AppsToShowPreference.all.rawValue,
        "appsToShow5": AppsToShowPreference.all.rawValue,
        "spacesToShow": SpacesToShowPreference.all.rawValue,
        "spacesToShow2": SpacesToShowPreference.all.rawValue,
        "spacesToShow3": SpacesToShowPreference.all.rawValue,
        "spacesToShow4": SpacesToShowPreference.all.rawValue,
        "spacesToShow5": SpacesToShowPreference.all.rawValue,
        "screensToShow": ScreensToShowPreference.all.rawValue,
        "screensToShow2": ScreensToShowPreference.all.rawValue,
        "screensToShow3": ScreensToShowPreference.all.rawValue,
        "screensToShow4": ScreensToShowPreference.all.rawValue,
        "screensToShow5": ScreensToShowPreference.all.rawValue,
        "fadeOutAnimation": "false",
        "hideSpaceNumberLabels": "false",
        "hideStatusIcons": "false",
        "startAtLogin": "true",
        "menubarIcon": MenubarIconPreference.outlined.rawValue,
        "language": LanguagePreference.systemDefault.rawValue,
        "blacklist": defaultBlacklist(),
        "updatePolicy": UpdatePolicyPreference.autoCheck.rawValue,
        "crashPolicy": CrashPolicyPreference.ask.rawValue,
        "rowsCount": rowCountDependingOnScreenRatio(),
        "windowMinWidthInRow": "15",
        "windowMaxWidthInRow": "30",
        "shortcutStyle": ShortcutStylePreference.focusOnRelease.rawValue,
        "shortcutStyle2": ShortcutStylePreference.focusOnRelease.rawValue,
        "shortcutStyle3": ShortcutStylePreference.focusOnRelease.rawValue,
        "shortcutStyle4": ShortcutStylePreference.focusOnRelease.rawValue,
        "shortcutStyle5": ShortcutStylePreference.focusOnRelease.rawValue,
        "hideAppBadges": "false",
        "hideWindowlessApps": "false",
        "hideThumbnails": "false",
        "previewFocusedWindow": "false",
        "enabledCustomizeAppearanceSize": "false",
    ]

    // system preferences
    static var finderShowsQuitMenuItem: Bool { UserDefaults(suiteName: "com.apple.Finder")?.bool(forKey: "QuitMenuItem") ?? false }

    // constant values
    // not exposed as preferences now but may be in the future, probably through macro preferences

    // persisted values
    static var enabledCustomizeAppearanceSize: Bool { defaults.bool("enabledCustomizeAppearanceSize") }
    static var maxWidthOnScreen: CGFloat {
        get {
            return defaults.cgfloat("maxWidthOnScreen") / CGFloat(100)
        }
        set {
            Preferences.set("maxWidthOnScreen", newValue * CGFloat(100))
        }
    }

    static var maxHeightOnScreen: CGFloat {
        get {
            return defaults.cgfloat("maxHeightOnScreen") / CGFloat(100)
        }
        set {
            Preferences.set("maxHeightOnScreen", newValue * CGFloat(100))
        }
    }

    static var windowMaxWidthInRow: CGFloat {
        get {
            return defaults.cgfloat("windowMaxWidthInRow") / CGFloat(100)
        }
        set {
            Preferences.set("windowMaxWidthInRow", newValue * CGFloat(100))
        }
    }

    static var windowMinWidthInRow: CGFloat {
        get {
            return defaults.cgfloat("windowMinWidthInRow") / CGFloat(100)
        }
        set {
            Preferences.set("windowMinWidthInRow", newValue * CGFloat(100))
        }
    }

    static var rowsCount: CGFloat {
        get {
            return defaults.cgfloat("rowsCount")
        }
        set {
            Preferences.set("rowsCount", newValue)
        }
    }

    static var iconSize: CGFloat {
        get {
            return defaults.cgfloat("iconSize")
        }
        set {
            Preferences.set("iconSize", newValue)
        }
    }

    static var fontHeight: CGFloat {
        get {
            return defaults.cgfloat("fontHeight")
        }
        set {
            Preferences.set("fontHeight", newValue)
        }
    }
    static var holdShortcut: [String] { ["holdShortcut", "holdShortcut2", "holdShortcut3", "holdShortcut4", "holdShortcut5"].map { defaults.string($0) } }
    static var nextWindowShortcut: [String] { ["nextWindowShortcut", "nextWindowShortcut2", "nextWindowShortcut3", "nextWindowShortcut4", "nextWindowShortcut5"].map { defaults.string($0) } }
    static var focusWindowShortcut: String { defaults.string("focusWindowShortcut") }
    static var previousWindowShortcut: String { defaults.string("previousWindowShortcut") }
    static var cancelShortcut: String { defaults.string("cancelShortcut") }
    static var closeWindowShortcut: String { defaults.string("closeWindowShortcut") }
    static var minDeminWindowShortcut: String { defaults.string("minDeminWindowShortcut") }
    static var toggleFullscreenWindowShortcut: String { defaults.string("toggleFullscreenWindowShortcut") }
    static var quitAppShortcut: String { defaults.string("quitAppShortcut") }
    static var hideShowAppShortcut: String { defaults.string("hideShowAppShortcut") }
    // periphery:ignore
    static var arrowKeysEnabled: Bool { defaults.bool("arrowKeysEnabled") }
    // periphery:ignore
    static var vimKeysEnabled: Bool { defaults.bool("vimKeysEnabled") }
    static var mouseHoverEnabled: Bool { defaults.bool("mouseHoverEnabled") }
    static var cursorFollowFocusEnabled: Bool { defaults.bool("cursorFollowFocusEnabled") }
    static var showTabsAsWindows: Bool { defaults.bool("showTabsAsWindows") }
    static var hideColoredCircles: Bool { defaults.bool("hideColoredCircles") }
    static var windowDisplayDelay: DispatchTimeInterval { DispatchTimeInterval.milliseconds(defaults.int("windowDisplayDelay")) }
    static var fadeOutAnimation: Bool { defaults.bool("fadeOutAnimation") }
    static var hideSpaceNumberLabels: Bool { defaults.bool("hideSpaceNumberLabels") }
    static var hideStatusIcons: Bool { defaults.bool("hideStatusIcons") }
    static var hideAppBadges: Bool { defaults.bool("hideAppBadges") }
    static var hideWindowlessApps: Bool { defaults.bool("hideWindowlessApps") }
    // periphery:ignore
    static var startAtLogin: Bool { defaults.bool("startAtLogin") }
    static var blacklist: [BlacklistEntry] { jsonDecode([BlacklistEntry].self, defaults.string("blacklist")) }
    static var previewFocusedWindow: Bool { defaults.bool("previewFocusedWindow") }

    // macro values
    static var appearanceStyle: AppearanceStylePreference { defaults.macroPref("appearanceStyle", AppearanceStylePreference.allCases) }
    static var appearanceSize: AppearanceSizePreference { defaults.macroPref("appearanceSize", AppearanceSizePreference.allCases) }
    static var appearanceTheme: AppearanceThemePreference { defaults.macroPref("appearanceTheme", AppearanceThemePreference.allCases) }
    static var appearanceVisibility: AppearanceVisibilityPreference { defaults.macroPref("appearanceVisibility", AppearanceVisibilityPreference.allCases) }
    // periphery:ignore
    static var theme: ThemePreference { ThemePreference.macOs/*defaults.macroPref("theme", ThemePreference.allCases)*/ }
    static var showOnScreen: ShowOnScreenPreference { defaults.macroPref("showOnScreen", ShowOnScreenPreference.allCases) }
    static var titleTruncation: TitleTruncationPreference { defaults.macroPref("titleTruncation", TitleTruncationPreference.allCases) }
    static var alignThumbnails: AlignThumbnailsPreference { defaults.macroPref("alignThumbnails", AlignThumbnailsPreference.allCases) }
    static var showAppsOrWindows: ShowAppsOrWindowsPreference { defaults.macroPref("showAppsOrWindows", ShowAppsOrWindowsPreference.allCases) }
    static var showTitles: ShowTitlesPreference { defaults.macroPref("showTitles", ShowTitlesPreference.allCases) }
    static var updatePolicy: UpdatePolicyPreference { defaults.macroPref("updatePolicy", UpdatePolicyPreference.allCases) }
    static var crashPolicy: CrashPolicyPreference { defaults.macroPref("crashPolicy", CrashPolicyPreference.allCases) }
    static var appsToShow: [AppsToShowPreference] { ["appsToShow", "appsToShow2", "appsToShow3", "appsToShow4", "appsToShow5"].map { defaults.macroPref($0, AppsToShowPreference.allCases) } }
    static var spacesToShow: [SpacesToShowPreference] { ["spacesToShow", "spacesToShow2", "spacesToShow3", "spacesToShow4", "spacesToShow5"].map { defaults.macroPref($0, SpacesToShowPreference.allCases) } }
    static var screensToShow: [ScreensToShowPreference] { ["screensToShow", "screensToShow2", "screensToShow3", "screensToShow4", "screensToShow5"].map { defaults.macroPref($0, ScreensToShowPreference.allCases) } }
    static var showMinimizedWindows: [ShowHowPreference] { ["showMinimizedWindows", "showMinimizedWindows2", "showMinimizedWindows3", "showMinimizedWindows4", "showMinimizedWindows5"].map { defaults.macroPref($0, ShowHowPreference.allCases) } }
    static var showHiddenWindows: [ShowHowPreference] { ["showHiddenWindows", "showHiddenWindows2", "showHiddenWindows3", "showHiddenWindows4", "showHiddenWindows5"].map { defaults.macroPref($0, ShowHowPreference.allCases) } }
    static var showFullscreenWindows: [ShowHowPreference] { ["showFullscreenWindows", "showFullscreenWindows2", "showFullscreenWindows3", "showFullscreenWindows4", "showFullscreenWindows5"].map { defaults.macroPref($0, ShowHowPreference.allCases) } }
    static var windowOrder: [WindowOrderPreference] { ["windowOrder", "windowOrder2", "windowOrder3", "windowOrder4", "windowOrder5"].map { defaults.macroPref($0, WindowOrderPreference.allCases) } }
    static var shortcutStyle: [ShortcutStylePreference] { ["shortcutStyle", "shortcutStyle2", "shortcutStyle3", "shortcutStyle4", "shortcutStyle5"].map { defaults.macroPref($0, ShortcutStylePreference.allCases) } }
    static var menubarIcon: MenubarIconPreference { defaults.macroPref("menubarIcon", MenubarIconPreference.allCases) }
    static var language: LanguagePreference { defaults.macroPref("language", LanguagePreference.allCases) }

    static func initialize() {
        removeCorruptedPreferences()
        migratePreferences()
        registerDefaults()
    }

    static func removeCorruptedPreferences() {
        // from v5.1.0+, there are crash reports of users somehow having their hold shortcuts set to ""
        ["holdShortcut", "holdShortcut2", "holdShortcut3", "holdShortcut4", "holdShortcut5"].forEach {
            if let s = defaults.string(forKey: $0), s == "" {
                defaults.removeObject(forKey: $0)
            }
        }
    }

    static func resetAll() {
        defaults.removePersistentDomain(forName: App.id)
    }

    static func registerDefaults() {
        defaults.register(defaults: defaultValues)
    }

    static func getString(_ key: String) -> String? {
        defaults.string(forKey: key)
    }

    static func set<T>(_ key: String, _ value: T) where T: Encodable {
        defaults.set(key == "blacklist" ? jsonEncode(value) : value, forKey: key)
        UserDefaults.cache.removeValue(forKey: key)
    }

    static func remove(_ key: String) {
        defaults.removeObject(forKey: key)
        UserDefaults.cache.removeValue(forKey: key)
    }

    static var all: [String: Any] { defaults.persistentDomain(forName: App.id)! }

    static func migratePreferences() {
        let preferencesKey = "preferencesVersion"
        if let diskVersion = defaults.string(forKey: preferencesKey) {
            if diskVersion.compare(App.version, options: .numeric) == .orderedAscending {
                updateToNewPreferences(diskVersion)
            }
        }
        defaults.set(App.version, forKey: preferencesKey)
    }

    private static func updateToNewPreferences(_ currentVersion: String) {
        if currentVersion.compare("6.72.0", options: .numeric) != .orderedDescending {
            migratePreferencesIndexes()
            if currentVersion.compare("6.42.0", options: .numeric) != .orderedDescending {
                migrateBlacklists()
                if currentVersion.compare("6.28.1", options: .numeric) != .orderedDescending {
                    migrateMinMaxWindowsWidthInRow()
                    if currentVersion.compare("6.27.1", options: .numeric) != .orderedDescending {
                        // "Start at login" new implem doesn't use Login Items; we remove the entry from previous versions
                        (Preferences.self as AvoidDeprecationWarnings.Type).migrateLoginItem()
                        if currentVersion.compare("6.23.0", options: .numeric) != .orderedDescending {
                            // "Show windows from:" got the "Active Space" option removed
                            migrateShowWindowsFrom()
                            if currentVersion.compare("6.18.1", options: .numeric) != .orderedDescending {
                                // nextWindowShortcut used to be able to have modifiers already present in holdShortcut; we remove these
                                migrateNextWindowShortcuts()
                                // dropdowns preferences used to store English text; now they store indexes
                                migrateDropdownsFromTextToIndexes()
                                // the "Hide menubar icon" checkbox was replaced with a dropdown of: icon1, icon2, hidden
                                migrateMenubarIconFromCheckboxToDropdown()
                                // "Show minimized/hidden/fullscreen windows" checkboxes were replaced with dropdowns
                                migrateShowWindowsCheckboxToDropdown()
                                // "Max size on screen" was split into max width and max height
                                migrateMaxSizeOnScreenToWidthAndHeight()
                            }
                        }
                    }
                }
            }
        }
    }

    // we want to rely on preferences numbers to match the enum indexes. This migration realigns existing desyncs
    private static func migratePreferencesIndexes() {
        // migrate spacesToShow from 1 to 2. 1 was removed a while ago. 1=active => 2=>visible
        ["", "2", "3", "4", "5"].forEach { suffix in
            if let spacesToShow = defaults.string(forKey: "spacesToShow" + suffix) {
                if spacesToShow == "1" {
                    defaults.set("2", forKey: "spacesToShow" + suffix)
                }
            }
        }

        // migrate spacesToShow from 0 to 2 and 2 to 0. 0 used to be end, 2 used to be start; they got switch for the UI order
        ["", "2", "3", "4", "5"].forEach { suffix in
            if let spacesToShow = defaults.string(forKey: "titleTruncation" + suffix) {
                if spacesToShow == "0" {
                    defaults.set("2", forKey: "titleTruncation" + suffix)
                }
                if spacesToShow == "2" {
                    defaults.set("0", forKey: "titleTruncation" + suffix)
                }
            }
        }
    }

    private static func migrateBlacklists() {
        var entries = [BlacklistEntry]()
        if let old = defaults.string(forKey: "dontShowBlacklist") {
            entries.append(contentsOf: oldBlacklistEntriesToNewOnes(old, .always, .none))
        }
        if let old = defaults.string(forKey: "disableShortcutsBlacklist") {
            let onlyFullscreen = defaults.bool(forKey: "disableShortcutsBlacklistOnlyFullscreen")
            entries.append(contentsOf: oldBlacklistEntriesToNewOnes(old, .none, onlyFullscreen ? .whenFullscreen : .always))
        }
        if entries.count > 0 {
            defaults.set(Preferences.jsonEncode(entries), forKey: "blacklist")
            ["dontShowBlacklist", "disableShortcutsBlacklist", "disableShortcutsBlacklistOnlyFullscreen"].forEach {
                defaults.removeObject(forKey: $0)
            }
        }
    }

    private static func oldBlacklistEntriesToNewOnes(_ old: String, _ hide: BlacklistHidePreference, _ ignore: BlacklistIgnorePreference) -> [BlacklistEntry] {
        old.split(separator: "\n").compactMap { (e) -> BlacklistEntry? in
            let line = e.trimmingCharacters(in: .whitespaces)
            if line.isEmpty {
                return nil
            }
            return BlacklistEntry(bundleIdentifier: line, hide: hide, ignore: ignore)
        }
    }

    private static func migrateMinMaxWindowsWidthInRow() {
        ["windowMinWidthInRow", "windowMaxWidthInRow"].forEach {
            if let old = defaults.string(forKey: $0) {
                if old == "0" {
                    defaults.set("1", forKey: $0)
                }
            }
        }
    }

    @available(OSX, deprecated: 10.11)
    static func migrateLoginItem() {
        do {
            if let loginItemsWrapped = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil) {
                let loginItems = loginItemsWrapped.takeRetainedValue()
                if let loginItemsSnapshotWrapped = LSSharedFileListCopySnapshot(loginItems, nil) {
                    let loginItemsSnapshot = loginItemsSnapshotWrapped.takeRetainedValue() as! [LSSharedFileListItem]
                    let itemName = Bundle.main.bundleURL.lastPathComponent as CFString
                    let itemUrl = URL(fileURLWithPath: Bundle.main.bundlePath) as CFURL
                    loginItemsSnapshot.forEach {
                        if (LSSharedFileListItemCopyDisplayName($0).takeRetainedValue() == itemName) ||
                               (LSSharedFileListItemCopyResolvedURL($0, 0, nil)?.takeRetainedValue() == itemUrl) {
                            LSSharedFileListItemRemove(loginItems, $0)
                        }
                    }
                }
            }
            throw AxError.runtimeError // remove compiler warning
        } catch {
            // the LSSharedFile API is deprecated, and has a runtime crash on M1 Monterey
            // we catch any exception to void the app crashing
        }
    }

    private static func migrateShowWindowsFrom() {
        ["", "2"].forEach { suffix in
            if let spacesToShow = defaults.string(forKey: "spacesToShow" + suffix) {
                if spacesToShow == "2" {
                    defaults.set("1", forKey: "screensToShow" + suffix)
                    defaults.set("1", forKey: "spacesToShow" + suffix)
                } else if spacesToShow == "1" {
                    defaults.set("1", forKey: "screensToShow" + suffix)
                }
            }
        }
    }

    private static func migrateNextWindowShortcuts() {
        ["", "2"].forEach { suffix in
            if let oldHoldShortcut = defaults.string(forKey: "holdShortcut" + suffix),
               let oldNextWindowShortcut = defaults.string(forKey: "nextWindowShortcut" + suffix) {
                let nextWindowShortcutCleanedUp = oldHoldShortcut.reduce(oldNextWindowShortcut, { $0.replacingOccurrences(of: String($1), with: "") })
                if oldNextWindowShortcut != nextWindowShortcutCleanedUp {
                    defaults.set(nextWindowShortcutCleanedUp, forKey: "nextWindowShortcut" + suffix)
                }
            }
        }
    }

    private static func migrateMaxSizeOnScreenToWidthAndHeight() {
        if let old = defaults.string(forKey: "maxScreenUsage") {
            defaults.set(old, forKey: "maxWidthOnScreen")
            defaults.set(old, forKey: "maxHeightOnScreen")
        }
    }

    private static func migrateShowWindowsCheckboxToDropdown() {
        ["showMinimizedWindows", "showHiddenWindows", "showFullscreenWindows"]
            .flatMap { [$0, $0 + "2"] }
            .forEach {
                if let old = defaults.string(forKey: $0) {
                    if old == "true" {
                        defaults.set(ShowHowPreference.show.rawValue, forKey: $0)
                    } else if old == "false" {
                        defaults.set(ShowHowPreference.hide.rawValue, forKey: $0)
                    }
                }
            }
    }

    private static func migrateDropdownsFromTextToIndexes() {
        migratePreferenceValue("theme", [" macOS": "0", "❖ Windows 10": "1"])
        // "Main screen" was renamed to "Active screen"
        migratePreferenceValue("showOnScreen", ["Main screen": "0", "Active screen": "0", "Screen including mouse": "1"])
        migratePreferenceValue("alignThumbnails", ["Left": "0", "Center": "1"])
        migratePreferenceValue("appsToShow", ["All apps": "0", "Active app": "1"])
        migratePreferenceValue("spacesToShow", ["All spaces": "0", "Active space": "1"])
        migratePreferenceValue("screensToShow", ["All screens": "0", "Screen showing AltTab": "1"])
    }

    private static func migrateMenubarIconFromCheckboxToDropdown() {
        if let old = defaults.string(forKey: "hideMenubarIcon") {
            if old == "true" {
                defaults.set("3", forKey: "menubarIcon")
            }
        }
    }

    static func migratePreferenceValue(_ preference: String, _ oldAndNew: [String: String]) {
        if let old = defaults.string(forKey: preference),
           let new = oldAndNew[old] {
            defaults.set(new, forKey: preference)
        }
    }

    static func rowCountDependingOnScreenRatio() -> String {
        // landscape; tested with 4/3, 16/10, 16/9
        if NSScreen.main!.ratio() > 1 {
            return "4"
        }
        // vertical; tested with 10/16
        return "6"
    }

    static func onlyShowApplications() -> Bool {
        return Preferences.showAppsOrWindows == .applications && Preferences.appearanceStyle != .thumbnails
    }

    /// key-above-tab is ` on US keyboard, but can be different on other keyboards
    static func keyAboveTabDependingOnInputSource() -> String {
        return LiteralKeyCodeTransformer.shared.transformedValue(NSNumber(value: kVK_ANSI_Grave)) ?? "`"
    }

    static func defaultBlacklist() -> String {
        return jsonEncode([
            BlacklistEntry(bundleIdentifier: "com.McAfee.McAfeeSafariHost", hide: .always, ignore: .none),
            BlacklistEntry(bundleIdentifier: "com.apple.finder", hide: .whenNoOpenWindow, ignore: .none),
        ] + [
            "com.microsoft.rdc.macos",
            "com.teamviewer.TeamViewer",
            "org.virtualbox.app.VirtualBoxVM",
            "com.parallels.",
            "com.citrix.XenAppViewer",
            "com.citrix.receiver.icaviewer.mac",
            "com.nicesoftware.dcvviewer",
            "com.vmware.fusion",
            "com.apple.ScreenSharing",
            "com.utmapp.UTM",
        ].map {
            BlacklistEntry(bundleIdentifier: $0, hide: .none, ignore: .whenFullscreen)
        })
    }

    static func jsonDecode<T>(_ type: T.Type, _ value: String) -> T where T: Decodable {
        return try! JSONDecoder().decode(type, from: value.data(using: .utf8)!)
    }

    static func jsonEncode<T>(_ value: T) -> String where T: Encodable {
        return String(data: try! JSONEncoder().encode(value), encoding: .utf8)!
    }

    static func indexToName(_ baseName: String, _ index: Int) -> String {
        return baseName + (index == 0 ? "" : String(index + 1))
    }

    static func nameToIndex(_ name: String) -> Int {
        guard let number = name.last?.wholeNumberValue else { return 0 }
        return number - 1
    }
}

// workaround to silence compiler warning
private protocol AvoidDeprecationWarnings {
    static func migrateLoginItem()
}

// workaround to silence compiler warning
extension Preferences: AvoidDeprecationWarnings {
}

// MacroPreference are collection of values derived from a single key
// we don't want to store every value in UserDefaults as the user could change them and contradict the macro
protocol MacroPreference {
    var localizedString: LocalizedString { get }
}

protocol SfSymbolMacroPreference: MacroPreference {
    var symbolName: String { get }
}

struct WidthHeightImage {
    var width: CGFloat
    var height: CGFloat
    var name: String

    init(width: CGFloat = 80, height: CGFloat = 50, name: String) {
        self.width = width
        self.height = height
        self.name = name
    }
}

protocol ImageMacroPreference: MacroPreference {
    var image: WidthHeightImage { get }
}

// periphery:ignore
struct ThemeParameters {
    let label: String
    let cellCornerRadius: CGFloat
    let windowCornerRadius: CGFloat
}

typealias LocalizedString = String

enum MenubarIconPreference: String, CaseIterable, MacroPreference {
    case outlined = "0"
    case filled = "1"
    case colored = "2"
    case hidden = "3"

    var localizedString: LocalizedString {
        switch self {
            // these spaces are different from each other; they have to be unique
            case .outlined: return " "
            case .filled: return " "
            case .colored: return " "
            case .hidden: return " "
        }
    }
}

enum LanguagePreference: String, CaseIterable, MacroPreference {
    case systemDefault = "0"
    case arabic = "1"
    case bulgarian = "2"
    case bengali = "3"
    case catalan = "4"
    case czech = "5"
    case danish = "6"
    case german = "7"
    case greek = "8"
    case english = "9"
    case spanish = "10"
    case estonian = "11"
    case persian = "12"
    case finnish = "13"
    case french = "14"
    case galician = "15"
    case hebrew = "16"
    case hindi = "17"
    case croatian = "18"
    case hungarian = "19"
    case indonesian = "20"
    case icelandic = "21"
    case italian = "22"
    case japanese = "23"
    case kannada = "24"
    case korean = "25"
    case kurdish = "26"
    case luxembourgish = "27"
    case malayalam = "28"
    case norwegianBokmal = "29"
    case dutch = "30"
    case norwegianNynorsk = "31"
    case polish = "32"
    case portuguese = "33"
    case brazilianPortuguese = "34"
    case romanian = "35"
    case russian = "36"
    case slovak = "37"
    case slovenian = "38"
    case albanian = "39"
    case serbian = "40"
    case swedish = "41"
    case tamil = "42"
    case thai = "43"
    case turkish = "44"
    case ukrainian = "45"
    case uzbek = "46"
    case vietnamese = "47"
    case simplifiedChinese = "48"
    case traditionalChinese = "49"

    var localizedString: String {
        switch self {
            case .systemDefault:
                return NSLocalizedString("System Default", comment: "")
            case .arabic:
                return "العربية"
            case .bulgarian:
                return "Български"
            case .bengali:
                return "বাংলা"
            case .catalan:
                return "Català"
            case .czech:
                return "Čeština"
            case .danish:
                return "Dansk"
            case .german:
                return "Deutsch"
            case .greek:
                return "Ελληνικά"
            case .english:
                return "English"
            case .spanish:
                return "Español"
            case .estonian:
                return "Eesti"
            case .persian:
                return "فارسی"
            case .finnish:
                return "Suomi"
            case .french:
                return "Français"
            case .galician:
                return "Galego"
            case .hebrew:
                return "עברית"
            case .hindi:
                return "हिन्दी"
            case .croatian:
                return "Hrvatski"
            case .hungarian:
                return "Magyar"
            case .indonesian:
                return "Bahasa Indonesia"
            case .icelandic:
                return "Íslenska"
            case .italian:
                return "Italiano"
            case .japanese:
                return "日本語"
            case .kannada:
                return "ಕನ್ನಡ"
            case .korean:
                return "한국어"
            case .kurdish:
                return "Kurdî"
            case .luxembourgish:
                return "Lëtzebuergesch"
            case .malayalam:
                return "മലയാളം"
            case .norwegianBokmal:
                return "Norsk Bokmål"
            case .dutch:
                return "Nederlands"
            case .norwegianNynorsk:
                return "Norsk Nynorsk"
            case .polish:
                return "Polski"
            case .portuguese:
                return "Português"
            case .brazilianPortuguese:
                return "Português (Brasil)"
            case .romanian:
                return "Română"
            case .russian:
                return "Русский"
            case .slovak:
                return "Slovenčina"
            case .slovenian:
                return "Slovenščina"
            case .albanian:
                return "Shqip"
            case .serbian:
                return "Српски"
            case .swedish:
                return "Svenska"
            case .tamil:
                return "தமிழ்"
            case .thai:
                return "ไทย"
            case .turkish:
                return "Türkçe"
            case .ukrainian:
                return "Українська"
            case .uzbek:
                return "O'zbek"
            case .vietnamese:
                return "Tiếng Việt"
            case .simplifiedChinese:
                return "简体中文"
            case .traditionalChinese:
                return "繁體中文"
        }
    }

    var appleLanguages: String {
        switch self {
            case .systemDefault:
                return ""
            case .arabic:
                return "ar"
            case .bulgarian:
                return "bg"
            case .bengali:
                return "bn"
            case .catalan:
                return "ca"
            case .czech:
                return "cs"
            case .danish:
                return "da"
            case .german:
                return "de"
            case .greek:
                return "el"
            case .english:
                return "en"
            case .spanish:
                return "es"
            case .estonian:
                return "et"
            case .persian:
                return "fa"
            case .finnish:
                return "fi"
            case .french:
                return "fr"
            case .galician:
                return "gl"
            case .hebrew:
                return "he"
            case .hindi:
                return "hi"
            case .croatian:
                return "hr"
            case .hungarian:
                return "hu"
            case .indonesian:
                return "id"
            case .icelandic:
                return "is"
            case .italian:
                return "it"
            case .japanese:
                return "ja"
            case .kannada:
                return "kn"
            case .korean:
                return "ko"
            case .kurdish:
                return "ku"
            case .luxembourgish:
                return "lb"
            case .malayalam:
                return "ml"
            case .norwegianBokmal:
                return "nb"
            case .dutch:
                return "nl"
            case .norwegianNynorsk:
                return "nn"
            case .polish:
                return "pl"
            case .portuguese:
                return "pt"
            case .brazilianPortuguese:
                return "pt-BR"
            case .romanian:
                return "ro"
            case .russian:
                return "ru"
            case .slovak:
                return "sk"
            case .slovenian:
                return "sl"
            case .albanian:
                return "sq"
            case .serbian:
                return "sr"
            case .swedish:
                return "sv"
            case .tamil:
                return "ta"
            case .thai:
                return "th"
            case .turkish:
                return "tr"
            case .ukrainian:
                return "uk"
            case .uzbek:
                return "uz"
            case .vietnamese:
                return "vi"
            case .simplifiedChinese:
                return "zh-CN"
            case .traditionalChinese:
                return "zh-TW"
        }
    }
}

enum ShortcutStylePreference: String, CaseIterable, MacroPreference {
    case focusOnRelease = "0"
    case doNothingOnRelease = "1"

    var localizedString: LocalizedString {
        switch self {
            case .focusOnRelease: return NSLocalizedString("Focus selected window", comment: "")
            case .doNothingOnRelease: return NSLocalizedString("Do nothing", comment: "")
        }
    }
}

enum ShowHowPreference: String, CaseIterable, MacroPreference {
    case show = "0"
    case hide = "1"
    case showAtTheEnd = "2"

    var localizedString: LocalizedString {
        switch self {
            case .show: return NSLocalizedString("Show", comment: "")
            case .showAtTheEnd: return NSLocalizedString("Show at the end", comment: "")
            case .hide: return NSLocalizedString("Hide", comment: "")
        }
    }
}

enum WindowOrderPreference: String, CaseIterable, MacroPreference {
    case recentlyFocused = "0"
    case recentlyCreated = "1"
    case alphabetical = "2"
    case space = "3"

    var localizedString: LocalizedString {
        switch self {
            case .recentlyFocused: return NSLocalizedString("Recently Focused First", comment: "")
            case .recentlyCreated: return NSLocalizedString("Recently Created First", comment: "")
            case .alphabetical: return NSLocalizedString("Alphabetical Order", comment: "")
            case .space: return NSLocalizedString("Space Order", comment: "")
        }
    }
}

enum AppsToShowPreference: String, CaseIterable, MacroPreference {
    case all = "0"
    case active = "1"

    var localizedString: LocalizedString {
        switch self {
            case .all: return NSLocalizedString("All apps", comment: "")
            case .active: return NSLocalizedString("Active app", comment: "")
        }
    }
}

enum SpacesToShowPreference: String, CaseIterable, MacroPreference {
    case all = "0"
    case visible = "2"

    var localizedString: LocalizedString {
        switch self {
            case .all: return NSLocalizedString("All Spaces", comment: "")
            case .visible: return NSLocalizedString("Visible Spaces", comment: "")
        }
    }
}

enum ScreensToShowPreference: String, CaseIterable, MacroPreference {
    case all = "0"
    case showingAltTab = "1"

    var localizedString: LocalizedString {
        switch self {
            case .all: return NSLocalizedString("All screens", comment: "")
            case .showingAltTab: return NSLocalizedString("Screen showing AltTab", comment: "")
        }
    }
}

enum ShowOnScreenPreference: String, CaseIterable, MacroPreference {
    case active = "0"
    case includingMouse = "1"
    case includingMenubar = "2"

    var localizedString: LocalizedString {
        switch self {
            case .active: return NSLocalizedString("Active screen", comment: "")
            case .includingMouse: return NSLocalizedString("Screen including mouse", comment: "")
            case .includingMenubar: return NSLocalizedString("Screen including menu bar", comment: "")
        }
    }
}

enum TitleTruncationPreference: String, CaseIterable, MacroPreference {
    case start = "0"
    case middle = "1"
    case end = "2"

    var localizedString: LocalizedString {
        switch self {
            case .start: return NSLocalizedString("Start", comment: "")
            case .middle: return NSLocalizedString("Middle", comment: "")
            case .end: return NSLocalizedString("End", comment: "")
        }
    }
}

enum ShowAppsOrWindowsPreference: String, CaseIterable, MacroPreference {
    case applications = "0"
    case windows = "1"

    var localizedString: LocalizedString {
        switch self {
            case .applications: return NSLocalizedString("Applications", comment: "")
            case .windows: return NSLocalizedString("Windows", comment: "")
        }
    }
}

enum ShowTitlesPreference: String, CaseIterable, MacroPreference {
    case windowTitle = "0"
    case appName = "1"
    case appNameAndWindowTitle = "2"

    var localizedString: LocalizedString {
        switch self {
            case .windowTitle: return NSLocalizedString("Window Title", comment: "")
            case .appName: return NSLocalizedString("Application Name", comment: "")
            case .appNameAndWindowTitle: return NSLocalizedString("Application Name - Window Title", comment: "")
        }
    }

    var image: WidthHeightImage {
        switch self {
            case .windowTitle: return WidthHeightImage(name: "show_running_windows")
            case .appName: return WidthHeightImage(name: "show_running_applications")
            case .appNameAndWindowTitle: return WidthHeightImage(name: "show_running_applications_windows")
        }
    }
}

enum AlignThumbnailsPreference: String, CaseIterable, ImageMacroPreference {
    case leading = "0"
    case center = "1"

    var localizedString: LocalizedString {
        switch self {
            case .leading: return NSLocalizedString("Leading", comment: "")
            case .center: return NSLocalizedString("Center", comment: "")
        }
    }

    var image: WidthHeightImage {
        switch self {
            case .leading: return WidthHeightImage(name: "align_thumbnails_leading")
            case .center: return WidthHeightImage(name: "align_thumbnails_center")
        }
    }
}

enum AppearanceStylePreference: String, CaseIterable, ImageMacroPreference {
    case thumbnails = "0"
    case appIcons = "1"
    case titles = "2"

    var localizedString: LocalizedString {
        switch self {
            case .thumbnails: return NSLocalizedString("Thumbnails", comment: "")
            case .appIcons: return NSLocalizedString("App Icons", comment: "")
            case .titles: return NSLocalizedString("Titles", comment: "")
        }
    }

    var image: WidthHeightImage {
        let width = CGFloat(150)
        let height = width / 1.6
        switch self {
            case .thumbnails: return WidthHeightImage(width: width, height: height, name: "thumbnails")
            case .appIcons: return WidthHeightImage(width: width, height: height, name: "app_icons")
            case .titles: return WidthHeightImage(width: width, height: height, name: "titles")
        }
    }
}

enum AppearanceSizePreference: String, CaseIterable, SfSymbolMacroPreference {
    case small = "0"
    case medium = "1"
    case large = "2"

    var localizedString: LocalizedString {
        switch self {
            case .small: return NSLocalizedString("Small", comment: "")
            case .medium: return NSLocalizedString("Medium", comment: "")
            case .large: return NSLocalizedString("Large", comment: "")
        }
    }

    var symbolName: String {
        switch self {
            case .small: return "moonphase.waning.gibbous.inverse"
            case .medium: return "moonphase.last.quarter.inverse"
            case .large: return "moonphase.waning.crescent.inverse"
        }
    }
}

enum ThemePreference: String, CaseIterable, ImageMacroPreference {
    case macOs = "0"
    case windows10 = "1"

    var localizedString: LocalizedString {
        switch self {
            case .macOs: return " macOS"
            case .windows10: return "❖ Windows 10"
        }
    }

    var image: WidthHeightImage {
        switch self {
            case .macOs: return WidthHeightImage(name: "macos")
            case .windows10: return WidthHeightImage(name: "windows10")
        }
    }

    // periphery:ignore
    var themeParameters: ThemeParameters {
        switch self {
            case .macOs: return ThemeParameters(label: localizedString, cellCornerRadius: 10, windowCornerRadius: 23)
            case .windows10: return ThemeParameters(label: localizedString, cellCornerRadius: 0, windowCornerRadius: 0)
        }
    }
}

enum AppearanceThemePreference: String, CaseIterable, SfSymbolMacroPreference {
    case light = "0"
    case dark = "1"
    case system = "2"

    var localizedString: LocalizedString {
        switch self {
            case .light: return NSLocalizedString("Light", comment: "")
            case .dark: return NSLocalizedString("Dark", comment: "")
            case .system: return NSLocalizedString("System", comment: "")
        }
    }

    var symbolName: String {
        switch self {
            case .light: return "sun.max"
            case .dark: return "moon.fill"
            case .system: return "laptopcomputer"
        }
    }
}

enum AppearanceVisibilityPreference: String, CaseIterable, SfSymbolMacroPreference {
    case normal = "0"
    case high = "1"
    case highest = "2"

    var localizedString: LocalizedString {
        switch self {
            case .normal: return NSLocalizedString("Normal", comment: "")
            case .high: return NSLocalizedString("High", comment: "")
            case .highest: return NSLocalizedString("Highest", comment: "")
        }
    }

    var symbolName: String {
        switch self {
            case .normal: return "eye"
            case .high: return "eyeglasses"
            case .highest: return "binoculars.fill"
        }
    }
}

enum UpdatePolicyPreference: String, CaseIterable, MacroPreference {
    case manual = "0"
    case autoCheck = "1"
    case autoInstall = "2"

    var localizedString: LocalizedString {
        switch self {
            case .manual: return NSLocalizedString("Don’t check for updates periodically", comment: "")
            case .autoCheck: return NSLocalizedString("Check for updates periodically", comment: "")
            case .autoInstall: return NSLocalizedString("Auto-install updates periodically", comment: "")
        }
    }
}

enum CrashPolicyPreference: String, CaseIterable, MacroPreference {
    case never = "0"
    case ask = "1"
    case always = "2"

    var localizedString: LocalizedString {
        switch self {
            case .never: return NSLocalizedString("Never send crash reports", comment: "")
            case .ask: return NSLocalizedString("Ask whether to send crash reports", comment: "")
            case .always: return NSLocalizedString("Always send crash reports", comment: "")
        }
    }
}

enum BlacklistHidePreference: String, CaseIterable, MacroPreference, Codable {
    case none = "0"
    case always = "1"
    case whenNoOpenWindow = "2"

    var localizedString: LocalizedString {
        switch self {
            case .none: return ""
            case .always: return NSLocalizedString("Always", comment: "")
            case .whenNoOpenWindow: return NSLocalizedString("When no open window", comment: "")
        }
    }
}

enum BlacklistIgnorePreference: String, CaseIterable, MacroPreference, Codable {
    case none = "0"
    case always = "1"
    case whenFullscreen = "2"

    var localizedString: LocalizedString {
        switch self {
            case .none: return ""
            case .always: return NSLocalizedString("Always", comment: "")
            case .whenFullscreen: return NSLocalizedString("When fullscreen", comment: "")
        }
    }
}

struct BlacklistEntry: Codable {
    var bundleIdentifier: String
    var hide: BlacklistHidePreference
    var ignore: BlacklistIgnorePreference
}

extension UserDefaults {
    static var cache = [String: String]()

    func getFromCacheOrFetchAndCache(_ key: String) -> String {
        if let c = UserDefaults.cache[key] {
            return c
        }
        let v = defaults.string(forKey: key)!
        UserDefaults.cache[key] = v
        return v
    }

    func getThenConvertOrReset<T>(_ key: String, _ getterFn: (String) -> T?) -> T {
        let stringValue = getFromCacheOrFetchAndCache(key)
        if let v = getterFn(stringValue) {
            return v
        }
        removeObject(forKey: key)
        UserDefaults.cache.removeValue(forKey: key)
        let stringValue2 = getFromCacheOrFetchAndCache(key)
        let v = getterFn(stringValue2)!
        return v
    }

    func string(_ key: String) -> String {
        return getFromCacheOrFetchAndCache(key)
    }

    func int(_ key: String) -> Int {
        return getThenConvertOrReset(key, { s in Int(s) })
    }

    func bool(_ key: String) -> Bool {
        return getThenConvertOrReset(key, { s in Bool(s) })
    }

    func cgfloat(_ key: String) -> CGFloat {
        return getThenConvertOrReset(key, { s in Int(s).flatMap { CGFloat($0) } })
    }

    func double(_ key: String) -> Double {
        return getThenConvertOrReset(key, { s in Double(s) })
    }

    func macroPref<A>(_ key: String, _ macroPreferences: [A]) -> A {
        return getThenConvertOrReset(key, { s in Int(s).flatMap { macroPreferences[safe: $0] } })
    }
}
