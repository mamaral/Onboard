Pod::Spec.new do |s|

  s.name         = "Onboard"
  s.version      = "2.1.7"
  s.summary      = "Create a beautiful and engaging onboarding experience with only a few lines of code."
  s.homepage     = "https://github.com/mamaral/Onboard"
  s.license      = "MIT"
  s.author       = { "Mike Amaral" => "mike.amaral36@gmail.com" }
  s.social_media_url   = "http://twitter.com/MikeAmaral"
  s.platform     = :ios
  s.source       = { :git => "https://github.com/mamaral/Onboard.git", :tag => "v2.1.7" }
  s.source_files  = "Source/OnboardingViewController.{h,m}", "Source/OnboardingContentViewController.{h,m}"
  s.requires_arc = true

end
