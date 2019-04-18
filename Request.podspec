Pod::Spec.new do |s|
		s.name 				= "Request"
		s.version 			= "1.0.0"
		s.summary         	= "Sort description of 'Request' framework"
	    s.homepage        	= "https://github.com/amine2233/Request"
	    s.license           = { type: 'MIT', file: 'LICENSE' }
	    s.author            = { 'Amine Bensalah' => 'amine.bensalah@outlook.com' }
	    s.ios.deployment_target = '10.0'
	    s.osx.deployment_target = '10.12'
	    s.tvos.deployment_target = '10.0'
	    s.watchos.deployment_target = '4.0'
	    s.requires_arc = true
	    s.source            = { :git => "https://github.com/amine2233/Request.git", :tag => s.version.to_s }
	    s.source_files      = "Sources/**/*.swift"
	    s.swift_version = '4.0'
	    s.pod_target_xcconfig = {
    		'SWIFT_VERSION' => s.swift_version
  		}
  		s.module_name = s.name

		s.ios.exclude_files = "Sources/Extensions/AppKit", "Sources/Extensions/WatchKit"
  		s.tvos.exclude_files = "Sources/Extensions/AppKit", "Sources/Extensions/WatchKit"
  		s.osx.exclude_files = "Sources/Extensions/UIKit", "Sources/Extensions/WatchKit"
  		s.watchos.exclude_files = "Sources/Extensions/AppKit", "Sources/Extensions/UIKit"
	end
