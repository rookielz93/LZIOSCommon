#
# Be sure to run `pod lib lint LZIOSCommon.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LZIOSCommon'
  s.version          = '0.1.8'
  s.summary          = 'A short description of LZIOSCommon.'
  s.requires_arc     = true
    
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/rookielz93/LZIOSCommon'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rookie' => '3538290757@qq.com' }
  s.source           = { :git => 'https://github.com/rookielz93/LZIOSCommon.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.ios.deployment_target = '10.0'
  # s.default_subspec = 'AppInfo','BaseStruct','Define','Lock','Log','Segue','Thread'

  s.public_header_files = 'LZIOSCommon/Classes/*.h'
  s.source_files = 'LZIOSCommon/Classes/*.{h,m}'
  
  s.subspec 'AppInfo' do |ss|
    ss.source_files = 'LZIOSCommon/Classes/AppInfo/**/*'
    
    ss.dependency 'LZIOSCommon/Log'
    ss.dependency 'LZIOSCommon/Define'
  end
  
  s.subspec 'BaseStruct' do |ss|
    ss.source_files = 'LZIOSCommon/Classes/BaseStruct/**/*'
    
    ss.dependency 'LZIOSCommon/Log'
    ss.dependency 'LZIOSCommon/Lock'
  end
  
  s.subspec 'Define' do |ss|
    ss.source_files = 'LZIOSCommon/Classes/Define/**/*'
        
    ss.dependency 'LZIOSCommon/Log'
  end
  
  s.subspec 'Lock' do |ss|
    ss.source_files = 'LZIOSCommon/Classes/Lock/**/*'
        
    ss.dependency 'LZIOSCommon/Log'
  end
  
  s.subspec 'Log' do |ss|
    ss.source_files = 'LZIOSCommon/Classes/Log/**/*'
  end
  
  s.subspec 'Segue' do |ss|
    ss.source_files = 'LZIOSCommon/Classes/Segue/**/*'
        
    ss.dependency 'LZIOSCommon/Log'
  end
  
  s.subspec 'Thread' do |ss|
    ss.source_files = 'LZIOSCommon/Classes/Thread/**/*'
        
    ss.dependency 'LZIOSCommon/Log'
  end
  
  s.subspec 'Modules' do |ss|
    ss.dependency 'LZIOSCommon/Define' # 模块，不是文件路径
    ss.dependency 'LZIOSCommon/BaseStruct'
    ss.dependency 'LZIOSCommon/Lock'
    ss.dependency 'LZIOSCommon/Thread'
    ss.dependency 'LZIOSCommon/Log'
    ss.dependency 'LZIOSCommon/Segue'
    
    ss.subspec 'LZAlert' do |sss|
      sss.source_files = 'LZIOSCommon/Classes/Modules/LZAlert/**/*'
    end
    
    ss.subspec 'LZCategory' do |sss|
      sss.source_files = 'LZIOSCommon/Classes/Modules/LZCategory/**/*'
    end
    
    ss.subspec 'LZLocalNotification' do |sss|
      sss.source_files = 'LZIOSCommon/Classes/Modules/LZLocalNotification/**/*'
      
      sss.dependency 'LZIOSCommon/Modules/LZAlert'
    end
    
    ss.subspec 'LZMVCBase' do |sss|
      sss.source_files = 'LZIOSCommon/Classes/Modules/LZMVCBase/**/*'
    end
    
    ss.subspec 'LZPasteboardManager' do |sss|
      sss.source_files = 'LZIOSCommon/Classes/Modules/LZPasteboardManager/**/*'
    end
    
    ss.subspec 'LZVideoTool' do |sss|
      sss.source_files = 'LZIOSCommon/Classes/Modules/LZVideoTool/**/*'
      
      sss.dependency 'LZIOSCommon/Modules/LZStorage/LZFile'
      sss.frameworks = 'Foundation','AVFoundation'
    end
    
    ss.subspec 'LZStorage' do |sss|
      sss.subspec 'LZFile' do |ssss|
        ssss.source_files = 'LZIOSCommon/Classes/Modules/LZStorage/LZFile/**/*'
      end
      
      sss.subspec 'LZUserDefault' do |ssss|
        ssss.source_files = 'LZIOSCommon/Classes/Modules/LZStorage/LZUserDefault/**/*'
      end
      
      sss.subspec 'LZSqlite' do |ssss|
        ssss.source_files = 'LZIOSCommon/Classes/Modules/LZStorage/LZSqlite/**/*'
        
        ssss.dependency 'LZIOSCommon/Log'
        ssss.dependency 'LZIOSCommon/Modules/LZCategory'
        ssss.dependency 'LZIOSCommon/Modules/LZStorage/LZFile'
        ssss.dependency 'FMDB', '2.7.5'
      end
    end
    
    ss.subspec 'LZInPurchase' do |sss|
      sss.ios.deployment_target = '10.0'
      sss.source_files = 'LZIOSCommon/Classes/Modules/LZInPurchase/**/*'
      
      sss.dependency 'LZIOSCommon/Modules/LZCategory'
      sss.dependency 'LZIOSCommon/Modules/LZStorage/LZUserDefault'
      sss.dependency 'YYModel', '1.0.4'
    end
    
     ss.subspec 'LZTaskQueue' do |sss|
      sss.source_files = 'LZIOSCommon/Classes/Modules/LZTaskQueue/**/*'
      
      sss.dependency 'LZIOSCommon/Log'
    end
    
    ss.subspec 'LZNet' do |sss|
      sss.subspec 'LZNetCore' do |ssss|
        ssss.source_files = 'LZIOSCommon/Classes/Modules/LZNet/LZNetCore/**/*'
        
        ssss.dependency 'LZIOSCommon/Log'
        ssss.dependency 'AFNetworking', '4.0.0'
      end
      
      sss.subspec 'LZCookie' do |ssss|
        ssss.source_files = 'LZIOSCommon/Classes/Modules/LZNet/LZCookie/**/*'
        
        ssss.dependency 'LZIOSCommon/Log'
      end
      
      sss.subspec 'LZAPI' do |ssss|
        ssss.source_files = 'LZIOSCommon/Classes/Modules/LZNet/LZAPI/**/*'
        
        ssss.dependency 'LZIOSCommon/Log'
        ssss.dependency 'LZIOSCommon/Modules/LZNet/LZNetCore'
      end
      
      sss.subspec 'LZFileDownloader' do |ssss|
        ssss.source_files = 'LZIOSCommon/Classes/Modules/LZNet/LZFileDownloader/**/*'
        
        ssss.dependency 'LZIOSCommon/Log'
        ssss.dependency 'LZIOSCommon/Modules/LZTaskQueue'
        ssss.dependency 'LZIOSCommon/Modules/LZNet/LZNetCore'
      end
    end
    
  end
  
  # s.exclude_files = 'avp-kit/**/Test/**/*'
  # s.resource_bundles = {
  #   'LZIOSCommon' => ['LZIOSCommon/Assets/*.png']
  # }

  # s.frameworks = 'UIKit', 'MapKit'

end
