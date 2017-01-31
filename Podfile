# Uncomment this line to define a global platform for your project
platform :ios, '8.0'

use_frameworks!

target 'HFUTer3' do
    # UI
    pod 'WSProgressHUD'                     ## 不错的Hud
    pod 'YYWebImage'                        ## 高效ImageView
    pod 'YYImage/WebP'
    pod 'SnapKit'                           ## AutoLayout
    pod 'SVProgressHUD'
    pod 'MJRefresh'                         ## 下拉刷新
    pod 'AIFlatSwitch'                      ## 动态选择button
    pod 'YYText'   , :git => 'https://github.com/BrikerMan/YYText.git'
    pod 'ZYCornerRadius'                    # 优化圆角绘制r
    
    # TableView
    pod 'UITableView+FDTemplateLayoutCell_Bell'  ##优化UITableViewCell高度计算
    pod 'Eureka', '~> 2.0.0-beta.1'                           ## 优秀的TableView封装

    pod 'DZNEmptyDataSet'                   ## 空数据展示
    
    # 动画
    pod 'NVActivityIndicatorView'
    pod 'SwipeBack'
    pod 'LTMorphingLabel', :git => 'https://github.com/lexrus/LTMorphingLabel.git', :branch => 'swift3'
    
    # 网络
    pod 'AlamofireDomain', '~> 4.0'         ## 牛逼的网络请求库
    pod 'KMPlaceholderTextView'             ## 带Placeholder的TextView
    pod 'Pitaya', :git => 'https://github.com/johnlui/Pitaya.git'
    
    # 数据
    pod 'YYModel'                           ## Dic or Json -> Model
    pod 'Qiniu'
    
    # 统计
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'UMengAnalytics-NO-IDFA'
    
    # 调试
    pod 'Reveal-SDK', :configurations => ['Debug']
    
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
            config.build_settings['DYLIB_COMPATIBILITY_VERSION'] = ''
        end
    end
end
