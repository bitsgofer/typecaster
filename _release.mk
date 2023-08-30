releases:
	mkdir -p releases

release-all: release-web
release-all: release-linux
release-all: release-macOS
release-all: release-windows
.PHONY: release-all

release-web: releases
release-web:
	mkdir -p releases/web
	${GODOT} --headless --export-release "web" releases/web/index.html
.PHONY: release-web

run-web:
	cd tools/webserver && \
		go build -o webserver ./...
	./tools/webserver/webserver --contentDir=releases/web
.PHONY: run-web

release-linux: releases
release-linux:
	mkdir -p releases/linux
	${GODOT} --headless --export-release "linux" releases/linux/${GAME_FILE_NAME}.amd64
.PHONY: release-linux

release-macOS: releases
release-macOS:
	mkdir -p releases/macOS
	${GODOT} --headless --export-release "macOS" releases/macOS/${GAME_FILE_NAME}.zip
.PHONY: release-macOS

release-windows: releases
release-windows:
	mkdir -p releases/windows
	${GODOT} --headless --export-release "windows" releases/windows/${GAME_FILE_NAME}.exe
.PHONY: release-windows

# release-iOS: releases
# release-iOS:
# 	mkdir -p releases/iOS
# 	${GODOT} --headless --export-release "iOS" releases/iOS/${GAME_FILE_NAME}.zip
# .PHONY: release-iOS
#
# release-android: releases
# release-android:
# 	mkdir -p releases/android
# 	${GODOT} --headless --export-release "android" releases/android/${GAME_FILE_NAME}.apk
# .PHONY: release-android
