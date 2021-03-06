# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '0.1'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w[
  main/home.js
]

Rails.application.config.assets.precompile += %w[
  main/home.css
  main/ie/ie8.css
  main/ie/ie9.css
  mailer/application.css
  main/error.css
]

Rails.application.config.assets.precompile += %w[
  *.png
  *.jpg
  *.jpeg
  *.gif
  *.eot
  *.svg
  *.ttf
  *.woff
]

Rails.application.config.assets.precompile += %w( bx_loader.gif controls.png )
