//
//  AppDependencyMock.swift
//  AdequateTests
//
//  Created by Mathew Gacy on 4/18/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import Foundation
@testable import Adequate

class AppDependencyMock: HasDataProvider, HasImageService, HasThemeManager {

    var dataProvider: DataProviderType
    var imageService: ImageServiceType
    var themeManager: ThemeManagerType

    init (dataProvider: DataProviderType, imageService: ImageServiceType, themeManager: ThemeManagerType) {
        self.dataProvider = dataProvider
        self.imageService = imageService
        self.themeManager = themeManager
    }
}

/*
class AppDependencyMock2: HasDataProvider, HasImageService, HasNotificationManager, HasThemeManager, HasUserDefaultsManager {

    var _dataProvider: DataProviderMock
    var _imageService: ImageServiceMock
    var _notificationManager: NotificationManagerMock
    var _themeManager: ThemeManagerMock
    var _userDefaultsManager: UserDefaultsManagerMock

    var dataProvider: DataProviderType {
        return _dataProvider
    }
    var imageService: ImageServiceType {
        return _imageService
    }
    var notificationManager: NotificationManagerType {
        return _notificationManager
    }
    var themeManager: ThemeManagerType {
        return _themeManager
    }
    var userDefaultsManager: UserDefaultsManagerType {
        return _userDefaultsManager
    }

    init (
        dataProvider: DataProviderMock = .init(),
        imageService: ImageServiceMock = .init(),
        notificationManager: NotificationManagerMock = .init(),
        themeManager: ThemeManagerMock = .init(),
        userDefaultsManager: UserDefaultsManagerMock = .init()
    ) {
        self._dataProvider = dataProvider
        self._imageService = imageService
        self._notificationManager = notificationManager
        self._themeManager = themeManager
        self._userDefaultsManager = userDefaultsManager
    }
}
*/
