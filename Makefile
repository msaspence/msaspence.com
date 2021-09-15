default:
	bundle exec jekyll serve --livereload

setup:
	bundle
	cp s3_website.sample.yml s3_website.yml

deploy:
	bundle exec jekyll build
	aws s3 sync ./_site/ s3://msaspence.com
