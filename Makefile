include _assets.mk
include _release.mk

PWD=$(shell pwd)

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)        # OSX
	GODOT_BIN = /Applications/Godot.app/Contents/MacOS/Godot
	ASEPRITE_BIN = $(shell which aseprite)
else ifeq ($(UNAME_S),Linux)    # Linux
	GODOT_BIN = $(shell which godot)
	ASEPRITE_BIN = $(shell which aseprite)
endif
GODOT_PROJ_OPTIONS=--path ${PWD}
GODOT=$(GODOT_BIN) $(GODOT_PROJ_OPTIONS)
ASEPRITE=$(ASEPRITE_BIN)

GAME_NAME=GAME_NAME_CHANGE_ME
GAME_FILE_NAME=$(subst -,_,${GAME_NAME})
SCENE=scene/root.tscn

edit:
	$(GODOT) -e ${SCENE}
.PHONY: edit

run:
	$(GODOT) ${SCENE}
.PHONY: run

debug:
	${GODOT} -d ${SCENE}
.PHONY: run

clean:
	rm -rf \
		releases/ \
		assets/
.PHONY: clean
