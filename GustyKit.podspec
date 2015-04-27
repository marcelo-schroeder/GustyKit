Pod::Spec.new do |s|
    s.name                  = 'GustyKit'
    s.version           = '1.0.0'
    s.summary           = 'A Cocoa Touch development kit that helps you develop high quality iOS app extensions faster.'
    s.homepage          = 'https://github.com/marcelo-schroeder/GustyKit'
    s.license           = 'Apache-2.0'
    s.author            = { 'Marcelo Schroeder' => 'marcelo.schroeder@infoaccent.com' }
    s.platform          = :ios, '8.0'
    s.requires_arc      = true
    s.source            = { :git => 'https://github.com/marcelo-schroeder/GustyKit.git', :tag => 'v1.0.0' }
    s.default_subspec   = 'CoreUI'
    s.subspec 'Foundation' do |ss|
        ss.source_files  = 'GustyKit/GustyKit/Foundation/classes/**/*.{h,m}'
    end
    s.subspec 'CoreUI' do |ss|
        ss.source_files  = 'GustyKit/GustyKit/CoreUI/classes/**/*.{h,m}'
        ss.resource      = 'GustyKit/GustyKit/CoreUI/resources/**/*.*'
        ss.dependency 'GustyKit/Foundation'
        ss.dependency 'ODRefreshControl', '1.1.0'
    end
    s.subspec 'Help' do |ss|
        ss.source_files  = 'GustyKit/GustyKit/Help/classes/**/*.{h,m}'
        ss.resource      = 'GustyKit/GustyKit/Help/resources/**/*.*'
        ss.xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'IFA_AVAILABLE_Help=1' }
        ss.dependency 'GustyKit/CoreUI'
    end
    s.subspec 'GoogleMobileAdsSupport' do |ss|
        ss.source_files  = 'GustyKit/GustyKit/GoogleMobileAdsSupport/classes/**/*.{h,m}'
        ss.xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'IFA_AVAILABLE_GoogleMobileAdsSupport=1' }
        ss.dependency 'GustyKit/CoreUI'
        ss.dependency 'Google-Mobile-Ads-SDK', '~> 6'
    end
end
