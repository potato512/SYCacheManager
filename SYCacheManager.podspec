Pod::Spec.new do |s|
  s.name         = "SYCacheManager"
  s.version      = "2.0.1"
  s.summary      = "SYCacheManager used to cache data."
  s.homepage     = "https://github.com/potato512/SYCacheManager"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "herman" => "zhangsy757@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/potato512/SYCacheManager.git", :tag => "#{s.version}" }
  s.source_files  = "SYCacheManager/**/*.{h,m}"
  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true
  s.dependency "LKDBHelper"
  s.dependency "FMDB"
end
