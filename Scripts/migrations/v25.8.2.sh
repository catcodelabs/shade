#!/usr/bin/env sh

if ! command -v uwsm >/dev/null 2>&1; then

    echo "'uwsm' package is required for this update. Please install it."
    echo "You can also run './install.sh' to install all missing dependencies."

fi

if command -v shade-shell >/dev/null 2>&1; then
    echo "Reloading shade shell shaders..."
    shade-shell shaders --reload
fi
