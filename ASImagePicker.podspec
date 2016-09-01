Pod::Spec.new do |s|
s.name             = "ASImagePicker"
s.version          = "1.0.0"
s.summary          = "Highly imitate UIImagePickerController.Support for multiSelect!(Use Photos Framework)"
s.description      = <<-DESC
Highly imitate UIImagePickerController.Support for multiSelect!(Use Photos Framework)
DESC
s.homepage         = "http://alanshen0118.github.io"
# s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
s.license          = 'MIT'
s.author           = { "Alan_Sim" => "alanshen0118@gmail.com" }
s.source           = { :git => "https://github.com/alanshen0118/ASImagePicker.git", :tag => s.version.to_s }
# s.social_media_url = ''

s.platform     = :ios, '9.0'
# s.ios.deployment_target = '5.0'
# s.osx.deployment_target = '10.7'
s.requires_arc = true

s.source_files = 'ASImagePicker/*'
# s.resources = 'Assets'

# s.ios.exclude_files = 'Classes/osx'
# s.osx.exclude_files = 'Classes/ios'
# s.public_header_files = 'Classes/**/*.h'
s.frameworks = 'Foundation', 'Photos', 'UIKit'

end