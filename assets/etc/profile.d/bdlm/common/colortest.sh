#!/usr/bin/env bash

# https://wiki.archlinux.org/index.php/Color_Bash_Prompt
source /etc/profile.d/bdlm/color.sh

echo "Normal           : ${__BDLM_CLR_RST_ALL}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Normal Underline : ${__BDLM_CLR_STL_ UNDERLINE}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Normal Bold      : ${__BDLM_CLR_STL_ BOLD}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Normal Highlight : ${__BDLM_CLR_STL_ HLT}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Normal Faded     : ${__BDLM_CLR_FG_250}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo
echo "Black            : ${__BDLM_CLR_FG_BLK}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Black  Underline : ${__BDLM_CLR_FG_BLK}${__BDLM_CLR_STL_UNDERLINE}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Black  Bold      : ${__BDLM_CLR_FG_BLK}${__BDLM_CLR_STL_BOLD}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Black  Highlight : ${__BDLM_CLR_FG_BLK}${__BDLM_CLR_STL_HLT}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo
echo "Red              : ${__BDLM_CLR_FG_REDD}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Red Underline    : ${__BDLM_CLR_FG_REDD}${__BDLM_CLR_STL_UNDERLINE}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Red Bold         : ${__BDLM_CLR_FG_REDD}${__BDLM_CLR_STL_BOLD}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Red Highlight    : ${__BDLM_CLR_FG_REDD}${__BDLM_CLR_STL_HLT}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Red Faded        : ${__BDLM_CLR_FG_REDD}${__BDLM_CLR_STL_DIM}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Dark Red         : ${__BDLM_CLR_FG_REDD_DK}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Dark Red Bold    : ${__BDLM_CLR_FG_REDD_DK}${__BDLM_CLR_STL_BOLD}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo
echo "Green              : ${__BDLM_CLR_FG_GREN}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Green Underline    : ${__BDLM_CLR_FG_GREN}${__BDLM_CLR_STL_UNDERLINE}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Green Bold         : ${__BDLM_CLR_FG_GREN}${__BDLM_CLR_STL_BOLD}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Green Highlight    : ${__BDLM_CLR_FG_GREN}${__BDLM_CLR_STL_HLT}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Green Faded        : ${__BDLM_CLR_FG_GREN}${__BDLM_CLR_STL_DIM}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Green (dark) Faded : ${__BDLM_CLR_FG_GREN_DK}${__BDLM_CLR_STL_DIM}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Green (dark) Highlight : ${__BDLM_CLR_FG_GREN_DK}${__BDLM_CLR_STL_HLT}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo
echo "Yellow           : ${__BDLM_CLR_FG_YLOW}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Yellow Underline : ${__BDLM_CLR_FG_YLOW}${__BDLM_CLR_STL_UNDERLINE}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Yellow Bold      : ${__BDLM_CLR_FG_YLOW}${__BDLM_CLR_STL_BOLD}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Yellow Highlight : ${__BDLM_CLR_FG_YLOW}${__BDLM_CLR_STL_HLT}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Yellow Faded     : ${__BDLM_CLR_FG_YLOW}${__BDLM_CLR_STL_DIM}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo
echo "Brown           : ${__BDLM_CLR_FG_BRWN}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Brown Underline : ${__BDLM_CLR_FG_BRWN}${__BDLM_CLR_STL_UNDERLINE}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Brown Bold      : ${__BDLM_CLR_FG_BRWN}${__BDLM_CLR_STL_BOLD}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Brown Highlight : ${__BDLM_CLR_FG_BRWN}${__BDLM_CLR_STL_HLT}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo
echo "Blue             : ${__BDLM_CLR_FG_BLUE}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Blue Underline   : ${__BDLM_CLR_FG_BLUE}${__BDLM_CLR_STL_UNDERLINE}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Blue Bold        : ${__BDLM_CLR_FG_BLUE}${__BDLM_CLR_STL_BOLD}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Blue Highlight   : ${__BDLM_CLR_FG_BLUE}${__BDLM_CLR_STL_HLT}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Blue Faded       : ${__BDLM_CLR_FG_BLUE}${__BDLM_CLR_STL_DIM}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo
echo "Purple           : ${__BDLM_CLR_FG_PURP}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Purple Underline : ${__BDLM_CLR_FG_PURP}${__BDLM_CLR_STL_UNDERLINE}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Purple Bold      : ${__BDLM_CLR_FG_PURP}${__BDLM_CLR_STL_BOLD}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Purple Highlight : ${__BDLM_CLR_FG_PURP}${__BDLM_CLR_STL_HLT}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Purple Faded     : ${__BDLM_CLR_FG_PURP}${__BDLM_CLR_STL_DIM}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo
echo "Orange           : ${__BDLM_CLR_FG_ORNG}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Orange Faded     : ${__BDLM_CLR_FG_ORNG}${__BDLM_CLR_STL_DIM}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo
echo "Magenta          : ${__BDLM_CLR_FG_MGNT}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Magenta Underline: ${__BDLM_CLR_FG_MGNT}${__BDLM_CLR_STL_UNDERLINE}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Magenta Bold     : ${__BDLM_CLR_FG_MGNT}${__BDLM_CLR_STL_BOLD}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Magenta Highlight: ${__BDLM_CLR_FG_MGNT}${__BDLM_CLR_STL_HLT}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo
echo "Cyan             : ${__BDLM_CLR_FG_CYAN}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Cyan Underline   : ${__BDLM_CLR_FG_CYAN}${__BDLM_CLR_STL_UNDERLINE}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Cyan Bold        : ${__BDLM_CLR_FG_CYAN}${__BDLM_CLR_STL_BOLD}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Cyan Highlight   : ${__BDLM_CLR_FG_CYAN}${__BDLM_CLR_STL_HLT}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo
echo "White            : ${__BDLM_CLR_FG_WHTE_LT}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "White Underline  : ${__BDLM_CLR_FG_WHTE_LT}${__BDLM_CLR_STL_UNDERLINE}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "White Bold       : ${__BDLM_CLR_FG_WHTE_LT}${__BDLM_CLR_STL_BOLD}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "White Highlight  : ${__BDLM_CLR_FG_WHTE_LT}${__BDLM_CLR_STL_HLT}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo
echo "Black Background : ${__BDLM_CLR_BG_BLCK}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Red Background   : ${__BDLM_CLR_BG_REDD}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Green Background : ${__BDLM_CLR_BG_GREN}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Yellow Background: ${__BDLM_CLR_BG_YLOW}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Blue Background  : ${__BDLM_CLR_BG_BLUE}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Purple Background: ${__BDLM_CLR_BG_PRPL}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "Cyan Background  : ${__BDLM_CLR_BG_CYAN}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo "White Background : ${__BDLM_CLR_BG_WHTE}The quick brown fox jumped over the lazy dog.${__BDLM_CLR_RST_ALL}"
echo
echo "------------------------------------------------------------------------------------------------------------------------------------------"
echo
echo "colors by number:"
rst="__BDLM_CLR_RST_ALL"
fgblk="__BDLM_CLR_FG_BLCK"
for a in {1..255}; do
    fg="__BDLM_CLR_FG_${a}"
    bg="__BDLM_CLR_BG_${a}"
    echo "foreground: ${!fg}${fg}${!rst} | background: ${!fgblk}${!bg}${bg}${!rst}"
