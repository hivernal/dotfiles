/usr/libexec/polkit-gnome-authentication-agent-1 &
slstatus &
feh --bg-fill "${HOME}/pictures/neboskreb.jpg"
doas xbacklight -set 10
exec dbus-launch --sh-syntax --exit-with-session dwm
