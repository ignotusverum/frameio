platform :ios, '11.0'
use_frameworks!
use_modular_headers!
inhibit_all_warnings! # supresses pods project warnings

def common
  pod 'IQKeyboardManagerSwift', '6.2.1'
  
  pod 'MERLin', :git => 'https://github.com/gringoireDM/MERLin.git', :branch => 'master'
end

target 'frameio' do
  common  
end

abstract_target 'Modules' do
  common
  
  pod 'RxDataSources'

  # - Targets
  target 'FrameIOFoundation'
end
