assets-all: assets
assets-all: assets/logo.png
.PHONY: assets-all

assets:
	mkdir -p assets

assets/logo.png: media/logo.aseprite
	$(ASEPRITE) --batch \
		media/$(basename $(notdir ${<})).aseprite \
		--scale 1 \
		--save-as assets/$(basename $(notdir ${@})).png
