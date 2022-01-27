return {
    VERSION = {
        major = 1,
        minor = 0,
        revision = 0
    },

    LrSdkVersion = 9.0,
    LrSdkMinimumVersion = 4.0,

    LrToolkitIdentifier = "cc.chesterip.lrimageclassifier",
    LrPluginName = "LR Image Classifier",
    LrPluginInfoUrl = "https://lrimageclassifier.chesterip.cc",

    LrLibraryMenuItems = {
        title = "Tag Images",
        enabledWhen = "photosSelected",
        file = "TagImages.lua"
    },

    LrPluginInfoProvider = 'PluginInfoProvider.lua'
}

