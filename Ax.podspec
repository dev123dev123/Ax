Pod::Spec.new do |spec|
  spec.name = "Ax"
  spec.version = "0.1.0"
  spec.summary = "Ax is a library written in Swift that helps you to control the flow of asynchronous executions in a simplified way ."
  spec.homepage = "https://github.com/wilsonbalderrama/Ax"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Wilson Balderrama" => 'wilson.balderrama@gmail.com' }
  spec.social_media_url = "http://twitter.com/thoughtbot"

  spec.platform = :ios, "10.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/wilsonbalderrama/Ax.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "Ax/**/*.{h,swift}"
end
