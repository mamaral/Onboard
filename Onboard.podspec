Pod::Spec.new do |s|

  s.name         = "Onboard"
  s.version      = "1.0"
  s.summary      = "Onboard provides developers with a quick and easy means to create a beautiful, engaging, and useful onboarding experience with only a few lines of code."
  s.homepage     = "https://github.com/mamaral/Onboard"
  s.screenshots  = "https://github.com/mamaral/Onboard/blob/master/onboard_demo.gif", "https://github.com/mamaral/Onboard/blob/master/Screenshots/purple1.png", "https://github.com/mamaral/Onboard/blob/master/Screenshots/space2.png"
  s.license      = "MIT"
  s.author             = { "Mike Amaral" => "mike.amaral36@gmail.com" }
  s.social_media_url   = "http://twitter.com/MikeAmaral"
  s.platform     = :ios
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/mamaral/Onboard.git", :tag => "1.0" }
  s.source_files  = "Objective-C/Onboard/OnboardingViewController.{h,m}", "Objective-C/Onboard/OnboardingContentViewController.{h,m}"
  s.requires_arc = true

end
