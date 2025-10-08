#!/usr/bin/env bash

echo "Shared Options & Widgets: KBigDebuffs"
cp ./Shared/OptionsUnitDebuffsKRF.xml ../KBigDebuffs/Shared/OptionsUnitDebuffsKBD.xml
cp ./Shared/WidgetsKRF.xml ../KBigDebuffs/Shared/WidgetsKBD.xml
sed -i 's/KRF/KBD/g' ../KBigDebuffs/Shared/OptionsUnitDebuffsKBD.xml
sed -i 's/KRF/KBD/g' ../KBigDebuffs/Shared/WidgetsKBD.xml

echo "Shared Options & Widgets: KNameplateColor"
cp ./Shared/OptionsNameplatesColorKRF.xml ../KNameplateColor/Shared/OptionsNameplatesColorKNC.xml
cp ./Shared/WidgetsKRF.xml ../KNameplateColor/Shared/WidgetsKNC.xml
sed -i 's/KRF/KNC/g' ../KNameplateColor/Shared/OptionsNameplatesColorKNC.xml
sed -i 's/KallyeRaidFrames/KNameplateColor/g' ../KNameplateColor/Shared/OptionsNameplatesColorKNC.xml
sed -i 's/KRF/KNC/g' ../KNameplateColor/Shared/WidgetsKNC.xml

echo "Shared Options & Widgets: KRaidIcons"
cp ./Shared/OptionsRaidIconsKRF.xml ../KRaidIcons/Shared/OptionsRaidIconsKRI.xml
cp ./Shared/WidgetsKRF.xml ../KRaidIcons/Shared/WidgetsKRI.xml
sed -i 's/KRF/KRI/g' ../KRaidIcons/Shared/OptionsRaidIconsKRI.xml
sed -i 's/KRF/KRI/g' ../KRaidIcons/Shared/WidgetsKRI.xml

LANGS=("en" "fr" "de" "es" "it" "ko" "ru" "zh")

for lang in "${LANGS[@]}"; do
    echo "/KBigDebuffs/Core/localization.${lang}.lua: KBigDebuffs / KNameplateColor / KRaidIcons"
    # KBD
    sed -n "/-- KBD START/,/-- KBD END/{/-- KBD START/!{/-- KBD END/!p}}" Core/localization.${lang}.lua > /tmp/temp.${lang}.lua
    sed -i "/-- KBD START/,/-- KBD END/{/-- KBD START/!{/-- KBD END/!d}}" ../KBigDebuffs/Core/localization.${lang}.lua
    sed -i "/-- KBD START/r /tmp/temp.${lang}.lua" ../KBigDebuffs/Core/localization.${lang}.lua

    # NameplatesColor (KNC)
    sed -n "/-- KNC START/,/-- KNC END/{/-- KNC START/!{/-- KNC END/!p}}" Core/localization.${lang}.lua > /tmp/temp.${lang}.lua
    sed -i "/-- KNC START/,/-- KNC END/{/-- KNC START/!{/-- KNC END/!d}}" ../KNameplateColor/Core/localization.${lang}.lua
    sed -i "/-- KNC START/r /tmp/temp.${lang}.lua" ../KNameplateColor/Core/localization.${lang}.lua

    # Raid Icons (KRI)
    sed -n "/-- KRI START/,/-- KRI END/{/-- KRI START/!{/-- KRI END/!p}}" Core/localization.${lang}.lua > /tmp/temp.${lang}.lua
    sed -i "/-- KRI START/,/-- KRI END/{/-- KRI START/!{/-- KRI END/!d}}" ../KRaidIcons/Core/localization.${lang}.lua
    sed -i "/-- KRI START/r /tmp/temp.${lang}.lua" ../KRaidIcons/Core/localization.${lang}.lua
done


rm /tmp/temp.*.lua
