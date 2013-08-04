require './app'

guard :livereload, apply_css_live: true do
  watch /^views/
  watch /assets\/javascripts/
  watch(%r{assets/stylesheets/.+\.scss}) { |m| "/assets/app.css" }
  watch(%r{assets/(fonts|images)/(.*)}) { |m| "/assets/#{m[2]}" }
  watch /spec/
  ignore /\.swp$/
end
