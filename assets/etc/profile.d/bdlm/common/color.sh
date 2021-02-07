#!/usr/bin/env bash


# .bdlmrc color and style variables:

# All colors (256)
for a in {1..255}; do
    declare "__BDLM_CLR_FG_${a}"=$'\033[38;5;'${a}'m' # Foreground
    declare "__BDLM_CLR_BG_${a}"=$'\033[48;5;'${a}'m' # Background
done

# Reset all styles and colors
__BDLM_CLR_RST_ALL=$'\033[0m'

# Text styles
__BDLM_CLR_STL_BOLD=$'\033[1m'           # Bold
__BDLM_CLR_STL_DIM=$'\033[2m'            # Dim
__BDLM_CLR_STL_HLT=$'\033[3m'            # Highlight
__BDLM_CLR_STL_UNDERLINE=$'\033[4m'      # Underline
__BDLM_CLR_STL_BLINK=$'\033[5m'          # Blink
__BDLM_CLR_STL_INVERT=$'\033[7m'         # Invert
__BDLM_CLR_STL_HIDDEN=$'\033[8m'         # Hidden

__BDLM_CLR_STL_RST_BOLD=$'\033[21m'      # Reset Bold
__BDLM_CLR_STL_RST_DIM=$'\033[22m'       # Reset Dim
__BDLM_CLR_STL_RST_HLT=$'\033[23m'       # Reset Highlight
__BDLM_CLR_STL_RST_UNDERLINE=$'\033[24m' # Reset Underline
__BDLM_CLR_STL_RST_BLINK=$'\033[25m'     # Reset Blink
__BDLM_CLR_STL_RST_INVERT=$'\033[27m'    # Reset Invert
__BDLM_CLR_STL_RST_HIDDEN=$'\033[28m'    # Reset Hidden

# Named foreground colors
__BDLM_CLR_FG_DFLT=$'\033[39m'          # Default
__BDLM_CLR_FG_BLCK=$'\033[30m'          # Black
__BDLM_CLR_FG_WHTE=$'\033[38;5;15m'     # White

__BDLM_CLR_FG_GRAY=$'\033[38;5;242m'    # Gray
__BDLM_CLR_FG_REDD=$'\033[31m'          # Red
__BDLM_CLR_FG_GREN=$'\033[32m'          # Green
__BDLM_CLR_FG_YLOW=$'\033[33m'          # Yellow
__BDLM_CLR_FG_BLUE=$'\033[38;5;27m'     # Blue
__BDLM_CLR_FG_MGNT=$'\033[35m'          # Magenta
__BDLM_CLR_FG_CYAN=$'\033[36m'          # Cyan
__BDLM_CLR_FG_BRWN=$'\033[38;5;130m'    # Brown
__BDLM_CLR_FG_ORNG=$'\033[38;5;208m'    # Orange
__BDLM_CLR_FG_PURP=$'\033[38;5;129m'    # Purple

__BDLM_CLR_FG_GRAY_LT=$'\033[38;5;245m' # Light Gray
__BDLM_CLR_FG_REDD_LT=$'\033[91m'       # Light Red
__BDLM_CLR_FG_GREN_LT=$'\033[92m'       # Light Green
__BDLM_CLR_FG_YLOW_LT=$'\033[93m'       # Light Yellow
__BDLM_CLR_FG_BLUE_LT=$'\033[38;5;33m'  # Light Blue
__BDLM_CLR_FG_MGNT_LT=$'\033[95m'       # Light Magenta
__BDLM_CLR_FG_CYAN_LT=$'\033[96m'       # Light Cyan
__BDLM_CLR_FG_BRWN_LT=$'\033[38;5;136m' # Light Brown
__BDLM_CLR_FG_ORNG_LT=$'\033[38;5;172m' # Light Orange
__BDLM_CLR_FG_PURP_LT=$'\033[38;5;135m' # Light Purple

