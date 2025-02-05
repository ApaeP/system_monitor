#!/bin/bash

PLUGINS_PATH="$HOME/Library/Application Support/xbar/plugins"
CURRENT_DIR=`pwd`

cp "${CURRENT_DIR}"/system_monitor.1s.rb "${PLUGINS_PATH}"/system_monitor.1s.rb
cp -R "${CURRENT_DIR}"/system_monitor "${PLUGINS_PATH}"
