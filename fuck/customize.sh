set_perm_recursive "$MODPATH" 0 0 0755 0644

uninstall () {
    packages=$(pm list packages | grep "$1" | awk -F':' '{ print $2 }')

    for package in $packages; do
        echo "正在卸载 $package"
        pm uninstall "$package"
    done
}

uninstall "com.miHoYo"
uninstall "com.mihoyo"
if pm list packages | grep -q "com.gameone.hsod2"; then
    package="com.gameone.hsod2"
    echo "正在卸载 $package"
    pm uninstall "$package"
fi

uninstall "com.HoYoverse"
uninstall "com.hoyoverse"

ui_print " "
