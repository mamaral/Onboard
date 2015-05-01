Pod::Spec.new do |s|

  s.name         = "Onboard"
  s.version      = "2.1.2"
  s.summary      = "Onboard provides devs with a quick and easy way to create an engaging, and useful onboarding experience with only a few lines of code."
  s.homepage     = "https://github.com/mamaral/Onboard"
  s.license      = "MIT"
  s.author       = { "Mike Amaral" => "mike.amaral36@gmail.com" }
  s.social_media_url   = "http://twitter.com/MikeAmaral"
  s.platform     = :ios
  s.source       = { :git => "https://github.com/mamaral/Onboard.git", :tag => "v2.1.2" }
  s.source_files  = "Objective-C/Onboard/OnboardingViewController.{h,m}", "Objective-C/Onboard/OnboardingContentViewController.{h,m}"
  s.requires_arc = true

end
