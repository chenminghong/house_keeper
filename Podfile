platform :ios, '8.0'
inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'

target ‘pairearch_WLY’ do

pod 'AFNetworking'
pod 'SDWebImage'
pod 'MJRefresh'
pod 'BaiduMobStat'
pod 'IQKeyboardManager'
pod 'UMengAnalytics-NO-IDFA'

pod 'MBProgressHUD+BWMExtension', '~> 1.0.1'
pod 'MBProgressHUD', '~> 0.9.2'
pod 'Masonry', '~> 1.0.2'
pod 'TZImagePickerController', '~> 1.7.8'
pod 'SAMKeychain', '~> 1.5.2'
pod 'HUPhotoBrowser', '~> 1.2.4'



=begin
pod 'XHVersion', '~> 1.0.1'
pod 'JSPatch'
pod 'FastImageCache'
pod 'FMDB'
pod 'SSKeychain'
=end

end

post_install do |installer|
    copy_pods_resources_path = "Pods/Target Support Files/Pods-pairearch_WLY/Pods-pairearch_WLY-resources.sh"
    string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
    assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
    text = File.read(copy_pods_resources_path)
    new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
    File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }
end
