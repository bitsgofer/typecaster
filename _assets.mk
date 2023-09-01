assets-all: assets
assets-all: assets/logo.png
assets-all: assets/mage.png
assets-all: assets/spell.png
assets-all: assets/enemy.png
assets-all: assets/heart.png
.PHONY: assets-all

assets:
	mkdir -p assets

assets/logo.png: media/logo.aseprite
	$(ASEPRITE) --batch \
		media/$(basename $(notdir ${<})).aseprite \
		--scale 1 \
		--save-as assets/$(basename $(notdir ${@})).png

assets/mage.png: media/mage.aseprite
	$(ASEPRITE) --batch \
		media/$(basename $(notdir ${<})).aseprite \
		--scale 1 \
		--save-as assets/$(basename $(notdir ${@})).png

assets/enemy.png: media/enemy.aseprite
	$(ASEPRITE) --batch \
		media/$(basename $(notdir ${<})).aseprite \
		--scale 1 \
		--save-as assets/$(basename $(notdir ${@})).png

assets/spell.png: media/spell.aseprite
	$(ASEPRITE) --batch \
		media/$(basename $(notdir ${<})).aseprite \
		--scale 1 \
		--save-as assets/$(basename $(notdir ${@})).png

assets/heart.png: media/heart.aseprite
	$(ASEPRITE) --batch \
		media/$(basename $(notdir ${<})).aseprite \
		--scale 1 \
		--save-as assets/$(basename $(notdir ${@})).png
