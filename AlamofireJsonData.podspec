Pod::Spec.new do |s|
  s.name         = 'AlamofireJsonData'
  s.version      = '0.0.1'
  s.summary      = 'JsonData on Alamofire.'
  s.homepage     = 'https://github.com/wegie/AlamofireJsonData'
  s.license      = 'MIT'
  s.author       = 'wegie'
  s.platform     = :ios, '8.0'
  s.source       = { :git => 'https://github.com/wegie/AlamofireJsonData.git', :tag => s.version.to_s }
  s.source_files = 'AlamofireJsonData/**/*.swift'
  s.requires_arc = true
  s.dependency 'Alamofire', '~> 3.3.1'
  s.dependency 'JsonData/Objectable', '~> 0.0.1'
end