done
echo
echo "------------------------------------------------------------------------------------------------------------------------------------------"
echo

# Reset all styles and colors
echo ${__BDLM_CLR_RST_ALL}__BDLM_CLR_RST_ALL${__BDLM_CLR_RST_ALL}

# Text styles
echo ${__BDLM_CLR_STL_BOLD}__BDLM_CLR_STL_BOLD${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_STL_DIM}__BDLM_CLR_STL_DIM${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_STL_HLT}__BDLM_CLR_STL_HLT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_STL_UNDERLINE}__BDLM_CLR_STL_UNDERLINE${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_STL_BLINK}__BDLM_CLR_STL_BLINK${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_STL_INVERT}__BDLM_CLR_STL_INVERT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_STL_HIDDEN}__BDLM_CLR_STL_HIDDEN${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_STL_RST_BOLD}__BDLM_CLR_STL_RST_BOLD${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_STL_RST_DIM}__BDLM_CLR_STL_RST_DIM${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_STL_RST_HLT}__BDLM_CLR_STL_RST_HLT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_STL_RST_UNDERLINE}__BDLM_CLR_STL_RST_UNDERLINE${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_STL_RST_BLINK}__BDLM_CLR_STL_RST_BLINK${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_STL_RST_INVERT}__BDLM_CLR_STL_RST_INVERT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_STL_RST_HIDDEN}__BDLM_CLR_STL_RST_HIDDEN${__BDLM_CLR_RST_ALL}

