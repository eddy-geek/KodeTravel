#!/bin/bash

# console was in /etc/default/console-setup; now [ubuntu 14.10] /etc/default/keyboard ; fedora: /etc/X11/xorg.conf.d/00-system-setup-keyboard.conf
_SRC_=~/Dropbox/Geek/br101/br101 ; \
_MNT_='' ; \
_DSTX_=$_MNT_/usr/share/X11/xkb ; \
_DSTC_=$_MNT_/etc/default/keyboard ; \
sudo cp $_SRC_ $_DSTX_/symbols/br101 && grep -q br101 $_DSTX_/rules/evdev.xml || \
sudo vim "+%s/<\/layoutList>/ <layout>\r    <configItem>\r      <name>br101<\/name>\r       <description>br101<\/description>\r       <languageList><iso639Id>por<\/iso639Id><\/languageList>\r     <\/configItem>\r   <\/layout>\r  <\/layoutList>/gc" $_DSTX_/rules/evdev.xml \
&& grep -q br101 $_DSTC || \
echo 'XKBMODEL="pc105"
#XKBLAYOUT="us"
#XKBVARIANT="altgr-intl"
XKBLAYOUT="br101,br101"
XKBVARIANT="txt,dev"
XKBOPTIONS="group(ctrls_toggle),terminate:ctrl_alt_bksp,lv3:ralt_switch"'\
| sudo tee -a $_DSTC_

exit

# TODO: Set ~/.kde/share/config/xkbrc:
[Layout]
DisplayNames=br1,
LayoutList=br101,us(alt-intl)
LayoutLoopCount=-1
Model=pc101
ResetOldOptions=false
ShowFlag=false
ShowLabel=true
ShowLayoutIndicator=true
ShowSingle=false
SwitchMode=Global
Use=true
# For xfce it would be ~/.config/xfce4/xfconf/xfce-perchannel-xml/keyboard-layout.xml + keyboards.xml

<!-- Expanded version of the replace above -->
    <layout>
      <configItem>
        <name>br101</name>
        <description>br101</description>
        <languageList><iso639Id>por</iso639Id></languageList>
      </configItem>
      <variantList>
        <variant>
          <configItem>
            <name>dev</name>
            <description>For Code-Writing</description>
            <languageList><iso639Id>por</iso639Id></languageList>
          </configItem>
        </variant>
      </variantList>
    </layout>
<!-- More accurate version (TODO replace the above with this one) -->
    <layout>
      <configItem>
        <name>kt</name>
        <shortDescription></shortDescription>
        <description>Travel Kode</description>
        <languageList>
          <iso639Id>eng</iso639Id>
          <iso639Id>fra</iso639Id>
          <iso639Id>spa</iso639Id>
          <iso639Id>por</iso639Id>
          <iso639Id>ita</iso639Id>
        </languageList>
      </configItem>
      <variantList>
        <variant>
          <configItem>
            <name>dev</name>
            <description>br101 for Code writing</description>
          </configItem>
        </variant>
        <variant>
          <configItem>
            <name>txt</name>
            <description>br101 for Text writing</description>
          </configItem>
        </variant>
      </variantList>
    </layout>
<!-- Or for Virtualboxfedora: -->
sudo cp /media/sf_D_DRIVE/Dropbox/Geek/br101/br101 /usr/share/X11/xkb/symbols/br101 \
&& sudo chmod go+r /usr/share/X11/xkb/symbols/br101
and in /etc/X11/xorg.conf.d/00-system-setup-keyboard.conf


OLDER STUFF:


#Keyboard maps creation:
[ "$1" = "install" ] \
	&& echo "Installing keymaps..." \
	&& workdir="/dok/Fichiers/Geek/br101" \
	&& installdir="/media/16LG/br101" \
	&& sudo cp $workdir/br101 /usr/share/X11/xkb/symbols \
	&& setxkbmap -layout br101 -variant txt -print -option | xkbcomp -dflts - br101-txt.xkm \
	&& setxkbmap -layout br101 -variant txt102 -print -option | xkbcomp -dflts - br101-txt102.xkm \
	&& setxkbmap -layout br101 -variant dev -print -option | xkbcomp -dflts - br101-dev.xkm \
	&& setxkbmap -layout br101 -variant dev102 -print -option | xkbcomp -dflts - br101-dev102.xkm \
	&& cd $installdir \
	&& cp $workdir/br101* . \
	&& cp $workdir/br101.sh .. \
	&& cp -R $workdir/layouts . \
	&& echo " success" && exit

#l.8 to verify that installdir exists (i.e. pendrive is mounted)

#Keybooard maps loading
command=$0
echo -n "\$0=$0 ; "
echo -n "!!=" && history 1
[ "$command" = "/bin/bash" ] && command=`history 1 | awk '{print $NF}'` #cut -d" " -f2
echo "command=$command"
absdir=`dirname "$(cd "${command%/*}" 2>/dev/null; echo "$PWD"/"${0##*/}")"`
echo "absdir=$absdir"
alias kbdev="$(echo "xkbcomp $absdir/br101-dev.xkm $DISPLAY")"
alias kbdev102="$(echo "xkbcomp $absdir/br101-dev102.xkm $DISPLAY")"
alias kbtxt="$(echo "xkbcomp $absdir/br101-txt.xkm $DISPLAY")"
alias kbtxt102="$(echo "xkbcomp $absdir/br101-txt102.xkm $DISPLAY")"
case "$1" in
	txt102)     kbtxt102 ;;
	txt)        kbtxt ;;
	102|dev102) kbdev102 ;;
	*)          kbdev ;;
esac

