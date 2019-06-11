Pod::Spec.new do |s|
  s.name         = "RNCalculatorKeyboard"
  s.version      = "1.0.0"
  s.summary      = "Calculator keyboard input view"

  s.description  = <<-DESC
                   Custom Input View that mimics a calculator keyboard for fast number input.
                   DESC

  s.homepage     = "https://github.com/souzainf3/RNLoadingButton-Swift"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Romilson Nunes" => "souzainf3@yahoo.com.br" }
  s.social_media_url   = "http://twitter.com/souzainf3"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/souzainf3/RNCalculatorKeyboard.git", :tag => s.version.to_s }

  s.source_files  = "Source/*"
  s.frameworks = "UIKit"
  s.requires_arc = true
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }

end
