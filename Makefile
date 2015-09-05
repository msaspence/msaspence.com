default:
	jekyll serve

deploy:
	s3_website cfg apply --headless
	jekyll build
	s3_website push
