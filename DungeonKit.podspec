Pod::Spec.new do |s|
  s.name              = "DungeonKit"
  s.version           = "1.0.0"
  s.summary           = "Tabletop gaming character sheet logic engine."
  s.description       = "DungeonKit makes it easy to create character sheets for tabletop games.  Define statistics and their interactions with one another, and the entire sheet's values will update automatically."
  s.homepage          = "https://github.com/dodgecm/DungeonKit"
  s.license           = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author            = { "Chris Dodge" => "cmd8n@virginia.edu" }
#  s.source            = { :git => "https://github.com/dodgecm/DungeonKit.git", :tag => "v#{s.version}" }
  s.platform          = :ios, '8.0'
  s.requires_arc      = true
  s.frameworks        = [ "UIKit" ]

  s.subspec 'Core' do |cs|
    cs.source_files   = 'DungeonKit/core/**/*.{h,m}'
  end

  s.subspec '5e' do |cs|
    cs.dependency 'DungeonKit/Core'
    cs.source_files   = 'DungeonKit/5e/**/*.{h,m}'
  end
end
