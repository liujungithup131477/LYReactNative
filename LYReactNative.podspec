require "json"

package = JSON.parse(File.read(File.join(__dir__, "node_modules/react-native/package.json")))
version = package['version']

source = { :git => 'https://github.com/facebook/react-native.git' }
if version == '1000.0.0'
  # This is an unpublished version, use the latest commit hash of the react-native repo, which we’re presumably in.
  source[:commit] = `git rev-parse HEAD`.strip
else
  source[:tag] = "v#{version}"
end

folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1'
folly_version = '2016.09.26.00'

filePath = 'node_modules/react-native/'
codePushFilePath = 'node_modules/react-native-code-push/'
svgFilePath = 'node_modules/react-native-svg/'
linearGradientFilePath = 'node_modules/react-native-linear-gradient/'
appcenterFilePath = 'node_modules/appcenter/'
appcenterAnalyticsFilePath = 'node_modules/appcenter-analytics/'
appcenterCrashesFilePath = 'node_modules/appcenter-crashes/'
documentName = 'LYReactNative/React/'

codePushPackage = JSON.parse(File.read(File.join(__dir__, 'node_modules/react-native-code-push/package.json')))

Pod::Spec.new do |s|

  s.name         = "LYReactNative"
  s.version      = "0.57.8"
  s.summary      = "pod for ReactNative."

  s.description  = <<-DESC
                    pod for ReactNative with RN v0.57.8.
                   DESC

  s.homepage     = "https://github.com/liujungithup131477/LYReactNative"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"

  s.author             = { "admin" => "liujun163131477@163.com" }
  s.source       = { :git => "https://github.com/liujungithup131477/LYReactNative.git", :tag => "#{s.version}" }
  s.header_dir = "React"
  s.requires_arc = true
  s.ios.deployment_target = '9.0'
  s.platform = :ios, '9.0'

  s.pod_target_xcconfig     = {
      "CLANG_CXX_LANGUAGE_STANDARD" => "c++14",
      'OTHER_LDFLAGS' => '-ObjC',
      'HEADER_SEARCH_PATHS' => '\'$(PODS_ROOT)/Folly\' \'$(PODS_ROOT)/boost-for-react-native\'  \'$(PODS_ROOT)/DoubleConversion\' \'$(PODS_TARGET_SRCROOT)/BRCIotSmartLifeRN/CodePush\'',
      'VALID_ARCHS[sdk=iphonesimulator*]' => ''
  }

  s.cocoapods_version       = ">= 1.2.0"
  s.subspec "React" do |s|
    s.subspec "Core" do |ss|
        ss.dependency             "Yoga"
        ss.subspec "Base" do |sss|
            sss.source_files = "#{filePath}React/Base/**/*.{c,h,m,mm,S,cpp}"
            sss.ios.exclude_files    = "#{filePath}React/**/RCTTV*.*"
        end
        ss.subspec "Modules" do |sss|
            sss.source_files = "#{filePath}React/Modules/*.{c,h,m,mm,S,cpp}"
            sss.ios.exclude_files    = "#{filePath}React/**/RCTTV*.*"
        end
        ss.subspec "Profiler" do |sss|
            sss.source_files = "#{filePath}React/Profiler/*.{c,h,m,mm,S,cpp}"
            sss.ios.exclude_files    = "#{filePath}React/**/RCTTV*.*"
        end
        ss.subspec "UIUtils" do |sss|
            sss.source_files = "#{filePath}React/UIUtils/*.{c,h,m,mm,S,cpp}"
            sss.ios.exclude_files    = "#{filePath}React/**/RCTTV*.*"
        end
        ss.subspec "Views" do |sss|
            sss.source_files = "#{filePath}React/Views/**/*.{c,h,m,mm,S,cpp}"
            sss.ios.exclude_files = "#{filePath}React/Views/RCTTV*.*"
        end
        
        ss.header_dir           = "React"
        ss.framework            = "JavaScriptCore"
        ss.libraries            = "stdc++"
        ss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/#{filePath}ReactCommon\"" }
    end
    
    s.subspec "CxxBridge" do |ss|
      ss.dependency             "Folly", folly_version
        ss.dependency             "#{documentName}Core"
        ss.dependency             "#{documentName}cxxreact"
        ss.compiler_flags       = folly_compiler_flags
        ss.private_header_files = "#{filePath}React/Cxx*/*.h"
        ss.source_files         = "#{filePath}React/Cxx*/*.{h,m,mm}"
      end
      
      s.subspec "DevSupport" do |ss|
          ss.dependency           "#{documentName}Core"
          ss.dependency           "#{documentName}RCTWebSocket"
          ss.source_files       = "#{filePath}React/DevSupport/*",
                                    "#{filePath}React/Inspector/*"
      end
      
      s.subspec "jschelpers" do |ss|
          ss.dependency             "Folly", folly_version
          ss.dependency             "#{documentName}PrivateDatabase"
          ss.compiler_flags       = folly_compiler_flags
          ss.source_files         = "#{filePath}ReactCommon/jschelpers/*.{cpp,h}"
          ss.private_header_files = "#{filePath}ReactCommon/jschelpers/*.h"
          ss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/#{filePath}ReactCommon\"" }
          ss.framework            = "JavaScriptCore"
      end
      
      s.subspec "jsinspector" do |ss|
          ss.source_files         = "#{filePath}ReactCommon/jsinspector/*.{cpp,h}"
          ss.private_header_files = "#{filePath}ReactCommon/jsinspector/*.h"
          ss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/#{filePath}ReactCommon\"" }
      end
      
      s.subspec "PrivateDatabase" do |ss|
          ss.source_files         = "#{filePath}ReactCommon/privatedata/*.{cpp,h}"
          ss.private_header_files = "#{filePath}ReactCommon/privatedata/*.h"
          ss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/#{filePath}ReactCommon\"" }
      end
      
      s.subspec "cxxreact" do |ss|
          ss.dependency             "#{documentName}jschelpers"
          ss.dependency             "#{documentName}jsinspector"
          ss.dependency             "boost-for-react-native", "1.63.0"
          ss.dependency             "Folly", folly_version
          ss.compiler_flags       = folly_compiler_flags
          ss.source_files         = "#{filePath}ReactCommon/cxxreact/*.{cpp,h}"
          ss.exclude_files        = "#{filePath}ReactCommon/cxxreact/SampleCxxModule.*"
          ss.private_header_files = "#{filePath}ReactCommon/cxxreact/*.h"
          ss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/#{filePath}ReactCommon\" \"$(PODS_ROOT)/boost-for-react-native\" \"$(PODS_ROOT)/DoubleConversion\" \"$(PODS_ROOT)/Folly\"" }
      end
      
      s.subspec "RCTAnimation" do |ss|
          ss.dependency             "#{documentName}Core"
          ss.source_files         = "#{filePath}Libraries/NativeAnimation/{Drivers/*,Nodes/*,*}.{h,m}"
          ss.header_dir           = "RCTAnimation"
      end
      
      s.subspec "RCTBlob" do |ss|
          ss.dependency             "#{documentName}Core"
          ss.source_files         = "#{filePath}Libraries/Blob/*.{h,m,mm}"
          ss.preserve_paths       = "#{filePath}Libraries/Blob/*.js"
      end
      
      s.subspec "RCTGeolocation" do |ss|
          ss.dependency             "#{documentName}Core"
          ss.source_files         = "#{filePath}Libraries/Geolocation/*.{h,m}"
      end
      
      s.subspec "RCTImage" do |ss|
          ss.dependency             "#{documentName}Core"
          ss.dependency             "#{documentName}RCTNetwork"
          ss.source_files         = "#{filePath}Libraries/Image/*.{h,m}"
      end
      
      s.subspec "RCTNetwork" do |ss|
          ss.dependency             "#{documentName}Core"
          ss.source_files         = "#{filePath}Libraries/Network/*.{h,m,mm}"
      end
      
      s.subspec "RCTText" do |ss|
          ss.dependency             "#{documentName}Core"
          ss.source_files         = "#{filePath}Libraries/Text/**/*.{h,m}"
      end
      
      s.subspec "RCTWebSocket" do |ss|
          ss.dependency             "#{documentName}Core"
          ss.dependency             "#{documentName}RCTBlob"
          ss.dependency             "#{documentName}fishhook"
          ss.source_files         = "#{filePath}Libraries/WebSocket/*.{h,m}"
      end
      
      s.subspec "fishhook" do |ss|
        ss.header_dir           = "fishhook"
        ss.source_files         = "#{filePath}Libraries/fishhook/*.{h,c}"
      end
      
      s.subspec "RCTLinkingIOS" do |ss|
          ss.dependency             "#{documentName}Core"
          ss.source_files         = "#{filePath}Libraries/LinkingIOS/*.{h,m}"
      end
  end

end
