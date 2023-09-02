ASEPRITE_FILES := $(shell find ./media -type f -name '*.aseprite')
PNG_FILES := $(patsubst ./media/%.aseprite, ./assets/%.png, $(ASEPRITE_FILES))

MP3_SOURCE_FILES := $(shell find ./media -type f -name '*.mp3')
MP3_FILES := $(patsubst ./media/%.mp3, ./assets/%.mp3, ${MP3_SOURCE_FILES})
WAV_SOURCE_FILES := $(shell find ./media -type f -name '*.wav')
WAV_FILES := $(patsubst ./media/%.wav, ./assets/%.wav, ${WAV_SOURCE_FILES})

assets: assets-graphics assets-sound
.PHONY: assets

assets-sound: ${MP3_FILES} ${WAV_FILES}
.PHONY: assets-sound

assets/%.mp3: media/%.mp3
	mkdir -p $(dir ${@})
	cp ${<} ${@}

assets/%.wav: media/%.wav
	mkdir -p $(dir ${@})
	cp ${<} ${@}

assets-graphics: ${PNG_FILES}
.PHONY: assets-graphics

assets/%.png: media/%.aseprite
	mkdir -p $(dir ${@})
	$(ASEPRITE) --batch \
		${<} \
		--scale 1 \
		--save-as ${@}
