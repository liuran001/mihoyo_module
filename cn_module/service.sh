#!/system/bin/sh
MODPATH=${0%/*}

[[ $MODPATH = '' ]] && MODPATH="/data/adb/modules/mihoyo_module"

while [[ "$(getprop sys.boot_completed)" != "1" ]];
do
    sleep 3
done
rm -f $MODPATH/run.log
echo "[`date +%m.%d\ %T`] 设备开机" >> $MODPATH/run.log
chmod +x $MODPATH/curl
rm -f /data/local/tmp/mihoyo_game_tmp.apk

while true
do
    ping -c 1 www.baidu.com &> /dev/null
    [ $? -eq 0 ] && break
    sleep 10
done
echo "[`date +%m.%d\ %T`] 已连接到网络" >> $MODPATH/run.log

install_game() {
    if [[ ! "$(pm list packages | grep $1)" ]];then
        echo "[`date +%m.%d\ %T`] 未检测到 $3，开始下载安装包" >> $MODPATH/run.log
        game_apk="/data/local/tmp/mihoyo_game_tmp.apk"
        $MODPATH/curl -sL "$2" -o "$game_apk"
        echo "[`date +%m.%d\ %T`] 正在安装 $3" >> $MODPATH/run.log
        pm install "$game_apk" || echo "[`date +%m.%d\ %T`] 安装 $3 失败" >> $MODPATH/run.log
        rm -f "$game_apk"
        echo "[`date +%m.%d\ %T`] 安装 $3 完成，已清理安装包" >> $MODPATH/run.log
        if [[ "$4" != '' ]]; then
            echo "[`date +%m.%d\ %T`] 开始为 $3 下载 obb 数据包" >> $MODPATH/run.log
            obb_path="/storage/emulated/0/Android/obb/$1"
            [[ ! -d "$obb_path" ]] && mkdir "$obb_path"
            $MODPATH/curl -sL "$4" -o "$obb_path/$5" || echo "[`date +%m.%d\ %T`] 为 $3 下载 obb 数据包失败" >> $MODPATH/run.log
            echo "[`date +%m.%d\ %T`] 为 $3 下载 obb 数据包完成" >> $MODPATH/run.log
        fi
    else
        echo "[`date +%m.%d\ %T`] 已检测到 $3，忽略安装" >> $MODPATH/run.log
    fi
}

install_game "com.miHoYo.Yuanshen" "https://ys-api.mihoyo.com/event/download_porter/link/ys_cn/official/android_adbdpz" "原神"
install_game "com.miHoYo.hkrpg" "https://api-takumi.mihoyo.com/event/download_porter/link/hkrpg_cn/official/android_default" "崩坏：星穹铁道"
install_game "com.miHoYo.HSoDv2Original" "https://uri6.com/tkio/rEb2Y3a" "崩坏学园2"
install_game "com.miHoYo.enterprise.NGHSoD" "https://api-takumi.mihoyo.com/event/download_porter/link/bh3_cn/bh3/android_gw" "崩坏3"
install_game "com.miHoYo.wd" "https://api-takumi.mihoyo.com/event/download_porter/link/nxx_cn/wd/android_gw" "未定事件簿"
install_game "com.mihoyo.hyperion" "https://download-bbs.miyoushe.com/app/mihoyobbs_2.55.1_miyousheluodi.apk" "米游社"
install_game "com.gameone.hsod2" "https://file.obdo.cc/d/Cloudflare%20R2/com.gameone.hsod2.apk?sign=9UmvOkCOlwXRiAf2YGSbxjRW9K9QuQlk6Sy5dYVQ2gg=:0" "崩壞學園" "https://file.obdo.cc/d/Cloudflare%20R2/main.19.com.gameone.hsod2.obb?sign=YFcwaD61z4vUgdFVtDe4HoCevx8_CWhrH4ZidK0-KRI=:0" "main.19.com.gameone.hsod2.obb"

echo "[`date +%m.%d\ %T`] 脚本执行完毕，线程退出" >> $MODPATH/run.log
exit 0
