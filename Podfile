source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'HFUTer3' do
    inhibit_all_warnings!
    use_frameworks!
    # UI
    pod 'WSProgressHUD', '~> 1.1.3'                         ## 不错的Hud
    pod 'YYWebImage', '~> 1.0.5'                            ## 高效ImageView
    pod 'YYImage/WebP', '~> 1.0.4'
    pod 'SnapKit', '~> 4.0.0'                               ## AutoLayout
    pod 'SVProgressHUD', '~> 2.2.5'
    pod 'MJRefresh', '~> 3.1.15.3'
    pod 'AIFlatSwitch', '~> 1.0.2'                          ## 动态选择button
    # pod 'YYText' , :git => 'https://github.com/BrikerMan/YYText.git'
    pod 'YYText'
    pod 'GzipSwift'
    pod 'ZYCornerRadius', '~> 1.0.2'                        # 优化圆角绘制
    pod 'RSKImageCropper', :git => 'https://github.com/BrikerMan/RSKImageCropper.git' ## 图片选择
    pod 'Toaster', '~> 2.1.1'
    
    # TableView
    pod 'UITableView+FDTemplateLayoutCell_Bell', '~> 1.5.0' ##优化UITableViewCell高度计算
    pod 'Eureka', '~> 4.2.0'
    pod 'Kanna', '~> 4.0.0'
    pod 'DZNEmptyDataSet', '~> 1.8.1'                       ## 空数据展示
    
    # 动画
    pod 'NVActivityIndicatorView', '~> 4.3.0'
    pod 'SwipeBack', '~> 1.1.1'
    pod 'LTMorphingLabel', '~> 0.5.7'
    
    # 网络
    #    pod 'Alamofire', '~> 4.5'
    
    pod 'AlamofireDomain', '~> 4.0'         ## 牛逼的网络请求库
    pod 'KMPlaceholderTextView', '~> 1.3.0'             ## 带Placeholder的TextView
    pod 'Pitaya', :git => 'https://github.com/johnlui/Pitaya.git'
    pod 'RxSwift', '~> 4.2.0'
    
    # 数据Eureka
    pod 'YYModel', '~> 1.0.4'                           ## Dic or Json -> Model
    pod 'Qiniu', '~> 7.2.4'
    # pod 'GzipSwift', :git => 'https://github.com/1024jp/GzipSwift.git', :branch => 'swift4'
    pod 'FMDB', '~> 2.7.2'
    pod 'AVOSCloud', '~> 11.3.0'
    pod 'PromiseKit', '~> 4.2.0'
#    pod 'Alamofire', '~> 4.5'
    pod 'PromiseKit/Alamofire', '~> 4.2.0'
    
    # 统计
    pod 'Fabric', '~> 1.7.9'
    pod 'Crashlytics', '~> 3.10.5'
    pod 'UMengAnalytics-NO-IDFA', '~> 4.2.5'
    pod 'CocoaLumberjack/Swift', '~> 3.4.2'
    
    # 调试
    pod 'Reveal-SDK', '~> 11', :configurations => ['Debug']
    
    # 支付
    pod 'SwiftyStoreKit'
    
end

target 'TodayWidget' do
    inhibit_all_warnings!
    use_frameworks!
    pod 'Pitaya', :git => 'https://github.com/johnlui/Pitaya.git'
    pod 'PromiseKit', '~> 4.2.0'
    pod 'FMDB', '~> 2.7.2'
    pod 'CocoaLumberjack/Swift', '~> 3.4.2'
end

# 指定 swift 版本，这样升级也能编译通过，然后逐个升级替换
post_install do |installer|
    swift3_0 = [
    'PromiseKit', 'PromiseKit.common', 'PromiseKit.common-Alamofire'
    ]
    swift3_2 = [
    'AIFlatSwitch', 'Alamofire', 'AlamofireDomain', 'CocoaLumberjack/Swift',
    'KMPlaceholderTextView',
    'NVActivityIndicatorView', 'Pitaya', 'RxSwift',
    'Toaster'
    ]
#    swift4_1 = [
#    'Kanna', 'Eureka', 'SwiftyStoreKit', 'GzipSwift',
#    'YYText', 'WSProgressHUD', 'SnapKit', 'RxSwift', 'LTMorphingLabel',
#    'AVOSCloud', 'DZNEmptyDataSet', 'FMDB', 'Qiniu', 'MJRefresh', 'RSKImageCropper',
#    'SVProgressHUD', 'YYModel', 'YYWebImage'
#    ]

    installer.pods_project.targets.each do |target|
        if swift3_2.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
                printf "SWIFT_VERSION 3.2 %s\n", target.name
            end
            elsif swift3_0.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
                printf "SWIFT_VERSION 3.0 %s\n", target.name
            end
            else
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.1'
                printf "SWIFT_VERSION 4.1 %s\n", target.name
            end
        end
    end
end
