default:
	jekyll serve --livereload

setup:
	bundle
	cp s3_website.sample.yml s3_website.yml

deploy:
	bundle exec s3_website cfg apply --headless
	jekyll build
	bundle exec s3_website push
