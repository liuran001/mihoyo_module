#!/system/bin/sh
MODPATH=${0%/*}

[[ $MODPATH = '' ]] && MODPATH="/data/adb/modules/fuck_mihoyo_module"

uninstall () {
    packages=$(pm list packages | grep "$1" | awk -F':' '{ print $2 }')

    for package in $packages; do
        echo "[`date +%m.%d\ %T`] 正在卸载 $package" >> $MODPATH/run.log
        pm uninstall "$package"
    done
}

while [[ "$(getprop sys.boot_completed)" != "1" ]];
do
    sleep 3
done

rm -f $MODPATH/run.log
echo "[`date +%m.%d\ %T`] 设备开机" >> $MODPATH/run.log

uninstall "com.miHoYo"
uninstall "com.mihoyo"
if pm list packages | grep -q "com.gameone.hsod2"; then
    package="com.gameone.hsod2"
    echo "[`date +%m.%d\ %T`] 正在卸载 $package" >> $MODPATH/run.log
    pm uninstall "$package"
fi

uninstall "com.HoYoverse"
uninstall "com.hoyoverse"

echo "[`date +%m.%d\ %T`] 脚本执行完毕，线程退出" >> $MODPATH/run.log
exit 0
