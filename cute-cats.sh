
#!/usr/bin/env bash

#
# Author: iluvgirlswithglasses
# Github: https://github.com/iluvgirlswithglasses
#
#
# --------------------------- description ----------------------------
#
# This script generates a deadass simple ascii art along with a text.
# The quote I use for the text is from "First Love" by Ivan Turgenev.
# Which is... quite fitting for the ascii art.
#
#
# ------------------------- make executable --------------------------
#
# To make this script executable in the $PATH environment:
# $ chmod +x ./cute-cats.sh
# $ ln -s $( readlink -f ./cute-cats.sh) ~/.local/bin/cute-cats
#
# If ~/.local/bin is not included in your $PATH environment, you may
# add it to the environment, or simply create the symlink elsewhere.
#
#
# -------------------------- customization ---------------------------
#
# Modify './data/cute-cats/*.txt' to change the art and the text to
# whatever you like.
#
#
# ----------------------------- options ------------------------------
#
# This script takes an optional argument. You may use it to specify
# the gap between the art and the text. E.g., this set gap to 4 lines:
# $ ./cute-cats.sh 4
#
# Use printf to generate the top and the bottom margin. For example:
# $ printf "\n\n" && ./cute-cats.sh && printf "\n\n"
#

# default gap between art and text is 2 lines
GAP=$(( ${1:-2} ))

# get content
DIR=$( dirname $(realpath "$0") )
ART_DIR="$DIR/data/cute-cats/ascii-art.txt"
TXT_DIR="$DIR/data/cute-cats/quote.txt"

# this color theme is from iluvgirlswithglasses/dotfiles
ART_COLOR="\\e[38;2;240;116;137m"
TXT_COLOR="\\e[38;2;151;158;171m\\e[3m"

# calculate paddings
SCR_COLS=$(( $(tput cols) ))
ART_COLS=$(( $(wc -L "$ART_DIR" | awk '{print $1;}') ))
TXT_COLS=$(( $(wc -L "$TXT_DIR" | awk '{print $1;}') ))

if [ $ART_COLS -lt $TXT_COLS ]
then
	DIFF=$(( ($TXT_COLS - $ART_COLS) / 2 ))
	TXT_PADS=$(( ($SCR_COLS - $TXT_COLS) / 2 ))
	ART_PADS=$(( $TXT_PADS + $DIFF ))
else
	DIFF=$(( ($ART_COLS - $TXT_COLS) / 2 ))
	ART_PADS=$(( ($SCR_COLS - $ART_COLS) / 2 ))
	TXT_PADS=$(( $ART_PADS + $DIFF ))
fi

# padding top
echo

# print the ascii art
printf "$ART_COLOR"
while IFS= read -r line
do
	printf "%${ART_PADS}s" ""
	printf "${line}\n"
done < $ART_DIR

# print gap between art and text
GAP=$(( $GAP - 1 ))
printf "%${GAP}s\n" | tr ' ' '\n'

# print text
printf "$TXT_COLOR"
while IFS= read -r line
do
	printf "%${TXT_PADS}s" ""
	printf "${line}\n"
done < $TXT_DIR

# reset
printf "\e[0m"

# padding bottom
echo

