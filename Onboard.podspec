Pod::Spec.new do |spec|
  spec.name             = 'Onboard'
  spec.version          = '1.0'
  spec.homepage         = 'https://github.com/mamaral/Onboard'
  spec.authors          = 'Mike Amaral'
  spec.platform         = :ios
  spec.summary          = 'Onboard provides developers with a quick and easy means to create a beautiful, engaging, and useful onboarding experience with only a few lines of code.'
  spec.source           =  { :git => 'https://github.com/mamaral/Onboard.git' }
  spec.source_files     = 'OnboardingViewController.{h,m}', 'OnboardingContentViewController.{h,m}'
  spec.requires_arc 	  = true
end
