index:
	helm package charts/* -d packages
	helm repo index --url https://github.com/letrungtrieu/charts .