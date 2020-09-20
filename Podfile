# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

# Basic
def basic_pods
  pod 'Down'
  pod 'Promises'
  pod 'SwiftyBeaver'
  # AWS
  pod 'AWSCore'
  pod 'AWSAppSync'
  pod 'AWSMobileClient'
  pod 'AWSSNS'
end

# Testing
def test_pods
  pod 'SnapshotTesting', '~> 1.8.2'
end

# # UITesting
def ui_test_pods
  pod 'Swifter', '~> 1.5.0-rc.1'
end

target 'Adequate' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Adequate
  basic_pods
end

target 'NotificationService' do
  use_frameworks!
end

target 'DealWidget' do
  use_frameworks!
end

target 'AdequateTests' do
  use_frameworks!
  basic_pods
  test_pods
end

target 'AdequateUITests' do
  use_frameworks!
  ui_test_pods
end