__BDLM_CLR_FG_GRAY_DK=$'\033[38;5;238m' # Dark Gray
__BDLM_CLR_FG_REDD_DK=$'\033[38;5;124m' # Dark Red
__BDLM_CLR_FG_GREN_DK=$'\033[92m'       # Dark Green
__BDLM_CLR_FG_YLOW_DK=$'\033[93m'       # Dark Yellow
__BDLM_CLR_FG_BLUE_DK=$'\033[38;5;21m'  # Dark Blue
__BDLM_CLR_FG_MGNT_DK=$'\033[95m'       # Dark Magenta
__BDLM_CLR_FG_CYAN_DK=$'\033[96m'       # Dark Cyan
__BDLM_CLR_FG_BRWN_DK=$'\033[38;5;94m'  # Dark Brown
__BDLM_CLR_FG_ORNG_DK=$'\033[38;5;172m' # Dark Orange
__BDLM_CLR_FG_PURP_DK=$'\033[38;5;135m' # Dark Purple

# Named background colors
__BDLM_CLR_BG_DFLT=$'\033[49m'          # Default
__BDLM_CLR_BG_BLCK=$'\033[40m'          # Black
__BDLM_CLR_BG_WHTE=$'\033[48;5;15m'     # White

__BDLM_CLR_BG_GRAY=$'\033[48;5;242m'    # Gray
__BDLM_CLR_BG_REDD=$'\033[41m'          # Red
__BDLM_CLR_BG_GREN=$'\033[42m'          # Green
__BDLM_CLR_BG_YLOW=$'\033[43m'          # Yellow
__BDLM_CLR_BG_BLUE=$'\033[48;5;27m'     # Blue
__BDLM_CLR_BG_MGNT=$'\033[45m'          # Magenta
__BDLM_CLR_BG_CYAN=$'\033[46m'          # Cyan
__BDLM_CLR_BG_BRWN=$'\033[48;5;130m'    # Brown
__BDLM_CLR_BG_ORNG=$'\033[48;5;208m'    # Orange
__BDLM_CLR_BG_PURP=$'\033[48;5;129m'    # Purple

__BDLM_CLR_BG_GRAY_LT=$'\033[48;5;245m' # Light Gray
__BDLM_CLR_BG_REDD_LT=$'\033[101m'      # Light Red
__BDLM_CLR_BG_GREN_LT=$'\033[102m'      # Light Green
__BDLM_CLR_BG_YLOW_LT=$'\033[103m'      # Light Yellow
__BDLM_CLR_BG_BLUE_LT=$'\033[48;5;33m'  # Light Blue
__BDLM_CLR_BG_MGNT_LT=$'\033[105m'      # Light Magenta
__BDLM_CLR_BG_CYAN_LT=$'\033[106m'      # Light Cyan
__BDLM_CLR_BG_WHTE_LT=$'\033[48;5;250m' # Light White
__BDLM_CLR_BG_BRWN_LT=$'\033[48;5;136m' # Light Brown
__BDLM_CLR_BG_ORNG_LT=$'\033[48;5;172m' # Light Orange
__BDLM_CLR_BG_PURP_LT=$'\033[48;5;135m' # Light Purple

__BDLM_CLR_BG_GRAY_DK=$'\033[48;5;238m' # Dark Gray
__BDLM_CLR_BG_REDD_DK=$'\033[48;5;124m' # Dark Red
__BDLM_CLR_BG_GREN_DK=$'\033[102m'      # Dark Green
__BDLM_CLR_BG_YLOW_DK=$'\033[103m'      # Dark Yellow
__BDLM_CLR_BG_BLUE_DK=$'\033[48;5;21m'  # Dark Blue
__BDLM_CLR_BG_MGNT_DK=$'\033[105m'      # Dark Magenta
__BDLM_CLR_BG_CYAN_DK=$'\033[106m'      # Dark Cyan
__BDLM_CLR_BG_WHTE_DK=$'\033[48;5;250m' # Dark White
__BDLM_CLR_BG_BRWN_DK=$'\033[48;5;94m'  # Dark Brown
__BDLM_CLR_BG_ORNG_DK=$'\033[48;5;172m' # Dark Orange
__BDLM_CLR_BG_PURP_DK=$'\033[48;5;135m' # Dark Purple

__BDLM_CLR=1
