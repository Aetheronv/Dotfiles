#!/usr/bin/env bash

# ------------------ DIRETÓRIOS ------------------
THEMES_DIR="$HOME/.config/eww/themes"
CURRENT="$THEMES_DIR/current.scss"

ALACRITTY_THEMES="$HOME/.config/alacritty/themes"
ALACRITTY_CURRENT="$ALACRITTY_THEMES/current.toml"

HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"
HYPR_CONF="$HOME/.config/hypr/hyprland.conf"

# ------------------ WALLPAPERS ------------------
WALLPAPER_DARK="$HOME/.config/hypr/dark.jpg"
WALLPAPER_LIGHT="$HOME/.config/hypr/light.jpg"

# ------------------ DETECTA TEMA ATUAL ------------------
if [ -L "$CURRENT" ]; then
    CURRENT_THEME=$(basename "$(readlink -f "$CURRENT")" .scss)
else
    CURRENT_THEME="dark"
fi

# ------------------ ALTERNA TEMA ------------------
[ "$CURRENT_THEME" = "dark" ] && THEME="light" || THEME="dark"

# ------------------ EWW ------------------
eww update currentTheme="$THEME"
ln -sf "$THEMES_DIR/$THEME.scss" "$CURRENT"

# ------------------ ALACRITTY ------------------
[ -f "$ALACRITTY_THEMES/$THEME.toml" ] && ln -sf "$ALACRITTY_THEMES/$THEME.toml" "$ALACRITTY_CURRENT"

# ------------------ NEOVIM ------------------
THEME_NVIM="$([ "$THEME" = "dark" ] && echo "glassd" || echo "glassl")"
if command -v nvr >/dev/null 2>&1; then
    nvr --remote-send ":let g:TeVimTheme='$THEME_NVIM'<CR>"
    nvr --remote-send ":lua require('tevim.themes').load()<CR>"
fi

#------------------- ROFI ----------------
if [ "$THEME" = "dark" ]; then
    ln -sf "$THEMES_DIR/glassd.rasi" "$THEMES_DIR/current.rasi"
else
    ln -sf "$THEMES_DIR/glassl.rasi" "$THEMES_DIR/current.rasi"
fi


# ------------------ GTK ------------------
GTK4_CONF="$HOME/.config/gtk-4.0/settings.ini"
THEME_DIR="$HOME/.themes/Tahoe-$([ "$THEME" = "dark" ] && echo "Dark" || echo "Light")"

# Copia a pasta gtk-4.0 do tema para ~/.config/gtk-4.0
mkdir -p "$HOME/.config/gtk-4.0"
rm -rf "$HOME/.config/gtk-4.0/"*
cp -r "$THEME_DIR/gtk-4.0/"* "$HOME/.config/gtk-4.0/"

# Atualiza GTK3 também (gsettings/xfconf) para dark/light
if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.interface gtk-theme "Tahoe-$([ "$THEME" = "dark" ] && echo "Dark" || echo "Light")"
elif command -v xfconf-query >/dev/null 2>&1; then
    xfconf-query -c xsettings -p /Net/ThemeName -s "Tahoe-$([ "$THEME" = "dark" ] && echo "Dark" || echo "Light")"
fi

# Reinicia xdg-desktop-portal-gtk
pkill -f xdg-desktop-portal-gtk
pkill -f nautilus
nohup xdg-desktop-portal-gtk >/dev/null 2>&1 &


# ------------------ WALLPAPER ------------------
WALLPAPER="$([ "$THEME" = "dark" ] && echo "$WALLPAPER_DARK" || echo "$WALLPAPER_LIGHT")"
sed -i "s|^preload = .*|preload = $WALLPAPER|" "$HYPRPAPER_CONF"
sed -i "s|^wallpaper = .*|wallpaper = HDMI-A-1,$WALLPAPER|" "$HYPRPAPER_CONF"

# ------------------ RECARREGA HYPRPAPER ------------------
pkill hyprpaper
hyprpaper & disown

# ------------------ HYPRLAND ------------------
if [ "$THEME" = "dark" ]; then
    sed -i 's|^source =.*|source = ~/.config/hypr/themes/dark.conf|' "$HYPR_CONF"
else
    sed -i 's|^source =.*|source = ~/.config/hypr/themes/light.conf|' "$HYPR_CONF"
fi

