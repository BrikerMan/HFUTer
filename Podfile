source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'


target 'HFUTer3' do
    inhibit_all_warnings!
    use_frameworks!
    # UI
    pod 'WSProgressHUD', '~> 1.1.2'                         ## 不错的Hud
    pod 'YYWebImage', '~> 1.0.5'                            ## 高效ImageView
    pod 'YYImage/WebP', '~> 1.0.4'
    pod 'SnapKit', '~> 3.2.0'                               ## AutoLayout
    pod 'SVProgressHUD', '~> 2.1.2'
    pod 'MJRefresh', '~> 3.1.15'
    pod 'AIFlatSwitch', '~> 1.0.2'                          ## 动态选择button
    pod 'YYText' , :git => 'https://github.com/BrikerMan/YYText.git'
    pod 'ZYCornerRadius', '~> 1.0.2'                        # 优化圆角绘制
    pod 'RSKImageCropper', :git => 'https://github.com/BrikerMan/RSKImageCropper.git' ## 图片选择
    pod 'Toaster', '~> 2.1.1'
    
    # TableView
    pod 'UITableView+FDTemplateLayoutCell_Bell', '~> 1.5.0' ##优化UITableViewCell高度计算
    pod 'Eureka', '~> 4.2.0'
    pod 'Kanna', '~> 4.0.0'
    pod 'DZNEmptyDataSet', '~> 1.8.1'                       ## 空数据展示
    
    # 动画
    pod 'NVActivityIndicatorView', '~> 3.6.1'
    pod 'SwipeBack', '~> 1.1.1'
    pod 'LTMorphingLabel', '~> 0.5.3'
    
    # 网络
#    pod 'Alamofire', '~> 4.5'
    pod 'PromiseKit/Alamofire', '~> 4.2.0'
    pod 'AlamofireDomain', '~> 4.0'         ## 牛逼的网络请求库
    pod 'KMPlaceholderTextView', '~> 1.3.0'             ## 带Placeholder的TextView
    pod 'Pitaya', :git => 'https://github.com/johnlui/Pitaya.git'
    pod 'RxSwift', '~> 3.4.0'
    
    # 数据Eureka
    pod 'YYModel', '~> 1.0.4'                           ## Dic or Json -> Model
    pod 'Qiniu', '~> 7.1.5'
    pod 'GzipSwift', :git => 'https://github.com/1024jp/GzipSwift.git', :branch => 'swift4'
    pod 'FMDB', '~> 2.6.2'
    pod 'AVOSCloud', '~> 4.4.0'
    pod 'PromiseKit', '~> 4.2.0'
    
    
    # 统计
    pod 'Fabric', '~> 1.6.11'
    pod 'Crashlytics', '~> 3.8.4'
    pod 'UMengAnalytics-NO-IDFA', '~> 4.2.5'
    pod 'CocoaLumberjack/Swift', '~> 3.1.0'
    
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
    pod 'FMDB', '~> 2.6.2'
    pod 'CocoaLumberjack/Swift', '~> 3.1.0'
end

# 指定 swift 版本，这样升级也能编译通过，然后逐个升级替换
post_install do |installer|
    swift3_2 = ['AIFlatSwitch', 'Alamofire', 'AlamofireDomain', 'CocoaLumberjack/Swift', 
        'GzipSwift', 'KMPlaceholderTextView', 'LTMorphingLabel',
        'NVActivityIndicatorView', 'Pitaya', 'PromiseKit', 'RxSwift', 'SnapKit',
        'Toaster']
    swift4_1 = ['Kanna', 'Eureka', 'SwiftyStoreKit']
    
    installer.pods_project.targets.each do |target|
        if swift3_2.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        elsif swift4_1.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.1'
            end
        else
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end
end
