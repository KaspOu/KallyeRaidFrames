#!/usr/bin/env bash

cp ./Shared/OptionsUnitDebuffsKRF.xml ../KBigDebuffs/Shared/OptionsUnitDebuffsKBD.xml
cp ./Shared/WidgetsKRF.xml ../KBigDebuffs/Shared/WidgetsKBD.xml
sed -i 's/KRF/KBD/g' ../KBigDebuffs/Shared/OptionsUnitDebuffsKBD.xml
sed -i 's/KRF/KBD/g' ../KBigDebuffs/Shared/WidgetsKBD.xml

cp ./Shared/OptionsNameplatesColorKRF.xml ../KNameplateColor/Shared/OptionsNameplatesColorKNC.xml
cp ./Shared/WidgetsKRF.xml ../KNameplateColor/Shared/WidgetsKNC.xml
sed -i 's/KRF/KNC/g' ../KNameplateColor/Shared/OptionsNameplatesColorKNC.xml
sed -i 's/KallyeRaidFrames/KNameplateColor/g' ../KNameplateColor/Shared/OptionsNameplatesColorKNC.xml
sed -i 's/KRF/KNC/g' ../KNameplateColor/Shared/WidgetsKNC.xml

cp ./Shared/OptionsRaidIconsKRF.xml ../KRaidIcons/Shared/OptionsRaidIconsKRI.xml
cp ./Shared/WidgetsKRF.xml ../KRaidIcons/Shared/WidgetsKRI.xml
sed -i 's/KRF/KRI/g' ../KRaidIcons/Shared/OptionsRaidIconsKRI.xml
sed -i 's/KRF/KRI/g' ../KRaidIcons/Shared/WidgetsKRI.xml

# KBD
sed -n '/-- KBD START/,/-- KBD END/{/-- KBD START/!{/-- KBD END/!p}}' Core/localization.en.lua > /tmp/temp.en.lua
sed -i '/-- KBD START/,/-- KBD END/{/-- KBD START/!{/-- KBD END/!d}}' ../KBigDebuffs/Core/localization.en.lua
sed -i '/-- KBD START/r /tmp/temp.en.lua' ../KBigDebuffs/Core/localization.en.lua

sed -n '/-- KBD START/,/-- KBD END/{/-- KBD START/!{/-- KBD END/!p}}' Core/localization.es.lua > /tmp/temp.es.lua
sed -i '/-- KBD START/,/-- KBD END/{/-- KBD START/!{/-- KBD END/!d}}' ../KBigDebuffs/Core/localization.es.lua
sed -i '/-- KBD START/r /tmp/temp.es.lua' ../KBigDebuffs/Core/localization.es.lua

sed -n '/-- KBD START/,/-- KBD END/{/-- KBD START/!{/-- KBD END/!p}}' Core/localization.fr.lua > /tmp/temp.fr.lua
sed -i '/-- KBD START/,/-- KBD END/{/-- KBD START/!{/-- KBD END/!d}}' ../KBigDebuffs/Core/localization.fr.lua
sed -i '/-- KBD START/r /tmp/temp.fr.lua' ../KBigDebuffs/Core/localization.fr.lua

sed -n '/-- KBD START/,/-- KBD END/{/-- KBD START/!{/-- KBD END/!p}}' Core/localization.ru.lua > /tmp/temp.ru.lua
sed -i '/-- KBD START/,/-- KBD END/{/-- KBD START/!{/-- KBD END/!d}}' ../KBigDebuffs/Core/localization.ru.lua
sed -i '/-- KBD START/r /tmp/temp.ru.lua' ../KBigDebuffs/Core/localization.ru.lua

# NameplatesColor
sed -n '/-- KNC START/,/-- KNC END/{/-- KNC START/!{/-- KNC END/!p}}' Core/localization.en.lua > /tmp/temp.en.lua
sed -i '/-- KNC START/,/-- KNC END/{/-- KNC START/!{/-- KNC END/!d}}' ../KNameplateColor/Core/localization.en.lua
sed -i '/-- KNC START/r /tmp/temp.en.lua' ../KNameplateColor/Core/localization.en.lua

sed -n '/-- KNC START/,/-- KNC END/{/-- KNC START/!{/-- KNC END/!p}}' Core/localization.es.lua > /tmp/temp.es.lua
sed -i '/-- KNC START/,/-- KNC END/{/-- KNC START/!{/-- KNC END/!d}}' ../KNameplateColor/Core/localization.es.lua
sed -i '/-- KNC START/r /tmp/temp.es.lua' ../KNameplateColor/Core/localization.es.lua

sed -n '/-- KNC START/,/-- KNC END/{/-- KNC START/!{/-- KNC END/!p}}' Core/localization.fr.lua > /tmp/temp.fr.lua
sed -i '/-- KNC START/,/-- KNC END/{/-- KNC START/!{/-- KNC END/!d}}' ../KNameplateColor/Core/localization.fr.lua
sed -i '/-- KNC START/r /tmp/temp.fr.lua' ../KNameplateColor/Core/localization.fr.lua

sed -n '/-- KNC START/,/-- KNC END/{/-- KNC START/!{/-- KNC END/!p}}' Core/localization.ru.lua > /tmp/temp.ru.lua
sed -i '/-- KNC START/,/-- KNC END/{/-- KNC START/!{/-- KNC END/!d}}' ../KNameplateColor/Core/localization.ru.lua
sed -i '/-- KNC START/r /tmp/temp.ru.lua' ../KNameplateColor/Core/localization.ru.lua

# Raid Icons
sed -n '/-- KRI START/,/-- KRI END/{/-- KRI START/!{/-- KRI END/!p}}' Core/localization.en.lua > /tmp/temp.en.lua
sed -i '/-- KRI START/,/-- KRI END/{/-- KRI START/!{/-- KRI END/!d}}' ../KRaidIcons/Core/localization.en.lua
sed -i '/-- KRI START/r /tmp/temp.en.lua' ../KRaidIcons/Core/localization.en.lua

sed -n '/-- KRI START/,/-- KRI END/{/-- KRI START/!{/-- KRI END/!p}}' Core/localization.es.lua > /tmp/temp.es.lua
sed -i '/-- KRI START/,/-- KRI END/{/-- KRI START/!{/-- KRI END/!d}}' ../KRaidIcons/Core/localization.es.lua
sed -i '/-- KRI START/r /tmp/temp.es.lua' ../KRaidIcons/Core/localization.es.lua

sed -n '/-- KRI START/,/-- KRI END/{/-- KRI START/!{/-- KRI END/!p}}' Core/localization.fr.lua > /tmp/temp.fr.lua
sed -i '/-- KRI START/,/-- KRI END/{/-- KRI START/!{/-- KRI END/!d}}' ../KRaidIcons/Core/localization.fr.lua
sed -i '/-- KRI START/r /tmp/temp.fr.lua' ../KRaidIcons/Core/localization.fr.lua

sed -n '/-- KRI START/,/-- KRI END/{/-- KRI START/!{/-- KRI END/!p}}' Core/localization.ru.lua > /tmp/temp.ru.lua
sed -i '/-- KRI START/,/-- KRI END/{/-- KRI START/!{/-- KRI END/!d}}' ../KRaidIcons/Core/localization.ru.lua
sed -i '/-- KRI START/r /tmp/temp.ru.lua' ../KRaidIcons/Core/localization.ru.lua


rm /tmp/temp.*.lua
