default:
	bundle exec jekyll serve --livereload

setup:
	bundle
	cp s3_website.sample.yml s3_website.yml

deploy:
	bundle exec jekyll build
