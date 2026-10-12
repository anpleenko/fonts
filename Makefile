build:
	./scripts/checking-dependencies.sh
	./scripts/build-iosevka-custom.sh
	./scripts/nerd-font-generator.sh
	./scripts/package-fonts.sh
