# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

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
# def test_pods
#
# end

target 'Adequate' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Adequate
  basic_pods

  target 'NotificationService' do
    inherit! :search_paths
  end

  target 'DealWidget' do
    inherit! :search_paths
  end

  target 'AdequateTests' do
    inherit! :search_paths
    # Pods for testing
    # test_pods
  end

end
