ASEPRITE_FILES := $(shell find ./media -type f -name '*.aseprite')
PNG_FILES := $(patsubst ./media/%.aseprite, ./assets/%.png, $(ASEPRITE_FILES))

assets: ${PNG_FILES}
.PHONY: assets

assets/%.png: media/%.aseprite
	mkdir -p $(dir ${@})
	$(ASEPRITE) --batch \
		${<} \
		--scale 1 \
		--save-as ${@}
