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

cd "$(dirname $0)"
WORKDIR="$PWD"

VERB=''
MNT=''

LAYOUT='kt'
VMAIN='dev'

SRC="$WORKDIR/$LAYOUT.symbols"

while getopts "hvs:d:m:" opt; do
  case $opt in
#    s)
#      echo "Source Layout file: $OPTARG" >&2
#      SRC="$OPTARG"
#      ;;
#    d)
#      echo "Dropbox directory: $OPTARG" >&2
#      SRC="$OPTARG/Dropbox/Geek/$LAYOUT/$LAYOUT"
#      ;;
    m)
      echo "Mount point: $OPTARG" >&2
      MNT="$OPTARG"
      ;;
    v)
      echo "Debug enabled" >&2
      VERB='y'
      ;;
    h)
      echo "Usage: '$0 [-m dest_mount_point]'" >&2
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND-1)) ;
# now $@ contains what was previously after the arguments processed by getopts

DSTXFCE=$HOME/.config/xfce4/xfconf/xfce-perchannel-xml
read -d '' XCFG <<EOF
<?xml version="1.0" encoding="UTF-8"?>

<channel name="keyboard-layout" version="1.0">
  <property name="Default" type="empty">
    <property name="XkbDisable" type="bool" value="false"/>
    <property name="XkbModel" type="string" value=""/>
    <property name="XkbLayout" type="string" value="kt,kt,us"/>
    <property name="XkbVariant" type="string" value="dev,txt,alt-intl"/>
    <property name="XkbOptions" type="empty">
      <property name="Group" type="string" value="grp:ctrls_toggle"/>
      <property name="Compose" type="string" value="compose:102"/>
    </property>
  </property>
</channel>
EOF

## XKB folder
# older distros may use /etc/X11/xkb/ instead
DSTXKB=$MNT/usr/share/X11/xkb ; #XKB output
if test ! -d $DSTXKB
then echo "XKB folder $DSTXKB does not exist, exiting." ; exit
fi

## Console output
DSTC=$MNT/etc/default/console-setup ;
uname -r | grep -q "^3\|^2.6.38" && DSTC=$MNT/etc/default/keyboard ; #new standard
DSTC_fed=/etc/X11/xorg.conf.d/00-system-setup-keyboard.conf
test -f $DSTC_fed && DSTC=$DSTC_fed
DSTC_fed=/etc/X11/xorg.conf.d/00-keyboard.conf
test -f $DSTC_fed && DSTC=$DSTC_fed   # Unused, we will use localectl instead
if test ! -f $DSTC
then echo "Config file $DSTC does not exist, exiting." ; exit
fi

## Rules name
# given by first string of: > xprop -root _XKB_RULES_NAMES
# for fedora:_XKB_RULES_NAMES(STRING) =.config/xfce4/xfconf/xfce-perchannel-xml "evdev", "pc105", "us,us", "euro,alt-intl", ""
XMLN=$(xprop -root _XKB_RULES_NAMES | cut -d' ' -f3 | cut -b2- | rev | cut -b3- | rev)
DXML="$DSTXKB/rules/$XMLN.xml"
# eg Ubuntu 20: DXML=/usr/share/X11/xkb/rules/evdev.xml
if test ! -f $DXML
then echo "Rule file $DXML does not exist, exiting." ; exit
fi

DSTSYMB=$DSTXKB/symbols/$LAYOUT

export DXML VIMRPL DSTC

echo -e " folder: $WORKDIR\n layout: $LAYOUT \n moving file: $SRC to: $DSTSYMB \n and changing: $DSTC \n and: $DXML"
[ -n "$VERB" ] && echo " with vim command: $VIMRPL" # contains \r so no "-e"

[ -n "$VERB" ] && set -o xtrace

# Copy layout file
#sudo cp $SRC $DSTSYMB
sudo ln -s $SRC $DSTSYMB
#sudo ln -s $PWD/kt.symbols /usr/share/X11/xkb/symbols/kt

# Append layout info at the end of the layout list
$WORKDIR/kt_patch_evedex_xml.sh "$LAYOUT" "$DXML"

if test -x /bin/localectl; then  # fedora
  # see: localectl list-x11-keymap-models, list-x11-keymap-layouts, list-x11-keymap-variants [LAYOUT], list-x11-keymap-options
  sudo localectl set-x11-keymap "$LAYOUT,us" "$VMAIN,altgr-intl" "group(ctrls_toggle),terminate:ctrl_alt_bksp,lv3:ralt_switch,compose:102"
else
  # Select layout for console / xkb? by appending to default file
  grep -q $LAYOUT $DSTC || (
    echo "Patching $DSTC" ;
    #read -d '' NEWCFG <<EOF
    echo "
XKBMODEL=\"pc105\"
XKBLAYOUT=\"$LAYOUT,$LAYOUT,us\"
XKBVARIANT=\"dev,txt,altgr-intl\"
XKBOPTIONS=\"group(ctrls_toggle),terminate:ctrl_alt_bksp,lv3:ralt_switch\"" \
    | sudo tee -a $DSTC ;
  )
fi

if test -d $DSTXFCE; then
  echo $XCFG >> $DSTXFCE/keyboard-layout.xml
fi

if test -d ~/.zsh.after -a \! -f ~/.zsh.after/keymap.zsh
then echo 'keymap() { setxkbmap -layout kt -variant ${1:-dev} -print -option | xkbcomp -dflts - $DISPLAY }' \
       > ~/.zsh.after/keymap.zsh
fi

[ -n "$VERB" ] && set +o xtrace