# Named foreground colors
echo ${__BDLM_CLR_FG_DFLT}__BDLM_CLR_FG_DFLT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}__BDLM_CLR_FG_BLCK${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_WHTE}__BDLM_CLR_FG_WHTE${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_FG_BLUE_LT}__BDLM_CLR_FG_BLUE_LT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLUE}__BDLM_CLR_FG_BLUE${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLUE_DK}__BDLM_CLR_FG_BLUE_DK${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_FG_BRWN_LT}__BDLM_CLR_FG_BRWN_LT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BRWN}__BDLM_CLR_FG_BRWN${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BRWN_DK}__BDLM_CLR_FG_BRWN_DK${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_FG_CYAN_LT}__BDLM_CLR_FG_CYAN_LT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_CYAN}__BDLM_CLR_FG_CYAN${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_CYAN_DK}__BDLM_CLR_FG_CYAN_DK${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_FG_GRAY_LT}__BDLM_CLR_FG_GRAY_LT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_GRAY}__BDLM_CLR_FG_GRAY${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_GRAY_DK}__BDLM_CLR_FG_GRAY_DK${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_FG_GREN_LT}__BDLM_CLR_FG_GREN_LT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_GREN}__BDLM_CLR_FG_GREN${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_GREN_DK}__BDLM_CLR_FG_GREN_DK${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_FG_MGNT_LT}__BDLM_CLR_FG_MGNT_LT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_MGNT}__BDLM_CLR_FG_MGNT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_MGNT_DK}__BDLM_CLR_FG_MGNT_DK${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_FG_ORNG_LT}__BDLM_CLR_FG_ORNG_LT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_ORNG}__BDLM_CLR_FG_ORNG${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_ORNG_DK}__BDLM_CLR_FG_ORNG_DK${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_FG_PURP_LT}__BDLM_CLR_FG_PURP_LT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_PURP}__BDLM_CLR_FG_PURP${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_PURP_DK}__BDLM_CLR_FG_PURP_DK${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_FG_REDD_LT}__BDLM_CLR_FG_REDD_LT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_REDD}__BDLM_CLR_FG_REDD${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_REDD_DK}__BDLM_CLR_FG_REDD_DK${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_FG_YLOW_LT}__BDLM_CLR_FG_YLOW_LT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_YLOW}__BDLM_CLR_FG_YLOW${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_YLOW_DK}__BDLM_CLR_FG_YLOW_DK${__BDLM_CLR_RST_ALL}

# Named background colors
echo ${__BDLM_CLR_BG_DFLT}__BDLM_CLR_BG_DFLT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_BG_BLCK}__BDLM_CLR_BG_BLCK${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_WHTE}__BDLM_CLR_BG_WHTE${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_BLUE_LT}__BDLM_CLR_BG_BLUE_LT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_BLUE}__BDLM_CLR_BG_BLUE${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_BLUE_DK}__BDLM_CLR_BG_BLUE_DK${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_BRWN_LT}__BDLM_CLR_BG_BRWN_LT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_BRWN}__BDLM_CLR_BG_BRWN${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_BRWN_DK}__BDLM_CLR_BG_BRWN_DK${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_CYAN_LT}__BDLM_CLR_BG_CYAN_LT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_CYAN}__BDLM_CLR_BG_CYAN${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_CYAN_DK}__BDLM_CLR_BG_CYAN_DK${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_GRAY_LT}__BDLM_CLR_BG_GRAY_LT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_GRAY}__BDLM_CLR_BG_GRAY${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_GRAY_DK}__BDLM_CLR_BG_GRAY_DK${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_GREN_LT}__BDLM_CLR_BG_GREN_LT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_GREN}__BDLM_CLR_BG_GREN${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_GREN_DK}__BDLM_CLR_BG_GREN_DK${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_MGNT_LT}__BDLM_CLR_BG_MGNT_LT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_MGNT}__BDLM_CLR_BG_MGNT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_MGNT_DK}__BDLM_CLR_BG_MGNT_DK${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_ORNG_LT}__BDLM_CLR_BG_ORNG_LT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_ORNG}__BDLM_CLR_BG_ORNG${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_ORNG_DK}__BDLM_CLR_BG_ORNG_DK${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_PURP_LT}__BDLM_CLR_BG_PURP_LT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_PURP}__BDLM_CLR_BG_PURP${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_PURP_DK}__BDLM_CLR_BG_PURP_DK${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_REDD_LT}__BDLM_CLR_BG_REDD_LT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_REDD}__BDLM_CLR_BG_REDD${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_REDD_DK}__BDLM_CLR_BG_REDD_DK${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_WHTE_LT}__BDLM_CLR_BG_WHTE_LT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_WHTE}__BDLM_CLR_BG_WHTE${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_WHTE_DK}__BDLM_CLR_BG_WHTE_DK${__BDLM_CLR_RST_ALL}

echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_YLOW_LT}__BDLM_CLR_BG_YLOW_LT${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_YLOW}__BDLM_CLR_BG_YLOW${__BDLM_CLR_RST_ALL}
echo ${__BDLM_CLR_FG_BLCK}${__BDLM_CLR_BG_YLOW_DK}__BDLM_CLR_BG_YLOW_DK${__BDLM_CLR_RST_ALL}
