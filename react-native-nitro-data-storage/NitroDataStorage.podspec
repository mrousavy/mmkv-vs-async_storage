require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = "NitroDataStorage"
  s.version      = package['version']
  s.summary      = package['description']
  s.homepage     = package['homepage'] || "https://github.com/yourusername/react-native-nitro-data-storage"
  s.license      = package['license']
  s.authors      = package['author']
  s.platforms    = { :ios => "17.0" }
  s.source       = { :git => package['repository']['url'], :tag => "v#{s.version}" }

  s.source_files = "ios/**/*.swift"

  load 'nitrogen/generated/ios/NitroDataStorage+autolinking.rb'
  add_nitrogen_files(s)

  # React Native and Nitro dependencies
  s.dependency "NitroModules"
  s.dependency "React-jsi"
  s.dependency "React-callinvoker"

  install_modules_dependencies(s)
end
