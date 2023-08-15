all: Adwaita/gtk-contained.css st-0.9/st Default-hdpi

deps: st-0.9.tar.gz gtk3.tar

GTK_THEME=M/gtk-3.0

XFWM_THEME=M/xfwm4

gtk3.tar:
	wget -O gtk3.tar https://gitlab.gnome.org/GNOME/gtk/-/archive/gtk-3-24/gtk-gtk-3-24.tar?path=gtk/theme/Adwaita

$(GTK_THEME)/gtk-contained.css: gtk3.tar
	mkdir -p $(GTK_THEME)
	tar --strip-components=4 -C $(GTK_THEME) -xf gtk3.tar gtk-gtk-3-24-gtk-theme-Adwaita/gtk/theme/Adwaita
	patch -d $(GTK_THEME) -p1 < gtk3.patch
	sh -c "cd $(GTK_THEME); ./parse-sass.sh"

st-0.9.tar.gz:
	wget https://dl.suckless.org/st/st-0.9.tar.gz

st/st: st-0.9.tar.gz
	mkdir st
	tar --strip-components=1 -C st -xzf st-0.9.tar.gz
	patch -d st -p1 < st.patch
	make -C st

Default-hdpi:
	cp -r /usr/share/themes/Default-hdpi 
	patch -d Default-hdpi -p1 < themerc.patch

.PHONY: clean

clean:
	rm -rf Adwaita st-0.9 Default-hdpi M
