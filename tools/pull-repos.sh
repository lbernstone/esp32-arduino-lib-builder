#!/bin/bash

source ./tools/config.sh

#
# CLONE ESP-IDF
#

if [ ! -d "$IDF_PATH" ]; then
	cloner "$IDF_REPO_URL" "$IDF_COMMIT" "$IDF_PATH"
else
	updater "$IDF_REPO_URL" "$IDF_COMMIT" "$IDF_PATH"
fi
if [ $? -ne 0 ]; then exit 1; fi
cd $IDF_PATH && ./install.sh
if [ $? -ne 0 ]; then exit 1; fi

#
# CLONE/UPDATE ARDUINO
#

if [ ! -d "$AR_COMPS/arduino" ]; then
	cloner $AR_REPO_URL "$ARDUINO_COMMIT" "$AR_COMPS/arduino"
else
	updater $AR_REPO_URL "$ARDUINO_COMMIT" "$AR_COMPS/arduino"
fi
if [ $? -ne 0 ]; then exit 1; fi

#
# CLONE/UPDATE ESP32-CAMERA
#

if [ ! -d "$AR_COMPS/esp32-camera" ]; then
	cloner $CAMERA_REPO_URL "$CAMERA_COMMIT" "$AR_COMPS/esp32-camera"
else
	updater $CAMERA_REPO_URL "$CAMERA_COMMIT" "$AR_COMPS/esp32-camera"
fi
if [ $? -ne 0 ]; then exit 1; fi

#
# CLONE/UPDATE ESP-FACE
#

if [ ! -d "$AR_COMPS/esp-face" ]; then
	cloner $FACE_REPO_URL "$FACE_COMMIT" "$AR_COMPS/esp-face"
else
	updater $FACE_REPO_URL "$FACE_COMMIT" "$AR_COMPS/esp-face"
fi
if [ $? -ne 0 ]; then exit 1; fi
