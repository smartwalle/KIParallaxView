Pod::Spec.new do |s|
  s.name         = "KIParallaxView"
  s.version      = "0.0.2"
  s.summary      = "KIParallaxView"
  s.description  = <<-DESC
                  KIParallaxView.
                   DESC
  s.homepage     = "https://github.com/smartwalle/KIParallaxView"
  s.license      = "MIT"
  s.author             = { "SmartWalle" => "smartwalle@gmail.com" }
  s.platform     = :ios, "5.0"
  s.source       = { :git => "https://github.com/smartwalle/KIParallaxView.git", :tag => "#{s.version}" }

  s.source_files  = "KIParallaxView/KIParallaxView/*.{h,m}"
  s.requires_arc = true
end
