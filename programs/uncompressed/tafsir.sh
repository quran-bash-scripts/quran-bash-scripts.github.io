#!/bin/bash
#
# In the Name of Allah The entirely Mercifyl, the especially Merciful
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>
# or write to the Free Software Foundation, Inc., 51 Franklin St,
# Fifth Floor, Boston, MA 02110-1301 USA
#
# Copyright (C) Hijri: 1439, 1440
#
# Copyright (C) Gregorian: 2018
# Abu-Djuwairiyyah Karim ibn Muḥammad as-Salafî


#######################
# Different variables #
#    and constants    #
#######################


####################
# Get the root directory
# of this very script
export thisScriptRootDir=""
get_script_root_dir(){
    # Solution 1
    SCRIPT_A1=$(realpath $0)
    SCRIPTPATH_A1=$(dirname $SCRIPT_A1)

    # Solution 2
    SCRIPT_A2=$(readlink -f $0)
    SCRIPTPATH_A2=$(dirname $SCRIPT_A2)

    # Solution 3
    SCRIPT_A3="$(readlink --canonicalize-existing "$0")"
    SCRIPTPATH_A3="$(dirname "$SCRIPT_A3")"

    # Solution 4
    SCRIPT_A4="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
    SCRIPTPATH_A4=$(dirname $SCRIPT_A4)

    # Solution 5
    SCRIPTPATH_A5=$(dirname $0)

    if [[ -d "$SCRIPTPATH_A1" ]]
    then
	thisScriptRootDir="$SCRIPTPATH_A1"
    elif [[ -d "$SCRIPTPATH_A2" ]]
    then
	thisScriptRootDir="$SCRIPTPATH_A2"
    elif [[ -d "$SCRIPTPATH_A3" ]]
    then
	thisScriptRootDir="$SCRIPTPATH_A3"
    elif [[ -d "$SCRIPTPATH_A4" ]]
    then
	thisScriptRootDir="$SCRIPTPATH_A4"
    elif [[ -d "$SCRIPTPATH_A5" ]]
    then
	thisScriptRootDir="$SCRIPTPATH_A5"
    else
	echo 'Error: Failed to get the root directory of this script!'
	exit $E_DIDNOTGETROOT
    fi
}
# Run the function to
# get the variable 
get_script_root_dir

export html_tafasir_folder_thisScriptRoot="$thisScriptRootDir/html-tafasir-files"
export txt_tafasir_folder_thisScriptRoot="$thisScriptRootDir/txt-tafasir-files"

export html_tafasir_folder_users_home="$HOME/.tafsir/html-tafasir-files"
export txt_tafasir_folder_users_home="$HOME/.tafsir/txt-tafasir-files"



######## HTML output folder ########
# Output tafsir file folder
export out_taf_file_dirname=""

# Output tafsir text file
export ayaat_out_txt_taf_file=""
export ayaat_out_htm_taf_file=""

does_html_output_location_exist(){

    error_msg="

 We were not able to find a suitable
 Location where to generate the HTML
 file that will show the information
 of the current âyât being played.
 Please make sure your SDCard and/or
 your personal home directory is/are
 readable and writable. This program
 Will exit now...

 Please provide your own output
 directory to the script. Use: -o
 or --output-file-root, followed by
 the full path to folder. For example:
 
`basename $0` -o /home/abu-bakr/quran-files/
"
    
    if [[ -d "/storage/sdcard0/" ]]
    then
	out_taf_file_dirname="/storage/sdcard0/"

    elif [[ -d "/storage/emulated/legacy/" ]]
    then
	out_taf_file_dirname="/storage/emulated/legacy/"

    elif [[ -d "/storage/emulated/0/" ]]
    then
	out_taf_file_dirname="/storage/emulated/0"

    elif [[ -d "/Removable/MicroSD/" ]]
    then
	out_taf_file_dirname="/Removable/MicroSD/"

    elif [[ -d "/sdcard/external_sd/" ]]
    then
	out_taf_file_dirname="/sdcard/external_sd/"

    elif [[ -d "/storage/" ]]
    then
	out_taf_file_dirname="/storage/"

    elif [[ -d "/sdcard0/" ]]
    then
	out_taf_file_dirname="/sdcard0/"

    elif [[ -d "/sdcard1/" ]]
    then
	out_taf_file_dirname="/sdcard1/"

    elif [[ -d "$HOME/" ]]
    then
	out_taf_file_dirname="$HOME/"
    else
	reset
	echo "$error_msg"
	exit
    fi

    ayaat_out_txt_taf_file="$out_taf_file_dirname/tafsir.txt"
    ayaat_out_htm_taf_file="$out_taf_file_dirname/tafsir.html"
}
# Launch the function
# to get the output folder
does_html_output_location_exist



export outputFormat="htm" # default value
export query_type_suwar_or_ayat=""
export entered_set_of_suwar_or_set_of_ayat=""
export entered_koran_unit_number=""
export set_of_ayat_to_pass_to_tafsir_lookup=""
export set_of_suwar_to_convert_to_ayat=""
export set_of_koran_unit_to_convert_to_ayat=""
export ayaat_tafsirs_array_to_be_dumped_to_outfile=()
export taf_file_ext=trans.zekr.7z
export inputExt_txt="txt"
export inputExt_html="html"

# Tells us if the function
# was successful or not
export flag=""

# Tells us if the user entered
# ayaat or suwar range
export range_flag=""

# First element of the range
export first=""

# Last element of the range
export last=""

# line number of the given
# ayah as it appears in the
# zekr/tanzil quran/translation
# text file formats. This one
# will be set up for us by the
# convert_surahAndAyahNumber_to_tanzil_ayahLineNumber
# function.
export ayahLineNumber=""

# Surah and Ayah number in
# the 001007, 114005...
# format. This variable will
# be set up by the function
# conv_ayahLineNumberber_to_surahAndAyahNumber
# which will be given a line number
# to be converted into Surah and
# ayah number using the zekr/tanzil
# ayat->line number scheme.
export surahAndAyahNumber=""

# empty array that will hold
# the list of ayat of a given
# Sūrah. That one will be set
# up for us by the function
export ayaat_list_of_given_surah=( )

# Will hold the number of verses
# of a given Sūrah.
export number_of_verses_of_surah=""

# Array variables for the list of verses of various units
export list_of_verses_that_belong_to_this_HIZB=( )
export list_of_verses_that_belong_to_this_JUZ=( )
export list_of_verses_that_belong_to_this_PAGE_NUMBER=( )
export list_of_verses_that_belong_to_this_RUB_UL_HIZB=( )
export list_of_verses_that_belong_to_this_KORAN_UNIT=( )

# For the time being, these flag vars
# are not really used in the program
export JUZ_FLAG="false"
export HIZB_FLAG="false"
export RUB_UL_HIZB_FLAG="false"
export PAGE_NUMBER_FLAG="false"
export AYAAT_FLAG="false"
export SUWAR_FLAG="false"



# Check the dependencies are present
check_dependencies(){
    reset; echo
    
    #type find >/dev/null 2>&1 || {
    #	echo >&2 "find is not accessible!";
    #	echo "Please install the findutils package.";
    #	echo "The program will work fine but you"
    #	echo "will not be able to generate Playlist"
    #	echo "files untill you install GNU find.";
    #   }

    type tput >/dev/null 2>&1 || {
	echo >&2 "'tput' is not accessible!"
	echo "Please install the tput package. Note that normally,"
	echo "tput is part of the 'ncurses' package. Thus, installing"
	echo "tput actually means installing ncurses. The program will"
	echo "work fine but colored text output will be handled by Bash"
	echo "and if your terminal doesn't support Bash colors, you"
	echo "will get some ugly output wherever colored text appears."
	echo;
    }
    
    #  type parallel >/dev/null 2>&1 || {
    #	echo >&2 "'parallel' is not accessible!";
    #	echo "Please install the GNU parallel package.";
    #	echo "The program will work fine but you"
    #	echo "will not be able to generate Playlist"
    #	echo "files untill you install GNU parallel.";
    #   }

    #  type termux-notification >/dev/null 2>&1 || {
    #	echo >&2 "'termux-notification' is not accessible!";
    #	echo "Please install the 'termux-api' package";
    #	echo "If you are running this script on Termux";
    #	echo "on Android. The program will work fine";
    #	echo "but you will not get info display on the";
    #	echo "Android notification bar.";
    #   }

    #  type termux-vibrate >/dev/null 2>&1 || {
    #	echo >&2 "'termux-vibrate' is not accessible!";
    #	echo "Please install the 'termux-api' package";
    #	echo "If you are running this script on Termux";
    #	echo "on Android. The program will work fine";
    #	echo "but you will not get the vibration";
    #	echo "feature on you Android device";
    #   }

    type 7z >/dev/null 2>&1 || {
	echo >&2 "7z is not accessible!";
	echo "Please install the 'p7zip-full' package.";
	echo "This program will exit now...";
	exit 1;
    }

    type sed >/dev/null 2>&1 || {
	echo >&2 "sed is not accessible!";
	echo "Please install GNU Sed.";
	echo "This program will exit now...";
	exit 1;
    }

    #  type mpv >/dev/null 2>&1 || {
    #	echo >&2 "The MPV-Player is not accessible!";
    #	echo "Please install the 'mpv' package.";
    #	echo "This program will exit now...";
    #	exit 1;
    #   }

    #  type awk >/dev/null 2>&1 || {
    #   echo >&2 "'awk' is not accessible!";
    #   echo "Please install the 'gawk' package.";
    #   echo "The program will work fine but some";
    #   echo "minor features will not work untill";
    #   echo "you install GNU awk.";
    # }
    
}
# Run the function to see if
# the dependencies are installed
check_dependencies



# Text color variables
export UNDERLINE=""
export HIGHLIGHT=""
export OFF_HIGHLIGHT=""
export BOLD=""
export NC="" # No Color

# Normal colors
export RED=""
export GREEN=""
export YELLOW=""
export BLUE=""
export MAGENTA=""
export CYAN=""
export WHITE=""

# Boldfaced colors
export BOLD_RED=""
export BOLD_GREEN=""
export BOLD_YELLOW=""
export BOLD_BLUE=""
export BOLD_MAGENTA=""
export BOLD_CYAN=""
export BOLD_WHITE=""

# Simple, normal colors BG FG
export BG_YELLOW_FG_BLACK=""
export BG_GREEN_FG_BLACK=""
export BG_CYAN_FG_BLACK=""
export BG_MAGENTA_FG_BLACK=""
export BG_RED_FG_BLACK=""
export BG_BLUE_FG_BLACK=""
export BG_WHITE_FG_BLACK=""

# Boldfaced colors BG FG
export BOLD_BG_YELLOW_FG_BLACK=""
export BOLD_BG_GREEN_FG_BLACK=""
export BOLD_BG_CYAN_FG_BLACK=""
export BOLD_BG_MAGENTA_FG_BLACK=""
export BOLD_BG_RED_FG_BLACK=""
export BOLD_BG_BLUE_FG_BLACK=""
export BOLD_BG_WHITE_FG_BLACK=""

# New, recently set up
export BG_BLACK_FG_YELLOW=""
export BG_BLACK_FG_GREEN=""
export BG_BLACK_FG_WHITE=""
export BG_RED_FG_WHITE=""
export BG_GREEN_FG_WHITE=""
export BG_YELLOW_FG_WHITE=""
export BG_BLUE_FG_WHITE=""
export BG_MAGENTA_FG_WHITE=""


check_tput_and_set_up_tput_colors_or_bash_colors(){
    type tput >/dev/null 2>&1 && {

	UNDERLINE=$(tput sgr 0 1)
	BOLD=$(tput bold)
	HIGHLIGHT=$(tput smso)
	OFF_HIGHLIGHT=$(tput rmso)
	NC=$(tput sgr0) # reset, No color

	# Nomal colors
	RED=$(tput setaf 1)
	GREEN=$(tput setaf 2)
	YELLOW=$(tput setaf 3)
	BLUE=$(tput setaf 4)
	MAGENTA=$(tput setaf 5)
	CYAN=$(tput setaf 6)
	WHITE=$(tput setaf 7)

	# Boldfaced colors
	BOLD_RED=$(tput bold)$(tput setaf 1)
	BOLD_GREEN=$(tput bold)$(tput setaf 2)
	BOLD_YELLOW=$(tput bold)$(tput setaf 3)
	BOLD_BLUE=$(tput bold)$(tput setaf 4)
	BOLD_MAGENTA=$(tput bold)$(tput setaf 5)
	BOLD_CYAN=$(tput bold)$(tput setaf 6)
	BOLD_WHITE=$(tput bold)$(tput setaf 7)

	# Simple, normal colors BG FG
	BG_RED_FG_BLACK=$(tput setab 1)$(tput setaf 0)
	BG_GREEN_FG_BLACK=$(tput setab 2)$(tput setaf 0)
	BG_YELLOW_FG_BLACK=$(tput setab 3)$(tput setaf 0)
	BG_BLUE_FG_BLACK=$(tput setab 4)$(tput setaf 0)
	BG_MAGENTA_FG_BLACK=$(tput setab 5)$(tput setaf 0)
	BG_CYAN_FG_BLACK=$(tput setab 6)$(tput setaf 0)
	BG_WHITE_FG_BLACK=$(tput setab 7)$(tput setaf 0)

	# Boldfaced colors BG FG
	BOLD_BG_RED_FG_BLACK=$(tput bold)$(tput setab 1)$(tput setaf 0)
	BOLD_BG_GREEN_FG_BLACK=$(tput bold)$(tput setab 2)$(tput setaf 0)
	BOLD_BG_YELLOW_FG_BLACK=$(tput bold)$(tput setab 3)$(tput setaf 0)
	BOLD_BG_BLUE_FG_BLACK=$(tput bold)$(tput setab 4)$(tput setaf 0)
	BOLD_BG_MAGENTA_FG_BLACK=$(tput bold)$(tput setab 5)$(tput setaf 0)
	BOLD_BG_CYAN_FG_BLACK=$(tput bold)$(tput setab 6)$(tput setaf 0)
	BOLD_BG_WHITE_FG_BLACK=$(tput bold)$(tput setab 7)$(tput setaf 0)

	# Newly set up
	BG_BLACK_FG_GREEN=$(tput setab 0)$(tput setaf 2)
	BG_BLACK_FG_YELLOW=$(tput setab 0)$(tput setaf 3)
	BG_BLACK_FG_WHITE=$(tput setab 0)$(tput setaf 7)
	BG_RED_FG_WHITE=$(tput setab 1)$(tput setaf 7)
	BG_GREEN_FG_WHITE=$(tput setab 2)$(tput setaf 7)
	BG_YELLOW_FG_WHITE=$(tput setab 3)$(tput setaf 7)
	BG_BLUE_FG_WHITE=$(tput setab 4)$(tput setaf 7)
	BG_MAGENTA_FG_WHITE=$(tput setab 5)$(tput setaf 7)

	: '
    echo; echo "TPUT SET OF COLORS"
    echo -e "${UNDERLINE}This is the Test ###${NC}"
    echo -e "${BOLD}This is ${OFF_BOLD}the Test ###${NC}"
    echo -e "${BOLD_TYPE2}This is ${NC}the Test ###"
    echo -e "This is ${NC}the Test ###${NC}"

    echo
    echo -e "Nomal colors"
    echo -e "${RED}This is the Test ###${NC}"
    echo -e "${GREEN}This is the Test ###${NC}"
    echo -e "${YELLOW}This is the Test ###${NC}"
    echo -e "${BLUE}This is the Test ###${NC}"
    echo -e "${MAGENTA}This is the Test ###${NC}"
    echo -e "${CYAN}This is the Test ###${NC}"
    echo -e "${WHITE}This is the Test ###${NC}"

    echo
    echo -e "Boldfaced colors"
    echo -e "${BOLD_RED}This is the Test ###${NC}"
    echo -e "${BOLD_GREEN}This is the Test ###${NC}"
    echo -e "${BOLD_YELLOW}This is the Test ###${NC}"
    echo -e "${BOLD_BLUE}This is the Test ###${NC}"
    echo -e "${BOLD_MAGENTA}This is the Test ###${NC}"
    echo -e "${BOLD_CYAN}This is the Test ###${NC}"
    echo -e "${BOLD_WHITE}This is the Test ###${NC}"

    echo
    echo -e "Simple, normal colors BG FG"
    echo -e "${BG_YELLOW_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BG_GREEN_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BG_CYAN_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BG_MAGENTA_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BG_RED_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BG_BLUE_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BG_WHITE_FG_BLACK}This is the Test ###${NC}"

    echo
    echo -e "Boldfaced colors BG FG"
    echo -e "${BOLD_BG_YELLOW_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BOLD_BG_GREEN_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BOLD_BG_CYAN_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BOLD_BG_MAGENTA_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BOLD_BG_RED_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BOLD_BG_BLUE_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BOLD_BG_WHITE_FG_BLACK}This is the Test ###${NC}"

    echo
    echo -e "${BG_BLACK_FG_YELLOW}This is the Test ###${NC}"
    echo -e "${BG_BLACK_FG_GREEN}This is the Test ###${NC}"
    echo -e "${BG_BLACK_FG_WHITE}This is the Test ###${NC}"
    echo -e "${BG_RED_FG_WHITE}This is the Test ###${NC}"
    echo -e "${BG_GREEN_FG_WHITE}This is the Test ###${NC}"
    echo -e "${BG_YELLOW_FG_WHITE}This is the Test ###${NC}"
    echo -e "${BG_BLUE_FG_WHITE}This is the Test ###${NC}"
    echo -e "${BG_MAGENTA_FG_WHITE}This is the Test ###${NC}"
    echo' ;

    } || {

	
	UNDERLINE="\033[m" # No Color, till
	#I discover how to do it wish bash colors
	
	BOLD="\033[m" # No Color, till
	#I discover how to do it wish bash colors
	
	OFF_BOLD="\033[m" # No Color, till
	#I discover how to do it wish bash colors
	
	BOLD_TYPE2="\033[m" # No Color, till
	#I discover how to do it wish bash colors
	
	NC="\033[m" # No Color

	# Nomal colors
	RED="\033[31m"
	GREEN="\033[32m"
	YELLOW="\033[33m"
	BLUE="\033[34m"
	MAGENTA="\033[35m"
	CYAN="\033[36m"
	WHITE="\033[37m"

	# Boldfaced colors
	BOLD_RED="\033[1;31m"
	BOLD_GREEN="\033[1;32m"
	BOLD_YELLOW="\033[1;33m"
	BOLD_BLUE="\033[1;34m"
	BOLD_MAGENTA="\033[1;35m"
	BOLD_CYAN="\033[1;36m"
	BOLD_WHITE="\033[1;37m"

	# Simple, normal colors BG FG
	BG_RED_FG_BLACK="\033[41m\033[30m"
	BG_GREEN_FG_BLACK="\033[42m\033[30m"
	BG_YELLOW_FG_BLACK="\033[43m\033[30m"
	BG_BLUE_FG_BLACK="\033[44m\033[30m"
	BG_MAGENTA_FG_BLACK="\033[45m\033[30m"
	BG_CYAN_FG_BLACK="\033[46m\033[30m"
	BG_WHITE_FG_BLACK="\033[47m\033[30m"

	# Boldfaced colors BG FG
	BOLD_BG_RED_FG_BLACK="\033[1;41m\033[1;30m"
	BOLD_BG_GREEN_FG_BLACK="\033[1;42m\033[1;30m"
	BOLD_BG_YELLOW_FG_BLACK="\033[1;43m\033[1;30m"
	BOLD_BG_BLUE_FG_BLACK="\033[1;44m\033[1;30m"
	BOLD_BG_MAGENTA_FG_BLACK="\033[1;45m\033[1;30m"
	BOLD_BG_CYAN_FG_BLACK="\033[1;46m\033[1;30m"
	BOLD_BG_WHITE_FG_BLACK="\033[1;47m\033[1;30m"

	# Newly set up
	BG_BLACK_FG_GREEN="\033[40m\033[32m"
	BG_BLACK_FG_YELLOW="\033[40m\033[33m"
	BG_BLACK_FG_WHITE="\033[40m\033[37m"
	BG_RED_FG_WHITE="\033[41m\033[37m"
	BG_GREEN_FG_WHITE="\033[42m\033[37m"
	BG_YELLOW_FG_WHITE="\033[43m\033[37m"
	BG_BLUE_FG_WHITE="\033[44m\033[37m"
	BG_MAGENTA_FG_WHITE="\033[45m\033[37m"

	: '
    echo; echo; echo "BASH SET OF COLORS"
    echo -e "${UNDERLINE}This is the Test ###${NC}"
    echo -e "${BOLD}This is ${OFF_BOLD}the Test ###${NC}"
    echo -e "${BOLD_TYPE2}This is ${NC}the Test ###"
    echo -e "This is ${NC}the Test ###${NC}"

    echo
    echo -e "Nomal colors"
    echo -e "${RED}This is the Test ###${NC}"
    echo -e "${GREEN}This is the Test ###${NC}"
    echo -e "${YELLOW}This is the Test ###${NC}"
    echo -e "${BLUE}This is the Test ###${NC}"
    echo -e "${MAGENTA}This is the Test ###${NC}"
    echo -e "${CYAN}This is the Test ###${NC}"
    echo -e "${WHITE}This is the Test ###${NC}"

    echo
    echo -e "Boldfaced colors"
    echo -e "${BOLD_RED}This is the Test ###${NC}"
    echo -e "${BOLD_GREEN}This is the Test ###${NC}"
    echo -e "${BOLD_YELLOW}This is the Test ###${NC}"
    echo -e "${BOLD_BLUE}This is the Test ###${NC}"
    echo -e "${BOLD_MAGENTA}This is the Test ###${NC}"
    echo -e "${BOLD_CYAN}This is the Test ###${NC}"
    echo -e "${BOLD_WHITE}This is the Test ###${NC}"

    echo
    echo -e "Simple, normal colors BG FG"
    echo -e "${BG_YELLOW_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BG_GREEN_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BG_CYAN_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BG_MAGENTA_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BG_RED_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BG_BLUE_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BG_WHITE_FG_BLACK}This is the Test ###${NC}"

    echo
    echo -e "Boldfaced colors BG FG"
    echo -e "${BOLD_BG_YELLOW_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BOLD_BG_GREEN_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BOLD_BG_CYAN_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BOLD_BG_MAGENTA_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BOLD_BG_RED_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BOLD_BG_BLUE_FG_BLACK}This is the Test ###${NC}"
    echo -e "${BOLD_BG_WHITE_FG_BLACK}This is the Test ###${NC}"

    echo
    echo -e "${BG_BLACK_FG_YELLOW}This is the Test ###${NC}"
    echo -e "${BG_BLACK_FG_GREEN}This is the Test ###${NC}"
    echo -e "${BG_BLACK_FG_WHITE}This is the Test ###${NC}"
    echo -e "${BG_RED_FG_WHITE}This is the Test ###${NC}"
    echo -e "${BG_GREEN_FG_WHITE}This is the Test ###${NC}"
    echo -e "${BG_YELLOW_FG_WHITE}This is the Test ###${NC}"
    echo -e "${BG_BLUE_FG_WHITE}This is the Test ###${NC}"
    echo -e "${BG_MAGENTA_FG_WHITE}This is the Test ###${NC}"
    echo';
    }

}
# Run the function here to get the color values
check_tput_and_set_up_tput_colors_or_bash_colors




##### Set of Functions ######
# This will generate the line
# number of a given ayah as it
# appears in the zekr/tanzil
# Quran/Translation file. This
# line number is later used to
# lookup the translation/tafsir
# of a verse in the above
# mentionned zekr/tanzil file(s)
convert_surahAndAyahNumber_to_tanzil_ayahLineNumber(){
    local surahAndAyahNum="$1"
    case $surahAndAyahNum in
	001001 )
	    ayahLineNumber="1"
	    ;;
	001002 )
	    ayahLineNumber=2
	    ;;
	001003 )
	    ayahLineNumber=3
	    ;;
	001004 )
	    ayahLineNumber=4
	    ;;
	001005 )
	    ayahLineNumber=5
	    ;;
	001006 )
	    ayahLineNumber=6
	    ;;
	001007 )
	    ayahLineNumber=7
	    ;;
	002001 )
	    ayahLineNumber=8
	    ;;
	002002 )
	    ayahLineNumber=9
	    ;;
	002003 )
	    ayahLineNumber=10
	    ;;
	002004 )
	    ayahLineNumber=11
	    ;;
	002005 )
	    ayahLineNumber=12
	    ;;
	002006 )
	    ayahLineNumber=13
	    ;;
	002007 )
	    ayahLineNumber=14
	    ;;
	002008 )
	    ayahLineNumber=15
	    ;;
	002009 )
	    ayahLineNumber=16
	    ;;
	002010 )
	    ayahLineNumber=17
	    ;;
	002011 )
	    ayahLineNumber=18
	    ;;
	002012 )
	    ayahLineNumber=19
	    ;;
	002013 )
	    ayahLineNumber=20
	    ;;
	002014 )
	    ayahLineNumber=21
	    ;;
	002015 )
	    ayahLineNumber=22
	    ;;
	002016 )
	    ayahLineNumber=23
	    ;;
	002017 )
	    ayahLineNumber=24
	    ;;
	002018 )
	    ayahLineNumber=25
	    ;;
	002019 )
	    ayahLineNumber=26
	    ;;
	002020 )
	    ayahLineNumber=27
	    ;;
	002021 )
	    ayahLineNumber=28
	    ;;
	002022 )
	    ayahLineNumber=29
	    ;;
	002023 )
	    ayahLineNumber=30
	    ;;
	002024 )
	    ayahLineNumber=31
	    ;;
	002025 )
	    ayahLineNumber=32
	    ;;
	002026 )
	    ayahLineNumber=33
	    ;;
	002027 )
	    ayahLineNumber=34
	    ;;
	002028 )
	    ayahLineNumber=35
	    ;;
	002029 )
	    ayahLineNumber=36
	    ;;
	002030 )
	    ayahLineNumber=37
	    ;;
	002031 )
	    ayahLineNumber=38
	    ;;
	002032 )
	    ayahLineNumber=39
	    ;;
	002033 )
	    ayahLineNumber=40
	    ;;
	002034 )
	    ayahLineNumber=41
	    ;;
	002035 )
	    ayahLineNumber=42
	    ;;
	002036 )
	    ayahLineNumber=43
	    ;;
	002037 )
	    ayahLineNumber=44
	    ;;
	002038 )
	    ayahLineNumber=45
	    ;;
	002039 )
	    ayahLineNumber=46
	    ;;
	002040 )
	    ayahLineNumber=47
	    ;;
	002041 )
	    ayahLineNumber=48
	    ;;
	002042 )
	    ayahLineNumber=49
	    ;;
	002043 )
	    ayahLineNumber=50
	    ;;
	002044 )
	    ayahLineNumber=51
	    ;;
	002045 )
	    ayahLineNumber=52
	    ;;
	002046 )
	    ayahLineNumber=53
	    ;;
	002047 )
	    ayahLineNumber=54
	    ;;
	002048 )
	    ayahLineNumber=55
	    ;;
	002049 )
	    ayahLineNumber=56
	    ;;
	002050 )
	    ayahLineNumber=57
	    ;;
	002051 )
	    ayahLineNumber=58
	    ;;
	002052 )
	    ayahLineNumber=59
	    ;;
	002053 )
	    ayahLineNumber=60
	    ;;
	002054 )
	    ayahLineNumber=61
	    ;;
	002055 )
	    ayahLineNumber=62
	    ;;
	002056 )
	    ayahLineNumber=63
	    ;;
	002057 )
	    ayahLineNumber=64
	    ;;
	002058 )
	    ayahLineNumber=65
	    ;;
	002059 )
	    ayahLineNumber=66
	    ;;
	002060 )
	    ayahLineNumber=67
	    ;;
	002061 )
	    ayahLineNumber=68
	    ;;
	002062 )
	    ayahLineNumber=69
	    ;;
	002063 )
	    ayahLineNumber=70
	    ;;
	002064 )
	    ayahLineNumber=71
	    ;;
	002065 )
	    ayahLineNumber=72
	    ;;
	002066 )
	    ayahLineNumber=73
	    ;;
	002067 )
	    ayahLineNumber=74
	    ;;
	002068 )
	    ayahLineNumber=75
	    ;;
	002069 )
	    ayahLineNumber=76
	    ;;
	002070 )
	    ayahLineNumber=77
	    ;;
	002071 )
	    ayahLineNumber=78
	    ;;
	002072 )
	    ayahLineNumber=79
	    ;;
	002073 )
	    ayahLineNumber=80
	    ;;
	002074 )
	    ayahLineNumber=81
	    ;;
	002075 )
	    ayahLineNumber=82
	    ;;
	002076 )
	    ayahLineNumber=83
	    ;;
	002077 )
	    ayahLineNumber=84
	    ;;
	002078 )
	    ayahLineNumber=85
	    ;;
	002079 )
	    ayahLineNumber=86
	    ;;
	002080 )
	    ayahLineNumber=87
	    ;;
	002081 )
	    ayahLineNumber=88
	    ;;
	002082 )
	    ayahLineNumber=89
	    ;;
	002083 )
	    ayahLineNumber=90
	    ;;
	002084 )
	    ayahLineNumber=91
	    ;;
	002085 )
	    ayahLineNumber=92
	    ;;
	002086 )
	    ayahLineNumber=93
	    ;;
	002087 )
	    ayahLineNumber=94
	    ;;
	002088 )
	    ayahLineNumber=95
	    ;;
	002089 )
	    ayahLineNumber=96
	    ;;
	002090 )
	    ayahLineNumber=97
	    ;;
	002091 )
	    ayahLineNumber=98
	    ;;
	002092 )
	    ayahLineNumber=99
	    ;;
	002093 )
	    ayahLineNumber=100
	    ;;
	002094 )
	    ayahLineNumber=101
	    ;;
	002095 )
	    ayahLineNumber=102
	    ;;
	002096 )
	    ayahLineNumber=103
	    ;;
	002097 )
	    ayahLineNumber=104
	    ;;
	002098 )
	    ayahLineNumber=105
	    ;;
	002099 )
	    ayahLineNumber=106
	    ;;
	002100 )
	    ayahLineNumber=107
	    ;;
	002101 )
	    ayahLineNumber=108
	    ;;
	002102 )
	    ayahLineNumber=109
	    ;;
	002103 )
	    ayahLineNumber=110
	    ;;
	002104 )
	    ayahLineNumber=111
	    ;;
	002105 )
	    ayahLineNumber=112
	    ;;
	002106 )
	    ayahLineNumber=113
	    ;;
	002107 )
	    ayahLineNumber=114
	    ;;
	002108 )
	    ayahLineNumber=115
	    ;;
	002109 )
	    ayahLineNumber=116
	    ;;
	002110 )
	    ayahLineNumber=117
	    ;;
	002111 )
	    ayahLineNumber=118
	    ;;
	002112 )
	    ayahLineNumber=119
	    ;;
	002113 )
	    ayahLineNumber=120
	    ;;
	002114 )
	    ayahLineNumber=121
	    ;;
	002115 )
	    ayahLineNumber=122
	    ;;
	002116 )
	    ayahLineNumber=123
	    ;;
	002117 )
	    ayahLineNumber=124
	    ;;
	002118 )
	    ayahLineNumber=125
	    ;;
	002119 )
	    ayahLineNumber=126
	    ;;
	002120 )
	    ayahLineNumber=127
	    ;;
	002121 )
	    ayahLineNumber=128
	    ;;
	002122 )
	    ayahLineNumber=129
	    ;;
	002123 )
	    ayahLineNumber=130
	    ;;
	002124 )
	    ayahLineNumber=131
	    ;;
	002125 )
	    ayahLineNumber=132
	    ;;
	002126 )
	    ayahLineNumber=133
	    ;;
	002127 )
	    ayahLineNumber=134
	    ;;
	002128 )
	    ayahLineNumber=135
	    ;;
	002129 )
	    ayahLineNumber=136
	    ;;
	002130 )
	    ayahLineNumber=137
	    ;;
	002131 )
	    ayahLineNumber=138
	    ;;
	002132 )
	    ayahLineNumber=139
	    ;;
	002133 )
	    ayahLineNumber=140
	    ;;
	002134 )
	    ayahLineNumber=141
	    ;;
	002135 )
	    ayahLineNumber=142
	    ;;
	002136 )
	    ayahLineNumber=143
	    ;;
	002137 )
	    ayahLineNumber=144
	    ;;
	002138 )
	    ayahLineNumber=145
	    ;;
	002139 )
	    ayahLineNumber=146
	    ;;
	002140 )
	    ayahLineNumber=147
	    ;;
	002141 )
	    ayahLineNumber=148
	    ;;
	002142 )
	    ayahLineNumber=149
	    ;;
	002143 )
	    ayahLineNumber=150
	    ;;
	002144 )
	    ayahLineNumber=151
	    ;;
	002145 )
	    ayahLineNumber=152
	    ;;
	002146 )
	    ayahLineNumber=153
	    ;;
	002147 )
	    ayahLineNumber=154
	    ;;
	002148 )
	    ayahLineNumber=155
	    ;;
	002149 )
	    ayahLineNumber=156
	    ;;
	002150 )
	    ayahLineNumber=157
	    ;;
	002151 )
	    ayahLineNumber=158
	    ;;
	002152 )
	    ayahLineNumber=159
	    ;;
	002153 )
	    ayahLineNumber=160
	    ;;
	002154 )
	    ayahLineNumber=161
	    ;;
	002155 )
	    ayahLineNumber=162
	    ;;
	002156 )
	    ayahLineNumber=163
	    ;;
	002157 )
	    ayahLineNumber=164
	    ;;
	002158 )
	    ayahLineNumber=165
	    ;;
	002159 )
	    ayahLineNumber=166
	    ;;
	002160 )
	    ayahLineNumber=167
	    ;;
	002161 )
	    ayahLineNumber=168
	    ;;
	002162 )
	    ayahLineNumber=169
	    ;;
	002163 )
	    ayahLineNumber=170
	    ;;
	002164 )
	    ayahLineNumber=171
	    ;;
	002165 )
	    ayahLineNumber=172
	    ;;
	002166 )
	    ayahLineNumber=173
	    ;;
	002167 )
	    ayahLineNumber=174
	    ;;
	002168 )
	    ayahLineNumber=175
	    ;;
	002169 )
	    ayahLineNumber=176
	    ;;
	002170 )
	    ayahLineNumber=177
	    ;;
	002171 )
	    ayahLineNumber=178
	    ;;
	002172 )
	    ayahLineNumber=179
	    ;;
	002173 )
	    ayahLineNumber=180
	    ;;
	002174 )
	    ayahLineNumber=181
	    ;;
	002175 )
	    ayahLineNumber=182
	    ;;
	002176 )
	    ayahLineNumber=183
	    ;;
	002177 )
	    ayahLineNumber=184
	    ;;
	002178 )
	    ayahLineNumber=185
	    ;;
	002179 )
	    ayahLineNumber=186
	    ;;
	002180 )
	    ayahLineNumber=187
	    ;;
	002181 )
	    ayahLineNumber=188
	    ;;
	002182 )
	    ayahLineNumber=189
	    ;;
	002183 )
	    ayahLineNumber=190
	    ;;
	002184 )
	    ayahLineNumber=191
	    ;;
	002185 )
	    ayahLineNumber=192
	    ;;
	002186 )
	    ayahLineNumber=193
	    ;;
	002187 )
	    ayahLineNumber=194
	    ;;
	002188 )
	    ayahLineNumber=195
	    ;;
	002189 )
	    ayahLineNumber=196
	    ;;
	002190 )
	    ayahLineNumber=197
	    ;;
	002191 )
	    ayahLineNumber=198
	    ;;
	002192 )
	    ayahLineNumber=199
	    ;;
	002193 )
	    ayahLineNumber=200
	    ;;
	002194 )
	    ayahLineNumber=201
	    ;;
	002195 )
	    ayahLineNumber=202
	    ;;
	002196 )
	    ayahLineNumber=203
	    ;;
	002197 )
	    ayahLineNumber=204
	    ;;
	002198 )
	    ayahLineNumber=205
	    ;;
	002199 )
	    ayahLineNumber=206
	    ;;
	002200 )
	    ayahLineNumber=207
	    ;;
	002201 )
	    ayahLineNumber=208
	    ;;
	002202 )
	    ayahLineNumber=209
	    ;;
	002203 )
	    ayahLineNumber=210
	    ;;
	002204 )
	    ayahLineNumber=211
	    ;;
	002205 )
	    ayahLineNumber=212
	    ;;
	002206 )
	    ayahLineNumber=213
	    ;;
	002207 )
	    ayahLineNumber=214
	    ;;
	002208 )
	    ayahLineNumber=215
	    ;;
	002209 )
	    ayahLineNumber=216
	    ;;
	002210 )
	    ayahLineNumber=217
	    ;;
	002211 )
	    ayahLineNumber=218
	    ;;
	002212 )
	    ayahLineNumber=219
	    ;;
	002213 )
	    ayahLineNumber=220
	    ;;
	002214 )
	    ayahLineNumber=221
	    ;;
	002215 )
	    ayahLineNumber=222
	    ;;
	002216 )
	    ayahLineNumber=223
	    ;;
	002217 )
	    ayahLineNumber=224
	    ;;
	002218 )
	    ayahLineNumber=225
	    ;;
	002219 )
	    ayahLineNumber=226
	    ;;
	002220 )
	    ayahLineNumber=227
	    ;;
	002221 )
	    ayahLineNumber=228
	    ;;
	002222 )
	    ayahLineNumber=229
	    ;;
	002223 )
	    ayahLineNumber=230
	    ;;
	002224 )
	    ayahLineNumber=231
	    ;;
	002225 )
	    ayahLineNumber=232
	    ;;
	002226 )
	    ayahLineNumber=233
	    ;;
	002227 )
	    ayahLineNumber=234
	    ;;
	002228 )
	    ayahLineNumber=235
	    ;;
	002229 )
	    ayahLineNumber=236
	    ;;
	002230 )
	    ayahLineNumber=237
	    ;;
	002231 )
	    ayahLineNumber=238
	    ;;
	002232 )
	    ayahLineNumber=239
	    ;;
	002233 )
	    ayahLineNumber=240
	    ;;
	002234 )
	    ayahLineNumber=241
	    ;;
	002235 )
	    ayahLineNumber=242
	    ;;
	002236 )
	    ayahLineNumber=243
	    ;;
	002237 )
	    ayahLineNumber=244
	    ;;
	002238 )
	    ayahLineNumber=245
	    ;;
	002239 )
	    ayahLineNumber=246
	    ;;
	002240 )
	    ayahLineNumber=247
	    ;;
	002241 )
	    ayahLineNumber=248
	    ;;
	002242 )
	    ayahLineNumber=249
	    ;;
	002243 )
	    ayahLineNumber=250
	    ;;
	002244 )
	    ayahLineNumber=251
	    ;;
	002245 )
	    ayahLineNumber=252
	    ;;
	002246 )
	    ayahLineNumber=253
	    ;;
	002247 )
	    ayahLineNumber=254
	    ;;
	002248 )
	    ayahLineNumber=255
	    ;;
	002249 )
	    ayahLineNumber=256
	    ;;
	002250 )
	    ayahLineNumber=257
	    ;;
	002251 )
	    ayahLineNumber=258
	    ;;
	002252 )
	    ayahLineNumber=259
	    ;;
	002253 )
	    ayahLineNumber=260
	    ;;
	002254 )
	    ayahLineNumber=261
	    ;;
	002255 )
	    ayahLineNumber=262
	    ;;
	002256 )
	    ayahLineNumber=263
	    ;;
	002257 )
	    ayahLineNumber=264
	    ;;
	002258 )
	    ayahLineNumber=265
	    ;;
	002259 )
	    ayahLineNumber=266
	    ;;
	002260 )
	    ayahLineNumber=267
	    ;;
	002261 )
	    ayahLineNumber=268
	    ;;
	002262 )
	    ayahLineNumber=269
	    ;;
	002263 )
	    ayahLineNumber=270
	    ;;
	002264 )
	    ayahLineNumber=271
	    ;;
	002265 )
	    ayahLineNumber=272
	    ;;
	002266 )
	    ayahLineNumber=273
	    ;;
	002267 )
	    ayahLineNumber=274
	    ;;
	002268 )
	    ayahLineNumber=275
	    ;;
	002269 )
	    ayahLineNumber=276
	    ;;
	002270 )
	    ayahLineNumber=277
	    ;;
	002271 )
	    ayahLineNumber=278
	    ;;
	002272 )
	    ayahLineNumber=279
	    ;;
	002273 )
	    ayahLineNumber=280
	    ;;
	002274 )
	    ayahLineNumber=281
	    ;;
	002275 )
	    ayahLineNumber=282
	    ;;
	002276 )
	    ayahLineNumber=283
	    ;;
	002277 )
	    ayahLineNumber=284
	    ;;
	002278 )
	    ayahLineNumber=285
	    ;;
	002279 )
	    ayahLineNumber=286
	    ;;
	002280 )
	    ayahLineNumber=287
	    ;;
	002281 )
	    ayahLineNumber=288
	    ;;
	002282 )
	    ayahLineNumber=289
	    ;;
	002283 )
	    ayahLineNumber=290
	    ;;
	002284 )
	    ayahLineNumber=291
	    ;;
	002285 )
	    ayahLineNumber=292
	    ;;
	002286 )
	    ayahLineNumber=293
	    ;;
	003001 )
	    ayahLineNumber=294
	    ;;
	003002 )
	    ayahLineNumber=295
	    ;;
	003003 )
	    ayahLineNumber=296
	    ;;
	003004 )
	    ayahLineNumber=297
	    ;;
	003005 )
	    ayahLineNumber=298
	    ;;
	003006 )
	    ayahLineNumber=299
	    ;;
	003007 )
	    ayahLineNumber=300
	    ;;
	003008 )
	    ayahLineNumber=301
	    ;;
	003009 )
	    ayahLineNumber=302
	    ;;
	003010 )
	    ayahLineNumber=303
	    ;;
	003011 )
	    ayahLineNumber=304
	    ;;
	003012 )
	    ayahLineNumber=305
	    ;;
	003013 )
	    ayahLineNumber=306
	    ;;
	003014 )
	    ayahLineNumber=307
	    ;;
	003015 )
	    ayahLineNumber=308
	    ;;
	003016 )
	    ayahLineNumber=309
	    ;;
	003017 )
	    ayahLineNumber=310
	    ;;
	003018 )
	    ayahLineNumber=311
	    ;;
	003019 )
	    ayahLineNumber=312
	    ;;
	003020 )
	    ayahLineNumber=313
	    ;;
	003021 )
	    ayahLineNumber=314
	    ;;
	003022 )
	    ayahLineNumber=315
	    ;;
	003023 )
	    ayahLineNumber=316
	    ;;
	003024 )
	    ayahLineNumber=317
	    ;;
	003025 )
	    ayahLineNumber=318
	    ;;
	003026 )
	    ayahLineNumber=319
	    ;;
	003027 )
	    ayahLineNumber=320
	    ;;
	003028 )
	    ayahLineNumber=321
	    ;;
	003029 )
	    ayahLineNumber=322
	    ;;
	003030 )
	    ayahLineNumber=323
	    ;;
	003031 )
	    ayahLineNumber=324
	    ;;
	003032 )
	    ayahLineNumber=325
	    ;;
	003033 )
	    ayahLineNumber=326
	    ;;
	003034 )
	    ayahLineNumber=327
	    ;;
	003035 )
	    ayahLineNumber=328
	    ;;
	003036 )
	    ayahLineNumber=329
	    ;;
	003037 )
	    ayahLineNumber=330
	    ;;
	003038 )
	    ayahLineNumber=331
	    ;;
	003039 )
	    ayahLineNumber=332
	    ;;
	003040 )
	    ayahLineNumber=333
	    ;;
	003041 )
	    ayahLineNumber=334
	    ;;
	003042 )
	    ayahLineNumber=335
	    ;;
	003043 )
	    ayahLineNumber=336
	    ;;
	003044 )
	    ayahLineNumber=337
	    ;;
	003045 )
	    ayahLineNumber=338
	    ;;
	003046 )
	    ayahLineNumber=339
	    ;;
	003047 )
	    ayahLineNumber=340
	    ;;
	003048 )
	    ayahLineNumber=341
	    ;;
	003049 )
	    ayahLineNumber=342
	    ;;
	003050 )
	    ayahLineNumber=343
	    ;;
	003051 )
	    ayahLineNumber=344
	    ;;
	003052 )
	    ayahLineNumber=345
	    ;;
	003053 )
	    ayahLineNumber=346
	    ;;
	003054 )
	    ayahLineNumber=347
	    ;;
	003055 )
	    ayahLineNumber=348
	    ;;
	003056 )
	    ayahLineNumber=349
	    ;;
	003057 )
	    ayahLineNumber=350
	    ;;
	003058 )
	    ayahLineNumber=351
	    ;;
	003059 )
	    ayahLineNumber=352
	    ;;
	003060 )
	    ayahLineNumber=353
	    ;;
	003061 )
	    ayahLineNumber=354
	    ;;
	003062 )
	    ayahLineNumber=355
	    ;;
	003063 )
	    ayahLineNumber=356
	    ;;
	003064 )
	    ayahLineNumber=357
	    ;;
	003065 )
	    ayahLineNumber=358
	    ;;
	003066 )
	    ayahLineNumber=359
	    ;;
	003067 )
	    ayahLineNumber=360
	    ;;
	003068 )
	    ayahLineNumber=361
	    ;;
	003069 )
	    ayahLineNumber=362
	    ;;
	003070 )
	    ayahLineNumber=363
	    ;;
	003071 )
	    ayahLineNumber=364
	    ;;
	003072 )
	    ayahLineNumber=365
	    ;;
	003073 )
	    ayahLineNumber=366
	    ;;
	003074 )
	    ayahLineNumber=367
	    ;;
	003075 )
	    ayahLineNumber=368
	    ;;
	003076 )
	    ayahLineNumber=369
	    ;;
	003077 )
	    ayahLineNumber=370
	    ;;
	003078 )
	    ayahLineNumber=371
	    ;;
	003079 )
	    ayahLineNumber=372
	    ;;
	003080 )
	    ayahLineNumber=373
	    ;;
	003081 )
	    ayahLineNumber=374
	    ;;
	003082 )
	    ayahLineNumber=375
	    ;;
	003083 )
	    ayahLineNumber=376
	    ;;
	003084 )
	    ayahLineNumber=377
	    ;;
	003085 )
	    ayahLineNumber=378
	    ;;
	003086 )
	    ayahLineNumber=379
	    ;;
	003087 )
	    ayahLineNumber=380
	    ;;
	003088 )
	    ayahLineNumber=381
	    ;;
	003089 )
	    ayahLineNumber=382
	    ;;
	003090 )
	    ayahLineNumber=383
	    ;;
	003091 )
	    ayahLineNumber=384
	    ;;
	003092 )
	    ayahLineNumber=385
	    ;;
	003093 )
	    ayahLineNumber=386
	    ;;
	003094 )
	    ayahLineNumber=387
	    ;;
	003095 )
	    ayahLineNumber=388
	    ;;
	003096 )
	    ayahLineNumber=389
	    ;;
	003097 )
	    ayahLineNumber=390
	    ;;
	003098 )
	    ayahLineNumber=391
	    ;;
	003099 )
	    ayahLineNumber=392
	    ;;
	003100 )
	    ayahLineNumber=393
	    ;;
	003101 )
	    ayahLineNumber=394
	    ;;
	003102 )
	    ayahLineNumber=395
	    ;;
	003103 )
	    ayahLineNumber=396
	    ;;
	003104 )
	    ayahLineNumber=397
	    ;;
	003105 )
	    ayahLineNumber=398
	    ;;
	003106 )
	    ayahLineNumber=399
	    ;;
	003107 )
	    ayahLineNumber=400
	    ;;
	003108 )
	    ayahLineNumber=401
	    ;;
	003109 )
	    ayahLineNumber=402
	    ;;
	003110 )
	    ayahLineNumber=403
	    ;;
	003111 )
	    ayahLineNumber=404
	    ;;
	003112 )
	    ayahLineNumber=405
	    ;;
	003113 )
	    ayahLineNumber=406
	    ;;
	003114 )
	    ayahLineNumber=407
	    ;;
	003115 )
	    ayahLineNumber=408
	    ;;
	003116 )
	    ayahLineNumber=409
	    ;;
	003117 )
	    ayahLineNumber=410
	    ;;
	003118 )
	    ayahLineNumber=411
	    ;;
	003119 )
	    ayahLineNumber=412
	    ;;
	003120 )
	    ayahLineNumber=413
	    ;;
	003121 )
	    ayahLineNumber=414
	    ;;
	003122 )
	    ayahLineNumber=415
	    ;;
	003123 )
	    ayahLineNumber=416
	    ;;
	003124 )
	    ayahLineNumber=417
	    ;;
	003125 )
	    ayahLineNumber=418
	    ;;
	003126 )
	    ayahLineNumber=419
	    ;;
	003127 )
	    ayahLineNumber=420
	    ;;
	003128 )
	    ayahLineNumber=421
	    ;;
	003129 )
	    ayahLineNumber=422
	    ;;
	003130 )
	    ayahLineNumber=423
	    ;;
	003131 )
	    ayahLineNumber=424
	    ;;
	003132 )
	    ayahLineNumber=425
	    ;;
	003133 )
	    ayahLineNumber=426
	    ;;
	003134 )
	    ayahLineNumber=427
	    ;;
	003135 )
	    ayahLineNumber=428
	    ;;
	003136 )
	    ayahLineNumber=429
	    ;;
	003137 )
	    ayahLineNumber=430
	    ;;
	003138 )
	    ayahLineNumber=431
	    ;;
	003139 )
	    ayahLineNumber=432
	    ;;
	003140 )
	    ayahLineNumber=433
	    ;;
	003141 )
	    ayahLineNumber=434
	    ;;
	003142 )
	    ayahLineNumber=435
	    ;;
	003143 )
	    ayahLineNumber=436
	    ;;
	003144 )
	    ayahLineNumber=437
	    ;;
	003145 )
	    ayahLineNumber=438
	    ;;
	003146 )
	    ayahLineNumber=439
	    ;;
	003147 )
	    ayahLineNumber=440
	    ;;
	003148 )
	    ayahLineNumber=441
	    ;;
	003149 )
	    ayahLineNumber=442
	    ;;
	003150 )
	    ayahLineNumber=443
	    ;;
	003151 )
	    ayahLineNumber=444
	    ;;
	003152 )
	    ayahLineNumber=445
	    ;;
	003153 )
	    ayahLineNumber=446
	    ;;
	003154 )
	    ayahLineNumber=447
	    ;;
	003155 )
	    ayahLineNumber=448
	    ;;
	003156 )
	    ayahLineNumber=449
	    ;;
	003157 )
	    ayahLineNumber=450
	    ;;
	003158 )
	    ayahLineNumber=451
	    ;;
	003159 )
	    ayahLineNumber=452
	    ;;
	003160 )
	    ayahLineNumber=453
	    ;;
	003161 )
	    ayahLineNumber=454
	    ;;
	003162 )
	    ayahLineNumber=455
	    ;;
	003163 )
	    ayahLineNumber=456
	    ;;
	003164 )
	    ayahLineNumber=457
	    ;;
	003165 )
	    ayahLineNumber=458
	    ;;
	003166 )
	    ayahLineNumber=459
	    ;;
	003167 )
	    ayahLineNumber=460
	    ;;
	003168 )
	    ayahLineNumber=461
	    ;;
	003169 )
	    ayahLineNumber=462
	    ;;
	003170 )
	    ayahLineNumber=463
	    ;;
	003171 )
	    ayahLineNumber=464
	    ;;
	003172 )
	    ayahLineNumber=465
	    ;;
	003173 )
	    ayahLineNumber=466
	    ;;
	003174 )
	    ayahLineNumber=467
	    ;;
	003175 )
	    ayahLineNumber=468
	    ;;
	003176 )
	    ayahLineNumber=469
	    ;;
	003177 )
	    ayahLineNumber=470
	    ;;
	003178 )
	    ayahLineNumber=471
	    ;;
	003179 )
	    ayahLineNumber=472
	    ;;
	003180 )
	    ayahLineNumber=473
	    ;;
	003181 )
	    ayahLineNumber=474
	    ;;
	003182 )
	    ayahLineNumber=475
	    ;;
	003183 )
	    ayahLineNumber=476
	    ;;
	003184 )
	    ayahLineNumber=477
	    ;;
	003185 )
	    ayahLineNumber=478
	    ;;
	003186 )
	    ayahLineNumber=479
	    ;;
	003187 )
	    ayahLineNumber=480
	    ;;
	003188 )
	    ayahLineNumber=481
	    ;;
	003189 )
	    ayahLineNumber=482
	    ;;
	003190 )
	    ayahLineNumber=483
	    ;;
	003191 )
	    ayahLineNumber=484
	    ;;
	003192 )
	    ayahLineNumber=485
	    ;;
	003193 )
	    ayahLineNumber=486
	    ;;
	003194 )
	    ayahLineNumber=487
	    ;;
	003195 )
	    ayahLineNumber=488
	    ;;
	003196 )
	    ayahLineNumber=489
	    ;;
	003197 )
	    ayahLineNumber=490
	    ;;
	003198 )
	    ayahLineNumber=491
	    ;;
	003199 )
	    ayahLineNumber=492
	    ;;
	003200 )
	    ayahLineNumber=493
	    ;;
	004001 )
	    ayahLineNumber=494
	    ;;
	004002 )
	    ayahLineNumber=495
	    ;;
	004003 )
	    ayahLineNumber=496
	    ;;
	004004 )
	    ayahLineNumber=497
	    ;;
	004005 )
	    ayahLineNumber=498
	    ;;
	004006 )
	    ayahLineNumber=499
	    ;;
	004007 )
	    ayahLineNumber=500
	    ;;
	004008 )
	    ayahLineNumber=501
	    ;;
	004009 )
	    ayahLineNumber=502
	    ;;
	004010 )
	    ayahLineNumber=503
	    ;;
	004011 )
	    ayahLineNumber=504
	    ;;
	004012 )
	    ayahLineNumber=505
	    ;;
	004013 )
	    ayahLineNumber=506
	    ;;
	004014 )
	    ayahLineNumber=507
	    ;;
	004015 )
	    ayahLineNumber=508
	    ;;
	004016 )
	    ayahLineNumber=509
	    ;;
	004017 )
	    ayahLineNumber=510
	    ;;
	004018 )
	    ayahLineNumber=511
	    ;;
	004019 )
	    ayahLineNumber=512
	    ;;
	004020 )
	    ayahLineNumber=513
	    ;;
	004021 )
	    ayahLineNumber=514
	    ;;
	004022 )
	    ayahLineNumber=515
	    ;;
	004023 )
	    ayahLineNumber=516
	    ;;
	004024 )
	    ayahLineNumber=517
	    ;;
	004025 )
	    ayahLineNumber=518
	    ;;
	004026 )
	    ayahLineNumber=519
	    ;;
	004027 )
	    ayahLineNumber=520
	    ;;
	004028 )
	    ayahLineNumber=521
	    ;;
	004029 )
	    ayahLineNumber=522
	    ;;
	004030 )
	    ayahLineNumber=523
	    ;;
	004031 )
	    ayahLineNumber=524
	    ;;
	004032 )
	    ayahLineNumber=525
	    ;;
	004033 )
	    ayahLineNumber=526
	    ;;
	004034 )
	    ayahLineNumber=527
	    ;;
	004035 )
	    ayahLineNumber=528
	    ;;
	004036 )
	    ayahLineNumber=529
	    ;;
	004037 )
	    ayahLineNumber=530
	    ;;
	004038 )
	    ayahLineNumber=531
	    ;;
	004039 )
	    ayahLineNumber=532
	    ;;
	004040 )
	    ayahLineNumber=533
	    ;;
	004041 )
	    ayahLineNumber=534
	    ;;
	004042 )
	    ayahLineNumber=535
	    ;;
	004043 )
	    ayahLineNumber=536
	    ;;
	004044 )
	    ayahLineNumber=537
	    ;;
	004045 )
	    ayahLineNumber=538
	    ;;
	004046 )
	    ayahLineNumber=539
	    ;;
	004047 )
	    ayahLineNumber=540
	    ;;
	004048 )
	    ayahLineNumber=541
	    ;;
	004049 )
	    ayahLineNumber=542
	    ;;
	004050 )
	    ayahLineNumber=543
	    ;;
	004051 )
	    ayahLineNumber=544
	    ;;
	004052 )
	    ayahLineNumber=545
	    ;;
	004053 )
	    ayahLineNumber=546
	    ;;
	004054 )
	    ayahLineNumber=547
	    ;;
	004055 )
	    ayahLineNumber=548
	    ;;
	004056 )
	    ayahLineNumber=549
	    ;;
	004057 )
	    ayahLineNumber=550
	    ;;
	004058 )
	    ayahLineNumber=551
	    ;;
	004059 )
	    ayahLineNumber=552
	    ;;
	004060 )
	    ayahLineNumber=553
	    ;;
	004061 )
	    ayahLineNumber=554
	    ;;
	004062 )
	    ayahLineNumber=555
	    ;;
	004063 )
	    ayahLineNumber=556
	    ;;
	004064 )
	    ayahLineNumber=557
	    ;;
	004065 )
	    ayahLineNumber=558
	    ;;
	004066 )
	    ayahLineNumber=559
	    ;;
	004067 )
	    ayahLineNumber=560
	    ;;
	004068 )
	    ayahLineNumber=561
	    ;;
	004069 )
	    ayahLineNumber=562
	    ;;
	004070 )
	    ayahLineNumber=563
	    ;;
	004071 )
	    ayahLineNumber=564
	    ;;
	004072 )
	    ayahLineNumber=565
	    ;;
	004073 )
	    ayahLineNumber=566
	    ;;
	004074 )
	    ayahLineNumber=567
	    ;;
	004075 )
	    ayahLineNumber=568
	    ;;
	004076 )
	    ayahLineNumber=569
	    ;;
	004077 )
	    ayahLineNumber=570
	    ;;
	004078 )
	    ayahLineNumber=571
	    ;;
	004079 )
	    ayahLineNumber=572
	    ;;
	004080 )
	    ayahLineNumber=573
	    ;;
	004081 )
	    ayahLineNumber=574
	    ;;
	004082 )
	    ayahLineNumber=575
	    ;;
	004083 )
	    ayahLineNumber=576
	    ;;
	004084 )
	    ayahLineNumber=577
	    ;;
	004085 )
	    ayahLineNumber=578
	    ;;
	004086 )
	    ayahLineNumber=579
	    ;;
	004087 )
	    ayahLineNumber=580
	    ;;
	004088 )
	    ayahLineNumber=581
	    ;;
	004089 )
	    ayahLineNumber=582
	    ;;
	004090 )
	    ayahLineNumber=583
	    ;;
	004091 )
	    ayahLineNumber=584
	    ;;
	004092 )
	    ayahLineNumber=585
	    ;;
	004093 )
	    ayahLineNumber=586
	    ;;
	004094 )
	    ayahLineNumber=587
	    ;;
	004095 )
	    ayahLineNumber=588
	    ;;
	004096 )
	    ayahLineNumber=589
	    ;;
	004097 )
	    ayahLineNumber=590
	    ;;
	004098 )
	    ayahLineNumber=591
	    ;;
	004099 )
	    ayahLineNumber=592
	    ;;
	004100 )
	    ayahLineNumber=593
	    ;;
	004101 )
	    ayahLineNumber=594
	    ;;
	004102 )
	    ayahLineNumber=595
	    ;;
	004103 )
	    ayahLineNumber=596
	    ;;
	004104 )
	    ayahLineNumber=597
	    ;;
	004105 )
	    ayahLineNumber=598
	    ;;
	004106 )
	    ayahLineNumber=599
	    ;;
	004107 )
	    ayahLineNumber=600
	    ;;
	004108 )
	    ayahLineNumber=601
	    ;;
	004109 )
	    ayahLineNumber=602
	    ;;
	004110 )
	    ayahLineNumber=603
	    ;;
	004111 )
	    ayahLineNumber=604
	    ;;
	004112 )
	    ayahLineNumber=605
	    ;;
	004113 )
	    ayahLineNumber=606
	    ;;
	004114 )
	    ayahLineNumber=607
	    ;;
	004115 )
	    ayahLineNumber=608
	    ;;
	004116 )
	    ayahLineNumber=609
	    ;;
	004117 )
	    ayahLineNumber=610
	    ;;
	004118 )
	    ayahLineNumber=611
	    ;;
	004119 )
	    ayahLineNumber=612
	    ;;
	004120 )
	    ayahLineNumber=613
	    ;;
	004121 )
	    ayahLineNumber=614
	    ;;
	004122 )
	    ayahLineNumber=615
	    ;;
	004123 )
	    ayahLineNumber=616
	    ;;
	004124 )
	    ayahLineNumber=617
	    ;;
	004125 )
	    ayahLineNumber=618
	    ;;
	004126 )
	    ayahLineNumber=619
	    ;;
	004127 )
	    ayahLineNumber=620
	    ;;
	004128 )
	    ayahLineNumber=621
	    ;;
	004129 )
	    ayahLineNumber=622
	    ;;
	004130 )
	    ayahLineNumber=623
	    ;;
	004131 )
	    ayahLineNumber=624
	    ;;
	004132 )
	    ayahLineNumber=625
	    ;;
	004133 )
	    ayahLineNumber=626
	    ;;
	004134 )
	    ayahLineNumber=627
	    ;;
	004135 )
	    ayahLineNumber=628
	    ;;
	004136 )
	    ayahLineNumber=629
	    ;;
	004137 )
	    ayahLineNumber=630
	    ;;
	004138 )
	    ayahLineNumber=631
	    ;;
	004139 )
	    ayahLineNumber=632
	    ;;
	004140 )
	    ayahLineNumber=633
	    ;;
	004141 )
	    ayahLineNumber=634
	    ;;
	004142 )
	    ayahLineNumber=635
	    ;;
	004143 )
	    ayahLineNumber=636
	    ;;
	004144 )
	    ayahLineNumber=637
	    ;;
	004145 )
	    ayahLineNumber=638
	    ;;
	004146 )
	    ayahLineNumber=639
	    ;;
	004147 )
	    ayahLineNumber=640
	    ;;
	004148 )
	    ayahLineNumber=641
	    ;;
	004149 )
	    ayahLineNumber=642
	    ;;
	004150 )
	    ayahLineNumber=643
	    ;;
	004151 )
	    ayahLineNumber=644
	    ;;
	004152 )
	    ayahLineNumber=645
	    ;;
	004153 )
	    ayahLineNumber=646
	    ;;
	004154 )
	    ayahLineNumber=647
	    ;;
	004155 )
	    ayahLineNumber=648
	    ;;
	004156 )
	    ayahLineNumber=649
	    ;;
	004157 )
	    ayahLineNumber=650
	    ;;
	004158 )
	    ayahLineNumber=651
	    ;;
	004159 )
	    ayahLineNumber=652
	    ;;
	004160 )
	    ayahLineNumber=653
	    ;;
	004161 )
	    ayahLineNumber=654
	    ;;
	004162 )
	    ayahLineNumber=655
	    ;;
	004163 )
	    ayahLineNumber=656
	    ;;
	004164 )
	    ayahLineNumber=657
	    ;;
	004165 )
	    ayahLineNumber=658
	    ;;
	004166 )
	    ayahLineNumber=659
	    ;;
	004167 )
	    ayahLineNumber=660
	    ;;
	004168 )
	    ayahLineNumber=661
	    ;;
	004169 )
	    ayahLineNumber=662
	    ;;
	004170 )
	    ayahLineNumber=663
	    ;;
	004171 )
	    ayahLineNumber=664
	    ;;
	004172 )
	    ayahLineNumber=665
	    ;;
	004173 )
	    ayahLineNumber=666
	    ;;
	004174 )
	    ayahLineNumber=667
	    ;;
	004175 )
	    ayahLineNumber=668
	    ;;
	004176 )
	    ayahLineNumber=669
	    ;;
	005001 )
	    ayahLineNumber=670
	    ;;
	005002 )
	    ayahLineNumber=671
	    ;;
	005003 )
	    ayahLineNumber=672
	    ;;
	005004 )
	    ayahLineNumber=673
	    ;;
	005005 )
	    ayahLineNumber=674
	    ;;
	005006 )
	    ayahLineNumber=675
	    ;;
	005007 )
	    ayahLineNumber=676
	    ;;
	005008 )
	    ayahLineNumber=677
	    ;;
	005009 )
	    ayahLineNumber=678
	    ;;
	005010 )
	    ayahLineNumber=679
	    ;;
	005011 )
	    ayahLineNumber=680
	    ;;
	005012 )
	    ayahLineNumber=681
	    ;;
	005013 )
	    ayahLineNumber=682
	    ;;
	005014 )
	    ayahLineNumber=683
	    ;;
	005015 )
	    ayahLineNumber=684
	    ;;
	005016 )
	    ayahLineNumber=685
	    ;;
	005017 )
	    ayahLineNumber=686
	    ;;
	005018 )
	    ayahLineNumber=687
	    ;;
	005019 )
	    ayahLineNumber=688
	    ;;
	005020 )
	    ayahLineNumber=689
	    ;;
	005021 )
	    ayahLineNumber=690
	    ;;
	005022 )
	    ayahLineNumber=691
	    ;;
	005023 )
	    ayahLineNumber=692
	    ;;
	005024 )
	    ayahLineNumber=693
	    ;;
	005025 )
	    ayahLineNumber=694
	    ;;
	005026 )
	    ayahLineNumber=695
	    ;;
	005027 )
	    ayahLineNumber=696
	    ;;
	005028 )
	    ayahLineNumber=697
	    ;;
	005029 )
	    ayahLineNumber=698
	    ;;
	005030 )
	    ayahLineNumber=699
	    ;;
	005031 )
	    ayahLineNumber=700
	    ;;
	005032 )
	    ayahLineNumber=701
	    ;;
	005033 )
	    ayahLineNumber=702
	    ;;
	005034 )
	    ayahLineNumber=703
	    ;;
	005035 )
	    ayahLineNumber=704
	    ;;
	005036 )
	    ayahLineNumber=705
	    ;;
	005037 )
	    ayahLineNumber=706
	    ;;
	005038 )
	    ayahLineNumber=707
	    ;;
	005039 )
	    ayahLineNumber=708
	    ;;
	005040 )
	    ayahLineNumber=709
	    ;;
	005041 )
	    ayahLineNumber=710
	    ;;
	005042 )
	    ayahLineNumber=711
	    ;;
	005043 )
	    ayahLineNumber=712
	    ;;
	005044 )
	    ayahLineNumber=713
	    ;;
	005045 )
	    ayahLineNumber=714
	    ;;
	005046 )
	    ayahLineNumber=715
	    ;;
	005047 )
	    ayahLineNumber=716
	    ;;
	005048 )
	    ayahLineNumber=717
	    ;;
	005049 )
	    ayahLineNumber=718
	    ;;
	005050 )
	    ayahLineNumber=719
	    ;;
	005051 )
	    ayahLineNumber=720
	    ;;
	005052 )
	    ayahLineNumber=721
	    ;;
	005053 )
	    ayahLineNumber=722
	    ;;
	005054 )
	    ayahLineNumber=723
	    ;;
	005055 )
	    ayahLineNumber=724
	    ;;
	005056 )
	    ayahLineNumber=725
	    ;;
	005057 )
	    ayahLineNumber=726
	    ;;
	005058 )
	    ayahLineNumber=727
	    ;;
	005059 )
	    ayahLineNumber=728
	    ;;
	005060 )
	    ayahLineNumber=729
	    ;;
	005061 )
	    ayahLineNumber=730
	    ;;
	005062 )
	    ayahLineNumber=731
	    ;;
	005063 )
	    ayahLineNumber=732
	    ;;
	005064 )
	    ayahLineNumber=733
	    ;;
	005065 )
	    ayahLineNumber=734
	    ;;
	005066 )
	    ayahLineNumber=735
	    ;;
	005067 )
	    ayahLineNumber=736
	    ;;
	005068 )
	    ayahLineNumber=737
	    ;;
	005069 )
	    ayahLineNumber=738
	    ;;
	005070 )
	    ayahLineNumber=739
	    ;;
	005071 )
	    ayahLineNumber=740
	    ;;
	005072 )
	    ayahLineNumber=741
	    ;;
	005073 )
	    ayahLineNumber=742
	    ;;
	005074 )
	    ayahLineNumber=743
	    ;;
	005075 )
	    ayahLineNumber=744
	    ;;
	005076 )
	    ayahLineNumber=745
	    ;;
	005077 )
	    ayahLineNumber=746
	    ;;
	005078 )
	    ayahLineNumber=747
	    ;;
	005079 )
	    ayahLineNumber=748
	    ;;
	005080 )
	    ayahLineNumber=749
	    ;;
	005081 )
	    ayahLineNumber=750
	    ;;
	005082 )
	    ayahLineNumber=751
	    ;;
	005083 )
	    ayahLineNumber=752
	    ;;
	005084 )
	    ayahLineNumber=753
	    ;;
	005085 )
	    ayahLineNumber=754
	    ;;
	005086 )
	    ayahLineNumber=755
	    ;;
	005087 )
	    ayahLineNumber=756
	    ;;
	005088 )
	    ayahLineNumber=757
	    ;;
	005089 )
	    ayahLineNumber=758
	    ;;
	005090 )
	    ayahLineNumber=759
	    ;;
	005091 )
	    ayahLineNumber=760
	    ;;
	005092 )
	    ayahLineNumber=761
	    ;;
	005093 )
	    ayahLineNumber=762
	    ;;
	005094 )
	    ayahLineNumber=763
	    ;;
	005095 )
	    ayahLineNumber=764
	    ;;
	005096 )
	    ayahLineNumber=765
	    ;;
	005097 )
	    ayahLineNumber=766
	    ;;
	005098 )
	    ayahLineNumber=767
	    ;;
	005099 )
	    ayahLineNumber=768
	    ;;
	005100 )
	    ayahLineNumber=769
	    ;;
	005101 )
	    ayahLineNumber=770
	    ;;
	005102 )
	    ayahLineNumber=771
	    ;;
	005103 )
	    ayahLineNumber=772
	    ;;
	005104 )
	    ayahLineNumber=773
	    ;;
	005105 )
	    ayahLineNumber=774
	    ;;
	005106 )
	    ayahLineNumber=775
	    ;;
	005107 )
	    ayahLineNumber=776
	    ;;
	005108 )
	    ayahLineNumber=777
	    ;;
	005109 )
	    ayahLineNumber=778
	    ;;
	005110 )
	    ayahLineNumber=779
	    ;;
	005111 )
	    ayahLineNumber=780
	    ;;
	005112 )
	    ayahLineNumber=781
	    ;;
	005113 )
	    ayahLineNumber=782
	    ;;
	005114 )
	    ayahLineNumber=783
	    ;;
	005115 )
	    ayahLineNumber=784
	    ;;
	005116 )
	    ayahLineNumber=785
	    ;;
	005117 )
	    ayahLineNumber=786
	    ;;
	005118 )
	    ayahLineNumber=787
	    ;;
	005119 )
	    ayahLineNumber=788
	    ;;
	005120 )
	    ayahLineNumber=789
	    ;;
	006001 )
	    ayahLineNumber=790
	    ;;
	006002 )
	    ayahLineNumber=791
	    ;;
	006003 )
	    ayahLineNumber=792
	    ;;
	006004 )
	    ayahLineNumber=793
	    ;;
	006005 )
	    ayahLineNumber=794
	    ;;
	006006 )
	    ayahLineNumber=795
	    ;;
	006007 )
	    ayahLineNumber=796
	    ;;
	006008 )
	    ayahLineNumber=797
	    ;;
	006009 )
	    ayahLineNumber=798
	    ;;
	006010 )
	    ayahLineNumber=799
	    ;;
	006011 )
	    ayahLineNumber=800
	    ;;
	006012 )
	    ayahLineNumber=801
	    ;;
	006013 )
	    ayahLineNumber=802
	    ;;
	006014 )
	    ayahLineNumber=803
	    ;;
	006015 )
	    ayahLineNumber=804
	    ;;
	006016 )
	    ayahLineNumber=805
	    ;;
	006017 )
	    ayahLineNumber=806
	    ;;
	006018 )
	    ayahLineNumber=807
	    ;;
	006019 )
	    ayahLineNumber=808
	    ;;
	006020 )
	    ayahLineNumber=809
	    ;;
	006021 )
	    ayahLineNumber=810
	    ;;
	006022 )
	    ayahLineNumber=811
	    ;;
	006023 )
	    ayahLineNumber=812
	    ;;
	006024 )
	    ayahLineNumber=813
	    ;;
	006025 )
	    ayahLineNumber=814
	    ;;
	006026 )
	    ayahLineNumber=815
	    ;;
	006027 )
	    ayahLineNumber=816
	    ;;
	006028 )
	    ayahLineNumber=817
	    ;;
	006029 )
	    ayahLineNumber=818
	    ;;
	006030 )
	    ayahLineNumber=819
	    ;;
	006031 )
	    ayahLineNumber=820
	    ;;
	006032 )
	    ayahLineNumber=821
	    ;;
	006033 )
	    ayahLineNumber=822
	    ;;
	006034 )
	    ayahLineNumber=823
	    ;;
	006035 )
	    ayahLineNumber=824
	    ;;
	006036 )
	    ayahLineNumber=825
	    ;;
	006037 )
	    ayahLineNumber=826
	    ;;
	006038 )
	    ayahLineNumber=827
	    ;;
	006039 )
	    ayahLineNumber=828
	    ;;
	006040 )
	    ayahLineNumber=829
	    ;;
	006041 )
	    ayahLineNumber=830
	    ;;
	006042 )
	    ayahLineNumber=831
	    ;;
	006043 )
	    ayahLineNumber=832
	    ;;
	006044 )
	    ayahLineNumber=833
	    ;;
	006045 )
	    ayahLineNumber=834
	    ;;
	006046 )
	    ayahLineNumber=835
	    ;;
	006047 )
	    ayahLineNumber=836
	    ;;
	006048 )
	    ayahLineNumber=837
	    ;;
	006049 )
	    ayahLineNumber=838
	    ;;
	006050 )
	    ayahLineNumber=839
	    ;;
	006051 )
	    ayahLineNumber=840
	    ;;
	006052 )
	    ayahLineNumber=841
	    ;;
	006053 )
	    ayahLineNumber=842
	    ;;
	006054 )
	    ayahLineNumber=843
	    ;;
	006055 )
	    ayahLineNumber=844
	    ;;
	006056 )
	    ayahLineNumber=845
	    ;;
	006057 )
	    ayahLineNumber=846
	    ;;
	006058 )
	    ayahLineNumber=847
	    ;;
	006059 )
	    ayahLineNumber=848
	    ;;
	006060 )
	    ayahLineNumber=849
	    ;;
	006061 )
	    ayahLineNumber=850
	    ;;
	006062 )
	    ayahLineNumber=851
	    ;;
	006063 )
	    ayahLineNumber=852
	    ;;
	006064 )
	    ayahLineNumber=853
	    ;;
	006065 )
	    ayahLineNumber=854
	    ;;
	006066 )
	    ayahLineNumber=855
	    ;;
	006067 )
	    ayahLineNumber=856
	    ;;
	006068 )
	    ayahLineNumber=857
	    ;;
	006069 )
	    ayahLineNumber=858
	    ;;
	006070 )
	    ayahLineNumber=859
	    ;;
	006071 )
	    ayahLineNumber=860
	    ;;
	006072 )
	    ayahLineNumber=861
	    ;;
	006073 )
	    ayahLineNumber=862
	    ;;
	006074 )
	    ayahLineNumber=863
	    ;;
	006075 )
	    ayahLineNumber=864
	    ;;
	006076 )
	    ayahLineNumber=865
	    ;;
	006077 )
	    ayahLineNumber=866
	    ;;
	006078 )
	    ayahLineNumber=867
	    ;;
	006079 )
	    ayahLineNumber=868
	    ;;
	006080 )
	    ayahLineNumber=869
	    ;;
	006081 )
	    ayahLineNumber=870
	    ;;
	006082 )
	    ayahLineNumber=871
	    ;;
	006083 )
	    ayahLineNumber=872
	    ;;
	006084 )
	    ayahLineNumber=873
	    ;;
	006085 )
	    ayahLineNumber=874
	    ;;
	006086 )
	    ayahLineNumber=875
	    ;;
	006087 )
	    ayahLineNumber=876
	    ;;
	006088 )
	    ayahLineNumber=877
	    ;;
	006089 )
	    ayahLineNumber=878
	    ;;
	006090 )
	    ayahLineNumber=879
	    ;;
	006091 )
	    ayahLineNumber=880
	    ;;
	006092 )
	    ayahLineNumber=881
	    ;;
	006093 )
	    ayahLineNumber=882
	    ;;
	006094 )
	    ayahLineNumber=883
	    ;;
	006095 )
	    ayahLineNumber=884
	    ;;
	006096 )
	    ayahLineNumber=885
	    ;;
	006097 )
	    ayahLineNumber=886
	    ;;
	006098 )
	    ayahLineNumber=887
	    ;;
	006099 )
	    ayahLineNumber=888
	    ;;
	006100 )
	    ayahLineNumber=889
	    ;;
	006101 )
	    ayahLineNumber=890
	    ;;
	006102 )
	    ayahLineNumber=891
	    ;;
	006103 )
	    ayahLineNumber=892
	    ;;
	006104 )
	    ayahLineNumber=893
	    ;;
	006105 )
	    ayahLineNumber=894
	    ;;
	006106 )
	    ayahLineNumber=895
	    ;;
	006107 )
	    ayahLineNumber=896
	    ;;
	006108 )
	    ayahLineNumber=897
	    ;;
	006109 )
	    ayahLineNumber=898
	    ;;
	006110 )
	    ayahLineNumber=899
	    ;;
	006111 )
	    ayahLineNumber=900
	    ;;
	006112 )
	    ayahLineNumber=901
	    ;;
	006113 )
	    ayahLineNumber=902
	    ;;
	006114 )
	    ayahLineNumber=903
	    ;;
	006115 )
	    ayahLineNumber=904
	    ;;
	006116 )
	    ayahLineNumber=905
	    ;;
	006117 )
	    ayahLineNumber=906
	    ;;
	006118 )
	    ayahLineNumber=907
	    ;;
	006119 )
	    ayahLineNumber=908
	    ;;
	006120 )
	    ayahLineNumber=909
	    ;;
	006121 )
	    ayahLineNumber=910
	    ;;
	006122 )
	    ayahLineNumber=911
	    ;;
	006123 )
	    ayahLineNumber=912
	    ;;
	006124 )
	    ayahLineNumber=913
	    ;;
	006125 )
	    ayahLineNumber=914
	    ;;
	006126 )
	    ayahLineNumber=915
	    ;;
	006127 )
	    ayahLineNumber=916
	    ;;
	006128 )
	    ayahLineNumber=917
	    ;;
	006129 )
	    ayahLineNumber=918
	    ;;
	006130 )
	    ayahLineNumber=919
	    ;;
	006131 )
	    ayahLineNumber=920
	    ;;
	006132 )
	    ayahLineNumber=921
	    ;;
	006133 )
	    ayahLineNumber=922
	    ;;
	006134 )
	    ayahLineNumber=923
	    ;;
	006135 )
	    ayahLineNumber=924
	    ;;
	006136 )
	    ayahLineNumber=925
	    ;;
	006137 )
	    ayahLineNumber=926
	    ;;
	006138 )
	    ayahLineNumber=927
	    ;;
	006139 )
	    ayahLineNumber=928
	    ;;
	006140 )
	    ayahLineNumber=929
	    ;;
	006141 )
	    ayahLineNumber=930
	    ;;
	006142 )
	    ayahLineNumber=931
	    ;;
	006143 )
	    ayahLineNumber=932
	    ;;
	006144 )
	    ayahLineNumber=933
	    ;;
	006145 )
	    ayahLineNumber=934
	    ;;
	006146 )
	    ayahLineNumber=935
	    ;;
	006147 )
	    ayahLineNumber=936
	    ;;
	006148 )
	    ayahLineNumber=937
	    ;;
	006149 )
	    ayahLineNumber=938
	    ;;
	006150 )
	    ayahLineNumber=939
	    ;;
	006151 )
	    ayahLineNumber=940
	    ;;
	006152 )
	    ayahLineNumber=941
	    ;;
	006153 )
	    ayahLineNumber=942
	    ;;
	006154 )
	    ayahLineNumber=943
	    ;;
	006155 )
	    ayahLineNumber=944
	    ;;
	006156 )
	    ayahLineNumber=945
	    ;;
	006157 )
	    ayahLineNumber=946
	    ;;
	006158 )
	    ayahLineNumber=947
	    ;;
	006159 )
	    ayahLineNumber=948
	    ;;
	006160 )
	    ayahLineNumber=949
	    ;;
	006161 )
	    ayahLineNumber=950
	    ;;
	006162 )
	    ayahLineNumber=951
	    ;;
	006163 )
	    ayahLineNumber=952
	    ;;
	006164 )
	    ayahLineNumber=953
	    ;;
	006165 )
	    ayahLineNumber=954
	    ;;
	007001 )
	    ayahLineNumber=955
	    ;;
	007002 )
	    ayahLineNumber=956
	    ;;
	007003 )
	    ayahLineNumber=957
	    ;;
	007004 )
	    ayahLineNumber=958
	    ;;
	007005 )
	    ayahLineNumber=959
	    ;;
	007006 )
	    ayahLineNumber=960
	    ;;
	007007 )
	    ayahLineNumber=961
	    ;;
	007008 )
	    ayahLineNumber=962
	    ;;
	007009 )
	    ayahLineNumber=963
	    ;;
	007010 )
	    ayahLineNumber=964
	    ;;
	007011 )
	    ayahLineNumber=965
	    ;;
	007012 )
	    ayahLineNumber=966
	    ;;
	007013 )
	    ayahLineNumber=967
	    ;;
	007014 )
	    ayahLineNumber=968
	    ;;
	007015 )
	    ayahLineNumber=969
	    ;;
	007016 )
	    ayahLineNumber=970
	    ;;
	007017 )
	    ayahLineNumber=971
	    ;;
	007018 )
	    ayahLineNumber=972
	    ;;
	007019 )
	    ayahLineNumber=973
	    ;;
	007020 )
	    ayahLineNumber=974
	    ;;
	007021 )
	    ayahLineNumber=975
	    ;;
	007022 )
	    ayahLineNumber=976
	    ;;
	007023 )
	    ayahLineNumber=977
	    ;;
	007024 )
	    ayahLineNumber=978
	    ;;
	007025 )
	    ayahLineNumber=979
	    ;;
	007026 )
	    ayahLineNumber=980
	    ;;
	007027 )
	    ayahLineNumber=981
	    ;;
	007028 )
	    ayahLineNumber=982
	    ;;
	007029 )
	    ayahLineNumber=983
	    ;;
	007030 )
	    ayahLineNumber=984
	    ;;
	007031 )
	    ayahLineNumber=985
	    ;;
	007032 )
	    ayahLineNumber=986
	    ;;
	007033 )
	    ayahLineNumber=987
	    ;;
	007034 )
	    ayahLineNumber=988
	    ;;
	007035 )
	    ayahLineNumber=989
	    ;;
	007036 )
	    ayahLineNumber=990
	    ;;
	007037 )
	    ayahLineNumber=991
	    ;;
	007038 )
	    ayahLineNumber=992
	    ;;
	007039 )
	    ayahLineNumber=993
	    ;;
	007040 )
	    ayahLineNumber=994
	    ;;
	007041 )
	    ayahLineNumber=995
	    ;;
	007042 )
	    ayahLineNumber=996
	    ;;
	007043 )
	    ayahLineNumber=997
	    ;;
	007044 )
	    ayahLineNumber=998
	    ;;
	007045 )
	    ayahLineNumber=999
	    ;;
	007046 )
	    ayahLineNumber=1000
	    ;;
	007047 )
	    ayahLineNumber=1001
	    ;;
	007048 )
	    ayahLineNumber=1002
	    ;;
	007049 )
	    ayahLineNumber=1003
	    ;;
	007050 )
	    ayahLineNumber=1004
	    ;;
	007051 )
	    ayahLineNumber=1005
	    ;;
	007052 )
	    ayahLineNumber=1006
	    ;;
	007053 )
	    ayahLineNumber=1007
	    ;;
	007054 )
	    ayahLineNumber=1008
	    ;;
	007055 )
	    ayahLineNumber=1009
	    ;;
	007056 )
	    ayahLineNumber=1010
	    ;;
	007057 )
	    ayahLineNumber=1011
	    ;;
	007058 )
	    ayahLineNumber=1012
	    ;;
	007059 )
	    ayahLineNumber=1013
	    ;;
	007060 )
	    ayahLineNumber=1014
	    ;;
	007061 )
	    ayahLineNumber=1015
	    ;;
	007062 )
	    ayahLineNumber=1016
	    ;;
	007063 )
	    ayahLineNumber=1017
	    ;;
	007064 )
	    ayahLineNumber=1018
	    ;;
	007065 )
	    ayahLineNumber=1019
	    ;;
	007066 )
	    ayahLineNumber=1020
	    ;;
	007067 )
	    ayahLineNumber=1021
	    ;;
	007068 )
	    ayahLineNumber=1022
	    ;;
	007069 )
	    ayahLineNumber=1023
	    ;;
	007070 )
	    ayahLineNumber=1024
	    ;;
	007071 )
	    ayahLineNumber=1025
	    ;;
	007072 )
	    ayahLineNumber=1026
	    ;;
	007073 )
	    ayahLineNumber=1027
	    ;;
	007074 )
	    ayahLineNumber=1028
	    ;;
	007075 )
	    ayahLineNumber=1029
	    ;;
	007076 )
	    ayahLineNumber=1030
	    ;;
	007077 )
	    ayahLineNumber=1031
	    ;;
	007078 )
	    ayahLineNumber=1032
	    ;;
	007079 )
	    ayahLineNumber=1033
	    ;;
	007080 )
	    ayahLineNumber=1034
	    ;;
	007081 )
	    ayahLineNumber=1035
	    ;;
	007082 )
	    ayahLineNumber=1036
	    ;;
	007083 )
	    ayahLineNumber=1037
	    ;;
	007084 )
	    ayahLineNumber=1038
	    ;;
	007085 )
	    ayahLineNumber=1039
	    ;;
	007086 )
	    ayahLineNumber=1040
	    ;;
	007087 )
	    ayahLineNumber=1041
	    ;;
	007088 )
	    ayahLineNumber=1042
	    ;;
	007089 )
	    ayahLineNumber=1043
	    ;;
	007090 )
	    ayahLineNumber=1044
	    ;;
	007091 )
	    ayahLineNumber=1045
	    ;;
	007092 )
	    ayahLineNumber=1046
	    ;;
	007093 )
	    ayahLineNumber=1047
	    ;;
	007094 )
	    ayahLineNumber=1048
	    ;;
	007095 )
	    ayahLineNumber=1049
	    ;;
	007096 )
	    ayahLineNumber=1050
	    ;;
	007097 )
	    ayahLineNumber=1051
	    ;;
	007098 )
	    ayahLineNumber=1052
	    ;;
	007099 )
	    ayahLineNumber=1053
	    ;;
	007100 )
	    ayahLineNumber=1054
	    ;;
	007101 )
	    ayahLineNumber=1055
	    ;;
	007102 )
	    ayahLineNumber=1056
	    ;;
	007103 )
	    ayahLineNumber=1057
	    ;;
	007104 )
	    ayahLineNumber=1058
	    ;;
	007105 )
	    ayahLineNumber=1059
	    ;;
	007106 )
	    ayahLineNumber=1060
	    ;;
	007107 )
	    ayahLineNumber=1061
	    ;;
	007108 )
	    ayahLineNumber=1062
	    ;;
	007109 )
	    ayahLineNumber=1063
	    ;;
	007110 )
	    ayahLineNumber=1064
	    ;;
	007111 )
	    ayahLineNumber=1065
	    ;;
	007112 )
	    ayahLineNumber=1066
	    ;;
	007113 )
	    ayahLineNumber=1067
	    ;;
	007114 )
	    ayahLineNumber=1068
	    ;;
	007115 )
	    ayahLineNumber=1069
	    ;;
	007116 )
	    ayahLineNumber=1070
	    ;;
	007117 )
	    ayahLineNumber=1071
	    ;;
	007118 )
	    ayahLineNumber=1072
	    ;;
	007119 )
	    ayahLineNumber=1073
	    ;;
	007120 )
	    ayahLineNumber=1074
	    ;;
	007121 )
	    ayahLineNumber=1075
	    ;;
	007122 )
	    ayahLineNumber=1076
	    ;;
	007123 )
	    ayahLineNumber=1077
	    ;;
	007124 )
	    ayahLineNumber=1078
	    ;;
	007125 )
	    ayahLineNumber=1079
	    ;;
	007126 )
	    ayahLineNumber=1080
	    ;;
	007127 )
	    ayahLineNumber=1081
	    ;;
	007128 )
	    ayahLineNumber=1082
	    ;;
	007129 )
	    ayahLineNumber=1083
	    ;;
	007130 )
	    ayahLineNumber=1084
	    ;;
	007131 )
	    ayahLineNumber=1085
	    ;;
	007132 )
	    ayahLineNumber=1086
	    ;;
	007133 )
	    ayahLineNumber=1087
	    ;;
	007134 )
	    ayahLineNumber=1088
	    ;;
	007135 )
	    ayahLineNumber=1089
	    ;;
	007136 )
	    ayahLineNumber=1090
	    ;;
	007137 )
	    ayahLineNumber=1091
	    ;;
	007138 )
	    ayahLineNumber=1092
	    ;;
	007139 )
	    ayahLineNumber=1093
	    ;;
	007140 )
	    ayahLineNumber=1094
	    ;;
	007141 )
	    ayahLineNumber=1095
	    ;;
	007142 )
	    ayahLineNumber=1096
	    ;;
	007143 )
	    ayahLineNumber=1097
	    ;;
	007144 )
	    ayahLineNumber=1098
	    ;;
	007145 )
	    ayahLineNumber=1099
	    ;;
	007146 )
	    ayahLineNumber=1100
	    ;;
	007147 )
	    ayahLineNumber=1101
	    ;;
	007148 )
	    ayahLineNumber=1102
	    ;;
	007149 )
	    ayahLineNumber=1103
	    ;;
	007150 )
	    ayahLineNumber=1104
	    ;;
	007151 )
	    ayahLineNumber=1105
	    ;;
	007152 )
	    ayahLineNumber=1106
	    ;;
	007153 )
	    ayahLineNumber=1107
	    ;;
	007154 )
	    ayahLineNumber=1108
	    ;;
	007155 )
	    ayahLineNumber=1109
	    ;;
	007156 )
	    ayahLineNumber=1110
	    ;;
	007157 )
	    ayahLineNumber=1111
	    ;;
	007158 )
	    ayahLineNumber=1112
	    ;;
	007159 )
	    ayahLineNumber=1113
	    ;;
	007160 )
	    ayahLineNumber=1114
	    ;;
	007161 )
	    ayahLineNumber=1115
	    ;;
	007162 )
	    ayahLineNumber=1116
	    ;;
	007163 )
	    ayahLineNumber=1117
	    ;;
	007164 )
	    ayahLineNumber=1118
	    ;;
	007165 )
	    ayahLineNumber=1119
	    ;;
	007166 )
	    ayahLineNumber=1120
	    ;;
	007167 )
	    ayahLineNumber=1121
	    ;;
	007168 )
	    ayahLineNumber=1122
	    ;;
	007169 )
	    ayahLineNumber=1123
	    ;;
	007170 )
	    ayahLineNumber=1124
	    ;;
	007171 )
	    ayahLineNumber=1125
	    ;;
	007172 )
	    ayahLineNumber=1126
	    ;;
	007173 )
	    ayahLineNumber=1127
	    ;;
	007174 )
	    ayahLineNumber=1128
	    ;;
	007175 )
	    ayahLineNumber=1129
	    ;;
	007176 )
	    ayahLineNumber=1130
	    ;;
	007177 )
	    ayahLineNumber=1131
	    ;;
	007178 )
	    ayahLineNumber=1132
	    ;;
	007179 )
	    ayahLineNumber=1133
	    ;;
	007180 )
	    ayahLineNumber=1134
	    ;;
	007181 )
	    ayahLineNumber=1135
	    ;;
	007182 )
	    ayahLineNumber=1136
	    ;;
	007183 )
	    ayahLineNumber=1137
	    ;;
	007184 )
	    ayahLineNumber=1138
	    ;;
	007185 )
	    ayahLineNumber=1139
	    ;;
	007186 )
	    ayahLineNumber=1140
	    ;;
	007187 )
	    ayahLineNumber=1141
	    ;;
	007188 )
	    ayahLineNumber=1142
	    ;;
	007189 )
	    ayahLineNumber=1143
	    ;;
	007190 )
	    ayahLineNumber=1144
	    ;;
	007191 )
	    ayahLineNumber=1145
	    ;;
	007192 )
	    ayahLineNumber=1146
	    ;;
	007193 )
	    ayahLineNumber=1147
	    ;;
	007194 )
	    ayahLineNumber=1148
	    ;;
	007195 )
	    ayahLineNumber=1149
	    ;;
	007196 )
	    ayahLineNumber=1150
	    ;;
	007197 )
	    ayahLineNumber=1151
	    ;;
	007198 )
	    ayahLineNumber=1152
	    ;;
	007199 )
	    ayahLineNumber=1153
	    ;;
	007200 )
	    ayahLineNumber=1154
	    ;;
	007201 )
	    ayahLineNumber=1155
	    ;;
	007202 )
	    ayahLineNumber=1156
	    ;;
	007203 )
	    ayahLineNumber=1157
	    ;;
	007204 )
	    ayahLineNumber=1158
	    ;;
	007205 )
	    ayahLineNumber=1159
	    ;;
	007206 )
	    ayahLineNumber=1160
	    ;;
	008001 )
	    ayahLineNumber=1161
	    ;;
	008002 )
	    ayahLineNumber=1162
	    ;;
	008003 )
	    ayahLineNumber=1163
	    ;;
	008004 )
	    ayahLineNumber=1164
	    ;;
	008005 )
	    ayahLineNumber=1165
	    ;;
	008006 )
	    ayahLineNumber=1166
	    ;;
	008007 )
	    ayahLineNumber=1167
	    ;;
	008008 )
	    ayahLineNumber=1168
	    ;;
	008009 )
	    ayahLineNumber=1169
	    ;;
	008010 )
	    ayahLineNumber=1170
	    ;;
	008011 )
	    ayahLineNumber=1171
	    ;;
	008012 )
	    ayahLineNumber=1172
	    ;;
	008013 )
	    ayahLineNumber=1173
	    ;;
	008014 )
	    ayahLineNumber=1174
	    ;;
	008015 )
	    ayahLineNumber=1175
	    ;;
	008016 )
	    ayahLineNumber=1176
	    ;;
	008017 )
	    ayahLineNumber=1177
	    ;;
	008018 )
	    ayahLineNumber=1178
	    ;;
	008019 )
	    ayahLineNumber=1179
	    ;;
	008020 )
	    ayahLineNumber=1180
	    ;;
	008021 )
	    ayahLineNumber=1181
	    ;;
	008022 )
	    ayahLineNumber=1182
	    ;;
	008023 )
	    ayahLineNumber=1183
	    ;;
	008024 )
	    ayahLineNumber=1184
	    ;;
	008025 )
	    ayahLineNumber=1185
	    ;;
	008026 )
	    ayahLineNumber=1186
	    ;;
	008027 )
	    ayahLineNumber=1187
	    ;;
	008028 )
	    ayahLineNumber=1188
	    ;;
	008029 )
	    ayahLineNumber=1189
	    ;;
	008030 )
	    ayahLineNumber=1190
	    ;;
	008031 )
	    ayahLineNumber=1191
	    ;;
	008032 )
	    ayahLineNumber=1192
	    ;;
	008033 )
	    ayahLineNumber=1193
	    ;;
	008034 )
	    ayahLineNumber=1194
	    ;;
	008035 )
	    ayahLineNumber=1195
	    ;;
	008036 )
	    ayahLineNumber=1196
	    ;;
	008037 )
	    ayahLineNumber=1197
	    ;;
	008038 )
	    ayahLineNumber=1198
	    ;;
	008039 )
	    ayahLineNumber=1199
	    ;;
	008040 )
	    ayahLineNumber=1200
	    ;;
	008041 )
	    ayahLineNumber=1201
	    ;;
	008042 )
	    ayahLineNumber=1202
	    ;;
	008043 )
	    ayahLineNumber=1203
	    ;;
	008044 )
	    ayahLineNumber=1204
	    ;;
	008045 )
	    ayahLineNumber=1205
	    ;;
	008046 )
	    ayahLineNumber=1206
	    ;;
	008047 )
	    ayahLineNumber=1207
	    ;;
	008048 )
	    ayahLineNumber=1208
	    ;;
	008049 )
	    ayahLineNumber=1209
	    ;;
	008050 )
	    ayahLineNumber=1210
	    ;;
	008051 )
	    ayahLineNumber=1211
	    ;;
	008052 )
	    ayahLineNumber=1212
	    ;;
	008053 )
	    ayahLineNumber=1213
	    ;;
	008054 )
	    ayahLineNumber=1214
	    ;;
	008055 )
	    ayahLineNumber=1215
	    ;;
	008056 )
	    ayahLineNumber=1216
	    ;;
	008057 )
	    ayahLineNumber=1217
	    ;;
	008058 )
	    ayahLineNumber=1218
	    ;;
	008059 )
	    ayahLineNumber=1219
	    ;;
	008060 )
	    ayahLineNumber=1220
	    ;;
	008061 )
	    ayahLineNumber=1221
	    ;;
	008062 )
	    ayahLineNumber=1222
	    ;;
	008063 )
	    ayahLineNumber=1223
	    ;;
	008064 )
	    ayahLineNumber=1224
	    ;;
	008065 )
	    ayahLineNumber=1225
	    ;;
	008066 )
	    ayahLineNumber=1226
	    ;;
	008067 )
	    ayahLineNumber=1227
	    ;;
	008068 )
	    ayahLineNumber=1228
	    ;;
	008069 )
	    ayahLineNumber=1229
	    ;;
	008070 )
	    ayahLineNumber=1230
	    ;;
	008071 )
	    ayahLineNumber=1231
	    ;;
	008072 )
	    ayahLineNumber=1232
	    ;;
	008073 )
	    ayahLineNumber=1233
	    ;;
	008074 )
	    ayahLineNumber=1234
	    ;;
	008075 )
	    ayahLineNumber=1235
	    ;;
	009001 )
	    ayahLineNumber=1236
	    ;;
	009002 )
	    ayahLineNumber=1237
	    ;;
	009003 )
	    ayahLineNumber=1238
	    ;;
	009004 )
	    ayahLineNumber=1239
	    ;;
	009005 )
	    ayahLineNumber=1240
	    ;;
	009006 )
	    ayahLineNumber=1241
	    ;;
	009007 )
	    ayahLineNumber=1242
	    ;;
	009008 )
	    ayahLineNumber=1243
	    ;;
	009009 )
	    ayahLineNumber=1244
	    ;;
	009010 )
	    ayahLineNumber=1245
	    ;;
	009011 )
	    ayahLineNumber=1246
	    ;;
	009012 )
	    ayahLineNumber=1247
	    ;;
	009013 )
	    ayahLineNumber=1248
	    ;;
	009014 )
	    ayahLineNumber=1249
	    ;;
	009015 )
	    ayahLineNumber=1250
	    ;;
	009016 )
	    ayahLineNumber=1251
	    ;;
	009017 )
	    ayahLineNumber=1252
	    ;;
	009018 )
	    ayahLineNumber=1253
	    ;;
	009019 )
	    ayahLineNumber=1254
	    ;;
	009020 )
	    ayahLineNumber=1255
	    ;;
	009021 )
	    ayahLineNumber=1256
	    ;;
	009022 )
	    ayahLineNumber=1257
	    ;;
	009023 )
	    ayahLineNumber=1258
	    ;;
	009024 )
	    ayahLineNumber=1259
	    ;;
	009025 )
	    ayahLineNumber=1260
	    ;;
	009026 )
	    ayahLineNumber=1261
	    ;;
	009027 )
	    ayahLineNumber=1262
	    ;;
	009028 )
	    ayahLineNumber=1263
	    ;;
	009029 )
	    ayahLineNumber=1264
	    ;;
	009030 )
	    ayahLineNumber=1265
	    ;;
	009031 )
	    ayahLineNumber=1266
	    ;;
	009032 )
	    ayahLineNumber=1267
	    ;;
	009033 )
	    ayahLineNumber=1268
	    ;;
	009034 )
	    ayahLineNumber=1269
	    ;;
	009035 )
	    ayahLineNumber=1270
	    ;;
	009036 )
	    ayahLineNumber=1271
	    ;;
	009037 )
	    ayahLineNumber=1272
	    ;;
	009038 )
	    ayahLineNumber=1273
	    ;;
	009039 )
	    ayahLineNumber=1274
	    ;;
	009040 )
	    ayahLineNumber=1275
	    ;;
	009041 )
	    ayahLineNumber=1276
	    ;;
	009042 )
	    ayahLineNumber=1277
	    ;;
	009043 )
	    ayahLineNumber=1278
	    ;;
	009044 )
	    ayahLineNumber=1279
	    ;;
	009045 )
	    ayahLineNumber=1280
	    ;;
	009046 )
	    ayahLineNumber=1281
	    ;;
	009047 )
	    ayahLineNumber=1282
	    ;;
	009048 )
	    ayahLineNumber=1283
	    ;;
	009049 )
	    ayahLineNumber=1284
	    ;;
	009050 )
	    ayahLineNumber=1285
	    ;;
	009051 )
	    ayahLineNumber=1286
	    ;;
	009052 )
	    ayahLineNumber=1287
	    ;;
	009053 )
	    ayahLineNumber=1288
	    ;;
	009054 )
	    ayahLineNumber=1289
	    ;;
	009055 )
	    ayahLineNumber=1290
	    ;;
	009056 )
	    ayahLineNumber=1291
	    ;;
	009057 )
	    ayahLineNumber=1292
	    ;;
	009058 )
	    ayahLineNumber=1293
	    ;;
	009059 )
	    ayahLineNumber=1294
	    ;;
	009060 )
	    ayahLineNumber=1295
	    ;;
	009061 )
	    ayahLineNumber=1296
	    ;;
	009062 )
	    ayahLineNumber=1297
	    ;;
	009063 )
	    ayahLineNumber=1298
	    ;;
	009064 )
	    ayahLineNumber=1299
	    ;;
	009065 )
	    ayahLineNumber=1300
	    ;;
	009066 )
	    ayahLineNumber=1301
	    ;;
	009067 )
	    ayahLineNumber=1302
	    ;;
	009068 )
	    ayahLineNumber=1303
	    ;;
	009069 )
	    ayahLineNumber=1304
	    ;;
	009070 )
	    ayahLineNumber=1305
	    ;;
	009071 )
	    ayahLineNumber=1306
	    ;;
	009072 )
	    ayahLineNumber=1307
	    ;;
	009073 )
	    ayahLineNumber=1308
	    ;;
	009074 )
	    ayahLineNumber=1309
	    ;;
	009075 )
	    ayahLineNumber=1310
	    ;;
	009076 )
	    ayahLineNumber=1311
	    ;;
	009077 )
	    ayahLineNumber=1312
	    ;;
	009078 )
	    ayahLineNumber=1313
	    ;;
	009079 )
	    ayahLineNumber=1314
	    ;;
	009080 )
	    ayahLineNumber=1315
	    ;;
	009081 )
	    ayahLineNumber=1316
	    ;;
	009082 )
	    ayahLineNumber=1317
	    ;;
	009083 )
	    ayahLineNumber=1318
	    ;;
	009084 )
	    ayahLineNumber=1319
	    ;;
	009085 )
	    ayahLineNumber=1320
	    ;;
	009086 )
	    ayahLineNumber=1321
	    ;;
	009087 )
	    ayahLineNumber=1322
	    ;;
	009088 )
	    ayahLineNumber=1323
	    ;;
	009089 )
	    ayahLineNumber=1324
	    ;;
	009090 )
	    ayahLineNumber=1325
	    ;;
	009091 )
	    ayahLineNumber=1326
	    ;;
	009092 )
	    ayahLineNumber=1327
	    ;;
	009093 )
	    ayahLineNumber=1328
	    ;;
	009094 )
	    ayahLineNumber=1329
	    ;;
	009095 )
	    ayahLineNumber=1330
	    ;;
	009096 )
	    ayahLineNumber=1331
	    ;;
	009097 )
	    ayahLineNumber=1332
	    ;;
	009098 )
	    ayahLineNumber=1333
	    ;;
	009099 )
	    ayahLineNumber=1334
	    ;;
	009100 )
	    ayahLineNumber=1335
	    ;;
	009101 )
	    ayahLineNumber=1336
	    ;;
	009102 )
	    ayahLineNumber=1337
	    ;;
	009103 )
	    ayahLineNumber=1338
	    ;;
	009104 )
	    ayahLineNumber=1339
	    ;;
	009105 )
	    ayahLineNumber=1340
	    ;;
	009106 )
	    ayahLineNumber=1341
	    ;;
	009107 )
	    ayahLineNumber=1342
	    ;;
	009108 )
	    ayahLineNumber=1343
	    ;;
	009109 )
	    ayahLineNumber=1344
	    ;;
	009110 )
	    ayahLineNumber=1345
	    ;;
	009111 )
	    ayahLineNumber=1346
	    ;;
	009112 )
	    ayahLineNumber=1347
	    ;;
	009113 )
	    ayahLineNumber=1348
	    ;;
	009114 )
	    ayahLineNumber=1349
	    ;;
	009115 )
	    ayahLineNumber=1350
	    ;;
	009116 )
	    ayahLineNumber=1351
	    ;;
	009117 )
	    ayahLineNumber=1352
	    ;;
	009118 )
	    ayahLineNumber=1353
	    ;;
	009119 )
	    ayahLineNumber=1354
	    ;;
	009120 )
	    ayahLineNumber=1355
	    ;;
	009121 )
	    ayahLineNumber=1356
	    ;;
	009122 )
	    ayahLineNumber=1357
	    ;;
	009123 )
	    ayahLineNumber=1358
	    ;;
	009124 )
	    ayahLineNumber=1359
	    ;;
	009125 )
	    ayahLineNumber=1360
	    ;;
	009126 )
	    ayahLineNumber=1361
	    ;;
	009127 )
	    ayahLineNumber=1362
	    ;;
	009128 )
	    ayahLineNumber=1363
	    ;;
	009129 )
	    ayahLineNumber=1364
	    ;;
	010001 )
	    ayahLineNumber=1365
	    ;;
	010002 )
	    ayahLineNumber=1366
	    ;;
	010003 )
	    ayahLineNumber=1367
	    ;;
	010004 )
	    ayahLineNumber=1368
	    ;;
	010005 )
	    ayahLineNumber=1369
	    ;;
	010006 )
	    ayahLineNumber=1370
	    ;;
	010007 )
	    ayahLineNumber=1371
	    ;;
	010008 )
	    ayahLineNumber=1372
	    ;;
	010009 )
	    ayahLineNumber=1373
	    ;;
	010010 )
	    ayahLineNumber=1374
	    ;;
	010011 )
	    ayahLineNumber=1375
	    ;;
	010012 )
	    ayahLineNumber=1376
	    ;;
	010013 )
	    ayahLineNumber=1377
	    ;;
	010014 )
	    ayahLineNumber=1378
	    ;;
	010015 )
	    ayahLineNumber=1379
	    ;;
	010016 )
	    ayahLineNumber=1380
	    ;;
	010017 )
	    ayahLineNumber=1381
	    ;;
	010018 )
	    ayahLineNumber=1382
	    ;;
	010019 )
	    ayahLineNumber=1383
	    ;;
	010020 )
	    ayahLineNumber=1384
	    ;;
	010021 )
	    ayahLineNumber=1385
	    ;;
	010022 )
	    ayahLineNumber=1386
	    ;;
	010023 )
	    ayahLineNumber=1387
	    ;;
	010024 )
	    ayahLineNumber=1388
	    ;;
	010025 )
	    ayahLineNumber=1389
	    ;;
	010026 )
	    ayahLineNumber=1390
	    ;;
	010027 )
	    ayahLineNumber=1391
	    ;;
	010028 )
	    ayahLineNumber=1392
	    ;;
	010029 )
	    ayahLineNumber=1393
	    ;;
	010030 )
	    ayahLineNumber=1394
	    ;;
	010031 )
	    ayahLineNumber=1395
	    ;;
	010032 )
	    ayahLineNumber=1396
	    ;;
	010033 )
	    ayahLineNumber=1397
	    ;;
	010034 )
	    ayahLineNumber=1398
	    ;;
	010035 )
	    ayahLineNumber=1399
	    ;;
	010036 )
	    ayahLineNumber=1400
	    ;;
	010037 )
	    ayahLineNumber=1401
	    ;;
	010038 )
	    ayahLineNumber=1402
	    ;;
	010039 )
	    ayahLineNumber=1403
	    ;;
	010040 )
	    ayahLineNumber=1404
	    ;;
	010041 )
	    ayahLineNumber=1405
	    ;;
	010042 )
	    ayahLineNumber=1406
	    ;;
	010043 )
	    ayahLineNumber=1407
	    ;;
	010044 )
	    ayahLineNumber=1408
	    ;;
	010045 )
	    ayahLineNumber=1409
	    ;;
	010046 )
	    ayahLineNumber=1410
	    ;;
	010047 )
	    ayahLineNumber=1411
	    ;;
	010048 )
	    ayahLineNumber=1412
	    ;;
	010049 )
	    ayahLineNumber=1413
	    ;;
	010050 )
	    ayahLineNumber=1414
	    ;;
	010051 )
	    ayahLineNumber=1415
	    ;;
	010052 )
	    ayahLineNumber=1416
	    ;;
	010053 )
	    ayahLineNumber=1417
	    ;;
	010054 )
	    ayahLineNumber=1418
	    ;;
	010055 )
	    ayahLineNumber=1419
	    ;;
	010056 )
	    ayahLineNumber=1420
	    ;;
	010057 )
	    ayahLineNumber=1421
	    ;;
	010058 )
	    ayahLineNumber=1422
	    ;;
	010059 )
	    ayahLineNumber=1423
	    ;;
	010060 )
	    ayahLineNumber=1424
	    ;;
	010061 )
	    ayahLineNumber=1425
	    ;;
	010062 )
	    ayahLineNumber=1426
	    ;;
	010063 )
	    ayahLineNumber=1427
	    ;;
	010064 )
	    ayahLineNumber=1428
	    ;;
	010065 )
	    ayahLineNumber=1429
	    ;;
	010066 )
	    ayahLineNumber=1430
	    ;;
	010067 )
	    ayahLineNumber=1431
	    ;;
	010068 )
	    ayahLineNumber=1432
	    ;;
	010069 )
	    ayahLineNumber=1433
	    ;;
	010070 )
	    ayahLineNumber=1434
	    ;;
	010071 )
	    ayahLineNumber=1435
	    ;;
	010072 )
	    ayahLineNumber=1436
	    ;;
	010073 )
	    ayahLineNumber=1437
	    ;;
	010074 )
	    ayahLineNumber=1438
	    ;;
	010075 )
	    ayahLineNumber=1439
	    ;;
	010076 )
	    ayahLineNumber=1440
	    ;;
	010077 )
	    ayahLineNumber=1441
	    ;;
	010078 )
	    ayahLineNumber=1442
	    ;;
	010079 )
	    ayahLineNumber=1443
	    ;;
	010080 )
	    ayahLineNumber=1444
	    ;;
	010081 )
	    ayahLineNumber=1445
	    ;;
	010082 )
	    ayahLineNumber=1446
	    ;;
	010083 )
	    ayahLineNumber=1447
	    ;;
	010084 )
	    ayahLineNumber=1448
	    ;;
	010085 )
	    ayahLineNumber=1449
	    ;;
	010086 )
	    ayahLineNumber=1450
	    ;;
	010087 )
	    ayahLineNumber=1451
	    ;;
	010088 )
	    ayahLineNumber=1452
	    ;;
	010089 )
	    ayahLineNumber=1453
	    ;;
	010090 )
	    ayahLineNumber=1454
	    ;;
	010091 )
	    ayahLineNumber=1455
	    ;;
	010092 )
	    ayahLineNumber=1456
	    ;;
	010093 )
	    ayahLineNumber=1457
	    ;;
	010094 )
	    ayahLineNumber=1458
	    ;;
	010095 )
	    ayahLineNumber=1459
	    ;;
	010096 )
	    ayahLineNumber=1460
	    ;;
	010097 )
	    ayahLineNumber=1461
	    ;;
	010098 )
	    ayahLineNumber=1462
	    ;;
	010099 )
	    ayahLineNumber=1463
	    ;;
	010100 )
	    ayahLineNumber=1464
	    ;;
	010101 )
	    ayahLineNumber=1465
	    ;;
	010102 )
	    ayahLineNumber=1466
	    ;;
	010103 )
	    ayahLineNumber=1467
	    ;;
	010104 )
	    ayahLineNumber=1468
	    ;;
	010105 )
	    ayahLineNumber=1469
	    ;;
	010106 )
	    ayahLineNumber=1470
	    ;;
	010107 )
	    ayahLineNumber=1471
	    ;;
	010108 )
	    ayahLineNumber=1472
	    ;;
	010109 )
	    ayahLineNumber=1473
	    ;;
	011001 )
	    ayahLineNumber=1474
	    ;;
	011002 )
	    ayahLineNumber=1475
	    ;;
	011003 )
	    ayahLineNumber=1476
	    ;;
	011004 )
	    ayahLineNumber=1477
	    ;;
	011005 )
	    ayahLineNumber=1478
	    ;;
	011006 )
	    ayahLineNumber=1479
	    ;;
	011007 )
	    ayahLineNumber=1480
	    ;;
	011008 )
	    ayahLineNumber=1481
	    ;;
	011009 )
	    ayahLineNumber=1482
	    ;;
	011010 )
	    ayahLineNumber=1483
	    ;;
	011011 )
	    ayahLineNumber=1484
	    ;;
	011012 )
	    ayahLineNumber=1485
	    ;;
	011013 )
	    ayahLineNumber=1486
	    ;;
	011014 )
	    ayahLineNumber=1487
	    ;;
	011015 )
	    ayahLineNumber=1488
	    ;;
	011016 )
	    ayahLineNumber=1489
	    ;;
	011017 )
	    ayahLineNumber=1490
	    ;;
	011018 )
	    ayahLineNumber=1491
	    ;;
	011019 )
	    ayahLineNumber=1492
	    ;;
	011020 )
	    ayahLineNumber=1493
	    ;;
	011021 )
	    ayahLineNumber=1494
	    ;;
	011022 )
	    ayahLineNumber=1495
	    ;;
	011023 )
	    ayahLineNumber=1496
	    ;;
	011024 )
	    ayahLineNumber=1497
	    ;;
	011025 )
	    ayahLineNumber=1498
	    ;;
	011026 )
	    ayahLineNumber=1499
	    ;;
	011027 )
	    ayahLineNumber=1500
	    ;;
	011028 )
	    ayahLineNumber=1501
	    ;;
	011029 )
	    ayahLineNumber=1502
	    ;;
	011030 )
	    ayahLineNumber=1503
	    ;;
	011031 )
	    ayahLineNumber=1504
	    ;;
	011032 )
	    ayahLineNumber=1505
	    ;;
	011033 )
	    ayahLineNumber=1506
	    ;;
	011034 )
	    ayahLineNumber=1507
	    ;;
	011035 )
	    ayahLineNumber=1508
	    ;;
	011036 )
	    ayahLineNumber=1509
	    ;;
	011037 )
	    ayahLineNumber=1510
	    ;;
	011038 )
	    ayahLineNumber=1511
	    ;;
	011039 )
	    ayahLineNumber=1512
	    ;;
	011040 )
	    ayahLineNumber=1513
	    ;;
	011041 )
	    ayahLineNumber=1514
	    ;;
	011042 )
	    ayahLineNumber=1515
	    ;;
	011043 )
	    ayahLineNumber=1516
	    ;;
	011044 )
	    ayahLineNumber=1517
	    ;;
	011045 )
	    ayahLineNumber=1518
	    ;;
	011046 )
	    ayahLineNumber=1519
	    ;;
	011047 )
	    ayahLineNumber=1520
	    ;;
	011048 )
	    ayahLineNumber=1521
	    ;;
	011049 )
	    ayahLineNumber=1522
	    ;;
	011050 )
	    ayahLineNumber=1523
	    ;;
	011051 )
	    ayahLineNumber=1524
	    ;;
	011052 )
	    ayahLineNumber=1525
	    ;;
	011053 )
	    ayahLineNumber=1526
	    ;;
	011054 )
	    ayahLineNumber=1527
	    ;;
	011055 )
	    ayahLineNumber=1528
	    ;;
	011056 )
	    ayahLineNumber=1529
	    ;;
	011057 )
	    ayahLineNumber=1530
	    ;;
	011058 )
	    ayahLineNumber=1531
	    ;;
	011059 )
	    ayahLineNumber=1532
	    ;;
	011060 )
	    ayahLineNumber=1533
	    ;;
	011061 )
	    ayahLineNumber=1534
	    ;;
	011062 )
	    ayahLineNumber=1535
	    ;;
	011063 )
	    ayahLineNumber=1536
	    ;;
	011064 )
	    ayahLineNumber=1537
	    ;;
	011065 )
	    ayahLineNumber=1538
	    ;;
	011066 )
	    ayahLineNumber=1539
	    ;;
	011067 )
	    ayahLineNumber=1540
	    ;;
	011068 )
	    ayahLineNumber=1541
	    ;;
	011069 )
	    ayahLineNumber=1542
	    ;;
	011070 )
	    ayahLineNumber=1543
	    ;;
	011071 )
	    ayahLineNumber=1544
	    ;;
	011072 )
	    ayahLineNumber=1545
	    ;;
	011073 )
	    ayahLineNumber=1546
	    ;;
	011074 )
	    ayahLineNumber=1547
	    ;;
	011075 )
	    ayahLineNumber=1548
	    ;;
	011076 )
	    ayahLineNumber=1549
	    ;;
	011077 )
	    ayahLineNumber=1550
	    ;;
	011078 )
	    ayahLineNumber=1551
	    ;;
	011079 )
	    ayahLineNumber=1552
	    ;;
	011080 )
	    ayahLineNumber=1553
	    ;;
	011081 )
	    ayahLineNumber=1554
	    ;;
	011082 )
	    ayahLineNumber=1555
	    ;;
	011083 )
	    ayahLineNumber=1556
	    ;;
	011084 )
	    ayahLineNumber=1557
	    ;;
	011085 )
	    ayahLineNumber=1558
	    ;;
	011086 )
	    ayahLineNumber=1559
	    ;;
	011087 )
	    ayahLineNumber=1560
	    ;;
	011088 )
	    ayahLineNumber=1561
	    ;;
	011089 )
	    ayahLineNumber=1562
	    ;;
	011090 )
	    ayahLineNumber=1563
	    ;;
	011091 )
	    ayahLineNumber=1564
	    ;;
	011092 )
	    ayahLineNumber=1565
	    ;;
	011093 )
	    ayahLineNumber=1566
	    ;;
	011094 )
	    ayahLineNumber=1567
	    ;;
	011095 )
	    ayahLineNumber=1568
	    ;;
	011096 )
	    ayahLineNumber=1569
	    ;;
	011097 )
	    ayahLineNumber=1570
	    ;;
	011098 )
	    ayahLineNumber=1571
	    ;;
	011099 )
	    ayahLineNumber=1572
	    ;;
	011100 )
	    ayahLineNumber=1573
	    ;;
	011101 )
	    ayahLineNumber=1574
	    ;;
	011102 )
	    ayahLineNumber=1575
	    ;;
	011103 )
	    ayahLineNumber=1576
	    ;;
	011104 )
	    ayahLineNumber=1577
	    ;;
	011105 )
	    ayahLineNumber=1578
	    ;;
	011106 )
	    ayahLineNumber=1579
	    ;;
	011107 )
	    ayahLineNumber=1580
	    ;;
	011108 )
	    ayahLineNumber=1581
	    ;;
	011109 )
	    ayahLineNumber=1582
	    ;;
	011110 )
	    ayahLineNumber=1583
	    ;;
	011111 )
	    ayahLineNumber=1584
	    ;;
	011112 )
	    ayahLineNumber=1585
	    ;;
	011113 )
	    ayahLineNumber=1586
	    ;;
	011114 )
	    ayahLineNumber=1587
	    ;;
	011115 )
	    ayahLineNumber=1588
	    ;;
	011116 )
	    ayahLineNumber=1589
	    ;;
	011117 )
	    ayahLineNumber=1590
	    ;;
	011118 )
	    ayahLineNumber=1591
	    ;;
	011119 )
	    ayahLineNumber=1592
	    ;;
	011120 )
	    ayahLineNumber=1593
	    ;;
	011121 )
	    ayahLineNumber=1594
	    ;;
	011122 )
	    ayahLineNumber=1595
	    ;;
	011123 )
	    ayahLineNumber=1596
	    ;;
	012001 )
	    ayahLineNumber=1597
	    ;;
	012002 )
	    ayahLineNumber=1598
	    ;;
	012003 )
	    ayahLineNumber=1599
	    ;;
	012004 )
	    ayahLineNumber=1600
	    ;;
	012005 )
	    ayahLineNumber=1601
	    ;;
	012006 )
	    ayahLineNumber=1602
	    ;;
	012007 )
	    ayahLineNumber=1603
	    ;;
	012008 )
	    ayahLineNumber=1604
	    ;;
	012009 )
	    ayahLineNumber=1605
	    ;;
	012010 )
	    ayahLineNumber=1606
	    ;;
	012011 )
	    ayahLineNumber=1607
	    ;;
	012012 )
	    ayahLineNumber=1608
	    ;;
	012013 )
	    ayahLineNumber=1609
	    ;;
	012014 )
	    ayahLineNumber=1610
	    ;;
	012015 )
	    ayahLineNumber=1611
	    ;;
	012016 )
	    ayahLineNumber=1612
	    ;;
	012017 )
	    ayahLineNumber=1613
	    ;;
	012018 )
	    ayahLineNumber=1614
	    ;;
	012019 )
	    ayahLineNumber=1615
	    ;;
	012020 )
	    ayahLineNumber=1616
	    ;;
	012021 )
	    ayahLineNumber=1617
	    ;;
	012022 )
	    ayahLineNumber=1618
	    ;;
	012023 )
	    ayahLineNumber=1619
	    ;;
	012024 )
	    ayahLineNumber=1620
	    ;;
	012025 )
	    ayahLineNumber=1621
	    ;;
	012026 )
	    ayahLineNumber=1622
	    ;;
	012027 )
	    ayahLineNumber=1623
	    ;;
	012028 )
	    ayahLineNumber=1624
	    ;;
	012029 )
	    ayahLineNumber=1625
	    ;;
	012030 )
	    ayahLineNumber=1626
	    ;;
	012031 )
	    ayahLineNumber=1627
	    ;;
	012032 )
	    ayahLineNumber=1628
	    ;;
	012033 )
	    ayahLineNumber=1629
	    ;;
	012034 )
	    ayahLineNumber=1630
	    ;;
	012035 )
	    ayahLineNumber=1631
	    ;;
	012036 )
	    ayahLineNumber=1632
	    ;;
	012037 )
	    ayahLineNumber=1633
	    ;;
	012038 )
	    ayahLineNumber=1634
	    ;;
	012039 )
	    ayahLineNumber=1635
	    ;;
	012040 )
	    ayahLineNumber=1636
	    ;;
	012041 )
	    ayahLineNumber=1637
	    ;;
	012042 )
	    ayahLineNumber=1638
	    ;;
	012043 )
	    ayahLineNumber=1639
	    ;;
	012044 )
	    ayahLineNumber=1640
	    ;;
	012045 )
	    ayahLineNumber=1641
	    ;;
	012046 )
	    ayahLineNumber=1642
	    ;;
	012047 )
	    ayahLineNumber=1643
	    ;;
	012048 )
	    ayahLineNumber=1644
	    ;;
	012049 )
	    ayahLineNumber=1645
	    ;;
	012050 )
	    ayahLineNumber=1646
	    ;;
	012051 )
	    ayahLineNumber=1647
	    ;;
	012052 )
	    ayahLineNumber=1648
	    ;;
	012053 )
	    ayahLineNumber=1649
	    ;;
	012054 )
	    ayahLineNumber=1650
	    ;;
	012055 )
	    ayahLineNumber=1651
	    ;;
	012056 )
	    ayahLineNumber=1652
	    ;;
	012057 )
	    ayahLineNumber=1653
	    ;;
	012058 )
	    ayahLineNumber=1654
	    ;;
	012059 )
	    ayahLineNumber=1655
	    ;;
	012060 )
	    ayahLineNumber=1656
	    ;;
	012061 )
	    ayahLineNumber=1657
	    ;;
	012062 )
	    ayahLineNumber=1658
	    ;;
	012063 )
	    ayahLineNumber=1659
	    ;;
	012064 )
	    ayahLineNumber=1660
	    ;;
	012065 )
	    ayahLineNumber=1661
	    ;;
	012066 )
	    ayahLineNumber=1662
	    ;;
	012067 )
	    ayahLineNumber=1663
	    ;;
	012068 )
	    ayahLineNumber=1664
	    ;;
	012069 )
	    ayahLineNumber=1665
	    ;;
	012070 )
	    ayahLineNumber=1666
	    ;;
	012071 )
	    ayahLineNumber=1667
	    ;;
	012072 )
	    ayahLineNumber=1668
	    ;;
	012073 )
	    ayahLineNumber=1669
	    ;;
	012074 )
	    ayahLineNumber=1670
	    ;;
	012075 )
	    ayahLineNumber=1671
	    ;;
	012076 )
	    ayahLineNumber=1672
	    ;;
	012077 )
	    ayahLineNumber=1673
	    ;;
	012078 )
	    ayahLineNumber=1674
	    ;;
	012079 )
	    ayahLineNumber=1675
	    ;;
	012080 )
	    ayahLineNumber=1676
	    ;;
	012081 )
	    ayahLineNumber=1677
	    ;;
	012082 )
	    ayahLineNumber=1678
	    ;;
	012083 )
	    ayahLineNumber=1679
	    ;;
	012084 )
	    ayahLineNumber=1680
	    ;;
	012085 )
	    ayahLineNumber=1681
	    ;;
	012086 )
	    ayahLineNumber=1682
	    ;;
	012087 )
	    ayahLineNumber=1683
	    ;;
	012088 )
	    ayahLineNumber=1684
	    ;;
	012089 )
	    ayahLineNumber=1685
	    ;;
	012090 )
	    ayahLineNumber=1686
	    ;;
	012091 )
	    ayahLineNumber=1687
	    ;;
	012092 )
	    ayahLineNumber=1688
	    ;;
	012093 )
	    ayahLineNumber=1689
	    ;;
	012094 )
	    ayahLineNumber=1690
	    ;;
	012095 )
	    ayahLineNumber=1691
	    ;;
	012096 )
	    ayahLineNumber=1692
	    ;;
	012097 )
	    ayahLineNumber=1693
	    ;;
	012098 )
	    ayahLineNumber=1694
	    ;;
	012099 )
	    ayahLineNumber=1695
	    ;;
	012100 )
	    ayahLineNumber=1696
	    ;;
	012101 )
	    ayahLineNumber=1697
	    ;;
	012102 )
	    ayahLineNumber=1698
	    ;;
	012103 )
	    ayahLineNumber=1699
	    ;;
	012104 )
	    ayahLineNumber=1700
	    ;;
	012105 )
	    ayahLineNumber=1701
	    ;;
	012106 )
	    ayahLineNumber=1702
	    ;;
	012107 )
	    ayahLineNumber=1703
	    ;;
	012108 )
	    ayahLineNumber=1704
	    ;;
	012109 )
	    ayahLineNumber=1705
	    ;;
	012110 )
	    ayahLineNumber=1706
	    ;;
	012111 )
	    ayahLineNumber=1707
	    ;;
	013001 )
	    ayahLineNumber=1708
	    ;;
	013002 )
	    ayahLineNumber=1709
	    ;;
	013003 )
	    ayahLineNumber=1710
	    ;;
	013004 )
	    ayahLineNumber=1711
	    ;;
	013005 )
	    ayahLineNumber=1712
	    ;;
	013006 )
	    ayahLineNumber=1713
	    ;;
	013007 )
	    ayahLineNumber=1714
	    ;;
	013008 )
	    ayahLineNumber=1715
	    ;;
	013009 )
	    ayahLineNumber=1716
	    ;;
	013010 )
	    ayahLineNumber=1717
	    ;;
	013011 )
	    ayahLineNumber=1718
	    ;;
	013012 )
	    ayahLineNumber=1719
	    ;;
	013013 )
	    ayahLineNumber=1720
	    ;;
	013014 )
	    ayahLineNumber=1721
	    ;;
	013015 )
	    ayahLineNumber=1722
	    ;;
	013016 )
	    ayahLineNumber=1723
	    ;;
	013017 )
	    ayahLineNumber=1724
	    ;;
	013018 )
	    ayahLineNumber=1725
	    ;;
	013019 )
	    ayahLineNumber=1726
	    ;;
	013020 )
	    ayahLineNumber=1727
	    ;;
	013021 )
	    ayahLineNumber=1728
	    ;;
	013022 )
	    ayahLineNumber=1729
	    ;;
	013023 )
	    ayahLineNumber=1730
	    ;;
	013024 )
	    ayahLineNumber=1731
	    ;;
	013025 )
	    ayahLineNumber=1732
	    ;;
	013026 )
	    ayahLineNumber=1733
	    ;;
	013027 )
	    ayahLineNumber=1734
	    ;;
	013028 )
	    ayahLineNumber=1735
	    ;;
	013029 )
	    ayahLineNumber=1736
	    ;;
	013030 )
	    ayahLineNumber=1737
	    ;;
	013031 )
	    ayahLineNumber=1738
	    ;;
	013032 )
	    ayahLineNumber=1739
	    ;;
	013033 )
	    ayahLineNumber=1740
	    ;;
	013034 )
	    ayahLineNumber=1741
	    ;;
	013035 )
	    ayahLineNumber=1742
	    ;;
	013036 )
	    ayahLineNumber=1743
	    ;;
	013037 )
	    ayahLineNumber=1744
	    ;;
	013038 )
	    ayahLineNumber=1745
	    ;;
	013039 )
	    ayahLineNumber=1746
	    ;;
	013040 )
	    ayahLineNumber=1747
	    ;;
	013041 )
	    ayahLineNumber=1748
	    ;;
	013042 )
	    ayahLineNumber=1749
	    ;;
	013043 )
	    ayahLineNumber=1750
	    ;;
	014001 )
	    ayahLineNumber=1751
	    ;;
	014002 )
	    ayahLineNumber=1752
	    ;;
	014003 )
	    ayahLineNumber=1753
	    ;;
	014004 )
	    ayahLineNumber=1754
	    ;;
	014005 )
	    ayahLineNumber=1755
	    ;;
	014006 )
	    ayahLineNumber=1756
	    ;;
	014007 )
	    ayahLineNumber=1757
	    ;;
	014008 )
	    ayahLineNumber=1758
	    ;;
	014009 )
	    ayahLineNumber=1759
	    ;;
	014010 )
	    ayahLineNumber=1760
	    ;;
	014011 )
	    ayahLineNumber=1761
	    ;;
	014012 )
	    ayahLineNumber=1762
	    ;;
	014013 )
	    ayahLineNumber=1763
	    ;;
	014014 )
	    ayahLineNumber=1764
	    ;;
	014015 )
	    ayahLineNumber=1765
	    ;;
	014016 )
	    ayahLineNumber=1766
	    ;;
	014017 )
	    ayahLineNumber=1767
	    ;;
	014018 )
	    ayahLineNumber=1768
	    ;;
	014019 )
	    ayahLineNumber=1769
	    ;;
	014020 )
	    ayahLineNumber=1770
	    ;;
	014021 )
	    ayahLineNumber=1771
	    ;;
	014022 )
	    ayahLineNumber=1772
	    ;;
	014023 )
	    ayahLineNumber=1773
	    ;;
	014024 )
	    ayahLineNumber=1774
	    ;;
	014025 )
	    ayahLineNumber=1775
	    ;;
	014026 )
	    ayahLineNumber=1776
	    ;;
	014027 )
	    ayahLineNumber=1777
	    ;;
	014028 )
	    ayahLineNumber=1778
	    ;;
	014029 )
	    ayahLineNumber=1779
	    ;;
	014030 )
	    ayahLineNumber=1780
	    ;;
	014031 )
	    ayahLineNumber=1781
	    ;;
	014032 )
	    ayahLineNumber=1782
	    ;;
	014033 )
	    ayahLineNumber=1783
	    ;;
	014034 )
	    ayahLineNumber=1784
	    ;;
	014035 )
	    ayahLineNumber=1785
	    ;;
	014036 )
	    ayahLineNumber=1786
	    ;;
	014037 )
	    ayahLineNumber=1787
	    ;;
	014038 )
	    ayahLineNumber=1788
	    ;;
	014039 )
	    ayahLineNumber=1789
	    ;;
	014040 )
	    ayahLineNumber=1790
	    ;;
	014041 )
	    ayahLineNumber=1791
	    ;;
	014042 )
	    ayahLineNumber=1792
	    ;;
	014043 )
	    ayahLineNumber=1793
	    ;;
	014044 )
	    ayahLineNumber=1794
	    ;;
	014045 )
	    ayahLineNumber=1795
	    ;;
	014046 )
	    ayahLineNumber=1796
	    ;;
	014047 )
	    ayahLineNumber=1797
	    ;;
	014048 )
	    ayahLineNumber=1798
	    ;;
	014049 )
	    ayahLineNumber=1799
	    ;;
	014050 )
	    ayahLineNumber=1800
	    ;;
	014051 )
	    ayahLineNumber=1801
	    ;;
	014052 )
	    ayahLineNumber=1802
	    ;;
	015001 )
	    ayahLineNumber=1803
	    ;;
	015002 )
	    ayahLineNumber=1804
	    ;;
	015003 )
	    ayahLineNumber=1805
	    ;;
	015004 )
	    ayahLineNumber=1806
	    ;;
	015005 )
	    ayahLineNumber=1807
	    ;;
	015006 )
	    ayahLineNumber=1808
	    ;;
	015007 )
	    ayahLineNumber=1809
	    ;;
	015008 )
	    ayahLineNumber=1810
	    ;;
	015009 )
	    ayahLineNumber=1811
	    ;;
	015010 )
	    ayahLineNumber=1812
	    ;;
	015011 )
	    ayahLineNumber=1813
	    ;;
	015012 )
	    ayahLineNumber=1814
	    ;;
	015013 )
	    ayahLineNumber=1815
	    ;;
	015014 )
	    ayahLineNumber=1816
	    ;;
	015015 )
	    ayahLineNumber=1817
	    ;;
	015016 )
	    ayahLineNumber=1818
	    ;;
	015017 )
	    ayahLineNumber=1819
	    ;;
	015018 )
	    ayahLineNumber=1820
	    ;;
	015019 )
	    ayahLineNumber=1821
	    ;;
	015020 )
	    ayahLineNumber=1822
	    ;;
	015021 )
	    ayahLineNumber=1823
	    ;;
	015022 )
	    ayahLineNumber=1824
	    ;;
	015023 )
	    ayahLineNumber=1825
	    ;;
	015024 )
	    ayahLineNumber=1826
	    ;;
	015025 )
	    ayahLineNumber=1827
	    ;;
	015026 )
	    ayahLineNumber=1828
	    ;;
	015027 )
	    ayahLineNumber=1829
	    ;;
	015028 )
	    ayahLineNumber=1830
	    ;;
	015029 )
	    ayahLineNumber=1831
	    ;;
	015030 )
	    ayahLineNumber=1832
	    ;;
	015031 )
	    ayahLineNumber=1833
	    ;;
	015032 )
	    ayahLineNumber=1834
	    ;;
	015033 )
	    ayahLineNumber=1835
	    ;;
	015034 )
	    ayahLineNumber=1836
	    ;;
	015035 )
	    ayahLineNumber=1837
	    ;;
	015036 )
	    ayahLineNumber=1838
	    ;;
	015037 )
	    ayahLineNumber=1839
	    ;;
	015038 )
	    ayahLineNumber=1840
	    ;;
	015039 )
	    ayahLineNumber=1841
	    ;;
	015040 )
	    ayahLineNumber=1842
	    ;;
	015041 )
	    ayahLineNumber=1843
	    ;;
	015042 )
	    ayahLineNumber=1844
	    ;;
	015043 )
	    ayahLineNumber=1845
	    ;;
	015044 )
	    ayahLineNumber=1846
	    ;;
	015045 )
	    ayahLineNumber=1847
	    ;;
	015046 )
	    ayahLineNumber=1848
	    ;;
	015047 )
	    ayahLineNumber=1849
	    ;;
	015048 )
	    ayahLineNumber=1850
	    ;;
	015049 )
	    ayahLineNumber=1851
	    ;;
	015050 )
	    ayahLineNumber=1852
	    ;;
	015051 )
	    ayahLineNumber=1853
	    ;;
	015052 )
	    ayahLineNumber=1854
	    ;;
	015053 )
	    ayahLineNumber=1855
	    ;;
	015054 )
	    ayahLineNumber=1856
	    ;;
	015055 )
	    ayahLineNumber=1857
	    ;;
	015056 )
	    ayahLineNumber=1858
	    ;;
	015057 )
	    ayahLineNumber=1859
	    ;;
	015058 )
	    ayahLineNumber=1860
	    ;;
	015059 )
	    ayahLineNumber=1861
	    ;;
	015060 )
	    ayahLineNumber=1862
	    ;;
	015061 )
	    ayahLineNumber=1863
	    ;;
	015062 )
	    ayahLineNumber=1864
	    ;;
	015063 )
	    ayahLineNumber=1865
	    ;;
	015064 )
	    ayahLineNumber=1866
	    ;;
	015065 )
	    ayahLineNumber=1867
	    ;;
	015066 )
	    ayahLineNumber=1868
	    ;;
	015067 )
	    ayahLineNumber=1869
	    ;;
	015068 )
	    ayahLineNumber=1870
	    ;;
	015069 )
	    ayahLineNumber=1871
	    ;;
	015070 )
	    ayahLineNumber=1872
	    ;;
	015071 )
	    ayahLineNumber=1873
	    ;;
	015072 )
	    ayahLineNumber=1874
	    ;;
	015073 )
	    ayahLineNumber=1875
	    ;;
	015074 )
	    ayahLineNumber=1876
	    ;;
	015075 )
	    ayahLineNumber=1877
	    ;;
	015076 )
	    ayahLineNumber=1878
	    ;;
	015077 )
	    ayahLineNumber=1879
	    ;;
	015078 )
	    ayahLineNumber=1880
	    ;;
	015079 )
	    ayahLineNumber=1881
	    ;;
	015080 )
	    ayahLineNumber=1882
	    ;;
	015081 )
	    ayahLineNumber=1883
	    ;;
	015082 )
	    ayahLineNumber=1884
	    ;;
	015083 )
	    ayahLineNumber=1885
	    ;;
	015084 )
	    ayahLineNumber=1886
	    ;;
	015085 )
	    ayahLineNumber=1887
	    ;;
	015086 )
	    ayahLineNumber=1888
	    ;;
	015087 )
	    ayahLineNumber=1889
	    ;;
	015088 )
	    ayahLineNumber=1890
	    ;;
	015089 )
	    ayahLineNumber=1891
	    ;;
	015090 )
	    ayahLineNumber=1892
	    ;;
	015091 )
	    ayahLineNumber=1893
	    ;;
	015092 )
	    ayahLineNumber=1894
	    ;;
	015093 )
	    ayahLineNumber=1895
	    ;;
	015094 )
	    ayahLineNumber=1896
	    ;;
	015095 )
	    ayahLineNumber=1897
	    ;;
	015096 )
	    ayahLineNumber=1898
	    ;;
	015097 )
	    ayahLineNumber=1899
	    ;;
	015098 )
	    ayahLineNumber=1900
	    ;;
	015099 )
	    ayahLineNumber=1901
	    ;;
	016001 )
	    ayahLineNumber=1902
	    ;;
	016002 )
	    ayahLineNumber=1903
	    ;;
	016003 )
	    ayahLineNumber=1904
	    ;;
	016004 )
	    ayahLineNumber=1905
	    ;;
	016005 )
	    ayahLineNumber=1906
	    ;;
	016006 )
	    ayahLineNumber=1907
	    ;;
	016007 )
	    ayahLineNumber=1908
	    ;;
	016008 )
	    ayahLineNumber=1909
	    ;;
	016009 )
	    ayahLineNumber=1910
	    ;;
	016010 )
	    ayahLineNumber=1911
	    ;;
	016011 )
	    ayahLineNumber=1912
	    ;;
	016012 )
	    ayahLineNumber=1913
	    ;;
	016013 )
	    ayahLineNumber=1914
	    ;;
	016014 )
	    ayahLineNumber=1915
	    ;;
	016015 )
	    ayahLineNumber=1916
	    ;;
	016016 )
	    ayahLineNumber=1917
	    ;;
	016017 )
	    ayahLineNumber=1918
	    ;;
	016018 )
	    ayahLineNumber=1919
	    ;;
	016019 )
	    ayahLineNumber=1920
	    ;;
	016020 )
	    ayahLineNumber=1921
	    ;;
	016021 )
	    ayahLineNumber=1922
	    ;;
	016022 )
	    ayahLineNumber=1923
	    ;;
	016023 )
	    ayahLineNumber=1924
	    ;;
	016024 )
	    ayahLineNumber=1925
	    ;;
	016025 )
	    ayahLineNumber=1926
	    ;;
	016026 )
	    ayahLineNumber=1927
	    ;;
	016027 )
	    ayahLineNumber=1928
	    ;;
	016028 )
	    ayahLineNumber=1929
	    ;;
	016029 )
	    ayahLineNumber=1930
	    ;;
	016030 )
	    ayahLineNumber=1931
	    ;;
	016031 )
	    ayahLineNumber=1932
	    ;;
	016032 )
	    ayahLineNumber=1933
	    ;;
	016033 )
	    ayahLineNumber=1934
	    ;;
	016034 )
	    ayahLineNumber=1935
	    ;;
	016035 )
	    ayahLineNumber=1936
	    ;;
	016036 )
	    ayahLineNumber=1937
	    ;;
	016037 )
	    ayahLineNumber=1938
	    ;;
	016038 )
	    ayahLineNumber=1939
	    ;;
	016039 )
	    ayahLineNumber=1940
	    ;;
	016040 )
	    ayahLineNumber=1941
	    ;;
	016041 )
	    ayahLineNumber=1942
	    ;;
	016042 )
	    ayahLineNumber=1943
	    ;;
	016043 )
	    ayahLineNumber=1944
	    ;;
	016044 )
	    ayahLineNumber=1945
	    ;;
	016045 )
	    ayahLineNumber=1946
	    ;;
	016046 )
	    ayahLineNumber=1947
	    ;;
	016047 )
	    ayahLineNumber=1948
	    ;;
	016048 )
	    ayahLineNumber=1949
	    ;;
	016049 )
	    ayahLineNumber=1950
	    ;;
	016050 )
	    ayahLineNumber=1951
	    ;;
	016051 )
	    ayahLineNumber=1952
	    ;;
	016052 )
	    ayahLineNumber=1953
	    ;;
	016053 )
	    ayahLineNumber=1954
	    ;;
	016054 )
	    ayahLineNumber=1955
	    ;;
	016055 )
	    ayahLineNumber=1956
	    ;;
	016056 )
	    ayahLineNumber=1957
	    ;;
	016057 )
	    ayahLineNumber=1958
	    ;;
	016058 )
	    ayahLineNumber=1959
	    ;;
	016059 )
	    ayahLineNumber=1960
	    ;;
	016060 )
	    ayahLineNumber=1961
	    ;;
	016061 )
	    ayahLineNumber=1962
	    ;;
	016062 )
	    ayahLineNumber=1963
	    ;;
	016063 )
	    ayahLineNumber=1964
	    ;;
	016064 )
	    ayahLineNumber=1965
	    ;;
	016065 )
	    ayahLineNumber=1966
	    ;;
	016066 )
	    ayahLineNumber=1967
	    ;;
	016067 )
	    ayahLineNumber=1968
	    ;;
	016068 )
	    ayahLineNumber=1969
	    ;;
	016069 )
	    ayahLineNumber=1970
	    ;;
	016070 )
	    ayahLineNumber=1971
	    ;;
	016071 )
	    ayahLineNumber=1972
	    ;;
	016072 )
	    ayahLineNumber=1973
	    ;;
	016073 )
	    ayahLineNumber=1974
	    ;;
	016074 )
	    ayahLineNumber=1975
	    ;;
	016075 )
	    ayahLineNumber=1976
	    ;;
	016076 )
	    ayahLineNumber=1977
	    ;;
	016077 )
	    ayahLineNumber=1978
	    ;;
	016078 )
	    ayahLineNumber=1979
	    ;;
	016079 )
	    ayahLineNumber=1980
	    ;;
	016080 )
	    ayahLineNumber=1981
	    ;;
	016081 )
	    ayahLineNumber=1982
	    ;;
	016082 )
	    ayahLineNumber=1983
	    ;;
	016083 )
	    ayahLineNumber=1984
	    ;;
	016084 )
	    ayahLineNumber=1985
	    ;;
	016085 )
	    ayahLineNumber=1986
	    ;;
	016086 )
	    ayahLineNumber=1987
	    ;;
	016087 )
	    ayahLineNumber=1988
	    ;;
	016088 )
	    ayahLineNumber=1989
	    ;;
	016089 )
	    ayahLineNumber=1990
	    ;;
	016090 )
	    ayahLineNumber=1991
	    ;;
	016091 )
	    ayahLineNumber=1992
	    ;;
	016092 )
	    ayahLineNumber=1993
	    ;;
	016093 )
	    ayahLineNumber=1994
	    ;;
	016094 )
	    ayahLineNumber=1995
	    ;;
	016095 )
	    ayahLineNumber=1996
	    ;;
	016096 )
	    ayahLineNumber=1997
	    ;;
	016097 )
	    ayahLineNumber=1998
	    ;;
	016098 )
	    ayahLineNumber=1999
	    ;;
	016099 )
	    ayahLineNumber=2000
	    ;;
	016100 )
	    ayahLineNumber=2001
	    ;;
	016101 )
	    ayahLineNumber=2002
	    ;;
	016102 )
	    ayahLineNumber=2003
	    ;;
	016103 )
	    ayahLineNumber=2004
	    ;;
	016104 )
	    ayahLineNumber=2005
	    ;;
	016105 )
	    ayahLineNumber=2006
	    ;;
	016106 )
	    ayahLineNumber=2007
	    ;;
	016107 )
	    ayahLineNumber=2008
	    ;;
	016108 )
	    ayahLineNumber=2009
	    ;;
	016109 )
	    ayahLineNumber=2010
	    ;;
	016110 )
	    ayahLineNumber=2011
	    ;;
	016111 )
	    ayahLineNumber=2012
	    ;;
	016112 )
	    ayahLineNumber=2013
	    ;;
	016113 )
	    ayahLineNumber=2014
	    ;;
	016114 )
	    ayahLineNumber=2015
	    ;;
	016115 )
	    ayahLineNumber=2016
	    ;;
	016116 )
	    ayahLineNumber=2017
	    ;;
	016117 )
	    ayahLineNumber=2018
	    ;;
	016118 )
	    ayahLineNumber=2019
	    ;;
	016119 )
	    ayahLineNumber=2020
	    ;;
	016120 )
	    ayahLineNumber=2021
	    ;;
	016121 )
	    ayahLineNumber=2022
	    ;;
	016122 )
	    ayahLineNumber=2023
	    ;;
	016123 )
	    ayahLineNumber=2024
	    ;;
	016124 )
	    ayahLineNumber=2025
	    ;;
	016125 )
	    ayahLineNumber=2026
	    ;;
	016126 )
	    ayahLineNumber=2027
	    ;;
	016127 )
	    ayahLineNumber=2028
	    ;;
	016128 )
	    ayahLineNumber=2029
	    ;;
	017001 )
	    ayahLineNumber=2030
	    ;;
	017002 )
	    ayahLineNumber=2031
	    ;;
	017003 )
	    ayahLineNumber=2032
	    ;;
	017004 )
	    ayahLineNumber=2033
	    ;;
	017005 )
	    ayahLineNumber=2034
	    ;;
	017006 )
	    ayahLineNumber=2035
	    ;;
	017007 )
	    ayahLineNumber=2036
	    ;;
	017008 )
	    ayahLineNumber=2037
	    ;;
	017009 )
	    ayahLineNumber=2038
	    ;;
	017010 )
	    ayahLineNumber=2039
	    ;;
	017011 )
	    ayahLineNumber=2040
	    ;;
	017012 )
	    ayahLineNumber=2041
	    ;;
	017013 )
	    ayahLineNumber=2042
	    ;;
	017014 )
	    ayahLineNumber=2043
	    ;;
	017015 )
	    ayahLineNumber=2044
	    ;;
	017016 )
	    ayahLineNumber=2045
	    ;;
	017017 )
	    ayahLineNumber=2046
	    ;;
	017018 )
	    ayahLineNumber=2047
	    ;;
	017019 )
	    ayahLineNumber=2048
	    ;;
	017020 )
	    ayahLineNumber=2049
	    ;;
	017021 )
	    ayahLineNumber=2050
	    ;;
	017022 )
	    ayahLineNumber=2051
	    ;;
	017023 )
	    ayahLineNumber=2052
	    ;;
	017024 )
	    ayahLineNumber=2053
	    ;;
	017025 )
	    ayahLineNumber=2054
	    ;;
	017026 )
	    ayahLineNumber=2055
	    ;;
	017027 )
	    ayahLineNumber=2056
	    ;;
	017028 )
	    ayahLineNumber=2057
	    ;;
	017029 )
	    ayahLineNumber=2058
	    ;;
	017030 )
	    ayahLineNumber=2059
	    ;;
	017031 )
	    ayahLineNumber=2060
	    ;;
	017032 )
	    ayahLineNumber=2061
	    ;;
	017033 )
	    ayahLineNumber=2062
	    ;;
	017034 )
	    ayahLineNumber=2063
	    ;;
	017035 )
	    ayahLineNumber=2064
	    ;;
	017036 )
	    ayahLineNumber=2065
	    ;;
	017037 )
	    ayahLineNumber=2066
	    ;;
	017038 )
	    ayahLineNumber=2067
	    ;;
	017039 )
	    ayahLineNumber=2068
	    ;;
	017040 )
	    ayahLineNumber=2069
	    ;;
	017041 )
	    ayahLineNumber=2070
	    ;;
	017042 )
	    ayahLineNumber=2071
	    ;;
	017043 )
	    ayahLineNumber=2072
	    ;;
	017044 )
	    ayahLineNumber=2073
	    ;;
	017045 )
	    ayahLineNumber=2074
	    ;;
	017046 )
	    ayahLineNumber=2075
	    ;;
	017047 )
	    ayahLineNumber=2076
	    ;;
	017048 )
	    ayahLineNumber=2077
	    ;;
	017049 )
	    ayahLineNumber=2078
	    ;;
	017050 )
	    ayahLineNumber=2079
	    ;;
	017051 )
	    ayahLineNumber=2080
	    ;;
	017052 )
	    ayahLineNumber=2081
	    ;;
	017053 )
	    ayahLineNumber=2082
	    ;;
	017054 )
	    ayahLineNumber=2083
	    ;;
	017055 )
	    ayahLineNumber=2084
	    ;;
	017056 )
	    ayahLineNumber=2085
	    ;;
	017057 )
	    ayahLineNumber=2086
	    ;;
	017058 )
	    ayahLineNumber=2087
	    ;;
	017059 )
	    ayahLineNumber=2088
	    ;;
	017060 )
	    ayahLineNumber=2089
	    ;;
	017061 )
	    ayahLineNumber=2090
	    ;;
	017062 )
	    ayahLineNumber=2091
	    ;;
	017063 )
	    ayahLineNumber=2092
	    ;;
	017064 )
	    ayahLineNumber=2093
	    ;;
	017065 )
	    ayahLineNumber=2094
	    ;;
	017066 )
	    ayahLineNumber=2095
	    ;;
	017067 )
	    ayahLineNumber=2096
	    ;;
	017068 )
	    ayahLineNumber=2097
	    ;;
	017069 )
	    ayahLineNumber=2098
	    ;;
	017070 )
	    ayahLineNumber=2099
	    ;;
	017071 )
	    ayahLineNumber=2100
	    ;;
	017072 )
	    ayahLineNumber=2101
	    ;;
	017073 )
	    ayahLineNumber=2102
	    ;;
	017074 )
	    ayahLineNumber=2103
	    ;;
	017075 )
	    ayahLineNumber=2104
	    ;;
	017076 )
	    ayahLineNumber=2105
	    ;;
	017077 )
	    ayahLineNumber=2106
	    ;;
	017078 )
	    ayahLineNumber=2107
	    ;;
	017079 )
	    ayahLineNumber=2108
	    ;;
	017080 )
	    ayahLineNumber=2109
	    ;;
	017081 )
	    ayahLineNumber=2110
	    ;;
	017082 )
	    ayahLineNumber=2111
	    ;;
	017083 )
	    ayahLineNumber=2112
	    ;;
	017084 )
	    ayahLineNumber=2113
	    ;;
	017085 )
	    ayahLineNumber=2114
	    ;;
	017086 )
	    ayahLineNumber=2115
	    ;;
	017087 )
	    ayahLineNumber=2116
	    ;;
	017088 )
	    ayahLineNumber=2117
	    ;;
	017089 )
	    ayahLineNumber=2118
	    ;;
	017090 )
	    ayahLineNumber=2119
	    ;;
	017091 )
	    ayahLineNumber=2120
	    ;;
	017092 )
	    ayahLineNumber=2121
	    ;;
	017093 )
	    ayahLineNumber=2122
	    ;;
	017094 )
	    ayahLineNumber=2123
	    ;;
	017095 )
	    ayahLineNumber=2124
	    ;;
	017096 )
	    ayahLineNumber=2125
	    ;;
	017097 )
	    ayahLineNumber=2126
	    ;;
	017098 )
	    ayahLineNumber=2127
	    ;;
	017099 )
	    ayahLineNumber=2128
	    ;;
	017100 )
	    ayahLineNumber=2129
	    ;;
	017101 )
	    ayahLineNumber=2130
	    ;;
	017102 )
	    ayahLineNumber=2131
	    ;;
	017103 )
	    ayahLineNumber=2132
	    ;;
	017104 )
	    ayahLineNumber=2133
	    ;;
	017105 )
	    ayahLineNumber=2134
	    ;;
	017106 )
	    ayahLineNumber=2135
	    ;;
	017107 )
	    ayahLineNumber=2136
	    ;;
	017108 )
	    ayahLineNumber=2137
	    ;;
	017109 )
	    ayahLineNumber=2138
	    ;;
	017110 )
	    ayahLineNumber=2139
	    ;;
	017111 )
	    ayahLineNumber=2140
	    ;;
	018001 )
	    ayahLineNumber=2141
	    ;;
	018002 )
	    ayahLineNumber=2142
	    ;;
	018003 )
	    ayahLineNumber=2143
	    ;;
	018004 )
	    ayahLineNumber=2144
	    ;;
	018005 )
	    ayahLineNumber=2145
	    ;;
	018006 )
	    ayahLineNumber=2146
	    ;;
	018007 )
	    ayahLineNumber=2147
	    ;;
	018008 )
	    ayahLineNumber=2148
	    ;;
	018009 )
	    ayahLineNumber=2149
	    ;;
	018010 )
	    ayahLineNumber=2150
	    ;;
	018011 )
	    ayahLineNumber=2151
	    ;;
	018012 )
	    ayahLineNumber=2152
	    ;;
	018013 )
	    ayahLineNumber=2153
	    ;;
	018014 )
	    ayahLineNumber=2154
	    ;;
	018015 )
	    ayahLineNumber=2155
	    ;;
	018016 )
	    ayahLineNumber=2156
	    ;;
	018017 )
	    ayahLineNumber=2157
	    ;;
	018018 )
	    ayahLineNumber=2158
	    ;;
	018019 )
	    ayahLineNumber=2159
	    ;;
	018020 )
	    ayahLineNumber=2160
	    ;;
	018021 )
	    ayahLineNumber=2161
	    ;;
	018022 )
	    ayahLineNumber=2162
	    ;;
	018023 )
	    ayahLineNumber=2163
	    ;;
	018024 )
	    ayahLineNumber=2164
	    ;;
	018025 )
	    ayahLineNumber=2165
	    ;;
	018026 )
	    ayahLineNumber=2166
	    ;;
	018027 )
	    ayahLineNumber=2167
	    ;;
	018028 )
	    ayahLineNumber=2168
	    ;;
	018029 )
	    ayahLineNumber=2169
	    ;;
	018030 )
	    ayahLineNumber=2170
	    ;;
	018031 )
	    ayahLineNumber=2171
	    ;;
	018032 )
	    ayahLineNumber=2172
	    ;;
	018033 )
	    ayahLineNumber=2173
	    ;;
	018034 )
	    ayahLineNumber=2174
	    ;;
	018035 )
	    ayahLineNumber=2175
	    ;;
	018036 )
	    ayahLineNumber=2176
	    ;;
	018037 )
	    ayahLineNumber=2177
	    ;;
	018038 )
	    ayahLineNumber=2178
	    ;;
	018039 )
	    ayahLineNumber=2179
	    ;;
	018040 )
	    ayahLineNumber=2180
	    ;;
	018041 )
	    ayahLineNumber=2181
	    ;;
	018042 )
	    ayahLineNumber=2182
	    ;;
	018043 )
	    ayahLineNumber=2183
	    ;;
	018044 )
	    ayahLineNumber=2184
	    ;;
	018045 )
	    ayahLineNumber=2185
	    ;;
	018046 )
	    ayahLineNumber=2186
	    ;;
	018047 )
	    ayahLineNumber=2187
	    ;;
	018048 )
	    ayahLineNumber=2188
	    ;;
	018049 )
	    ayahLineNumber=2189
	    ;;
	018050 )
	    ayahLineNumber=2190
	    ;;
	018051 )
	    ayahLineNumber=2191
	    ;;
	018052 )
	    ayahLineNumber=2192
	    ;;
	018053 )
	    ayahLineNumber=2193
	    ;;
	018054 )
	    ayahLineNumber=2194
	    ;;
	018055 )
	    ayahLineNumber=2195
	    ;;
	018056 )
	    ayahLineNumber=2196
	    ;;
	018057 )
	    ayahLineNumber=2197
	    ;;
	018058 )
	    ayahLineNumber=2198
	    ;;
	018059 )
	    ayahLineNumber=2199
	    ;;
	018060 )
	    ayahLineNumber=2200
	    ;;
	018061 )
	    ayahLineNumber=2201
	    ;;
	018062 )
	    ayahLineNumber=2202
	    ;;
	018063 )
	    ayahLineNumber=2203
	    ;;
	018064 )
	    ayahLineNumber=2204
	    ;;
	018065 )
	    ayahLineNumber=2205
	    ;;
	018066 )
	    ayahLineNumber=2206
	    ;;
	018067 )
	    ayahLineNumber=2207
	    ;;
	018068 )
	    ayahLineNumber=2208
	    ;;
	018069 )
	    ayahLineNumber=2209
	    ;;
	018070 )
	    ayahLineNumber=2210
	    ;;
	018071 )
	    ayahLineNumber=2211
	    ;;
	018072 )
	    ayahLineNumber=2212
	    ;;
	018073 )
	    ayahLineNumber=2213
	    ;;
	018074 )
	    ayahLineNumber=2214
	    ;;
	018075 )
	    ayahLineNumber=2215
	    ;;
	018076 )
	    ayahLineNumber=2216
	    ;;
	018077 )
	    ayahLineNumber=2217
	    ;;
	018078 )
	    ayahLineNumber=2218
	    ;;
	018079 )
	    ayahLineNumber=2219
	    ;;
	018080 )
	    ayahLineNumber=2220
	    ;;
	018081 )
	    ayahLineNumber=2221
	    ;;
	018082 )
	    ayahLineNumber=2222
	    ;;
	018083 )
	    ayahLineNumber=2223
	    ;;
	018084 )
	    ayahLineNumber=2224
	    ;;
	018085 )
	    ayahLineNumber=2225
	    ;;
	018086 )
	    ayahLineNumber=2226
	    ;;
	018087 )
	    ayahLineNumber=2227
	    ;;
	018088 )
	    ayahLineNumber=2228
	    ;;
	018089 )
	    ayahLineNumber=2229
	    ;;
	018090 )
	    ayahLineNumber=2230
	    ;;
	018091 )
	    ayahLineNumber=2231
	    ;;
	018092 )
	    ayahLineNumber=2232
	    ;;
	018093 )
	    ayahLineNumber=2233
	    ;;
	018094 )
	    ayahLineNumber=2234
	    ;;
	018095 )
	    ayahLineNumber=2235
	    ;;
	018096 )
	    ayahLineNumber=2236
	    ;;
	018097 )
	    ayahLineNumber=2237
	    ;;
	018098 )
	    ayahLineNumber=2238
	    ;;
	018099 )
	    ayahLineNumber=2239
	    ;;
	018100 )
	    ayahLineNumber=2240
	    ;;
	018101 )
	    ayahLineNumber=2241
	    ;;
	018102 )
	    ayahLineNumber=2242
	    ;;
	018103 )
	    ayahLineNumber=2243
	    ;;
	018104 )
	    ayahLineNumber=2244
	    ;;
	018105 )
	    ayahLineNumber=2245
	    ;;
	018106 )
	    ayahLineNumber=2246
	    ;;
	018107 )
	    ayahLineNumber=2247
	    ;;
	018108 )
	    ayahLineNumber=2248
	    ;;
	018109 )
	    ayahLineNumber=2249
	    ;;
	018110 )
	    ayahLineNumber=2250
	    ;;
	019001 )
	    ayahLineNumber=2251
	    ;;
	019002 )
	    ayahLineNumber=2252
	    ;;
	019003 )
	    ayahLineNumber=2253
	    ;;
	019004 )
	    ayahLineNumber=2254
	    ;;
	019005 )
	    ayahLineNumber=2255
	    ;;
	019006 )
	    ayahLineNumber=2256
	    ;;
	019007 )
	    ayahLineNumber=2257
	    ;;
	019008 )
	    ayahLineNumber=2258
	    ;;
	019009 )
	    ayahLineNumber=2259
	    ;;
	019010 )
	    ayahLineNumber=2260
	    ;;
	019011 )
	    ayahLineNumber=2261
	    ;;
	019012 )
	    ayahLineNumber=2262
	    ;;
	019013 )
	    ayahLineNumber=2263
	    ;;
	019014 )
	    ayahLineNumber=2264
	    ;;
	019015 )
	    ayahLineNumber=2265
	    ;;
	019016 )
	    ayahLineNumber=2266
	    ;;
	019017 )
	    ayahLineNumber=2267
	    ;;
	019018 )
	    ayahLineNumber=2268
	    ;;
	019019 )
	    ayahLineNumber=2269
	    ;;
	019020 )
	    ayahLineNumber=2270
	    ;;
	019021 )
	    ayahLineNumber=2271
	    ;;
	019022 )
	    ayahLineNumber=2272
	    ;;
	019023 )
	    ayahLineNumber=2273
	    ;;
	019024 )
	    ayahLineNumber=2274
	    ;;
	019025 )
	    ayahLineNumber=2275
	    ;;
	019026 )
	    ayahLineNumber=2276
	    ;;
	019027 )
	    ayahLineNumber=2277
	    ;;
	019028 )
	    ayahLineNumber=2278
	    ;;
	019029 )
	    ayahLineNumber=2279
	    ;;
	019030 )
	    ayahLineNumber=2280
	    ;;
	019031 )
	    ayahLineNumber=2281
	    ;;
	019032 )
	    ayahLineNumber=2282
	    ;;
	019033 )
	    ayahLineNumber=2283
	    ;;
	019034 )
	    ayahLineNumber=2284
	    ;;
	019035 )
	    ayahLineNumber=2285
	    ;;
	019036 )
	    ayahLineNumber=2286
	    ;;
	019037 )
	    ayahLineNumber=2287
	    ;;
	019038 )
	    ayahLineNumber=2288
	    ;;
	019039 )
	    ayahLineNumber=2289
	    ;;
	019040 )
	    ayahLineNumber=2290
	    ;;
	019041 )
	    ayahLineNumber=2291
	    ;;
	019042 )
	    ayahLineNumber=2292
	    ;;
	019043 )
	    ayahLineNumber=2293
	    ;;
	019044 )
	    ayahLineNumber=2294
	    ;;
	019045 )
	    ayahLineNumber=2295
	    ;;
	019046 )
	    ayahLineNumber=2296
	    ;;
	019047 )
	    ayahLineNumber=2297
	    ;;
	019048 )
	    ayahLineNumber=2298
	    ;;
	019049 )
	    ayahLineNumber=2299
	    ;;
	019050 )
	    ayahLineNumber=2300
	    ;;
	019051 )
	    ayahLineNumber=2301
	    ;;
	019052 )
	    ayahLineNumber=2302
	    ;;
	019053 )
	    ayahLineNumber=2303
	    ;;
	019054 )
	    ayahLineNumber=2304
	    ;;
	019055 )
	    ayahLineNumber=2305
	    ;;
	019056 )
	    ayahLineNumber=2306
	    ;;
	019057 )
	    ayahLineNumber=2307
	    ;;
	019058 )
	    ayahLineNumber=2308
	    ;;
	019059 )
	    ayahLineNumber=2309
	    ;;
	019060 )
	    ayahLineNumber=2310
	    ;;
	019061 )
	    ayahLineNumber=2311
	    ;;
	019062 )
	    ayahLineNumber=2312
	    ;;
	019063 )
	    ayahLineNumber=2313
	    ;;
	019064 )
	    ayahLineNumber=2314
	    ;;
	019065 )
	    ayahLineNumber=2315
	    ;;
	019066 )
	    ayahLineNumber=2316
	    ;;
	019067 )
	    ayahLineNumber=2317
	    ;;
	019068 )
	    ayahLineNumber=2318
	    ;;
	019069 )
	    ayahLineNumber=2319
	    ;;
	019070 )
	    ayahLineNumber=2320
	    ;;
	019071 )
	    ayahLineNumber=2321
	    ;;
	019072 )
	    ayahLineNumber=2322
	    ;;
	019073 )
	    ayahLineNumber=2323
	    ;;
	019074 )
	    ayahLineNumber=2324
	    ;;
	019075 )
	    ayahLineNumber=2325
	    ;;
	019076 )
	    ayahLineNumber=2326
	    ;;
	019077 )
	    ayahLineNumber=2327
	    ;;
	019078 )
	    ayahLineNumber=2328
	    ;;
	019079 )
	    ayahLineNumber=2329
	    ;;
	019080 )
	    ayahLineNumber=2330
	    ;;
	019081 )
	    ayahLineNumber=2331
	    ;;
	019082 )
	    ayahLineNumber=2332
	    ;;
	019083 )
	    ayahLineNumber=2333
	    ;;
	019084 )
	    ayahLineNumber=2334
	    ;;
	019085 )
	    ayahLineNumber=2335
	    ;;
	019086 )
	    ayahLineNumber=2336
	    ;;
	019087 )
	    ayahLineNumber=2337
	    ;;
	019088 )
	    ayahLineNumber=2338
	    ;;
	019089 )
	    ayahLineNumber=2339
	    ;;
	019090 )
	    ayahLineNumber=2340
	    ;;
	019091 )
	    ayahLineNumber=2341
	    ;;
	019092 )
	    ayahLineNumber=2342
	    ;;
	019093 )
	    ayahLineNumber=2343
	    ;;
	019094 )
	    ayahLineNumber=2344
	    ;;
	019095 )
	    ayahLineNumber=2345
	    ;;
	019096 )
	    ayahLineNumber=2346
	    ;;
	019097 )
	    ayahLineNumber=2347
	    ;;
	019098 )
	    ayahLineNumber=2348
	    ;;
	020001 )
	    ayahLineNumber=2349
	    ;;
	020002 )
	    ayahLineNumber=2350
	    ;;
	020003 )
	    ayahLineNumber=2351
	    ;;
	020004 )
	    ayahLineNumber=2352
	    ;;
	020005 )
	    ayahLineNumber=2353
	    ;;
	020006 )
	    ayahLineNumber=2354
	    ;;
	020007 )
	    ayahLineNumber=2355
	    ;;
	020008 )
	    ayahLineNumber=2356
	    ;;
	020009 )
	    ayahLineNumber=2357
	    ;;
	020010 )
	    ayahLineNumber=2358
	    ;;
	020011 )
	    ayahLineNumber=2359
	    ;;
	020012 )
	    ayahLineNumber=2360
	    ;;
	020013 )
	    ayahLineNumber=2361
	    ;;
	020014 )
	    ayahLineNumber=2362
	    ;;
	020015 )
	    ayahLineNumber=2363
	    ;;
	020016 )
	    ayahLineNumber=2364
	    ;;
	020017 )
	    ayahLineNumber=2365
	    ;;
	020018 )
	    ayahLineNumber=2366
	    ;;
	020019 )
	    ayahLineNumber=2367
	    ;;
	020020 )
	    ayahLineNumber=2368
	    ;;
	020021 )
	    ayahLineNumber=2369
	    ;;
	020022 )
	    ayahLineNumber=2370
	    ;;
	020023 )
	    ayahLineNumber=2371
	    ;;
	020024 )
	    ayahLineNumber=2372
	    ;;
	020025 )
	    ayahLineNumber=2373
	    ;;
	020026 )
	    ayahLineNumber=2374
	    ;;
	020027 )
	    ayahLineNumber=2375
	    ;;
	020028 )
	    ayahLineNumber=2376
	    ;;
	020029 )
	    ayahLineNumber=2377
	    ;;
	020030 )
	    ayahLineNumber=2378
	    ;;
	020031 )
	    ayahLineNumber=2379
	    ;;
	020032 )
	    ayahLineNumber=2380
	    ;;
	020033 )
	    ayahLineNumber=2381
	    ;;
	020034 )
	    ayahLineNumber=2382
	    ;;
	020035 )
	    ayahLineNumber=2383
	    ;;
	020036 )
	    ayahLineNumber=2384
	    ;;
	020037 )
	    ayahLineNumber=2385
	    ;;
	020038 )
	    ayahLineNumber=2386
	    ;;
	020039 )
	    ayahLineNumber=2387
	    ;;
	020040 )
	    ayahLineNumber=2388
	    ;;
	020041 )
	    ayahLineNumber=2389
	    ;;
	020042 )
	    ayahLineNumber=2390
	    ;;
	020043 )
	    ayahLineNumber=2391
	    ;;
	020044 )
	    ayahLineNumber=2392
	    ;;
	020045 )
	    ayahLineNumber=2393
	    ;;
	020046 )
	    ayahLineNumber=2394
	    ;;
	020047 )
	    ayahLineNumber=2395
	    ;;
	020048 )
	    ayahLineNumber=2396
	    ;;
	020049 )
	    ayahLineNumber=2397
	    ;;
	020050 )
	    ayahLineNumber=2398
	    ;;
	020051 )
	    ayahLineNumber=2399
	    ;;
	020052 )
	    ayahLineNumber=2400
	    ;;
	020053 )
	    ayahLineNumber=2401
	    ;;
	020054 )
	    ayahLineNumber=2402
	    ;;
	020055 )
	    ayahLineNumber=2403
	    ;;
	020056 )
	    ayahLineNumber=2404
	    ;;
	020057 )
	    ayahLineNumber=2405
	    ;;
	020058 )
	    ayahLineNumber=2406
	    ;;
	020059 )
	    ayahLineNumber=2407
	    ;;
	020060 )
	    ayahLineNumber=2408
	    ;;
	020061 )
	    ayahLineNumber=2409
	    ;;
	020062 )
	    ayahLineNumber=2410
	    ;;
	020063 )
	    ayahLineNumber=2411
	    ;;
	020064 )
	    ayahLineNumber=2412
	    ;;
	020065 )
	    ayahLineNumber=2413
	    ;;
	020066 )
	    ayahLineNumber=2414
	    ;;
	020067 )
	    ayahLineNumber=2415
	    ;;
	020068 )
	    ayahLineNumber=2416
	    ;;
	020069 )
	    ayahLineNumber=2417
	    ;;
	020070 )
	    ayahLineNumber=2418
	    ;;
	020071 )
	    ayahLineNumber=2419
	    ;;
	020072 )
	    ayahLineNumber=2420
	    ;;
	020073 )
	    ayahLineNumber=2421
	    ;;
	020074 )
	    ayahLineNumber=2422
	    ;;
	020075 )
	    ayahLineNumber=2423
	    ;;
	020076 )
	    ayahLineNumber=2424
	    ;;
	020077 )
	    ayahLineNumber=2425
	    ;;
	020078 )
	    ayahLineNumber=2426
	    ;;
	020079 )
	    ayahLineNumber=2427
	    ;;
	020080 )
	    ayahLineNumber=2428
	    ;;
	020081 )
	    ayahLineNumber=2429
	    ;;
	020082 )
	    ayahLineNumber=2430
	    ;;
	020083 )
	    ayahLineNumber=2431
	    ;;
	020084 )
	    ayahLineNumber=2432
	    ;;
	020085 )
	    ayahLineNumber=2433
	    ;;
	020086 )
	    ayahLineNumber=2434
	    ;;
	020087 )
	    ayahLineNumber=2435
	    ;;
	020088 )
	    ayahLineNumber=2436
	    ;;
	020089 )
	    ayahLineNumber=2437
	    ;;
	020090 )
	    ayahLineNumber=2438
	    ;;
	020091 )
	    ayahLineNumber=2439
	    ;;
	020092 )
	    ayahLineNumber=2440
	    ;;
	020093 )
	    ayahLineNumber=2441
	    ;;
	020094 )
	    ayahLineNumber=2442
	    ;;
	020095 )
	    ayahLineNumber=2443
	    ;;
	020096 )
	    ayahLineNumber=2444
	    ;;
	020097 )
	    ayahLineNumber=2445
	    ;;
	020098 )
	    ayahLineNumber=2446
	    ;;
	020099 )
	    ayahLineNumber=2447
	    ;;
	020100 )
	    ayahLineNumber=2448
	    ;;
	020101 )
	    ayahLineNumber=2449
	    ;;
	020102 )
	    ayahLineNumber=2450
	    ;;
	020103 )
	    ayahLineNumber=2451
	    ;;
	020104 )
	    ayahLineNumber=2452
	    ;;
	020105 )
	    ayahLineNumber=2453
	    ;;
	020106 )
	    ayahLineNumber=2454
	    ;;
	020107 )
	    ayahLineNumber=2455
	    ;;
	020108 )
	    ayahLineNumber=2456
	    ;;
	020109 )
	    ayahLineNumber=2457
	    ;;
	020110 )
	    ayahLineNumber=2458
	    ;;
	020111 )
	    ayahLineNumber=2459
	    ;;
	020112 )
	    ayahLineNumber=2460
	    ;;
	020113 )
	    ayahLineNumber=2461
	    ;;
	020114 )
	    ayahLineNumber=2462
	    ;;
	020115 )
	    ayahLineNumber=2463
	    ;;
	020116 )
	    ayahLineNumber=2464
	    ;;
	020117 )
	    ayahLineNumber=2465
	    ;;
	020118 )
	    ayahLineNumber=2466
	    ;;
	020119 )
	    ayahLineNumber=2467
	    ;;
	020120 )
	    ayahLineNumber=2468
	    ;;
	020121 )
	    ayahLineNumber=2469
	    ;;
	020122 )
	    ayahLineNumber=2470
	    ;;
	020123 )
	    ayahLineNumber=2471
	    ;;
	020124 )
	    ayahLineNumber=2472
	    ;;
	020125 )
	    ayahLineNumber=2473
	    ;;
	020126 )
	    ayahLineNumber=2474
	    ;;
	020127 )
	    ayahLineNumber=2475
	    ;;
	020128 )
	    ayahLineNumber=2476
	    ;;
	020129 )
	    ayahLineNumber=2477
	    ;;
	020130 )
	    ayahLineNumber=2478
	    ;;
	020131 )
	    ayahLineNumber=2479
	    ;;
	020132 )
	    ayahLineNumber=2480
	    ;;
	020133 )
	    ayahLineNumber=2481
	    ;;
	020134 )
	    ayahLineNumber=2482
	    ;;
	020135 )
	    ayahLineNumber=2483
	    ;;
	021001 )
	    ayahLineNumber=2484
	    ;;
	021002 )
	    ayahLineNumber=2485
	    ;;
	021003 )
	    ayahLineNumber=2486
	    ;;
	021004 )
	    ayahLineNumber=2487
	    ;;
	021005 )
	    ayahLineNumber=2488
	    ;;
	021006 )
	    ayahLineNumber=2489
	    ;;
	021007 )
	    ayahLineNumber=2490
	    ;;
	021008 )
	    ayahLineNumber=2491
	    ;;
	021009 )
	    ayahLineNumber=2492
	    ;;
	021010 )
	    ayahLineNumber=2493
	    ;;
	021011 )
	    ayahLineNumber=2494
	    ;;
	021012 )
	    ayahLineNumber=2495
	    ;;
	021013 )
	    ayahLineNumber=2496
	    ;;
	021014 )
	    ayahLineNumber=2497
	    ;;
	021015 )
	    ayahLineNumber=2498
	    ;;
	021016 )
	    ayahLineNumber=2499
	    ;;
	021017 )
	    ayahLineNumber=2500
	    ;;
	021018 )
	    ayahLineNumber=2501
	    ;;
	021019 )
	    ayahLineNumber=2502
	    ;;
	021020 )
	    ayahLineNumber=2503
	    ;;
	021021 )
	    ayahLineNumber=2504
	    ;;
	021022 )
	    ayahLineNumber=2505
	    ;;
	021023 )
	    ayahLineNumber=2506
	    ;;
	021024 )
	    ayahLineNumber=2507
	    ;;
	021025 )
	    ayahLineNumber=2508
	    ;;
	021026 )
	    ayahLineNumber=2509
	    ;;
	021027 )
	    ayahLineNumber=2510
	    ;;
	021028 )
	    ayahLineNumber=2511
	    ;;
	021029 )
	    ayahLineNumber=2512
	    ;;
	021030 )
	    ayahLineNumber=2513
	    ;;
	021031 )
	    ayahLineNumber=2514
	    ;;
	021032 )
	    ayahLineNumber=2515
	    ;;
	021033 )
	    ayahLineNumber=2516
	    ;;
	021034 )
	    ayahLineNumber=2517
	    ;;
	021035 )
	    ayahLineNumber=2518
	    ;;
	021036 )
	    ayahLineNumber=2519
	    ;;
	021037 )
	    ayahLineNumber=2520
	    ;;
	021038 )
	    ayahLineNumber=2521
	    ;;
	021039 )
	    ayahLineNumber=2522
	    ;;
	021040 )
	    ayahLineNumber=2523
	    ;;
	021041 )
	    ayahLineNumber=2524
	    ;;
	021042 )
	    ayahLineNumber=2525
	    ;;
	021043 )
	    ayahLineNumber=2526
	    ;;
	021044 )
	    ayahLineNumber=2527
	    ;;
	021045 )
	    ayahLineNumber=2528
	    ;;
	021046 )
	    ayahLineNumber=2529
	    ;;
	021047 )
	    ayahLineNumber=2530
	    ;;
	021048 )
	    ayahLineNumber=2531
	    ;;
	021049 )
	    ayahLineNumber=2532
	    ;;
	021050 )
	    ayahLineNumber=2533
	    ;;
	021051 )
	    ayahLineNumber=2534
	    ;;
	021052 )
	    ayahLineNumber=2535
	    ;;
	021053 )
	    ayahLineNumber=2536
	    ;;
	021054 )
	    ayahLineNumber=2537
	    ;;
	021055 )
	    ayahLineNumber=2538
	    ;;
	021056 )
	    ayahLineNumber=2539
	    ;;
	021057 )
	    ayahLineNumber=2540
	    ;;
	021058 )
	    ayahLineNumber=2541
	    ;;
	021059 )
	    ayahLineNumber=2542
	    ;;
	021060 )
	    ayahLineNumber=2543
	    ;;
	021061 )
	    ayahLineNumber=2544
	    ;;
	021062 )
	    ayahLineNumber=2545
	    ;;
	021063 )
	    ayahLineNumber=2546
	    ;;
	021064 )
	    ayahLineNumber=2547
	    ;;
	021065 )
	    ayahLineNumber=2548
	    ;;
	021066 )
	    ayahLineNumber=2549
	    ;;
	021067 )
	    ayahLineNumber=2550
	    ;;
	021068 )
	    ayahLineNumber=2551
	    ;;
	021069 )
	    ayahLineNumber=2552
	    ;;
	021070 )
	    ayahLineNumber=2553
	    ;;
	021071 )
	    ayahLineNumber=2554
	    ;;
	021072 )
	    ayahLineNumber=2555
	    ;;
	021073 )
	    ayahLineNumber=2556
	    ;;
	021074 )
	    ayahLineNumber=2557
	    ;;
	021075 )
	    ayahLineNumber=2558
	    ;;
	021076 )
	    ayahLineNumber=2559
	    ;;
	021077 )
	    ayahLineNumber=2560
	    ;;
	021078 )
	    ayahLineNumber=2561
	    ;;
	021079 )
	    ayahLineNumber=2562
	    ;;
	021080 )
	    ayahLineNumber=2563
	    ;;
	021081 )
	    ayahLineNumber=2564
	    ;;
	021082 )
	    ayahLineNumber=2565
	    ;;
	021083 )
	    ayahLineNumber=2566
	    ;;
	021084 )
	    ayahLineNumber=2567
	    ;;
	021085 )
	    ayahLineNumber=2568
	    ;;
	021086 )
	    ayahLineNumber=2569
	    ;;
	021087 )
	    ayahLineNumber=2570
	    ;;
	021088 )
	    ayahLineNumber=2571
	    ;;
	021089 )
	    ayahLineNumber=2572
	    ;;
	021090 )
	    ayahLineNumber=2573
	    ;;
	021091 )
	    ayahLineNumber=2574
	    ;;
	021092 )
	    ayahLineNumber=2575
	    ;;
	021093 )
	    ayahLineNumber=2576
	    ;;
	021094 )
	    ayahLineNumber=2577
	    ;;
	021095 )
	    ayahLineNumber=2578
	    ;;
	021096 )
	    ayahLineNumber=2579
	    ;;
	021097 )
	    ayahLineNumber=2580
	    ;;
	021098 )
	    ayahLineNumber=2581
	    ;;
	021099 )
	    ayahLineNumber=2582
	    ;;
	021100 )
	    ayahLineNumber=2583
	    ;;
	021101 )
	    ayahLineNumber=2584
	    ;;
	021102 )
	    ayahLineNumber=2585
	    ;;
	021103 )
	    ayahLineNumber=2586
	    ;;
	021104 )
	    ayahLineNumber=2587
	    ;;
	021105 )
	    ayahLineNumber=2588
	    ;;
	021106 )
	    ayahLineNumber=2589
	    ;;
	021107 )
	    ayahLineNumber=2590
	    ;;
	021108 )
	    ayahLineNumber=2591
	    ;;
	021109 )
	    ayahLineNumber=2592
	    ;;
	021110 )
	    ayahLineNumber=2593
	    ;;
	021111 )
	    ayahLineNumber=2594
	    ;;
	021112 )
	    ayahLineNumber=2595
	    ;;
	022001 )
	    ayahLineNumber=2596
	    ;;
	022002 )
	    ayahLineNumber=2597
	    ;;
	022003 )
	    ayahLineNumber=2598
	    ;;
	022004 )
	    ayahLineNumber=2599
	    ;;
	022005 )
	    ayahLineNumber=2600
	    ;;
	022006 )
	    ayahLineNumber=2601
	    ;;
	022007 )
	    ayahLineNumber=2602
	    ;;
	022008 )
	    ayahLineNumber=2603
	    ;;
	022009 )
	    ayahLineNumber=2604
	    ;;
	022010 )
	    ayahLineNumber=2605
	    ;;
	022011 )
	    ayahLineNumber=2606
	    ;;
	022012 )
	    ayahLineNumber=2607
	    ;;
	022013 )
	    ayahLineNumber=2608
	    ;;
	022014 )
	    ayahLineNumber=2609
	    ;;
	022015 )
	    ayahLineNumber=2610
	    ;;
	022016 )
	    ayahLineNumber=2611
	    ;;
	022017 )
	    ayahLineNumber=2612
	    ;;
	022018 )
	    ayahLineNumber=2613
	    ;;
	022019 )
	    ayahLineNumber=2614
	    ;;
	022020 )
	    ayahLineNumber=2615
	    ;;
	022021 )
	    ayahLineNumber=2616
	    ;;
	022022 )
	    ayahLineNumber=2617
	    ;;
	022023 )
	    ayahLineNumber=2618
	    ;;
	022024 )
	    ayahLineNumber=2619
	    ;;
	022025 )
	    ayahLineNumber=2620
	    ;;
	022026 )
	    ayahLineNumber=2621
	    ;;
	022027 )
	    ayahLineNumber=2622
	    ;;
	022028 )
	    ayahLineNumber=2623
	    ;;
	022029 )
	    ayahLineNumber=2624
	    ;;
	022030 )
	    ayahLineNumber=2625
	    ;;
	022031 )
	    ayahLineNumber=2626
	    ;;
	022032 )
	    ayahLineNumber=2627
	    ;;
	022033 )
	    ayahLineNumber=2628
	    ;;
	022034 )
	    ayahLineNumber=2629
	    ;;
	022035 )
	    ayahLineNumber=2630
	    ;;
	022036 )
	    ayahLineNumber=2631
	    ;;
	022037 )
	    ayahLineNumber=2632
	    ;;
	022038 )
	    ayahLineNumber=2633
	    ;;
	022039 )
	    ayahLineNumber=2634
	    ;;
	022040 )
	    ayahLineNumber=2635
	    ;;
	022041 )
	    ayahLineNumber=2636
	    ;;
	022042 )
	    ayahLineNumber=2637
	    ;;
	022043 )
	    ayahLineNumber=2638
	    ;;
	022044 )
	    ayahLineNumber=2639
	    ;;
	022045 )
	    ayahLineNumber=2640
	    ;;
	022046 )
	    ayahLineNumber=2641
	    ;;
	022047 )
	    ayahLineNumber=2642
	    ;;
	022048 )
	    ayahLineNumber=2643
	    ;;
	022049 )
	    ayahLineNumber=2644
	    ;;
	022050 )
	    ayahLineNumber=2645
	    ;;
	022051 )
	    ayahLineNumber=2646
	    ;;
	022052 )
	    ayahLineNumber=2647
	    ;;
	022053 )
	    ayahLineNumber=2648
	    ;;
	022054 )
	    ayahLineNumber=2649
	    ;;
	022055 )
	    ayahLineNumber=2650
	    ;;
	022056 )
	    ayahLineNumber=2651
	    ;;
	022057 )
	    ayahLineNumber=2652
	    ;;
	022058 )
	    ayahLineNumber=2653
	    ;;
	022059 )
	    ayahLineNumber=2654
	    ;;
	022060 )
	    ayahLineNumber=2655
	    ;;
	022061 )
	    ayahLineNumber=2656
	    ;;
	022062 )
	    ayahLineNumber=2657
	    ;;
	022063 )
	    ayahLineNumber=2658
	    ;;
	022064 )
	    ayahLineNumber=2659
	    ;;
	022065 )
	    ayahLineNumber=2660
	    ;;
	022066 )
	    ayahLineNumber=2661
	    ;;
	022067 )
	    ayahLineNumber=2662
	    ;;
	022068 )
	    ayahLineNumber=2663
	    ;;
	022069 )
	    ayahLineNumber=2664
	    ;;
	022070 )
	    ayahLineNumber=2665
	    ;;
	022071 )
	    ayahLineNumber=2666
	    ;;
	022072 )
	    ayahLineNumber=2667
	    ;;
	022073 )
	    ayahLineNumber=2668
	    ;;
	022074 )
	    ayahLineNumber=2669
	    ;;
	022075 )
	    ayahLineNumber=2670
	    ;;
	022076 )
	    ayahLineNumber=2671
	    ;;
	022077 )
	    ayahLineNumber=2672
	    ;;
	022078 )
	    ayahLineNumber=2673
	    ;;
	023001 )
	    ayahLineNumber=2674
	    ;;
	023002 )
	    ayahLineNumber=2675
	    ;;
	023003 )
	    ayahLineNumber=2676
	    ;;
	023004 )
	    ayahLineNumber=2677
	    ;;
	023005 )
	    ayahLineNumber=2678
	    ;;
	023006 )
	    ayahLineNumber=2679
	    ;;
	023007 )
	    ayahLineNumber=2680
	    ;;
	023008 )
	    ayahLineNumber=2681
	    ;;
	023009 )
	    ayahLineNumber=2682
	    ;;
	023010 )
	    ayahLineNumber=2683
	    ;;
	023011 )
	    ayahLineNumber=2684
	    ;;
	023012 )
	    ayahLineNumber=2685
	    ;;
	023013 )
	    ayahLineNumber=2686
	    ;;
	023014 )
	    ayahLineNumber=2687
	    ;;
	023015 )
	    ayahLineNumber=2688
	    ;;
	023016 )
	    ayahLineNumber=2689
	    ;;
	023017 )
	    ayahLineNumber=2690
	    ;;
	023018 )
	    ayahLineNumber=2691
	    ;;
	023019 )
	    ayahLineNumber=2692
	    ;;
	023020 )
	    ayahLineNumber=2693
	    ;;
	023021 )
	    ayahLineNumber=2694
	    ;;
	023022 )
	    ayahLineNumber=2695
	    ;;
	023023 )
	    ayahLineNumber=2696
	    ;;
	023024 )
	    ayahLineNumber=2697
	    ;;
	023025 )
	    ayahLineNumber=2698
	    ;;
	023026 )
	    ayahLineNumber=2699
	    ;;
	023027 )
	    ayahLineNumber=2700
	    ;;
	023028 )
	    ayahLineNumber=2701
	    ;;
	023029 )
	    ayahLineNumber=2702
	    ;;
	023030 )
	    ayahLineNumber=2703
	    ;;
	023031 )
	    ayahLineNumber=2704
	    ;;
	023032 )
	    ayahLineNumber=2705
	    ;;
	023033 )
	    ayahLineNumber=2706
	    ;;
	023034 )
	    ayahLineNumber=2707
	    ;;
	023035 )
	    ayahLineNumber=2708
	    ;;
	023036 )
	    ayahLineNumber=2709
	    ;;
	023037 )
	    ayahLineNumber=2710
	    ;;
	023038 )
	    ayahLineNumber=2711
	    ;;
	023039 )
	    ayahLineNumber=2712
	    ;;
	023040 )
	    ayahLineNumber=2713
	    ;;
	023041 )
	    ayahLineNumber=2714
	    ;;
	023042 )
	    ayahLineNumber=2715
	    ;;
	023043 )
	    ayahLineNumber=2716
	    ;;
	023044 )
	    ayahLineNumber=2717
	    ;;
	023045 )
	    ayahLineNumber=2718
	    ;;
	023046 )
	    ayahLineNumber=2719
	    ;;
	023047 )
	    ayahLineNumber=2720
	    ;;
	023048 )
	    ayahLineNumber=2721
	    ;;
	023049 )
	    ayahLineNumber=2722
	    ;;
	023050 )
	    ayahLineNumber=2723
	    ;;
	023051 )
	    ayahLineNumber=2724
	    ;;
	023052 )
	    ayahLineNumber=2725
	    ;;
	023053 )
	    ayahLineNumber=2726
	    ;;
	023054 )
	    ayahLineNumber=2727
	    ;;
	023055 )
	    ayahLineNumber=2728
	    ;;
	023056 )
	    ayahLineNumber=2729
	    ;;
	023057 )
	    ayahLineNumber=2730
	    ;;
	023058 )
	    ayahLineNumber=2731
	    ;;
	023059 )
	    ayahLineNumber=2732
	    ;;
	023060 )
	    ayahLineNumber=2733
	    ;;
	023061 )
	    ayahLineNumber=2734
	    ;;
	023062 )
	    ayahLineNumber=2735
	    ;;
	023063 )
	    ayahLineNumber=2736
	    ;;
	023064 )
	    ayahLineNumber=2737
	    ;;
	023065 )
	    ayahLineNumber=2738
	    ;;
	023066 )
	    ayahLineNumber=2739
	    ;;
	023067 )
	    ayahLineNumber=2740
	    ;;
	023068 )
	    ayahLineNumber=2741
	    ;;
	023069 )
	    ayahLineNumber=2742
	    ;;
	023070 )
	    ayahLineNumber=2743
	    ;;
	023071 )
	    ayahLineNumber=2744
	    ;;
	023072 )
	    ayahLineNumber=2745
	    ;;
	023073 )
	    ayahLineNumber=2746
	    ;;
	023074 )
	    ayahLineNumber=2747
	    ;;
	023075 )
	    ayahLineNumber=2748
	    ;;
	023076 )
	    ayahLineNumber=2749
	    ;;
	023077 )
	    ayahLineNumber=2750
	    ;;
	023078 )
	    ayahLineNumber=2751
	    ;;
	023079 )
	    ayahLineNumber=2752
	    ;;
	023080 )
	    ayahLineNumber=2753
	    ;;
	023081 )
	    ayahLineNumber=2754
	    ;;
	023082 )
	    ayahLineNumber=2755
	    ;;
	023083 )
	    ayahLineNumber=2756
	    ;;
	023084 )
	    ayahLineNumber=2757
	    ;;
	023085 )
	    ayahLineNumber=2758
	    ;;
	023086 )
	    ayahLineNumber=2759
	    ;;
	023087 )
	    ayahLineNumber=2760
	    ;;
	023088 )
	    ayahLineNumber=2761
	    ;;
	023089 )
	    ayahLineNumber=2762
	    ;;
	023090 )
	    ayahLineNumber=2763
	    ;;
	023091 )
	    ayahLineNumber=2764
	    ;;
	023092 )
	    ayahLineNumber=2765
	    ;;
	023093 )
	    ayahLineNumber=2766
	    ;;
	023094 )
	    ayahLineNumber=2767
	    ;;
	023095 )
	    ayahLineNumber=2768
	    ;;
	023096 )
	    ayahLineNumber=2769
	    ;;
	023097 )
	    ayahLineNumber=2770
	    ;;
	023098 )
	    ayahLineNumber=2771
	    ;;
	023099 )
	    ayahLineNumber=2772
	    ;;
	023100 )
	    ayahLineNumber=2773
	    ;;
	023101 )
	    ayahLineNumber=2774
	    ;;
	023102 )
	    ayahLineNumber=2775
	    ;;
	023103 )
	    ayahLineNumber=2776
	    ;;
	023104 )
	    ayahLineNumber=2777
	    ;;
	023105 )
	    ayahLineNumber=2778
	    ;;
	023106 )
	    ayahLineNumber=2779
	    ;;
	023107 )
	    ayahLineNumber=2780
	    ;;
	023108 )
	    ayahLineNumber=2781
	    ;;
	023109 )
	    ayahLineNumber=2782
	    ;;
	023110 )
	    ayahLineNumber=2783
	    ;;
	023111 )
	    ayahLineNumber=2784
	    ;;
	023112 )
	    ayahLineNumber=2785
	    ;;
	023113 )
	    ayahLineNumber=2786
	    ;;
	023114 )
	    ayahLineNumber=2787
	    ;;
	023115 )
	    ayahLineNumber=2788
	    ;;
	023116 )
	    ayahLineNumber=2789
	    ;;
	023117 )
	    ayahLineNumber=2790
	    ;;
	023118 )
	    ayahLineNumber=2791
	    ;;
	024001 )
	    ayahLineNumber=2792
	    ;;
	024002 )
	    ayahLineNumber=2793
	    ;;
	024003 )
	    ayahLineNumber=2794
	    ;;
	024004 )
	    ayahLineNumber=2795
	    ;;
	024005 )
	    ayahLineNumber=2796
	    ;;
	024006 )
	    ayahLineNumber=2797
	    ;;
	024007 )
	    ayahLineNumber=2798
	    ;;
	024008 )
	    ayahLineNumber=2799
	    ;;
	024009 )
	    ayahLineNumber=2800
	    ;;
	024010 )
	    ayahLineNumber=2801
	    ;;
	024011 )
	    ayahLineNumber=2802
	    ;;
	024012 )
	    ayahLineNumber=2803
	    ;;
	024013 )
	    ayahLineNumber=2804
	    ;;
	024014 )
	    ayahLineNumber=2805
	    ;;
	024015 )
	    ayahLineNumber=2806
	    ;;
	024016 )
	    ayahLineNumber=2807
	    ;;
	024017 )
	    ayahLineNumber=2808
	    ;;
	024018 )
	    ayahLineNumber=2809
	    ;;
	024019 )
	    ayahLineNumber=2810
	    ;;
	024020 )
	    ayahLineNumber=2811
	    ;;
	024021 )
	    ayahLineNumber=2812
	    ;;
	024022 )
	    ayahLineNumber=2813
	    ;;
	024023 )
	    ayahLineNumber=2814
	    ;;
	024024 )
	    ayahLineNumber=2815
	    ;;
	024025 )
	    ayahLineNumber=2816
	    ;;
	024026 )
	    ayahLineNumber=2817
	    ;;
	024027 )
	    ayahLineNumber=2818
	    ;;
	024028 )
	    ayahLineNumber=2819
	    ;;
	024029 )
	    ayahLineNumber=2820
	    ;;
	024030 )
	    ayahLineNumber=2821
	    ;;
	024031 )
	    ayahLineNumber=2822
	    ;;
	024032 )
	    ayahLineNumber=2823
	    ;;
	024033 )
	    ayahLineNumber=2824
	    ;;
	024034 )
	    ayahLineNumber=2825
	    ;;
	024035 )
	    ayahLineNumber=2826
	    ;;
	024036 )
	    ayahLineNumber=2827
	    ;;
	024037 )
	    ayahLineNumber=2828
	    ;;
	024038 )
	    ayahLineNumber=2829
	    ;;
	024039 )
	    ayahLineNumber=2830
	    ;;
	024040 )
	    ayahLineNumber=2831
	    ;;
	024041 )
	    ayahLineNumber=2832
	    ;;
	024042 )
	    ayahLineNumber=2833
	    ;;
	024043 )
	    ayahLineNumber=2834
	    ;;
	024044 )
	    ayahLineNumber=2835
	    ;;
	024045 )
	    ayahLineNumber=2836
	    ;;
	024046 )
	    ayahLineNumber=2837
	    ;;
	024047 )
	    ayahLineNumber=2838
	    ;;
	024048 )
	    ayahLineNumber=2839
	    ;;
	024049 )
	    ayahLineNumber=2840
	    ;;
	024050 )
	    ayahLineNumber=2841
	    ;;
	024051 )
	    ayahLineNumber=2842
	    ;;
	024052 )
	    ayahLineNumber=2843
	    ;;
	024053 )
	    ayahLineNumber=2844
	    ;;
	024054 )
	    ayahLineNumber=2845
	    ;;
	024055 )
	    ayahLineNumber=2846
	    ;;
	024056 )
	    ayahLineNumber=2847
	    ;;
	024057 )
	    ayahLineNumber=2848
	    ;;
	024058 )
	    ayahLineNumber=2849
	    ;;
	024059 )
	    ayahLineNumber=2850
	    ;;
	024060 )
	    ayahLineNumber=2851
	    ;;
	024061 )
	    ayahLineNumber=2852
	    ;;
	024062 )
	    ayahLineNumber=2853
	    ;;
	024063 )
	    ayahLineNumber=2854
	    ;;
	024064 )
	    ayahLineNumber=2855
	    ;;
	025001 )
	    ayahLineNumber=2856
	    ;;
	025002 )
	    ayahLineNumber=2857
	    ;;
	025003 )
	    ayahLineNumber=2858
	    ;;
	025004 )
	    ayahLineNumber=2859
	    ;;
	025005 )
	    ayahLineNumber=2860
	    ;;
	025006 )
	    ayahLineNumber=2861
	    ;;
	025007 )
	    ayahLineNumber=2862
	    ;;
	025008 )
	    ayahLineNumber=2863
	    ;;
	025009 )
	    ayahLineNumber=2864
	    ;;
	025010 )
	    ayahLineNumber=2865
	    ;;
	025011 )
	    ayahLineNumber=2866
	    ;;
	025012 )
	    ayahLineNumber=2867
	    ;;
	025013 )
	    ayahLineNumber=2868
	    ;;
	025014 )
	    ayahLineNumber=2869
	    ;;
	025015 )
	    ayahLineNumber=2870
	    ;;
	025016 )
	    ayahLineNumber=2871
	    ;;
	025017 )
	    ayahLineNumber=2872
	    ;;
	025018 )
	    ayahLineNumber=2873
	    ;;
	025019 )
	    ayahLineNumber=2874
	    ;;
	025020 )
	    ayahLineNumber=2875
	    ;;
	025021 )
	    ayahLineNumber=2876
	    ;;
	025022 )
	    ayahLineNumber=2877
	    ;;
	025023 )
	    ayahLineNumber=2878
	    ;;
	025024 )
	    ayahLineNumber=2879
	    ;;
	025025 )
	    ayahLineNumber=2880
	    ;;
	025026 )
	    ayahLineNumber=2881
	    ;;
	025027 )
	    ayahLineNumber=2882
	    ;;
	025028 )
	    ayahLineNumber=2883
	    ;;
	025029 )
	    ayahLineNumber=2884
	    ;;
	025030 )
	    ayahLineNumber=2885
	    ;;
	025031 )
	    ayahLineNumber=2886
	    ;;
	025032 )
	    ayahLineNumber=2887
	    ;;
	025033 )
	    ayahLineNumber=2888
	    ;;
	025034 )
	    ayahLineNumber=2889
	    ;;
	025035 )
	    ayahLineNumber=2890
	    ;;
	025036 )
	    ayahLineNumber=2891
	    ;;
	025037 )
	    ayahLineNumber=2892
	    ;;
	025038 )
	    ayahLineNumber=2893
	    ;;
	025039 )
	    ayahLineNumber=2894
	    ;;
	025040 )
	    ayahLineNumber=2895
	    ;;
	025041 )
	    ayahLineNumber=2896
	    ;;
	025042 )
	    ayahLineNumber=2897
	    ;;
	025043 )
	    ayahLineNumber=2898
	    ;;
	025044 )
	    ayahLineNumber=2899
	    ;;
	025045 )
	    ayahLineNumber=2900
	    ;;
	025046 )
	    ayahLineNumber=2901
	    ;;
	025047 )
	    ayahLineNumber=2902
	    ;;
	025048 )
	    ayahLineNumber=2903
	    ;;
	025049 )
	    ayahLineNumber=2904
	    ;;
	025050 )
	    ayahLineNumber=2905
	    ;;
	025051 )
	    ayahLineNumber=2906
	    ;;
	025052 )
	    ayahLineNumber=2907
	    ;;
	025053 )
	    ayahLineNumber=2908
	    ;;
	025054 )
	    ayahLineNumber=2909
	    ;;
	025055 )
	    ayahLineNumber=2910
	    ;;
	025056 )
	    ayahLineNumber=2911
	    ;;
	025057 )
	    ayahLineNumber=2912
	    ;;
	025058 )
	    ayahLineNumber=2913
	    ;;
	025059 )
	    ayahLineNumber=2914
	    ;;
	025060 )
	    ayahLineNumber=2915
	    ;;
	025061 )
	    ayahLineNumber=2916
	    ;;
	025062 )
	    ayahLineNumber=2917
	    ;;
	025063 )
	    ayahLineNumber=2918
	    ;;
	025064 )
	    ayahLineNumber=2919
	    ;;
	025065 )
	    ayahLineNumber=2920
	    ;;
	025066 )
	    ayahLineNumber=2921
	    ;;
	025067 )
	    ayahLineNumber=2922
	    ;;
	025068 )
	    ayahLineNumber=2923
	    ;;
	025069 )
	    ayahLineNumber=2924
	    ;;
	025070 )
	    ayahLineNumber=2925
	    ;;
	025071 )
	    ayahLineNumber=2926
	    ;;
	025072 )
	    ayahLineNumber=2927
	    ;;
	025073 )
	    ayahLineNumber=2928
	    ;;
	025074 )
	    ayahLineNumber=2929
	    ;;
	025075 )
	    ayahLineNumber=2930
	    ;;
	025076 )
	    ayahLineNumber=2931
	    ;;
	025077 )
	    ayahLineNumber=2932
	    ;;
	026001 )
	    ayahLineNumber=2933
	    ;;
	026002 )
	    ayahLineNumber=2934
	    ;;
	026003 )
	    ayahLineNumber=2935
	    ;;
	026004 )
	    ayahLineNumber=2936
	    ;;
	026005 )
	    ayahLineNumber=2937
	    ;;
	026006 )
	    ayahLineNumber=2938
	    ;;
	026007 )
	    ayahLineNumber=2939
	    ;;
	026008 )
	    ayahLineNumber=2940
	    ;;
	026009 )
	    ayahLineNumber=2941
	    ;;
	026010 )
	    ayahLineNumber=2942
	    ;;
	026011 )
	    ayahLineNumber=2943
	    ;;
	026012 )
	    ayahLineNumber=2944
	    ;;
	026013 )
	    ayahLineNumber=2945
	    ;;
	026014 )
	    ayahLineNumber=2946
	    ;;
	026015 )
	    ayahLineNumber=2947
	    ;;
	026016 )
	    ayahLineNumber=2948
	    ;;
	026017 )
	    ayahLineNumber=2949
	    ;;
	026018 )
	    ayahLineNumber=2950
	    ;;
	026019 )
	    ayahLineNumber=2951
	    ;;
	026020 )
	    ayahLineNumber=2952
	    ;;
	026021 )
	    ayahLineNumber=2953
	    ;;
	026022 )
	    ayahLineNumber=2954
	    ;;
	026023 )
	    ayahLineNumber=2955
	    ;;
	026024 )
	    ayahLineNumber=2956
	    ;;
	026025 )
	    ayahLineNumber=2957
	    ;;
	026026 )
	    ayahLineNumber=2958
	    ;;
	026027 )
	    ayahLineNumber=2959
	    ;;
	026028 )
	    ayahLineNumber=2960
	    ;;
	026029 )
	    ayahLineNumber=2961
	    ;;
	026030 )
	    ayahLineNumber=2962
	    ;;
	026031 )
	    ayahLineNumber=2963
	    ;;
	026032 )
	    ayahLineNumber=2964
	    ;;
	026033 )
	    ayahLineNumber=2965
	    ;;
	026034 )
	    ayahLineNumber=2966
	    ;;
	026035 )
	    ayahLineNumber=2967
	    ;;
	026036 )
	    ayahLineNumber=2968
	    ;;
	026037 )
	    ayahLineNumber=2969
	    ;;
	026038 )
	    ayahLineNumber=2970
	    ;;
	026039 )
	    ayahLineNumber=2971
	    ;;
	026040 )
	    ayahLineNumber=2972
	    ;;
	026041 )
	    ayahLineNumber=2973
	    ;;
	026042 )
	    ayahLineNumber=2974
	    ;;
	026043 )
	    ayahLineNumber=2975
	    ;;
	026044 )
	    ayahLineNumber=2976
	    ;;
	026045 )
	    ayahLineNumber=2977
	    ;;
	026046 )
	    ayahLineNumber=2978
	    ;;
	026047 )
	    ayahLineNumber=2979
	    ;;
	026048 )
	    ayahLineNumber=2980
	    ;;
	026049 )
	    ayahLineNumber=2981
	    ;;
	026050 )
	    ayahLineNumber=2982
	    ;;
	026051 )
	    ayahLineNumber=2983
	    ;;
	026052 )
	    ayahLineNumber=2984
	    ;;
	026053 )
	    ayahLineNumber=2985
	    ;;
	026054 )
	    ayahLineNumber=2986
	    ;;
	026055 )
	    ayahLineNumber=2987
	    ;;
	026056 )
	    ayahLineNumber=2988
	    ;;
	026057 )
	    ayahLineNumber=2989
	    ;;
	026058 )
	    ayahLineNumber=2990
	    ;;
	026059 )
	    ayahLineNumber=2991
	    ;;
	026060 )
	    ayahLineNumber=2992
	    ;;
	026061 )
	    ayahLineNumber=2993
	    ;;
	026062 )
	    ayahLineNumber=2994
	    ;;
	026063 )
	    ayahLineNumber=2995
	    ;;
	026064 )
	    ayahLineNumber=2996
	    ;;
	026065 )
	    ayahLineNumber=2997
	    ;;
	026066 )
	    ayahLineNumber=2998
	    ;;
	026067 )
	    ayahLineNumber=2999
	    ;;
	026068 )
	    ayahLineNumber=3000
	    ;;
	026069 )
	    ayahLineNumber=3001
	    ;;
	026070 )
	    ayahLineNumber=3002
	    ;;
	026071 )
	    ayahLineNumber=3003
	    ;;
	026072 )
	    ayahLineNumber=3004
	    ;;
	026073 )
	    ayahLineNumber=3005
	    ;;
	026074 )
	    ayahLineNumber=3006
	    ;;
	026075 )
	    ayahLineNumber=3007
	    ;;
	026076 )
	    ayahLineNumber=3008
	    ;;
	026077 )
	    ayahLineNumber=3009
	    ;;
	026078 )
	    ayahLineNumber=3010
	    ;;
	026079 )
	    ayahLineNumber=3011
	    ;;
	026080 )
	    ayahLineNumber=3012
	    ;;
	026081 )
	    ayahLineNumber=3013
	    ;;
	026082 )
	    ayahLineNumber=3014
	    ;;
	026083 )
	    ayahLineNumber=3015
	    ;;
	026084 )
	    ayahLineNumber=3016
	    ;;
	026085 )
	    ayahLineNumber=3017
	    ;;
	026086 )
	    ayahLineNumber=3018
	    ;;
	026087 )
	    ayahLineNumber=3019
	    ;;
	026088 )
	    ayahLineNumber=3020
	    ;;
	026089 )
	    ayahLineNumber=3021
	    ;;
	026090 )
	    ayahLineNumber=3022
	    ;;
	026091 )
	    ayahLineNumber=3023
	    ;;
	026092 )
	    ayahLineNumber=3024
	    ;;
	026093 )
	    ayahLineNumber=3025
	    ;;
	026094 )
	    ayahLineNumber=3026
	    ;;
	026095 )
	    ayahLineNumber=3027
	    ;;
	026096 )
	    ayahLineNumber=3028
	    ;;
	026097 )
	    ayahLineNumber=3029
	    ;;
	026098 )
	    ayahLineNumber=3030
	    ;;
	026099 )
	    ayahLineNumber=3031
	    ;;
	026100 )
	    ayahLineNumber=3032
	    ;;
	026101 )
	    ayahLineNumber=3033
	    ;;
	026102 )
	    ayahLineNumber=3034
	    ;;
	026103 )
	    ayahLineNumber=3035
	    ;;
	026104 )
	    ayahLineNumber=3036
	    ;;
	026105 )
	    ayahLineNumber=3037
	    ;;
	026106 )
	    ayahLineNumber=3038
	    ;;
	026107 )
	    ayahLineNumber=3039
	    ;;
	026108 )
	    ayahLineNumber=3040
	    ;;
	026109 )
	    ayahLineNumber=3041
	    ;;
	026110 )
	    ayahLineNumber=3042
	    ;;
	026111 )
	    ayahLineNumber=3043
	    ;;
	026112 )
	    ayahLineNumber=3044
	    ;;
	026113 )
	    ayahLineNumber=3045
	    ;;
	026114 )
	    ayahLineNumber=3046
	    ;;
	026115 )
	    ayahLineNumber=3047
	    ;;
	026116 )
	    ayahLineNumber=3048
	    ;;
	026117 )
	    ayahLineNumber=3049
	    ;;
	026118 )
	    ayahLineNumber=3050
	    ;;
	026119 )
	    ayahLineNumber=3051
	    ;;
	026120 )
	    ayahLineNumber=3052
	    ;;
	026121 )
	    ayahLineNumber=3053
	    ;;
	026122 )
	    ayahLineNumber=3054
	    ;;
	026123 )
	    ayahLineNumber=3055
	    ;;
	026124 )
	    ayahLineNumber=3056
	    ;;
	026125 )
	    ayahLineNumber=3057
	    ;;
	026126 )
	    ayahLineNumber=3058
	    ;;
	026127 )
	    ayahLineNumber=3059
	    ;;
	026128 )
	    ayahLineNumber=3060
	    ;;
	026129 )
	    ayahLineNumber=3061
	    ;;
	026130 )
	    ayahLineNumber=3062
	    ;;
	026131 )
	    ayahLineNumber=3063
	    ;;
	026132 )
	    ayahLineNumber=3064
	    ;;
	026133 )
	    ayahLineNumber=3065
	    ;;
	026134 )
	    ayahLineNumber=3066
	    ;;
	026135 )
	    ayahLineNumber=3067
	    ;;
	026136 )
	    ayahLineNumber=3068
	    ;;
	026137 )
	    ayahLineNumber=3069
	    ;;
	026138 )
	    ayahLineNumber=3070
	    ;;
	026139 )
	    ayahLineNumber=3071
	    ;;
	026140 )
	    ayahLineNumber=3072
	    ;;
	026141 )
	    ayahLineNumber=3073
	    ;;
	026142 )
	    ayahLineNumber=3074
	    ;;
	026143 )
	    ayahLineNumber=3075
	    ;;
	026144 )
	    ayahLineNumber=3076
	    ;;
	026145 )
	    ayahLineNumber=3077
	    ;;
	026146 )
	    ayahLineNumber=3078
	    ;;
	026147 )
	    ayahLineNumber=3079
	    ;;
	026148 )
	    ayahLineNumber=3080
	    ;;
	026149 )
	    ayahLineNumber=3081
	    ;;
	026150 )
	    ayahLineNumber=3082
	    ;;
	026151 )
	    ayahLineNumber=3083
	    ;;
	026152 )
	    ayahLineNumber=3084
	    ;;
	026153 )
	    ayahLineNumber=3085
	    ;;
	026154 )
	    ayahLineNumber=3086
	    ;;
	026155 )
	    ayahLineNumber=3087
	    ;;
	026156 )
	    ayahLineNumber=3088
	    ;;
	026157 )
	    ayahLineNumber=3089
	    ;;
	026158 )
	    ayahLineNumber=3090
	    ;;
	026159 )
	    ayahLineNumber=3091
	    ;;
	026160 )
	    ayahLineNumber=3092
	    ;;
	026161 )
	    ayahLineNumber=3093
	    ;;
	026162 )
	    ayahLineNumber=3094
	    ;;
	026163 )
	    ayahLineNumber=3095
	    ;;
	026164 )
	    ayahLineNumber=3096
	    ;;
	026165 )
	    ayahLineNumber=3097
	    ;;
	026166 )
	    ayahLineNumber=3098
	    ;;
	026167 )
	    ayahLineNumber=3099
	    ;;
	026168 )
	    ayahLineNumber=3100
	    ;;
	026169 )
	    ayahLineNumber=3101
	    ;;
	026170 )
	    ayahLineNumber=3102
	    ;;
	026171 )
	    ayahLineNumber=3103
	    ;;
	026172 )
	    ayahLineNumber=3104
	    ;;
	026173 )
	    ayahLineNumber=3105
	    ;;
	026174 )
	    ayahLineNumber=3106
	    ;;
	026175 )
	    ayahLineNumber=3107
	    ;;
	026176 )
	    ayahLineNumber=3108
	    ;;
	026177 )
	    ayahLineNumber=3109
	    ;;
	026178 )
	    ayahLineNumber=3110
	    ;;
	026179 )
	    ayahLineNumber=3111
	    ;;
	026180 )
	    ayahLineNumber=3112
	    ;;
	026181 )
	    ayahLineNumber=3113
	    ;;
	026182 )
	    ayahLineNumber=3114
	    ;;
	026183 )
	    ayahLineNumber=3115
	    ;;
	026184 )
	    ayahLineNumber=3116
	    ;;
	026185 )
	    ayahLineNumber=3117
	    ;;
	026186 )
	    ayahLineNumber=3118
	    ;;
	026187 )
	    ayahLineNumber=3119
	    ;;
	026188 )
	    ayahLineNumber=3120
	    ;;
	026189 )
	    ayahLineNumber=3121
	    ;;
	026190 )
	    ayahLineNumber=3122
	    ;;
	026191 )
	    ayahLineNumber=3123
	    ;;
	026192 )
	    ayahLineNumber=3124
	    ;;
	026193 )
	    ayahLineNumber=3125
	    ;;
	026194 )
	    ayahLineNumber=3126
	    ;;
	026195 )
	    ayahLineNumber=3127
	    ;;
	026196 )
	    ayahLineNumber=3128
	    ;;
	026197 )
	    ayahLineNumber=3129
	    ;;
	026198 )
	    ayahLineNumber=3130
	    ;;
	026199 )
	    ayahLineNumber=3131
	    ;;
	026200 )
	    ayahLineNumber=3132
	    ;;
	026201 )
	    ayahLineNumber=3133
	    ;;
	026202 )
	    ayahLineNumber=3134
	    ;;
	026203 )
	    ayahLineNumber=3135
	    ;;
	026204 )
	    ayahLineNumber=3136
	    ;;
	026205 )
	    ayahLineNumber=3137
	    ;;
	026206 )
	    ayahLineNumber=3138
	    ;;
	026207 )
	    ayahLineNumber=3139
	    ;;
	026208 )
	    ayahLineNumber=3140
	    ;;
	026209 )
	    ayahLineNumber=3141
	    ;;
	026210 )
	    ayahLineNumber=3142
	    ;;
	026211 )
	    ayahLineNumber=3143
	    ;;
	026212 )
	    ayahLineNumber=3144
	    ;;
	026213 )
	    ayahLineNumber=3145
	    ;;
	026214 )
	    ayahLineNumber=3146
	    ;;
	026215 )
	    ayahLineNumber=3147
	    ;;
	026216 )
	    ayahLineNumber=3148
	    ;;
	026217 )
	    ayahLineNumber=3149
	    ;;
	026218 )
	    ayahLineNumber=3150
	    ;;
	026219 )
	    ayahLineNumber=3151
	    ;;
	026220 )
	    ayahLineNumber=3152
	    ;;
	026221 )
	    ayahLineNumber=3153
	    ;;
	026222 )
	    ayahLineNumber=3154
	    ;;
	026223 )
	    ayahLineNumber=3155
	    ;;
	026224 )
	    ayahLineNumber=3156
	    ;;
	026225 )
	    ayahLineNumber=3157
	    ;;
	026226 )
	    ayahLineNumber=3158
	    ;;
	026227 )
	    ayahLineNumber=3159
	    ;;
	027001 )
	    ayahLineNumber=3160
	    ;;
	027002 )
	    ayahLineNumber=3161
	    ;;
	027003 )
	    ayahLineNumber=3162
	    ;;
	027004 )
	    ayahLineNumber=3163
	    ;;
	027005 )
	    ayahLineNumber=3164
	    ;;
	027006 )
	    ayahLineNumber=3165
	    ;;
	027007 )
	    ayahLineNumber=3166
	    ;;
	027008 )
	    ayahLineNumber=3167
	    ;;
	027009 )
	    ayahLineNumber=3168
	    ;;
	027010 )
	    ayahLineNumber=3169
	    ;;
	027011 )
	    ayahLineNumber=3170
	    ;;
	027012 )
	    ayahLineNumber=3171
	    ;;
	027013 )
	    ayahLineNumber=3172
	    ;;
	027014 )
	    ayahLineNumber=3173
	    ;;
	027015 )
	    ayahLineNumber=3174
	    ;;
	027016 )
	    ayahLineNumber=3175
	    ;;
	027017 )
	    ayahLineNumber=3176
	    ;;
	027018 )
	    ayahLineNumber=3177
	    ;;
	027019 )
	    ayahLineNumber=3178
	    ;;
	027020 )
	    ayahLineNumber=3179
	    ;;
	027021 )
	    ayahLineNumber=3180
	    ;;
	027022 )
	    ayahLineNumber=3181
	    ;;
	027023 )
	    ayahLineNumber=3182
	    ;;
	027024 )
	    ayahLineNumber=3183
	    ;;
	027025 )
	    ayahLineNumber=3184
	    ;;
	027026 )
	    ayahLineNumber=3185
	    ;;
	027027 )
	    ayahLineNumber=3186
	    ;;
	027028 )
	    ayahLineNumber=3187
	    ;;
	027029 )
	    ayahLineNumber=3188
	    ;;
	027030 )
	    ayahLineNumber=3189
	    ;;
	027031 )
	    ayahLineNumber=3190
	    ;;
	027032 )
	    ayahLineNumber=3191
	    ;;
	027033 )
	    ayahLineNumber=3192
	    ;;
	027034 )
	    ayahLineNumber=3193
	    ;;
	027035 )
	    ayahLineNumber=3194
	    ;;
	027036 )
	    ayahLineNumber=3195
	    ;;
	027037 )
	    ayahLineNumber=3196
	    ;;
	027038 )
	    ayahLineNumber=3197
	    ;;
	027039 )
	    ayahLineNumber=3198
	    ;;
	027040 )
	    ayahLineNumber=3199
	    ;;
	027041 )
	    ayahLineNumber=3200
	    ;;
	027042 )
	    ayahLineNumber=3201
	    ;;
	027043 )
	    ayahLineNumber=3202
	    ;;
	027044 )
	    ayahLineNumber=3203
	    ;;
	027045 )
	    ayahLineNumber=3204
	    ;;
	027046 )
	    ayahLineNumber=3205
	    ;;
	027047 )
	    ayahLineNumber=3206
	    ;;
	027048 )
	    ayahLineNumber=3207
	    ;;
	027049 )
	    ayahLineNumber=3208
	    ;;
	027050 )
	    ayahLineNumber=3209
	    ;;
	027051 )
	    ayahLineNumber=3210
	    ;;
	027052 )
	    ayahLineNumber=3211
	    ;;
	027053 )
	    ayahLineNumber=3212
	    ;;
	027054 )
	    ayahLineNumber=3213
	    ;;
	027055 )
	    ayahLineNumber=3214
	    ;;
	027056 )
	    ayahLineNumber=3215
	    ;;
	027057 )
	    ayahLineNumber=3216
	    ;;
	027058 )
	    ayahLineNumber=3217
	    ;;
	027059 )
	    ayahLineNumber=3218
	    ;;
	027060 )
	    ayahLineNumber=3219
	    ;;
	027061 )
	    ayahLineNumber=3220
	    ;;
	027062 )
	    ayahLineNumber=3221
	    ;;
	027063 )
	    ayahLineNumber=3222
	    ;;
	027064 )
	    ayahLineNumber=3223
	    ;;
	027065 )
	    ayahLineNumber=3224
	    ;;
	027066 )
	    ayahLineNumber=3225
	    ;;
	027067 )
	    ayahLineNumber=3226
	    ;;
	027068 )
	    ayahLineNumber=3227
	    ;;
	027069 )
	    ayahLineNumber=3228
	    ;;
	027070 )
	    ayahLineNumber=3229
	    ;;
	027071 )
	    ayahLineNumber=3230
	    ;;
	027072 )
	    ayahLineNumber=3231
	    ;;
	027073 )
	    ayahLineNumber=3232
	    ;;
	027074 )
	    ayahLineNumber=3233
	    ;;
	027075 )
	    ayahLineNumber=3234
	    ;;
	027076 )
	    ayahLineNumber=3235
	    ;;
	027077 )
	    ayahLineNumber=3236
	    ;;
	027078 )
	    ayahLineNumber=3237
	    ;;
	027079 )
	    ayahLineNumber=3238
	    ;;
	027080 )
	    ayahLineNumber=3239
	    ;;
	027081 )
	    ayahLineNumber=3240
	    ;;
	027082 )
	    ayahLineNumber=3241
	    ;;
	027083 )
	    ayahLineNumber=3242
	    ;;
	027084 )
	    ayahLineNumber=3243
	    ;;
	027085 )
	    ayahLineNumber=3244
	    ;;
	027086 )
	    ayahLineNumber=3245
	    ;;
	027087 )
	    ayahLineNumber=3246
	    ;;
	027088 )
	    ayahLineNumber=3247
	    ;;
	027089 )
	    ayahLineNumber=3248
	    ;;
	027090 )
	    ayahLineNumber=3249
	    ;;
	027091 )
	    ayahLineNumber=3250
	    ;;
	027092 )
	    ayahLineNumber=3251
	    ;;
	027093 )
	    ayahLineNumber=3252
	    ;;
	028001 )
	    ayahLineNumber=3253
	    ;;
	028002 )
	    ayahLineNumber=3254
	    ;;
	028003 )
	    ayahLineNumber=3255
	    ;;
	028004 )
	    ayahLineNumber=3256
	    ;;
	028005 )
	    ayahLineNumber=3257
	    ;;
	028006 )
	    ayahLineNumber=3258
	    ;;
	028007 )
	    ayahLineNumber=3259
	    ;;
	028008 )
	    ayahLineNumber=3260
	    ;;
	028009 )
	    ayahLineNumber=3261
	    ;;
	028010 )
	    ayahLineNumber=3262
	    ;;
	028011 )
	    ayahLineNumber=3263
	    ;;
	028012 )
	    ayahLineNumber=3264
	    ;;
	028013 )
	    ayahLineNumber=3265
	    ;;
	028014 )
	    ayahLineNumber=3266
	    ;;
	028015 )
	    ayahLineNumber=3267
	    ;;
	028016 )
	    ayahLineNumber=3268
	    ;;
	028017 )
	    ayahLineNumber=3269
	    ;;
	028018 )
	    ayahLineNumber=3270
	    ;;
	028019 )
	    ayahLineNumber=3271
	    ;;
	028020 )
	    ayahLineNumber=3272
	    ;;
	028021 )
	    ayahLineNumber=3273
	    ;;
	028022 )
	    ayahLineNumber=3274
	    ;;
	028023 )
	    ayahLineNumber=3275
	    ;;
	028024 )
	    ayahLineNumber=3276
	    ;;
	028025 )
	    ayahLineNumber=3277
	    ;;
	028026 )
	    ayahLineNumber=3278
	    ;;
	028027 )
	    ayahLineNumber=3279
	    ;;
	028028 )
	    ayahLineNumber=3280
	    ;;
	028029 )
	    ayahLineNumber=3281
	    ;;
	028030 )
	    ayahLineNumber=3282
	    ;;
	028031 )
	    ayahLineNumber=3283
	    ;;
	028032 )
	    ayahLineNumber=3284
	    ;;
	028033 )
	    ayahLineNumber=3285
	    ;;
	028034 )
	    ayahLineNumber=3286
	    ;;
	028035 )
	    ayahLineNumber=3287
	    ;;
	028036 )
	    ayahLineNumber=3288
	    ;;
	028037 )
	    ayahLineNumber=3289
	    ;;
	028038 )
	    ayahLineNumber=3290
	    ;;
	028039 )
	    ayahLineNumber=3291
	    ;;
	028040 )
	    ayahLineNumber=3292
	    ;;
	028041 )
	    ayahLineNumber=3293
	    ;;
	028042 )
	    ayahLineNumber=3294
	    ;;
	028043 )
	    ayahLineNumber=3295
	    ;;
	028044 )
	    ayahLineNumber=3296
	    ;;
	028045 )
	    ayahLineNumber=3297
	    ;;
	028046 )
	    ayahLineNumber=3298
	    ;;
	028047 )
	    ayahLineNumber=3299
	    ;;
	028048 )
	    ayahLineNumber=3300
	    ;;
	028049 )
	    ayahLineNumber=3301
	    ;;
	028050 )
	    ayahLineNumber=3302
	    ;;
	028051 )
	    ayahLineNumber=3303
	    ;;
	028052 )
	    ayahLineNumber=3304
	    ;;
	028053 )
	    ayahLineNumber=3305
	    ;;
	028054 )
	    ayahLineNumber=3306
	    ;;
	028055 )
	    ayahLineNumber=3307
	    ;;
	028056 )
	    ayahLineNumber=3308
	    ;;
	028057 )
	    ayahLineNumber=3309
	    ;;
	028058 )
	    ayahLineNumber=3310
	    ;;
	028059 )
	    ayahLineNumber=3311
	    ;;
	028060 )
	    ayahLineNumber=3312
	    ;;
	028061 )
	    ayahLineNumber=3313
	    ;;
	028062 )
	    ayahLineNumber=3314
	    ;;
	028063 )
	    ayahLineNumber=3315
	    ;;
	028064 )
	    ayahLineNumber=3316
	    ;;
	028065 )
	    ayahLineNumber=3317
	    ;;
	028066 )
	    ayahLineNumber=3318
	    ;;
	028067 )
	    ayahLineNumber=3319
	    ;;
	028068 )
	    ayahLineNumber=3320
	    ;;
	028069 )
	    ayahLineNumber=3321
	    ;;
	028070 )
	    ayahLineNumber=3322
	    ;;
	028071 )
	    ayahLineNumber=3323
	    ;;
	028072 )
	    ayahLineNumber=3324
	    ;;
	028073 )
	    ayahLineNumber=3325
	    ;;
	028074 )
	    ayahLineNumber=3326
	    ;;
	028075 )
	    ayahLineNumber=3327
	    ;;
	028076 )
	    ayahLineNumber=3328
	    ;;
	028077 )
	    ayahLineNumber=3329
	    ;;
	028078 )
	    ayahLineNumber=3330
	    ;;
	028079 )
	    ayahLineNumber=3331
	    ;;
	028080 )
	    ayahLineNumber=3332
	    ;;
	028081 )
	    ayahLineNumber=3333
	    ;;
	028082 )
	    ayahLineNumber=3334
	    ;;
	028083 )
	    ayahLineNumber=3335
	    ;;
	028084 )
	    ayahLineNumber=3336
	    ;;
	028085 )
	    ayahLineNumber=3337
	    ;;
	028086 )
	    ayahLineNumber=3338
	    ;;
	028087 )
	    ayahLineNumber=3339
	    ;;
	028088 )
	    ayahLineNumber=3340
	    ;;
	029001 )
	    ayahLineNumber=3341
	    ;;
	029002 )
	    ayahLineNumber=3342
	    ;;
	029003 )
	    ayahLineNumber=3343
	    ;;
	029004 )
	    ayahLineNumber=3344
	    ;;
	029005 )
	    ayahLineNumber=3345
	    ;;
	029006 )
	    ayahLineNumber=3346
	    ;;
	029007 )
	    ayahLineNumber=3347
	    ;;
	029008 )
	    ayahLineNumber=3348
	    ;;
	029009 )
	    ayahLineNumber=3349
	    ;;
	029010 )
	    ayahLineNumber=3350
	    ;;
	029011 )
	    ayahLineNumber=3351
	    ;;
	029012 )
	    ayahLineNumber=3352
	    ;;
	029013 )
	    ayahLineNumber=3353
	    ;;
	029014 )
	    ayahLineNumber=3354
	    ;;
	029015 )
	    ayahLineNumber=3355
	    ;;
	029016 )
	    ayahLineNumber=3356
	    ;;
	029017 )
	    ayahLineNumber=3357
	    ;;
	029018 )
	    ayahLineNumber=3358
	    ;;
	029019 )
	    ayahLineNumber=3359
	    ;;
	029020 )
	    ayahLineNumber=3360
	    ;;
	029021 )
	    ayahLineNumber=3361
	    ;;
	029022 )
	    ayahLineNumber=3362
	    ;;
	029023 )
	    ayahLineNumber=3363
	    ;;
	029024 )
	    ayahLineNumber=3364
	    ;;
	029025 )
	    ayahLineNumber=3365
	    ;;
	029026 )
	    ayahLineNumber=3366
	    ;;
	029027 )
	    ayahLineNumber=3367
	    ;;
	029028 )
	    ayahLineNumber=3368
	    ;;
	029029 )
	    ayahLineNumber=3369
	    ;;
	029030 )
	    ayahLineNumber=3370
	    ;;
	029031 )
	    ayahLineNumber=3371
	    ;;
	029032 )
	    ayahLineNumber=3372
	    ;;
	029033 )
	    ayahLineNumber=3373
	    ;;
	029034 )
	    ayahLineNumber=3374
	    ;;
	029035 )
	    ayahLineNumber=3375
	    ;;
	029036 )
	    ayahLineNumber=3376
	    ;;
	029037 )
	    ayahLineNumber=3377
	    ;;
	029038 )
	    ayahLineNumber=3378
	    ;;
	029039 )
	    ayahLineNumber=3379
	    ;;
	029040 )
	    ayahLineNumber=3380
	    ;;
	029041 )
	    ayahLineNumber=3381
	    ;;
	029042 )
	    ayahLineNumber=3382
	    ;;
	029043 )
	    ayahLineNumber=3383
	    ;;
	029044 )
	    ayahLineNumber=3384
	    ;;
	029045 )
	    ayahLineNumber=3385
	    ;;
	029046 )
	    ayahLineNumber=3386
	    ;;
	029047 )
	    ayahLineNumber=3387
	    ;;
	029048 )
	    ayahLineNumber=3388
	    ;;
	029049 )
	    ayahLineNumber=3389
	    ;;
	029050 )
	    ayahLineNumber=3390
	    ;;
	029051 )
	    ayahLineNumber=3391
	    ;;
	029052 )
	    ayahLineNumber=3392
	    ;;
	029053 )
	    ayahLineNumber=3393
	    ;;
	029054 )
	    ayahLineNumber=3394
	    ;;
	029055 )
	    ayahLineNumber=3395
	    ;;
	029056 )
	    ayahLineNumber=3396
	    ;;
	029057 )
	    ayahLineNumber=3397
	    ;;
	029058 )
	    ayahLineNumber=3398
	    ;;
	029059 )
	    ayahLineNumber=3399
	    ;;
	029060 )
	    ayahLineNumber=3400
	    ;;
	029061 )
	    ayahLineNumber=3401
	    ;;
	029062 )
	    ayahLineNumber=3402
	    ;;
	029063 )
	    ayahLineNumber=3403
	    ;;
	029064 )
	    ayahLineNumber=3404
	    ;;
	029065 )
	    ayahLineNumber=3405
	    ;;
	029066 )
	    ayahLineNumber=3406
	    ;;
	029067 )
	    ayahLineNumber=3407
	    ;;
	029068 )
	    ayahLineNumber=3408
	    ;;
	029069 )
	    ayahLineNumber=3409
	    ;;
	030001 )
	    ayahLineNumber=3410
	    ;;
	030002 )
	    ayahLineNumber=3411
	    ;;
	030003 )
	    ayahLineNumber=3412
	    ;;
	030004 )
	    ayahLineNumber=3413
	    ;;
	030005 )
	    ayahLineNumber=3414
	    ;;
	030006 )
	    ayahLineNumber=3415
	    ;;
	030007 )
	    ayahLineNumber=3416
	    ;;
	030008 )
	    ayahLineNumber=3417
	    ;;
	030009 )
	    ayahLineNumber=3418
	    ;;
	030010 )
	    ayahLineNumber=3419
	    ;;
	030011 )
	    ayahLineNumber=3420
	    ;;
	030012 )
	    ayahLineNumber=3421
	    ;;
	030013 )
	    ayahLineNumber=3422
	    ;;
	030014 )
	    ayahLineNumber=3423
	    ;;
	030015 )
	    ayahLineNumber=3424
	    ;;
	030016 )
	    ayahLineNumber=3425
	    ;;
	030017 )
	    ayahLineNumber=3426
	    ;;
	030018 )
	    ayahLineNumber=3427
	    ;;
	030019 )
	    ayahLineNumber=3428
	    ;;
	030020 )
	    ayahLineNumber=3429
	    ;;
	030021 )
	    ayahLineNumber=3430
	    ;;
	030022 )
	    ayahLineNumber=3431
	    ;;
	030023 )
	    ayahLineNumber=3432
	    ;;
	030024 )
	    ayahLineNumber=3433
	    ;;
	030025 )
	    ayahLineNumber=3434
	    ;;
	030026 )
	    ayahLineNumber=3435
	    ;;
	030027 )
	    ayahLineNumber=3436
	    ;;
	030028 )
	    ayahLineNumber=3437
	    ;;
	030029 )
	    ayahLineNumber=3438
	    ;;
	030030 )
	    ayahLineNumber=3439
	    ;;
	030031 )
	    ayahLineNumber=3440
	    ;;
	030032 )
	    ayahLineNumber=3441
	    ;;
	030033 )
	    ayahLineNumber=3442
	    ;;
	030034 )
	    ayahLineNumber=3443
	    ;;
	030035 )
	    ayahLineNumber=3444
	    ;;
	030036 )
	    ayahLineNumber=3445
	    ;;
	030037 )
	    ayahLineNumber=3446
	    ;;
	030038 )
	    ayahLineNumber=3447
	    ;;
	030039 )
	    ayahLineNumber=3448
	    ;;
	030040 )
	    ayahLineNumber=3449
	    ;;
	030041 )
	    ayahLineNumber=3450
	    ;;
	030042 )
	    ayahLineNumber=3451
	    ;;
	030043 )
	    ayahLineNumber=3452
	    ;;
	030044 )
	    ayahLineNumber=3453
	    ;;
	030045 )
	    ayahLineNumber=3454
	    ;;
	030046 )
	    ayahLineNumber=3455
	    ;;
	030047 )
	    ayahLineNumber=3456
	    ;;
	030048 )
	    ayahLineNumber=3457
	    ;;
	030049 )
	    ayahLineNumber=3458
	    ;;
	030050 )
	    ayahLineNumber=3459
	    ;;
	030051 )
	    ayahLineNumber=3460
	    ;;
	030052 )
	    ayahLineNumber=3461
	    ;;
	030053 )
	    ayahLineNumber=3462
	    ;;
	030054 )
	    ayahLineNumber=3463
	    ;;
	030055 )
	    ayahLineNumber=3464
	    ;;
	030056 )
	    ayahLineNumber=3465
	    ;;
	030057 )
	    ayahLineNumber=3466
	    ;;
	030058 )
	    ayahLineNumber=3467
	    ;;
	030059 )
	    ayahLineNumber=3468
	    ;;
	030060 )
	    ayahLineNumber=3469
	    ;;
	031001 )
	    ayahLineNumber=3470
	    ;;
	031002 )
	    ayahLineNumber=3471
	    ;;
	031003 )
	    ayahLineNumber=3472
	    ;;
	031004 )
	    ayahLineNumber=3473
	    ;;
	031005 )
	    ayahLineNumber=3474
	    ;;
	031006 )
	    ayahLineNumber=3475
	    ;;
	031007 )
	    ayahLineNumber=3476
	    ;;
	031008 )
	    ayahLineNumber=3477
	    ;;
	031009 )
	    ayahLineNumber=3478
	    ;;
	031010 )
	    ayahLineNumber=3479
	    ;;
	031011 )
	    ayahLineNumber=3480
	    ;;
	031012 )
	    ayahLineNumber=3481
	    ;;
	031013 )
	    ayahLineNumber=3482
	    ;;
	031014 )
	    ayahLineNumber=3483
	    ;;
	031015 )
	    ayahLineNumber=3484
	    ;;
	031016 )
	    ayahLineNumber=3485
	    ;;
	031017 )
	    ayahLineNumber=3486
	    ;;
	031018 )
	    ayahLineNumber=3487
	    ;;
	031019 )
	    ayahLineNumber=3488
	    ;;
	031020 )
	    ayahLineNumber=3489
	    ;;
	031021 )
	    ayahLineNumber=3490
	    ;;
	031022 )
	    ayahLineNumber=3491
	    ;;
	031023 )
	    ayahLineNumber=3492
	    ;;
	031024 )
	    ayahLineNumber=3493
	    ;;
	031025 )
	    ayahLineNumber=3494
	    ;;
	031026 )
	    ayahLineNumber=3495
	    ;;
	031027 )
	    ayahLineNumber=3496
	    ;;
	031028 )
	    ayahLineNumber=3497
	    ;;
	031029 )
	    ayahLineNumber=3498
	    ;;
	031030 )
	    ayahLineNumber=3499
	    ;;
	031031 )
	    ayahLineNumber=3500
	    ;;
	031032 )
	    ayahLineNumber=3501
	    ;;
	031033 )
	    ayahLineNumber=3502
	    ;;
	031034 )
	    ayahLineNumber=3503
	    ;;
	032001 )
	    ayahLineNumber=3504
	    ;;
	032002 )
	    ayahLineNumber=3505
	    ;;
	032003 )
	    ayahLineNumber=3506
	    ;;
	032004 )
	    ayahLineNumber=3507
	    ;;
	032005 )
	    ayahLineNumber=3508
	    ;;
	032006 )
	    ayahLineNumber=3509
	    ;;
	032007 )
	    ayahLineNumber=3510
	    ;;
	032008 )
	    ayahLineNumber=3511
	    ;;
	032009 )
	    ayahLineNumber=3512
	    ;;
	032010 )
	    ayahLineNumber=3513
	    ;;
	032011 )
	    ayahLineNumber=3514
	    ;;
	032012 )
	    ayahLineNumber=3515
	    ;;
	032013 )
	    ayahLineNumber=3516
	    ;;
	032014 )
	    ayahLineNumber=3517
	    ;;
	032015 )
	    ayahLineNumber=3518
	    ;;
	032016 )
	    ayahLineNumber=3519
	    ;;
	032017 )
	    ayahLineNumber=3520
	    ;;
	032018 )
	    ayahLineNumber=3521
	    ;;
	032019 )
	    ayahLineNumber=3522
	    ;;
	032020 )
	    ayahLineNumber=3523
	    ;;
	032021 )
	    ayahLineNumber=3524
	    ;;
	032022 )
	    ayahLineNumber=3525
	    ;;
	032023 )
	    ayahLineNumber=3526
	    ;;
	032024 )
	    ayahLineNumber=3527
	    ;;
	032025 )
	    ayahLineNumber=3528
	    ;;
	032026 )
	    ayahLineNumber=3529
	    ;;
	032027 )
	    ayahLineNumber=3530
	    ;;
	032028 )
	    ayahLineNumber=3531
	    ;;
	032029 )
	    ayahLineNumber=3532
	    ;;
	032030 )
	    ayahLineNumber=3533
	    ;;
	033001 )
	    ayahLineNumber=3534
	    ;;
	033002 )
	    ayahLineNumber=3535
	    ;;
	033003 )
	    ayahLineNumber=3536
	    ;;
	033004 )
	    ayahLineNumber=3537
	    ;;
	033005 )
	    ayahLineNumber=3538
	    ;;
	033006 )
	    ayahLineNumber=3539
	    ;;
	033007 )
	    ayahLineNumber=3540
	    ;;
	033008 )
	    ayahLineNumber=3541
	    ;;
	033009 )
	    ayahLineNumber=3542
	    ;;
	033010 )
	    ayahLineNumber=3543
	    ;;
	033011 )
	    ayahLineNumber=3544
	    ;;
	033012 )
	    ayahLineNumber=3545
	    ;;
	033013 )
	    ayahLineNumber=3546
	    ;;
	033014 )
	    ayahLineNumber=3547
	    ;;
	033015 )
	    ayahLineNumber=3548
	    ;;
	033016 )
	    ayahLineNumber=3549
	    ;;
	033017 )
	    ayahLineNumber=3550
	    ;;
	033018 )
	    ayahLineNumber=3551
	    ;;
	033019 )
	    ayahLineNumber=3552
	    ;;
	033020 )
	    ayahLineNumber=3553
	    ;;
	033021 )
	    ayahLineNumber=3554
	    ;;
	033022 )
	    ayahLineNumber=3555
	    ;;
	033023 )
	    ayahLineNumber=3556
	    ;;
	033024 )
	    ayahLineNumber=3557
	    ;;
	033025 )
	    ayahLineNumber=3558
	    ;;
	033026 )
	    ayahLineNumber=3559
	    ;;
	033027 )
	    ayahLineNumber=3560
	    ;;
	033028 )
	    ayahLineNumber=3561
	    ;;
	033029 )
	    ayahLineNumber=3562
	    ;;
	033030 )
	    ayahLineNumber=3563
	    ;;
	033031 )
	    ayahLineNumber=3564
	    ;;
	033032 )
	    ayahLineNumber=3565
	    ;;
	033033 )
	    ayahLineNumber=3566
	    ;;
	033034 )
	    ayahLineNumber=3567
	    ;;
	033035 )
	    ayahLineNumber=3568
	    ;;
	033036 )
	    ayahLineNumber=3569
	    ;;
	033037 )
	    ayahLineNumber=3570
	    ;;
	033038 )
	    ayahLineNumber=3571
	    ;;
	033039 )
	    ayahLineNumber=3572
	    ;;
	033040 )
	    ayahLineNumber=3573
	    ;;
	033041 )
	    ayahLineNumber=3574
	    ;;
	033042 )
	    ayahLineNumber=3575
	    ;;
	033043 )
	    ayahLineNumber=3576
	    ;;
	033044 )
	    ayahLineNumber=3577
	    ;;
	033045 )
	    ayahLineNumber=3578
	    ;;
	033046 )
	    ayahLineNumber=3579
	    ;;
	033047 )
	    ayahLineNumber=3580
	    ;;
	033048 )
	    ayahLineNumber=3581
	    ;;
	033049 )
	    ayahLineNumber=3582
	    ;;
	033050 )
	    ayahLineNumber=3583
	    ;;
	033051 )
	    ayahLineNumber=3584
	    ;;
	033052 )
	    ayahLineNumber=3585
	    ;;
	033053 )
	    ayahLineNumber=3586
	    ;;
	033054 )
	    ayahLineNumber=3587
	    ;;
	033055 )
	    ayahLineNumber=3588
	    ;;
	033056 )
	    ayahLineNumber=3589
	    ;;
	033057 )
	    ayahLineNumber=3590
	    ;;
	033058 )
	    ayahLineNumber=3591
	    ;;
	033059 )
	    ayahLineNumber=3592
	    ;;
	033060 )
	    ayahLineNumber=3593
	    ;;
	033061 )
	    ayahLineNumber=3594
	    ;;
	033062 )
	    ayahLineNumber=3595
	    ;;
	033063 )
	    ayahLineNumber=3596
	    ;;
	033064 )
	    ayahLineNumber=3597
	    ;;
	033065 )
	    ayahLineNumber=3598
	    ;;
	033066 )
	    ayahLineNumber=3599
	    ;;
	033067 )
	    ayahLineNumber=3600
	    ;;
	033068 )
	    ayahLineNumber=3601
	    ;;
	033069 )
	    ayahLineNumber=3602
	    ;;
	033070 )
	    ayahLineNumber=3603
	    ;;
	033071 )
	    ayahLineNumber=3604
	    ;;
	033072 )
	    ayahLineNumber=3605
	    ;;
	033073 )
	    ayahLineNumber=3606
	    ;;
	034001 )
	    ayahLineNumber=3607
	    ;;
	034002 )
	    ayahLineNumber=3608
	    ;;
	034003 )
	    ayahLineNumber=3609
	    ;;
	034004 )
	    ayahLineNumber=3610
	    ;;
	034005 )
	    ayahLineNumber=3611
	    ;;
	034006 )
	    ayahLineNumber=3612
	    ;;
	034007 )
	    ayahLineNumber=3613
	    ;;
	034008 )
	    ayahLineNumber=3614
	    ;;
	034009 )
	    ayahLineNumber=3615
	    ;;
	034010 )
	    ayahLineNumber=3616
	    ;;
	034011 )
	    ayahLineNumber=3617
	    ;;
	034012 )
	    ayahLineNumber=3618
	    ;;
	034013 )
	    ayahLineNumber=3619
	    ;;
	034014 )
	    ayahLineNumber=3620
	    ;;
	034015 )
	    ayahLineNumber=3621
	    ;;
	034016 )
	    ayahLineNumber=3622
	    ;;
	034017 )
	    ayahLineNumber=3623
	    ;;
	034018 )
	    ayahLineNumber=3624
	    ;;
	034019 )
	    ayahLineNumber=3625
	    ;;
	034020 )
	    ayahLineNumber=3626
	    ;;
	034021 )
	    ayahLineNumber=3627
	    ;;
	034022 )
	    ayahLineNumber=3628
	    ;;
	034023 )
	    ayahLineNumber=3629
	    ;;
	034024 )
	    ayahLineNumber=3630
	    ;;
	034025 )
	    ayahLineNumber=3631
	    ;;
	034026 )
	    ayahLineNumber=3632
	    ;;
	034027 )
	    ayahLineNumber=3633
	    ;;
	034028 )
	    ayahLineNumber=3634
	    ;;
	034029 )
	    ayahLineNumber=3635
	    ;;
	034030 )
	    ayahLineNumber=3636
	    ;;
	034031 )
	    ayahLineNumber=3637
	    ;;
	034032 )
	    ayahLineNumber=3638
	    ;;
	034033 )
	    ayahLineNumber=3639
	    ;;
	034034 )
	    ayahLineNumber=3640
	    ;;
	034035 )
	    ayahLineNumber=3641
	    ;;
	034036 )
	    ayahLineNumber=3642
	    ;;
	034037 )
	    ayahLineNumber=3643
	    ;;
	034038 )
	    ayahLineNumber=3644
	    ;;
	034039 )
	    ayahLineNumber=3645
	    ;;
	034040 )
	    ayahLineNumber=3646
	    ;;
	034041 )
	    ayahLineNumber=3647
	    ;;
	034042 )
	    ayahLineNumber=3648
	    ;;
	034043 )
	    ayahLineNumber=3649
	    ;;
	034044 )
	    ayahLineNumber=3650
	    ;;
	034045 )
	    ayahLineNumber=3651
	    ;;
	034046 )
	    ayahLineNumber=3652
	    ;;
	034047 )
	    ayahLineNumber=3653
	    ;;
	034048 )
	    ayahLineNumber=3654
	    ;;
	034049 )
	    ayahLineNumber=3655
	    ;;
	034050 )
	    ayahLineNumber=3656
	    ;;
	034051 )
	    ayahLineNumber=3657
	    ;;
	034052 )
	    ayahLineNumber=3658
	    ;;
	034053 )
	    ayahLineNumber=3659
	    ;;
	034054 )
	    ayahLineNumber=3660
	    ;;
	035001 )
	    ayahLineNumber=3661
	    ;;
	035002 )
	    ayahLineNumber=3662
	    ;;
	035003 )
	    ayahLineNumber=3663
	    ;;
	035004 )
	    ayahLineNumber=3664
	    ;;
	035005 )
	    ayahLineNumber=3665
	    ;;
	035006 )
	    ayahLineNumber=3666
	    ;;
	035007 )
	    ayahLineNumber=3667
	    ;;
	035008 )
	    ayahLineNumber=3668
	    ;;
	035009 )
	    ayahLineNumber=3669
	    ;;
	035010 )
	    ayahLineNumber=3670
	    ;;
	035011 )
	    ayahLineNumber=3671
	    ;;
	035012 )
	    ayahLineNumber=3672
	    ;;
	035013 )
	    ayahLineNumber=3673
	    ;;
	035014 )
	    ayahLineNumber=3674
	    ;;
	035015 )
	    ayahLineNumber=3675
	    ;;
	035016 )
	    ayahLineNumber=3676
	    ;;
	035017 )
	    ayahLineNumber=3677
	    ;;
	035018 )
	    ayahLineNumber=3678
	    ;;
	035019 )
	    ayahLineNumber=3679
	    ;;
	035020 )
	    ayahLineNumber=3680
	    ;;
	035021 )
	    ayahLineNumber=3681
	    ;;
	035022 )
	    ayahLineNumber=3682
	    ;;
	035023 )
	    ayahLineNumber=3683
	    ;;
	035024 )
	    ayahLineNumber=3684
	    ;;
	035025 )
	    ayahLineNumber=3685
	    ;;
	035026 )
	    ayahLineNumber=3686
	    ;;
	035027 )
	    ayahLineNumber=3687
	    ;;
	035028 )
	    ayahLineNumber=3688
	    ;;
	035029 )
	    ayahLineNumber=3689
	    ;;
	035030 )
	    ayahLineNumber=3690
	    ;;
	035031 )
	    ayahLineNumber=3691
	    ;;
	035032 )
	    ayahLineNumber=3692
	    ;;
	035033 )
	    ayahLineNumber=3693
	    ;;
	035034 )
	    ayahLineNumber=3694
	    ;;
	035035 )
	    ayahLineNumber=3695
	    ;;
	035036 )
	    ayahLineNumber=3696
	    ;;
	035037 )
	    ayahLineNumber=3697
	    ;;
	035038 )
	    ayahLineNumber=3698
	    ;;
	035039 )
	    ayahLineNumber=3699
	    ;;
	035040 )
	    ayahLineNumber=3700
	    ;;
	035041 )
	    ayahLineNumber=3701
	    ;;
	035042 )
	    ayahLineNumber=3702
	    ;;
	035043 )
	    ayahLineNumber=3703
	    ;;
	035044 )
	    ayahLineNumber=3704
	    ;;
	035045 )
	    ayahLineNumber=3705
	    ;;
	036001 )
	    ayahLineNumber=3706
	    ;;
	036002 )
	    ayahLineNumber=3707
	    ;;
	036003 )
	    ayahLineNumber=3708
	    ;;
	036004 )
	    ayahLineNumber=3709
	    ;;
	036005 )
	    ayahLineNumber=3710
	    ;;
	036006 )
	    ayahLineNumber=3711
	    ;;
	036007 )
	    ayahLineNumber=3712
	    ;;
	036008 )
	    ayahLineNumber=3713
	    ;;
	036009 )
	    ayahLineNumber=3714
	    ;;
	036010 )
	    ayahLineNumber=3715
	    ;;
	036011 )
	    ayahLineNumber=3716
	    ;;
	036012 )
	    ayahLineNumber=3717
	    ;;
	036013 )
	    ayahLineNumber=3718
	    ;;
	036014 )
	    ayahLineNumber=3719
	    ;;
	036015 )
	    ayahLineNumber=3720
	    ;;
	036016 )
	    ayahLineNumber=3721
	    ;;
	036017 )
	    ayahLineNumber=3722
	    ;;
	036018 )
	    ayahLineNumber=3723
	    ;;
	036019 )
	    ayahLineNumber=3724
	    ;;
	036020 )
	    ayahLineNumber=3725
	    ;;
	036021 )
	    ayahLineNumber=3726
	    ;;
	036022 )
	    ayahLineNumber=3727
	    ;;
	036023 )
	    ayahLineNumber=3728
	    ;;
	036024 )
	    ayahLineNumber=3729
	    ;;
	036025 )
	    ayahLineNumber=3730
	    ;;
	036026 )
	    ayahLineNumber=3731
	    ;;
	036027 )
	    ayahLineNumber=3732
	    ;;
	036028 )
	    ayahLineNumber=3733
	    ;;
	036029 )
	    ayahLineNumber=3734
	    ;;
	036030 )
	    ayahLineNumber=3735
	    ;;
	036031 )
	    ayahLineNumber=3736
	    ;;
	036032 )
	    ayahLineNumber=3737
	    ;;
	036033 )
	    ayahLineNumber=3738
	    ;;
	036034 )
	    ayahLineNumber=3739
	    ;;
	036035 )
	    ayahLineNumber=3740
	    ;;
	036036 )
	    ayahLineNumber=3741
	    ;;
	036037 )
	    ayahLineNumber=3742
	    ;;
	036038 )
	    ayahLineNumber=3743
	    ;;
	036039 )
	    ayahLineNumber=3744
	    ;;
	036040 )
	    ayahLineNumber=3745
	    ;;
	036041 )
	    ayahLineNumber=3746
	    ;;
	036042 )
	    ayahLineNumber=3747
	    ;;
	036043 )
	    ayahLineNumber=3748
	    ;;
	036044 )
	    ayahLineNumber=3749
	    ;;
	036045 )
	    ayahLineNumber=3750
	    ;;
	036046 )
	    ayahLineNumber=3751
	    ;;
	036047 )
	    ayahLineNumber=3752
	    ;;
	036048 )
	    ayahLineNumber=3753
	    ;;
	036049 )
	    ayahLineNumber=3754
	    ;;
	036050 )
	    ayahLineNumber=3755
	    ;;
	036051 )
	    ayahLineNumber=3756
	    ;;
	036052 )
	    ayahLineNumber=3757
	    ;;
	036053 )
	    ayahLineNumber=3758
	    ;;
	036054 )
	    ayahLineNumber=3759
	    ;;
	036055 )
	    ayahLineNumber=3760
	    ;;
	036056 )
	    ayahLineNumber=3761
	    ;;
	036057 )
	    ayahLineNumber=3762
	    ;;
	036058 )
	    ayahLineNumber=3763
	    ;;
	036059 )
	    ayahLineNumber=3764
	    ;;
	036060 )
	    ayahLineNumber=3765
	    ;;
	036061 )
	    ayahLineNumber=3766
	    ;;
	036062 )
	    ayahLineNumber=3767
	    ;;
	036063 )
	    ayahLineNumber=3768
	    ;;
	036064 )
	    ayahLineNumber=3769
	    ;;
	036065 )
	    ayahLineNumber=3770
	    ;;
	036066 )
	    ayahLineNumber=3771
	    ;;
	036067 )
	    ayahLineNumber=3772
	    ;;
	036068 )
	    ayahLineNumber=3773
	    ;;
	036069 )
	    ayahLineNumber=3774
	    ;;
	036070 )
	    ayahLineNumber=3775
	    ;;
	036071 )
	    ayahLineNumber=3776
	    ;;
	036072 )
	    ayahLineNumber=3777
	    ;;
	036073 )
	    ayahLineNumber=3778
	    ;;
	036074 )
	    ayahLineNumber=3779
	    ;;
	036075 )
	    ayahLineNumber=3780
	    ;;
	036076 )
	    ayahLineNumber=3781
	    ;;
	036077 )
	    ayahLineNumber=3782
	    ;;
	036078 )
	    ayahLineNumber=3783
	    ;;
	036079 )
	    ayahLineNumber=3784
	    ;;
	036080 )
	    ayahLineNumber=3785
	    ;;
	036081 )
	    ayahLineNumber=3786
	    ;;
	036082 )
	    ayahLineNumber=3787
	    ;;
	036083 )
	    ayahLineNumber=3788
	    ;;
	037001 )
	    ayahLineNumber=3789
	    ;;
	037002 )
	    ayahLineNumber=3790
	    ;;
	037003 )
	    ayahLineNumber=3791
	    ;;
	037004 )
	    ayahLineNumber=3792
	    ;;
	037005 )
	    ayahLineNumber=3793
	    ;;
	037006 )
	    ayahLineNumber=3794
	    ;;
	037007 )
	    ayahLineNumber=3795
	    ;;
	037008 )
	    ayahLineNumber=3796
	    ;;
	037009 )
	    ayahLineNumber=3797
	    ;;
	037010 )
	    ayahLineNumber=3798
	    ;;
	037011 )
	    ayahLineNumber=3799
	    ;;
	037012 )
	    ayahLineNumber=3800
	    ;;
	037013 )
	    ayahLineNumber=3801
	    ;;
	037014 )
	    ayahLineNumber=3802
	    ;;
	037015 )
	    ayahLineNumber=3803
	    ;;
	037016 )
	    ayahLineNumber=3804
	    ;;
	037017 )
	    ayahLineNumber=3805
	    ;;
	037018 )
	    ayahLineNumber=3806
	    ;;
	037019 )
	    ayahLineNumber=3807
	    ;;
	037020 )
	    ayahLineNumber=3808
	    ;;
	037021 )
	    ayahLineNumber=3809
	    ;;
	037022 )
	    ayahLineNumber=3810
	    ;;
	037023 )
	    ayahLineNumber=3811
	    ;;
	037024 )
	    ayahLineNumber=3812
	    ;;
	037025 )
	    ayahLineNumber=3813
	    ;;
	037026 )
	    ayahLineNumber=3814
	    ;;
	037027 )
	    ayahLineNumber=3815
	    ;;
	037028 )
	    ayahLineNumber=3816
	    ;;
	037029 )
	    ayahLineNumber=3817
	    ;;
	037030 )
	    ayahLineNumber=3818
	    ;;
	037031 )
	    ayahLineNumber=3819
	    ;;
	037032 )
	    ayahLineNumber=3820
	    ;;
	037033 )
	    ayahLineNumber=3821
	    ;;
	037034 )
	    ayahLineNumber=3822
	    ;;
	037035 )
	    ayahLineNumber=3823
	    ;;
	037036 )
	    ayahLineNumber=3824
	    ;;
	037037 )
	    ayahLineNumber=3825
	    ;;
	037038 )
	    ayahLineNumber=3826
	    ;;
	037039 )
	    ayahLineNumber=3827
	    ;;
	037040 )
	    ayahLineNumber=3828
	    ;;
	037041 )
	    ayahLineNumber=3829
	    ;;
	037042 )
	    ayahLineNumber=3830
	    ;;
	037043 )
	    ayahLineNumber=3831
	    ;;
	037044 )
	    ayahLineNumber=3832
	    ;;
	037045 )
	    ayahLineNumber=3833
	    ;;
	037046 )
	    ayahLineNumber=3834
	    ;;
	037047 )
	    ayahLineNumber=3835
	    ;;
	037048 )
	    ayahLineNumber=3836
	    ;;
	037049 )
	    ayahLineNumber=3837
	    ;;
	037050 )
	    ayahLineNumber=3838
	    ;;
	037051 )
	    ayahLineNumber=3839
	    ;;
	037052 )
	    ayahLineNumber=3840
	    ;;
	037053 )
	    ayahLineNumber=3841
	    ;;
	037054 )
	    ayahLineNumber=3842
	    ;;
	037055 )
	    ayahLineNumber=3843
	    ;;
	037056 )
	    ayahLineNumber=3844
	    ;;
	037057 )
	    ayahLineNumber=3845
	    ;;
	037058 )
	    ayahLineNumber=3846
	    ;;
	037059 )
	    ayahLineNumber=3847
	    ;;
	037060 )
	    ayahLineNumber=3848
	    ;;
	037061 )
	    ayahLineNumber=3849
	    ;;
	037062 )
	    ayahLineNumber=3850
	    ;;
	037063 )
	    ayahLineNumber=3851
	    ;;
	037064 )
	    ayahLineNumber=3852
	    ;;
	037065 )
	    ayahLineNumber=3853
	    ;;
	037066 )
	    ayahLineNumber=3854
	    ;;
	037067 )
	    ayahLineNumber=3855
	    ;;
	037068 )
	    ayahLineNumber=3856
	    ;;
	037069 )
	    ayahLineNumber=3857
	    ;;
	037070 )
	    ayahLineNumber=3858
	    ;;
	037071 )
	    ayahLineNumber=3859
	    ;;
	037072 )
	    ayahLineNumber=3860
	    ;;
	037073 )
	    ayahLineNumber=3861
	    ;;
	037074 )
	    ayahLineNumber=3862
	    ;;
	037075 )
	    ayahLineNumber=3863
	    ;;
	037076 )
	    ayahLineNumber=3864
	    ;;
	037077 )
	    ayahLineNumber=3865
	    ;;
	037078 )
	    ayahLineNumber=3866
	    ;;
	037079 )
	    ayahLineNumber=3867
	    ;;
	037080 )
	    ayahLineNumber=3868
	    ;;
	037081 )
	    ayahLineNumber=3869
	    ;;
	037082 )
	    ayahLineNumber=3870
	    ;;
	037083 )
	    ayahLineNumber=3871
	    ;;
	037084 )
	    ayahLineNumber=3872
	    ;;
	037085 )
	    ayahLineNumber=3873
	    ;;
	037086 )
	    ayahLineNumber=3874
	    ;;
	037087 )
	    ayahLineNumber=3875
	    ;;
	037088 )
	    ayahLineNumber=3876
	    ;;
	037089 )
	    ayahLineNumber=3877
	    ;;
	037090 )
	    ayahLineNumber=3878
	    ;;
	037091 )
	    ayahLineNumber=3879
	    ;;
	037092 )
	    ayahLineNumber=3880
	    ;;
	037093 )
	    ayahLineNumber=3881
	    ;;
	037094 )
	    ayahLineNumber=3882
	    ;;
	037095 )
	    ayahLineNumber=3883
	    ;;
	037096 )
	    ayahLineNumber=3884
	    ;;
	037097 )
	    ayahLineNumber=3885
	    ;;
	037098 )
	    ayahLineNumber=3886
	    ;;
	037099 )
	    ayahLineNumber=3887
	    ;;
	037100 )
	    ayahLineNumber=3888
	    ;;
	037101 )
	    ayahLineNumber=3889
	    ;;
	037102 )
	    ayahLineNumber=3890
	    ;;
	037103 )
	    ayahLineNumber=3891
	    ;;
	037104 )
	    ayahLineNumber=3892
	    ;;
	037105 )
	    ayahLineNumber=3893
	    ;;
	037106 )
	    ayahLineNumber=3894
	    ;;
	037107 )
	    ayahLineNumber=3895
	    ;;
	037108 )
	    ayahLineNumber=3896
	    ;;
	037109 )
	    ayahLineNumber=3897
	    ;;
	037110 )
	    ayahLineNumber=3898
	    ;;
	037111 )
	    ayahLineNumber=3899
	    ;;
	037112 )
	    ayahLineNumber=3900
	    ;;
	037113 )
	    ayahLineNumber=3901
	    ;;
	037114 )
	    ayahLineNumber=3902
	    ;;
	037115 )
	    ayahLineNumber=3903
	    ;;
	037116 )
	    ayahLineNumber=3904
	    ;;
	037117 )
	    ayahLineNumber=3905
	    ;;
	037118 )
	    ayahLineNumber=3906
	    ;;
	037119 )
	    ayahLineNumber=3907
	    ;;
	037120 )
	    ayahLineNumber=3908
	    ;;
	037121 )
	    ayahLineNumber=3909
	    ;;
	037122 )
	    ayahLineNumber=3910
	    ;;
	037123 )
	    ayahLineNumber=3911
	    ;;
	037124 )
	    ayahLineNumber=3912
	    ;;
	037125 )
	    ayahLineNumber=3913
	    ;;
	037126 )
	    ayahLineNumber=3914
	    ;;
	037127 )
	    ayahLineNumber=3915
	    ;;
	037128 )
	    ayahLineNumber=3916
	    ;;
	037129 )
	    ayahLineNumber=3917
	    ;;
	037130 )
	    ayahLineNumber=3918
	    ;;
	037131 )
	    ayahLineNumber=3919
	    ;;
	037132 )
	    ayahLineNumber=3920
	    ;;
	037133 )
	    ayahLineNumber=3921
	    ;;
	037134 )
	    ayahLineNumber=3922
	    ;;
	037135 )
	    ayahLineNumber=3923
	    ;;
	037136 )
	    ayahLineNumber=3924
	    ;;
	037137 )
	    ayahLineNumber=3925
	    ;;
	037138 )
	    ayahLineNumber=3926
	    ;;
	037139 )
	    ayahLineNumber=3927
	    ;;
	037140 )
	    ayahLineNumber=3928
	    ;;
	037141 )
	    ayahLineNumber=3929
	    ;;
	037142 )
	    ayahLineNumber=3930
	    ;;
	037143 )
	    ayahLineNumber=3931
	    ;;
	037144 )
	    ayahLineNumber=3932
	    ;;
	037145 )
	    ayahLineNumber=3933
	    ;;
	037146 )
	    ayahLineNumber=3934
	    ;;
	037147 )
	    ayahLineNumber=3935
	    ;;
	037148 )
	    ayahLineNumber=3936
	    ;;
	037149 )
	    ayahLineNumber=3937
	    ;;
	037150 )
	    ayahLineNumber=3938
	    ;;
	037151 )
	    ayahLineNumber=3939
	    ;;
	037152 )
	    ayahLineNumber=3940
	    ;;
	037153 )
	    ayahLineNumber=3941
	    ;;
	037154 )
	    ayahLineNumber=3942
	    ;;
	037155 )
	    ayahLineNumber=3943
	    ;;
	037156 )
	    ayahLineNumber=3944
	    ;;
	037157 )
	    ayahLineNumber=3945
	    ;;
	037158 )
	    ayahLineNumber=3946
	    ;;
	037159 )
	    ayahLineNumber=3947
	    ;;
	037160 )
	    ayahLineNumber=3948
	    ;;
	037161 )
	    ayahLineNumber=3949
	    ;;
	037162 )
	    ayahLineNumber=3950
	    ;;
	037163 )
	    ayahLineNumber=3951
	    ;;
	037164 )
	    ayahLineNumber=3952
	    ;;
	037165 )
	    ayahLineNumber=3953
	    ;;
	037166 )
	    ayahLineNumber=3954
	    ;;
	037167 )
	    ayahLineNumber=3955
	    ;;
	037168 )
	    ayahLineNumber=3956
	    ;;
	037169 )
	    ayahLineNumber=3957
	    ;;
	037170 )
	    ayahLineNumber=3958
	    ;;
	037171 )
	    ayahLineNumber=3959
	    ;;
	037172 )
	    ayahLineNumber=3960
	    ;;
	037173 )
	    ayahLineNumber=3961
	    ;;
	037174 )
	    ayahLineNumber=3962
	    ;;
	037175 )
	    ayahLineNumber=3963
	    ;;
	037176 )
	    ayahLineNumber=3964
	    ;;
	037177 )
	    ayahLineNumber=3965
	    ;;
	037178 )
	    ayahLineNumber=3966
	    ;;
	037179 )
	    ayahLineNumber=3967
	    ;;
	037180 )
	    ayahLineNumber=3968
	    ;;
	037181 )
	    ayahLineNumber=3969
	    ;;
	037182 )
	    ayahLineNumber=3970
	    ;;
	038001 )
	    ayahLineNumber=3971
	    ;;
	038002 )
	    ayahLineNumber=3972
	    ;;
	038003 )
	    ayahLineNumber=3973
	    ;;
	038004 )
	    ayahLineNumber=3974
	    ;;
	038005 )
	    ayahLineNumber=3975
	    ;;
	038006 )
	    ayahLineNumber=3976
	    ;;
	038007 )
	    ayahLineNumber=3977
	    ;;
	038008 )
	    ayahLineNumber=3978
	    ;;
	038009 )
	    ayahLineNumber=3979
	    ;;
	038010 )
	    ayahLineNumber=3980
	    ;;
	038011 )
	    ayahLineNumber=3981
	    ;;
	038012 )
	    ayahLineNumber=3982
	    ;;
	038013 )
	    ayahLineNumber=3983
	    ;;
	038014 )
	    ayahLineNumber=3984
	    ;;
	038015 )
	    ayahLineNumber=3985
	    ;;
	038016 )
	    ayahLineNumber=3986
	    ;;
	038017 )
	    ayahLineNumber=3987
	    ;;
	038018 )
	    ayahLineNumber=3988
	    ;;
	038019 )
	    ayahLineNumber=3989
	    ;;
	038020 )
	    ayahLineNumber=3990
	    ;;
	038021 )
	    ayahLineNumber=3991
	    ;;
	038022 )
	    ayahLineNumber=3992
	    ;;
	038023 )
	    ayahLineNumber=3993
	    ;;
	038024 )
	    ayahLineNumber=3994
	    ;;
	038025 )
	    ayahLineNumber=3995
	    ;;
	038026 )
	    ayahLineNumber=3996
	    ;;
	038027 )
	    ayahLineNumber=3997
	    ;;
	038028 )
	    ayahLineNumber=3998
	    ;;
	038029 )
	    ayahLineNumber=3999
	    ;;
	038030 )
	    ayahLineNumber=4000
	    ;;
	038031 )
	    ayahLineNumber=4001
	    ;;
	038032 )
	    ayahLineNumber=4002
	    ;;
	038033 )
	    ayahLineNumber=4003
	    ;;
	038034 )
	    ayahLineNumber=4004
	    ;;
	038035 )
	    ayahLineNumber=4005
	    ;;
	038036 )
	    ayahLineNumber=4006
	    ;;
	038037 )
	    ayahLineNumber=4007
	    ;;
	038038 )
	    ayahLineNumber=4008
	    ;;
	038039 )
	    ayahLineNumber=4009
	    ;;
	038040 )
	    ayahLineNumber=4010
	    ;;
	038041 )
	    ayahLineNumber=4011
	    ;;
	038042 )
	    ayahLineNumber=4012
	    ;;
	038043 )
	    ayahLineNumber=4013
	    ;;
	038044 )
	    ayahLineNumber=4014
	    ;;
	038045 )
	    ayahLineNumber=4015
	    ;;
	038046 )
	    ayahLineNumber=4016
	    ;;
	038047 )
	    ayahLineNumber=4017
	    ;;
	038048 )
	    ayahLineNumber=4018
	    ;;
	038049 )
	    ayahLineNumber=4019
	    ;;
	038050 )
	    ayahLineNumber=4020
	    ;;
	038051 )
	    ayahLineNumber=4021
	    ;;
	038052 )
	    ayahLineNumber=4022
	    ;;
	038053 )
	    ayahLineNumber=4023
	    ;;
	038054 )
	    ayahLineNumber=4024
	    ;;
	038055 )
	    ayahLineNumber=4025
	    ;;
	038056 )
	    ayahLineNumber=4026
	    ;;
	038057 )
	    ayahLineNumber=4027
	    ;;
	038058 )
	    ayahLineNumber=4028
	    ;;
	038059 )
	    ayahLineNumber=4029
	    ;;
	038060 )
	    ayahLineNumber=4030
	    ;;
	038061 )
	    ayahLineNumber=4031
	    ;;
	038062 )
	    ayahLineNumber=4032
	    ;;
	038063 )
	    ayahLineNumber=4033
	    ;;
	038064 )
	    ayahLineNumber=4034
	    ;;
	038065 )
	    ayahLineNumber=4035
	    ;;
	038066 )
	    ayahLineNumber=4036
	    ;;
	038067 )
	    ayahLineNumber=4037
	    ;;
	038068 )
	    ayahLineNumber=4038
	    ;;
	038069 )
	    ayahLineNumber=4039
	    ;;
	038070 )
	    ayahLineNumber=4040
	    ;;
	038071 )
	    ayahLineNumber=4041
	    ;;
	038072 )
	    ayahLineNumber=4042
	    ;;
	038073 )
	    ayahLineNumber=4043
	    ;;
	038074 )
	    ayahLineNumber=4044
	    ;;
	038075 )
	    ayahLineNumber=4045
	    ;;
	038076 )
	    ayahLineNumber=4046
	    ;;
	038077 )
	    ayahLineNumber=4047
	    ;;
	038078 )
	    ayahLineNumber=4048
	    ;;
	038079 )
	    ayahLineNumber=4049
	    ;;
	038080 )
	    ayahLineNumber=4050
	    ;;
	038081 )
	    ayahLineNumber=4051
	    ;;
	038082 )
	    ayahLineNumber=4052
	    ;;
	038083 )
	    ayahLineNumber=4053
	    ;;
	038084 )
	    ayahLineNumber=4054
	    ;;
	038085 )
	    ayahLineNumber=4055
	    ;;
	038086 )
	    ayahLineNumber=4056
	    ;;
	038087 )
	    ayahLineNumber=4057
	    ;;
	038088 )
	    ayahLineNumber=4058
	    ;;
	039001 )
	    ayahLineNumber=4059
	    ;;
	039002 )
	    ayahLineNumber=4060
	    ;;
	039003 )
	    ayahLineNumber=4061
	    ;;
	039004 )
	    ayahLineNumber=4062
	    ;;
	039005 )
	    ayahLineNumber=4063
	    ;;
	039006 )
	    ayahLineNumber=4064
	    ;;
	039007 )
	    ayahLineNumber=4065
	    ;;
	039008 )
	    ayahLineNumber=4066
	    ;;
	039009 )
	    ayahLineNumber=4067
	    ;;
	039010 )
	    ayahLineNumber=4068
	    ;;
	039011 )
	    ayahLineNumber=4069
	    ;;
	039012 )
	    ayahLineNumber=4070
	    ;;
	039013 )
	    ayahLineNumber=4071
	    ;;
	039014 )
	    ayahLineNumber=4072
	    ;;
	039015 )
	    ayahLineNumber=4073
	    ;;
	039016 )
	    ayahLineNumber=4074
	    ;;
	039017 )
	    ayahLineNumber=4075
	    ;;
	039018 )
	    ayahLineNumber=4076
	    ;;
	039019 )
	    ayahLineNumber=4077
	    ;;
	039020 )
	    ayahLineNumber=4078
	    ;;
	039021 )
	    ayahLineNumber=4079
	    ;;
	039022 )
	    ayahLineNumber=4080
	    ;;
	039023 )
	    ayahLineNumber=4081
	    ;;
	039024 )
	    ayahLineNumber=4082
	    ;;
	039025 )
	    ayahLineNumber=4083
	    ;;
	039026 )
	    ayahLineNumber=4084
	    ;;
	039027 )
	    ayahLineNumber=4085
	    ;;
	039028 )
	    ayahLineNumber=4086
	    ;;
	039029 )
	    ayahLineNumber=4087
	    ;;
	039030 )
	    ayahLineNumber=4088
	    ;;
	039031 )
	    ayahLineNumber=4089
	    ;;
	039032 )
	    ayahLineNumber=4090
	    ;;
	039033 )
	    ayahLineNumber=4091
	    ;;
	039034 )
	    ayahLineNumber=4092
	    ;;
	039035 )
	    ayahLineNumber=4093
	    ;;
	039036 )
	    ayahLineNumber=4094
	    ;;
	039037 )
	    ayahLineNumber=4095
	    ;;
	039038 )
	    ayahLineNumber=4096
	    ;;
	039039 )
	    ayahLineNumber=4097
	    ;;
	039040 )
	    ayahLineNumber=4098
	    ;;
	039041 )
	    ayahLineNumber=4099
	    ;;
	039042 )
	    ayahLineNumber=4100
	    ;;
	039043 )
	    ayahLineNumber=4101
	    ;;
	039044 )
	    ayahLineNumber=4102
	    ;;
	039045 )
	    ayahLineNumber=4103
	    ;;
	039046 )
	    ayahLineNumber=4104
	    ;;
	039047 )
	    ayahLineNumber=4105
	    ;;
	039048 )
	    ayahLineNumber=4106
	    ;;
	039049 )
	    ayahLineNumber=4107
	    ;;
	039050 )
	    ayahLineNumber=4108
	    ;;
	039051 )
	    ayahLineNumber=4109
	    ;;
	039052 )
	    ayahLineNumber=4110
	    ;;
	039053 )
	    ayahLineNumber=4111
	    ;;
	039054 )
	    ayahLineNumber=4112
	    ;;
	039055 )
	    ayahLineNumber=4113
	    ;;
	039056 )
	    ayahLineNumber=4114
	    ;;
	039057 )
	    ayahLineNumber=4115
	    ;;
	039058 )
	    ayahLineNumber=4116
	    ;;
	039059 )
	    ayahLineNumber=4117
	    ;;
	039060 )
	    ayahLineNumber=4118
	    ;;
	039061 )
	    ayahLineNumber=4119
	    ;;
	039062 )
	    ayahLineNumber=4120
	    ;;
	039063 )
	    ayahLineNumber=4121
	    ;;
	039064 )
	    ayahLineNumber=4122
	    ;;
	039065 )
	    ayahLineNumber=4123
	    ;;
	039066 )
	    ayahLineNumber=4124
	    ;;
	039067 )
	    ayahLineNumber=4125
	    ;;
	039068 )
	    ayahLineNumber=4126
	    ;;
	039069 )
	    ayahLineNumber=4127
	    ;;
	039070 )
	    ayahLineNumber=4128
	    ;;
	039071 )
	    ayahLineNumber=4129
	    ;;
	039072 )
	    ayahLineNumber=4130
	    ;;
	039073 )
	    ayahLineNumber=4131
	    ;;
	039074 )
	    ayahLineNumber=4132
	    ;;
	039075 )
	    ayahLineNumber=4133
	    ;;
	040001 )
	    ayahLineNumber=4134
	    ;;
	040002 )
	    ayahLineNumber=4135
	    ;;
	040003 )
	    ayahLineNumber=4136
	    ;;
	040004 )
	    ayahLineNumber=4137
	    ;;
	040005 )
	    ayahLineNumber=4138
	    ;;
	040006 )
	    ayahLineNumber=4139
	    ;;
	040007 )
	    ayahLineNumber=4140
	    ;;
	040008 )
	    ayahLineNumber=4141
	    ;;
	040009 )
	    ayahLineNumber=4142
	    ;;
	040010 )
	    ayahLineNumber=4143
	    ;;
	040011 )
	    ayahLineNumber=4144
	    ;;
	040012 )
	    ayahLineNumber=4145
	    ;;
	040013 )
	    ayahLineNumber=4146
	    ;;
	040014 )
	    ayahLineNumber=4147
	    ;;
	040015 )
	    ayahLineNumber=4148
	    ;;
	040016 )
	    ayahLineNumber=4149
	    ;;
	040017 )
	    ayahLineNumber=4150
	    ;;
	040018 )
	    ayahLineNumber=4151
	    ;;
	040019 )
	    ayahLineNumber=4152
	    ;;
	040020 )
	    ayahLineNumber=4153
	    ;;
	040021 )
	    ayahLineNumber=4154
	    ;;
	040022 )
	    ayahLineNumber=4155
	    ;;
	040023 )
	    ayahLineNumber=4156
	    ;;
	040024 )
	    ayahLineNumber=4157
	    ;;
	040025 )
	    ayahLineNumber=4158
	    ;;
	040026 )
	    ayahLineNumber=4159
	    ;;
	040027 )
	    ayahLineNumber=4160
	    ;;
	040028 )
	    ayahLineNumber=4161
	    ;;
	040029 )
	    ayahLineNumber=4162
	    ;;
	040030 )
	    ayahLineNumber=4163
	    ;;
	040031 )
	    ayahLineNumber=4164
	    ;;
	040032 )
	    ayahLineNumber=4165
	    ;;
	040033 )
	    ayahLineNumber=4166
	    ;;
	040034 )
	    ayahLineNumber=4167
	    ;;
	040035 )
	    ayahLineNumber=4168
	    ;;
	040036 )
	    ayahLineNumber=4169
	    ;;
	040037 )
	    ayahLineNumber=4170
	    ;;
	040038 )
	    ayahLineNumber=4171
	    ;;
	040039 )
	    ayahLineNumber=4172
	    ;;
	040040 )
	    ayahLineNumber=4173
	    ;;
	040041 )
	    ayahLineNumber=4174
	    ;;
	040042 )
	    ayahLineNumber=4175
	    ;;
	040043 )
	    ayahLineNumber=4176
	    ;;
	040044 )
	    ayahLineNumber=4177
	    ;;
	040045 )
	    ayahLineNumber=4178
	    ;;
	040046 )
	    ayahLineNumber=4179
	    ;;
	040047 )
	    ayahLineNumber=4180
	    ;;
	040048 )
	    ayahLineNumber=4181
	    ;;
	040049 )
	    ayahLineNumber=4182
	    ;;
	040050 )
	    ayahLineNumber=4183
	    ;;
	040051 )
	    ayahLineNumber=4184
	    ;;
	040052 )
	    ayahLineNumber=4185
	    ;;
	040053 )
	    ayahLineNumber=4186
	    ;;
	040054 )
	    ayahLineNumber=4187
	    ;;
	040055 )
	    ayahLineNumber=4188
	    ;;
	040056 )
	    ayahLineNumber=4189
	    ;;
	040057 )
	    ayahLineNumber=4190
	    ;;
	040058 )
	    ayahLineNumber=4191
	    ;;
	040059 )
	    ayahLineNumber=4192
	    ;;
	040060 )
	    ayahLineNumber=4193
	    ;;
	040061 )
	    ayahLineNumber=4194
	    ;;
	040062 )
	    ayahLineNumber=4195
	    ;;
	040063 )
	    ayahLineNumber=4196
	    ;;
	040064 )
	    ayahLineNumber=4197
	    ;;
	040065 )
	    ayahLineNumber=4198
	    ;;
	040066 )
	    ayahLineNumber=4199
	    ;;
	040067 )
	    ayahLineNumber=4200
	    ;;
	040068 )
	    ayahLineNumber=4201
	    ;;
	040069 )
	    ayahLineNumber=4202
	    ;;
	040070 )
	    ayahLineNumber=4203
	    ;;
	040071 )
	    ayahLineNumber=4204
	    ;;
	040072 )
	    ayahLineNumber=4205
	    ;;
	040073 )
	    ayahLineNumber=4206
	    ;;
	040074 )
	    ayahLineNumber=4207
	    ;;
	040075 )
	    ayahLineNumber=4208
	    ;;
	040076 )
	    ayahLineNumber=4209
	    ;;
	040077 )
	    ayahLineNumber=4210
	    ;;
	040078 )
	    ayahLineNumber=4211
	    ;;
	040079 )
	    ayahLineNumber=4212
	    ;;
	040080 )
	    ayahLineNumber=4213
	    ;;
	040081 )
	    ayahLineNumber=4214
	    ;;
	040082 )
	    ayahLineNumber=4215
	    ;;
	040083 )
	    ayahLineNumber=4216
	    ;;
	040084 )
	    ayahLineNumber=4217
	    ;;
	040085 )
	    ayahLineNumber=4218
	    ;;
	041001 )
	    ayahLineNumber=4219
	    ;;
	041002 )
	    ayahLineNumber=4220
	    ;;
	041003 )
	    ayahLineNumber=4221
	    ;;
	041004 )
	    ayahLineNumber=4222
	    ;;
	041005 )
	    ayahLineNumber=4223
	    ;;
	041006 )
	    ayahLineNumber=4224
	    ;;
	041007 )
	    ayahLineNumber=4225
	    ;;
	041008 )
	    ayahLineNumber=4226
	    ;;
	041009 )
	    ayahLineNumber=4227
	    ;;
	041010 )
	    ayahLineNumber=4228
	    ;;
	041011 )
	    ayahLineNumber=4229
	    ;;
	041012 )
	    ayahLineNumber=4230
	    ;;
	041013 )
	    ayahLineNumber=4231
	    ;;
	041014 )
	    ayahLineNumber=4232
	    ;;
	041015 )
	    ayahLineNumber=4233
	    ;;
	041016 )
	    ayahLineNumber=4234
	    ;;
	041017 )
	    ayahLineNumber=4235
	    ;;
	041018 )
	    ayahLineNumber=4236
	    ;;
	041019 )
	    ayahLineNumber=4237
	    ;;
	041020 )
	    ayahLineNumber=4238
	    ;;
	041021 )
	    ayahLineNumber=4239
	    ;;
	041022 )
	    ayahLineNumber=4240
	    ;;
	041023 )
	    ayahLineNumber=4241
	    ;;
	041024 )
	    ayahLineNumber=4242
	    ;;
	041025 )
	    ayahLineNumber=4243
	    ;;
	041026 )
	    ayahLineNumber=4244
	    ;;
	041027 )
	    ayahLineNumber=4245
	    ;;
	041028 )
	    ayahLineNumber=4246
	    ;;
	041029 )
	    ayahLineNumber=4247
	    ;;
	041030 )
	    ayahLineNumber=4248
	    ;;
	041031 )
	    ayahLineNumber=4249
	    ;;
	041032 )
	    ayahLineNumber=4250
	    ;;
	041033 )
	    ayahLineNumber=4251
	    ;;
	041034 )
	    ayahLineNumber=4252
	    ;;
	041035 )
	    ayahLineNumber=4253
	    ;;
	041036 )
	    ayahLineNumber=4254
	    ;;
	041037 )
	    ayahLineNumber=4255
	    ;;
	041038 )
	    ayahLineNumber=4256
	    ;;
	041039 )
	    ayahLineNumber=4257
	    ;;
	041040 )
	    ayahLineNumber=4258
	    ;;
	041041 )
	    ayahLineNumber=4259
	    ;;
	041042 )
	    ayahLineNumber=4260
	    ;;
	041043 )
	    ayahLineNumber=4261
	    ;;
	041044 )
	    ayahLineNumber=4262
	    ;;
	041045 )
	    ayahLineNumber=4263
	    ;;
	041046 )
	    ayahLineNumber=4264
	    ;;
	041047 )
	    ayahLineNumber=4265
	    ;;
	041048 )
	    ayahLineNumber=4266
	    ;;
	041049 )
	    ayahLineNumber=4267
	    ;;
	041050 )
	    ayahLineNumber=4268
	    ;;
	041051 )
	    ayahLineNumber=4269
	    ;;
	041052 )
	    ayahLineNumber=4270
	    ;;
	041053 )
	    ayahLineNumber=4271
	    ;;
	041054 )
	    ayahLineNumber=4272
	    ;;
	042001 )
	    ayahLineNumber=4273
	    ;;
	042002 )
	    ayahLineNumber=4274
	    ;;
	042003 )
	    ayahLineNumber=4275
	    ;;
	042004 )
	    ayahLineNumber=4276
	    ;;
	042005 )
	    ayahLineNumber=4277
	    ;;
	042006 )
	    ayahLineNumber=4278
	    ;;
	042007 )
	    ayahLineNumber=4279
	    ;;
	042008 )
	    ayahLineNumber=4280
	    ;;
	042009 )
	    ayahLineNumber=4281
	    ;;
	042010 )
	    ayahLineNumber=4282
	    ;;
	042011 )
	    ayahLineNumber=4283
	    ;;
	042012 )
	    ayahLineNumber=4284
	    ;;
	042013 )
	    ayahLineNumber=4285
	    ;;
	042014 )
	    ayahLineNumber=4286
	    ;;
	042015 )
	    ayahLineNumber=4287
	    ;;
	042016 )
	    ayahLineNumber=4288
	    ;;
	042017 )
	    ayahLineNumber=4289
	    ;;
	042018 )
	    ayahLineNumber=4290
	    ;;
	042019 )
	    ayahLineNumber=4291
	    ;;
	042020 )
	    ayahLineNumber=4292
	    ;;
	042021 )
	    ayahLineNumber=4293
	    ;;
	042022 )
	    ayahLineNumber=4294
	    ;;
	042023 )
	    ayahLineNumber=4295
	    ;;
	042024 )
	    ayahLineNumber=4296
	    ;;
	042025 )
	    ayahLineNumber=4297
	    ;;
	042026 )
	    ayahLineNumber=4298
	    ;;
	042027 )
	    ayahLineNumber=4299
	    ;;
	042028 )
	    ayahLineNumber=4300
	    ;;
	042029 )
	    ayahLineNumber=4301
	    ;;
	042030 )
	    ayahLineNumber=4302
	    ;;
	042031 )
	    ayahLineNumber=4303
	    ;;
	042032 )
	    ayahLineNumber=4304
	    ;;
	042033 )
	    ayahLineNumber=4305
	    ;;
	042034 )
	    ayahLineNumber=4306
	    ;;
	042035 )
	    ayahLineNumber=4307
	    ;;
	042036 )
	    ayahLineNumber=4308
	    ;;
	042037 )
	    ayahLineNumber=4309
	    ;;
	042038 )
	    ayahLineNumber=4310
	    ;;
	042039 )
	    ayahLineNumber=4311
	    ;;
	042040 )
	    ayahLineNumber=4312
	    ;;
	042041 )
	    ayahLineNumber=4313
	    ;;
	042042 )
	    ayahLineNumber=4314
	    ;;
	042043 )
	    ayahLineNumber=4315
	    ;;
	042044 )
	    ayahLineNumber=4316
	    ;;
	042045 )
	    ayahLineNumber=4317
	    ;;
	042046 )
	    ayahLineNumber=4318
	    ;;
	042047 )
	    ayahLineNumber=4319
	    ;;
	042048 )
	    ayahLineNumber=4320
	    ;;
	042049 )
	    ayahLineNumber=4321
	    ;;
	042050 )
	    ayahLineNumber=4322
	    ;;
	042051 )
	    ayahLineNumber=4323
	    ;;
	042052 )
	    ayahLineNumber=4324
	    ;;
	042053 )
	    ayahLineNumber=4325
	    ;;
	043001 )
	    ayahLineNumber=4326
	    ;;
	043002 )
	    ayahLineNumber=4327
	    ;;
	043003 )
	    ayahLineNumber=4328
	    ;;
	043004 )
	    ayahLineNumber=4329
	    ;;
	043005 )
	    ayahLineNumber=4330
	    ;;
	043006 )
	    ayahLineNumber=4331
	    ;;
	043007 )
	    ayahLineNumber=4332
	    ;;
	043008 )
	    ayahLineNumber=4333
	    ;;
	043009 )
	    ayahLineNumber=4334
	    ;;
	043010 )
	    ayahLineNumber=4335
	    ;;
	043011 )
	    ayahLineNumber=4336
	    ;;
	043012 )
	    ayahLineNumber=4337
	    ;;
	043013 )
	    ayahLineNumber=4338
	    ;;
	043014 )
	    ayahLineNumber=4339
	    ;;
	043015 )
	    ayahLineNumber=4340
	    ;;
	043016 )
	    ayahLineNumber=4341
	    ;;
	043017 )
	    ayahLineNumber=4342
	    ;;
	043018 )
	    ayahLineNumber=4343
	    ;;
	043019 )
	    ayahLineNumber=4344
	    ;;
	043020 )
	    ayahLineNumber=4345
	    ;;
	043021 )
	    ayahLineNumber=4346
	    ;;
	043022 )
	    ayahLineNumber=4347
	    ;;
	043023 )
	    ayahLineNumber=4348
	    ;;
	043024 )
	    ayahLineNumber=4349
	    ;;
	043025 )
	    ayahLineNumber=4350
	    ;;
	043026 )
	    ayahLineNumber=4351
	    ;;
	043027 )
	    ayahLineNumber=4352
	    ;;
	043028 )
	    ayahLineNumber=4353
	    ;;
	043029 )
	    ayahLineNumber=4354
	    ;;
	043030 )
	    ayahLineNumber=4355
	    ;;
	043031 )
	    ayahLineNumber=4356
	    ;;
	043032 )
	    ayahLineNumber=4357
	    ;;
	043033 )
	    ayahLineNumber=4358
	    ;;
	043034 )
	    ayahLineNumber=4359
	    ;;
	043035 )
	    ayahLineNumber=4360
	    ;;
	043036 )
	    ayahLineNumber=4361
	    ;;
	043037 )
	    ayahLineNumber=4362
	    ;;
	043038 )
	    ayahLineNumber=4363
	    ;;
	043039 )
	    ayahLineNumber=4364
	    ;;
	043040 )
	    ayahLineNumber=4365
	    ;;
	043041 )
	    ayahLineNumber=4366
	    ;;
	043042 )
	    ayahLineNumber=4367
	    ;;
	043043 )
	    ayahLineNumber=4368
	    ;;
	043044 )
	    ayahLineNumber=4369
	    ;;
	043045 )
	    ayahLineNumber=4370
	    ;;
	043046 )
	    ayahLineNumber=4371
	    ;;
	043047 )
	    ayahLineNumber=4372
	    ;;
	043048 )
	    ayahLineNumber=4373
	    ;;
	043049 )
	    ayahLineNumber=4374
	    ;;
	043050 )
	    ayahLineNumber=4375
	    ;;
	043051 )
	    ayahLineNumber=4376
	    ;;
	043052 )
	    ayahLineNumber=4377
	    ;;
	043053 )
	    ayahLineNumber=4378
	    ;;
	043054 )
	    ayahLineNumber=4379
	    ;;
	043055 )
	    ayahLineNumber=4380
	    ;;
	043056 )
	    ayahLineNumber=4381
	    ;;
	043057 )
	    ayahLineNumber=4382
	    ;;
	043058 )
	    ayahLineNumber=4383
	    ;;
	043059 )
	    ayahLineNumber=4384
	    ;;
	043060 )
	    ayahLineNumber=4385
	    ;;
	043061 )
	    ayahLineNumber=4386
	    ;;
	043062 )
	    ayahLineNumber=4387
	    ;;
	043063 )
	    ayahLineNumber=4388
	    ;;
	043064 )
	    ayahLineNumber=4389
	    ;;
	043065 )
	    ayahLineNumber=4390
	    ;;
	043066 )
	    ayahLineNumber=4391
	    ;;
	043067 )
	    ayahLineNumber=4392
	    ;;
	043068 )
	    ayahLineNumber=4393
	    ;;
	043069 )
	    ayahLineNumber=4394
	    ;;
	043070 )
	    ayahLineNumber=4395
	    ;;
	043071 )
	    ayahLineNumber=4396
	    ;;
	043072 )
	    ayahLineNumber=4397
	    ;;
	043073 )
	    ayahLineNumber=4398
	    ;;
	043074 )
	    ayahLineNumber=4399
	    ;;
	043075 )
	    ayahLineNumber=4400
	    ;;
	043076 )
	    ayahLineNumber=4401
	    ;;
	043077 )
	    ayahLineNumber=4402
	    ;;
	043078 )
	    ayahLineNumber=4403
	    ;;
	043079 )
	    ayahLineNumber=4404
	    ;;
	043080 )
	    ayahLineNumber=4405
	    ;;
	043081 )
	    ayahLineNumber=4406
	    ;;
	043082 )
	    ayahLineNumber=4407
	    ;;
	043083 )
	    ayahLineNumber=4408
	    ;;
	043084 )
	    ayahLineNumber=4409
	    ;;
	043085 )
	    ayahLineNumber=4410
	    ;;
	043086 )
	    ayahLineNumber=4411
	    ;;
	043087 )
	    ayahLineNumber=4412
	    ;;
	043088 )
	    ayahLineNumber=4413
	    ;;
	043089 )
	    ayahLineNumber=4414
	    ;;
	044001 )
	    ayahLineNumber=4415
	    ;;
	044002 )
	    ayahLineNumber=4416
	    ;;
	044003 )
	    ayahLineNumber=4417
	    ;;
	044004 )
	    ayahLineNumber=4418
	    ;;
	044005 )
	    ayahLineNumber=4419
	    ;;
	044006 )
	    ayahLineNumber=4420
	    ;;
	044007 )
	    ayahLineNumber=4421
	    ;;
	044008 )
	    ayahLineNumber=4422
	    ;;
	044009 )
	    ayahLineNumber=4423
	    ;;
	044010 )
	    ayahLineNumber=4424
	    ;;
	044011 )
	    ayahLineNumber=4425
	    ;;
	044012 )
	    ayahLineNumber=4426
	    ;;
	044013 )
	    ayahLineNumber=4427
	    ;;
	044014 )
	    ayahLineNumber=4428
	    ;;
	044015 )
	    ayahLineNumber=4429
	    ;;
	044016 )
	    ayahLineNumber=4430
	    ;;
	044017 )
	    ayahLineNumber=4431
	    ;;
	044018 )
	    ayahLineNumber=4432
	    ;;
	044019 )
	    ayahLineNumber=4433
	    ;;
	044020 )
	    ayahLineNumber=4434
	    ;;
	044021 )
	    ayahLineNumber=4435
	    ;;
	044022 )
	    ayahLineNumber=4436
	    ;;
	044023 )
	    ayahLineNumber=4437
	    ;;
	044024 )
	    ayahLineNumber=4438
	    ;;
	044025 )
	    ayahLineNumber=4439
	    ;;
	044026 )
	    ayahLineNumber=4440
	    ;;
	044027 )
	    ayahLineNumber=4441
	    ;;
	044028 )
	    ayahLineNumber=4442
	    ;;
	044029 )
	    ayahLineNumber=4443
	    ;;
	044030 )
	    ayahLineNumber=4444
	    ;;
	044031 )
	    ayahLineNumber=4445
	    ;;
	044032 )
	    ayahLineNumber=4446
	    ;;
	044033 )
	    ayahLineNumber=4447
	    ;;
	044034 )
	    ayahLineNumber=4448
	    ;;
	044035 )
	    ayahLineNumber=4449
	    ;;
	044036 )
	    ayahLineNumber=4450
	    ;;
	044037 )
	    ayahLineNumber=4451
	    ;;
	044038 )
	    ayahLineNumber=4452
	    ;;
	044039 )
	    ayahLineNumber=4453
	    ;;
	044040 )
	    ayahLineNumber=4454
	    ;;
	044041 )
	    ayahLineNumber=4455
	    ;;
	044042 )
	    ayahLineNumber=4456
	    ;;
	044043 )
	    ayahLineNumber=4457
	    ;;
	044044 )
	    ayahLineNumber=4458
	    ;;
	044045 )
	    ayahLineNumber=4459
	    ;;
	044046 )
	    ayahLineNumber=4460
	    ;;
	044047 )
	    ayahLineNumber=4461
	    ;;
	044048 )
	    ayahLineNumber=4462
	    ;;
	044049 )
	    ayahLineNumber=4463
	    ;;
	044050 )
	    ayahLineNumber=4464
	    ;;
	044051 )
	    ayahLineNumber=4465
	    ;;
	044052 )
	    ayahLineNumber=4466
	    ;;
	044053 )
	    ayahLineNumber=4467
	    ;;
	044054 )
	    ayahLineNumber=4468
	    ;;
	044055 )
	    ayahLineNumber=4469
	    ;;
	044056 )
	    ayahLineNumber=4470
	    ;;
	044057 )
	    ayahLineNumber=4471
	    ;;
	044058 )
	    ayahLineNumber=4472
	    ;;
	044059 )
	    ayahLineNumber=4473
	    ;;
	045001 )
	    ayahLineNumber=4474
	    ;;
	045002 )
	    ayahLineNumber=4475
	    ;;
	045003 )
	    ayahLineNumber=4476
	    ;;
	045004 )
	    ayahLineNumber=4477
	    ;;
	045005 )
	    ayahLineNumber=4478
	    ;;
	045006 )
	    ayahLineNumber=4479
	    ;;
	045007 )
	    ayahLineNumber=4480
	    ;;
	045008 )
	    ayahLineNumber=4481
	    ;;
	045009 )
	    ayahLineNumber=4482
	    ;;
	045010 )
	    ayahLineNumber=4483
	    ;;
	045011 )
	    ayahLineNumber=4484
	    ;;
	045012 )
	    ayahLineNumber=4485
	    ;;
	045013 )
	    ayahLineNumber=4486
	    ;;
	045014 )
	    ayahLineNumber=4487
	    ;;
	045015 )
	    ayahLineNumber=4488
	    ;;
	045016 )
	    ayahLineNumber=4489
	    ;;
	045017 )
	    ayahLineNumber=4490
	    ;;
	045018 )
	    ayahLineNumber=4491
	    ;;
	045019 )
	    ayahLineNumber=4492
	    ;;
	045020 )
	    ayahLineNumber=4493
	    ;;
	045021 )
	    ayahLineNumber=4494
	    ;;
	045022 )
	    ayahLineNumber=4495
	    ;;
	045023 )
	    ayahLineNumber=4496
	    ;;
	045024 )
	    ayahLineNumber=4497
	    ;;
	045025 )
	    ayahLineNumber=4498
	    ;;
	045026 )
	    ayahLineNumber=4499
	    ;;
	045027 )
	    ayahLineNumber=4500
	    ;;
	045028 )
	    ayahLineNumber=4501
	    ;;
	045029 )
	    ayahLineNumber=4502
	    ;;
	045030 )
	    ayahLineNumber=4503
	    ;;
	045031 )
	    ayahLineNumber=4504
	    ;;
	045032 )
	    ayahLineNumber=4505
	    ;;
	045033 )
	    ayahLineNumber=4506
	    ;;
	045034 )
	    ayahLineNumber=4507
	    ;;
	045035 )
	    ayahLineNumber=4508
	    ;;
	045036 )
	    ayahLineNumber=4509
	    ;;
	045037 )
	    ayahLineNumber=4510
	    ;;
	046001 )
	    ayahLineNumber=4511
	    ;;
	046002 )
	    ayahLineNumber=4512
	    ;;
	046003 )
	    ayahLineNumber=4513
	    ;;
	046004 )
	    ayahLineNumber=4514
	    ;;
	046005 )
	    ayahLineNumber=4515
	    ;;
	046006 )
	    ayahLineNumber=4516
	    ;;
	046007 )
	    ayahLineNumber=4517
	    ;;
	046008 )
	    ayahLineNumber=4518
	    ;;
	046009 )
	    ayahLineNumber=4519
	    ;;
	046010 )
	    ayahLineNumber=4520
	    ;;
	046011 )
	    ayahLineNumber=4521
	    ;;
	046012 )
	    ayahLineNumber=4522
	    ;;
	046013 )
	    ayahLineNumber=4523
	    ;;
	046014 )
	    ayahLineNumber=4524
	    ;;
	046015 )
	    ayahLineNumber=4525
	    ;;
	046016 )
	    ayahLineNumber=4526
	    ;;
	046017 )
	    ayahLineNumber=4527
	    ;;
	046018 )
	    ayahLineNumber=4528
	    ;;
	046019 )
	    ayahLineNumber=4529
	    ;;
	046020 )
	    ayahLineNumber=4530
	    ;;
	046021 )
	    ayahLineNumber=4531
	    ;;
	046022 )
	    ayahLineNumber=4532
	    ;;
	046023 )
	    ayahLineNumber=4533
	    ;;
	046024 )
	    ayahLineNumber=4534
	    ;;
	046025 )
	    ayahLineNumber=4535
	    ;;
	046026 )
	    ayahLineNumber=4536
	    ;;
	046027 )
	    ayahLineNumber=4537
	    ;;
	046028 )
	    ayahLineNumber=4538
	    ;;
	046029 )
	    ayahLineNumber=4539
	    ;;
	046030 )
	    ayahLineNumber=4540
	    ;;
	046031 )
	    ayahLineNumber=4541
	    ;;
	046032 )
	    ayahLineNumber=4542
	    ;;
	046033 )
	    ayahLineNumber=4543
	    ;;
	046034 )
	    ayahLineNumber=4544
	    ;;
	046035 )
	    ayahLineNumber=4545
	    ;;
	047001 )
	    ayahLineNumber=4546
	    ;;
	047002 )
	    ayahLineNumber=4547
	    ;;
	047003 )
	    ayahLineNumber=4548
	    ;;
	047004 )
	    ayahLineNumber=4549
	    ;;
	047005 )
	    ayahLineNumber=4550
	    ;;
	047006 )
	    ayahLineNumber=4551
	    ;;
	047007 )
	    ayahLineNumber=4552
	    ;;
	047008 )
	    ayahLineNumber=4553
	    ;;
	047009 )
	    ayahLineNumber=4554
	    ;;
	047010 )
	    ayahLineNumber=4555
	    ;;
	047011 )
	    ayahLineNumber=4556
	    ;;
	047012 )
	    ayahLineNumber=4557
	    ;;
	047013 )
	    ayahLineNumber=4558
	    ;;
	047014 )
	    ayahLineNumber=4559
	    ;;
	047015 )
	    ayahLineNumber=4560
	    ;;
	047016 )
	    ayahLineNumber=4561
	    ;;
	047017 )
	    ayahLineNumber=4562
	    ;;
	047018 )
	    ayahLineNumber=4563
	    ;;
	047019 )
	    ayahLineNumber=4564
	    ;;
	047020 )
	    ayahLineNumber=4565
	    ;;
	047021 )
	    ayahLineNumber=4566
	    ;;
	047022 )
	    ayahLineNumber=4567
	    ;;
	047023 )
	    ayahLineNumber=4568
	    ;;
	047024 )
	    ayahLineNumber=4569
	    ;;
	047025 )
	    ayahLineNumber=4570
	    ;;
	047026 )
	    ayahLineNumber=4571
	    ;;
	047027 )
	    ayahLineNumber=4572
	    ;;
	047028 )
	    ayahLineNumber=4573
	    ;;
	047029 )
	    ayahLineNumber=4574
	    ;;
	047030 )
	    ayahLineNumber=4575
	    ;;
	047031 )
	    ayahLineNumber=4576
	    ;;
	047032 )
	    ayahLineNumber=4577
	    ;;
	047033 )
	    ayahLineNumber=4578
	    ;;
	047034 )
	    ayahLineNumber=4579
	    ;;
	047035 )
	    ayahLineNumber=4580
	    ;;
	047036 )
	    ayahLineNumber=4581
	    ;;
	047037 )
	    ayahLineNumber=4582
	    ;;
	047038 )
	    ayahLineNumber=4583
	    ;;
	048001 )
	    ayahLineNumber=4584
	    ;;
	048002 )
	    ayahLineNumber=4585
	    ;;
	048003 )
	    ayahLineNumber=4586
	    ;;
	048004 )
	    ayahLineNumber=4587
	    ;;
	048005 )
	    ayahLineNumber=4588
	    ;;
	048006 )
	    ayahLineNumber=4589
	    ;;
	048007 )
	    ayahLineNumber=4590
	    ;;
	048008 )
	    ayahLineNumber=4591
	    ;;
	048009 )
	    ayahLineNumber=4592
	    ;;
	048010 )
	    ayahLineNumber=4593
	    ;;
	048011 )
	    ayahLineNumber=4594
	    ;;
	048012 )
	    ayahLineNumber=4595
	    ;;
	048013 )
	    ayahLineNumber=4596
	    ;;
	048014 )
	    ayahLineNumber=4597
	    ;;
	048015 )
	    ayahLineNumber=4598
	    ;;
	048016 )
	    ayahLineNumber=4599
	    ;;
	048017 )
	    ayahLineNumber=4600
	    ;;
	048018 )
	    ayahLineNumber=4601
	    ;;
	048019 )
	    ayahLineNumber=4602
	    ;;
	048020 )
	    ayahLineNumber=4603
	    ;;
	048021 )
	    ayahLineNumber=4604
	    ;;
	048022 )
	    ayahLineNumber=4605
	    ;;
	048023 )
	    ayahLineNumber=4606
	    ;;
	048024 )
	    ayahLineNumber=4607
	    ;;
	048025 )
	    ayahLineNumber=4608
	    ;;
	048026 )
	    ayahLineNumber=4609
	    ;;
	048027 )
	    ayahLineNumber=4610
	    ;;
	048028 )
	    ayahLineNumber=4611
	    ;;
	048029 )
	    ayahLineNumber=4612
	    ;;
	049001 )
	    ayahLineNumber=4613
	    ;;
	049002 )
	    ayahLineNumber=4614
	    ;;
	049003 )
	    ayahLineNumber=4615
	    ;;
	049004 )
	    ayahLineNumber=4616
	    ;;
	049005 )
	    ayahLineNumber=4617
	    ;;
	049006 )
	    ayahLineNumber=4618
	    ;;
	049007 )
	    ayahLineNumber=4619
	    ;;
	049008 )
	    ayahLineNumber=4620
	    ;;
	049009 )
	    ayahLineNumber=4621
	    ;;
	049010 )
	    ayahLineNumber=4622
	    ;;
	049011 )
	    ayahLineNumber=4623
	    ;;
	049012 )
	    ayahLineNumber=4624
	    ;;
	049013 )
	    ayahLineNumber=4625
	    ;;
	049014 )
	    ayahLineNumber=4626
	    ;;
	049015 )
	    ayahLineNumber=4627
	    ;;
	049016 )
	    ayahLineNumber=4628
	    ;;
	049017 )
	    ayahLineNumber=4629
	    ;;
	049018 )
	    ayahLineNumber=4630
	    ;;
	050001 )
	    ayahLineNumber=4631
	    ;;
	050002 )
	    ayahLineNumber=4632
	    ;;
	050003 )
	    ayahLineNumber=4633
	    ;;
	050004 )
	    ayahLineNumber=4634
	    ;;
	050005 )
	    ayahLineNumber=4635
	    ;;
	050006 )
	    ayahLineNumber=4636
	    ;;
	050007 )
	    ayahLineNumber=4637
	    ;;
	050008 )
	    ayahLineNumber=4638
	    ;;
	050009 )
	    ayahLineNumber=4639
	    ;;
	050010 )
	    ayahLineNumber=4640
	    ;;
	050011 )
	    ayahLineNumber=4641
	    ;;
	050012 )
	    ayahLineNumber=4642
	    ;;
	050013 )
	    ayahLineNumber=4643
	    ;;
	050014 )
	    ayahLineNumber=4644
	    ;;
	050015 )
	    ayahLineNumber=4645
	    ;;
	050016 )
	    ayahLineNumber=4646
	    ;;
	050017 )
	    ayahLineNumber=4647
	    ;;
	050018 )
	    ayahLineNumber=4648
	    ;;
	050019 )
	    ayahLineNumber=4649
	    ;;
	050020 )
	    ayahLineNumber=4650
	    ;;
	050021 )
	    ayahLineNumber=4651
	    ;;
	050022 )
	    ayahLineNumber=4652
	    ;;
	050023 )
	    ayahLineNumber=4653
	    ;;
	050024 )
	    ayahLineNumber=4654
	    ;;
	050025 )
	    ayahLineNumber=4655
	    ;;
	050026 )
	    ayahLineNumber=4656
	    ;;
	050027 )
	    ayahLineNumber=4657
	    ;;
	050028 )
	    ayahLineNumber=4658
	    ;;
	050029 )
	    ayahLineNumber=4659
	    ;;
	050030 )
	    ayahLineNumber=4660
	    ;;
	050031 )
	    ayahLineNumber=4661
	    ;;
	050032 )
	    ayahLineNumber=4662
	    ;;
	050033 )
	    ayahLineNumber=4663
	    ;;
	050034 )
	    ayahLineNumber=4664
	    ;;
	050035 )
	    ayahLineNumber=4665
	    ;;
	050036 )
	    ayahLineNumber=4666
	    ;;
	050037 )
	    ayahLineNumber=4667
	    ;;
	050038 )
	    ayahLineNumber=4668
	    ;;
	050039 )
	    ayahLineNumber=4669
	    ;;
	050040 )
	    ayahLineNumber=4670
	    ;;
	050041 )
	    ayahLineNumber=4671
	    ;;
	050042 )
	    ayahLineNumber=4672
	    ;;
	050043 )
	    ayahLineNumber=4673
	    ;;
	050044 )
	    ayahLineNumber=4674
	    ;;
	050045 )
	    ayahLineNumber=4675
	    ;;
	051001 )
	    ayahLineNumber=4676
	    ;;
	051002 )
	    ayahLineNumber=4677
	    ;;
	051003 )
	    ayahLineNumber=4678
	    ;;
	051004 )
	    ayahLineNumber=4679
	    ;;
	051005 )
	    ayahLineNumber=4680
	    ;;
	051006 )
	    ayahLineNumber=4681
	    ;;
	051007 )
	    ayahLineNumber=4682
	    ;;
	051008 )
	    ayahLineNumber=4683
	    ;;
	051009 )
	    ayahLineNumber=4684
	    ;;
	051010 )
	    ayahLineNumber=4685
	    ;;
	051011 )
	    ayahLineNumber=4686
	    ;;
	051012 )
	    ayahLineNumber=4687
	    ;;
	051013 )
	    ayahLineNumber=4688
	    ;;
	051014 )
	    ayahLineNumber=4689
	    ;;
	051015 )
	    ayahLineNumber=4690
	    ;;
	051016 )
	    ayahLineNumber=4691
	    ;;
	051017 )
	    ayahLineNumber=4692
	    ;;
	051018 )
	    ayahLineNumber=4693
	    ;;
	051019 )
	    ayahLineNumber=4694
	    ;;
	051020 )
	    ayahLineNumber=4695
	    ;;
	051021 )
	    ayahLineNumber=4696
	    ;;
	051022 )
	    ayahLineNumber=4697
	    ;;
	051023 )
	    ayahLineNumber=4698
	    ;;
	051024 )
	    ayahLineNumber=4699
	    ;;
	051025 )
	    ayahLineNumber=4700
	    ;;
	051026 )
	    ayahLineNumber=4701
	    ;;
	051027 )
	    ayahLineNumber=4702
	    ;;
	051028 )
	    ayahLineNumber=4703
	    ;;
	051029 )
	    ayahLineNumber=4704
	    ;;
	051030 )
	    ayahLineNumber=4705
	    ;;
	051031 )
	    ayahLineNumber=4706
	    ;;
	051032 )
	    ayahLineNumber=4707
	    ;;
	051033 )
	    ayahLineNumber=4708
	    ;;
	051034 )
	    ayahLineNumber=4709
	    ;;
	051035 )
	    ayahLineNumber=4710
	    ;;
	051036 )
	    ayahLineNumber=4711
	    ;;
	051037 )
	    ayahLineNumber=4712
	    ;;
	051038 )
	    ayahLineNumber=4713
	    ;;
	051039 )
	    ayahLineNumber=4714
	    ;;
	051040 )
	    ayahLineNumber=4715
	    ;;
	051041 )
	    ayahLineNumber=4716
	    ;;
	051042 )
	    ayahLineNumber=4717
	    ;;
	051043 )
	    ayahLineNumber=4718
	    ;;
	051044 )
	    ayahLineNumber=4719
	    ;;
	051045 )
	    ayahLineNumber=4720
	    ;;
	051046 )
	    ayahLineNumber=4721
	    ;;
	051047 )
	    ayahLineNumber=4722
	    ;;
	051048 )
	    ayahLineNumber=4723
	    ;;
	051049 )
	    ayahLineNumber=4724
	    ;;
	051050 )
	    ayahLineNumber=4725
	    ;;
	051051 )
	    ayahLineNumber=4726
	    ;;
	051052 )
	    ayahLineNumber=4727
	    ;;
	051053 )
	    ayahLineNumber=4728
	    ;;
	051054 )
	    ayahLineNumber=4729
	    ;;
	051055 )
	    ayahLineNumber=4730
	    ;;
	051056 )
	    ayahLineNumber=4731
	    ;;
	051057 )
	    ayahLineNumber=4732
	    ;;
	051058 )
	    ayahLineNumber=4733
	    ;;
	051059 )
	    ayahLineNumber=4734
	    ;;
	051060 )
	    ayahLineNumber=4735
	    ;;
	052001 )
	    ayahLineNumber=4736
	    ;;
	052002 )
	    ayahLineNumber=4737
	    ;;
	052003 )
	    ayahLineNumber=4738
	    ;;
	052004 )
	    ayahLineNumber=4739
	    ;;
	052005 )
	    ayahLineNumber=4740
	    ;;
	052006 )
	    ayahLineNumber=4741
	    ;;
	052007 )
	    ayahLineNumber=4742
	    ;;
	052008 )
	    ayahLineNumber=4743
	    ;;
	052009 )
	    ayahLineNumber=4744
	    ;;
	052010 )
	    ayahLineNumber=4745
	    ;;
	052011 )
	    ayahLineNumber=4746
	    ;;
	052012 )
	    ayahLineNumber=4747
	    ;;
	052013 )
	    ayahLineNumber=4748
	    ;;
	052014 )
	    ayahLineNumber=4749
	    ;;
	052015 )
	    ayahLineNumber=4750
	    ;;
	052016 )
	    ayahLineNumber=4751
	    ;;
	052017 )
	    ayahLineNumber=4752
	    ;;
	052018 )
	    ayahLineNumber=4753
	    ;;
	052019 )
	    ayahLineNumber=4754
	    ;;
	052020 )
	    ayahLineNumber=4755
	    ;;
	052021 )
	    ayahLineNumber=4756
	    ;;
	052022 )
	    ayahLineNumber=4757
	    ;;
	052023 )
	    ayahLineNumber=4758
	    ;;
	052024 )
	    ayahLineNumber=4759
	    ;;
	052025 )
	    ayahLineNumber=4760
	    ;;
	052026 )
	    ayahLineNumber=4761
	    ;;
	052027 )
	    ayahLineNumber=4762
	    ;;
	052028 )
	    ayahLineNumber=4763
	    ;;
	052029 )
	    ayahLineNumber=4764
	    ;;
	052030 )
	    ayahLineNumber=4765
	    ;;
	052031 )
	    ayahLineNumber=4766
	    ;;
	052032 )
	    ayahLineNumber=4767
	    ;;
	052033 )
	    ayahLineNumber=4768
	    ;;
	052034 )
	    ayahLineNumber=4769
	    ;;
	052035 )
	    ayahLineNumber=4770
	    ;;
	052036 )
	    ayahLineNumber=4771
	    ;;
	052037 )
	    ayahLineNumber=4772
	    ;;
	052038 )
	    ayahLineNumber=4773
	    ;;
	052039 )
	    ayahLineNumber=4774
	    ;;
	052040 )
	    ayahLineNumber=4775
	    ;;
	052041 )
	    ayahLineNumber=4776
	    ;;
	052042 )
	    ayahLineNumber=4777
	    ;;
	052043 )
	    ayahLineNumber=4778
	    ;;
	052044 )
	    ayahLineNumber=4779
	    ;;
	052045 )
	    ayahLineNumber=4780
	    ;;
	052046 )
	    ayahLineNumber=4781
	    ;;
	052047 )
	    ayahLineNumber=4782
	    ;;
	052048 )
	    ayahLineNumber=4783
	    ;;
	052049 )
	    ayahLineNumber=4784
	    ;;
	053001 )
	    ayahLineNumber=4785
	    ;;
	053002 )
	    ayahLineNumber=4786
	    ;;
	053003 )
	    ayahLineNumber=4787
	    ;;
	053004 )
	    ayahLineNumber=4788
	    ;;
	053005 )
	    ayahLineNumber=4789
	    ;;
	053006 )
	    ayahLineNumber=4790
	    ;;
	053007 )
	    ayahLineNumber=4791
	    ;;
	053008 )
	    ayahLineNumber=4792
	    ;;
	053009 )
	    ayahLineNumber=4793
	    ;;
	053010 )
	    ayahLineNumber=4794
	    ;;
	053011 )
	    ayahLineNumber=4795
	    ;;
	053012 )
	    ayahLineNumber=4796
	    ;;
	053013 )
	    ayahLineNumber=4797
	    ;;
	053014 )
	    ayahLineNumber=4798
	    ;;
	053015 )
	    ayahLineNumber=4799
	    ;;
	053016 )
	    ayahLineNumber=4800
	    ;;
	053017 )
	    ayahLineNumber=4801
	    ;;
	053018 )
	    ayahLineNumber=4802
	    ;;
	053019 )
	    ayahLineNumber=4803
	    ;;
	053020 )
	    ayahLineNumber=4804
	    ;;
	053021 )
	    ayahLineNumber=4805
	    ;;
	053022 )
	    ayahLineNumber=4806
	    ;;
	053023 )
	    ayahLineNumber=4807
	    ;;
	053024 )
	    ayahLineNumber=4808
	    ;;
	053025 )
	    ayahLineNumber=4809
	    ;;
	053026 )
	    ayahLineNumber=4810
	    ;;
	053027 )
	    ayahLineNumber=4811
	    ;;
	053028 )
	    ayahLineNumber=4812
	    ;;
	053029 )
	    ayahLineNumber=4813
	    ;;
	053030 )
	    ayahLineNumber=4814
	    ;;
	053031 )
	    ayahLineNumber=4815
	    ;;
	053032 )
	    ayahLineNumber=4816
	    ;;
	053033 )
	    ayahLineNumber=4817
	    ;;
	053034 )
	    ayahLineNumber=4818
	    ;;
	053035 )
	    ayahLineNumber=4819
	    ;;
	053036 )
	    ayahLineNumber=4820
	    ;;
	053037 )
	    ayahLineNumber=4821
	    ;;
	053038 )
	    ayahLineNumber=4822
	    ;;
	053039 )
	    ayahLineNumber=4823
	    ;;
	053040 )
	    ayahLineNumber=4824
	    ;;
	053041 )
	    ayahLineNumber=4825
	    ;;
	053042 )
	    ayahLineNumber=4826
	    ;;
	053043 )
	    ayahLineNumber=4827
	    ;;
	053044 )
	    ayahLineNumber=4828
	    ;;
	053045 )
	    ayahLineNumber=4829
	    ;;
	053046 )
	    ayahLineNumber=4830
	    ;;
	053047 )
	    ayahLineNumber=4831
	    ;;
	053048 )
	    ayahLineNumber=4832
	    ;;
	053049 )
	    ayahLineNumber=4833
	    ;;
	053050 )
	    ayahLineNumber=4834
	    ;;
	053051 )
	    ayahLineNumber=4835
	    ;;
	053052 )
	    ayahLineNumber=4836
	    ;;
	053053 )
	    ayahLineNumber=4837
	    ;;
	053054 )
	    ayahLineNumber=4838
	    ;;
	053055 )
	    ayahLineNumber=4839
	    ;;
	053056 )
	    ayahLineNumber=4840
	    ;;
	053057 )
	    ayahLineNumber=4841
	    ;;
	053058 )
	    ayahLineNumber=4842
	    ;;
	053059 )
	    ayahLineNumber=4843
	    ;;
	053060 )
	    ayahLineNumber=4844
	    ;;
	053061 )
	    ayahLineNumber=4845
	    ;;
	053062 )
	    ayahLineNumber=4846
	    ;;
	054001 )
	    ayahLineNumber=4847
	    ;;
	054002 )
	    ayahLineNumber=4848
	    ;;
	054003 )
	    ayahLineNumber=4849
	    ;;
	054004 )
	    ayahLineNumber=4850
	    ;;
	054005 )
	    ayahLineNumber=4851
	    ;;
	054006 )
	    ayahLineNumber=4852
	    ;;
	054007 )
	    ayahLineNumber=4853
	    ;;
	054008 )
	    ayahLineNumber=4854
	    ;;
	054009 )
	    ayahLineNumber=4855
	    ;;
	054010 )
	    ayahLineNumber=4856
	    ;;
	054011 )
	    ayahLineNumber=4857
	    ;;
	054012 )
	    ayahLineNumber=4858
	    ;;
	054013 )
	    ayahLineNumber=4859
	    ;;
	054014 )
	    ayahLineNumber=4860
	    ;;
	054015 )
	    ayahLineNumber=4861
	    ;;
	054016 )
	    ayahLineNumber=4862
	    ;;
	054017 )
	    ayahLineNumber=4863
	    ;;
	054018 )
	    ayahLineNumber=4864
	    ;;
	054019 )
	    ayahLineNumber=4865
	    ;;
	054020 )
	    ayahLineNumber=4866
	    ;;
	054021 )
	    ayahLineNumber=4867
	    ;;
	054022 )
	    ayahLineNumber=4868
	    ;;
	054023 )
	    ayahLineNumber=4869
	    ;;
	054024 )
	    ayahLineNumber=4870
	    ;;
	054025 )
	    ayahLineNumber=4871
	    ;;
	054026 )
	    ayahLineNumber=4872
	    ;;
	054027 )
	    ayahLineNumber=4873
	    ;;
	054028 )
	    ayahLineNumber=4874
	    ;;
	054029 )
	    ayahLineNumber=4875
	    ;;
	054030 )
	    ayahLineNumber=4876
	    ;;
	054031 )
	    ayahLineNumber=4877
	    ;;
	054032 )
	    ayahLineNumber=4878
	    ;;
	054033 )
	    ayahLineNumber=4879
	    ;;
	054034 )
	    ayahLineNumber=4880
	    ;;
	054035 )
	    ayahLineNumber=4881
	    ;;
	054036 )
	    ayahLineNumber=4882
	    ;;
	054037 )
	    ayahLineNumber=4883
	    ;;
	054038 )
	    ayahLineNumber=4884
	    ;;
	054039 )
	    ayahLineNumber=4885
	    ;;
	054040 )
	    ayahLineNumber=4886
	    ;;
	054041 )
	    ayahLineNumber=4887
	    ;;
	054042 )
	    ayahLineNumber=4888
	    ;;
	054043 )
	    ayahLineNumber=4889
	    ;;
	054044 )
	    ayahLineNumber=4890
	    ;;
	054045 )
	    ayahLineNumber=4891
	    ;;
	054046 )
	    ayahLineNumber=4892
	    ;;
	054047 )
	    ayahLineNumber=4893
	    ;;
	054048 )
	    ayahLineNumber=4894
	    ;;
	054049 )
	    ayahLineNumber=4895
	    ;;
	054050 )
	    ayahLineNumber=4896
	    ;;
	054051 )
	    ayahLineNumber=4897
	    ;;
	054052 )
	    ayahLineNumber=4898
	    ;;
	054053 )
	    ayahLineNumber=4899
	    ;;
	054054 )
	    ayahLineNumber=4900
	    ;;
	054055 )
	    ayahLineNumber=4901
	    ;;
	055001 )
	    ayahLineNumber=4902
	    ;;
	055002 )
	    ayahLineNumber=4903
	    ;;
	055003 )
	    ayahLineNumber=4904
	    ;;
	055004 )
	    ayahLineNumber=4905
	    ;;
	055005 )
	    ayahLineNumber=4906
	    ;;
	055006 )
	    ayahLineNumber=4907
	    ;;
	055007 )
	    ayahLineNumber=4908
	    ;;
	055008 )
	    ayahLineNumber=4909
	    ;;
	055009 )
	    ayahLineNumber=4910
	    ;;
	055010 )
	    ayahLineNumber=4911
	    ;;
	055011 )
	    ayahLineNumber=4912
	    ;;
	055012 )
	    ayahLineNumber=4913
	    ;;
	055013 )
	    ayahLineNumber=4914
	    ;;
	055014 )
	    ayahLineNumber=4915
	    ;;
	055015 )
	    ayahLineNumber=4916
	    ;;
	055016 )
	    ayahLineNumber=4917
	    ;;
	055017 )
	    ayahLineNumber=4918
	    ;;
	055018 )
	    ayahLineNumber=4919
	    ;;
	055019 )
	    ayahLineNumber=4920
	    ;;
	055020 )
	    ayahLineNumber=4921
	    ;;
	055021 )
	    ayahLineNumber=4922
	    ;;
	055022 )
	    ayahLineNumber=4923
	    ;;
	055023 )
	    ayahLineNumber=4924
	    ;;
	055024 )
	    ayahLineNumber=4925
	    ;;
	055025 )
	    ayahLineNumber=4926
	    ;;
	055026 )
	    ayahLineNumber=4927
	    ;;
	055027 )
	    ayahLineNumber=4928
	    ;;
	055028 )
	    ayahLineNumber=4929
	    ;;
	055029 )
	    ayahLineNumber=4930
	    ;;
	055030 )
	    ayahLineNumber=4931
	    ;;
	055031 )
	    ayahLineNumber=4932
	    ;;
	055032 )
	    ayahLineNumber=4933
	    ;;
	055033 )
	    ayahLineNumber=4934
	    ;;
	055034 )
	    ayahLineNumber=4935
	    ;;
	055035 )
	    ayahLineNumber=4936
	    ;;
	055036 )
	    ayahLineNumber=4937
	    ;;
	055037 )
	    ayahLineNumber=4938
	    ;;
	055038 )
	    ayahLineNumber=4939
	    ;;
	055039 )
	    ayahLineNumber=4940
	    ;;
	055040 )
	    ayahLineNumber=4941
	    ;;
	055041 )
	    ayahLineNumber=4942
	    ;;
	055042 )
	    ayahLineNumber=4943
	    ;;
	055043 )
	    ayahLineNumber=4944
	    ;;
	055044 )
	    ayahLineNumber=4945
	    ;;
	055045 )
	    ayahLineNumber=4946
	    ;;
	055046 )
	    ayahLineNumber=4947
	    ;;
	055047 )
	    ayahLineNumber=4948
	    ;;
	055048 )
	    ayahLineNumber=4949
	    ;;
	055049 )
	    ayahLineNumber=4950
	    ;;
	055050 )
	    ayahLineNumber=4951
	    ;;
	055051 )
	    ayahLineNumber=4952
	    ;;
	055052 )
	    ayahLineNumber=4953
	    ;;
	055053 )
	    ayahLineNumber=4954
	    ;;
	055054 )
	    ayahLineNumber=4955
	    ;;
	055055 )
	    ayahLineNumber=4956
	    ;;
	055056 )
	    ayahLineNumber=4957
	    ;;
	055057 )
	    ayahLineNumber=4958
	    ;;
	055058 )
	    ayahLineNumber=4959
	    ;;
	055059 )
	    ayahLineNumber=4960
	    ;;
	055060 )
	    ayahLineNumber=4961
	    ;;
	055061 )
	    ayahLineNumber=4962
	    ;;
	055062 )
	    ayahLineNumber=4963
	    ;;
	055063 )
	    ayahLineNumber=4964
	    ;;
	055064 )
	    ayahLineNumber=4965
	    ;;
	055065 )
	    ayahLineNumber=4966
	    ;;
	055066 )
	    ayahLineNumber=4967
	    ;;
	055067 )
	    ayahLineNumber=4968
	    ;;
	055068 )
	    ayahLineNumber=4969
	    ;;
	055069 )
	    ayahLineNumber=4970
	    ;;
	055070 )
	    ayahLineNumber=4971
	    ;;
	055071 )
	    ayahLineNumber=4972
	    ;;
	055072 )
	    ayahLineNumber=4973
	    ;;
	055073 )
	    ayahLineNumber=4974
	    ;;
	055074 )
	    ayahLineNumber=4975
	    ;;
	055075 )
	    ayahLineNumber=4976
	    ;;
	055076 )
	    ayahLineNumber=4977
	    ;;
	055077 )
	    ayahLineNumber=4978
	    ;;
	055078 )
	    ayahLineNumber=4979
	    ;;
	056001 )
	    ayahLineNumber=4980
	    ;;
	056002 )
	    ayahLineNumber=4981
	    ;;
	056003 )
	    ayahLineNumber=4982
	    ;;
	056004 )
	    ayahLineNumber=4983
	    ;;
	056005 )
	    ayahLineNumber=4984
	    ;;
	056006 )
	    ayahLineNumber=4985
	    ;;
	056007 )
	    ayahLineNumber=4986
	    ;;
	056008 )
	    ayahLineNumber=4987
	    ;;
	056009 )
	    ayahLineNumber=4988
	    ;;
	056010 )
	    ayahLineNumber=4989
	    ;;
	056011 )
	    ayahLineNumber=4990
	    ;;
	056012 )
	    ayahLineNumber=4991
	    ;;
	056013 )
	    ayahLineNumber=4992
	    ;;
	056014 )
	    ayahLineNumber=4993
	    ;;
	056015 )
	    ayahLineNumber=4994
	    ;;
	056016 )
	    ayahLineNumber=4995
	    ;;
	056017 )
	    ayahLineNumber=4996
	    ;;
	056018 )
	    ayahLineNumber=4997
	    ;;
	056019 )
	    ayahLineNumber=4998
	    ;;
	056020 )
	    ayahLineNumber=4999
	    ;;
	056021 )
	    ayahLineNumber=5000
	    ;;
	056022 )
	    ayahLineNumber=5001
	    ;;
	056023 )
	    ayahLineNumber=5002
	    ;;
	056024 )
	    ayahLineNumber=5003
	    ;;
	056025 )
	    ayahLineNumber=5004
	    ;;
	056026 )
	    ayahLineNumber=5005
	    ;;
	056027 )
	    ayahLineNumber=5006
	    ;;
	056028 )
	    ayahLineNumber=5007
	    ;;
	056029 )
	    ayahLineNumber=5008
	    ;;
	056030 )
	    ayahLineNumber=5009
	    ;;
	056031 )
	    ayahLineNumber=5010
	    ;;
	056032 )
	    ayahLineNumber=5011
	    ;;
	056033 )
	    ayahLineNumber=5012
	    ;;
	056034 )
	    ayahLineNumber=5013
	    ;;
	056035 )
	    ayahLineNumber=5014
	    ;;
	056036 )
	    ayahLineNumber=5015
	    ;;
	056037 )
	    ayahLineNumber=5016
	    ;;
	056038 )
	    ayahLineNumber=5017
	    ;;
	056039 )
	    ayahLineNumber=5018
	    ;;
	056040 )
	    ayahLineNumber=5019
	    ;;
	056041 )
	    ayahLineNumber=5020
	    ;;
	056042 )
	    ayahLineNumber=5021
	    ;;
	056043 )
	    ayahLineNumber=5022
	    ;;
	056044 )
	    ayahLineNumber=5023
	    ;;
	056045 )
	    ayahLineNumber=5024
	    ;;
	056046 )
	    ayahLineNumber=5025
	    ;;
	056047 )
	    ayahLineNumber=5026
	    ;;
	056048 )
	    ayahLineNumber=5027
	    ;;
	056049 )
	    ayahLineNumber=5028
	    ;;
	056050 )
	    ayahLineNumber=5029
	    ;;
	056051 )
	    ayahLineNumber=5030
	    ;;
	056052 )
	    ayahLineNumber=5031
	    ;;
	056053 )
	    ayahLineNumber=5032
	    ;;
	056054 )
	    ayahLineNumber=5033
	    ;;
	056055 )
	    ayahLineNumber=5034
	    ;;
	056056 )
	    ayahLineNumber=5035
	    ;;
	056057 )
	    ayahLineNumber=5036
	    ;;
	056058 )
	    ayahLineNumber=5037
	    ;;
	056059 )
	    ayahLineNumber=5038
	    ;;
	056060 )
	    ayahLineNumber=5039
	    ;;
	056061 )
	    ayahLineNumber=5040
	    ;;
	056062 )
	    ayahLineNumber=5041
	    ;;
	056063 )
	    ayahLineNumber=5042
	    ;;
	056064 )
	    ayahLineNumber=5043
	    ;;
	056065 )
	    ayahLineNumber=5044
	    ;;
	056066 )
	    ayahLineNumber=5045
	    ;;
	056067 )
	    ayahLineNumber=5046
	    ;;
	056068 )
	    ayahLineNumber=5047
	    ;;
	056069 )
	    ayahLineNumber=5048
	    ;;
	056070 )
	    ayahLineNumber=5049
	    ;;
	056071 )
	    ayahLineNumber=5050
	    ;;
	056072 )
	    ayahLineNumber=5051
	    ;;
	056073 )
	    ayahLineNumber=5052
	    ;;
	056074 )
	    ayahLineNumber=5053
	    ;;
	056075 )
	    ayahLineNumber=5054
	    ;;
	056076 )
	    ayahLineNumber=5055
	    ;;
	056077 )
	    ayahLineNumber=5056
	    ;;
	056078 )
	    ayahLineNumber=5057
	    ;;
	056079 )
	    ayahLineNumber=5058
	    ;;
	056080 )
	    ayahLineNumber=5059
	    ;;
	056081 )
	    ayahLineNumber=5060
	    ;;
	056082 )
	    ayahLineNumber=5061
	    ;;
	056083 )
	    ayahLineNumber=5062
	    ;;
	056084 )
	    ayahLineNumber=5063
	    ;;
	056085 )
	    ayahLineNumber=5064
	    ;;
	056086 )
	    ayahLineNumber=5065
	    ;;
	056087 )
	    ayahLineNumber=5066
	    ;;
	056088 )
	    ayahLineNumber=5067
	    ;;
	056089 )
	    ayahLineNumber=5068
	    ;;
	056090 )
	    ayahLineNumber=5069
	    ;;
	056091 )
	    ayahLineNumber=5070
	    ;;
	056092 )
	    ayahLineNumber=5071
	    ;;
	056093 )
	    ayahLineNumber=5072
	    ;;
	056094 )
	    ayahLineNumber=5073
	    ;;
	056095 )
	    ayahLineNumber=5074
	    ;;
	056096 )
	    ayahLineNumber=5075
	    ;;
	057001 )
	    ayahLineNumber=5076
	    ;;
	057002 )
	    ayahLineNumber=5077
	    ;;
	057003 )
	    ayahLineNumber=5078
	    ;;
	057004 )
	    ayahLineNumber=5079
	    ;;
	057005 )
	    ayahLineNumber=5080
	    ;;
	057006 )
	    ayahLineNumber=5081
	    ;;
	057007 )
	    ayahLineNumber=5082
	    ;;
	057008 )
	    ayahLineNumber=5083
	    ;;
	057009 )
	    ayahLineNumber=5084
	    ;;
	057010 )
	    ayahLineNumber=5085
	    ;;
	057011 )
	    ayahLineNumber=5086
	    ;;
	057012 )
	    ayahLineNumber=5087
	    ;;
	057013 )
	    ayahLineNumber=5088
	    ;;
	057014 )
	    ayahLineNumber=5089
	    ;;
	057015 )
	    ayahLineNumber=5090
	    ;;
	057016 )
	    ayahLineNumber=5091
	    ;;
	057017 )
	    ayahLineNumber=5092
	    ;;
	057018 )
	    ayahLineNumber=5093
	    ;;
	057019 )
	    ayahLineNumber=5094
	    ;;
	057020 )
	    ayahLineNumber=5095
	    ;;
	057021 )
	    ayahLineNumber=5096
	    ;;
	057022 )
	    ayahLineNumber=5097
	    ;;
	057023 )
	    ayahLineNumber=5098
	    ;;
	057024 )
	    ayahLineNumber=5099
	    ;;
	057025 )
	    ayahLineNumber=5100
	    ;;
	057026 )
	    ayahLineNumber=5101
	    ;;
	057027 )
	    ayahLineNumber=5102
	    ;;
	057028 )
	    ayahLineNumber=5103
	    ;;
	057029 )
	    ayahLineNumber=5104
	    ;;
	058001 )
	    ayahLineNumber=5105
	    ;;
	058002 )
	    ayahLineNumber=5106
	    ;;
	058003 )
	    ayahLineNumber=5107
	    ;;
	058004 )
	    ayahLineNumber=5108
	    ;;
	058005 )
	    ayahLineNumber=5109
	    ;;
	058006 )
	    ayahLineNumber=5110
	    ;;
	058007 )
	    ayahLineNumber=5111
	    ;;
	058008 )
	    ayahLineNumber=5112
	    ;;
	058009 )
	    ayahLineNumber=5113
	    ;;
	058010 )
	    ayahLineNumber=5114
	    ;;
	058011 )
	    ayahLineNumber=5115
	    ;;
	058012 )
	    ayahLineNumber=5116
	    ;;
	058013 )
	    ayahLineNumber=5117
	    ;;
	058014 )
	    ayahLineNumber=5118
	    ;;
	058015 )
	    ayahLineNumber=5119
	    ;;
	058016 )
	    ayahLineNumber=5120
	    ;;
	058017 )
	    ayahLineNumber=5121
	    ;;
	058018 )
	    ayahLineNumber=5122
	    ;;
	058019 )
	    ayahLineNumber=5123
	    ;;
	058020 )
	    ayahLineNumber=5124
	    ;;
	058021 )
	    ayahLineNumber=5125
	    ;;
	058022 )
	    ayahLineNumber=5126
	    ;;
	059001 )
	    ayahLineNumber=5127
	    ;;
	059002 )
	    ayahLineNumber=5128
	    ;;
	059003 )
	    ayahLineNumber=5129
	    ;;
	059004 )
	    ayahLineNumber=5130
	    ;;
	059005 )
	    ayahLineNumber=5131
	    ;;
	059006 )
	    ayahLineNumber=5132
	    ;;
	059007 )
	    ayahLineNumber=5133
	    ;;
	059008 )
	    ayahLineNumber=5134
	    ;;
	059009 )
	    ayahLineNumber=5135
	    ;;
	059010 )
	    ayahLineNumber=5136
	    ;;
	059011 )
	    ayahLineNumber=5137
	    ;;
	059012 )
	    ayahLineNumber=5138
	    ;;
	059013 )
	    ayahLineNumber=5139
	    ;;
	059014 )
	    ayahLineNumber=5140
	    ;;
	059015 )
	    ayahLineNumber=5141
	    ;;
	059016 )
	    ayahLineNumber=5142
	    ;;
	059017 )
	    ayahLineNumber=5143
	    ;;
	059018 )
	    ayahLineNumber=5144
	    ;;
	059019 )
	    ayahLineNumber=5145
	    ;;
	059020 )
	    ayahLineNumber=5146
	    ;;
	059021 )
	    ayahLineNumber=5147
	    ;;
	059022 )
	    ayahLineNumber=5148
	    ;;
	059023 )
	    ayahLineNumber=5149
	    ;;
	059024 )
	    ayahLineNumber=5150
	    ;;
	060001 )
	    ayahLineNumber=5151
	    ;;
	060002 )
	    ayahLineNumber=5152
	    ;;
	060003 )
	    ayahLineNumber=5153
	    ;;
	060004 )
	    ayahLineNumber=5154
	    ;;
	060005 )
	    ayahLineNumber=5155
	    ;;
	060006 )
	    ayahLineNumber=5156
	    ;;
	060007 )
	    ayahLineNumber=5157
	    ;;
	060008 )
	    ayahLineNumber=5158
	    ;;
	060009 )
	    ayahLineNumber=5159
	    ;;
	060010 )
	    ayahLineNumber=5160
	    ;;
	060011 )
	    ayahLineNumber=5161
	    ;;
	060012 )
	    ayahLineNumber=5162
	    ;;
	060013 )
	    ayahLineNumber=5163
	    ;;
	061001 )
	    ayahLineNumber=5164
	    ;;
	061002 )
	    ayahLineNumber=5165
	    ;;
	061003 )
	    ayahLineNumber=5166
	    ;;
	061004 )
	    ayahLineNumber=5167
	    ;;
	061005 )
	    ayahLineNumber=5168
	    ;;
	061006 )
	    ayahLineNumber=5169
	    ;;
	061007 )
	    ayahLineNumber=5170
	    ;;
	061008 )
	    ayahLineNumber=5171
	    ;;
	061009 )
	    ayahLineNumber=5172
	    ;;
	061010 )
	    ayahLineNumber=5173
	    ;;
	061011 )
	    ayahLineNumber=5174
	    ;;
	061012 )
	    ayahLineNumber=5175
	    ;;
	061013 )
	    ayahLineNumber=5176
	    ;;
	061014 )
	    ayahLineNumber=5177
	    ;;
	062001 )
	    ayahLineNumber=5178
	    ;;
	062002 )
	    ayahLineNumber=5179
	    ;;
	062003 )
	    ayahLineNumber=5180
	    ;;
	062004 )
	    ayahLineNumber=5181
	    ;;
	062005 )
	    ayahLineNumber=5182
	    ;;
	062006 )
	    ayahLineNumber=5183
	    ;;
	062007 )
	    ayahLineNumber=5184
	    ;;
	062008 )
	    ayahLineNumber=5185
	    ;;
	062009 )
	    ayahLineNumber=5186
	    ;;
	062010 )
	    ayahLineNumber=5187
	    ;;
	062011 )
	    ayahLineNumber=5188
	    ;;
	063001 )
	    ayahLineNumber=5189
	    ;;
	063002 )
	    ayahLineNumber=5190
	    ;;
	063003 )
	    ayahLineNumber=5191
	    ;;
	063004 )
	    ayahLineNumber=5192
	    ;;
	063005 )
	    ayahLineNumber=5193
	    ;;
	063006 )
	    ayahLineNumber=5194
	    ;;
	063007 )
	    ayahLineNumber=5195
	    ;;
	063008 )
	    ayahLineNumber=5196
	    ;;
	063009 )
	    ayahLineNumber=5197
	    ;;
	063010 )
	    ayahLineNumber=5198
	    ;;
	063011 )
	    ayahLineNumber=5199
	    ;;
	064001 )
	    ayahLineNumber=5200
	    ;;
	064002 )
	    ayahLineNumber=5201
	    ;;
	064003 )
	    ayahLineNumber=5202
	    ;;
	064004 )
	    ayahLineNumber=5203
	    ;;
	064005 )
	    ayahLineNumber=5204
	    ;;
	064006 )
	    ayahLineNumber=5205
	    ;;
	064007 )
	    ayahLineNumber=5206
	    ;;
	064008 )
	    ayahLineNumber=5207
	    ;;
	064009 )
	    ayahLineNumber=5208
	    ;;
	064010 )
	    ayahLineNumber=5209
	    ;;
	064011 )
	    ayahLineNumber=5210
	    ;;
	064012 )
	    ayahLineNumber=5211
	    ;;
	064013 )
	    ayahLineNumber=5212
	    ;;
	064014 )
	    ayahLineNumber=5213
	    ;;
	064015 )
	    ayahLineNumber=5214
	    ;;
	064016 )
	    ayahLineNumber=5215
	    ;;
	064017 )
	    ayahLineNumber=5216
	    ;;
	064018 )
	    ayahLineNumber=5217
	    ;;
	065001 )
	    ayahLineNumber=5218
	    ;;
	065002 )
	    ayahLineNumber=5219
	    ;;
	065003 )
	    ayahLineNumber=5220
	    ;;
	065004 )
	    ayahLineNumber=5221
	    ;;
	065005 )
	    ayahLineNumber=5222
	    ;;
	065006 )
	    ayahLineNumber=5223
	    ;;
	065007 )
	    ayahLineNumber=5224
	    ;;
	065008 )
	    ayahLineNumber=5225
	    ;;
	065009 )
	    ayahLineNumber=5226
	    ;;
	065010 )
	    ayahLineNumber=5227
	    ;;
	065011 )
	    ayahLineNumber=5228
	    ;;
	065012 )
	    ayahLineNumber=5229
	    ;;
	066001 )
	    ayahLineNumber=5230
	    ;;
	066002 )
	    ayahLineNumber=5231
	    ;;
	066003 )
	    ayahLineNumber=5232
	    ;;
	066004 )
	    ayahLineNumber=5233
	    ;;
	066005 )
	    ayahLineNumber=5234
	    ;;
	066006 )
	    ayahLineNumber=5235
	    ;;
	066007 )
	    ayahLineNumber=5236
	    ;;
	066008 )
	    ayahLineNumber=5237
	    ;;
	066009 )
	    ayahLineNumber=5238
	    ;;
	066010 )
	    ayahLineNumber=5239
	    ;;
	066011 )
	    ayahLineNumber=5240
	    ;;
	066012 )
	    ayahLineNumber=5241
	    ;;
	067001 )
	    ayahLineNumber=5242
	    ;;
	067002 )
	    ayahLineNumber=5243
	    ;;
	067003 )
	    ayahLineNumber=5244
	    ;;
	067004 )
	    ayahLineNumber=5245
	    ;;
	067005 )
	    ayahLineNumber=5246
	    ;;
	067006 )
	    ayahLineNumber=5247
	    ;;
	067007 )
	    ayahLineNumber=5248
	    ;;
	067008 )
	    ayahLineNumber=5249
	    ;;
	067009 )
	    ayahLineNumber=5250
	    ;;
	067010 )
	    ayahLineNumber=5251
	    ;;
	067011 )
	    ayahLineNumber=5252
	    ;;
	067012 )
	    ayahLineNumber=5253
	    ;;
	067013 )
	    ayahLineNumber=5254
	    ;;
	067014 )
	    ayahLineNumber=5255
	    ;;
	067015 )
	    ayahLineNumber=5256
	    ;;
	067016 )
	    ayahLineNumber=5257
	    ;;
	067017 )
	    ayahLineNumber=5258
	    ;;
	067018 )
	    ayahLineNumber=5259
	    ;;
	067019 )
	    ayahLineNumber=5260
	    ;;
	067020 )
	    ayahLineNumber=5261
	    ;;
	067021 )
	    ayahLineNumber=5262
	    ;;
	067022 )
	    ayahLineNumber=5263
	    ;;
	067023 )
	    ayahLineNumber=5264
	    ;;
	067024 )
	    ayahLineNumber=5265
	    ;;
	067025 )
	    ayahLineNumber=5266
	    ;;
	067026 )
	    ayahLineNumber=5267
	    ;;
	067027 )
	    ayahLineNumber=5268
	    ;;
	067028 )
	    ayahLineNumber=5269
	    ;;
	067029 )
	    ayahLineNumber=5270
	    ;;
	067030 )
	    ayahLineNumber=5271
	    ;;
	068001 )
	    ayahLineNumber=5272
	    ;;
	068002 )
	    ayahLineNumber=5273
	    ;;
	068003 )
	    ayahLineNumber=5274
	    ;;
	068004 )
	    ayahLineNumber=5275
	    ;;
	068005 )
	    ayahLineNumber=5276
	    ;;
	068006 )
	    ayahLineNumber=5277
	    ;;
	068007 )
	    ayahLineNumber=5278
	    ;;
	068008 )
	    ayahLineNumber=5279
	    ;;
	068009 )
	    ayahLineNumber=5280
	    ;;
	068010 )
	    ayahLineNumber=5281
	    ;;
	068011 )
	    ayahLineNumber=5282
	    ;;
	068012 )
	    ayahLineNumber=5283
	    ;;
	068013 )
	    ayahLineNumber=5284
	    ;;
	068014 )
	    ayahLineNumber=5285
	    ;;
	068015 )
	    ayahLineNumber=5286
	    ;;
	068016 )
	    ayahLineNumber=5287
	    ;;
	068017 )
	    ayahLineNumber=5288
	    ;;
	068018 )
	    ayahLineNumber=5289
	    ;;
	068019 )
	    ayahLineNumber=5290
	    ;;
	068020 )
	    ayahLineNumber=5291
	    ;;
	068021 )
	    ayahLineNumber=5292
	    ;;
	068022 )
	    ayahLineNumber=5293
	    ;;
	068023 )
	    ayahLineNumber=5294
	    ;;
	068024 )
	    ayahLineNumber=5295
	    ;;
	068025 )
	    ayahLineNumber=5296
	    ;;
	068026 )
	    ayahLineNumber=5297
	    ;;
	068027 )
	    ayahLineNumber=5298
	    ;;
	068028 )
	    ayahLineNumber=5299
	    ;;
	068029 )
	    ayahLineNumber=5300
	    ;;
	068030 )
	    ayahLineNumber=5301
	    ;;
	068031 )
	    ayahLineNumber=5302
	    ;;
	068032 )
	    ayahLineNumber=5303
	    ;;
	068033 )
	    ayahLineNumber=5304
	    ;;
	068034 )
	    ayahLineNumber=5305
	    ;;
	068035 )
	    ayahLineNumber=5306
	    ;;
	068036 )
	    ayahLineNumber=5307
	    ;;
	068037 )
	    ayahLineNumber=5308
	    ;;
	068038 )
	    ayahLineNumber=5309
	    ;;
	068039 )
	    ayahLineNumber=5310
	    ;;
	068040 )
	    ayahLineNumber=5311
	    ;;
	068041 )
	    ayahLineNumber=5312
	    ;;
	068042 )
	    ayahLineNumber=5313
	    ;;
	068043 )
	    ayahLineNumber=5314
	    ;;
	068044 )
	    ayahLineNumber=5315
	    ;;
	068045 )
	    ayahLineNumber=5316
	    ;;
	068046 )
	    ayahLineNumber=5317
	    ;;
	068047 )
	    ayahLineNumber=5318
	    ;;
	068048 )
	    ayahLineNumber=5319
	    ;;
	068049 )
	    ayahLineNumber=5320
	    ;;
	068050 )
	    ayahLineNumber=5321
	    ;;
	068051 )
	    ayahLineNumber=5322
	    ;;
	068052 )
	    ayahLineNumber=5323
	    ;;
	069001 )
	    ayahLineNumber=5324
	    ;;
	069002 )
	    ayahLineNumber=5325
	    ;;
	069003 )
	    ayahLineNumber=5326
	    ;;
	069004 )
	    ayahLineNumber=5327
	    ;;
	069005 )
	    ayahLineNumber=5328
	    ;;
	069006 )
	    ayahLineNumber=5329
	    ;;
	069007 )
	    ayahLineNumber=5330
	    ;;
	069008 )
	    ayahLineNumber=5331
	    ;;
	069009 )
	    ayahLineNumber=5332
	    ;;
	069010 )
	    ayahLineNumber=5333
	    ;;
	069011 )
	    ayahLineNumber=5334
	    ;;
	069012 )
	    ayahLineNumber=5335
	    ;;
	069013 )
	    ayahLineNumber=5336
	    ;;
	069014 )
	    ayahLineNumber=5337
	    ;;
	069015 )
	    ayahLineNumber=5338
	    ;;
	069016 )
	    ayahLineNumber=5339
	    ;;
	069017 )
	    ayahLineNumber=5340
	    ;;
	069018 )
	    ayahLineNumber=5341
	    ;;
	069019 )
	    ayahLineNumber=5342
	    ;;
	069020 )
	    ayahLineNumber=5343
	    ;;
	069021 )
	    ayahLineNumber=5344
	    ;;
	069022 )
	    ayahLineNumber=5345
	    ;;
	069023 )
	    ayahLineNumber=5346
	    ;;
	069024 )
	    ayahLineNumber=5347
	    ;;
	069025 )
	    ayahLineNumber=5348
	    ;;
	069026 )
	    ayahLineNumber=5349
	    ;;
	069027 )
	    ayahLineNumber=5350
	    ;;
	069028 )
	    ayahLineNumber=5351
	    ;;
	069029 )
	    ayahLineNumber=5352
	    ;;
	069030 )
	    ayahLineNumber=5353
	    ;;
	069031 )
	    ayahLineNumber=5354
	    ;;
	069032 )
	    ayahLineNumber=5355
	    ;;
	069033 )
	    ayahLineNumber=5356
	    ;;
	069034 )
	    ayahLineNumber=5357
	    ;;
	069035 )
	    ayahLineNumber=5358
	    ;;
	069036 )
	    ayahLineNumber=5359
	    ;;
	069037 )
	    ayahLineNumber=5360
	    ;;
	069038 )
	    ayahLineNumber=5361
	    ;;
	069039 )
	    ayahLineNumber=5362
	    ;;
	069040 )
	    ayahLineNumber=5363
	    ;;
	069041 )
	    ayahLineNumber=5364
	    ;;
	069042 )
	    ayahLineNumber=5365
	    ;;
	069043 )
	    ayahLineNumber=5366
	    ;;
	069044 )
	    ayahLineNumber=5367
	    ;;
	069045 )
	    ayahLineNumber=5368
	    ;;
	069046 )
	    ayahLineNumber=5369
	    ;;
	069047 )
	    ayahLineNumber=5370
	    ;;
	069048 )
	    ayahLineNumber=5371
	    ;;
	069049 )
	    ayahLineNumber=5372
	    ;;
	069050 )
	    ayahLineNumber=5373
	    ;;
	069051 )
	    ayahLineNumber=5374
	    ;;
	069052 )
	    ayahLineNumber=5375
	    ;;
	070001 )
	    ayahLineNumber=5376
	    ;;
	070002 )
	    ayahLineNumber=5377
	    ;;
	070003 )
	    ayahLineNumber=5378
	    ;;
	070004 )
	    ayahLineNumber=5379
	    ;;
	070005 )
	    ayahLineNumber=5380
	    ;;
	070006 )
	    ayahLineNumber=5381
	    ;;
	070007 )
	    ayahLineNumber=5382
	    ;;
	070008 )
	    ayahLineNumber=5383
	    ;;
	070009 )
	    ayahLineNumber=5384
	    ;;
	070010 )
	    ayahLineNumber=5385
	    ;;
	070011 )
	    ayahLineNumber=5386
	    ;;
	070012 )
	    ayahLineNumber=5387
	    ;;
	070013 )
	    ayahLineNumber=5388
	    ;;
	070014 )
	    ayahLineNumber=5389
	    ;;
	070015 )
	    ayahLineNumber=5390
	    ;;
	070016 )
	    ayahLineNumber=5391
	    ;;
	070017 )
	    ayahLineNumber=5392
	    ;;
	070018 )
	    ayahLineNumber=5393
	    ;;
	070019 )
	    ayahLineNumber=5394
	    ;;
	070020 )
	    ayahLineNumber=5395
	    ;;
	070021 )
	    ayahLineNumber=5396
	    ;;
	070022 )
	    ayahLineNumber=5397
	    ;;
	070023 )
	    ayahLineNumber=5398
	    ;;
	070024 )
	    ayahLineNumber=5399
	    ;;
	070025 )
	    ayahLineNumber=5400
	    ;;
	070026 )
	    ayahLineNumber=5401
	    ;;
	070027 )
	    ayahLineNumber=5402
	    ;;
	070028 )
	    ayahLineNumber=5403
	    ;;
	070029 )
	    ayahLineNumber=5404
	    ;;
	070030 )
	    ayahLineNumber=5405
	    ;;
	070031 )
	    ayahLineNumber=5406
	    ;;
	070032 )
	    ayahLineNumber=5407
	    ;;
	070033 )
	    ayahLineNumber=5408
	    ;;
	070034 )
	    ayahLineNumber=5409
	    ;;
	070035 )
	    ayahLineNumber=5410
	    ;;
	070036 )
	    ayahLineNumber=5411
	    ;;
	070037 )
	    ayahLineNumber=5412
	    ;;
	070038 )
	    ayahLineNumber=5413
	    ;;
	070039 )
	    ayahLineNumber=5414
	    ;;
	070040 )
	    ayahLineNumber=5415
	    ;;
	070041 )
	    ayahLineNumber=5416
	    ;;
	070042 )
	    ayahLineNumber=5417
	    ;;
	070043 )
	    ayahLineNumber=5418
	    ;;
	070044 )
	    ayahLineNumber=5419
	    ;;
	071001 )
	    ayahLineNumber=5420
	    ;;
	071002 )
	    ayahLineNumber=5421
	    ;;
	071003 )
	    ayahLineNumber=5422
	    ;;
	071004 )
	    ayahLineNumber=5423
	    ;;
	071005 )
	    ayahLineNumber=5424
	    ;;
	071006 )
	    ayahLineNumber=5425
	    ;;
	071007 )
	    ayahLineNumber=5426
	    ;;
	071008 )
	    ayahLineNumber=5427
	    ;;
	071009 )
	    ayahLineNumber=5428
	    ;;
	071010 )
	    ayahLineNumber=5429
	    ;;
	071011 )
	    ayahLineNumber=5430
	    ;;
	071012 )
	    ayahLineNumber=5431
	    ;;
	071013 )
	    ayahLineNumber=5432
	    ;;
	071014 )
	    ayahLineNumber=5433
	    ;;
	071015 )
	    ayahLineNumber=5434
	    ;;
	071016 )
	    ayahLineNumber=5435
	    ;;
	071017 )
	    ayahLineNumber=5436
	    ;;
	071018 )
	    ayahLineNumber=5437
	    ;;
	071019 )
	    ayahLineNumber=5438
	    ;;
	071020 )
	    ayahLineNumber=5439
	    ;;
	071021 )
	    ayahLineNumber=5440
	    ;;
	071022 )
	    ayahLineNumber=5441
	    ;;
	071023 )
	    ayahLineNumber=5442
	    ;;
	071024 )
	    ayahLineNumber=5443
	    ;;
	071025 )
	    ayahLineNumber=5444
	    ;;
	071026 )
	    ayahLineNumber=5445
	    ;;
	071027 )
	    ayahLineNumber=5446
	    ;;
	071028 )
	    ayahLineNumber=5447
	    ;;
	072001 )
	    ayahLineNumber=5448
	    ;;
	072002 )
	    ayahLineNumber=5449
	    ;;
	072003 )
	    ayahLineNumber=5450
	    ;;
	072004 )
	    ayahLineNumber=5451
	    ;;
	072005 )
	    ayahLineNumber=5452
	    ;;
	072006 )
	    ayahLineNumber=5453
	    ;;
	072007 )
	    ayahLineNumber=5454
	    ;;
	072008 )
	    ayahLineNumber=5455
	    ;;
	072009 )
	    ayahLineNumber=5456
	    ;;
	072010 )
	    ayahLineNumber=5457
	    ;;
	072011 )
	    ayahLineNumber=5458
	    ;;
	072012 )
	    ayahLineNumber=5459
	    ;;
	072013 )
	    ayahLineNumber=5460
	    ;;
	072014 )
	    ayahLineNumber=5461
	    ;;
	072015 )
	    ayahLineNumber=5462
	    ;;
	072016 )
	    ayahLineNumber=5463
	    ;;
	072017 )
	    ayahLineNumber=5464
	    ;;
	072018 )
	    ayahLineNumber=5465
	    ;;
	072019 )
	    ayahLineNumber=5466
	    ;;
	072020 )
	    ayahLineNumber=5467
	    ;;
	072021 )
	    ayahLineNumber=5468
	    ;;
	072022 )
	    ayahLineNumber=5469
	    ;;
	072023 )
	    ayahLineNumber=5470
	    ;;
	072024 )
	    ayahLineNumber=5471
	    ;;
	072025 )
	    ayahLineNumber=5472
	    ;;
	072026 )
	    ayahLineNumber=5473
	    ;;
	072027 )
	    ayahLineNumber=5474
	    ;;
	072028 )
	    ayahLineNumber=5475
	    ;;
	073001 )
	    ayahLineNumber=5476
	    ;;
	073002 )
	    ayahLineNumber=5477
	    ;;
	073003 )
	    ayahLineNumber=5478
	    ;;
	073004 )
	    ayahLineNumber=5479
	    ;;
	073005 )
	    ayahLineNumber=5480
	    ;;
	073006 )
	    ayahLineNumber=5481
	    ;;
	073007 )
	    ayahLineNumber=5482
	    ;;
	073008 )
	    ayahLineNumber=5483
	    ;;
	073009 )
	    ayahLineNumber=5484
	    ;;
	073010 )
	    ayahLineNumber=5485
	    ;;
	073011 )
	    ayahLineNumber=5486
	    ;;
	073012 )
	    ayahLineNumber=5487
	    ;;
	073013 )
	    ayahLineNumber=5488
	    ;;
	073014 )
	    ayahLineNumber=5489
	    ;;
	073015 )
	    ayahLineNumber=5490
	    ;;
	073016 )
	    ayahLineNumber=5491
	    ;;
	073017 )
	    ayahLineNumber=5492
	    ;;
	073018 )
	    ayahLineNumber=5493
	    ;;
	073019 )
	    ayahLineNumber=5494
	    ;;
	073020 )
	    ayahLineNumber=5495
	    ;;
	074001 )
	    ayahLineNumber=5496
	    ;;
	074002 )
	    ayahLineNumber=5497
	    ;;
	074003 )
	    ayahLineNumber=5498
	    ;;
	074004 )
	    ayahLineNumber=5499
	    ;;
	074005 )
	    ayahLineNumber=5500
	    ;;
	074006 )
	    ayahLineNumber=5501
	    ;;
	074007 )
	    ayahLineNumber=5502
	    ;;
	074008 )
	    ayahLineNumber=5503
	    ;;
	074009 )
	    ayahLineNumber=5504
	    ;;
	074010 )
	    ayahLineNumber=5505
	    ;;
	074011 )
	    ayahLineNumber=5506
	    ;;
	074012 )
	    ayahLineNumber=5507
	    ;;
	074013 )
	    ayahLineNumber=5508
	    ;;
	074014 )
	    ayahLineNumber=5509
	    ;;
	074015 )
	    ayahLineNumber=5510
	    ;;
	074016 )
	    ayahLineNumber=5511
	    ;;
	074017 )
	    ayahLineNumber=5512
	    ;;
	074018 )
	    ayahLineNumber=5513
	    ;;
	074019 )
	    ayahLineNumber=5514
	    ;;
	074020 )
	    ayahLineNumber=5515
	    ;;
	074021 )
	    ayahLineNumber=5516
	    ;;
	074022 )
	    ayahLineNumber=5517
	    ;;
	074023 )
	    ayahLineNumber=5518
	    ;;
	074024 )
	    ayahLineNumber=5519
	    ;;
	074025 )
	    ayahLineNumber=5520
	    ;;
	074026 )
	    ayahLineNumber=5521
	    ;;
	074027 )
	    ayahLineNumber=5522
	    ;;
	074028 )
	    ayahLineNumber=5523
	    ;;
	074029 )
	    ayahLineNumber=5524
	    ;;
	074030 )
	    ayahLineNumber=5525
	    ;;
	074031 )
	    ayahLineNumber=5526
	    ;;
	074032 )
	    ayahLineNumber=5527
	    ;;
	074033 )
	    ayahLineNumber=5528
	    ;;
	074034 )
	    ayahLineNumber=5529
	    ;;
	074035 )
	    ayahLineNumber=5530
	    ;;
	074036 )
	    ayahLineNumber=5531
	    ;;
	074037 )
	    ayahLineNumber=5532
	    ;;
	074038 )
	    ayahLineNumber=5533
	    ;;
	074039 )
	    ayahLineNumber=5534
	    ;;
	074040 )
	    ayahLineNumber=5535
	    ;;
	074041 )
	    ayahLineNumber=5536
	    ;;
	074042 )
	    ayahLineNumber=5537
	    ;;
	074043 )
	    ayahLineNumber=5538
	    ;;
	074044 )
	    ayahLineNumber=5539
	    ;;
	074045 )
	    ayahLineNumber=5540
	    ;;
	074046 )
	    ayahLineNumber=5541
	    ;;
	074047 )
	    ayahLineNumber=5542
	    ;;
	074048 )
	    ayahLineNumber=5543
	    ;;
	074049 )
	    ayahLineNumber=5544
	    ;;
	074050 )
	    ayahLineNumber=5545
	    ;;
	074051 )
	    ayahLineNumber=5546
	    ;;
	074052 )
	    ayahLineNumber=5547
	    ;;
	074053 )
	    ayahLineNumber=5548
	    ;;
	074054 )
	    ayahLineNumber=5549
	    ;;
	074055 )
	    ayahLineNumber=5550
	    ;;
	074056 )
	    ayahLineNumber=5551
	    ;;
	075001 )
	    ayahLineNumber=5552
	    ;;
	075002 )
	    ayahLineNumber=5553
	    ;;
	075003 )
	    ayahLineNumber=5554
	    ;;
	075004 )
	    ayahLineNumber=5555
	    ;;
	075005 )
	    ayahLineNumber=5556
	    ;;
	075006 )
	    ayahLineNumber=5557
	    ;;
	075007 )
	    ayahLineNumber=5558
	    ;;
	075008 )
	    ayahLineNumber=5559
	    ;;
	075009 )
	    ayahLineNumber=5560
	    ;;
	075010 )
	    ayahLineNumber=5561
	    ;;
	075011 )
	    ayahLineNumber=5562
	    ;;
	075012 )
	    ayahLineNumber=5563
	    ;;
	075013 )
	    ayahLineNumber=5564
	    ;;
	075014 )
	    ayahLineNumber=5565
	    ;;
	075015 )
	    ayahLineNumber=5566
	    ;;
	075016 )
	    ayahLineNumber=5567
	    ;;
	075017 )
	    ayahLineNumber=5568
	    ;;
	075018 )
	    ayahLineNumber=5569
	    ;;
	075019 )
	    ayahLineNumber=5570
	    ;;
	075020 )
	    ayahLineNumber=5571
	    ;;
	075021 )
	    ayahLineNumber=5572
	    ;;
	075022 )
	    ayahLineNumber=5573
	    ;;
	075023 )
	    ayahLineNumber=5574
	    ;;
	075024 )
	    ayahLineNumber=5575
	    ;;
	075025 )
	    ayahLineNumber=5576
	    ;;
	075026 )
	    ayahLineNumber=5577
	    ;;
	075027 )
	    ayahLineNumber=5578
	    ;;
	075028 )
	    ayahLineNumber=5579
	    ;;
	075029 )
	    ayahLineNumber=5580
	    ;;
	075030 )
	    ayahLineNumber=5581
	    ;;
	075031 )
	    ayahLineNumber=5582
	    ;;
	075032 )
	    ayahLineNumber=5583
	    ;;
	075033 )
	    ayahLineNumber=5584
	    ;;
	075034 )
	    ayahLineNumber=5585
	    ;;
	075035 )
	    ayahLineNumber=5586
	    ;;
	075036 )
	    ayahLineNumber=5587
	    ;;
	075037 )
	    ayahLineNumber=5588
	    ;;
	075038 )
	    ayahLineNumber=5589
	    ;;
	075039 )
	    ayahLineNumber=5590
	    ;;
	075040 )
	    ayahLineNumber=5591
	    ;;
	076001 )
	    ayahLineNumber=5592
	    ;;
	076002 )
	    ayahLineNumber=5593
	    ;;
	076003 )
	    ayahLineNumber=5594
	    ;;
	076004 )
	    ayahLineNumber=5595
	    ;;
	076005 )
	    ayahLineNumber=5596
	    ;;
	076006 )
	    ayahLineNumber=5597
	    ;;
	076007 )
	    ayahLineNumber=5598
	    ;;
	076008 )
	    ayahLineNumber=5599
	    ;;
	076009 )
	    ayahLineNumber=5600
	    ;;
	076010 )
	    ayahLineNumber=5601
	    ;;
	076011 )
	    ayahLineNumber=5602
	    ;;
	076012 )
	    ayahLineNumber=5603
	    ;;
	076013 )
	    ayahLineNumber=5604
	    ;;
	076014 )
	    ayahLineNumber=5605
	    ;;
	076015 )
	    ayahLineNumber=5606
	    ;;
	076016 )
	    ayahLineNumber=5607
	    ;;
	076017 )
	    ayahLineNumber=5608
	    ;;
	076018 )
	    ayahLineNumber=5609
	    ;;
	076019 )
	    ayahLineNumber=5610
	    ;;
	076020 )
	    ayahLineNumber=5611
	    ;;
	076021 )
	    ayahLineNumber=5612
	    ;;
	076022 )
	    ayahLineNumber=5613
	    ;;
	076023 )
	    ayahLineNumber=5614
	    ;;
	076024 )
	    ayahLineNumber=5615
	    ;;
	076025 )
	    ayahLineNumber=5616
	    ;;
	076026 )
	    ayahLineNumber=5617
	    ;;
	076027 )
	    ayahLineNumber=5618
	    ;;
	076028 )
	    ayahLineNumber=5619
	    ;;
	076029 )
	    ayahLineNumber=5620
	    ;;
	076030 )
	    ayahLineNumber=5621
	    ;;
	076031 )
	    ayahLineNumber=5622
	    ;;
	077001 )
	    ayahLineNumber=5623
	    ;;
	077002 )
	    ayahLineNumber=5624
	    ;;
	077003 )
	    ayahLineNumber=5625
	    ;;
	077004 )
	    ayahLineNumber=5626
	    ;;
	077005 )
	    ayahLineNumber=5627
	    ;;
	077006 )
	    ayahLineNumber=5628
	    ;;
	077007 )
	    ayahLineNumber=5629
	    ;;
	077008 )
	    ayahLineNumber=5630
	    ;;
	077009 )
	    ayahLineNumber=5631
	    ;;
	077010 )
	    ayahLineNumber=5632
	    ;;
	077011 )
	    ayahLineNumber=5633
	    ;;
	077012 )
	    ayahLineNumber=5634
	    ;;
	077013 )
	    ayahLineNumber=5635
	    ;;
	077014 )
	    ayahLineNumber=5636
	    ;;
	077015 )
	    ayahLineNumber=5637
	    ;;
	077016 )
	    ayahLineNumber=5638
	    ;;
	077017 )
	    ayahLineNumber=5639
	    ;;
	077018 )
	    ayahLineNumber=5640
	    ;;
	077019 )
	    ayahLineNumber=5641
	    ;;
	077020 )
	    ayahLineNumber=5642
	    ;;
	077021 )
	    ayahLineNumber=5643
	    ;;
	077022 )
	    ayahLineNumber=5644
	    ;;
	077023 )
	    ayahLineNumber=5645
	    ;;
	077024 )
	    ayahLineNumber=5646
	    ;;
	077025 )
	    ayahLineNumber=5647
	    ;;
	077026 )
	    ayahLineNumber=5648
	    ;;
	077027 )
	    ayahLineNumber=5649
	    ;;
	077028 )
	    ayahLineNumber=5650
	    ;;
	077029 )
	    ayahLineNumber=5651
	    ;;
	077030 )
	    ayahLineNumber=5652
	    ;;
	077031 )
	    ayahLineNumber=5653
	    ;;
	077032 )
	    ayahLineNumber=5654
	    ;;
	077033 )
	    ayahLineNumber=5655
	    ;;
	077034 )
	    ayahLineNumber=5656
	    ;;
	077035 )
	    ayahLineNumber=5657
	    ;;
	077036 )
	    ayahLineNumber=5658
	    ;;
	077037 )
	    ayahLineNumber=5659
	    ;;
	077038 )
	    ayahLineNumber=5660
	    ;;
	077039 )
	    ayahLineNumber=5661
	    ;;
	077040 )
	    ayahLineNumber=5662
	    ;;
	077041 )
	    ayahLineNumber=5663
	    ;;
	077042 )
	    ayahLineNumber=5664
	    ;;
	077043 )
	    ayahLineNumber=5665
	    ;;
	077044 )
	    ayahLineNumber=5666
	    ;;
	077045 )
	    ayahLineNumber=5667
	    ;;
	077046 )
	    ayahLineNumber=5668
	    ;;
	077047 )
	    ayahLineNumber=5669
	    ;;
	077048 )
	    ayahLineNumber=5670
	    ;;
	077049 )
	    ayahLineNumber=5671
	    ;;
	077050 )
	    ayahLineNumber=5672
	    ;;
	078001 )
	    ayahLineNumber=5673
	    ;;
	078002 )
	    ayahLineNumber=5674
	    ;;
	078003 )
	    ayahLineNumber=5675
	    ;;
	078004 )
	    ayahLineNumber=5676
	    ;;
	078005 )
	    ayahLineNumber=5677
	    ;;
	078006 )
	    ayahLineNumber=5678
	    ;;
	078007 )
	    ayahLineNumber=5679
	    ;;
	078008 )
	    ayahLineNumber=5680
	    ;;
	078009 )
	    ayahLineNumber=5681
	    ;;
	078010 )
	    ayahLineNumber=5682
	    ;;
	078011 )
	    ayahLineNumber=5683
	    ;;
	078012 )
	    ayahLineNumber=5684
	    ;;
	078013 )
	    ayahLineNumber=5685
	    ;;
	078014 )
	    ayahLineNumber=5686
	    ;;
	078015 )
	    ayahLineNumber=5687
	    ;;
	078016 )
	    ayahLineNumber=5688
	    ;;
	078017 )
	    ayahLineNumber=5689
	    ;;
	078018 )
	    ayahLineNumber=5690
	    ;;
	078019 )
	    ayahLineNumber=5691
	    ;;
	078020 )
	    ayahLineNumber=5692
	    ;;
	078021 )
	    ayahLineNumber=5693
	    ;;
	078022 )
	    ayahLineNumber=5694
	    ;;
	078023 )
	    ayahLineNumber=5695
	    ;;
	078024 )
	    ayahLineNumber=5696
	    ;;
	078025 )
	    ayahLineNumber=5697
	    ;;
	078026 )
	    ayahLineNumber=5698
	    ;;
	078027 )
	    ayahLineNumber=5699
	    ;;
	078028 )
	    ayahLineNumber=5700
	    ;;
	078029 )
	    ayahLineNumber=5701
	    ;;
	078030 )
	    ayahLineNumber=5702
	    ;;
	078031 )
	    ayahLineNumber=5703
	    ;;
	078032 )
	    ayahLineNumber=5704
	    ;;
	078033 )
	    ayahLineNumber=5705
	    ;;
	078034 )
	    ayahLineNumber=5706
	    ;;
	078035 )
	    ayahLineNumber=5707
	    ;;
	078036 )
	    ayahLineNumber=5708
	    ;;
	078037 )
	    ayahLineNumber=5709
	    ;;
	078038 )
	    ayahLineNumber=5710
	    ;;
	078039 )
	    ayahLineNumber=5711
	    ;;
	078040 )
	    ayahLineNumber=5712
	    ;;
	079001 )
	    ayahLineNumber=5713
	    ;;
	079002 )
	    ayahLineNumber=5714
	    ;;
	079003 )
	    ayahLineNumber=5715
	    ;;
	079004 )
	    ayahLineNumber=5716
	    ;;
	079005 )
	    ayahLineNumber=5717
	    ;;
	079006 )
	    ayahLineNumber=5718
	    ;;
	079007 )
	    ayahLineNumber=5719
	    ;;
	079008 )
	    ayahLineNumber=5720
	    ;;
	079009 )
	    ayahLineNumber=5721
	    ;;
	079010 )
	    ayahLineNumber=5722
	    ;;
	079011 )
	    ayahLineNumber=5723
	    ;;
	079012 )
	    ayahLineNumber=5724
	    ;;
	079013 )
	    ayahLineNumber=5725
	    ;;
	079014 )
	    ayahLineNumber=5726
	    ;;
	079015 )
	    ayahLineNumber=5727
	    ;;
	079016 )
	    ayahLineNumber=5728
	    ;;
	079017 )
	    ayahLineNumber=5729
	    ;;
	079018 )
	    ayahLineNumber=5730
	    ;;
	079019 )
	    ayahLineNumber=5731
	    ;;
	079020 )
	    ayahLineNumber=5732
	    ;;
	079021 )
	    ayahLineNumber=5733
	    ;;
	079022 )
	    ayahLineNumber=5734
	    ;;
	079023 )
	    ayahLineNumber=5735
	    ;;
	079024 )
	    ayahLineNumber=5736
	    ;;
	079025 )
	    ayahLineNumber=5737
	    ;;
	079026 )
	    ayahLineNumber=5738
	    ;;
	079027 )
	    ayahLineNumber=5739
	    ;;
	079028 )
	    ayahLineNumber=5740
	    ;;
	079029 )
	    ayahLineNumber=5741
	    ;;
	079030 )
	    ayahLineNumber=5742
	    ;;
	079031 )
	    ayahLineNumber=5743
	    ;;
	079032 )
	    ayahLineNumber=5744
	    ;;
	079033 )
	    ayahLineNumber=5745
	    ;;
	079034 )
	    ayahLineNumber=5746
	    ;;
	079035 )
	    ayahLineNumber=5747
	    ;;
	079036 )
	    ayahLineNumber=5748
	    ;;
	079037 )
	    ayahLineNumber=5749
	    ;;
	079038 )
	    ayahLineNumber=5750
	    ;;
	079039 )
	    ayahLineNumber=5751
	    ;;
	079040 )
	    ayahLineNumber=5752
	    ;;
	079041 )
	    ayahLineNumber=5753
	    ;;
	079042 )
	    ayahLineNumber=5754
	    ;;
	079043 )
	    ayahLineNumber=5755
	    ;;
	079044 )
	    ayahLineNumber=5756
	    ;;
	079045 )
	    ayahLineNumber=5757
	    ;;
	079046 )
	    ayahLineNumber=5758
	    ;;
	080001 )
	    ayahLineNumber=5759
	    ;;
	080002 )
	    ayahLineNumber=5760
	    ;;
	080003 )
	    ayahLineNumber=5761
	    ;;
	080004 )
	    ayahLineNumber=5762
	    ;;
	080005 )
	    ayahLineNumber=5763
	    ;;
	080006 )
	    ayahLineNumber=5764
	    ;;
	080007 )
	    ayahLineNumber=5765
	    ;;
	080008 )
	    ayahLineNumber=5766
	    ;;
	080009 )
	    ayahLineNumber=5767
	    ;;
	080010 )
	    ayahLineNumber=5768
	    ;;
	080011 )
	    ayahLineNumber=5769
	    ;;
	080012 )
	    ayahLineNumber=5770
	    ;;
	080013 )
	    ayahLineNumber=5771
	    ;;
	080014 )
	    ayahLineNumber=5772
	    ;;
	080015 )
	    ayahLineNumber=5773
	    ;;
	080016 )
	    ayahLineNumber=5774
	    ;;
	080017 )
	    ayahLineNumber=5775
	    ;;
	080018 )
	    ayahLineNumber=5776
	    ;;
	080019 )
	    ayahLineNumber=5777
	    ;;
	080020 )
	    ayahLineNumber=5778
	    ;;
	080021 )
	    ayahLineNumber=5779
	    ;;
	080022 )
	    ayahLineNumber=5780
	    ;;
	080023 )
	    ayahLineNumber=5781
	    ;;
	080024 )
	    ayahLineNumber=5782
	    ;;
	080025 )
	    ayahLineNumber=5783
	    ;;
	080026 )
	    ayahLineNumber=5784
	    ;;
	080027 )
	    ayahLineNumber=5785
	    ;;
	080028 )
	    ayahLineNumber=5786
	    ;;
	080029 )
	    ayahLineNumber=5787
	    ;;
	080030 )
	    ayahLineNumber=5788
	    ;;
	080031 )
	    ayahLineNumber=5789
	    ;;
	080032 )
	    ayahLineNumber=5790
	    ;;
	080033 )
	    ayahLineNumber=5791
	    ;;
	080034 )
	    ayahLineNumber=5792
	    ;;
	080035 )
	    ayahLineNumber=5793
	    ;;
	080036 )
	    ayahLineNumber=5794
	    ;;
	080037 )
	    ayahLineNumber=5795
	    ;;
	080038 )
	    ayahLineNumber=5796
	    ;;
	080039 )
	    ayahLineNumber=5797
	    ;;
	080040 )
	    ayahLineNumber=5798
	    ;;
	080041 )
	    ayahLineNumber=5799
	    ;;
	080042 )
	    ayahLineNumber=5800
	    ;;
	081001 )
	    ayahLineNumber=5801
	    ;;
	081002 )
	    ayahLineNumber=5802
	    ;;
	081003 )
	    ayahLineNumber=5803
	    ;;
	081004 )
	    ayahLineNumber=5804
	    ;;
	081005 )
	    ayahLineNumber=5805
	    ;;
	081006 )
	    ayahLineNumber=5806
	    ;;
	081007 )
	    ayahLineNumber=5807
	    ;;
	081008 )
	    ayahLineNumber=5808
	    ;;
	081009 )
	    ayahLineNumber=5809
	    ;;
	081010 )
	    ayahLineNumber=5810
	    ;;
	081011 )
	    ayahLineNumber=5811
	    ;;
	081012 )
	    ayahLineNumber=5812
	    ;;
	081013 )
	    ayahLineNumber=5813
	    ;;
	081014 )
	    ayahLineNumber=5814
	    ;;
	081015 )
	    ayahLineNumber=5815
	    ;;
	081016 )
	    ayahLineNumber=5816
	    ;;
	081017 )
	    ayahLineNumber=5817
	    ;;
	081018 )
	    ayahLineNumber=5818
	    ;;
	081019 )
	    ayahLineNumber=5819
	    ;;
	081020 )
	    ayahLineNumber=5820
	    ;;
	081021 )
	    ayahLineNumber=5821
	    ;;
	081022 )
	    ayahLineNumber=5822
	    ;;
	081023 )
	    ayahLineNumber=5823
	    ;;
	081024 )
	    ayahLineNumber=5824
	    ;;
	081025 )
	    ayahLineNumber=5825
	    ;;
	081026 )
	    ayahLineNumber=5826
	    ;;
	081027 )
	    ayahLineNumber=5827
	    ;;
	081028 )
	    ayahLineNumber=5828
	    ;;
	081029 )
	    ayahLineNumber=5829
	    ;;
	082001 )
	    ayahLineNumber=5830
	    ;;
	082002 )
	    ayahLineNumber=5831
	    ;;
	082003 )
	    ayahLineNumber=5832
	    ;;
	082004 )
	    ayahLineNumber=5833
	    ;;
	082005 )
	    ayahLineNumber=5834
	    ;;
	082006 )
	    ayahLineNumber=5835
	    ;;
	082007 )
	    ayahLineNumber=5836
	    ;;
	082008 )
	    ayahLineNumber=5837
	    ;;
	082009 )
	    ayahLineNumber=5838
	    ;;
	082010 )
	    ayahLineNumber=5839
	    ;;
	082011 )
	    ayahLineNumber=5840
	    ;;
	082012 )
	    ayahLineNumber=5841
	    ;;
	082013 )
	    ayahLineNumber=5842
	    ;;
	082014 )
	    ayahLineNumber=5843
	    ;;
	082015 )
	    ayahLineNumber=5844
	    ;;
	082016 )
	    ayahLineNumber=5845
	    ;;
	082017 )
	    ayahLineNumber=5846
	    ;;
	082018 )
	    ayahLineNumber=5847
	    ;;
	082019 )
	    ayahLineNumber=5848
	    ;;
	083001 )
	    ayahLineNumber=5849
	    ;;
	083002 )
	    ayahLineNumber=5850
	    ;;
	083003 )
	    ayahLineNumber=5851
	    ;;
	083004 )
	    ayahLineNumber=5852
	    ;;
	083005 )
	    ayahLineNumber=5853
	    ;;
	083006 )
	    ayahLineNumber=5854
	    ;;
	083007 )
	    ayahLineNumber=5855
	    ;;
	083008 )
	    ayahLineNumber=5856
	    ;;
	083009 )
	    ayahLineNumber=5857
	    ;;
	083010 )
	    ayahLineNumber=5858
	    ;;
	083011 )
	    ayahLineNumber=5859
	    ;;
	083012 )
	    ayahLineNumber=5860
	    ;;
	083013 )
	    ayahLineNumber=5861
	    ;;
	083014 )
	    ayahLineNumber=5862
	    ;;
	083015 )
	    ayahLineNumber=5863
	    ;;
	083016 )
	    ayahLineNumber=5864
	    ;;
	083017 )
	    ayahLineNumber=5865
	    ;;
	083018 )
	    ayahLineNumber=5866
	    ;;
	083019 )
	    ayahLineNumber=5867
	    ;;
	083020 )
	    ayahLineNumber=5868
	    ;;
	083021 )
	    ayahLineNumber=5869
	    ;;
	083022 )
	    ayahLineNumber=5870
	    ;;
	083023 )
	    ayahLineNumber=5871
	    ;;
	083024 )
	    ayahLineNumber=5872
	    ;;
	083025 )
	    ayahLineNumber=5873
	    ;;
	083026 )
	    ayahLineNumber=5874
	    ;;
	083027 )
	    ayahLineNumber=5875
	    ;;
	083028 )
	    ayahLineNumber=5876
	    ;;
	083029 )
	    ayahLineNumber=5877
	    ;;
	083030 )
	    ayahLineNumber=5878
	    ;;
	083031 )
	    ayahLineNumber=5879
	    ;;
	083032 )
	    ayahLineNumber=5880
	    ;;
	083033 )
	    ayahLineNumber=5881
	    ;;
	083034 )
	    ayahLineNumber=5882
	    ;;
	083035 )
	    ayahLineNumber=5883
	    ;;
	083036 )
	    ayahLineNumber=5884
	    ;;
	084001 )
	    ayahLineNumber=5885
	    ;;
	084002 )
	    ayahLineNumber=5886
	    ;;
	084003 )
	    ayahLineNumber=5887
	    ;;
	084004 )
	    ayahLineNumber=5888
	    ;;
	084005 )
	    ayahLineNumber=5889
	    ;;
	084006 )
	    ayahLineNumber=5890
	    ;;
	084007 )
	    ayahLineNumber=5891
	    ;;
	084008 )
	    ayahLineNumber=5892
	    ;;
	084009 )
	    ayahLineNumber=5893
	    ;;
	084010 )
	    ayahLineNumber=5894
	    ;;
	084011 )
	    ayahLineNumber=5895
	    ;;
	084012 )
	    ayahLineNumber=5896
	    ;;
	084013 )
	    ayahLineNumber=5897
	    ;;
	084014 )
	    ayahLineNumber=5898
	    ;;
	084015 )
	    ayahLineNumber=5899
	    ;;
	084016 )
	    ayahLineNumber=5900
	    ;;
	084017 )
	    ayahLineNumber=5901
	    ;;
	084018 )
	    ayahLineNumber=5902
	    ;;
	084019 )
	    ayahLineNumber=5903
	    ;;
	084020 )
	    ayahLineNumber=5904
	    ;;
	084021 )
	    ayahLineNumber=5905
	    ;;
	084022 )
	    ayahLineNumber=5906
	    ;;
	084023 )
	    ayahLineNumber=5907
	    ;;
	084024 )
	    ayahLineNumber=5908
	    ;;
	084025 )
	    ayahLineNumber=5909
	    ;;
	085001 )
	    ayahLineNumber=5910
	    ;;
	085002 )
	    ayahLineNumber=5911
	    ;;
	085003 )
	    ayahLineNumber=5912
	    ;;
	085004 )
	    ayahLineNumber=5913
	    ;;
	085005 )
	    ayahLineNumber=5914
	    ;;
	085006 )
	    ayahLineNumber=5915
	    ;;
	085007 )
	    ayahLineNumber=5916
	    ;;
	085008 )
	    ayahLineNumber=5917
	    ;;
	085009 )
	    ayahLineNumber=5918
	    ;;
	085010 )
	    ayahLineNumber=5919
	    ;;
	085011 )
	    ayahLineNumber=5920
	    ;;
	085012 )
	    ayahLineNumber=5921
	    ;;
	085013 )
	    ayahLineNumber=5922
	    ;;
	085014 )
	    ayahLineNumber=5923
	    ;;
	085015 )
	    ayahLineNumber=5924
	    ;;
	085016 )
	    ayahLineNumber=5925
	    ;;
	085017 )
	    ayahLineNumber=5926
	    ;;
	085018 )
	    ayahLineNumber=5927
	    ;;
	085019 )
	    ayahLineNumber=5928
	    ;;
	085020 )
	    ayahLineNumber=5929
	    ;;
	085021 )
	    ayahLineNumber=5930
	    ;;
	085022 )
	    ayahLineNumber=5931
	    ;;
	086001 )
	    ayahLineNumber=5932
	    ;;
	086002 )
	    ayahLineNumber=5933
	    ;;
	086003 )
	    ayahLineNumber=5934
	    ;;
	086004 )
	    ayahLineNumber=5935
	    ;;
	086005 )
	    ayahLineNumber=5936
	    ;;
	086006 )
	    ayahLineNumber=5937
	    ;;
	086007 )
	    ayahLineNumber=5938
	    ;;
	086008 )
	    ayahLineNumber=5939
	    ;;
	086009 )
	    ayahLineNumber=5940
	    ;;
	086010 )
	    ayahLineNumber=5941
	    ;;
	086011 )
	    ayahLineNumber=5942
	    ;;
	086012 )
	    ayahLineNumber=5943
	    ;;
	086013 )
	    ayahLineNumber=5944
	    ;;
	086014 )
	    ayahLineNumber=5945
	    ;;
	086015 )
	    ayahLineNumber=5946
	    ;;
	086016 )
	    ayahLineNumber=5947
	    ;;
	086017 )
	    ayahLineNumber=5948
	    ;;
	087001 )
	    ayahLineNumber=5949
	    ;;
	087002 )
	    ayahLineNumber=5950
	    ;;
	087003 )
	    ayahLineNumber=5951
	    ;;
	087004 )
	    ayahLineNumber=5952
	    ;;
	087005 )
	    ayahLineNumber=5953
	    ;;
	087006 )
	    ayahLineNumber=5954
	    ;;
	087007 )
	    ayahLineNumber=5955
	    ;;
	087008 )
	    ayahLineNumber=5956
	    ;;
	087009 )
	    ayahLineNumber=5957
	    ;;
	087010 )
	    ayahLineNumber=5958
	    ;;
	087011 )
	    ayahLineNumber=5959
	    ;;
	087012 )
	    ayahLineNumber=5960
	    ;;
	087013 )
	    ayahLineNumber=5961
	    ;;
	087014 )
	    ayahLineNumber=5962
	    ;;
	087015 )
	    ayahLineNumber=5963
	    ;;
	087016 )
	    ayahLineNumber=5964
	    ;;
	087017 )
	    ayahLineNumber=5965
	    ;;
	087018 )
	    ayahLineNumber=5966
	    ;;
	087019 )
	    ayahLineNumber=5967
	    ;;
	088001 )
	    ayahLineNumber=5968
	    ;;
	088002 )
	    ayahLineNumber=5969
	    ;;
	088003 )
	    ayahLineNumber=5970
	    ;;
	088004 )
	    ayahLineNumber=5971
	    ;;
	088005 )
	    ayahLineNumber=5972
	    ;;
	088006 )
	    ayahLineNumber=5973
	    ;;
	088007 )
	    ayahLineNumber=5974
	    ;;
	088008 )
	    ayahLineNumber=5975
	    ;;
	088009 )
	    ayahLineNumber=5976
	    ;;
	088010 )
	    ayahLineNumber=5977
	    ;;
	088011 )
	    ayahLineNumber=5978
	    ;;
	088012 )
	    ayahLineNumber=5979
	    ;;
	088013 )
	    ayahLineNumber=5980
	    ;;
	088014 )
	    ayahLineNumber=5981
	    ;;
	088015 )
	    ayahLineNumber=5982
	    ;;
	088016 )
	    ayahLineNumber=5983
	    ;;
	088017 )
	    ayahLineNumber=5984
	    ;;
	088018 )
	    ayahLineNumber=5985
	    ;;
	088019 )
	    ayahLineNumber=5986
	    ;;
	088020 )
	    ayahLineNumber=5987
	    ;;
	088021 )
	    ayahLineNumber=5988
	    ;;
	088022 )
	    ayahLineNumber=5989
	    ;;
	088023 )
	    ayahLineNumber=5990
	    ;;
	088024 )
	    ayahLineNumber=5991
	    ;;
	088025 )
	    ayahLineNumber=5992
	    ;;
	088026 )
	    ayahLineNumber=5993
	    ;;
	089001 )
	    ayahLineNumber=5994
	    ;;
	089002 )
	    ayahLineNumber=5995
	    ;;
	089003 )
	    ayahLineNumber=5996
	    ;;
	089004 )
	    ayahLineNumber=5997
	    ;;
	089005 )
	    ayahLineNumber=5998
	    ;;
	089006 )
	    ayahLineNumber=5999
	    ;;
	089007 )
	    ayahLineNumber=6000
	    ;;
	089008 )
	    ayahLineNumber=6001
	    ;;
	089009 )
	    ayahLineNumber=6002
	    ;;
	089010 )
	    ayahLineNumber=6003
	    ;;
	089011 )
	    ayahLineNumber=6004
	    ;;
	089012 )
	    ayahLineNumber=6005
	    ;;
	089013 )
	    ayahLineNumber=6006
	    ;;
	089014 )
	    ayahLineNumber=6007
	    ;;
	089015 )
	    ayahLineNumber=6008
	    ;;
	089016 )
	    ayahLineNumber=6009
	    ;;
	089017 )
	    ayahLineNumber=6010
	    ;;
	089018 )
	    ayahLineNumber=6011
	    ;;
	089019 )
	    ayahLineNumber=6012
	    ;;
	089020 )
	    ayahLineNumber=6013
	    ;;
	089021 )
	    ayahLineNumber=6014
	    ;;
	089022 )
	    ayahLineNumber=6015
	    ;;
	089023 )
	    ayahLineNumber=6016
	    ;;
	089024 )
	    ayahLineNumber=6017
	    ;;
	089025 )
	    ayahLineNumber=6018
	    ;;
	089026 )
	    ayahLineNumber=6019
	    ;;
	089027 )
	    ayahLineNumber=6020
	    ;;
	089028 )
	    ayahLineNumber=6021
	    ;;
	089029 )
	    ayahLineNumber=6022
	    ;;
	089030 )
	    ayahLineNumber=6023
	    ;;
	090001 )
	    ayahLineNumber=6024
	    ;;
	090002 )
	    ayahLineNumber=6025
	    ;;
	090003 )
	    ayahLineNumber=6026
	    ;;
	090004 )
	    ayahLineNumber=6027
	    ;;
	090005 )
	    ayahLineNumber=6028
	    ;;
	090006 )
	    ayahLineNumber=6029
	    ;;
	090007 )
	    ayahLineNumber=6030
	    ;;
	090008 )
	    ayahLineNumber=6031
	    ;;
	090009 )
	    ayahLineNumber=6032
	    ;;
	090010 )
	    ayahLineNumber=6033
	    ;;
	090011 )
	    ayahLineNumber=6034
	    ;;
	090012 )
	    ayahLineNumber=6035
	    ;;
	090013 )
	    ayahLineNumber=6036
	    ;;
	090014 )
	    ayahLineNumber=6037
	    ;;
	090015 )
	    ayahLineNumber=6038
	    ;;
	090016 )
	    ayahLineNumber=6039
	    ;;
	090017 )
	    ayahLineNumber=6040
	    ;;
	090018 )
	    ayahLineNumber=6041
	    ;;
	090019 )
	    ayahLineNumber=6042
	    ;;
	090020 )
	    ayahLineNumber=6043
	    ;;
	091001 )
	    ayahLineNumber=6044
	    ;;
	091002 )
	    ayahLineNumber=6045
	    ;;
	091003 )
	    ayahLineNumber=6046
	    ;;
	091004 )
	    ayahLineNumber=6047
	    ;;
	091005 )
	    ayahLineNumber=6048
	    ;;
	091006 )
	    ayahLineNumber=6049
	    ;;
	091007 )
	    ayahLineNumber=6050
	    ;;
	091008 )
	    ayahLineNumber=6051
	    ;;
	091009 )
	    ayahLineNumber=6052
	    ;;
	091010 )
	    ayahLineNumber=6053
	    ;;
	091011 )
	    ayahLineNumber=6054
	    ;;
	091012 )
	    ayahLineNumber=6055
	    ;;
	091013 )
	    ayahLineNumber=6056
	    ;;
	091014 )
	    ayahLineNumber=6057
	    ;;
	091015 )
	    ayahLineNumber=6058
	    ;;
	092001 )
	    ayahLineNumber=6059
	    ;;
	092002 )
	    ayahLineNumber=6060
	    ;;
	092003 )
	    ayahLineNumber=6061
	    ;;
	092004 )
	    ayahLineNumber=6062
	    ;;
	092005 )
	    ayahLineNumber=6063
	    ;;
	092006 )
	    ayahLineNumber=6064
	    ;;
	092007 )
	    ayahLineNumber=6065
	    ;;
	092008 )
	    ayahLineNumber=6066
	    ;;
	092009 )
	    ayahLineNumber=6067
	    ;;
	092010 )
	    ayahLineNumber=6068
	    ;;
	092011 )
	    ayahLineNumber=6069
	    ;;
	092012 )
	    ayahLineNumber=6070
	    ;;
	092013 )
	    ayahLineNumber=6071
	    ;;
	092014 )
	    ayahLineNumber=6072
	    ;;
	092015 )
	    ayahLineNumber=6073
	    ;;
	092016 )
	    ayahLineNumber=6074
	    ;;
	092017 )
	    ayahLineNumber=6075
	    ;;
	092018 )
	    ayahLineNumber=6076
	    ;;
	092019 )
	    ayahLineNumber=6077
	    ;;
	092020 )
	    ayahLineNumber=6078
	    ;;
	092021 )
	    ayahLineNumber=6079
	    ;;
	093001 )
	    ayahLineNumber=6080
	    ;;
	093002 )
	    ayahLineNumber=6081
	    ;;
	093003 )
	    ayahLineNumber=6082
	    ;;
	093004 )
	    ayahLineNumber=6083
	    ;;
	093005 )
	    ayahLineNumber=6084
	    ;;
	093006 )
	    ayahLineNumber=6085
	    ;;
	093007 )
	    ayahLineNumber=6086
	    ;;
	093008 )
	    ayahLineNumber=6087
	    ;;
	093009 )
	    ayahLineNumber=6088
	    ;;
	093010 )
	    ayahLineNumber=6089
	    ;;
	093011 )
	    ayahLineNumber=6090
	    ;;
	094001 )
	    ayahLineNumber=6091
	    ;;
	094002 )
	    ayahLineNumber=6092
	    ;;
	094003 )
	    ayahLineNumber=6093
	    ;;
	094004 )
	    ayahLineNumber=6094
	    ;;
	094005 )
	    ayahLineNumber=6095
	    ;;
	094006 )
	    ayahLineNumber=6096
	    ;;
	094007 )
	    ayahLineNumber=6097
	    ;;
	094008 )
	    ayahLineNumber=6098
	    ;;
	095001 )
	    ayahLineNumber=6099
	    ;;
	095002 )
	    ayahLineNumber=6100
	    ;;
	095003 )
	    ayahLineNumber=6101
	    ;;
	095004 )
	    ayahLineNumber=6102
	    ;;
	095005 )
	    ayahLineNumber=6103
	    ;;
	095006 )
	    ayahLineNumber=6104
	    ;;
	095007 )
	    ayahLineNumber=6105
	    ;;
	095008 )
	    ayahLineNumber=6106
	    ;;
	096001 )
	    ayahLineNumber=6107
	    ;;
	096002 )
	    ayahLineNumber=6108
	    ;;
	096003 )
	    ayahLineNumber=6109
	    ;;
	096004 )
	    ayahLineNumber=6110
	    ;;
	096005 )
	    ayahLineNumber=6111
	    ;;
	096006 )
	    ayahLineNumber=6112
	    ;;
	096007 )
	    ayahLineNumber=6113
	    ;;
	096008 )
	    ayahLineNumber=6114
	    ;;
	096009 )
	    ayahLineNumber=6115
	    ;;
	096010 )
	    ayahLineNumber=6116
	    ;;
	096011 )
	    ayahLineNumber=6117
	    ;;
	096012 )
	    ayahLineNumber=6118
	    ;;
	096013 )
	    ayahLineNumber=6119
	    ;;
	096014 )
	    ayahLineNumber=6120
	    ;;
	096015 )
	    ayahLineNumber=6121
	    ;;
	096016 )
	    ayahLineNumber=6122
	    ;;
	096017 )
	    ayahLineNumber=6123
	    ;;
	096018 )
	    ayahLineNumber=6124
	    ;;
	096019 )
	    ayahLineNumber=6125
	    ;;
	097001 )
	    ayahLineNumber=6126
	    ;;
	097002 )
	    ayahLineNumber=6127
	    ;;
	097003 )
	    ayahLineNumber=6128
	    ;;
	097004 )
	    ayahLineNumber=6129
	    ;;
	097005 )
	    ayahLineNumber=6130
	    ;;
	098001 )
	    ayahLineNumber=6131
	    ;;
	098002 )
	    ayahLineNumber=6132
	    ;;
	098003 )
	    ayahLineNumber=6133
	    ;;
	098004 )
	    ayahLineNumber=6134
	    ;;
	098005 )
	    ayahLineNumber=6135
	    ;;
	098006 )
	    ayahLineNumber=6136
	    ;;
	098007 )
	    ayahLineNumber=6137
	    ;;
	098008 )
	    ayahLineNumber=6138
	    ;;
	099001 )
	    ayahLineNumber=6139
	    ;;
	099002 )
	    ayahLineNumber=6140
	    ;;
	099003 )
	    ayahLineNumber=6141
	    ;;
	099004 )
	    ayahLineNumber=6142
	    ;;
	099005 )
	    ayahLineNumber=6143
	    ;;
	099006 )
	    ayahLineNumber=6144
	    ;;
	099007 )
	    ayahLineNumber=6145
	    ;;
	099008 )
	    ayahLineNumber=6146
	    ;;
	100001 )
	    ayahLineNumber=6147
	    ;;
	100002 )
	    ayahLineNumber=6148
	    ;;
	100003 )
	    ayahLineNumber=6149
	    ;;
	100004 )
	    ayahLineNumber=6150
	    ;;
	100005 )
	    ayahLineNumber=6151
	    ;;
	100006 )
	    ayahLineNumber=6152
	    ;;
	100007 )
	    ayahLineNumber=6153
	    ;;
	100008 )
	    ayahLineNumber=6154
	    ;;
	100009 )
	    ayahLineNumber=6155
	    ;;
	100010 )
	    ayahLineNumber=6156
	    ;;
	100011 )
	    ayahLineNumber=6157
	    ;;
	101001 )
	    ayahLineNumber=6158
	    ;;
	101002 )
	    ayahLineNumber=6159
	    ;;
	101003 )
	    ayahLineNumber=6160
	    ;;
	101004 )
	    ayahLineNumber=6161
	    ;;
	101005 )
	    ayahLineNumber=6162
	    ;;
	101006 )
	    ayahLineNumber=6163
	    ;;
	101007 )
	    ayahLineNumber=6164
	    ;;
	101008 )
	    ayahLineNumber=6165
	    ;;
	101009 )
	    ayahLineNumber=6166
	    ;;
	101010 )
	    ayahLineNumber=6167
	    ;;
	101011 )
	    ayahLineNumber=6168
	    ;;
	102001 )
	    ayahLineNumber=6169
	    ;;
	102002 )
	    ayahLineNumber=6170
	    ;;
	102003 )
	    ayahLineNumber=6171
	    ;;
	102004 )
	    ayahLineNumber=6172
	    ;;
	102005 )
	    ayahLineNumber=6173
	    ;;
	102006 )
	    ayahLineNumber=6174
	    ;;
	102007 )
	    ayahLineNumber=6175
	    ;;
	102008 )
	    ayahLineNumber=6176
	    ;;
	103001 )
	    ayahLineNumber=6177
	    ;;
	103002 )
	    ayahLineNumber=6178
	    ;;
	103003 )
	    ayahLineNumber=6179
	    ;;
	104001 )
	    ayahLineNumber=6180
	    ;;
	104002 )
	    ayahLineNumber=6181
	    ;;
	104003 )
	    ayahLineNumber=6182
	    ;;
	104004 )
	    ayahLineNumber=6183
	    ;;
	104005 )
	    ayahLineNumber=6184
	    ;;
	104006 )
	    ayahLineNumber=6185
	    ;;
	104007 )
	    ayahLineNumber=6186
	    ;;
	104008 )
	    ayahLineNumber=6187
	    ;;
	104009 )
	    ayahLineNumber=6188
	    ;;
	105001 )
	    ayahLineNumber=6189
	    ;;
	105002 )
	    ayahLineNumber=6190
	    ;;
	105003 )
	    ayahLineNumber=6191
	    ;;
	105004 )
	    ayahLineNumber=6192
	    ;;
	105005 )
	    ayahLineNumber=6193
	    ;;
	106001 )
	    ayahLineNumber=6194
	    ;;
	106002 )
	    ayahLineNumber=6195
	    ;;
	106003 )
	    ayahLineNumber=6196
	    ;;
	106004 )
	    ayahLineNumber=6197
	    ;;
	107001 )
	    ayahLineNumber=6198
	    ;;
	107002 )
	    ayahLineNumber=6199
	    ;;
	107003 )
	    ayahLineNumber=6200
	    ;;
	107004 )
	    ayahLineNumber=6201
	    ;;
	107005 )
	    ayahLineNumber=6202
	    ;;
	107006 )
	    ayahLineNumber=6203
	    ;;
	107007 )
	    ayahLineNumber=6204
	    ;;
	108001 )
	    ayahLineNumber=6205
	    ;;
	108002 )
	    ayahLineNumber=6206
	    ;;
	108003 )
	    ayahLineNumber=6207
	    ;;
	109001 )
	    ayahLineNumber=6208
	    ;;
	109002 )
	    ayahLineNumber=6209
	    ;;
	109003 )
	    ayahLineNumber=6210
	    ;;
	109004 )
	    ayahLineNumber=6211
	    ;;
	109005 )
	    ayahLineNumber=6212
	    ;;
	109006 )
	    ayahLineNumber=6213
	    ;;
	110001 )
	    ayahLineNumber=6214
	    ;;
	110002 )
	    ayahLineNumber=6215
	    ;;
	110003 )
	    ayahLineNumber=6216
	    ;;
	111001 )
	    ayahLineNumber=6217
	    ;;
	111002 )
	    ayahLineNumber=6218
	    ;;
	111003 )
	    ayahLineNumber=6219
	    ;;
	111004 )
	    ayahLineNumber=6220
	    ;;
	111005 )
	    ayahLineNumber=6221
	    ;;
	112001 )
	    ayahLineNumber=6222
	    ;;
	112002 )
	    ayahLineNumber=6223
	    ;;
	112003 )
	    ayahLineNumber=6224
	    ;;
	112004 )
	    ayahLineNumber=6225
	    ;;
	113001 )
	    ayahLineNumber=6226
	    ;;
	113002 )
	    ayahLineNumber=6227
	    ;;
	113003 )
	    ayahLineNumber=6228
	    ;;
	113004 )
	    ayahLineNumber=6229
	    ;;
	113005 )
	    ayahLineNumber=6230
	    ;;
	114001 )
	    ayahLineNumber=6231
	    ;;
	114002 )
	    ayahLineNumber=6232
	    ;;
	114003 )
	    ayahLineNumber=6233
	    ;;
	114004 )
	    ayahLineNumber=6234
	    ;;
	114005 )
	    ayahLineNumber=6235
	    ;;
	114006 )
	    ayahLineNumber=6236
	    ;;
	* )
	    flag="755"
	    echo
	    echo "The Sūrah+Ayah Number you entered in:"
	    echo
	    echo "$surahAndAyahNum"
	    echo
	    echo "is invalid! Please check the number"
	    echo "format is correct, that is 3-digits"
	    echo "for the surah number (between 001 and"
	    echo "110) followed by 3-other-digits for"
	    echo "ayah number (from 001 to the number"
	    echo "of the last verse of the given Sūrah)"
	    echo "Note that you have to put leading"
	    echo "zeros to make Sūrah number as well"
	    echo "as ayat number, have 3-digits."
	    echo
	    exit    
    esac
}



###############################
# This function takes the line
# number of a given ayah as it
# appears in the zekr/tanzil
# Quran/Translation file, then
# gives its real referenc in 6
# digits. The first 3 identify
# its Sūrah, for instance 005,
# the last 3 identify its ayah
# number, for instance 099. Both
# with leading zeros -> 005099
#
# This function will be used in
# case the user enters ayaat in
# range. for example 001001_001007.
# In such case we convert the 1st
# part into its corresponding line
# number, then the last part also.
# Once we get these, we generate
# the whole lines for which the
# user wants tafsir. We pass these
# lines to this very fuction below
# so that is gives us its reference
# in the 6-above-mentioned digits.
# Then we will pass the list of ayaat
# reference to the relevant tafsir
# lookup function.
#
# *Final Note* that the function:
# "convert_surahAndAyahNumber_to_tanzil_ayahLineNumber"
# takes a SūrahNumber+AyahNumber in
# 6 digits and converts it into a
# line number corresponding to the
# verse address in zekr/tanzil file.
#
# On the other hand, the one below:
# "conv_ayahLineNumber_to_surahAndAyahNumber"
# takes line number and generates a
# SūrahNumber+AyahNumber. So the 2
# functions do "opposite-tasks"
#
conv_ayahLineNumber_to_surahAndAyahNumber(){
    local ayahLineNumber="$1"
    case $ayahLineNumber in
	1 )
	    surahAndAyahNumber="001001"
	    ;;
	2 )
	    surahAndAyahNumber="001002"
	    ;;
	3 )
	    surahAndAyahNumber="001003"
	    ;;
	4 )
	    surahAndAyahNumber="001004"
	    ;;
	5 )
	    surahAndAyahNumber="001005"
	    ;;
	6 )
	    surahAndAyahNumber="001006"
	    ;;
	7 )
	    surahAndAyahNumber="001007"
	    ;;
	8 )
	    surahAndAyahNumber="002001"
	    ;;
	9 )
	    surahAndAyahNumber="002002"
	    ;;
	10 )
	    surahAndAyahNumber="002003"
	    ;;
	11 )
	    surahAndAyahNumber="002004"
	    ;;
	12 )
	    surahAndAyahNumber="002005"
	    ;;
	13 )
	    surahAndAyahNumber="002006"
	    ;;
	14 )
	    surahAndAyahNumber="002007"
	    ;;
	15 )
	    surahAndAyahNumber="002008"
	    ;;
	16 )
	    surahAndAyahNumber="002009"
	    ;;
	17 )
	    surahAndAyahNumber="002010"
	    ;;
	18 )
	    surahAndAyahNumber="002011"
	    ;;
	19 )
	    surahAndAyahNumber="002012"
	    ;;
	20 )
	    surahAndAyahNumber="002013"
	    ;;
	21 )
	    surahAndAyahNumber="002014"
	    ;;
	22 )
	    surahAndAyahNumber="002015"
	    ;;
	23 )
	    surahAndAyahNumber="002016"
	    ;;
	24 )
	    surahAndAyahNumber="002017"
	    ;;
	25 )
	    surahAndAyahNumber="002018"
	    ;;
	26 )
	    surahAndAyahNumber="002019"
	    ;;
	27 )
	    surahAndAyahNumber="002020"
	    ;;
	28 )
	    surahAndAyahNumber="002021"
	    ;;
	29 )
	    surahAndAyahNumber="002022"
	    ;;
	30 )
	    surahAndAyahNumber="002023"
	    ;;
	31 )
	    surahAndAyahNumber="002024"
	    ;;
	32 )
	    surahAndAyahNumber="002025"
	    ;;
	33 )
	    surahAndAyahNumber="002026"
	    ;;
	34 )
	    surahAndAyahNumber="002027"
	    ;;
	35 )
	    surahAndAyahNumber="002028"
	    ;;
	36 )
	    surahAndAyahNumber="002029"
	    ;;
	37 )
	    surahAndAyahNumber="002030"
	    ;;
	38 )
	    surahAndAyahNumber="002031"
	    ;;
	39 )
	    surahAndAyahNumber="002032"
	    ;;
	40 )
	    surahAndAyahNumber="002033"
	    ;;
	41 )
	    surahAndAyahNumber="002034"
	    ;;
	42 )
	    surahAndAyahNumber="002035"
	    ;;
	43 )
	    surahAndAyahNumber="002036"
	    ;;
	44 )
	    surahAndAyahNumber="002037"
	    ;;
	45 )
	    surahAndAyahNumber="002038"
	    ;;
	46 )
	    surahAndAyahNumber="002039"
	    ;;
	47 )
	    surahAndAyahNumber="002040"
	    ;;
	48 )
	    surahAndAyahNumber="002041"
	    ;;
	49 )
	    surahAndAyahNumber="002042"
	    ;;
	50 )
	    surahAndAyahNumber="002043"
	    ;;
	51 )
	    surahAndAyahNumber="002044"
	    ;;
	52 )
	    surahAndAyahNumber="002045"
	    ;;
	53 )
	    surahAndAyahNumber="002046"
	    ;;
	54 )
	    surahAndAyahNumber="002047"
	    ;;
	55 )
	    surahAndAyahNumber="002048"
	    ;;
	56 )
	    surahAndAyahNumber="002049"
	    ;;
	57 )
	    surahAndAyahNumber="002050"
	    ;;
	58 )
	    surahAndAyahNumber="002051"
	    ;;
	59 )
	    surahAndAyahNumber="002052"
	    ;;
	60 )
	    surahAndAyahNumber="002053"
	    ;;
	61 )
	    surahAndAyahNumber="002054"
	    ;;
	62 )
	    surahAndAyahNumber="002055"
	    ;;
	63 )
	    surahAndAyahNumber="002056"
	    ;;
	64 )
	    surahAndAyahNumber="002057"
	    ;;
	65 )
	    surahAndAyahNumber="002058"
	    ;;
	66 )
	    surahAndAyahNumber="002059"
	    ;;
	67 )
	    surahAndAyahNumber="002060"
	    ;;
	68 )
	    surahAndAyahNumber="002061"
	    ;;
	69 )
	    surahAndAyahNumber="002062"
	    ;;
	70 )
	    surahAndAyahNumber="002063"
	    ;;
	71 )
	    surahAndAyahNumber="002064"
	    ;;
	72 )
	    surahAndAyahNumber="002065"
	    ;;
	73 )
	    surahAndAyahNumber="002066"
	    ;;
	74 )
	    surahAndAyahNumber="002067"
	    ;;
	75 )
	    surahAndAyahNumber="002068"
	    ;;
	76 )
	    surahAndAyahNumber="002069"
	    ;;
	77 )
	    surahAndAyahNumber="002070"
	    ;;
	78 )
	    surahAndAyahNumber="002071"
	    ;;
	79 )
	    surahAndAyahNumber="002072"
	    ;;
	80 )
	    surahAndAyahNumber="002073"
	    ;;
	81 )
	    surahAndAyahNumber="002074"
	    ;;
	82 )
	    surahAndAyahNumber="002075"
	    ;;
	83 )
	    surahAndAyahNumber="002076"
	    ;;
	84 )
	    surahAndAyahNumber="002077"
	    ;;
	85 )
	    surahAndAyahNumber="002078"
	    ;;
	86 )
	    surahAndAyahNumber="002079"
	    ;;
	87 )
	    surahAndAyahNumber="002080"
	    ;;
	88 )
	    surahAndAyahNumber="002081"
	    ;;
	89 )
	    surahAndAyahNumber="002082"
	    ;;
	90 )
	    surahAndAyahNumber="002083"
	    ;;
	91 )
	    surahAndAyahNumber="002084"
	    ;;
	92 )
	    surahAndAyahNumber="002085"
	    ;;
	93 )
	    surahAndAyahNumber="002086"
	    ;;
	94 )
	    surahAndAyahNumber="002087"
	    ;;
	95 )
	    surahAndAyahNumber="002088"
	    ;;
	96 )
	    surahAndAyahNumber="002089"
	    ;;
	97 )
	    surahAndAyahNumber="002090"
	    ;;
	98 )
	    surahAndAyahNumber="002091"
	    ;;
	99 )
	    surahAndAyahNumber="002092"
	    ;;
	100 )
	    surahAndAyahNumber="002093"
	    ;;
	101 )
	    surahAndAyahNumber="002094"
	    ;;
	102 )
	    surahAndAyahNumber="002095"
	    ;;
	103 )
	    surahAndAyahNumber="002096"
	    ;;
	104 )
	    surahAndAyahNumber="002097"
	    ;;
	105 )
	    surahAndAyahNumber="002098"
	    ;;
	106 )
	    surahAndAyahNumber="002099"
	    ;;
	107 )
	    surahAndAyahNumber="002100"
	    ;;
	108 )
	    surahAndAyahNumber="002101"
	    ;;
	109 )
	    surahAndAyahNumber="002102"
	    ;;
	110 )
	    surahAndAyahNumber="002103"
	    ;;
	111 )
	    surahAndAyahNumber="002104"
	    ;;
	112 )
	    surahAndAyahNumber="002105"
	    ;;
	113 )
	    surahAndAyahNumber="002106"
	    ;;
	114 )
	    surahAndAyahNumber="002107"
	    ;;
	115 )
	    surahAndAyahNumber="002108"
	    ;;
	116 )
	    surahAndAyahNumber="002109"
	    ;;
	117 )
	    surahAndAyahNumber="002110"
	    ;;
	118 )
	    surahAndAyahNumber="002111"
	    ;;
	119 )
	    surahAndAyahNumber="002112"
	    ;;
	120 )
	    surahAndAyahNumber="002113"
	    ;;
	121 )
	    surahAndAyahNumber="002114"
	    ;;
	122 )
	    surahAndAyahNumber="002115"
	    ;;
	123 )
	    surahAndAyahNumber="002116"
	    ;;
	124 )
	    surahAndAyahNumber="002117"
	    ;;
	125 )
	    surahAndAyahNumber="002118"
	    ;;
	126 )
	    surahAndAyahNumber="002119"
	    ;;
	127 )
	    surahAndAyahNumber="002120"
	    ;;
	128 )
	    surahAndAyahNumber="002121"
	    ;;
	129 )
	    surahAndAyahNumber="002122"
	    ;;
	130 )
	    surahAndAyahNumber="002123"
	    ;;
	131 )
	    surahAndAyahNumber="002124"
	    ;;
	132 )
	    surahAndAyahNumber="002125"
	    ;;
	133 )
	    surahAndAyahNumber="002126"
	    ;;
	134 )
	    surahAndAyahNumber="002127"
	    ;;
	135 )
	    surahAndAyahNumber="002128"
	    ;;
	136 )
	    surahAndAyahNumber="002129"
	    ;;
	137 )
	    surahAndAyahNumber="002130"
	    ;;
	138 )
	    surahAndAyahNumber="002131"
	    ;;
	139 )
	    surahAndAyahNumber="002132"
	    ;;
	140 )
	    surahAndAyahNumber="002133"
	    ;;
	141 )
	    surahAndAyahNumber="002134"
	    ;;
	142 )
	    surahAndAyahNumber="002135"
	    ;;
	143 )
	    surahAndAyahNumber="002136"
	    ;;
	144 )
	    surahAndAyahNumber="002137"
	    ;;
	145 )
	    surahAndAyahNumber="002138"
	    ;;
	146 )
	    surahAndAyahNumber="002139"
	    ;;
	147 )
	    surahAndAyahNumber="002140"
	    ;;
	148 )
	    surahAndAyahNumber="002141"
	    ;;
	149 )
	    surahAndAyahNumber="002142"
	    ;;
	150 )
	    surahAndAyahNumber="002143"
	    ;;
	151 )
	    surahAndAyahNumber="002144"
	    ;;
	152 )
	    surahAndAyahNumber="002145"
	    ;;
	153 )
	    surahAndAyahNumber="002146"
	    ;;
	154 )
	    surahAndAyahNumber="002147"
	    ;;
	155 )
	    surahAndAyahNumber="002148"
	    ;;
	156 )
	    surahAndAyahNumber="002149"
	    ;;
	157 )
	    surahAndAyahNumber="002150"
	    ;;
	158 )
	    surahAndAyahNumber="002151"
	    ;;
	159 )
	    surahAndAyahNumber="002152"
	    ;;
	160 )
	    surahAndAyahNumber="002153"
	    ;;
	161 )
	    surahAndAyahNumber="002154"
	    ;;
	162 )
	    surahAndAyahNumber="002155"
	    ;;
	163 )
	    surahAndAyahNumber="002156"
	    ;;
	164 )
	    surahAndAyahNumber="002157"
	    ;;
	165 )
	    surahAndAyahNumber="002158"
	    ;;
	166 )
	    surahAndAyahNumber="002159"
	    ;;
	167 )
	    surahAndAyahNumber="002160"
	    ;;
	168 )
	    surahAndAyahNumber="002161"
	    ;;
	169 )
	    surahAndAyahNumber="002162"
	    ;;
	170 )
	    surahAndAyahNumber="002163"
	    ;;
	171 )
	    surahAndAyahNumber="002164"
	    ;;
	172 )
	    surahAndAyahNumber="002165"
	    ;;
	173 )
	    surahAndAyahNumber="002166"
	    ;;
	174 )
	    surahAndAyahNumber="002167"
	    ;;
	175 )
	    surahAndAyahNumber="002168"
	    ;;
	176 )
	    surahAndAyahNumber="002169"
	    ;;
	177 )
	    surahAndAyahNumber="002170"
	    ;;
	178 )
	    surahAndAyahNumber="002171"
	    ;;
	179 )
	    surahAndAyahNumber="002172"
	    ;;
	180 )
	    surahAndAyahNumber="002173"
	    ;;
	181 )
	    surahAndAyahNumber="002174"
	    ;;
	182 )
	    surahAndAyahNumber="002175"
	    ;;
	183 )
	    surahAndAyahNumber="002176"
	    ;;
	184 )
	    surahAndAyahNumber="002177"
	    ;;
	185 )
	    surahAndAyahNumber="002178"
	    ;;
	186 )
	    surahAndAyahNumber="002179"
	    ;;
	187 )
	    surahAndAyahNumber="002180"
	    ;;
	188 )
	    surahAndAyahNumber="002181"
	    ;;
	189 )
	    surahAndAyahNumber="002182"
	    ;;
	190 )
	    surahAndAyahNumber="002183"
	    ;;
	191 )
	    surahAndAyahNumber="002184"
	    ;;
	192 )
	    surahAndAyahNumber="002185"
	    ;;
	193 )
	    surahAndAyahNumber="002186"
	    ;;
	194 )
	    surahAndAyahNumber="002187"
	    ;;
	195 )
	    surahAndAyahNumber="002188"
	    ;;
	196 )
	    surahAndAyahNumber="002189"
	    ;;
	197 )
	    surahAndAyahNumber="002190"
	    ;;
	198 )
	    surahAndAyahNumber="002191"
	    ;;
	199 )
	    surahAndAyahNumber="002192"
	    ;;
	200 )
	    surahAndAyahNumber="002193"
	    ;;
	201 )
	    surahAndAyahNumber="002194"
	    ;;
	202 )
	    surahAndAyahNumber="002195"
	    ;;
	203 )
	    surahAndAyahNumber="002196"
	    ;;
	204 )
	    surahAndAyahNumber="002197"
	    ;;
	205 )
	    surahAndAyahNumber="002198"
	    ;;
	206 )
	    surahAndAyahNumber="002199"
	    ;;
	207 )
	    surahAndAyahNumber="002200"
	    ;;
	208 )
	    surahAndAyahNumber="002201"
	    ;;
	209 )
	    surahAndAyahNumber="002202"
	    ;;
	210 )
	    surahAndAyahNumber="002203"
	    ;;
	211 )
	    surahAndAyahNumber="002204"
	    ;;
	212 )
	    surahAndAyahNumber="002205"
	    ;;
	213 )
	    surahAndAyahNumber="002206"
	    ;;
	214 )
	    surahAndAyahNumber="002207"
	    ;;
	215 )
	    surahAndAyahNumber="002208"
	    ;;
	216 )
	    surahAndAyahNumber="002209"
	    ;;
	217 )
	    surahAndAyahNumber="002210"
	    ;;
	218 )
	    surahAndAyahNumber="002211"
	    ;;
	219 )
	    surahAndAyahNumber="002212"
	    ;;
	220 )
	    surahAndAyahNumber="002213"
	    ;;
	221 )
	    surahAndAyahNumber="002214"
	    ;;
	222 )
	    surahAndAyahNumber="002215"
	    ;;
	223 )
	    surahAndAyahNumber="002216"
	    ;;
	224 )
	    surahAndAyahNumber="002217"
	    ;;
	225 )
	    surahAndAyahNumber="002218"
	    ;;
	226 )
	    surahAndAyahNumber="002219"
	    ;;
	227 )
	    surahAndAyahNumber="002220"
	    ;;
	228 )
	    surahAndAyahNumber="002221"
	    ;;
	229 )
	    surahAndAyahNumber="002222"
	    ;;
	230 )
	    surahAndAyahNumber="002223"
	    ;;
	231 )
	    surahAndAyahNumber="002224"
	    ;;
	232 )
	    surahAndAyahNumber="002225"
	    ;;
	233 )
	    surahAndAyahNumber="002226"
	    ;;
	234 )
	    surahAndAyahNumber="002227"
	    ;;
	235 )
	    surahAndAyahNumber="002228"
	    ;;
	236 )
	    surahAndAyahNumber="002229"
	    ;;
	237 )
	    surahAndAyahNumber="002230"
	    ;;
	238 )
	    surahAndAyahNumber="002231"
	    ;;
	239 )
	    surahAndAyahNumber="002232"
	    ;;
	240 )
	    surahAndAyahNumber="002233"
	    ;;
	241 )
	    surahAndAyahNumber="002234"
	    ;;
	242 )
	    surahAndAyahNumber="002235"
	    ;;
	243 )
	    surahAndAyahNumber="002236"
	    ;;
	244 )
	    surahAndAyahNumber="002237"
	    ;;
	245 )
	    surahAndAyahNumber="002238"
	    ;;
	246 )
	    surahAndAyahNumber="002239"
	    ;;
	247 )
	    surahAndAyahNumber="002240"
	    ;;
	248 )
	    surahAndAyahNumber="002241"
	    ;;
	249 )
	    surahAndAyahNumber="002242"
	    ;;
	250 )
	    surahAndAyahNumber="002243"
	    ;;
	251 )
	    surahAndAyahNumber="002244"
	    ;;
	252 )
	    surahAndAyahNumber="002245"
	    ;;
	253 )
	    surahAndAyahNumber="002246"
	    ;;
	254 )
	    surahAndAyahNumber="002247"
	    ;;
	255 )
	    surahAndAyahNumber="002248"
	    ;;
	256 )
	    surahAndAyahNumber="002249"
	    ;;
	257 )
	    surahAndAyahNumber="002250"
	    ;;
	258 )
	    surahAndAyahNumber="002251"
	    ;;
	259 )
	    surahAndAyahNumber="002252"
	    ;;
	260 )
	    surahAndAyahNumber="002253"
	    ;;
	261 )
	    surahAndAyahNumber="002254"
	    ;;
	262 )
	    surahAndAyahNumber="002255"
	    ;;
	263 )
	    surahAndAyahNumber="002256"
	    ;;
	264 )
	    surahAndAyahNumber="002257"
	    ;;
	265 )
	    surahAndAyahNumber="002258"
	    ;;
	266 )
	    surahAndAyahNumber="002259"
	    ;;
	267 )
	    surahAndAyahNumber="002260"
	    ;;
	268 )
	    surahAndAyahNumber="002261"
	    ;;
	269 )
	    surahAndAyahNumber="002262"
	    ;;
	270 )
	    surahAndAyahNumber="002263"
	    ;;
	271 )
	    surahAndAyahNumber="002264"
	    ;;
	272 )
	    surahAndAyahNumber="002265"
	    ;;
	273 )
	    surahAndAyahNumber="002266"
	    ;;
	274 )
	    surahAndAyahNumber="002267"
	    ;;
	275 )
	    surahAndAyahNumber="002268"
	    ;;
	276 )
	    surahAndAyahNumber="002269"
	    ;;
	277 )
	    surahAndAyahNumber="002270"
	    ;;
	278 )
	    surahAndAyahNumber="002271"
	    ;;
	279 )
	    surahAndAyahNumber="002272"
	    ;;
	280 )
	    surahAndAyahNumber="002273"
	    ;;
	281 )
	    surahAndAyahNumber="002274"
	    ;;
	282 )
	    surahAndAyahNumber="002275"
	    ;;
	283 )
	    surahAndAyahNumber="002276"
	    ;;
	284 )
	    surahAndAyahNumber="002277"
	    ;;
	285 )
	    surahAndAyahNumber="002278"
	    ;;
	286 )
	    surahAndAyahNumber="002279"
	    ;;
	287 )
	    surahAndAyahNumber="002280"
	    ;;
	288 )
	    surahAndAyahNumber="002281"
	    ;;
	289 )
	    surahAndAyahNumber="002282"
	    ;;
	290 )
	    surahAndAyahNumber="002283"
	    ;;
	291 )
	    surahAndAyahNumber="002284"
	    ;;
	292 )
	    surahAndAyahNumber="002285"
	    ;;
	293 )
	    surahAndAyahNumber="002286"
	    ;;
	294 )
	    surahAndAyahNumber="003001"
	    ;;
	295 )
	    surahAndAyahNumber="003002"
	    ;;
	296 )
	    surahAndAyahNumber="003003"
	    ;;
	297 )
	    surahAndAyahNumber="003004"
	    ;;
	298 )
	    surahAndAyahNumber="003005"
	    ;;
	299 )
	    surahAndAyahNumber="003006"
	    ;;
	300 )
	    surahAndAyahNumber="003007"
	    ;;
	301 )
	    surahAndAyahNumber="003008"
	    ;;
	302 )
	    surahAndAyahNumber="003009"
	    ;;
	303 )
	    surahAndAyahNumber="003010"
	    ;;
	304 )
	    surahAndAyahNumber="003011"
	    ;;
	305 )
	    surahAndAyahNumber="003012"
	    ;;
	306 )
	    surahAndAyahNumber="003013"
	    ;;
	307 )
	    surahAndAyahNumber="003014"
	    ;;
	308 )
	    surahAndAyahNumber="003015"
	    ;;
	309 )
	    surahAndAyahNumber="003016"
	    ;;
	310 )
	    surahAndAyahNumber="003017"
	    ;;
	311 )
	    surahAndAyahNumber="003018"
	    ;;
	312 )
	    surahAndAyahNumber="003019"
	    ;;
	313 )
	    surahAndAyahNumber="003020"
	    ;;
	314 )
	    surahAndAyahNumber="003021"
	    ;;
	315 )
	    surahAndAyahNumber="003022"
	    ;;
	316 )
	    surahAndAyahNumber="003023"
	    ;;
	317 )
	    surahAndAyahNumber="003024"
	    ;;
	318 )
	    surahAndAyahNumber="003025"
	    ;;
	319 )
	    surahAndAyahNumber="003026"
	    ;;
	320 )
	    surahAndAyahNumber="003027"
	    ;;
	321 )
	    surahAndAyahNumber="003028"
	    ;;
	322 )
	    surahAndAyahNumber="003029"
	    ;;
	323 )
	    surahAndAyahNumber="003030"
	    ;;
	324 )
	    surahAndAyahNumber="003031"
	    ;;
	325 )
	    surahAndAyahNumber="003032"
	    ;;
	326 )
	    surahAndAyahNumber="003033"
	    ;;
	327 )
	    surahAndAyahNumber="003034"
	    ;;
	328 )
	    surahAndAyahNumber="003035"
	    ;;
	329 )
	    surahAndAyahNumber="003036"
	    ;;
	330 )
	    surahAndAyahNumber="003037"
	    ;;
	331 )
	    surahAndAyahNumber="003038"
	    ;;
	332 )
	    surahAndAyahNumber="003039"
	    ;;
	333 )
	    surahAndAyahNumber="003040"
	    ;;
	334 )
	    surahAndAyahNumber="003041"
	    ;;
	335 )
	    surahAndAyahNumber="003042"
	    ;;
	336 )
	    surahAndAyahNumber="003043"
	    ;;
	337 )
	    surahAndAyahNumber="003044"
	    ;;
	338 )
	    surahAndAyahNumber="003045"
	    ;;
	339 )
	    surahAndAyahNumber="003046"
	    ;;
	340 )
	    surahAndAyahNumber="003047"
	    ;;
	341 )
	    surahAndAyahNumber="003048"
	    ;;
	342 )
	    surahAndAyahNumber="003049"
	    ;;
	343 )
	    surahAndAyahNumber="003050"
	    ;;
	344 )
	    surahAndAyahNumber="003051"
	    ;;
	345 )
	    surahAndAyahNumber="003052"
	    ;;
	346 )
	    surahAndAyahNumber="003053"
	    ;;
	347 )
	    surahAndAyahNumber="003054"
	    ;;
	348 )
	    surahAndAyahNumber="003055"
	    ;;
	349 )
	    surahAndAyahNumber="003056"
	    ;;
	350 )
	    surahAndAyahNumber="003057"
	    ;;
	351 )
	    surahAndAyahNumber="003058"
	    ;;
	352 )
	    surahAndAyahNumber="003059"
	    ;;
	353 )
	    surahAndAyahNumber="003060"
	    ;;
	354 )
	    surahAndAyahNumber="003061"
	    ;;
	355 )
	    surahAndAyahNumber="003062"
	    ;;
	356 )
	    surahAndAyahNumber="003063"
	    ;;
	357 )
	    surahAndAyahNumber="003064"
	    ;;
	358 )
	    surahAndAyahNumber="003065"
	    ;;
	359 )
	    surahAndAyahNumber="003066"
	    ;;
	360 )
	    surahAndAyahNumber="003067"
	    ;;
	361 )
	    surahAndAyahNumber="003068"
	    ;;
	362 )
	    surahAndAyahNumber="003069"
	    ;;
	363 )
	    surahAndAyahNumber="003070"
	    ;;
	364 )
	    surahAndAyahNumber="003071"
	    ;;
	365 )
	    surahAndAyahNumber="003072"
	    ;;
	366 )
	    surahAndAyahNumber="003073"
	    ;;
	367 )
	    surahAndAyahNumber="003074"
	    ;;
	368 )
	    surahAndAyahNumber="003075"
	    ;;
	369 )
	    surahAndAyahNumber="003076"
	    ;;
	370 )
	    surahAndAyahNumber="003077"
	    ;;
	371 )
	    surahAndAyahNumber="003078"
	    ;;
	372 )
	    surahAndAyahNumber="003079"
	    ;;
	373 )
	    surahAndAyahNumber="003080"
	    ;;
	374 )
	    surahAndAyahNumber="003081"
	    ;;
	375 )
	    surahAndAyahNumber="003082"
	    ;;
	376 )
	    surahAndAyahNumber="003083"
	    ;;
	377 )
	    surahAndAyahNumber="003084"
	    ;;
	378 )
	    surahAndAyahNumber="003085"
	    ;;
	379 )
	    surahAndAyahNumber="003086"
	    ;;
	380 )
	    surahAndAyahNumber="003087"
	    ;;
	381 )
	    surahAndAyahNumber="003088"
	    ;;
	382 )
	    surahAndAyahNumber="003089"
	    ;;
	383 )
	    surahAndAyahNumber="003090"
	    ;;
	384 )
	    surahAndAyahNumber="003091"
	    ;;
	385 )
	    surahAndAyahNumber="003092"
	    ;;
	386 )
	    surahAndAyahNumber="003093"
	    ;;
	387 )
	    surahAndAyahNumber="003094"
	    ;;
	388 )
	    surahAndAyahNumber="003095"
	    ;;
	389 )
	    surahAndAyahNumber="003096"
	    ;;
	390 )
	    surahAndAyahNumber="003097"
	    ;;
	391 )
	    surahAndAyahNumber="003098"
	    ;;
	392 )
	    surahAndAyahNumber="003099"
	    ;;
	393 )
	    surahAndAyahNumber="003100"
	    ;;
	394 )
	    surahAndAyahNumber="003101"
	    ;;
	395 )
	    surahAndAyahNumber="003102"
	    ;;
	396 )
	    surahAndAyahNumber="003103"
	    ;;
	397 )
	    surahAndAyahNumber="003104"
	    ;;
	398 )
	    surahAndAyahNumber="003105"
	    ;;
	399 )
	    surahAndAyahNumber="003106"
	    ;;
	400 )
	    surahAndAyahNumber="003107"
	    ;;
	401 )
	    surahAndAyahNumber="003108"
	    ;;
	402 )
	    surahAndAyahNumber="003109"
	    ;;
	403 )
	    surahAndAyahNumber="003110"
	    ;;
	404 )
	    surahAndAyahNumber="003111"
	    ;;
	405 )
	    surahAndAyahNumber="003112"
	    ;;
	406 )
	    surahAndAyahNumber="003113"
	    ;;
	407 )
	    surahAndAyahNumber="003114"
	    ;;
	408 )
	    surahAndAyahNumber="003115"
	    ;;
	409 )
	    surahAndAyahNumber="003116"
	    ;;
	410 )
	    surahAndAyahNumber="003117"
	    ;;
	411 )
	    surahAndAyahNumber="003118"
	    ;;
	412 )
	    surahAndAyahNumber="003119"
	    ;;
	413 )
	    surahAndAyahNumber="003120"
	    ;;
	414 )
	    surahAndAyahNumber="003121"
	    ;;
	415 )
	    surahAndAyahNumber="003122"
	    ;;
	416 )
	    surahAndAyahNumber="003123"
	    ;;
	417 )
	    surahAndAyahNumber="003124"
	    ;;
	418 )
	    surahAndAyahNumber="003125"
	    ;;
	419 )
	    surahAndAyahNumber="003126"
	    ;;
	420 )
	    surahAndAyahNumber="003127"
	    ;;
	421 )
	    surahAndAyahNumber="003128"
	    ;;
	422 )
	    surahAndAyahNumber="003129"
	    ;;
	423 )
	    surahAndAyahNumber="003130"
	    ;;
	424 )
	    surahAndAyahNumber="003131"
	    ;;
	425 )
	    surahAndAyahNumber="003132"
	    ;;
	426 )
	    surahAndAyahNumber="003133"
	    ;;
	427 )
	    surahAndAyahNumber="003134"
	    ;;
	428 )
	    surahAndAyahNumber="003135"
	    ;;
	429 )
	    surahAndAyahNumber="003136"
	    ;;
	430 )
	    surahAndAyahNumber="003137"
	    ;;
	431 )
	    surahAndAyahNumber="003138"
	    ;;
	432 )
	    surahAndAyahNumber="003139"
	    ;;
	433 )
	    surahAndAyahNumber="003140"
	    ;;
	434 )
	    surahAndAyahNumber="003141"
	    ;;
	435 )
	    surahAndAyahNumber="003142"
	    ;;
	436 )
	    surahAndAyahNumber="003143"
	    ;;
	437 )
	    surahAndAyahNumber="003144"
	    ;;
	438 )
	    surahAndAyahNumber="003145"
	    ;;
	439 )
	    surahAndAyahNumber="003146"
	    ;;
	440 )
	    surahAndAyahNumber="003147"
	    ;;
	441 )
	    surahAndAyahNumber="003148"
	    ;;
	442 )
	    surahAndAyahNumber="003149"
	    ;;
	443 )
	    surahAndAyahNumber="003150"
	    ;;
	444 )
	    surahAndAyahNumber="003151"
	    ;;
	445 )
	    surahAndAyahNumber="003152"
	    ;;
	446 )
	    surahAndAyahNumber="003153"
	    ;;
	447 )
	    surahAndAyahNumber="003154"
	    ;;
	448 )
	    surahAndAyahNumber="003155"
	    ;;
	449 )
	    surahAndAyahNumber="003156"
	    ;;
	450 )
	    surahAndAyahNumber="003157"
	    ;;
	451 )
	    surahAndAyahNumber="003158"
	    ;;
	452 )
	    surahAndAyahNumber="003159"
	    ;;
	453 )
	    surahAndAyahNumber="003160"
	    ;;
	454 )
	    surahAndAyahNumber="003161"
	    ;;
	455 )
	    surahAndAyahNumber="003162"
	    ;;
	456 )
	    surahAndAyahNumber="003163"
	    ;;
	457 )
	    surahAndAyahNumber="003164"
	    ;;
	458 )
	    surahAndAyahNumber="003165"
	    ;;
	459 )
	    surahAndAyahNumber="003166"
	    ;;
	460 )
	    surahAndAyahNumber="003167"
	    ;;
	461 )
	    surahAndAyahNumber="003168"
	    ;;
	462 )
	    surahAndAyahNumber="003169"
	    ;;
	463 )
	    surahAndAyahNumber="003170"
	    ;;
	464 )
	    surahAndAyahNumber="003171"
	    ;;
	465 )
	    surahAndAyahNumber="003172"
	    ;;
	466 )
	    surahAndAyahNumber="003173"
	    ;;
	467 )
	    surahAndAyahNumber="003174"
	    ;;
	468 )
	    surahAndAyahNumber="003175"
	    ;;
	469 )
	    surahAndAyahNumber="003176"
	    ;;
	470 )
	    surahAndAyahNumber="003177"
	    ;;
	471 )
	    surahAndAyahNumber="003178"
	    ;;
	472 )
	    surahAndAyahNumber="003179"
	    ;;
	473 )
	    surahAndAyahNumber="003180"
	    ;;
	474 )
	    surahAndAyahNumber="003181"
	    ;;
	475 )
	    surahAndAyahNumber="003182"
	    ;;
	476 )
	    surahAndAyahNumber="003183"
	    ;;
	477 )
	    surahAndAyahNumber="003184"
	    ;;
	478 )
	    surahAndAyahNumber="003185"
	    ;;
	479 )
	    surahAndAyahNumber="003186"
	    ;;
	480 )
	    surahAndAyahNumber="003187"
	    ;;
	481 )
	    surahAndAyahNumber="003188"
	    ;;
	482 )
	    surahAndAyahNumber="003189"
	    ;;
	483 )
	    surahAndAyahNumber="003190"
	    ;;
	484 )
	    surahAndAyahNumber="003191"
	    ;;
	485 )
	    surahAndAyahNumber="003192"
	    ;;
	486 )
	    surahAndAyahNumber="003193"
	    ;;
	487 )
	    surahAndAyahNumber="003194"
	    ;;
	488 )
	    surahAndAyahNumber="003195"
	    ;;
	489 )
	    surahAndAyahNumber="003196"
	    ;;
	490 )
	    surahAndAyahNumber="003197"
	    ;;
	491 )
	    surahAndAyahNumber="003198"
	    ;;
	492 )
	    surahAndAyahNumber="003199"
	    ;;
	493 )
	    surahAndAyahNumber="003200"
	    ;;
	494 )
	    surahAndAyahNumber="004001"
	    ;;
	495 )
	    surahAndAyahNumber="004002"
	    ;;
	496 )
	    surahAndAyahNumber="004003"
	    ;;
	497 )
	    surahAndAyahNumber="004004"
	    ;;
	498 )
	    surahAndAyahNumber="004005"
	    ;;
	499 )
	    surahAndAyahNumber="004006"
	    ;;
	500 )
	    surahAndAyahNumber="004007"
	    ;;
	501 )
	    surahAndAyahNumber="004008"
	    ;;
	502 )
	    surahAndAyahNumber="004009"
	    ;;
	503 )
	    surahAndAyahNumber="004010"
	    ;;
	504 )
	    surahAndAyahNumber="004011"
	    ;;
	505 )
	    surahAndAyahNumber="004012"
	    ;;
	506 )
	    surahAndAyahNumber="004013"
	    ;;
	507 )
	    surahAndAyahNumber="004014"
	    ;;
	508 )
	    surahAndAyahNumber="004015"
	    ;;
	509 )
	    surahAndAyahNumber="004016"
	    ;;
	510 )
	    surahAndAyahNumber="004017"
	    ;;
	511 )
	    surahAndAyahNumber="004018"
	    ;;
	512 )
	    surahAndAyahNumber="004019"
	    ;;
	513 )
	    surahAndAyahNumber="004020"
	    ;;
	514 )
	    surahAndAyahNumber="004021"
	    ;;
	515 )
	    surahAndAyahNumber="004022"
	    ;;
	516 )
	    surahAndAyahNumber="004023"
	    ;;
	517 )
	    surahAndAyahNumber="004024"
	    ;;
	518 )
	    surahAndAyahNumber="004025"
	    ;;
	519 )
	    surahAndAyahNumber="004026"
	    ;;
	520 )
	    surahAndAyahNumber="004027"
	    ;;
	521 )
	    surahAndAyahNumber="004028"
	    ;;
	522 )
	    surahAndAyahNumber="004029"
	    ;;
	523 )
	    surahAndAyahNumber="004030"
	    ;;
	524 )
	    surahAndAyahNumber="004031"
	    ;;
	525 )
	    surahAndAyahNumber="004032"
	    ;;
	526 )
	    surahAndAyahNumber="004033"
	    ;;
	527 )
	    surahAndAyahNumber="004034"
	    ;;
	528 )
	    surahAndAyahNumber="004035"
	    ;;
	529 )
	    surahAndAyahNumber="004036"
	    ;;
	530 )
	    surahAndAyahNumber="004037"
	    ;;
	531 )
	    surahAndAyahNumber="004038"
	    ;;
	532 )
	    surahAndAyahNumber="004039"
	    ;;
	533 )
	    surahAndAyahNumber="004040"
	    ;;
	534 )
	    surahAndAyahNumber="004041"
	    ;;
	535 )
	    surahAndAyahNumber="004042"
	    ;;
	536 )
	    surahAndAyahNumber="004043"
	    ;;
	537 )
	    surahAndAyahNumber="004044"
	    ;;
	538 )
	    surahAndAyahNumber="004045"
	    ;;
	539 )
	    surahAndAyahNumber="004046"
	    ;;
	540 )
	    surahAndAyahNumber="004047"
	    ;;
	541 )
	    surahAndAyahNumber="004048"
	    ;;
	542 )
	    surahAndAyahNumber="004049"
	    ;;
	543 )
	    surahAndAyahNumber="004050"
	    ;;
	544 )
	    surahAndAyahNumber="004051"
	    ;;
	545 )
	    surahAndAyahNumber="004052"
	    ;;
	546 )
	    surahAndAyahNumber="004053"
	    ;;
	547 )
	    surahAndAyahNumber="004054"
	    ;;
	548 )
	    surahAndAyahNumber="004055"
	    ;;
	549 )
	    surahAndAyahNumber="004056"
	    ;;
	550 )
	    surahAndAyahNumber="004057"
	    ;;
	551 )
	    surahAndAyahNumber="004058"
	    ;;
	552 )
	    surahAndAyahNumber="004059"
	    ;;
	553 )
	    surahAndAyahNumber="004060"
	    ;;
	554 )
	    surahAndAyahNumber="004061"
	    ;;
	555 )
	    surahAndAyahNumber="004062"
	    ;;
	556 )
	    surahAndAyahNumber="004063"
	    ;;
	557 )
	    surahAndAyahNumber="004064"
	    ;;
	558 )
	    surahAndAyahNumber="004065"
	    ;;
	559 )
	    surahAndAyahNumber="004066"
	    ;;
	560 )
	    surahAndAyahNumber="004067"
	    ;;
	561 )
	    surahAndAyahNumber="004068"
	    ;;
	562 )
	    surahAndAyahNumber="004069"
	    ;;
	563 )
	    surahAndAyahNumber="004070"
	    ;;
	564 )
	    surahAndAyahNumber="004071"
	    ;;
	565 )
	    surahAndAyahNumber="004072"
	    ;;
	566 )
	    surahAndAyahNumber="004073"
	    ;;
	567 )
	    surahAndAyahNumber="004074"
	    ;;
	568 )
	    surahAndAyahNumber="004075"
	    ;;
	569 )
	    surahAndAyahNumber="004076"
	    ;;
	570 )
	    surahAndAyahNumber="004077"
	    ;;
	571 )
	    surahAndAyahNumber="004078"
	    ;;
	572 )
	    surahAndAyahNumber="004079"
	    ;;
	573 )
	    surahAndAyahNumber="004080"
	    ;;
	574 )
	    surahAndAyahNumber="004081"
	    ;;
	575 )
	    surahAndAyahNumber="004082"
	    ;;
	576 )
	    surahAndAyahNumber="004083"
	    ;;
	577 )
	    surahAndAyahNumber="004084"
	    ;;
	578 )
	    surahAndAyahNumber="004085"
	    ;;
	579 )
	    surahAndAyahNumber="004086"
	    ;;
	580 )
	    surahAndAyahNumber="004087"
	    ;;
	581 )
	    surahAndAyahNumber="004088"
	    ;;
	582 )
	    surahAndAyahNumber="004089"
	    ;;
	583 )
	    surahAndAyahNumber="004090"
	    ;;
	584 )
	    surahAndAyahNumber="004091"
	    ;;
	585 )
	    surahAndAyahNumber="004092"
	    ;;
	586 )
	    surahAndAyahNumber="004093"
	    ;;
	587 )
	    surahAndAyahNumber="004094"
	    ;;
	588 )
	    surahAndAyahNumber="004095"
	    ;;
	589 )
	    surahAndAyahNumber="004096"
	    ;;
	590 )
	    surahAndAyahNumber="004097"
	    ;;
	591 )
	    surahAndAyahNumber="004098"
	    ;;
	592 )
	    surahAndAyahNumber="004099"
	    ;;
	593 )
	    surahAndAyahNumber="004100"
	    ;;
	594 )
	    surahAndAyahNumber="004101"
	    ;;
	595 )
	    surahAndAyahNumber="004102"
	    ;;
	596 )
	    surahAndAyahNumber="004103"
	    ;;
	597 )
	    surahAndAyahNumber="004104"
	    ;;
	598 )
	    surahAndAyahNumber="004105"
	    ;;
	599 )
	    surahAndAyahNumber="004106"
	    ;;
	600 )
	    surahAndAyahNumber="004107"
	    ;;
	601 )
	    surahAndAyahNumber="004108"
	    ;;
	602 )
	    surahAndAyahNumber="004109"
	    ;;
	603 )
	    surahAndAyahNumber="004110"
	    ;;
	604 )
	    surahAndAyahNumber="004111"
	    ;;
	605 )
	    surahAndAyahNumber="004112"
	    ;;
	606 )
	    surahAndAyahNumber="004113"
	    ;;
	607 )
	    surahAndAyahNumber="004114"
	    ;;
	608 )
	    surahAndAyahNumber="004115"
	    ;;
	609 )
	    surahAndAyahNumber="004116"
	    ;;
	610 )
	    surahAndAyahNumber="004117"
	    ;;
	611 )
	    surahAndAyahNumber="004118"
	    ;;
	612 )
	    surahAndAyahNumber="004119"
	    ;;
	613 )
	    surahAndAyahNumber="004120"
	    ;;
	614 )
	    surahAndAyahNumber="004121"
	    ;;
	615 )
	    surahAndAyahNumber="004122"
	    ;;
	616 )
	    surahAndAyahNumber="004123"
	    ;;
	617 )
	    surahAndAyahNumber="004124"
	    ;;
	618 )
	    surahAndAyahNumber="004125"
	    ;;
	619 )
	    surahAndAyahNumber="004126"
	    ;;
	620 )
	    surahAndAyahNumber="004127"
	    ;;
	621 )
	    surahAndAyahNumber="004128"
	    ;;
	622 )
	    surahAndAyahNumber="004129"
	    ;;
	623 )
	    surahAndAyahNumber="004130"
	    ;;
	624 )
	    surahAndAyahNumber="004131"
	    ;;
	625 )
	    surahAndAyahNumber="004132"
	    ;;
	626 )
	    surahAndAyahNumber="004133"
	    ;;
	627 )
	    surahAndAyahNumber="004134"
	    ;;
	628 )
	    surahAndAyahNumber="004135"
	    ;;
	629 )
	    surahAndAyahNumber="004136"
	    ;;
	630 )
	    surahAndAyahNumber="004137"
	    ;;
	631 )
	    surahAndAyahNumber="004138"
	    ;;
	632 )
	    surahAndAyahNumber="004139"
	    ;;
	633 )
	    surahAndAyahNumber="004140"
	    ;;
	634 )
	    surahAndAyahNumber="004141"
	    ;;
	635 )
	    surahAndAyahNumber="004142"
	    ;;
	636 )
	    surahAndAyahNumber="004143"
	    ;;
	637 )
	    surahAndAyahNumber="004144"
	    ;;
	638 )
	    surahAndAyahNumber="004145"
	    ;;
	639 )
	    surahAndAyahNumber="004146"
	    ;;
	640 )
	    surahAndAyahNumber="004147"
	    ;;
	641 )
	    surahAndAyahNumber="004148"
	    ;;
	642 )
	    surahAndAyahNumber="004149"
	    ;;
	643 )
	    surahAndAyahNumber="004150"
	    ;;
	644 )
	    surahAndAyahNumber="004151"
	    ;;
	645 )
	    surahAndAyahNumber="004152"
	    ;;
	646 )
	    surahAndAyahNumber="004153"
	    ;;
	647 )
	    surahAndAyahNumber="004154"
	    ;;
	648 )
	    surahAndAyahNumber="004155"
	    ;;
	649 )
	    surahAndAyahNumber="004156"
	    ;;
	650 )
	    surahAndAyahNumber="004157"
	    ;;
	651 )
	    surahAndAyahNumber="004158"
	    ;;
	652 )
	    surahAndAyahNumber="004159"
	    ;;
	653 )
	    surahAndAyahNumber="004160"
	    ;;
	654 )
	    surahAndAyahNumber="004161"
	    ;;
	655 )
	    surahAndAyahNumber="004162"
	    ;;
	656 )
	    surahAndAyahNumber="004163"
	    ;;
	657 )
	    surahAndAyahNumber="004164"
	    ;;
	658 )
	    surahAndAyahNumber="004165"
	    ;;
	659 )
	    surahAndAyahNumber="004166"
	    ;;
	660 )
	    surahAndAyahNumber="004167"
	    ;;
	661 )
	    surahAndAyahNumber="004168"
	    ;;
	662 )
	    surahAndAyahNumber="004169"
	    ;;
	663 )
	    surahAndAyahNumber="004170"
	    ;;
	664 )
	    surahAndAyahNumber="004171"
	    ;;
	665 )
	    surahAndAyahNumber="004172"
	    ;;
	666 )
	    surahAndAyahNumber="004173"
	    ;;
	667 )
	    surahAndAyahNumber="004174"
	    ;;
	668 )
	    surahAndAyahNumber="004175"
	    ;;
	669 )
	    surahAndAyahNumber="004176"
	    ;;
	670 )
	    surahAndAyahNumber="005001"
	    ;;
	671 )
	    surahAndAyahNumber="005002"
	    ;;
	672 )
	    surahAndAyahNumber="005003"
	    ;;
	673 )
	    surahAndAyahNumber="005004"
	    ;;
	674 )
	    surahAndAyahNumber="005005"
	    ;;
	675 )
	    surahAndAyahNumber="005006"
	    ;;
	676 )
	    surahAndAyahNumber="005007"
	    ;;
	677 )
	    surahAndAyahNumber="005008"
	    ;;
	678 )
	    surahAndAyahNumber="005009"
	    ;;
	679 )
	    surahAndAyahNumber="005010"
	    ;;
	680 )
	    surahAndAyahNumber="005011"
	    ;;
	681 )
	    surahAndAyahNumber="005012"
	    ;;
	682 )
	    surahAndAyahNumber="005013"
	    ;;
	683 )
	    surahAndAyahNumber="005014"
	    ;;
	684 )
	    surahAndAyahNumber="005015"
	    ;;
	685 )
	    surahAndAyahNumber="005016"
	    ;;
	686 )
	    surahAndAyahNumber="005017"
	    ;;
	687 )
	    surahAndAyahNumber="005018"
	    ;;
	688 )
	    surahAndAyahNumber="005019"
	    ;;
	689 )
	    surahAndAyahNumber="005020"
	    ;;
	690 )
	    surahAndAyahNumber="005021"
	    ;;
	691 )
	    surahAndAyahNumber="005022"
	    ;;
	692 )
	    surahAndAyahNumber="005023"
	    ;;
	693 )
	    surahAndAyahNumber="005024"
	    ;;
	694 )
	    surahAndAyahNumber="005025"
	    ;;
	695 )
	    surahAndAyahNumber="005026"
	    ;;
	696 )
	    surahAndAyahNumber="005027"
	    ;;
	697 )
	    surahAndAyahNumber="005028"
	    ;;
	698 )
	    surahAndAyahNumber="005029"
	    ;;
	699 )
	    surahAndAyahNumber="005030"
	    ;;
	700 )
	    surahAndAyahNumber="005031"
	    ;;
	701 )
	    surahAndAyahNumber="005032"
	    ;;
	702 )
	    surahAndAyahNumber="005033"
	    ;;
	703 )
	    surahAndAyahNumber="005034"
	    ;;
	704 )
	    surahAndAyahNumber="005035"
	    ;;
	705 )
	    surahAndAyahNumber="005036"
	    ;;
	706 )
	    surahAndAyahNumber="005037"
	    ;;
	707 )
	    surahAndAyahNumber="005038"
	    ;;
	708 )
	    surahAndAyahNumber="005039"
	    ;;
	709 )
	    surahAndAyahNumber="005040"
	    ;;
	710 )
	    surahAndAyahNumber="005041"
	    ;;
	711 )
	    surahAndAyahNumber="005042"
	    ;;
	712 )
	    surahAndAyahNumber="005043"
	    ;;
	713 )
	    surahAndAyahNumber="005044"
	    ;;
	714 )
	    surahAndAyahNumber="005045"
	    ;;
	715 )
	    surahAndAyahNumber="005046"
	    ;;
	716 )
	    surahAndAyahNumber="005047"
	    ;;
	717 )
	    surahAndAyahNumber="005048"
	    ;;
	718 )
	    surahAndAyahNumber="005049"
	    ;;
	719 )
	    surahAndAyahNumber="005050"
	    ;;
	720 )
	    surahAndAyahNumber="005051"
	    ;;
	721 )
	    surahAndAyahNumber="005052"
	    ;;
	722 )
	    surahAndAyahNumber="005053"
	    ;;
	723 )
	    surahAndAyahNumber="005054"
	    ;;
	724 )
	    surahAndAyahNumber="005055"
	    ;;
	725 )
	    surahAndAyahNumber="005056"
	    ;;
	726 )
	    surahAndAyahNumber="005057"
	    ;;
	727 )
	    surahAndAyahNumber="005058"
	    ;;
	728 )
	    surahAndAyahNumber="005059"
	    ;;
	729 )
	    surahAndAyahNumber="005060"
	    ;;
	730 )
	    surahAndAyahNumber="005061"
	    ;;
	731 )
	    surahAndAyahNumber="005062"
	    ;;
	732 )
	    surahAndAyahNumber="005063"
	    ;;
	733 )
	    surahAndAyahNumber="005064"
	    ;;
	734 )
	    surahAndAyahNumber="005065"
	    ;;
	735 )
	    surahAndAyahNumber="005066"
	    ;;
	736 )
	    surahAndAyahNumber="005067"
	    ;;
	737 )
	    surahAndAyahNumber="005068"
	    ;;
	738 )
	    surahAndAyahNumber="005069"
	    ;;
	739 )
	    surahAndAyahNumber="005070"
	    ;;
	740 )
	    surahAndAyahNumber="005071"
	    ;;
	741 )
	    surahAndAyahNumber="005072"
	    ;;
	742 )
	    surahAndAyahNumber="005073"
	    ;;
	743 )
	    surahAndAyahNumber="005074"
	    ;;
	744 )
	    surahAndAyahNumber="005075"
	    ;;
	745 )
	    surahAndAyahNumber="005076"
	    ;;
	746 )
	    surahAndAyahNumber="005077"
	    ;;
	747 )
	    surahAndAyahNumber="005078"
	    ;;
	748 )
	    surahAndAyahNumber="005079"
	    ;;
	749 )
	    surahAndAyahNumber="005080"
	    ;;
	750 )
	    surahAndAyahNumber="005081"
	    ;;
	751 )
	    surahAndAyahNumber="005082"
	    ;;
	752 )
	    surahAndAyahNumber="005083"
	    ;;
	753 )
	    surahAndAyahNumber="005084"
	    ;;
	754 )
	    surahAndAyahNumber="005085"
	    ;;
	755 )
	    surahAndAyahNumber="005086"
	    ;;
	756 )
	    surahAndAyahNumber="005087"
	    ;;
	757 )
	    surahAndAyahNumber="005088"
	    ;;
	758 )
	    surahAndAyahNumber="005089"
	    ;;
	759 )
	    surahAndAyahNumber="005090"
	    ;;
	760 )
	    surahAndAyahNumber="005091"
	    ;;
	761 )
	    surahAndAyahNumber="005092"
	    ;;
	762 )
	    surahAndAyahNumber="005093"
	    ;;
	763 )
	    surahAndAyahNumber="005094"
	    ;;
	764 )
	    surahAndAyahNumber="005095"
	    ;;
	765 )
	    surahAndAyahNumber="005096"
	    ;;
	766 )
	    surahAndAyahNumber="005097"
	    ;;
	767 )
	    surahAndAyahNumber="005098"
	    ;;
	768 )
	    surahAndAyahNumber="005099"
	    ;;
	769 )
	    surahAndAyahNumber="005100"
	    ;;
	770 )
	    surahAndAyahNumber="005101"
	    ;;
	771 )
	    surahAndAyahNumber="005102"
	    ;;
	772 )
	    surahAndAyahNumber="005103"
	    ;;
	773 )
	    surahAndAyahNumber="005104"
	    ;;
	774 )
	    surahAndAyahNumber="005105"
	    ;;
	775 )
	    surahAndAyahNumber="005106"
	    ;;
	776 )
	    surahAndAyahNumber="005107"
	    ;;
	777 )
	    surahAndAyahNumber="005108"
	    ;;
	778 )
	    surahAndAyahNumber="005109"
	    ;;
	779 )
	    surahAndAyahNumber="005110"
	    ;;
	780 )
	    surahAndAyahNumber="005111"
	    ;;
	781 )
	    surahAndAyahNumber="005112"
	    ;;
	782 )
	    surahAndAyahNumber="005113"
	    ;;
	783 )
	    surahAndAyahNumber="005114"
	    ;;
	784 )
	    surahAndAyahNumber="005115"
	    ;;
	785 )
	    surahAndAyahNumber="005116"
	    ;;
	786 )
	    surahAndAyahNumber="005117"
	    ;;
	787 )
	    surahAndAyahNumber="005118"
	    ;;
	788 )
	    surahAndAyahNumber="005119"
	    ;;
	789 )
	    surahAndAyahNumber="005120"
	    ;;
	790 )
	    surahAndAyahNumber="006001"
	    ;;
	791 )
	    surahAndAyahNumber="006002"
	    ;;
	792 )
	    surahAndAyahNumber="006003"
	    ;;
	793 )
	    surahAndAyahNumber="006004"
	    ;;
	794 )
	    surahAndAyahNumber="006005"
	    ;;
	795 )
	    surahAndAyahNumber="006006"
	    ;;
	796 )
	    surahAndAyahNumber="006007"
	    ;;
	797 )
	    surahAndAyahNumber="006008"
	    ;;
	798 )
	    surahAndAyahNumber="006009"
	    ;;
	799 )
	    surahAndAyahNumber="006010"
	    ;;
	800 )
	    surahAndAyahNumber="006011"
	    ;;
	801 )
	    surahAndAyahNumber="006012"
	    ;;
	802 )
	    surahAndAyahNumber="006013"
	    ;;
	803 )
	    surahAndAyahNumber="006014"
	    ;;
	804 )
	    surahAndAyahNumber="006015"
	    ;;
	805 )
	    surahAndAyahNumber="006016"
	    ;;
	806 )
	    surahAndAyahNumber="006017"
	    ;;
	807 )
	    surahAndAyahNumber="006018"
	    ;;
	808 )
	    surahAndAyahNumber="006019"
	    ;;
	809 )
	    surahAndAyahNumber="006020"
	    ;;
	810 )
	    surahAndAyahNumber="006021"
	    ;;
	811 )
	    surahAndAyahNumber="006022"
	    ;;
	812 )
	    surahAndAyahNumber="006023"
	    ;;
	813 )
	    surahAndAyahNumber="006024"
	    ;;
	814 )
	    surahAndAyahNumber="006025"
	    ;;
	815 )
	    surahAndAyahNumber="006026"
	    ;;
	816 )
	    surahAndAyahNumber="006027"
	    ;;
	817 )
	    surahAndAyahNumber="006028"
	    ;;
	818 )
	    surahAndAyahNumber="006029"
	    ;;
	819 )
	    surahAndAyahNumber="006030"
	    ;;
	820 )
	    surahAndAyahNumber="006031"
	    ;;
	821 )
	    surahAndAyahNumber="006032"
	    ;;
	822 )
	    surahAndAyahNumber="006033"
	    ;;
	823 )
	    surahAndAyahNumber="006034"
	    ;;
	824 )
	    surahAndAyahNumber="006035"
	    ;;
	825 )
	    surahAndAyahNumber="006036"
	    ;;
	826 )
	    surahAndAyahNumber="006037"
	    ;;
	827 )
	    surahAndAyahNumber="006038"
	    ;;
	828 )
	    surahAndAyahNumber="006039"
	    ;;
	829 )
	    surahAndAyahNumber="006040"
	    ;;
	830 )
	    surahAndAyahNumber="006041"
	    ;;
	831 )
	    surahAndAyahNumber="006042"
	    ;;
	832 )
	    surahAndAyahNumber="006043"
	    ;;
	833 )
	    surahAndAyahNumber="006044"
	    ;;
	834 )
	    surahAndAyahNumber="006045"
	    ;;
	835 )
	    surahAndAyahNumber="006046"
	    ;;
	836 )
	    surahAndAyahNumber="006047"
	    ;;
	837 )
	    surahAndAyahNumber="006048"
	    ;;
	838 )
	    surahAndAyahNumber="006049"
	    ;;
	839 )
	    surahAndAyahNumber="006050"
	    ;;
	840 )
	    surahAndAyahNumber="006051"
	    ;;
	841 )
	    surahAndAyahNumber="006052"
	    ;;
	842 )
	    surahAndAyahNumber="006053"
	    ;;
	843 )
	    surahAndAyahNumber="006054"
	    ;;
	844 )
	    surahAndAyahNumber="006055"
	    ;;
	845 )
	    surahAndAyahNumber="006056"
	    ;;
	846 )
	    surahAndAyahNumber="006057"
	    ;;
	847 )
	    surahAndAyahNumber="006058"
	    ;;
	848 )
	    surahAndAyahNumber="006059"
	    ;;
	849 )
	    surahAndAyahNumber="006060"
	    ;;
	850 )
	    surahAndAyahNumber="006061"
	    ;;
	851 )
	    surahAndAyahNumber="006062"
	    ;;
	852 )
	    surahAndAyahNumber="006063"
	    ;;
	853 )
	    surahAndAyahNumber="006064"
	    ;;
	854 )
	    surahAndAyahNumber="006065"
	    ;;
	855 )
	    surahAndAyahNumber="006066"
	    ;;
	856 )
	    surahAndAyahNumber="006067"
	    ;;
	857 )
	    surahAndAyahNumber="006068"
	    ;;
	858 )
	    surahAndAyahNumber="006069"
	    ;;
	859 )
	    surahAndAyahNumber="006070"
	    ;;
	860 )
	    surahAndAyahNumber="006071"
	    ;;
	861 )
	    surahAndAyahNumber="006072"
	    ;;
	862 )
	    surahAndAyahNumber="006073"
	    ;;
	863 )
	    surahAndAyahNumber="006074"
	    ;;
	864 )
	    surahAndAyahNumber="006075"
	    ;;
	865 )
	    surahAndAyahNumber="006076"
	    ;;
	866 )
	    surahAndAyahNumber="006077"
	    ;;
	867 )
	    surahAndAyahNumber="006078"
	    ;;
	868 )
	    surahAndAyahNumber="006079"
	    ;;
	869 )
	    surahAndAyahNumber="006080"
	    ;;
	870 )
	    surahAndAyahNumber="006081"
	    ;;
	871 )
	    surahAndAyahNumber="006082"
	    ;;
	872 )
	    surahAndAyahNumber="006083"
	    ;;
	873 )
	    surahAndAyahNumber="006084"
	    ;;
	874 )
	    surahAndAyahNumber="006085"
	    ;;
	875 )
	    surahAndAyahNumber="006086"
	    ;;
	876 )
	    surahAndAyahNumber="006087"
	    ;;
	877 )
	    surahAndAyahNumber="006088"
	    ;;
	878 )
	    surahAndAyahNumber="006089"
	    ;;
	879 )
	    surahAndAyahNumber="006090"
	    ;;
	880 )
	    surahAndAyahNumber="006091"
	    ;;
	881 )
	    surahAndAyahNumber="006092"
	    ;;
	882 )
	    surahAndAyahNumber="006093"
	    ;;
	883 )
	    surahAndAyahNumber="006094"
	    ;;
	884 )
	    surahAndAyahNumber="006095"
	    ;;
	885 )
	    surahAndAyahNumber="006096"
	    ;;
	886 )
	    surahAndAyahNumber="006097"
	    ;;
	887 )
	    surahAndAyahNumber="006098"
	    ;;
	888 )
	    surahAndAyahNumber="006099"
	    ;;
	889 )
	    surahAndAyahNumber="006100"
	    ;;
	890 )
	    surahAndAyahNumber="006101"
	    ;;
	891 )
	    surahAndAyahNumber="006102"
	    ;;
	892 )
	    surahAndAyahNumber="006103"
	    ;;
	893 )
	    surahAndAyahNumber="006104"
	    ;;
	894 )
	    surahAndAyahNumber="006105"
	    ;;
	895 )
	    surahAndAyahNumber="006106"
	    ;;
	896 )
	    surahAndAyahNumber="006107"
	    ;;
	897 )
	    surahAndAyahNumber="006108"
	    ;;
	898 )
	    surahAndAyahNumber="006109"
	    ;;
	899 )
	    surahAndAyahNumber="006110"
	    ;;
	900 )
	    surahAndAyahNumber="006111"
	    ;;
	901 )
	    surahAndAyahNumber="006112"
	    ;;
	902 )
	    surahAndAyahNumber="006113"
	    ;;
	903 )
	    surahAndAyahNumber="006114"
	    ;;
	904 )
	    surahAndAyahNumber="006115"
	    ;;
	905 )
	    surahAndAyahNumber="006116"
	    ;;
	906 )
	    surahAndAyahNumber="006117"
	    ;;
	907 )
	    surahAndAyahNumber="006118"
	    ;;
	908 )
	    surahAndAyahNumber="006119"
	    ;;
	909 )
	    surahAndAyahNumber="006120"
	    ;;
	910 )
	    surahAndAyahNumber="006121"
	    ;;
	911 )
	    surahAndAyahNumber="006122"
	    ;;
	912 )
	    surahAndAyahNumber="006123"
	    ;;
	913 )
	    surahAndAyahNumber="006124"
	    ;;
	914 )
	    surahAndAyahNumber="006125"
	    ;;
	915 )
	    surahAndAyahNumber="006126"
	    ;;
	916 )
	    surahAndAyahNumber="006127"
	    ;;
	917 )
	    surahAndAyahNumber="006128"
	    ;;
	918 )
	    surahAndAyahNumber="006129"
	    ;;
	919 )
	    surahAndAyahNumber="006130"
	    ;;
	920 )
	    surahAndAyahNumber="006131"
	    ;;
	921 )
	    surahAndAyahNumber="006132"
	    ;;
	922 )
	    surahAndAyahNumber="006133"
	    ;;
	923 )
	    surahAndAyahNumber="006134"
	    ;;
	924 )
	    surahAndAyahNumber="006135"
	    ;;
	925 )
	    surahAndAyahNumber="006136"
	    ;;
	926 )
	    surahAndAyahNumber="006137"
	    ;;
	927 )
	    surahAndAyahNumber="006138"
	    ;;
	928 )
	    surahAndAyahNumber="006139"
	    ;;
	929 )
	    surahAndAyahNumber="006140"
	    ;;
	930 )
	    surahAndAyahNumber="006141"
	    ;;
	931 )
	    surahAndAyahNumber="006142"
	    ;;
	932 )
	    surahAndAyahNumber="006143"
	    ;;
	933 )
	    surahAndAyahNumber="006144"
	    ;;
	934 )
	    surahAndAyahNumber="006145"
	    ;;
	935 )
	    surahAndAyahNumber="006146"
	    ;;
	936 )
	    surahAndAyahNumber="006147"
	    ;;
	937 )
	    surahAndAyahNumber="006148"
	    ;;
	938 )
	    surahAndAyahNumber="006149"
	    ;;
	939 )
	    surahAndAyahNumber="006150"
	    ;;
	940 )
	    surahAndAyahNumber="006151"
	    ;;
	941 )
	    surahAndAyahNumber="006152"
	    ;;
	942 )
	    surahAndAyahNumber="006153"
	    ;;
	943 )
	    surahAndAyahNumber="006154"
	    ;;
	944 )
	    surahAndAyahNumber="006155"
	    ;;
	945 )
	    surahAndAyahNumber="006156"
	    ;;
	946 )
	    surahAndAyahNumber="006157"
	    ;;
	947 )
	    surahAndAyahNumber="006158"
	    ;;
	948 )
	    surahAndAyahNumber="006159"
	    ;;
	949 )
	    surahAndAyahNumber="006160"
	    ;;
	950 )
	    surahAndAyahNumber="006161"
	    ;;
	951 )
	    surahAndAyahNumber="006162"
	    ;;
	952 )
	    surahAndAyahNumber="006163"
	    ;;
	953 )
	    surahAndAyahNumber="006164"
	    ;;
	954 )
	    surahAndAyahNumber="006165"
	    ;;
	955 )
	    surahAndAyahNumber="007001"
	    ;;
	956 )
	    surahAndAyahNumber="007002"
	    ;;
	957 )
	    surahAndAyahNumber="007003"
	    ;;
	958 )
	    surahAndAyahNumber="007004"
	    ;;
	959 )
	    surahAndAyahNumber="007005"
	    ;;
	960 )
	    surahAndAyahNumber="007006"
	    ;;
	961 )
	    surahAndAyahNumber="007007"
	    ;;
	962 )
	    surahAndAyahNumber="007008"
	    ;;
	963 )
	    surahAndAyahNumber="007009"
	    ;;
	964 )
	    surahAndAyahNumber="007010"
	    ;;
	965 )
	    surahAndAyahNumber="007011"
	    ;;
	966 )
	    surahAndAyahNumber="007012"
	    ;;
	967 )
	    surahAndAyahNumber="007013"
	    ;;
	968 )
	    surahAndAyahNumber="007014"
	    ;;
	969 )
	    surahAndAyahNumber="007015"
	    ;;
	970 )
	    surahAndAyahNumber="007016"
	    ;;
	971 )
	    surahAndAyahNumber="007017"
	    ;;
	972 )
	    surahAndAyahNumber="007018"
	    ;;
	973 )
	    surahAndAyahNumber="007019"
	    ;;
	974 )
	    surahAndAyahNumber="007020"
	    ;;
	975 )
	    surahAndAyahNumber="007021"
	    ;;
	976 )
	    surahAndAyahNumber="007022"
	    ;;
	977 )
	    surahAndAyahNumber="007023"
	    ;;
	978 )
	    surahAndAyahNumber="007024"
	    ;;
	979 )
	    surahAndAyahNumber="007025"
	    ;;
	980 )
	    surahAndAyahNumber="007026"
	    ;;
	981 )
	    surahAndAyahNumber="007027"
	    ;;
	982 )
	    surahAndAyahNumber="007028"
	    ;;
	983 )
	    surahAndAyahNumber="007029"
	    ;;
	984 )
	    surahAndAyahNumber="007030"
	    ;;
	985 )
	    surahAndAyahNumber="007031"
	    ;;
	986 )
	    surahAndAyahNumber="007032"
	    ;;
	987 )
	    surahAndAyahNumber="007033"
	    ;;
	988 )
	    surahAndAyahNumber="007034"
	    ;;
	989 )
	    surahAndAyahNumber="007035"
	    ;;
	990 )
	    surahAndAyahNumber="007036"
	    ;;
	991 )
	    surahAndAyahNumber="007037"
	    ;;
	992 )
	    surahAndAyahNumber="007038"
	    ;;
	993 )
	    surahAndAyahNumber="007039"
	    ;;
	994 )
	    surahAndAyahNumber="007040"
	    ;;
	995 )
	    surahAndAyahNumber="007041"
	    ;;
	996 )
	    surahAndAyahNumber="007042"
	    ;;
	997 )
	    surahAndAyahNumber="007043"
	    ;;
	998 )
	    surahAndAyahNumber="007044"
	    ;;
	999 )
	    surahAndAyahNumber="007045"
	    ;;
	1000 )
	    surahAndAyahNumber="007046"
	    ;;
	1001 )
	    surahAndAyahNumber="007047"
	    ;;
	1002 )
	    surahAndAyahNumber="007048"
	    ;;
	1003 )
	    surahAndAyahNumber="007049"
	    ;;
	1004 )
	    surahAndAyahNumber="007050"
	    ;;
	1005 )
	    surahAndAyahNumber="007051"
	    ;;
	1006 )
	    surahAndAyahNumber="007052"
	    ;;
	1007 )
	    surahAndAyahNumber="007053"
	    ;;
	1008 )
	    surahAndAyahNumber="007054"
	    ;;
	1009 )
	    surahAndAyahNumber="007055"
	    ;;
	1010 )
	    surahAndAyahNumber="007056"
	    ;;
	1011 )
	    surahAndAyahNumber="007057"
	    ;;
	1012 )
	    surahAndAyahNumber="007058"
	    ;;
	1013 )
	    surahAndAyahNumber="007059"
	    ;;
	1014 )
	    surahAndAyahNumber="007060"
	    ;;
	1015 )
	    surahAndAyahNumber="007061"
	    ;;
	1016 )
	    surahAndAyahNumber="007062"
	    ;;
	1017 )
	    surahAndAyahNumber="007063"
	    ;;
	1018 )
	    surahAndAyahNumber="007064"
	    ;;
	1019 )
	    surahAndAyahNumber="007065"
	    ;;
	1020 )
	    surahAndAyahNumber="007066"
	    ;;
	1021 )
	    surahAndAyahNumber="007067"
	    ;;
	1022 )
	    surahAndAyahNumber="007068"
	    ;;
	1023 )
	    surahAndAyahNumber="007069"
	    ;;
	1024 )
	    surahAndAyahNumber="007070"
	    ;;
	1025 )
	    surahAndAyahNumber="007071"
	    ;;
	1026 )
	    surahAndAyahNumber="007072"
	    ;;
	1027 )
	    surahAndAyahNumber="007073"
	    ;;
	1028 )
	    surahAndAyahNumber="007074"
	    ;;
	1029 )
	    surahAndAyahNumber="007075"
	    ;;
	1030 )
	    surahAndAyahNumber="007076"
	    ;;
	1031 )
	    surahAndAyahNumber="007077"
	    ;;
	1032 )
	    surahAndAyahNumber="007078"
	    ;;
	1033 )
	    surahAndAyahNumber="007079"
	    ;;
	1034 )
	    surahAndAyahNumber="007080"
	    ;;
	1035 )
	    surahAndAyahNumber="007081"
	    ;;
	1036 )
	    surahAndAyahNumber="007082"
	    ;;
	1037 )
	    surahAndAyahNumber="007083"
	    ;;
	1038 )
	    surahAndAyahNumber="007084"
	    ;;
	1039 )
	    surahAndAyahNumber="007085"
	    ;;
	1040 )
	    surahAndAyahNumber="007086"
	    ;;
	1041 )
	    surahAndAyahNumber="007087"
	    ;;
	1042 )
	    surahAndAyahNumber="007088"
	    ;;
	1043 )
	    surahAndAyahNumber="007089"
	    ;;
	1044 )
	    surahAndAyahNumber="007090"
	    ;;
	1045 )
	    surahAndAyahNumber="007091"
	    ;;
	1046 )
	    surahAndAyahNumber="007092"
	    ;;
	1047 )
	    surahAndAyahNumber="007093"
	    ;;
	1048 )
	    surahAndAyahNumber="007094"
	    ;;
	1049 )
	    surahAndAyahNumber="007095"
	    ;;
	1050 )
	    surahAndAyahNumber="007096"
	    ;;
	1051 )
	    surahAndAyahNumber="007097"
	    ;;
	1052 )
	    surahAndAyahNumber="007098"
	    ;;
	1053 )
	    surahAndAyahNumber="007099"
	    ;;
	1054 )
	    surahAndAyahNumber="007100"
	    ;;
	1055 )
	    surahAndAyahNumber="007101"
	    ;;
	1056 )
	    surahAndAyahNumber="007102"
	    ;;
	1057 )
	    surahAndAyahNumber="007103"
	    ;;
	1058 )
	    surahAndAyahNumber="007104"
	    ;;
	1059 )
	    surahAndAyahNumber="007105"
	    ;;
	1060 )
	    surahAndAyahNumber="007106"
	    ;;
	1061 )
	    surahAndAyahNumber="007107"
	    ;;
	1062 )
	    surahAndAyahNumber="007108"
	    ;;
	1063 )
	    surahAndAyahNumber="007109"
	    ;;
	1064 )
	    surahAndAyahNumber="007110"
	    ;;
	1065 )
	    surahAndAyahNumber="007111"
	    ;;
	1066 )
	    surahAndAyahNumber="007112"
	    ;;
	1067 )
	    surahAndAyahNumber="007113"
	    ;;
	1068 )
	    surahAndAyahNumber="007114"
	    ;;
	1069 )
	    surahAndAyahNumber="007115"
	    ;;
	1070 )
	    surahAndAyahNumber="007116"
	    ;;
	1071 )
	    surahAndAyahNumber="007117"
	    ;;
	1072 )
	    surahAndAyahNumber="007118"
	    ;;
	1073 )
	    surahAndAyahNumber="007119"
	    ;;
	1074 )
	    surahAndAyahNumber="007120"
	    ;;
	1075 )
	    surahAndAyahNumber="007121"
	    ;;
	1076 )
	    surahAndAyahNumber="007122"
	    ;;
	1077 )
	    surahAndAyahNumber="007123"
	    ;;
	1078 )
	    surahAndAyahNumber="007124"
	    ;;
	1079 )
	    surahAndAyahNumber="007125"
	    ;;
	1080 )
	    surahAndAyahNumber="007126"
	    ;;
	1081 )
	    surahAndAyahNumber="007127"
	    ;;
	1082 )
	    surahAndAyahNumber="007128"
	    ;;
	1083 )
	    surahAndAyahNumber="007129"
	    ;;
	1084 )
	    surahAndAyahNumber="007130"
	    ;;
	1085 )
	    surahAndAyahNumber="007131"
	    ;;
	1086 )
	    surahAndAyahNumber="007132"
	    ;;
	1087 )
	    surahAndAyahNumber="007133"
	    ;;
	1088 )
	    surahAndAyahNumber="007134"
	    ;;
	1089 )
	    surahAndAyahNumber="007135"
	    ;;
	1090 )
	    surahAndAyahNumber="007136"
	    ;;
	1091 )
	    surahAndAyahNumber="007137"
	    ;;
	1092 )
	    surahAndAyahNumber="007138"
	    ;;
	1093 )
	    surahAndAyahNumber="007139"
	    ;;
	1094 )
	    surahAndAyahNumber="007140"
	    ;;
	1095 )
	    surahAndAyahNumber="007141"
	    ;;
	1096 )
	    surahAndAyahNumber="007142"
	    ;;
	1097 )
	    surahAndAyahNumber="007143"
	    ;;
	1098 )
	    surahAndAyahNumber="007144"
	    ;;
	1099 )
	    surahAndAyahNumber="007145"
	    ;;
	1100 )
	    surahAndAyahNumber="007146"
	    ;;
	1101 )
	    surahAndAyahNumber="007147"
	    ;;
	1102 )
	    surahAndAyahNumber="007148"
	    ;;
	1103 )
	    surahAndAyahNumber="007149"
	    ;;
	1104 )
	    surahAndAyahNumber="007150"
	    ;;
	1105 )
	    surahAndAyahNumber="007151"
	    ;;
	1106 )
	    surahAndAyahNumber="007152"
	    ;;
	1107 )
	    surahAndAyahNumber="007153"
	    ;;
	1108 )
	    surahAndAyahNumber="007154"
	    ;;
	1109 )
	    surahAndAyahNumber="007155"
	    ;;
	1110 )
	    surahAndAyahNumber="007156"
	    ;;
	1111 )
	    surahAndAyahNumber="007157"
	    ;;
	1112 )
	    surahAndAyahNumber="007158"
	    ;;
	1113 )
	    surahAndAyahNumber="007159"
	    ;;
	1114 )
	    surahAndAyahNumber="007160"
	    ;;
	1115 )
	    surahAndAyahNumber="007161"
	    ;;
	1116 )
	    surahAndAyahNumber="007162"
	    ;;
	1117 )
	    surahAndAyahNumber="007163"
	    ;;
	1118 )
	    surahAndAyahNumber="007164"
	    ;;
	1119 )
	    surahAndAyahNumber="007165"
	    ;;
	1120 )
	    surahAndAyahNumber="007166"
	    ;;
	1121 )
	    surahAndAyahNumber="007167"
	    ;;
	1122 )
	    surahAndAyahNumber="007168"
	    ;;
	1123 )
	    surahAndAyahNumber="007169"
	    ;;
	1124 )
	    surahAndAyahNumber="007170"
	    ;;
	1125 )
	    surahAndAyahNumber="007171"
	    ;;
	1126 )
	    surahAndAyahNumber="007172"
	    ;;
	1127 )
	    surahAndAyahNumber="007173"
	    ;;
	1128 )
	    surahAndAyahNumber="007174"
	    ;;
	1129 )
	    surahAndAyahNumber="007175"
	    ;;
	1130 )
	    surahAndAyahNumber="007176"
	    ;;
	1131 )
	    surahAndAyahNumber="007177"
	    ;;
	1132 )
	    surahAndAyahNumber="007178"
	    ;;
	1133 )
	    surahAndAyahNumber="007179"
	    ;;
	1134 )
	    surahAndAyahNumber="007180"
	    ;;
	1135 )
	    surahAndAyahNumber="007181"
	    ;;
	1136 )
	    surahAndAyahNumber="007182"
	    ;;
	1137 )
	    surahAndAyahNumber="007183"
	    ;;
	1138 )
	    surahAndAyahNumber="007184"
	    ;;
	1139 )
	    surahAndAyahNumber="007185"
	    ;;
	1140 )
	    surahAndAyahNumber="007186"
	    ;;
	1141 )
	    surahAndAyahNumber="007187"
	    ;;
	1142 )
	    surahAndAyahNumber="007188"
	    ;;
	1143 )
	    surahAndAyahNumber="007189"
	    ;;
	1144 )
	    surahAndAyahNumber="007190"
	    ;;
	1145 )
	    surahAndAyahNumber="007191"
	    ;;
	1146 )
	    surahAndAyahNumber="007192"
	    ;;
	1147 )
	    surahAndAyahNumber="007193"
	    ;;
	1148 )
	    surahAndAyahNumber="007194"
	    ;;
	1149 )
	    surahAndAyahNumber="007195"
	    ;;
	1150 )
	    surahAndAyahNumber="007196"
	    ;;
	1151 )
	    surahAndAyahNumber="007197"
	    ;;
	1152 )
	    surahAndAyahNumber="007198"
	    ;;
	1153 )
	    surahAndAyahNumber="007199"
	    ;;
	1154 )
	    surahAndAyahNumber="007200"
	    ;;
	1155 )
	    surahAndAyahNumber="007201"
	    ;;
	1156 )
	    surahAndAyahNumber="007202"
	    ;;
	1157 )
	    surahAndAyahNumber="007203"
	    ;;
	1158 )
	    surahAndAyahNumber="007204"
	    ;;
	1159 )
	    surahAndAyahNumber="007205"
	    ;;
	1160 )
	    surahAndAyahNumber="007206"
	    ;;
	1161 )
	    surahAndAyahNumber="008001"
	    ;;
	1162 )
	    surahAndAyahNumber="008002"
	    ;;
	1163 )
	    surahAndAyahNumber="008003"
	    ;;
	1164 )
	    surahAndAyahNumber="008004"
	    ;;
	1165 )
	    surahAndAyahNumber="008005"
	    ;;
	1166 )
	    surahAndAyahNumber="008006"
	    ;;
	1167 )
	    surahAndAyahNumber="008007"
	    ;;
	1168 )
	    surahAndAyahNumber="008008"
	    ;;
	1169 )
	    surahAndAyahNumber="008009"
	    ;;
	1170 )
	    surahAndAyahNumber="008010"
	    ;;
	1171 )
	    surahAndAyahNumber="008011"
	    ;;
	1172 )
	    surahAndAyahNumber="008012"
	    ;;
	1173 )
	    surahAndAyahNumber="008013"
	    ;;
	1174 )
	    surahAndAyahNumber="008014"
	    ;;
	1175 )
	    surahAndAyahNumber="008015"
	    ;;
	1176 )
	    surahAndAyahNumber="008016"
	    ;;
	1177 )
	    surahAndAyahNumber="008017"
	    ;;
	1178 )
	    surahAndAyahNumber="008018"
	    ;;
	1179 )
	    surahAndAyahNumber="008019"
	    ;;
	1180 )
	    surahAndAyahNumber="008020"
	    ;;
	1181 )
	    surahAndAyahNumber="008021"
	    ;;
	1182 )
	    surahAndAyahNumber="008022"
	    ;;
	1183 )
	    surahAndAyahNumber="008023"
	    ;;
	1184 )
	    surahAndAyahNumber="008024"
	    ;;
	1185 )
	    surahAndAyahNumber="008025"
	    ;;
	1186 )
	    surahAndAyahNumber="008026"
	    ;;
	1187 )
	    surahAndAyahNumber="008027"
	    ;;
	1188 )
	    surahAndAyahNumber="008028"
	    ;;
	1189 )
	    surahAndAyahNumber="008029"
	    ;;
	1190 )
	    surahAndAyahNumber="008030"
	    ;;
	1191 )
	    surahAndAyahNumber="008031"
	    ;;
	1192 )
	    surahAndAyahNumber="008032"
	    ;;
	1193 )
	    surahAndAyahNumber="008033"
	    ;;
	1194 )
	    surahAndAyahNumber="008034"
	    ;;
	1195 )
	    surahAndAyahNumber="008035"
	    ;;
	1196 )
	    surahAndAyahNumber="008036"
	    ;;
	1197 )
	    surahAndAyahNumber="008037"
	    ;;
	1198 )
	    surahAndAyahNumber="008038"
	    ;;
	1199 )
	    surahAndAyahNumber="008039"
	    ;;
	1200 )
	    surahAndAyahNumber="008040"
	    ;;
	1201 )
	    surahAndAyahNumber="008041"
	    ;;
	1202 )
	    surahAndAyahNumber="008042"
	    ;;
	1203 )
	    surahAndAyahNumber="008043"
	    ;;
	1204 )
	    surahAndAyahNumber="008044"
	    ;;
	1205 )
	    surahAndAyahNumber="008045"
	    ;;
	1206 )
	    surahAndAyahNumber="008046"
	    ;;
	1207 )
	    surahAndAyahNumber="008047"
	    ;;
	1208 )
	    surahAndAyahNumber="008048"
	    ;;
	1209 )
	    surahAndAyahNumber="008049"
	    ;;
	1210 )
	    surahAndAyahNumber="008050"
	    ;;
	1211 )
	    surahAndAyahNumber="008051"
	    ;;
	1212 )
	    surahAndAyahNumber="008052"
	    ;;
	1213 )
	    surahAndAyahNumber="008053"
	    ;;
	1214 )
	    surahAndAyahNumber="008054"
	    ;;
	1215 )
	    surahAndAyahNumber="008055"
	    ;;
	1216 )
	    surahAndAyahNumber="008056"
	    ;;
	1217 )
	    surahAndAyahNumber="008057"
	    ;;
	1218 )
	    surahAndAyahNumber="008058"
	    ;;
	1219 )
	    surahAndAyahNumber="008059"
	    ;;
	1220 )
	    surahAndAyahNumber="008060"
	    ;;
	1221 )
	    surahAndAyahNumber="008061"
	    ;;
	1222 )
	    surahAndAyahNumber="008062"
	    ;;
	1223 )
	    surahAndAyahNumber="008063"
	    ;;
	1224 )
	    surahAndAyahNumber="008064"
	    ;;
	1225 )
	    surahAndAyahNumber="008065"
	    ;;
	1226 )
	    surahAndAyahNumber="008066"
	    ;;
	1227 )
	    surahAndAyahNumber="008067"
	    ;;
	1228 )
	    surahAndAyahNumber="008068"
	    ;;
	1229 )
	    surahAndAyahNumber="008069"
	    ;;
	1230 )
	    surahAndAyahNumber="008070"
	    ;;
	1231 )
	    surahAndAyahNumber="008071"
	    ;;
	1232 )
	    surahAndAyahNumber="008072"
	    ;;
	1233 )
	    surahAndAyahNumber="008073"
	    ;;
	1234 )
	    surahAndAyahNumber="008074"
	    ;;
	1235 )
	    surahAndAyahNumber="008075"
	    ;;
	1236 )
	    surahAndAyahNumber="009001"
	    ;;
	1237 )
	    surahAndAyahNumber="009002"
	    ;;
	1238 )
	    surahAndAyahNumber="009003"
	    ;;
	1239 )
	    surahAndAyahNumber="009004"
	    ;;
	1240 )
	    surahAndAyahNumber="009005"
	    ;;
	1241 )
	    surahAndAyahNumber="009006"
	    ;;
	1242 )
	    surahAndAyahNumber="009007"
	    ;;
	1243 )
	    surahAndAyahNumber="009008"
	    ;;
	1244 )
	    surahAndAyahNumber="009009"
	    ;;
	1245 )
	    surahAndAyahNumber="009010"
	    ;;
	1246 )
	    surahAndAyahNumber="009011"
	    ;;
	1247 )
	    surahAndAyahNumber="009012"
	    ;;
	1248 )
	    surahAndAyahNumber="009013"
	    ;;
	1249 )
	    surahAndAyahNumber="009014"
	    ;;
	1250 )
	    surahAndAyahNumber="009015"
	    ;;
	1251 )
	    surahAndAyahNumber="009016"
	    ;;
	1252 )
	    surahAndAyahNumber="009017"
	    ;;
	1253 )
	    surahAndAyahNumber="009018"
	    ;;
	1254 )
	    surahAndAyahNumber="009019"
	    ;;
	1255 )
	    surahAndAyahNumber="009020"
	    ;;
	1256 )
	    surahAndAyahNumber="009021"
	    ;;
	1257 )
	    surahAndAyahNumber="009022"
	    ;;
	1258 )
	    surahAndAyahNumber="009023"
	    ;;
	1259 )
	    surahAndAyahNumber="009024"
	    ;;
	1260 )
	    surahAndAyahNumber="009025"
	    ;;
	1261 )
	    surahAndAyahNumber="009026"
	    ;;
	1262 )
	    surahAndAyahNumber="009027"
	    ;;
	1263 )
	    surahAndAyahNumber="009028"
	    ;;
	1264 )
	    surahAndAyahNumber="009029"
	    ;;
	1265 )
	    surahAndAyahNumber="009030"
	    ;;
	1266 )
	    surahAndAyahNumber="009031"
	    ;;
	1267 )
	    surahAndAyahNumber="009032"
	    ;;
	1268 )
	    surahAndAyahNumber="009033"
	    ;;
	1269 )
	    surahAndAyahNumber="009034"
	    ;;
	1270 )
	    surahAndAyahNumber="009035"
	    ;;
	1271 )
	    surahAndAyahNumber="009036"
	    ;;
	1272 )
	    surahAndAyahNumber="009037"
	    ;;
	1273 )
	    surahAndAyahNumber="009038"
	    ;;
	1274 )
	    surahAndAyahNumber="009039"
	    ;;
	1275 )
	    surahAndAyahNumber="009040"
	    ;;
	1276 )
	    surahAndAyahNumber="009041"
	    ;;
	1277 )
	    surahAndAyahNumber="009042"
	    ;;
	1278 )
	    surahAndAyahNumber="009043"
	    ;;
	1279 )
	    surahAndAyahNumber="009044"
	    ;;
	1280 )
	    surahAndAyahNumber="009045"
	    ;;
	1281 )
	    surahAndAyahNumber="009046"
	    ;;
	1282 )
	    surahAndAyahNumber="009047"
	    ;;
	1283 )
	    surahAndAyahNumber="009048"
	    ;;
	1284 )
	    surahAndAyahNumber="009049"
	    ;;
	1285 )
	    surahAndAyahNumber="009050"
	    ;;
	1286 )
	    surahAndAyahNumber="009051"
	    ;;
	1287 )
	    surahAndAyahNumber="009052"
	    ;;
	1288 )
	    surahAndAyahNumber="009053"
	    ;;
	1289 )
	    surahAndAyahNumber="009054"
	    ;;
	1290 )
	    surahAndAyahNumber="009055"
	    ;;
	1291 )
	    surahAndAyahNumber="009056"
	    ;;
	1292 )
	    surahAndAyahNumber="009057"
	    ;;
	1293 )
	    surahAndAyahNumber="009058"
	    ;;
	1294 )
	    surahAndAyahNumber="009059"
	    ;;
	1295 )
	    surahAndAyahNumber="009060"
	    ;;
	1296 )
	    surahAndAyahNumber="009061"
	    ;;
	1297 )
	    surahAndAyahNumber="009062"
	    ;;
	1298 )
	    surahAndAyahNumber="009063"
	    ;;
	1299 )
	    surahAndAyahNumber="009064"
	    ;;
	1300 )
	    surahAndAyahNumber="009065"
	    ;;
	1301 )
	    surahAndAyahNumber="009066"
	    ;;
	1302 )
	    surahAndAyahNumber="009067"
	    ;;
	1303 )
	    surahAndAyahNumber="009068"
	    ;;
	1304 )
	    surahAndAyahNumber="009069"
	    ;;
	1305 )
	    surahAndAyahNumber="009070"
	    ;;
	1306 )
	    surahAndAyahNumber="009071"
	    ;;
	1307 )
	    surahAndAyahNumber="009072"
	    ;;
	1308 )
	    surahAndAyahNumber="009073"
	    ;;
	1309 )
	    surahAndAyahNumber="009074"
	    ;;
	1310 )
	    surahAndAyahNumber="009075"
	    ;;
	1311 )
	    surahAndAyahNumber="009076"
	    ;;
	1312 )
	    surahAndAyahNumber="009077"
	    ;;
	1313 )
	    surahAndAyahNumber="009078"
	    ;;
	1314 )
	    surahAndAyahNumber="009079"
	    ;;
	1315 )
	    surahAndAyahNumber="009080"
	    ;;
	1316 )
	    surahAndAyahNumber="009081"
	    ;;
	1317 )
	    surahAndAyahNumber="009082"
	    ;;
	1318 )
	    surahAndAyahNumber="009083"
	    ;;
	1319 )
	    surahAndAyahNumber="009084"
	    ;;
	1320 )
	    surahAndAyahNumber="009085"
	    ;;
	1321 )
	    surahAndAyahNumber="009086"
	    ;;
	1322 )
	    surahAndAyahNumber="009087"
	    ;;
	1323 )
	    surahAndAyahNumber="009088"
	    ;;
	1324 )
	    surahAndAyahNumber="009089"
	    ;;
	1325 )
	    surahAndAyahNumber="009090"
	    ;;
	1326 )
	    surahAndAyahNumber="009091"
	    ;;
	1327 )
	    surahAndAyahNumber="009092"
	    ;;
	1328 )
	    surahAndAyahNumber="009093"
	    ;;
	1329 )
	    surahAndAyahNumber="009094"
	    ;;
	1330 )
	    surahAndAyahNumber="009095"
	    ;;
	1331 )
	    surahAndAyahNumber="009096"
	    ;;
	1332 )
	    surahAndAyahNumber="009097"
	    ;;
	1333 )
	    surahAndAyahNumber="009098"
	    ;;
	1334 )
	    surahAndAyahNumber="009099"
	    ;;
	1335 )
	    surahAndAyahNumber="009100"
	    ;;
	1336 )
	    surahAndAyahNumber="009101"
	    ;;
	1337 )
	    surahAndAyahNumber="009102"
	    ;;
	1338 )
	    surahAndAyahNumber="009103"
	    ;;
	1339 )
	    surahAndAyahNumber="009104"
	    ;;
	1340 )
	    surahAndAyahNumber="009105"
	    ;;
	1341 )
	    surahAndAyahNumber="009106"
	    ;;
	1342 )
	    surahAndAyahNumber="009107"
	    ;;
	1343 )
	    surahAndAyahNumber="009108"
	    ;;
	1344 )
	    surahAndAyahNumber="009109"
	    ;;
	1345 )
	    surahAndAyahNumber="009110"
	    ;;
	1346 )
	    surahAndAyahNumber="009111"
	    ;;
	1347 )
	    surahAndAyahNumber="009112"
	    ;;
	1348 )
	    surahAndAyahNumber="009113"
	    ;;
	1349 )
	    surahAndAyahNumber="009114"
	    ;;
	1350 )
	    surahAndAyahNumber="009115"
	    ;;
	1351 )
	    surahAndAyahNumber="009116"
	    ;;
	1352 )
	    surahAndAyahNumber="009117"
	    ;;
	1353 )
	    surahAndAyahNumber="009118"
	    ;;
	1354 )
	    surahAndAyahNumber="009119"
	    ;;
	1355 )
	    surahAndAyahNumber="009120"
	    ;;
	1356 )
	    surahAndAyahNumber="009121"
	    ;;
	1357 )
	    surahAndAyahNumber="009122"
	    ;;
	1358 )
	    surahAndAyahNumber="009123"
	    ;;
	1359 )
	    surahAndAyahNumber="009124"
	    ;;
	1360 )
	    surahAndAyahNumber="009125"
	    ;;
	1361 )
	    surahAndAyahNumber="009126"
	    ;;
	1362 )
	    surahAndAyahNumber="009127"
	    ;;
	1363 )
	    surahAndAyahNumber="009128"
	    ;;
	1364 )
	    surahAndAyahNumber="009129"
	    ;;
	1365 )
	    surahAndAyahNumber="010001"
	    ;;
	1366 )
	    surahAndAyahNumber="010002"
	    ;;
	1367 )
	    surahAndAyahNumber="010003"
	    ;;
	1368 )
	    surahAndAyahNumber="010004"
	    ;;
	1369 )
	    surahAndAyahNumber="010005"
	    ;;
	1370 )
	    surahAndAyahNumber="010006"
	    ;;
	1371 )
	    surahAndAyahNumber="010007"
	    ;;
	1372 )
	    surahAndAyahNumber="010008"
	    ;;
	1373 )
	    surahAndAyahNumber="010009"
	    ;;
	1374 )
	    surahAndAyahNumber="010010"
	    ;;
	1375 )
	    surahAndAyahNumber="010011"
	    ;;
	1376 )
	    surahAndAyahNumber="010012"
	    ;;
	1377 )
	    surahAndAyahNumber="010013"
	    ;;
	1378 )
	    surahAndAyahNumber="010014"
	    ;;
	1379 )
	    surahAndAyahNumber="010015"
	    ;;
	1380 )
	    surahAndAyahNumber="010016"
	    ;;
	1381 )
	    surahAndAyahNumber="010017"
	    ;;
	1382 )
	    surahAndAyahNumber="010018"
	    ;;
	1383 )
	    surahAndAyahNumber="010019"
	    ;;
	1384 )
	    surahAndAyahNumber="010020"
	    ;;
	1385 )
	    surahAndAyahNumber="010021"
	    ;;
	1386 )
	    surahAndAyahNumber="010022"
	    ;;
	1387 )
	    surahAndAyahNumber="010023"
	    ;;
	1388 )
	    surahAndAyahNumber="010024"
	    ;;
	1389 )
	    surahAndAyahNumber="010025"
	    ;;
	1390 )
	    surahAndAyahNumber="010026"
	    ;;
	1391 )
	    surahAndAyahNumber="010027"
	    ;;
	1392 )
	    surahAndAyahNumber="010028"
	    ;;
	1393 )
	    surahAndAyahNumber="010029"
	    ;;
	1394 )
	    surahAndAyahNumber="010030"
	    ;;
	1395 )
	    surahAndAyahNumber="010031"
	    ;;
	1396 )
	    surahAndAyahNumber="010032"
	    ;;
	1397 )
	    surahAndAyahNumber="010033"
	    ;;
	1398 )
	    surahAndAyahNumber="010034"
	    ;;
	1399 )
	    surahAndAyahNumber="010035"
	    ;;
	1400 )
	    surahAndAyahNumber="010036"
	    ;;
	1401 )
	    surahAndAyahNumber="010037"
	    ;;
	1402 )
	    surahAndAyahNumber="010038"
	    ;;
	1403 )
	    surahAndAyahNumber="010039"
	    ;;
	1404 )
	    surahAndAyahNumber="010040"
	    ;;
	1405 )
	    surahAndAyahNumber="010041"
	    ;;
	1406 )
	    surahAndAyahNumber="010042"
	    ;;
	1407 )
	    surahAndAyahNumber="010043"
	    ;;
	1408 )
	    surahAndAyahNumber="010044"
	    ;;
	1409 )
	    surahAndAyahNumber="010045"
	    ;;
	1410 )
	    surahAndAyahNumber="010046"
	    ;;
	1411 )
	    surahAndAyahNumber="010047"
	    ;;
	1412 )
	    surahAndAyahNumber="010048"
	    ;;
	1413 )
	    surahAndAyahNumber="010049"
	    ;;
	1414 )
	    surahAndAyahNumber="010050"
	    ;;
	1415 )
	    surahAndAyahNumber="010051"
	    ;;
	1416 )
	    surahAndAyahNumber="010052"
	    ;;
	1417 )
	    surahAndAyahNumber="010053"
	    ;;
	1418 )
	    surahAndAyahNumber="010054"
	    ;;
	1419 )
	    surahAndAyahNumber="010055"
	    ;;
	1420 )
	    surahAndAyahNumber="010056"
	    ;;
	1421 )
	    surahAndAyahNumber="010057"
	    ;;
	1422 )
	    surahAndAyahNumber="010058"
	    ;;
	1423 )
	    surahAndAyahNumber="010059"
	    ;;
	1424 )
	    surahAndAyahNumber="010060"
	    ;;
	1425 )
	    surahAndAyahNumber="010061"
	    ;;
	1426 )
	    surahAndAyahNumber="010062"
	    ;;
	1427 )
	    surahAndAyahNumber="010063"
	    ;;
	1428 )
	    surahAndAyahNumber="010064"
	    ;;
	1429 )
	    surahAndAyahNumber="010065"
	    ;;
	1430 )
	    surahAndAyahNumber="010066"
	    ;;
	1431 )
	    surahAndAyahNumber="010067"
	    ;;
	1432 )
	    surahAndAyahNumber="010068"
	    ;;
	1433 )
	    surahAndAyahNumber="010069"
	    ;;
	1434 )
	    surahAndAyahNumber="010070"
	    ;;
	1435 )
	    surahAndAyahNumber="010071"
	    ;;
	1436 )
	    surahAndAyahNumber="010072"
	    ;;
	1437 )
	    surahAndAyahNumber="010073"
	    ;;
	1438 )
	    surahAndAyahNumber="010074"
	    ;;
	1439 )
	    surahAndAyahNumber="010075"
	    ;;
	1440 )
	    surahAndAyahNumber="010076"
	    ;;
	1441 )
	    surahAndAyahNumber="010077"
	    ;;
	1442 )
	    surahAndAyahNumber="010078"
	    ;;
	1443 )
	    surahAndAyahNumber="010079"
	    ;;
	1444 )
	    surahAndAyahNumber="010080"
	    ;;
	1445 )
	    surahAndAyahNumber="010081"
	    ;;
	1446 )
	    surahAndAyahNumber="010082"
	    ;;
	1447 )
	    surahAndAyahNumber="010083"
	    ;;
	1448 )
	    surahAndAyahNumber="010084"
	    ;;
	1449 )
	    surahAndAyahNumber="010085"
	    ;;
	1450 )
	    surahAndAyahNumber="010086"
	    ;;
	1451 )
	    surahAndAyahNumber="010087"
	    ;;
	1452 )
	    surahAndAyahNumber="010088"
	    ;;
	1453 )
	    surahAndAyahNumber="010089"
	    ;;
	1454 )
	    surahAndAyahNumber="010090"
	    ;;
	1455 )
	    surahAndAyahNumber="010091"
	    ;;
	1456 )
	    surahAndAyahNumber="010092"
	    ;;
	1457 )
	    surahAndAyahNumber="010093"
	    ;;
	1458 )
	    surahAndAyahNumber="010094"
	    ;;
	1459 )
	    surahAndAyahNumber="010095"
	    ;;
	1460 )
	    surahAndAyahNumber="010096"
	    ;;
	1461 )
	    surahAndAyahNumber="010097"
	    ;;
	1462 )
	    surahAndAyahNumber="010098"
	    ;;
	1463 )
	    surahAndAyahNumber="010099"
	    ;;
	1464 )
	    surahAndAyahNumber="010100"
	    ;;
	1465 )
	    surahAndAyahNumber="010101"
	    ;;
	1466 )
	    surahAndAyahNumber="010102"
	    ;;
	1467 )
	    surahAndAyahNumber="010103"
	    ;;
	1468 )
	    surahAndAyahNumber="010104"
	    ;;
	1469 )
	    surahAndAyahNumber="010105"
	    ;;
	1470 )
	    surahAndAyahNumber="010106"
	    ;;
	1471 )
	    surahAndAyahNumber="010107"
	    ;;
	1472 )
	    surahAndAyahNumber="010108"
	    ;;
	1473 )
	    surahAndAyahNumber="010109"
	    ;;
	1474 )
	    surahAndAyahNumber="011001"
	    ;;
	1475 )
	    surahAndAyahNumber="011002"
	    ;;
	1476 )
	    surahAndAyahNumber="011003"
	    ;;
	1477 )
	    surahAndAyahNumber="011004"
	    ;;
	1478 )
	    surahAndAyahNumber="011005"
	    ;;
	1479 )
	    surahAndAyahNumber="011006"
	    ;;
	1480 )
	    surahAndAyahNumber="011007"
	    ;;
	1481 )
	    surahAndAyahNumber="011008"
	    ;;
	1482 )
	    surahAndAyahNumber="011009"
	    ;;
	1483 )
	    surahAndAyahNumber="011010"
	    ;;
	1484 )
	    surahAndAyahNumber="011011"
	    ;;
	1485 )
	    surahAndAyahNumber="011012"
	    ;;
	1486 )
	    surahAndAyahNumber="011013"
	    ;;
	1487 )
	    surahAndAyahNumber="011014"
	    ;;
	1488 )
	    surahAndAyahNumber="011015"
	    ;;
	1489 )
	    surahAndAyahNumber="011016"
	    ;;
	1490 )
	    surahAndAyahNumber="011017"
	    ;;
	1491 )
	    surahAndAyahNumber="011018"
	    ;;
	1492 )
	    surahAndAyahNumber="011019"
	    ;;
	1493 )
	    surahAndAyahNumber="011020"
	    ;;
	1494 )
	    surahAndAyahNumber="011021"
	    ;;
	1495 )
	    surahAndAyahNumber="011022"
	    ;;
	1496 )
	    surahAndAyahNumber="011023"
	    ;;
	1497 )
	    surahAndAyahNumber="011024"
	    ;;
	1498 )
	    surahAndAyahNumber="011025"
	    ;;
	1499 )
	    surahAndAyahNumber="011026"
	    ;;
	1500 )
	    surahAndAyahNumber="011027"
	    ;;
	1501 )
	    surahAndAyahNumber="011028"
	    ;;
	1502 )
	    surahAndAyahNumber="011029"
	    ;;
	1503 )
	    surahAndAyahNumber="011030"
	    ;;
	1504 )
	    surahAndAyahNumber="011031"
	    ;;
	1505 )
	    surahAndAyahNumber="011032"
	    ;;
	1506 )
	    surahAndAyahNumber="011033"
	    ;;
	1507 )
	    surahAndAyahNumber="011034"
	    ;;
	1508 )
	    surahAndAyahNumber="011035"
	    ;;
	1509 )
	    surahAndAyahNumber="011036"
	    ;;
	1510 )
	    surahAndAyahNumber="011037"
	    ;;
	1511 )
	    surahAndAyahNumber="011038"
	    ;;
	1512 )
	    surahAndAyahNumber="011039"
	    ;;
	1513 )
	    surahAndAyahNumber="011040"
	    ;;
	1514 )
	    surahAndAyahNumber="011041"
	    ;;
	1515 )
	    surahAndAyahNumber="011042"
	    ;;
	1516 )
	    surahAndAyahNumber="011043"
	    ;;
	1517 )
	    surahAndAyahNumber="011044"
	    ;;
	1518 )
	    surahAndAyahNumber="011045"
	    ;;
	1519 )
	    surahAndAyahNumber="011046"
	    ;;
	1520 )
	    surahAndAyahNumber="011047"
	    ;;
	1521 )
	    surahAndAyahNumber="011048"
	    ;;
	1522 )
	    surahAndAyahNumber="011049"
	    ;;
	1523 )
	    surahAndAyahNumber="011050"
	    ;;
	1524 )
	    surahAndAyahNumber="011051"
	    ;;
	1525 )
	    surahAndAyahNumber="011052"
	    ;;
	1526 )
	    surahAndAyahNumber="011053"
	    ;;
	1527 )
	    surahAndAyahNumber="011054"
	    ;;
	1528 )
	    surahAndAyahNumber="011055"
	    ;;
	1529 )
	    surahAndAyahNumber="011056"
	    ;;
	1530 )
	    surahAndAyahNumber="011057"
	    ;;
	1531 )
	    surahAndAyahNumber="011058"
	    ;;
	1532 )
	    surahAndAyahNumber="011059"
	    ;;
	1533 )
	    surahAndAyahNumber="011060"
	    ;;
	1534 )
	    surahAndAyahNumber="011061"
	    ;;
	1535 )
	    surahAndAyahNumber="011062"
	    ;;
	1536 )
	    surahAndAyahNumber="011063"
	    ;;
	1537 )
	    surahAndAyahNumber="011064"
	    ;;
	1538 )
	    surahAndAyahNumber="011065"
	    ;;
	1539 )
	    surahAndAyahNumber="011066"
	    ;;
	1540 )
	    surahAndAyahNumber="011067"
	    ;;
	1541 )
	    surahAndAyahNumber="011068"
	    ;;
	1542 )
	    surahAndAyahNumber="011069"
	    ;;
	1543 )
	    surahAndAyahNumber="011070"
	    ;;
	1544 )
	    surahAndAyahNumber="011071"
	    ;;
	1545 )
	    surahAndAyahNumber="011072"
	    ;;
	1546 )
	    surahAndAyahNumber="011073"
	    ;;
	1547 )
	    surahAndAyahNumber="011074"
	    ;;
	1548 )
	    surahAndAyahNumber="011075"
	    ;;
	1549 )
	    surahAndAyahNumber="011076"
	    ;;
	1550 )
	    surahAndAyahNumber="011077"
	    ;;
	1551 )
	    surahAndAyahNumber="011078"
	    ;;
	1552 )
	    surahAndAyahNumber="011079"
	    ;;
	1553 )
	    surahAndAyahNumber="011080"
	    ;;
	1554 )
	    surahAndAyahNumber="011081"
	    ;;
	1555 )
	    surahAndAyahNumber="011082"
	    ;;
	1556 )
	    surahAndAyahNumber="011083"
	    ;;
	1557 )
	    surahAndAyahNumber="011084"
	    ;;
	1558 )
	    surahAndAyahNumber="011085"
	    ;;
	1559 )
	    surahAndAyahNumber="011086"
	    ;;
	1560 )
	    surahAndAyahNumber="011087"
	    ;;
	1561 )
	    surahAndAyahNumber="011088"
	    ;;
	1562 )
	    surahAndAyahNumber="011089"
	    ;;
	1563 )
	    surahAndAyahNumber="011090"
	    ;;
	1564 )
	    surahAndAyahNumber="011091"
	    ;;
	1565 )
	    surahAndAyahNumber="011092"
	    ;;
	1566 )
	    surahAndAyahNumber="011093"
	    ;;
	1567 )
	    surahAndAyahNumber="011094"
	    ;;
	1568 )
	    surahAndAyahNumber="011095"
	    ;;
	1569 )
	    surahAndAyahNumber="011096"
	    ;;
	1570 )
	    surahAndAyahNumber="011097"
	    ;;
	1571 )
	    surahAndAyahNumber="011098"
	    ;;
	1572 )
	    surahAndAyahNumber="011099"
	    ;;
	1573 )
	    surahAndAyahNumber="011100"
	    ;;
	1574 )
	    surahAndAyahNumber="011101"
	    ;;
	1575 )
	    surahAndAyahNumber="011102"
	    ;;
	1576 )
	    surahAndAyahNumber="011103"
	    ;;
	1577 )
	    surahAndAyahNumber="011104"
	    ;;
	1578 )
	    surahAndAyahNumber="011105"
	    ;;
	1579 )
	    surahAndAyahNumber="011106"
	    ;;
	1580 )
	    surahAndAyahNumber="011107"
	    ;;
	1581 )
	    surahAndAyahNumber="011108"
	    ;;
	1582 )
	    surahAndAyahNumber="011109"
	    ;;
	1583 )
	    surahAndAyahNumber="011110"
	    ;;
	1584 )
	    surahAndAyahNumber="011111"
	    ;;
	1585 )
	    surahAndAyahNumber="011112"
	    ;;
	1586 )
	    surahAndAyahNumber="011113"
	    ;;
	1587 )
	    surahAndAyahNumber="011114"
	    ;;
	1588 )
	    surahAndAyahNumber="011115"
	    ;;
	1589 )
	    surahAndAyahNumber="011116"
	    ;;
	1590 )
	    surahAndAyahNumber="011117"
	    ;;
	1591 )
	    surahAndAyahNumber="011118"
	    ;;
	1592 )
	    surahAndAyahNumber="011119"
	    ;;
	1593 )
	    surahAndAyahNumber="011120"
	    ;;
	1594 )
	    surahAndAyahNumber="011121"
	    ;;
	1595 )
	    surahAndAyahNumber="011122"
	    ;;
	1596 )
	    surahAndAyahNumber="011123"
	    ;;
	1597 )
	    surahAndAyahNumber="012001"
	    ;;
	1598 )
	    surahAndAyahNumber="012002"
	    ;;
	1599 )
	    surahAndAyahNumber="012003"
	    ;;
	1600 )
	    surahAndAyahNumber="012004"
	    ;;
	1601 )
	    surahAndAyahNumber="012005"
	    ;;
	1602 )
	    surahAndAyahNumber="012006"
	    ;;
	1603 )
	    surahAndAyahNumber="012007"
	    ;;
	1604 )
	    surahAndAyahNumber="012008"
	    ;;
	1605 )
	    surahAndAyahNumber="012009"
	    ;;
	1606 )
	    surahAndAyahNumber="012010"
	    ;;
	1607 )
	    surahAndAyahNumber="012011"
	    ;;
	1608 )
	    surahAndAyahNumber="012012"
	    ;;
	1609 )
	    surahAndAyahNumber="012013"
	    ;;
	1610 )
	    surahAndAyahNumber="012014"
	    ;;
	1611 )
	    surahAndAyahNumber="012015"
	    ;;
	1612 )
	    surahAndAyahNumber="012016"
	    ;;
	1613 )
	    surahAndAyahNumber="012017"
	    ;;
	1614 )
	    surahAndAyahNumber="012018"
	    ;;
	1615 )
	    surahAndAyahNumber="012019"
	    ;;
	1616 )
	    surahAndAyahNumber="012020"
	    ;;
	1617 )
	    surahAndAyahNumber="012021"
	    ;;
	1618 )
	    surahAndAyahNumber="012022"
	    ;;
	1619 )
	    surahAndAyahNumber="012023"
	    ;;
	1620 )
	    surahAndAyahNumber="012024"
	    ;;
	1621 )
	    surahAndAyahNumber="012025"
	    ;;
	1622 )
	    surahAndAyahNumber="012026"
	    ;;
	1623 )
	    surahAndAyahNumber="012027"
	    ;;
	1624 )
	    surahAndAyahNumber="012028"
	    ;;
	1625 )
	    surahAndAyahNumber="012029"
	    ;;
	1626 )
	    surahAndAyahNumber="012030"
	    ;;
	1627 )
	    surahAndAyahNumber="012031"
	    ;;
	1628 )
	    surahAndAyahNumber="012032"
	    ;;
	1629 )
	    surahAndAyahNumber="012033"
	    ;;
	1630 )
	    surahAndAyahNumber="012034"
	    ;;
	1631 )
	    surahAndAyahNumber="012035"
	    ;;
	1632 )
	    surahAndAyahNumber="012036"
	    ;;
	1633 )
	    surahAndAyahNumber="012037"
	    ;;
	1634 )
	    surahAndAyahNumber="012038"
	    ;;
	1635 )
	    surahAndAyahNumber="012039"
	    ;;
	1636 )
	    surahAndAyahNumber="012040"
	    ;;
	1637 )
	    surahAndAyahNumber="012041"
	    ;;
	1638 )
	    surahAndAyahNumber="012042"
	    ;;
	1639 )
	    surahAndAyahNumber="012043"
	    ;;
	1640 )
	    surahAndAyahNumber="012044"
	    ;;
	1641 )
	    surahAndAyahNumber="012045"
	    ;;
	1642 )
	    surahAndAyahNumber="012046"
	    ;;
	1643 )
	    surahAndAyahNumber="012047"
	    ;;
	1644 )
	    surahAndAyahNumber="012048"
	    ;;
	1645 )
	    surahAndAyahNumber="012049"
	    ;;
	1646 )
	    surahAndAyahNumber="012050"
	    ;;
	1647 )
	    surahAndAyahNumber="012051"
	    ;;
	1648 )
	    surahAndAyahNumber="012052"
	    ;;
	1649 )
	    surahAndAyahNumber="012053"
	    ;;
	1650 )
	    surahAndAyahNumber="012054"
	    ;;
	1651 )
	    surahAndAyahNumber="012055"
	    ;;
	1652 )
	    surahAndAyahNumber="012056"
	    ;;
	1653 )
	    surahAndAyahNumber="012057"
	    ;;
	1654 )
	    surahAndAyahNumber="012058"
	    ;;
	1655 )
	    surahAndAyahNumber="012059"
	    ;;
	1656 )
	    surahAndAyahNumber="012060"
	    ;;
	1657 )
	    surahAndAyahNumber="012061"
	    ;;
	1658 )
	    surahAndAyahNumber="012062"
	    ;;
	1659 )
	    surahAndAyahNumber="012063"
	    ;;
	1660 )
	    surahAndAyahNumber="012064"
	    ;;
	1661 )
	    surahAndAyahNumber="012065"
	    ;;
	1662 )
	    surahAndAyahNumber="012066"
	    ;;
	1663 )
	    surahAndAyahNumber="012067"
	    ;;
	1664 )
	    surahAndAyahNumber="012068"
	    ;;
	1665 )
	    surahAndAyahNumber="012069"
	    ;;
	1666 )
	    surahAndAyahNumber="012070"
	    ;;
	1667 )
	    surahAndAyahNumber="012071"
	    ;;
	1668 )
	    surahAndAyahNumber="012072"
	    ;;
	1669 )
	    surahAndAyahNumber="012073"
	    ;;
	1670 )
	    surahAndAyahNumber="012074"
	    ;;
	1671 )
	    surahAndAyahNumber="012075"
	    ;;
	1672 )
	    surahAndAyahNumber="012076"
	    ;;
	1673 )
	    surahAndAyahNumber="012077"
	    ;;
	1674 )
	    surahAndAyahNumber="012078"
	    ;;
	1675 )
	    surahAndAyahNumber="012079"
	    ;;
	1676 )
	    surahAndAyahNumber="012080"
	    ;;
	1677 )
	    surahAndAyahNumber="012081"
	    ;;
	1678 )
	    surahAndAyahNumber="012082"
	    ;;
	1679 )
	    surahAndAyahNumber="012083"
	    ;;
	1680 )
	    surahAndAyahNumber="012084"
	    ;;
	1681 )
	    surahAndAyahNumber="012085"
	    ;;
	1682 )
	    surahAndAyahNumber="012086"
	    ;;
	1683 )
	    surahAndAyahNumber="012087"
	    ;;
	1684 )
	    surahAndAyahNumber="012088"
	    ;;
	1685 )
	    surahAndAyahNumber="012089"
	    ;;
	1686 )
	    surahAndAyahNumber="012090"
	    ;;
	1687 )
	    surahAndAyahNumber="012091"
	    ;;
	1688 )
	    surahAndAyahNumber="012092"
	    ;;
	1689 )
	    surahAndAyahNumber="012093"
	    ;;
	1690 )
	    surahAndAyahNumber="012094"
	    ;;
	1691 )
	    surahAndAyahNumber="012095"
	    ;;
	1692 )
	    surahAndAyahNumber="012096"
	    ;;
	1693 )
	    surahAndAyahNumber="012097"
	    ;;
	1694 )
	    surahAndAyahNumber="012098"
	    ;;
	1695 )
	    surahAndAyahNumber="012099"
	    ;;
	1696 )
	    surahAndAyahNumber="012100"
	    ;;
	1697 )
	    surahAndAyahNumber="012101"
	    ;;
	1698 )
	    surahAndAyahNumber="012102"
	    ;;
	1699 )
	    surahAndAyahNumber="012103"
	    ;;
	1700 )
	    surahAndAyahNumber="012104"
	    ;;
	1701 )
	    surahAndAyahNumber="012105"
	    ;;
	1702 )
	    surahAndAyahNumber="012106"
	    ;;
	1703 )
	    surahAndAyahNumber="012107"
	    ;;
	1704 )
	    surahAndAyahNumber="012108"
	    ;;
	1705 )
	    surahAndAyahNumber="012109"
	    ;;
	1706 )
	    surahAndAyahNumber="012110"
	    ;;
	1707 )
	    surahAndAyahNumber="012111"
	    ;;
	1708 )
	    surahAndAyahNumber="013001"
	    ;;
	1709 )
	    surahAndAyahNumber="013002"
	    ;;
	1710 )
	    surahAndAyahNumber="013003"
	    ;;
	1711 )
	    surahAndAyahNumber="013004"
	    ;;
	1712 )
	    surahAndAyahNumber="013005"
	    ;;
	1713 )
	    surahAndAyahNumber="013006"
	    ;;
	1714 )
	    surahAndAyahNumber="013007"
	    ;;
	1715 )
	    surahAndAyahNumber="013008"
	    ;;
	1716 )
	    surahAndAyahNumber="013009"
	    ;;
	1717 )
	    surahAndAyahNumber="013010"
	    ;;
	1718 )
	    surahAndAyahNumber="013011"
	    ;;
	1719 )
	    surahAndAyahNumber="013012"
	    ;;
	1720 )
	    surahAndAyahNumber="013013"
	    ;;
	1721 )
	    surahAndAyahNumber="013014"
	    ;;
	1722 )
	    surahAndAyahNumber="013015"
	    ;;
	1723 )
	    surahAndAyahNumber="013016"
	    ;;
	1724 )
	    surahAndAyahNumber="013017"
	    ;;
	1725 )
	    surahAndAyahNumber="013018"
	    ;;
	1726 )
	    surahAndAyahNumber="013019"
	    ;;
	1727 )
	    surahAndAyahNumber="013020"
	    ;;
	1728 )
	    surahAndAyahNumber="013021"
	    ;;
	1729 )
	    surahAndAyahNumber="013022"
	    ;;
	1730 )
	    surahAndAyahNumber="013023"
	    ;;
	1731 )
	    surahAndAyahNumber="013024"
	    ;;
	1732 )
	    surahAndAyahNumber="013025"
	    ;;
	1733 )
	    surahAndAyahNumber="013026"
	    ;;
	1734 )
	    surahAndAyahNumber="013027"
	    ;;
	1735 )
	    surahAndAyahNumber="013028"
	    ;;
	1736 )
	    surahAndAyahNumber="013029"
	    ;;
	1737 )
	    surahAndAyahNumber="013030"
	    ;;
	1738 )
	    surahAndAyahNumber="013031"
	    ;;
	1739 )
	    surahAndAyahNumber="013032"
	    ;;
	1740 )
	    surahAndAyahNumber="013033"
	    ;;
	1741 )
	    surahAndAyahNumber="013034"
	    ;;
	1742 )
	    surahAndAyahNumber="013035"
	    ;;
	1743 )
	    surahAndAyahNumber="013036"
	    ;;
	1744 )
	    surahAndAyahNumber="013037"
	    ;;
	1745 )
	    surahAndAyahNumber="013038"
	    ;;
	1746 )
	    surahAndAyahNumber="013039"
	    ;;
	1747 )
	    surahAndAyahNumber="013040"
	    ;;
	1748 )
	    surahAndAyahNumber="013041"
	    ;;
	1749 )
	    surahAndAyahNumber="013042"
	    ;;
	1750 )
	    surahAndAyahNumber="013043"
	    ;;
	1751 )
	    surahAndAyahNumber="014001"
	    ;;
	1752 )
	    surahAndAyahNumber="014002"
	    ;;
	1753 )
	    surahAndAyahNumber="014003"
	    ;;
	1754 )
	    surahAndAyahNumber="014004"
	    ;;
	1755 )
	    surahAndAyahNumber="014005"
	    ;;
	1756 )
	    surahAndAyahNumber="014006"
	    ;;
	1757 )
	    surahAndAyahNumber="014007"
	    ;;
	1758 )
	    surahAndAyahNumber="014008"
	    ;;
	1759 )
	    surahAndAyahNumber="014009"
	    ;;
	1760 )
	    surahAndAyahNumber="014010"
	    ;;
	1761 )
	    surahAndAyahNumber="014011"
	    ;;
	1762 )
	    surahAndAyahNumber="014012"
	    ;;
	1763 )
	    surahAndAyahNumber="014013"
	    ;;
	1764 )
	    surahAndAyahNumber="014014"
	    ;;
	1765 )
	    surahAndAyahNumber="014015"
	    ;;
	1766 )
	    surahAndAyahNumber="014016"
	    ;;
	1767 )
	    surahAndAyahNumber="014017"
	    ;;
	1768 )
	    surahAndAyahNumber="014018"
	    ;;
	1769 )
	    surahAndAyahNumber="014019"
	    ;;
	1770 )
	    surahAndAyahNumber="014020"
	    ;;
	1771 )
	    surahAndAyahNumber="014021"
	    ;;
	1772 )
	    surahAndAyahNumber="014022"
	    ;;
	1773 )
	    surahAndAyahNumber="014023"
	    ;;
	1774 )
	    surahAndAyahNumber="014024"
	    ;;
	1775 )
	    surahAndAyahNumber="014025"
	    ;;
	1776 )
	    surahAndAyahNumber="014026"
	    ;;
	1777 )
	    surahAndAyahNumber="014027"
	    ;;
	1778 )
	    surahAndAyahNumber="014028"
	    ;;
	1779 )
	    surahAndAyahNumber="014029"
	    ;;
	1780 )
	    surahAndAyahNumber="014030"
	    ;;
	1781 )
	    surahAndAyahNumber="014031"
	    ;;
	1782 )
	    surahAndAyahNumber="014032"
	    ;;
	1783 )
	    surahAndAyahNumber="014033"
	    ;;
	1784 )
	    surahAndAyahNumber="014034"
	    ;;
	1785 )
	    surahAndAyahNumber="014035"
	    ;;
	1786 )
	    surahAndAyahNumber="014036"
	    ;;
	1787 )
	    surahAndAyahNumber="014037"
	    ;;
	1788 )
	    surahAndAyahNumber="014038"
	    ;;
	1789 )
	    surahAndAyahNumber="014039"
	    ;;
	1790 )
	    surahAndAyahNumber="014040"
	    ;;
	1791 )
	    surahAndAyahNumber="014041"
	    ;;
	1792 )
	    surahAndAyahNumber="014042"
	    ;;
	1793 )
	    surahAndAyahNumber="014043"
	    ;;
	1794 )
	    surahAndAyahNumber="014044"
	    ;;
	1795 )
	    surahAndAyahNumber="014045"
	    ;;
	1796 )
	    surahAndAyahNumber="014046"
	    ;;
	1797 )
	    surahAndAyahNumber="014047"
	    ;;
	1798 )
	    surahAndAyahNumber="014048"
	    ;;
	1799 )
	    surahAndAyahNumber="014049"
	    ;;
	1800 )
	    surahAndAyahNumber="014050"
	    ;;
	1801 )
	    surahAndAyahNumber="014051"
	    ;;
	1802 )
	    surahAndAyahNumber="014052"
	    ;;
	1803 )
	    surahAndAyahNumber="015001"
	    ;;
	1804 )
	    surahAndAyahNumber="015002"
	    ;;
	1805 )
	    surahAndAyahNumber="015003"
	    ;;
	1806 )
	    surahAndAyahNumber="015004"
	    ;;
	1807 )
	    surahAndAyahNumber="015005"
	    ;;
	1808 )
	    surahAndAyahNumber="015006"
	    ;;
	1809 )
	    surahAndAyahNumber="015007"
	    ;;
	1810 )
	    surahAndAyahNumber="015008"
	    ;;
	1811 )
	    surahAndAyahNumber="015009"
	    ;;
	1812 )
	    surahAndAyahNumber="015010"
	    ;;
	1813 )
	    surahAndAyahNumber="015011"
	    ;;
	1814 )
	    surahAndAyahNumber="015012"
	    ;;
	1815 )
	    surahAndAyahNumber="015013"
	    ;;
	1816 )
	    surahAndAyahNumber="015014"
	    ;;
	1817 )
	    surahAndAyahNumber="015015"
	    ;;
	1818 )
	    surahAndAyahNumber="015016"
	    ;;
	1819 )
	    surahAndAyahNumber="015017"
	    ;;
	1820 )
	    surahAndAyahNumber="015018"
	    ;;
	1821 )
	    surahAndAyahNumber="015019"
	    ;;
	1822 )
	    surahAndAyahNumber="015020"
	    ;;
	1823 )
	    surahAndAyahNumber="015021"
	    ;;
	1824 )
	    surahAndAyahNumber="015022"
	    ;;
	1825 )
	    surahAndAyahNumber="015023"
	    ;;
	1826 )
	    surahAndAyahNumber="015024"
	    ;;
	1827 )
	    surahAndAyahNumber="015025"
	    ;;
	1828 )
	    surahAndAyahNumber="015026"
	    ;;
	1829 )
	    surahAndAyahNumber="015027"
	    ;;
	1830 )
	    surahAndAyahNumber="015028"
	    ;;
	1831 )
	    surahAndAyahNumber="015029"
	    ;;
	1832 )
	    surahAndAyahNumber="015030"
	    ;;
	1833 )
	    surahAndAyahNumber="015031"
	    ;;
	1834 )
	    surahAndAyahNumber="015032"
	    ;;
	1835 )
	    surahAndAyahNumber="015033"
	    ;;
	1836 )
	    surahAndAyahNumber="015034"
	    ;;
	1837 )
	    surahAndAyahNumber="015035"
	    ;;
	1838 )
	    surahAndAyahNumber="015036"
	    ;;
	1839 )
	    surahAndAyahNumber="015037"
	    ;;
	1840 )
	    surahAndAyahNumber="015038"
	    ;;
	1841 )
	    surahAndAyahNumber="015039"
	    ;;
	1842 )
	    surahAndAyahNumber="015040"
	    ;;
	1843 )
	    surahAndAyahNumber="015041"
	    ;;
	1844 )
	    surahAndAyahNumber="015042"
	    ;;
	1845 )
	    surahAndAyahNumber="015043"
	    ;;
	1846 )
	    surahAndAyahNumber="015044"
	    ;;
	1847 )
	    surahAndAyahNumber="015045"
	    ;;
	1848 )
	    surahAndAyahNumber="015046"
	    ;;
	1849 )
	    surahAndAyahNumber="015047"
	    ;;
	1850 )
	    surahAndAyahNumber="015048"
	    ;;
	1851 )
	    surahAndAyahNumber="015049"
	    ;;
	1852 )
	    surahAndAyahNumber="015050"
	    ;;
	1853 )
	    surahAndAyahNumber="015051"
	    ;;
	1854 )
	    surahAndAyahNumber="015052"
	    ;;
	1855 )
	    surahAndAyahNumber="015053"
	    ;;
	1856 )
	    surahAndAyahNumber="015054"
	    ;;
	1857 )
	    surahAndAyahNumber="015055"
	    ;;
	1858 )
	    surahAndAyahNumber="015056"
	    ;;
	1859 )
	    surahAndAyahNumber="015057"
	    ;;
	1860 )
	    surahAndAyahNumber="015058"
	    ;;
	1861 )
	    surahAndAyahNumber="015059"
	    ;;
	1862 )
	    surahAndAyahNumber="015060"
	    ;;
	1863 )
	    surahAndAyahNumber="015061"
	    ;;
	1864 )
	    surahAndAyahNumber="015062"
	    ;;
	1865 )
	    surahAndAyahNumber="015063"
	    ;;
	1866 )
	    surahAndAyahNumber="015064"
	    ;;
	1867 )
	    surahAndAyahNumber="015065"
	    ;;
	1868 )
	    surahAndAyahNumber="015066"
	    ;;
	1869 )
	    surahAndAyahNumber="015067"
	    ;;
	1870 )
	    surahAndAyahNumber="015068"
	    ;;
	1871 )
	    surahAndAyahNumber="015069"
	    ;;
	1872 )
	    surahAndAyahNumber="015070"
	    ;;
	1873 )
	    surahAndAyahNumber="015071"
	    ;;
	1874 )
	    surahAndAyahNumber="015072"
	    ;;
	1875 )
	    surahAndAyahNumber="015073"
	    ;;
	1876 )
	    surahAndAyahNumber="015074"
	    ;;
	1877 )
	    surahAndAyahNumber="015075"
	    ;;
	1878 )
	    surahAndAyahNumber="015076"
	    ;;
	1879 )
	    surahAndAyahNumber="015077"
	    ;;
	1880 )
	    surahAndAyahNumber="015078"
	    ;;
	1881 )
	    surahAndAyahNumber="015079"
	    ;;
	1882 )
	    surahAndAyahNumber="015080"
	    ;;
	1883 )
	    surahAndAyahNumber="015081"
	    ;;
	1884 )
	    surahAndAyahNumber="015082"
	    ;;
	1885 )
	    surahAndAyahNumber="015083"
	    ;;
	1886 )
	    surahAndAyahNumber="015084"
	    ;;
	1887 )
	    surahAndAyahNumber="015085"
	    ;;
	1888 )
	    surahAndAyahNumber="015086"
	    ;;
	1889 )
	    surahAndAyahNumber="015087"
	    ;;
	1890 )
	    surahAndAyahNumber="015088"
	    ;;
	1891 )
	    surahAndAyahNumber="015089"
	    ;;
	1892 )
	    surahAndAyahNumber="015090"
	    ;;
	1893 )
	    surahAndAyahNumber="015091"
	    ;;
	1894 )
	    surahAndAyahNumber="015092"
	    ;;
	1895 )
	    surahAndAyahNumber="015093"
	    ;;
	1896 )
	    surahAndAyahNumber="015094"
	    ;;
	1897 )
	    surahAndAyahNumber="015095"
	    ;;
	1898 )
	    surahAndAyahNumber="015096"
	    ;;
	1899 )
	    surahAndAyahNumber="015097"
	    ;;
	1900 )
	    surahAndAyahNumber="015098"
	    ;;
	1901 )
	    surahAndAyahNumber="015099"
	    ;;
	1902 )
	    surahAndAyahNumber="016001"
	    ;;
	1903 )
	    surahAndAyahNumber="016002"
	    ;;
	1904 )
	    surahAndAyahNumber="016003"
	    ;;
	1905 )
	    surahAndAyahNumber="016004"
	    ;;
	1906 )
	    surahAndAyahNumber="016005"
	    ;;
	1907 )
	    surahAndAyahNumber="016006"
	    ;;
	1908 )
	    surahAndAyahNumber="016007"
	    ;;
	1909 )
	    surahAndAyahNumber="016008"
	    ;;
	1910 )
	    surahAndAyahNumber="016009"
	    ;;
	1911 )
	    surahAndAyahNumber="016010"
	    ;;
	1912 )
	    surahAndAyahNumber="016011"
	    ;;
	1913 )
	    surahAndAyahNumber="016012"
	    ;;
	1914 )
	    surahAndAyahNumber="016013"
	    ;;
	1915 )
	    surahAndAyahNumber="016014"
	    ;;
	1916 )
	    surahAndAyahNumber="016015"
	    ;;
	1917 )
	    surahAndAyahNumber="016016"
	    ;;
	1918 )
	    surahAndAyahNumber="016017"
	    ;;
	1919 )
	    surahAndAyahNumber="016018"
	    ;;
	1920 )
	    surahAndAyahNumber="016019"
	    ;;
	1921 )
	    surahAndAyahNumber="016020"
	    ;;
	1922 )
	    surahAndAyahNumber="016021"
	    ;;
	1923 )
	    surahAndAyahNumber="016022"
	    ;;
	1924 )
	    surahAndAyahNumber="016023"
	    ;;
	1925 )
	    surahAndAyahNumber="016024"
	    ;;
	1926 )
	    surahAndAyahNumber="016025"
	    ;;
	1927 )
	    surahAndAyahNumber="016026"
	    ;;
	1928 )
	    surahAndAyahNumber="016027"
	    ;;
	1929 )
	    surahAndAyahNumber="016028"
	    ;;
	1930 )
	    surahAndAyahNumber="016029"
	    ;;
	1931 )
	    surahAndAyahNumber="016030"
	    ;;
	1932 )
	    surahAndAyahNumber="016031"
	    ;;
	1933 )
	    surahAndAyahNumber="016032"
	    ;;
	1934 )
	    surahAndAyahNumber="016033"
	    ;;
	1935 )
	    surahAndAyahNumber="016034"
	    ;;
	1936 )
	    surahAndAyahNumber="016035"
	    ;;
	1937 )
	    surahAndAyahNumber="016036"
	    ;;
	1938 )
	    surahAndAyahNumber="016037"
	    ;;
	1939 )
	    surahAndAyahNumber="016038"
	    ;;
	1940 )
	    surahAndAyahNumber="016039"
	    ;;
	1941 )
	    surahAndAyahNumber="016040"
	    ;;
	1942 )
	    surahAndAyahNumber="016041"
	    ;;
	1943 )
	    surahAndAyahNumber="016042"
	    ;;
	1944 )
	    surahAndAyahNumber="016043"
	    ;;
	1945 )
	    surahAndAyahNumber="016044"
	    ;;
	1946 )
	    surahAndAyahNumber="016045"
	    ;;
	1947 )
	    surahAndAyahNumber="016046"
	    ;;
	1948 )
	    surahAndAyahNumber="016047"
	    ;;
	1949 )
	    surahAndAyahNumber="016048"
	    ;;
	1950 )
	    surahAndAyahNumber="016049"
	    ;;
	1951 )
	    surahAndAyahNumber="016050"
	    ;;
	1952 )
	    surahAndAyahNumber="016051"
	    ;;
	1953 )
	    surahAndAyahNumber="016052"
	    ;;
	1954 )
	    surahAndAyahNumber="016053"
	    ;;
	1955 )
	    surahAndAyahNumber="016054"
	    ;;
	1956 )
	    surahAndAyahNumber="016055"
	    ;;
	1957 )
	    surahAndAyahNumber="016056"
	    ;;
	1958 )
	    surahAndAyahNumber="016057"
	    ;;
	1959 )
	    surahAndAyahNumber="016058"
	    ;;
	1960 )
	    surahAndAyahNumber="016059"
	    ;;
	1961 )
	    surahAndAyahNumber="016060"
	    ;;
	1962 )
	    surahAndAyahNumber="016061"
	    ;;
	1963 )
	    surahAndAyahNumber="016062"
	    ;;
	1964 )
	    surahAndAyahNumber="016063"
	    ;;
	1965 )
	    surahAndAyahNumber="016064"
	    ;;
	1966 )
	    surahAndAyahNumber="016065"
	    ;;
	1967 )
	    surahAndAyahNumber="016066"
	    ;;
	1968 )
	    surahAndAyahNumber="016067"
	    ;;
	1969 )
	    surahAndAyahNumber="016068"
	    ;;
	1970 )
	    surahAndAyahNumber="016069"
	    ;;
	1971 )
	    surahAndAyahNumber="016070"
	    ;;
	1972 )
	    surahAndAyahNumber="016071"
	    ;;
	1973 )
	    surahAndAyahNumber="016072"
	    ;;
	1974 )
	    surahAndAyahNumber="016073"
	    ;;
	1975 )
	    surahAndAyahNumber="016074"
	    ;;
	1976 )
	    surahAndAyahNumber="016075"
	    ;;
	1977 )
	    surahAndAyahNumber="016076"
	    ;;
	1978 )
	    surahAndAyahNumber="016077"
	    ;;
	1979 )
	    surahAndAyahNumber="016078"
	    ;;
	1980 )
	    surahAndAyahNumber="016079"
	    ;;
	1981 )
	    surahAndAyahNumber="016080"
	    ;;
	1982 )
	    surahAndAyahNumber="016081"
	    ;;
	1983 )
	    surahAndAyahNumber="016082"
	    ;;
	1984 )
	    surahAndAyahNumber="016083"
	    ;;
	1985 )
	    surahAndAyahNumber="016084"
	    ;;
	1986 )
	    surahAndAyahNumber="016085"
	    ;;
	1987 )
	    surahAndAyahNumber="016086"
	    ;;
	1988 )
	    surahAndAyahNumber="016087"
	    ;;
	1989 )
	    surahAndAyahNumber="016088"
	    ;;
	1990 )
	    surahAndAyahNumber="016089"
	    ;;
	1991 )
	    surahAndAyahNumber="016090"
	    ;;
	1992 )
	    surahAndAyahNumber="016091"
	    ;;
	1993 )
	    surahAndAyahNumber="016092"
	    ;;
	1994 )
	    surahAndAyahNumber="016093"
	    ;;
	1995 )
	    surahAndAyahNumber="016094"
	    ;;
	1996 )
	    surahAndAyahNumber="016095"
	    ;;
	1997 )
	    surahAndAyahNumber="016096"
	    ;;
	1998 )
	    surahAndAyahNumber="016097"
	    ;;
	1999 )
	    surahAndAyahNumber="016098"
	    ;;
	2000 )
	    surahAndAyahNumber="016099"
	    ;;
	2001 )
	    surahAndAyahNumber="016100"
	    ;;
	2002 )
	    surahAndAyahNumber="016101"
	    ;;
	2003 )
	    surahAndAyahNumber="016102"
	    ;;
	2004 )
	    surahAndAyahNumber="016103"
	    ;;
	2005 )
	    surahAndAyahNumber="016104"
	    ;;
	2006 )
	    surahAndAyahNumber="016105"
	    ;;
	2007 )
	    surahAndAyahNumber="016106"
	    ;;
	2008 )
	    surahAndAyahNumber="016107"
	    ;;
	2009 )
	    surahAndAyahNumber="016108"
	    ;;
	2010 )
	    surahAndAyahNumber="016109"
	    ;;
	2011 )
	    surahAndAyahNumber="016110"
	    ;;
	2012 )
	    surahAndAyahNumber="016111"
	    ;;
	2013 )
	    surahAndAyahNumber="016112"
	    ;;
	2014 )
	    surahAndAyahNumber="016113"
	    ;;
	2015 )
	    surahAndAyahNumber="016114"
	    ;;
	2016 )
	    surahAndAyahNumber="016115"
	    ;;
	2017 )
	    surahAndAyahNumber="016116"
	    ;;
	2018 )
	    surahAndAyahNumber="016117"
	    ;;
	2019 )
	    surahAndAyahNumber="016118"
	    ;;
	2020 )
	    surahAndAyahNumber="016119"
	    ;;
	2021 )
	    surahAndAyahNumber="016120"
	    ;;
	2022 )
	    surahAndAyahNumber="016121"
	    ;;
	2023 )
	    surahAndAyahNumber="016122"
	    ;;
	2024 )
	    surahAndAyahNumber="016123"
	    ;;
	2025 )
	    surahAndAyahNumber="016124"
	    ;;
	2026 )
	    surahAndAyahNumber="016125"
	    ;;
	2027 )
	    surahAndAyahNumber="016126"
	    ;;
	2028 )
	    surahAndAyahNumber="016127"
	    ;;
	2029 )
	    surahAndAyahNumber="016128"
	    ;;
	2030 )
	    surahAndAyahNumber="017001"
	    ;;
	2031 )
	    surahAndAyahNumber="017002"
	    ;;
	2032 )
	    surahAndAyahNumber="017003"
	    ;;
	2033 )
	    surahAndAyahNumber="017004"
	    ;;
	2034 )
	    surahAndAyahNumber="017005"
	    ;;
	2035 )
	    surahAndAyahNumber="017006"
	    ;;
	2036 )
	    surahAndAyahNumber="017007"
	    ;;
	2037 )
	    surahAndAyahNumber="017008"
	    ;;
	2038 )
	    surahAndAyahNumber="017009"
	    ;;
	2039 )
	    surahAndAyahNumber="017010"
	    ;;
	2040 )
	    surahAndAyahNumber="017011"
	    ;;
	2041 )
	    surahAndAyahNumber="017012"
	    ;;
	2042 )
	    surahAndAyahNumber="017013"
	    ;;
	2043 )
	    surahAndAyahNumber="017014"
	    ;;
	2044 )
	    surahAndAyahNumber="017015"
	    ;;
	2045 )
	    surahAndAyahNumber="017016"
	    ;;
	2046 )
	    surahAndAyahNumber="017017"
	    ;;
	2047 )
	    surahAndAyahNumber="017018"
	    ;;
	2048 )
	    surahAndAyahNumber="017019"
	    ;;
	2049 )
	    surahAndAyahNumber="017020"
	    ;;
	2050 )
	    surahAndAyahNumber="017021"
	    ;;
	2051 )
	    surahAndAyahNumber="017022"
	    ;;
	2052 )
	    surahAndAyahNumber="017023"
	    ;;
	2053 )
	    surahAndAyahNumber="017024"
	    ;;
	2054 )
	    surahAndAyahNumber="017025"
	    ;;
	2055 )
	    surahAndAyahNumber="017026"
	    ;;
	2056 )
	    surahAndAyahNumber="017027"
	    ;;
	2057 )
	    surahAndAyahNumber="017028"
	    ;;
	2058 )
	    surahAndAyahNumber="017029"
	    ;;
	2059 )
	    surahAndAyahNumber="017030"
	    ;;
	2060 )
	    surahAndAyahNumber="017031"
	    ;;
	2061 )
	    surahAndAyahNumber="017032"
	    ;;
	2062 )
	    surahAndAyahNumber="017033"
	    ;;
	2063 )
	    surahAndAyahNumber="017034"
	    ;;
	2064 )
	    surahAndAyahNumber="017035"
	    ;;
	2065 )
	    surahAndAyahNumber="017036"
	    ;;
	2066 )
	    surahAndAyahNumber="017037"
	    ;;
	2067 )
	    surahAndAyahNumber="017038"
	    ;;
	2068 )
	    surahAndAyahNumber="017039"
	    ;;
	2069 )
	    surahAndAyahNumber="017040"
	    ;;
	2070 )
	    surahAndAyahNumber="017041"
	    ;;
	2071 )
	    surahAndAyahNumber="017042"
	    ;;
	2072 )
	    surahAndAyahNumber="017043"
	    ;;
	2073 )
	    surahAndAyahNumber="017044"
	    ;;
	2074 )
	    surahAndAyahNumber="017045"
	    ;;
	2075 )
	    surahAndAyahNumber="017046"
	    ;;
	2076 )
	    surahAndAyahNumber="017047"
	    ;;
	2077 )
	    surahAndAyahNumber="017048"
	    ;;
	2078 )
	    surahAndAyahNumber="017049"
	    ;;
	2079 )
	    surahAndAyahNumber="017050"
	    ;;
	2080 )
	    surahAndAyahNumber="017051"
	    ;;
	2081 )
	    surahAndAyahNumber="017052"
	    ;;
	2082 )
	    surahAndAyahNumber="017053"
	    ;;
	2083 )
	    surahAndAyahNumber="017054"
	    ;;
	2084 )
	    surahAndAyahNumber="017055"
	    ;;
	2085 )
	    surahAndAyahNumber="017056"
	    ;;
	2086 )
	    surahAndAyahNumber="017057"
	    ;;
	2087 )
	    surahAndAyahNumber="017058"
	    ;;
	2088 )
	    surahAndAyahNumber="017059"
	    ;;
	2089 )
	    surahAndAyahNumber="017060"
	    ;;
	2090 )
	    surahAndAyahNumber="017061"
	    ;;
	2091 )
	    surahAndAyahNumber="017062"
	    ;;
	2092 )
	    surahAndAyahNumber="017063"
	    ;;
	2093 )
	    surahAndAyahNumber="017064"
	    ;;
	2094 )
	    surahAndAyahNumber="017065"
	    ;;
	2095 )
	    surahAndAyahNumber="017066"
	    ;;
	2096 )
	    surahAndAyahNumber="017067"
	    ;;
	2097 )
	    surahAndAyahNumber="017068"
	    ;;
	2098 )
	    surahAndAyahNumber="017069"
	    ;;
	2099 )
	    surahAndAyahNumber="017070"
	    ;;
	2100 )
	    surahAndAyahNumber="017071"
	    ;;
	2101 )
	    surahAndAyahNumber="017072"
	    ;;
	2102 )
	    surahAndAyahNumber="017073"
	    ;;
	2103 )
	    surahAndAyahNumber="017074"
	    ;;
	2104 )
	    surahAndAyahNumber="017075"
	    ;;
	2105 )
	    surahAndAyahNumber="017076"
	    ;;
	2106 )
	    surahAndAyahNumber="017077"
	    ;;
	2107 )
	    surahAndAyahNumber="017078"
	    ;;
	2108 )
	    surahAndAyahNumber="017079"
	    ;;
	2109 )
	    surahAndAyahNumber="017080"
	    ;;
	2110 )
	    surahAndAyahNumber="017081"
	    ;;
	2111 )
	    surahAndAyahNumber="017082"
	    ;;
	2112 )
	    surahAndAyahNumber="017083"
	    ;;
	2113 )
	    surahAndAyahNumber="017084"
	    ;;
	2114 )
	    surahAndAyahNumber="017085"
	    ;;
	2115 )
	    surahAndAyahNumber="017086"
	    ;;
	2116 )
	    surahAndAyahNumber="017087"
	    ;;
	2117 )
	    surahAndAyahNumber="017088"
	    ;;
	2118 )
	    surahAndAyahNumber="017089"
	    ;;
	2119 )
	    surahAndAyahNumber="017090"
	    ;;
	2120 )
	    surahAndAyahNumber="017091"
	    ;;
	2121 )
	    surahAndAyahNumber="017092"
	    ;;
	2122 )
	    surahAndAyahNumber="017093"
	    ;;
	2123 )
	    surahAndAyahNumber="017094"
	    ;;
	2124 )
	    surahAndAyahNumber="017095"
	    ;;
	2125 )
	    surahAndAyahNumber="017096"
	    ;;
	2126 )
	    surahAndAyahNumber="017097"
	    ;;
	2127 )
	    surahAndAyahNumber="017098"
	    ;;
	2128 )
	    surahAndAyahNumber="017099"
	    ;;
	2129 )
	    surahAndAyahNumber="017100"
	    ;;
	2130 )
	    surahAndAyahNumber="017101"
	    ;;
	2131 )
	    surahAndAyahNumber="017102"
	    ;;
	2132 )
	    surahAndAyahNumber="017103"
	    ;;
	2133 )
	    surahAndAyahNumber="017104"
	    ;;
	2134 )
	    surahAndAyahNumber="017105"
	    ;;
	2135 )
	    surahAndAyahNumber="017106"
	    ;;
	2136 )
	    surahAndAyahNumber="017107"
	    ;;
	2137 )
	    surahAndAyahNumber="017108"
	    ;;
	2138 )
	    surahAndAyahNumber="017109"
	    ;;
	2139 )
	    surahAndAyahNumber="017110"
	    ;;
	2140 )
	    surahAndAyahNumber="017111"
	    ;;
	2141 )
	    surahAndAyahNumber="018001"
	    ;;
	2142 )
	    surahAndAyahNumber="018002"
	    ;;
	2143 )
	    surahAndAyahNumber="018003"
	    ;;
	2144 )
	    surahAndAyahNumber="018004"
	    ;;
	2145 )
	    surahAndAyahNumber="018005"
	    ;;
	2146 )
	    surahAndAyahNumber="018006"
	    ;;
	2147 )
	    surahAndAyahNumber="018007"
	    ;;
	2148 )
	    surahAndAyahNumber="018008"
	    ;;
	2149 )
	    surahAndAyahNumber="018009"
	    ;;
	2150 )
	    surahAndAyahNumber="018010"
	    ;;
	2151 )
	    surahAndAyahNumber="018011"
	    ;;
	2152 )
	    surahAndAyahNumber="018012"
	    ;;
	2153 )
	    surahAndAyahNumber="018013"
	    ;;
	2154 )
	    surahAndAyahNumber="018014"
	    ;;
	2155 )
	    surahAndAyahNumber="018015"
	    ;;
	2156 )
	    surahAndAyahNumber="018016"
	    ;;
	2157 )
	    surahAndAyahNumber="018017"
	    ;;
	2158 )
	    surahAndAyahNumber="018018"
	    ;;
	2159 )
	    surahAndAyahNumber="018019"
	    ;;
	2160 )
	    surahAndAyahNumber="018020"
	    ;;
	2161 )
	    surahAndAyahNumber="018021"
	    ;;
	2162 )
	    surahAndAyahNumber="018022"
	    ;;
	2163 )
	    surahAndAyahNumber="018023"
	    ;;
	2164 )
	    surahAndAyahNumber="018024"
	    ;;
	2165 )
	    surahAndAyahNumber="018025"
	    ;;
	2166 )
	    surahAndAyahNumber="018026"
	    ;;
	2167 )
	    surahAndAyahNumber="018027"
	    ;;
	2168 )
	    surahAndAyahNumber="018028"
	    ;;
	2169 )
	    surahAndAyahNumber="018029"
	    ;;
	2170 )
	    surahAndAyahNumber="018030"
	    ;;
	2171 )
	    surahAndAyahNumber="018031"
	    ;;
	2172 )
	    surahAndAyahNumber="018032"
	    ;;
	2173 )
	    surahAndAyahNumber="018033"
	    ;;
	2174 )
	    surahAndAyahNumber="018034"
	    ;;
	2175 )
	    surahAndAyahNumber="018035"
	    ;;
	2176 )
	    surahAndAyahNumber="018036"
	    ;;
	2177 )
	    surahAndAyahNumber="018037"
	    ;;
	2178 )
	    surahAndAyahNumber="018038"
	    ;;
	2179 )
	    surahAndAyahNumber="018039"
	    ;;
	2180 )
	    surahAndAyahNumber="018040"
	    ;;
	2181 )
	    surahAndAyahNumber="018041"
	    ;;
	2182 )
	    surahAndAyahNumber="018042"
	    ;;
	2183 )
	    surahAndAyahNumber="018043"
	    ;;
	2184 )
	    surahAndAyahNumber="018044"
	    ;;
	2185 )
	    surahAndAyahNumber="018045"
	    ;;
	2186 )
	    surahAndAyahNumber="018046"
	    ;;
	2187 )
	    surahAndAyahNumber="018047"
	    ;;
	2188 )
	    surahAndAyahNumber="018048"
	    ;;
	2189 )
	    surahAndAyahNumber="018049"
	    ;;
	2190 )
	    surahAndAyahNumber="018050"
	    ;;
	2191 )
	    surahAndAyahNumber="018051"
	    ;;
	2192 )
	    surahAndAyahNumber="018052"
	    ;;
	2193 )
	    surahAndAyahNumber="018053"
	    ;;
	2194 )
	    surahAndAyahNumber="018054"
	    ;;
	2195 )
	    surahAndAyahNumber="018055"
	    ;;
	2196 )
	    surahAndAyahNumber="018056"
	    ;;
	2197 )
	    surahAndAyahNumber="018057"
	    ;;
	2198 )
	    surahAndAyahNumber="018058"
	    ;;
	2199 )
	    surahAndAyahNumber="018059"
	    ;;
	2200 )
	    surahAndAyahNumber="018060"
	    ;;
	2201 )
	    surahAndAyahNumber="018061"
	    ;;
	2202 )
	    surahAndAyahNumber="018062"
	    ;;
	2203 )
	    surahAndAyahNumber="018063"
	    ;;
	2204 )
	    surahAndAyahNumber="018064"
	    ;;
	2205 )
	    surahAndAyahNumber="018065"
	    ;;
	2206 )
	    surahAndAyahNumber="018066"
	    ;;
	2207 )
	    surahAndAyahNumber="018067"
	    ;;
	2208 )
	    surahAndAyahNumber="018068"
	    ;;
	2209 )
	    surahAndAyahNumber="018069"
	    ;;
	2210 )
	    surahAndAyahNumber="018070"
	    ;;
	2211 )
	    surahAndAyahNumber="018071"
	    ;;
	2212 )
	    surahAndAyahNumber="018072"
	    ;;
	2213 )
	    surahAndAyahNumber="018073"
	    ;;
	2214 )
	    surahAndAyahNumber="018074"
	    ;;
	2215 )
	    surahAndAyahNumber="018075"
	    ;;
	2216 )
	    surahAndAyahNumber="018076"
	    ;;
	2217 )
	    surahAndAyahNumber="018077"
	    ;;
	2218 )
	    surahAndAyahNumber="018078"
	    ;;
	2219 )
	    surahAndAyahNumber="018079"
	    ;;
	2220 )
	    surahAndAyahNumber="018080"
	    ;;
	2221 )
	    surahAndAyahNumber="018081"
	    ;;
	2222 )
	    surahAndAyahNumber="018082"
	    ;;
	2223 )
	    surahAndAyahNumber="018083"
	    ;;
	2224 )
	    surahAndAyahNumber="018084"
	    ;;
	2225 )
	    surahAndAyahNumber="018085"
	    ;;
	2226 )
	    surahAndAyahNumber="018086"
	    ;;
	2227 )
	    surahAndAyahNumber="018087"
	    ;;
	2228 )
	    surahAndAyahNumber="018088"
	    ;;
	2229 )
	    surahAndAyahNumber="018089"
	    ;;
	2230 )
	    surahAndAyahNumber="018090"
	    ;;
	2231 )
	    surahAndAyahNumber="018091"
	    ;;
	2232 )
	    surahAndAyahNumber="018092"
	    ;;
	2233 )
	    surahAndAyahNumber="018093"
	    ;;
	2234 )
	    surahAndAyahNumber="018094"
	    ;;
	2235 )
	    surahAndAyahNumber="018095"
	    ;;
	2236 )
	    surahAndAyahNumber="018096"
	    ;;
	2237 )
	    surahAndAyahNumber="018097"
	    ;;
	2238 )
	    surahAndAyahNumber="018098"
	    ;;
	2239 )
	    surahAndAyahNumber="018099"
	    ;;
	2240 )
	    surahAndAyahNumber="018100"
	    ;;
	2241 )
	    surahAndAyahNumber="018101"
	    ;;
	2242 )
	    surahAndAyahNumber="018102"
	    ;;
	2243 )
	    surahAndAyahNumber="018103"
	    ;;
	2244 )
	    surahAndAyahNumber="018104"
	    ;;
	2245 )
	    surahAndAyahNumber="018105"
	    ;;
	2246 )
	    surahAndAyahNumber="018106"
	    ;;
	2247 )
	    surahAndAyahNumber="018107"
	    ;;
	2248 )
	    surahAndAyahNumber="018108"
	    ;;
	2249 )
	    surahAndAyahNumber="018109"
	    ;;
	2250 )
	    surahAndAyahNumber="018110"
	    ;;
	2251 )
	    surahAndAyahNumber="019001"
	    ;;
	2252 )
	    surahAndAyahNumber="019002"
	    ;;
	2253 )
	    surahAndAyahNumber="019003"
	    ;;
	2254 )
	    surahAndAyahNumber="019004"
	    ;;
	2255 )
	    surahAndAyahNumber="019005"
	    ;;
	2256 )
	    surahAndAyahNumber="019006"
	    ;;
	2257 )
	    surahAndAyahNumber="019007"
	    ;;
	2258 )
	    surahAndAyahNumber="019008"
	    ;;
	2259 )
	    surahAndAyahNumber="019009"
	    ;;
	2260 )
	    surahAndAyahNumber="019010"
	    ;;
	2261 )
	    surahAndAyahNumber="019011"
	    ;;
	2262 )
	    surahAndAyahNumber="019012"
	    ;;
	2263 )
	    surahAndAyahNumber="019013"
	    ;;
	2264 )
	    surahAndAyahNumber="019014"
	    ;;
	2265 )
	    surahAndAyahNumber="019015"
	    ;;
	2266 )
	    surahAndAyahNumber="019016"
	    ;;
	2267 )
	    surahAndAyahNumber="019017"
	    ;;
	2268 )
	    surahAndAyahNumber="019018"
	    ;;
	2269 )
	    surahAndAyahNumber="019019"
	    ;;
	2270 )
	    surahAndAyahNumber="019020"
	    ;;
	2271 )
	    surahAndAyahNumber="019021"
	    ;;
	2272 )
	    surahAndAyahNumber="019022"
	    ;;
	2273 )
	    surahAndAyahNumber="019023"
	    ;;
	2274 )
	    surahAndAyahNumber="019024"
	    ;;
	2275 )
	    surahAndAyahNumber="019025"
	    ;;
	2276 )
	    surahAndAyahNumber="019026"
	    ;;
	2277 )
	    surahAndAyahNumber="019027"
	    ;;
	2278 )
	    surahAndAyahNumber="019028"
	    ;;
	2279 )
	    surahAndAyahNumber="019029"
	    ;;
	2280 )
	    surahAndAyahNumber="019030"
	    ;;
	2281 )
	    surahAndAyahNumber="019031"
	    ;;
	2282 )
	    surahAndAyahNumber="019032"
	    ;;
	2283 )
	    surahAndAyahNumber="019033"
	    ;;
	2284 )
	    surahAndAyahNumber="019034"
	    ;;
	2285 )
	    surahAndAyahNumber="019035"
	    ;;
	2286 )
	    surahAndAyahNumber="019036"
	    ;;
	2287 )
	    surahAndAyahNumber="019037"
	    ;;
	2288 )
	    surahAndAyahNumber="019038"
	    ;;
	2289 )
	    surahAndAyahNumber="019039"
	    ;;
	2290 )
	    surahAndAyahNumber="019040"
	    ;;
	2291 )
	    surahAndAyahNumber="019041"
	    ;;
	2292 )
	    surahAndAyahNumber="019042"
	    ;;
	2293 )
	    surahAndAyahNumber="019043"
	    ;;
	2294 )
	    surahAndAyahNumber="019044"
	    ;;
	2295 )
	    surahAndAyahNumber="019045"
	    ;;
	2296 )
	    surahAndAyahNumber="019046"
	    ;;
	2297 )
	    surahAndAyahNumber="019047"
	    ;;
	2298 )
	    surahAndAyahNumber="019048"
	    ;;
	2299 )
	    surahAndAyahNumber="019049"
	    ;;
	2300 )
	    surahAndAyahNumber="019050"
	    ;;
	2301 )
	    surahAndAyahNumber="019051"
	    ;;
	2302 )
	    surahAndAyahNumber="019052"
	    ;;
	2303 )
	    surahAndAyahNumber="019053"
	    ;;
	2304 )
	    surahAndAyahNumber="019054"
	    ;;
	2305 )
	    surahAndAyahNumber="019055"
	    ;;
	2306 )
	    surahAndAyahNumber="019056"
	    ;;
	2307 )
	    surahAndAyahNumber="019057"
	    ;;
	2308 )
	    surahAndAyahNumber="019058"
	    ;;
	2309 )
	    surahAndAyahNumber="019059"
	    ;;
	2310 )
	    surahAndAyahNumber="019060"
	    ;;
	2311 )
	    surahAndAyahNumber="019061"
	    ;;
	2312 )
	    surahAndAyahNumber="019062"
	    ;;
	2313 )
	    surahAndAyahNumber="019063"
	    ;;
	2314 )
	    surahAndAyahNumber="019064"
	    ;;
	2315 )
	    surahAndAyahNumber="019065"
	    ;;
	2316 )
	    surahAndAyahNumber="019066"
	    ;;
	2317 )
	    surahAndAyahNumber="019067"
	    ;;
	2318 )
	    surahAndAyahNumber="019068"
	    ;;
	2319 )
	    surahAndAyahNumber="019069"
	    ;;
	2320 )
	    surahAndAyahNumber="019070"
	    ;;
	2321 )
	    surahAndAyahNumber="019071"
	    ;;
	2322 )
	    surahAndAyahNumber="019072"
	    ;;
	2323 )
	    surahAndAyahNumber="019073"
	    ;;
	2324 )
	    surahAndAyahNumber="019074"
	    ;;
	2325 )
	    surahAndAyahNumber="019075"
	    ;;
	2326 )
	    surahAndAyahNumber="019076"
	    ;;
	2327 )
	    surahAndAyahNumber="019077"
	    ;;
	2328 )
	    surahAndAyahNumber="019078"
	    ;;
	2329 )
	    surahAndAyahNumber="019079"
	    ;;
	2330 )
	    surahAndAyahNumber="019080"
	    ;;
	2331 )
	    surahAndAyahNumber="019081"
	    ;;
	2332 )
	    surahAndAyahNumber="019082"
	    ;;
	2333 )
	    surahAndAyahNumber="019083"
	    ;;
	2334 )
	    surahAndAyahNumber="019084"
	    ;;
	2335 )
	    surahAndAyahNumber="019085"
	    ;;
	2336 )
	    surahAndAyahNumber="019086"
	    ;;
	2337 )
	    surahAndAyahNumber="019087"
	    ;;
	2338 )
	    surahAndAyahNumber="019088"
	    ;;
	2339 )
	    surahAndAyahNumber="019089"
	    ;;
	2340 )
	    surahAndAyahNumber="019090"
	    ;;
	2341 )
	    surahAndAyahNumber="019091"
	    ;;
	2342 )
	    surahAndAyahNumber="019092"
	    ;;
	2343 )
	    surahAndAyahNumber="019093"
	    ;;
	2344 )
	    surahAndAyahNumber="019094"
	    ;;
	2345 )
	    surahAndAyahNumber="019095"
	    ;;
	2346 )
	    surahAndAyahNumber="019096"
	    ;;
	2347 )
	    surahAndAyahNumber="019097"
	    ;;
	2348 )
	    surahAndAyahNumber="019098"
	    ;;
	2349 )
	    surahAndAyahNumber="020001"
	    ;;
	2350 )
	    surahAndAyahNumber="020002"
	    ;;
	2351 )
	    surahAndAyahNumber="020003"
	    ;;
	2352 )
	    surahAndAyahNumber="020004"
	    ;;
	2353 )
	    surahAndAyahNumber="020005"
	    ;;
	2354 )
	    surahAndAyahNumber="020006"
	    ;;
	2355 )
	    surahAndAyahNumber="020007"
	    ;;
	2356 )
	    surahAndAyahNumber="020008"
	    ;;
	2357 )
	    surahAndAyahNumber="020009"
	    ;;
	2358 )
	    surahAndAyahNumber="020010"
	    ;;
	2359 )
	    surahAndAyahNumber="020011"
	    ;;
	2360 )
	    surahAndAyahNumber="020012"
	    ;;
	2361 )
	    surahAndAyahNumber="020013"
	    ;;
	2362 )
	    surahAndAyahNumber="020014"
	    ;;
	2363 )
	    surahAndAyahNumber="020015"
	    ;;
	2364 )
	    surahAndAyahNumber="020016"
	    ;;
	2365 )
	    surahAndAyahNumber="020017"
	    ;;
	2366 )
	    surahAndAyahNumber="020018"
	    ;;
	2367 )
	    surahAndAyahNumber="020019"
	    ;;
	2368 )
	    surahAndAyahNumber="020020"
	    ;;
	2369 )
	    surahAndAyahNumber="020021"
	    ;;
	2370 )
	    surahAndAyahNumber="020022"
	    ;;
	2371 )
	    surahAndAyahNumber="020023"
	    ;;
	2372 )
	    surahAndAyahNumber="020024"
	    ;;
	2373 )
	    surahAndAyahNumber="020025"
	    ;;
	2374 )
	    surahAndAyahNumber="020026"
	    ;;
	2375 )
	    surahAndAyahNumber="020027"
	    ;;
	2376 )
	    surahAndAyahNumber="020028"
	    ;;
	2377 )
	    surahAndAyahNumber="020029"
	    ;;
	2378 )
	    surahAndAyahNumber="020030"
	    ;;
	2379 )
	    surahAndAyahNumber="020031"
	    ;;
	2380 )
	    surahAndAyahNumber="020032"
	    ;;
	2381 )
	    surahAndAyahNumber="020033"
	    ;;
	2382 )
	    surahAndAyahNumber="020034"
	    ;;
	2383 )
	    surahAndAyahNumber="020035"
	    ;;
	2384 )
	    surahAndAyahNumber="020036"
	    ;;
	2385 )
	    surahAndAyahNumber="020037"
	    ;;
	2386 )
	    surahAndAyahNumber="020038"
	    ;;
	2387 )
	    surahAndAyahNumber="020039"
	    ;;
	2388 )
	    surahAndAyahNumber="020040"
	    ;;
	2389 )
	    surahAndAyahNumber="020041"
	    ;;
	2390 )
	    surahAndAyahNumber="020042"
	    ;;
	2391 )
	    surahAndAyahNumber="020043"
	    ;;
	2392 )
	    surahAndAyahNumber="020044"
	    ;;
	2393 )
	    surahAndAyahNumber="020045"
	    ;;
	2394 )
	    surahAndAyahNumber="020046"
	    ;;
	2395 )
	    surahAndAyahNumber="020047"
	    ;;
	2396 )
	    surahAndAyahNumber="020048"
	    ;;
	2397 )
	    surahAndAyahNumber="020049"
	    ;;
	2398 )
	    surahAndAyahNumber="020050"
	    ;;
	2399 )
	    surahAndAyahNumber="020051"
	    ;;
	2400 )
	    surahAndAyahNumber="020052"
	    ;;
	2401 )
	    surahAndAyahNumber="020053"
	    ;;
	2402 )
	    surahAndAyahNumber="020054"
	    ;;
	2403 )
	    surahAndAyahNumber="020055"
	    ;;
	2404 )
	    surahAndAyahNumber="020056"
	    ;;
	2405 )
	    surahAndAyahNumber="020057"
	    ;;
	2406 )
	    surahAndAyahNumber="020058"
	    ;;
	2407 )
	    surahAndAyahNumber="020059"
	    ;;
	2408 )
	    surahAndAyahNumber="020060"
	    ;;
	2409 )
	    surahAndAyahNumber="020061"
	    ;;
	2410 )
	    surahAndAyahNumber="020062"
	    ;;
	2411 )
	    surahAndAyahNumber="020063"
	    ;;
	2412 )
	    surahAndAyahNumber="020064"
	    ;;
	2413 )
	    surahAndAyahNumber="020065"
	    ;;
	2414 )
	    surahAndAyahNumber="020066"
	    ;;
	2415 )
	    surahAndAyahNumber="020067"
	    ;;
	2416 )
	    surahAndAyahNumber="020068"
	    ;;
	2417 )
	    surahAndAyahNumber="020069"
	    ;;
	2418 )
	    surahAndAyahNumber="020070"
	    ;;
	2419 )
	    surahAndAyahNumber="020071"
	    ;;
	2420 )
	    surahAndAyahNumber="020072"
	    ;;
	2421 )
	    surahAndAyahNumber="020073"
	    ;;
	2422 )
	    surahAndAyahNumber="020074"
	    ;;
	2423 )
	    surahAndAyahNumber="020075"
	    ;;
	2424 )
	    surahAndAyahNumber="020076"
	    ;;
	2425 )
	    surahAndAyahNumber="020077"
	    ;;
	2426 )
	    surahAndAyahNumber="020078"
	    ;;
	2427 )
	    surahAndAyahNumber="020079"
	    ;;
	2428 )
	    surahAndAyahNumber="020080"
	    ;;
	2429 )
	    surahAndAyahNumber="020081"
	    ;;
	2430 )
	    surahAndAyahNumber="020082"
	    ;;
	2431 )
	    surahAndAyahNumber="020083"
	    ;;
	2432 )
	    surahAndAyahNumber="020084"
	    ;;
	2433 )
	    surahAndAyahNumber="020085"
	    ;;
	2434 )
	    surahAndAyahNumber="020086"
	    ;;
	2435 )
	    surahAndAyahNumber="020087"
	    ;;
	2436 )
	    surahAndAyahNumber="020088"
	    ;;
	2437 )
	    surahAndAyahNumber="020089"
	    ;;
	2438 )
	    surahAndAyahNumber="020090"
	    ;;
	2439 )
	    surahAndAyahNumber="020091"
	    ;;
	2440 )
	    surahAndAyahNumber="020092"
	    ;;
	2441 )
	    surahAndAyahNumber="020093"
	    ;;
	2442 )
	    surahAndAyahNumber="020094"
	    ;;
	2443 )
	    surahAndAyahNumber="020095"
	    ;;
	2444 )
	    surahAndAyahNumber="020096"
	    ;;
	2445 )
	    surahAndAyahNumber="020097"
	    ;;
	2446 )
	    surahAndAyahNumber="020098"
	    ;;
	2447 )
	    surahAndAyahNumber="020099"
	    ;;
	2448 )
	    surahAndAyahNumber="020100"
	    ;;
	2449 )
	    surahAndAyahNumber="020101"
	    ;;
	2450 )
	    surahAndAyahNumber="020102"
	    ;;
	2451 )
	    surahAndAyahNumber="020103"
	    ;;
	2452 )
	    surahAndAyahNumber="020104"
	    ;;
	2453 )
	    surahAndAyahNumber="020105"
	    ;;
	2454 )
	    surahAndAyahNumber="020106"
	    ;;
	2455 )
	    surahAndAyahNumber="020107"
	    ;;
	2456 )
	    surahAndAyahNumber="020108"
	    ;;
	2457 )
	    surahAndAyahNumber="020109"
	    ;;
	2458 )
	    surahAndAyahNumber="020110"
	    ;;
	2459 )
	    surahAndAyahNumber="020111"
	    ;;
	2460 )
	    surahAndAyahNumber="020112"
	    ;;
	2461 )
	    surahAndAyahNumber="020113"
	    ;;
	2462 )
	    surahAndAyahNumber="020114"
	    ;;
	2463 )
	    surahAndAyahNumber="020115"
	    ;;
	2464 )
	    surahAndAyahNumber="020116"
	    ;;
	2465 )
	    surahAndAyahNumber="020117"
	    ;;
	2466 )
	    surahAndAyahNumber="020118"
	    ;;
	2467 )
	    surahAndAyahNumber="020119"
	    ;;
	2468 )
	    surahAndAyahNumber="020120"
	    ;;
	2469 )
	    surahAndAyahNumber="020121"
	    ;;
	2470 )
	    surahAndAyahNumber="020122"
	    ;;
	2471 )
	    surahAndAyahNumber="020123"
	    ;;
	2472 )
	    surahAndAyahNumber="020124"
	    ;;
	2473 )
	    surahAndAyahNumber="020125"
	    ;;
	2474 )
	    surahAndAyahNumber="020126"
	    ;;
	2475 )
	    surahAndAyahNumber="020127"
	    ;;
	2476 )
	    surahAndAyahNumber="020128"
	    ;;
	2477 )
	    surahAndAyahNumber="020129"
	    ;;
	2478 )
	    surahAndAyahNumber="020130"
	    ;;
	2479 )
	    surahAndAyahNumber="020131"
	    ;;
	2480 )
	    surahAndAyahNumber="020132"
	    ;;
	2481 )
	    surahAndAyahNumber="020133"
	    ;;
	2482 )
	    surahAndAyahNumber="020134"
	    ;;
	2483 )
	    surahAndAyahNumber="020135"
	    ;;
	2484 )
	    surahAndAyahNumber="021001"
	    ;;
	2485 )
	    surahAndAyahNumber="021002"
	    ;;
	2486 )
	    surahAndAyahNumber="021003"
	    ;;
	2487 )
	    surahAndAyahNumber="021004"
	    ;;
	2488 )
	    surahAndAyahNumber="021005"
	    ;;
	2489 )
	    surahAndAyahNumber="021006"
	    ;;
	2490 )
	    surahAndAyahNumber="021007"
	    ;;
	2491 )
	    surahAndAyahNumber="021008"
	    ;;
	2492 )
	    surahAndAyahNumber="021009"
	    ;;
	2493 )
	    surahAndAyahNumber="021010"
	    ;;
	2494 )
	    surahAndAyahNumber="021011"
	    ;;
	2495 )
	    surahAndAyahNumber="021012"
	    ;;
	2496 )
	    surahAndAyahNumber="021013"
	    ;;
	2497 )
	    surahAndAyahNumber="021014"
	    ;;
	2498 )
	    surahAndAyahNumber="021015"
	    ;;
	2499 )
	    surahAndAyahNumber="021016"
	    ;;
	2500 )
	    surahAndAyahNumber="021017"
	    ;;
	2501 )
	    surahAndAyahNumber="021018"
	    ;;
	2502 )
	    surahAndAyahNumber="021019"
	    ;;
	2503 )
	    surahAndAyahNumber="021020"
	    ;;
	2504 )
	    surahAndAyahNumber="021021"
	    ;;
	2505 )
	    surahAndAyahNumber="021022"
	    ;;
	2506 )
	    surahAndAyahNumber="021023"
	    ;;
	2507 )
	    surahAndAyahNumber="021024"
	    ;;
	2508 )
	    surahAndAyahNumber="021025"
	    ;;
	2509 )
	    surahAndAyahNumber="021026"
	    ;;
	2510 )
	    surahAndAyahNumber="021027"
	    ;;
	2511 )
	    surahAndAyahNumber="021028"
	    ;;
	2512 )
	    surahAndAyahNumber="021029"
	    ;;
	2513 )
	    surahAndAyahNumber="021030"
	    ;;
	2514 )
	    surahAndAyahNumber="021031"
	    ;;
	2515 )
	    surahAndAyahNumber="021032"
	    ;;
	2516 )
	    surahAndAyahNumber="021033"
	    ;;
	2517 )
	    surahAndAyahNumber="021034"
	    ;;
	2518 )
	    surahAndAyahNumber="021035"
	    ;;
	2519 )
	    surahAndAyahNumber="021036"
	    ;;
	2520 )
	    surahAndAyahNumber="021037"
	    ;;
	2521 )
	    surahAndAyahNumber="021038"
	    ;;
	2522 )
	    surahAndAyahNumber="021039"
	    ;;
	2523 )
	    surahAndAyahNumber="021040"
	    ;;
	2524 )
	    surahAndAyahNumber="021041"
	    ;;
	2525 )
	    surahAndAyahNumber="021042"
	    ;;
	2526 )
	    surahAndAyahNumber="021043"
	    ;;
	2527 )
	    surahAndAyahNumber="021044"
	    ;;
	2528 )
	    surahAndAyahNumber="021045"
	    ;;
	2529 )
	    surahAndAyahNumber="021046"
	    ;;
	2530 )
	    surahAndAyahNumber="021047"
	    ;;
	2531 )
	    surahAndAyahNumber="021048"
	    ;;
	2532 )
	    surahAndAyahNumber="021049"
	    ;;
	2533 )
	    surahAndAyahNumber="021050"
	    ;;
	2534 )
	    surahAndAyahNumber="021051"
	    ;;
	2535 )
	    surahAndAyahNumber="021052"
	    ;;
	2536 )
	    surahAndAyahNumber="021053"
	    ;;
	2537 )
	    surahAndAyahNumber="021054"
	    ;;
	2538 )
	    surahAndAyahNumber="021055"
	    ;;
	2539 )
	    surahAndAyahNumber="021056"
	    ;;
	2540 )
	    surahAndAyahNumber="021057"
	    ;;
	2541 )
	    surahAndAyahNumber="021058"
	    ;;
	2542 )
	    surahAndAyahNumber="021059"
	    ;;
	2543 )
	    surahAndAyahNumber="021060"
	    ;;
	2544 )
	    surahAndAyahNumber="021061"
	    ;;
	2545 )
	    surahAndAyahNumber="021062"
	    ;;
	2546 )
	    surahAndAyahNumber="021063"
	    ;;
	2547 )
	    surahAndAyahNumber="021064"
	    ;;
	2548 )
	    surahAndAyahNumber="021065"
	    ;;
	2549 )
	    surahAndAyahNumber="021066"
	    ;;
	2550 )
	    surahAndAyahNumber="021067"
	    ;;
	2551 )
	    surahAndAyahNumber="021068"
	    ;;
	2552 )
	    surahAndAyahNumber="021069"
	    ;;
	2553 )
	    surahAndAyahNumber="021070"
	    ;;
	2554 )
	    surahAndAyahNumber="021071"
	    ;;
	2555 )
	    surahAndAyahNumber="021072"
	    ;;
	2556 )
	    surahAndAyahNumber="021073"
	    ;;
	2557 )
	    surahAndAyahNumber="021074"
	    ;;
	2558 )
	    surahAndAyahNumber="021075"
	    ;;
	2559 )
	    surahAndAyahNumber="021076"
	    ;;
	2560 )
	    surahAndAyahNumber="021077"
	    ;;
	2561 )
	    surahAndAyahNumber="021078"
	    ;;
	2562 )
	    surahAndAyahNumber="021079"
	    ;;
	2563 )
	    surahAndAyahNumber="021080"
	    ;;
	2564 )
	    surahAndAyahNumber="021081"
	    ;;
	2565 )
	    surahAndAyahNumber="021082"
	    ;;
	2566 )
	    surahAndAyahNumber="021083"
	    ;;
	2567 )
	    surahAndAyahNumber="021084"
	    ;;
	2568 )
	    surahAndAyahNumber="021085"
	    ;;
	2569 )
	    surahAndAyahNumber="021086"
	    ;;
	2570 )
	    surahAndAyahNumber="021087"
	    ;;
	2571 )
	    surahAndAyahNumber="021088"
	    ;;
	2572 )
	    surahAndAyahNumber="021089"
	    ;;
	2573 )
	    surahAndAyahNumber="021090"
	    ;;
	2574 )
	    surahAndAyahNumber="021091"
	    ;;
	2575 )
	    surahAndAyahNumber="021092"
	    ;;
	2576 )
	    surahAndAyahNumber="021093"
	    ;;
	2577 )
	    surahAndAyahNumber="021094"
	    ;;
	2578 )
	    surahAndAyahNumber="021095"
	    ;;
	2579 )
	    surahAndAyahNumber="021096"
	    ;;
	2580 )
	    surahAndAyahNumber="021097"
	    ;;
	2581 )
	    surahAndAyahNumber="021098"
	    ;;
	2582 )
	    surahAndAyahNumber="021099"
	    ;;
	2583 )
	    surahAndAyahNumber="021100"
	    ;;
	2584 )
	    surahAndAyahNumber="021101"
	    ;;
	2585 )
	    surahAndAyahNumber="021102"
	    ;;
	2586 )
	    surahAndAyahNumber="021103"
	    ;;
	2587 )
	    surahAndAyahNumber="021104"
	    ;;
	2588 )
	    surahAndAyahNumber="021105"
	    ;;
	2589 )
	    surahAndAyahNumber="021106"
	    ;;
	2590 )
	    surahAndAyahNumber="021107"
	    ;;
	2591 )
	    surahAndAyahNumber="021108"
	    ;;
	2592 )
	    surahAndAyahNumber="021109"
	    ;;
	2593 )
	    surahAndAyahNumber="021110"
	    ;;
	2594 )
	    surahAndAyahNumber="021111"
	    ;;
	2595 )
	    surahAndAyahNumber="021112"
	    ;;
	2596 )
	    surahAndAyahNumber="022001"
	    ;;
	2597 )
	    surahAndAyahNumber="022002"
	    ;;
	2598 )
	    surahAndAyahNumber="022003"
	    ;;
	2599 )
	    surahAndAyahNumber="022004"
	    ;;
	2600 )
	    surahAndAyahNumber="022005"
	    ;;
	2601 )
	    surahAndAyahNumber="022006"
	    ;;
	2602 )
	    surahAndAyahNumber="022007"
	    ;;
	2603 )
	    surahAndAyahNumber="022008"
	    ;;
	2604 )
	    surahAndAyahNumber="022009"
	    ;;
	2605 )
	    surahAndAyahNumber="022010"
	    ;;
	2606 )
	    surahAndAyahNumber="022011"
	    ;;
	2607 )
	    surahAndAyahNumber="022012"
	    ;;
	2608 )
	    surahAndAyahNumber="022013"
	    ;;
	2609 )
	    surahAndAyahNumber="022014"
	    ;;
	2610 )
	    surahAndAyahNumber="022015"
	    ;;
	2611 )
	    surahAndAyahNumber="022016"
	    ;;
	2612 )
	    surahAndAyahNumber="022017"
	    ;;
	2613 )
	    surahAndAyahNumber="022018"
	    ;;
	2614 )
	    surahAndAyahNumber="022019"
	    ;;
	2615 )
	    surahAndAyahNumber="022020"
	    ;;
	2616 )
	    surahAndAyahNumber="022021"
	    ;;
	2617 )
	    surahAndAyahNumber="022022"
	    ;;
	2618 )
	    surahAndAyahNumber="022023"
	    ;;
	2619 )
	    surahAndAyahNumber="022024"
	    ;;
	2620 )
	    surahAndAyahNumber="022025"
	    ;;
	2621 )
	    surahAndAyahNumber="022026"
	    ;;
	2622 )
	    surahAndAyahNumber="022027"
	    ;;
	2623 )
	    surahAndAyahNumber="022028"
	    ;;
	2624 )
	    surahAndAyahNumber="022029"
	    ;;
	2625 )
	    surahAndAyahNumber="022030"
	    ;;
	2626 )
	    surahAndAyahNumber="022031"
	    ;;
	2627 )
	    surahAndAyahNumber="022032"
	    ;;
	2628 )
	    surahAndAyahNumber="022033"
	    ;;
	2629 )
	    surahAndAyahNumber="022034"
	    ;;
	2630 )
	    surahAndAyahNumber="022035"
	    ;;
	2631 )
	    surahAndAyahNumber="022036"
	    ;;
	2632 )
	    surahAndAyahNumber="022037"
	    ;;
	2633 )
	    surahAndAyahNumber="022038"
	    ;;
	2634 )
	    surahAndAyahNumber="022039"
	    ;;
	2635 )
	    surahAndAyahNumber="022040"
	    ;;
	2636 )
	    surahAndAyahNumber="022041"
	    ;;
	2637 )
	    surahAndAyahNumber="022042"
	    ;;
	2638 )
	    surahAndAyahNumber="022043"
	    ;;
	2639 )
	    surahAndAyahNumber="022044"
	    ;;
	2640 )
	    surahAndAyahNumber="022045"
	    ;;
	2641 )
	    surahAndAyahNumber="022046"
	    ;;
	2642 )
	    surahAndAyahNumber="022047"
	    ;;
	2643 )
	    surahAndAyahNumber="022048"
	    ;;
	2644 )
	    surahAndAyahNumber="022049"
	    ;;
	2645 )
	    surahAndAyahNumber="022050"
	    ;;
	2646 )
	    surahAndAyahNumber="022051"
	    ;;
	2647 )
	    surahAndAyahNumber="022052"
	    ;;
	2648 )
	    surahAndAyahNumber="022053"
	    ;;
	2649 )
	    surahAndAyahNumber="022054"
	    ;;
	2650 )
	    surahAndAyahNumber="022055"
	    ;;
	2651 )
	    surahAndAyahNumber="022056"
	    ;;
	2652 )
	    surahAndAyahNumber="022057"
	    ;;
	2653 )
	    surahAndAyahNumber="022058"
	    ;;
	2654 )
	    surahAndAyahNumber="022059"
	    ;;
	2655 )
	    surahAndAyahNumber="022060"
	    ;;
	2656 )
	    surahAndAyahNumber="022061"
	    ;;
	2657 )
	    surahAndAyahNumber="022062"
	    ;;
	2658 )
	    surahAndAyahNumber="022063"
	    ;;
	2659 )
	    surahAndAyahNumber="022064"
	    ;;
	2660 )
	    surahAndAyahNumber="022065"
	    ;;
	2661 )
	    surahAndAyahNumber="022066"
	    ;;
	2662 )
	    surahAndAyahNumber="022067"
	    ;;
	2663 )
	    surahAndAyahNumber="022068"
	    ;;
	2664 )
	    surahAndAyahNumber="022069"
	    ;;
	2665 )
	    surahAndAyahNumber="022070"
	    ;;
	2666 )
	    surahAndAyahNumber="022071"
	    ;;
	2667 )
	    surahAndAyahNumber="022072"
	    ;;
	2668 )
	    surahAndAyahNumber="022073"
	    ;;
	2669 )
	    surahAndAyahNumber="022074"
	    ;;
	2670 )
	    surahAndAyahNumber="022075"
	    ;;
	2671 )
	    surahAndAyahNumber="022076"
	    ;;
	2672 )
	    surahAndAyahNumber="022077"
	    ;;
	2673 )
	    surahAndAyahNumber="022078"
	    ;;
	2674 )
	    surahAndAyahNumber="023001"
	    ;;
	2675 )
	    surahAndAyahNumber="023002"
	    ;;
	2676 )
	    surahAndAyahNumber="023003"
	    ;;
	2677 )
	    surahAndAyahNumber="023004"
	    ;;
	2678 )
	    surahAndAyahNumber="023005"
	    ;;
	2679 )
	    surahAndAyahNumber="023006"
	    ;;
	2680 )
	    surahAndAyahNumber="023007"
	    ;;
	2681 )
	    surahAndAyahNumber="023008"
	    ;;
	2682 )
	    surahAndAyahNumber="023009"
	    ;;
	2683 )
	    surahAndAyahNumber="023010"
	    ;;
	2684 )
	    surahAndAyahNumber="023011"
	    ;;
	2685 )
	    surahAndAyahNumber="023012"
	    ;;
	2686 )
	    surahAndAyahNumber="023013"
	    ;;
	2687 )
	    surahAndAyahNumber="023014"
	    ;;
	2688 )
	    surahAndAyahNumber="023015"
	    ;;
	2689 )
	    surahAndAyahNumber="023016"
	    ;;
	2690 )
	    surahAndAyahNumber="023017"
	    ;;
	2691 )
	    surahAndAyahNumber="023018"
	    ;;
	2692 )
	    surahAndAyahNumber="023019"
	    ;;
	2693 )
	    surahAndAyahNumber="023020"
	    ;;
	2694 )
	    surahAndAyahNumber="023021"
	    ;;
	2695 )
	    surahAndAyahNumber="023022"
	    ;;
	2696 )
	    surahAndAyahNumber="023023"
	    ;;
	2697 )
	    surahAndAyahNumber="023024"
	    ;;
	2698 )
	    surahAndAyahNumber="023025"
	    ;;
	2699 )
	    surahAndAyahNumber="023026"
	    ;;
	2700 )
	    surahAndAyahNumber="023027"
	    ;;
	2701 )
	    surahAndAyahNumber="023028"
	    ;;
	2702 )
	    surahAndAyahNumber="023029"
	    ;;
	2703 )
	    surahAndAyahNumber="023030"
	    ;;
	2704 )
	    surahAndAyahNumber="023031"
	    ;;
	2705 )
	    surahAndAyahNumber="023032"
	    ;;
	2706 )
	    surahAndAyahNumber="023033"
	    ;;
	2707 )
	    surahAndAyahNumber="023034"
	    ;;
	2708 )
	    surahAndAyahNumber="023035"
	    ;;
	2709 )
	    surahAndAyahNumber="023036"
	    ;;
	2710 )
	    surahAndAyahNumber="023037"
	    ;;
	2711 )
	    surahAndAyahNumber="023038"
	    ;;
	2712 )
	    surahAndAyahNumber="023039"
	    ;;
	2713 )
	    surahAndAyahNumber="023040"
	    ;;
	2714 )
	    surahAndAyahNumber="023041"
	    ;;
	2715 )
	    surahAndAyahNumber="023042"
	    ;;
	2716 )
	    surahAndAyahNumber="023043"
	    ;;
	2717 )
	    surahAndAyahNumber="023044"
	    ;;
	2718 )
	    surahAndAyahNumber="023045"
	    ;;
	2719 )
	    surahAndAyahNumber="023046"
	    ;;
	2720 )
	    surahAndAyahNumber="023047"
	    ;;
	2721 )
	    surahAndAyahNumber="023048"
	    ;;
	2722 )
	    surahAndAyahNumber="023049"
	    ;;
	2723 )
	    surahAndAyahNumber="023050"
	    ;;
	2724 )
	    surahAndAyahNumber="023051"
	    ;;
	2725 )
	    surahAndAyahNumber="023052"
	    ;;
	2726 )
	    surahAndAyahNumber="023053"
	    ;;
	2727 )
	    surahAndAyahNumber="023054"
	    ;;
	2728 )
	    surahAndAyahNumber="023055"
	    ;;
	2729 )
	    surahAndAyahNumber="023056"
	    ;;
	2730 )
	    surahAndAyahNumber="023057"
	    ;;
	2731 )
	    surahAndAyahNumber="023058"
	    ;;
	2732 )
	    surahAndAyahNumber="023059"
	    ;;
	2733 )
	    surahAndAyahNumber="023060"
	    ;;
	2734 )
	    surahAndAyahNumber="023061"
	    ;;
	2735 )
	    surahAndAyahNumber="023062"
	    ;;
	2736 )
	    surahAndAyahNumber="023063"
	    ;;
	2737 )
	    surahAndAyahNumber="023064"
	    ;;
	2738 )
	    surahAndAyahNumber="023065"
	    ;;
	2739 )
	    surahAndAyahNumber="023066"
	    ;;
	2740 )
	    surahAndAyahNumber="023067"
	    ;;
	2741 )
	    surahAndAyahNumber="023068"
	    ;;
	2742 )
	    surahAndAyahNumber="023069"
	    ;;
	2743 )
	    surahAndAyahNumber="023070"
	    ;;
	2744 )
	    surahAndAyahNumber="023071"
	    ;;
	2745 )
	    surahAndAyahNumber="023072"
	    ;;
	2746 )
	    surahAndAyahNumber="023073"
	    ;;
	2747 )
	    surahAndAyahNumber="023074"
	    ;;
	2748 )
	    surahAndAyahNumber="023075"
	    ;;
	2749 )
	    surahAndAyahNumber="023076"
	    ;;
	2750 )
	    surahAndAyahNumber="023077"
	    ;;
	2751 )
	    surahAndAyahNumber="023078"
	    ;;
	2752 )
	    surahAndAyahNumber="023079"
	    ;;
	2753 )
	    surahAndAyahNumber="023080"
	    ;;
	2754 )
	    surahAndAyahNumber="023081"
	    ;;
	2755 )
	    surahAndAyahNumber="023082"
	    ;;
	2756 )
	    surahAndAyahNumber="023083"
	    ;;
	2757 )
	    surahAndAyahNumber="023084"
	    ;;
	2758 )
	    surahAndAyahNumber="023085"
	    ;;
	2759 )
	    surahAndAyahNumber="023086"
	    ;;
	2760 )
	    surahAndAyahNumber="023087"
	    ;;
	2761 )
	    surahAndAyahNumber="023088"
	    ;;
	2762 )
	    surahAndAyahNumber="023089"
	    ;;
	2763 )
	    surahAndAyahNumber="023090"
	    ;;
	2764 )
	    surahAndAyahNumber="023091"
	    ;;
	2765 )
	    surahAndAyahNumber="023092"
	    ;;
	2766 )
	    surahAndAyahNumber="023093"
	    ;;
	2767 )
	    surahAndAyahNumber="023094"
	    ;;
	2768 )
	    surahAndAyahNumber="023095"
	    ;;
	2769 )
	    surahAndAyahNumber="023096"
	    ;;
	2770 )
	    surahAndAyahNumber="023097"
	    ;;
	2771 )
	    surahAndAyahNumber="023098"
	    ;;
	2772 )
	    surahAndAyahNumber="023099"
	    ;;
	2773 )
	    surahAndAyahNumber="023100"
	    ;;
	2774 )
	    surahAndAyahNumber="023101"
	    ;;
	2775 )
	    surahAndAyahNumber="023102"
	    ;;
	2776 )
	    surahAndAyahNumber="023103"
	    ;;
	2777 )
	    surahAndAyahNumber="023104"
	    ;;
	2778 )
	    surahAndAyahNumber="023105"
	    ;;
	2779 )
	    surahAndAyahNumber="023106"
	    ;;
	2780 )
	    surahAndAyahNumber="023107"
	    ;;
	2781 )
	    surahAndAyahNumber="023108"
	    ;;
	2782 )
	    surahAndAyahNumber="023109"
	    ;;
	2783 )
	    surahAndAyahNumber="023110"
	    ;;
	2784 )
	    surahAndAyahNumber="023111"
	    ;;
	2785 )
	    surahAndAyahNumber="023112"
	    ;;
	2786 )
	    surahAndAyahNumber="023113"
	    ;;
	2787 )
	    surahAndAyahNumber="023114"
	    ;;
	2788 )
	    surahAndAyahNumber="023115"
	    ;;
	2789 )
	    surahAndAyahNumber="023116"
	    ;;
	2790 )
	    surahAndAyahNumber="023117"
	    ;;
	2791 )
	    surahAndAyahNumber="023118"
	    ;;
	2792 )
	    surahAndAyahNumber="024001"
	    ;;
	2793 )
	    surahAndAyahNumber="024002"
	    ;;
	2794 )
	    surahAndAyahNumber="024003"
	    ;;
	2795 )
	    surahAndAyahNumber="024004"
	    ;;
	2796 )
	    surahAndAyahNumber="024005"
	    ;;
	2797 )
	    surahAndAyahNumber="024006"
	    ;;
	2798 )
	    surahAndAyahNumber="024007"
	    ;;
	2799 )
	    surahAndAyahNumber="024008"
	    ;;
	2800 )
	    surahAndAyahNumber="024009"
	    ;;
	2801 )
	    surahAndAyahNumber="024010"
	    ;;
	2802 )
	    surahAndAyahNumber="024011"
	    ;;
	2803 )
	    surahAndAyahNumber="024012"
	    ;;
	2804 )
	    surahAndAyahNumber="024013"
	    ;;
	2805 )
	    surahAndAyahNumber="024014"
	    ;;
	2806 )
	    surahAndAyahNumber="024015"
	    ;;
	2807 )
	    surahAndAyahNumber="024016"
	    ;;
	2808 )
	    surahAndAyahNumber="024017"
	    ;;
	2809 )
	    surahAndAyahNumber="024018"
	    ;;
	2810 )
	    surahAndAyahNumber="024019"
	    ;;
	2811 )
	    surahAndAyahNumber="024020"
	    ;;
	2812 )
	    surahAndAyahNumber="024021"
	    ;;
	2813 )
	    surahAndAyahNumber="024022"
	    ;;
	2814 )
	    surahAndAyahNumber="024023"
	    ;;
	2815 )
	    surahAndAyahNumber="024024"
	    ;;
	2816 )
	    surahAndAyahNumber="024025"
	    ;;
	2817 )
	    surahAndAyahNumber="024026"
	    ;;
	2818 )
	    surahAndAyahNumber="024027"
	    ;;
	2819 )
	    surahAndAyahNumber="024028"
	    ;;
	2820 )
	    surahAndAyahNumber="024029"
	    ;;
	2821 )
	    surahAndAyahNumber="024030"
	    ;;
	2822 )
	    surahAndAyahNumber="024031"
	    ;;
	2823 )
	    surahAndAyahNumber="024032"
	    ;;
	2824 )
	    surahAndAyahNumber="024033"
	    ;;
	2825 )
	    surahAndAyahNumber="024034"
	    ;;
	2826 )
	    surahAndAyahNumber="024035"
	    ;;
	2827 )
	    surahAndAyahNumber="024036"
	    ;;
	2828 )
	    surahAndAyahNumber="024037"
	    ;;
	2829 )
	    surahAndAyahNumber="024038"
	    ;;
	2830 )
	    surahAndAyahNumber="024039"
	    ;;
	2831 )
	    surahAndAyahNumber="024040"
	    ;;
	2832 )
	    surahAndAyahNumber="024041"
	    ;;
	2833 )
	    surahAndAyahNumber="024042"
	    ;;
	2834 )
	    surahAndAyahNumber="024043"
	    ;;
	2835 )
	    surahAndAyahNumber="024044"
	    ;;
	2836 )
	    surahAndAyahNumber="024045"
	    ;;
	2837 )
	    surahAndAyahNumber="024046"
	    ;;
	2838 )
	    surahAndAyahNumber="024047"
	    ;;
	2839 )
	    surahAndAyahNumber="024048"
	    ;;
	2840 )
	    surahAndAyahNumber="024049"
	    ;;
	2841 )
	    surahAndAyahNumber="024050"
	    ;;
	2842 )
	    surahAndAyahNumber="024051"
	    ;;
	2843 )
	    surahAndAyahNumber="024052"
	    ;;
	2844 )
	    surahAndAyahNumber="024053"
	    ;;
	2845 )
	    surahAndAyahNumber="024054"
	    ;;
	2846 )
	    surahAndAyahNumber="024055"
	    ;;
	2847 )
	    surahAndAyahNumber="024056"
	    ;;
	2848 )
	    surahAndAyahNumber="024057"
	    ;;
	2849 )
	    surahAndAyahNumber="024058"
	    ;;
	2850 )
	    surahAndAyahNumber="024059"
	    ;;
	2851 )
	    surahAndAyahNumber="024060"
	    ;;
	2852 )
	    surahAndAyahNumber="024061"
	    ;;
	2853 )
	    surahAndAyahNumber="024062"
	    ;;
	2854 )
	    surahAndAyahNumber="024063"
	    ;;
	2855 )
	    surahAndAyahNumber="024064"
	    ;;
	2856 )
	    surahAndAyahNumber="025001"
	    ;;
	2857 )
	    surahAndAyahNumber="025002"
	    ;;
	2858 )
	    surahAndAyahNumber="025003"
	    ;;
	2859 )
	    surahAndAyahNumber="025004"
	    ;;
	2860 )
	    surahAndAyahNumber="025005"
	    ;;
	2861 )
	    surahAndAyahNumber="025006"
	    ;;
	2862 )
	    surahAndAyahNumber="025007"
	    ;;
	2863 )
	    surahAndAyahNumber="025008"
	    ;;
	2864 )
	    surahAndAyahNumber="025009"
	    ;;
	2865 )
	    surahAndAyahNumber="025010"
	    ;;
	2866 )
	    surahAndAyahNumber="025011"
	    ;;
	2867 )
	    surahAndAyahNumber="025012"
	    ;;
	2868 )
	    surahAndAyahNumber="025013"
	    ;;
	2869 )
	    surahAndAyahNumber="025014"
	    ;;
	2870 )
	    surahAndAyahNumber="025015"
	    ;;
	2871 )
	    surahAndAyahNumber="025016"
	    ;;
	2872 )
	    surahAndAyahNumber="025017"
	    ;;
	2873 )
	    surahAndAyahNumber="025018"
	    ;;
	2874 )
	    surahAndAyahNumber="025019"
	    ;;
	2875 )
	    surahAndAyahNumber="025020"
	    ;;
	2876 )
	    surahAndAyahNumber="025021"
	    ;;
	2877 )
	    surahAndAyahNumber="025022"
	    ;;
	2878 )
	    surahAndAyahNumber="025023"
	    ;;
	2879 )
	    surahAndAyahNumber="025024"
	    ;;
	2880 )
	    surahAndAyahNumber="025025"
	    ;;
	2881 )
	    surahAndAyahNumber="025026"
	    ;;
	2882 )
	    surahAndAyahNumber="025027"
	    ;;
	2883 )
	    surahAndAyahNumber="025028"
	    ;;
	2884 )
	    surahAndAyahNumber="025029"
	    ;;
	2885 )
	    surahAndAyahNumber="025030"
	    ;;
	2886 )
	    surahAndAyahNumber="025031"
	    ;;
	2887 )
	    surahAndAyahNumber="025032"
	    ;;
	2888 )
	    surahAndAyahNumber="025033"
	    ;;
	2889 )
	    surahAndAyahNumber="025034"
	    ;;
	2890 )
	    surahAndAyahNumber="025035"
	    ;;
	2891 )
	    surahAndAyahNumber="025036"
	    ;;
	2892 )
	    surahAndAyahNumber="025037"
	    ;;
	2893 )
	    surahAndAyahNumber="025038"
	    ;;
	2894 )
	    surahAndAyahNumber="025039"
	    ;;
	2895 )
	    surahAndAyahNumber="025040"
	    ;;
	2896 )
	    surahAndAyahNumber="025041"
	    ;;
	2897 )
	    surahAndAyahNumber="025042"
	    ;;
	2898 )
	    surahAndAyahNumber="025043"
	    ;;
	2899 )
	    surahAndAyahNumber="025044"
	    ;;
	2900 )
	    surahAndAyahNumber="025045"
	    ;;
	2901 )
	    surahAndAyahNumber="025046"
	    ;;
	2902 )
	    surahAndAyahNumber="025047"
	    ;;
	2903 )
	    surahAndAyahNumber="025048"
	    ;;
	2904 )
	    surahAndAyahNumber="025049"
	    ;;
	2905 )
	    surahAndAyahNumber="025050"
	    ;;
	2906 )
	    surahAndAyahNumber="025051"
	    ;;
	2907 )
	    surahAndAyahNumber="025052"
	    ;;
	2908 )
	    surahAndAyahNumber="025053"
	    ;;
	2909 )
	    surahAndAyahNumber="025054"
	    ;;
	2910 )
	    surahAndAyahNumber="025055"
	    ;;
	2911 )
	    surahAndAyahNumber="025056"
	    ;;
	2912 )
	    surahAndAyahNumber="025057"
	    ;;
	2913 )
	    surahAndAyahNumber="025058"
	    ;;
	2914 )
	    surahAndAyahNumber="025059"
	    ;;
	2915 )
	    surahAndAyahNumber="025060"
	    ;;
	2916 )
	    surahAndAyahNumber="025061"
	    ;;
	2917 )
	    surahAndAyahNumber="025062"
	    ;;
	2918 )
	    surahAndAyahNumber="025063"
	    ;;
	2919 )
	    surahAndAyahNumber="025064"
	    ;;
	2920 )
	    surahAndAyahNumber="025065"
	    ;;
	2921 )
	    surahAndAyahNumber="025066"
	    ;;
	2922 )
	    surahAndAyahNumber="025067"
	    ;;
	2923 )
	    surahAndAyahNumber="025068"
	    ;;
	2924 )
	    surahAndAyahNumber="025069"
	    ;;
	2925 )
	    surahAndAyahNumber="025070"
	    ;;
	2926 )
	    surahAndAyahNumber="025071"
	    ;;
	2927 )
	    surahAndAyahNumber="025072"
	    ;;
	2928 )
	    surahAndAyahNumber="025073"
	    ;;
	2929 )
	    surahAndAyahNumber="025074"
	    ;;
	2930 )
	    surahAndAyahNumber="025075"
	    ;;
	2931 )
	    surahAndAyahNumber="025076"
	    ;;
	2932 )
	    surahAndAyahNumber="025077"
	    ;;
	2933 )
	    surahAndAyahNumber="026001"
	    ;;
	2934 )
	    surahAndAyahNumber="026002"
	    ;;
	2935 )
	    surahAndAyahNumber="026003"
	    ;;
	2936 )
	    surahAndAyahNumber="026004"
	    ;;
	2937 )
	    surahAndAyahNumber="026005"
	    ;;
	2938 )
	    surahAndAyahNumber="026006"
	    ;;
	2939 )
	    surahAndAyahNumber="026007"
	    ;;
	2940 )
	    surahAndAyahNumber="026008"
	    ;;
	2941 )
	    surahAndAyahNumber="026009"
	    ;;
	2942 )
	    surahAndAyahNumber="026010"
	    ;;
	2943 )
	    surahAndAyahNumber="026011"
	    ;;
	2944 )
	    surahAndAyahNumber="026012"
	    ;;
	2945 )
	    surahAndAyahNumber="026013"
	    ;;
	2946 )
	    surahAndAyahNumber="026014"
	    ;;
	2947 )
	    surahAndAyahNumber="026015"
	    ;;
	2948 )
	    surahAndAyahNumber="026016"
	    ;;
	2949 )
	    surahAndAyahNumber="026017"
	    ;;
	2950 )
	    surahAndAyahNumber="026018"
	    ;;
	2951 )
	    surahAndAyahNumber="026019"
	    ;;
	2952 )
	    surahAndAyahNumber="026020"
	    ;;
	2953 )
	    surahAndAyahNumber="026021"
	    ;;
	2954 )
	    surahAndAyahNumber="026022"
	    ;;
	2955 )
	    surahAndAyahNumber="026023"
	    ;;
	2956 )
	    surahAndAyahNumber="026024"
	    ;;
	2957 )
	    surahAndAyahNumber="026025"
	    ;;
	2958 )
	    surahAndAyahNumber="026026"
	    ;;
	2959 )
	    surahAndAyahNumber="026027"
	    ;;
	2960 )
	    surahAndAyahNumber="026028"
	    ;;
	2961 )
	    surahAndAyahNumber="026029"
	    ;;
	2962 )
	    surahAndAyahNumber="026030"
	    ;;
	2963 )
	    surahAndAyahNumber="026031"
	    ;;
	2964 )
	    surahAndAyahNumber="026032"
	    ;;
	2965 )
	    surahAndAyahNumber="026033"
	    ;;
	2966 )
	    surahAndAyahNumber="026034"
	    ;;
	2967 )
	    surahAndAyahNumber="026035"
	    ;;
	2968 )
	    surahAndAyahNumber="026036"
	    ;;
	2969 )
	    surahAndAyahNumber="026037"
	    ;;
	2970 )
	    surahAndAyahNumber="026038"
	    ;;
	2971 )
	    surahAndAyahNumber="026039"
	    ;;
	2972 )
	    surahAndAyahNumber="026040"
	    ;;
	2973 )
	    surahAndAyahNumber="026041"
	    ;;
	2974 )
	    surahAndAyahNumber="026042"
	    ;;
	2975 )
	    surahAndAyahNumber="026043"
	    ;;
	2976 )
	    surahAndAyahNumber="026044"
	    ;;
	2977 )
	    surahAndAyahNumber="026045"
	    ;;
	2978 )
	    surahAndAyahNumber="026046"
	    ;;
	2979 )
	    surahAndAyahNumber="026047"
	    ;;
	2980 )
	    surahAndAyahNumber="026048"
	    ;;
	2981 )
	    surahAndAyahNumber="026049"
	    ;;
	2982 )
	    surahAndAyahNumber="026050"
	    ;;
	2983 )
	    surahAndAyahNumber="026051"
	    ;;
	2984 )
	    surahAndAyahNumber="026052"
	    ;;
	2985 )
	    surahAndAyahNumber="026053"
	    ;;
	2986 )
	    surahAndAyahNumber="026054"
	    ;;
	2987 )
	    surahAndAyahNumber="026055"
	    ;;
	2988 )
	    surahAndAyahNumber="026056"
	    ;;
	2989 )
	    surahAndAyahNumber="026057"
	    ;;
	2990 )
	    surahAndAyahNumber="026058"
	    ;;
	2991 )
	    surahAndAyahNumber="026059"
	    ;;
	2992 )
	    surahAndAyahNumber="026060"
	    ;;
	2993 )
	    surahAndAyahNumber="026061"
	    ;;
	2994 )
	    surahAndAyahNumber="026062"
	    ;;
	2995 )
	    surahAndAyahNumber="026063"
	    ;;
	2996 )
	    surahAndAyahNumber="026064"
	    ;;
	2997 )
	    surahAndAyahNumber="026065"
	    ;;
	2998 )
	    surahAndAyahNumber="026066"
	    ;;
	2999 )
	    surahAndAyahNumber="026067"
	    ;;
	3000 )
	    surahAndAyahNumber="026068"
	    ;;
	3001 )
	    surahAndAyahNumber="026069"
	    ;;
	3002 )
	    surahAndAyahNumber="026070"
	    ;;
	3003 )
	    surahAndAyahNumber="026071"
	    ;;
	3004 )
	    surahAndAyahNumber="026072"
	    ;;
	3005 )
	    surahAndAyahNumber="026073"
	    ;;
	3006 )
	    surahAndAyahNumber="026074"
	    ;;
	3007 )
	    surahAndAyahNumber="026075"
	    ;;
	3008 )
	    surahAndAyahNumber="026076"
	    ;;
	3009 )
	    surahAndAyahNumber="026077"
	    ;;
	3010 )
	    surahAndAyahNumber="026078"
	    ;;
	3011 )
	    surahAndAyahNumber="026079"
	    ;;
	3012 )
	    surahAndAyahNumber="026080"
	    ;;
	3013 )
	    surahAndAyahNumber="026081"
	    ;;
	3014 )
	    surahAndAyahNumber="026082"
	    ;;
	3015 )
	    surahAndAyahNumber="026083"
	    ;;
	3016 )
	    surahAndAyahNumber="026084"
	    ;;
	3017 )
	    surahAndAyahNumber="026085"
	    ;;
	3018 )
	    surahAndAyahNumber="026086"
	    ;;
	3019 )
	    surahAndAyahNumber="026087"
	    ;;
	3020 )
	    surahAndAyahNumber="026088"
	    ;;
	3021 )
	    surahAndAyahNumber="026089"
	    ;;
	3022 )
	    surahAndAyahNumber="026090"
	    ;;
	3023 )
	    surahAndAyahNumber="026091"
	    ;;
	3024 )
	    surahAndAyahNumber="026092"
	    ;;
	3025 )
	    surahAndAyahNumber="026093"
	    ;;
	3026 )
	    surahAndAyahNumber="026094"
	    ;;
	3027 )
	    surahAndAyahNumber="026095"
	    ;;
	3028 )
	    surahAndAyahNumber="026096"
	    ;;
	3029 )
	    surahAndAyahNumber="026097"
	    ;;
	3030 )
	    surahAndAyahNumber="026098"
	    ;;
	3031 )
	    surahAndAyahNumber="026099"
	    ;;
	3032 )
	    surahAndAyahNumber="026100"
	    ;;
	3033 )
	    surahAndAyahNumber="026101"
	    ;;
	3034 )
	    surahAndAyahNumber="026102"
	    ;;
	3035 )
	    surahAndAyahNumber="026103"
	    ;;
	3036 )
	    surahAndAyahNumber="026104"
	    ;;
	3037 )
	    surahAndAyahNumber="026105"
	    ;;
	3038 )
	    surahAndAyahNumber="026106"
	    ;;
	3039 )
	    surahAndAyahNumber="026107"
	    ;;
	3040 )
	    surahAndAyahNumber="026108"
	    ;;
	3041 )
	    surahAndAyahNumber="026109"
	    ;;
	3042 )
	    surahAndAyahNumber="026110"
	    ;;
	3043 )
	    surahAndAyahNumber="026111"
	    ;;
	3044 )
	    surahAndAyahNumber="026112"
	    ;;
	3045 )
	    surahAndAyahNumber="026113"
	    ;;
	3046 )
	    surahAndAyahNumber="026114"
	    ;;
	3047 )
	    surahAndAyahNumber="026115"
	    ;;
	3048 )
	    surahAndAyahNumber="026116"
	    ;;
	3049 )
	    surahAndAyahNumber="026117"
	    ;;
	3050 )
	    surahAndAyahNumber="026118"
	    ;;
	3051 )
	    surahAndAyahNumber="026119"
	    ;;
	3052 )
	    surahAndAyahNumber="026120"
	    ;;
	3053 )
	    surahAndAyahNumber="026121"
	    ;;
	3054 )
	    surahAndAyahNumber="026122"
	    ;;
	3055 )
	    surahAndAyahNumber="026123"
	    ;;
	3056 )
	    surahAndAyahNumber="026124"
	    ;;
	3057 )
	    surahAndAyahNumber="026125"
	    ;;
	3058 )
	    surahAndAyahNumber="026126"
	    ;;
	3059 )
	    surahAndAyahNumber="026127"
	    ;;
	3060 )
	    surahAndAyahNumber="026128"
	    ;;
	3061 )
	    surahAndAyahNumber="026129"
	    ;;
	3062 )
	    surahAndAyahNumber="026130"
	    ;;
	3063 )
	    surahAndAyahNumber="026131"
	    ;;
	3064 )
	    surahAndAyahNumber="026132"
	    ;;
	3065 )
	    surahAndAyahNumber="026133"
	    ;;
	3066 )
	    surahAndAyahNumber="026134"
	    ;;
	3067 )
	    surahAndAyahNumber="026135"
	    ;;
	3068 )
	    surahAndAyahNumber="026136"
	    ;;
	3069 )
	    surahAndAyahNumber="026137"
	    ;;
	3070 )
	    surahAndAyahNumber="026138"
	    ;;
	3071 )
	    surahAndAyahNumber="026139"
	    ;;
	3072 )
	    surahAndAyahNumber="026140"
	    ;;
	3073 )
	    surahAndAyahNumber="026141"
	    ;;
	3074 )
	    surahAndAyahNumber="026142"
	    ;;
	3075 )
	    surahAndAyahNumber="026143"
	    ;;
	3076 )
	    surahAndAyahNumber="026144"
	    ;;
	3077 )
	    surahAndAyahNumber="026145"
	    ;;
	3078 )
	    surahAndAyahNumber="026146"
	    ;;
	3079 )
	    surahAndAyahNumber="026147"
	    ;;
	3080 )
	    surahAndAyahNumber="026148"
	    ;;
	3081 )
	    surahAndAyahNumber="026149"
	    ;;
	3082 )
	    surahAndAyahNumber="026150"
	    ;;
	3083 )
	    surahAndAyahNumber="026151"
	    ;;
	3084 )
	    surahAndAyahNumber="026152"
	    ;;
	3085 )
	    surahAndAyahNumber="026153"
	    ;;
	3086 )
	    surahAndAyahNumber="026154"
	    ;;
	3087 )
	    surahAndAyahNumber="026155"
	    ;;
	3088 )
	    surahAndAyahNumber="026156"
	    ;;
	3089 )
	    surahAndAyahNumber="026157"
	    ;;
	3090 )
	    surahAndAyahNumber="026158"
	    ;;
	3091 )
	    surahAndAyahNumber="026159"
	    ;;
	3092 )
	    surahAndAyahNumber="026160"
	    ;;
	3093 )
	    surahAndAyahNumber="026161"
	    ;;
	3094 )
	    surahAndAyahNumber="026162"
	    ;;
	3095 )
	    surahAndAyahNumber="026163"
	    ;;
	3096 )
	    surahAndAyahNumber="026164"
	    ;;
	3097 )
	    surahAndAyahNumber="026165"
	    ;;
	3098 )
	    surahAndAyahNumber="026166"
	    ;;
	3099 )
	    surahAndAyahNumber="026167"
	    ;;
	3100 )
	    surahAndAyahNumber="026168"
	    ;;
	3101 )
	    surahAndAyahNumber="026169"
	    ;;
	3102 )
	    surahAndAyahNumber="026170"
	    ;;
	3103 )
	    surahAndAyahNumber="026171"
	    ;;
	3104 )
	    surahAndAyahNumber="026172"
	    ;;
	3105 )
	    surahAndAyahNumber="026173"
	    ;;
	3106 )
	    surahAndAyahNumber="026174"
	    ;;
	3107 )
	    surahAndAyahNumber="026175"
	    ;;
	3108 )
	    surahAndAyahNumber="026176"
	    ;;
	3109 )
	    surahAndAyahNumber="026177"
	    ;;
	3110 )
	    surahAndAyahNumber="026178"
	    ;;
	3111 )
	    surahAndAyahNumber="026179"
	    ;;
	3112 )
	    surahAndAyahNumber="026180"
	    ;;
	3113 )
	    surahAndAyahNumber="026181"
	    ;;
	3114 )
	    surahAndAyahNumber="026182"
	    ;;
	3115 )
	    surahAndAyahNumber="026183"
	    ;;
	3116 )
	    surahAndAyahNumber="026184"
	    ;;
	3117 )
	    surahAndAyahNumber="026185"
	    ;;
	3118 )
	    surahAndAyahNumber="026186"
	    ;;
	3119 )
	    surahAndAyahNumber="026187"
	    ;;
	3120 )
	    surahAndAyahNumber="026188"
	    ;;
	3121 )
	    surahAndAyahNumber="026189"
	    ;;
	3122 )
	    surahAndAyahNumber="026190"
	    ;;
	3123 )
	    surahAndAyahNumber="026191"
	    ;;
	3124 )
	    surahAndAyahNumber="026192"
	    ;;
	3125 )
	    surahAndAyahNumber="026193"
	    ;;
	3126 )
	    surahAndAyahNumber="026194"
	    ;;
	3127 )
	    surahAndAyahNumber="026195"
	    ;;
	3128 )
	    surahAndAyahNumber="026196"
	    ;;
	3129 )
	    surahAndAyahNumber="026197"
	    ;;
	3130 )
	    surahAndAyahNumber="026198"
	    ;;
	3131 )
	    surahAndAyahNumber="026199"
	    ;;
	3132 )
	    surahAndAyahNumber="026200"
	    ;;
	3133 )
	    surahAndAyahNumber="026201"
	    ;;
	3134 )
	    surahAndAyahNumber="026202"
	    ;;
	3135 )
	    surahAndAyahNumber="026203"
	    ;;
	3136 )
	    surahAndAyahNumber="026204"
	    ;;
	3137 )
	    surahAndAyahNumber="026205"
	    ;;
	3138 )
	    surahAndAyahNumber="026206"
	    ;;
	3139 )
	    surahAndAyahNumber="026207"
	    ;;
	3140 )
	    surahAndAyahNumber="026208"
	    ;;
	3141 )
	    surahAndAyahNumber="026209"
	    ;;
	3142 )
	    surahAndAyahNumber="026210"
	    ;;
	3143 )
	    surahAndAyahNumber="026211"
	    ;;
	3144 )
	    surahAndAyahNumber="026212"
	    ;;
	3145 )
	    surahAndAyahNumber="026213"
	    ;;
	3146 )
	    surahAndAyahNumber="026214"
	    ;;
	3147 )
	    surahAndAyahNumber="026215"
	    ;;
	3148 )
	    surahAndAyahNumber="026216"
	    ;;
	3149 )
	    surahAndAyahNumber="026217"
	    ;;
	3150 )
	    surahAndAyahNumber="026218"
	    ;;
	3151 )
	    surahAndAyahNumber="026219"
	    ;;
	3152 )
	    surahAndAyahNumber="026220"
	    ;;
	3153 )
	    surahAndAyahNumber="026221"
	    ;;
	3154 )
	    surahAndAyahNumber="026222"
	    ;;
	3155 )
	    surahAndAyahNumber="026223"
	    ;;
	3156 )
	    surahAndAyahNumber="026224"
	    ;;
	3157 )
	    surahAndAyahNumber="026225"
	    ;;
	3158 )
	    surahAndAyahNumber="026226"
	    ;;
	3159 )
	    surahAndAyahNumber="026227"
	    ;;
	3160 )
	    surahAndAyahNumber="027001"
	    ;;
	3161 )
	    surahAndAyahNumber="027002"
	    ;;
	3162 )
	    surahAndAyahNumber="027003"
	    ;;
	3163 )
	    surahAndAyahNumber="027004"
	    ;;
	3164 )
	    surahAndAyahNumber="027005"
	    ;;
	3165 )
	    surahAndAyahNumber="027006"
	    ;;
	3166 )
	    surahAndAyahNumber="027007"
	    ;;
	3167 )
	    surahAndAyahNumber="027008"
	    ;;
	3168 )
	    surahAndAyahNumber="027009"
	    ;;
	3169 )
	    surahAndAyahNumber="027010"
	    ;;
	3170 )
	    surahAndAyahNumber="027011"
	    ;;
	3171 )
	    surahAndAyahNumber="027012"
	    ;;
	3172 )
	    surahAndAyahNumber="027013"
	    ;;
	3173 )
	    surahAndAyahNumber="027014"
	    ;;
	3174 )
	    surahAndAyahNumber="027015"
	    ;;
	3175 )
	    surahAndAyahNumber="027016"
	    ;;
	3176 )
	    surahAndAyahNumber="027017"
	    ;;
	3177 )
	    surahAndAyahNumber="027018"
	    ;;
	3178 )
	    surahAndAyahNumber="027019"
	    ;;
	3179 )
	    surahAndAyahNumber="027020"
	    ;;
	3180 )
	    surahAndAyahNumber="027021"
	    ;;
	3181 )
	    surahAndAyahNumber="027022"
	    ;;
	3182 )
	    surahAndAyahNumber="027023"
	    ;;
	3183 )
	    surahAndAyahNumber="027024"
	    ;;
	3184 )
	    surahAndAyahNumber="027025"
	    ;;
	3185 )
	    surahAndAyahNumber="027026"
	    ;;
	3186 )
	    surahAndAyahNumber="027027"
	    ;;
	3187 )
	    surahAndAyahNumber="027028"
	    ;;
	3188 )
	    surahAndAyahNumber="027029"
	    ;;
	3189 )
	    surahAndAyahNumber="027030"
	    ;;
	3190 )
	    surahAndAyahNumber="027031"
	    ;;
	3191 )
	    surahAndAyahNumber="027032"
	    ;;
	3192 )
	    surahAndAyahNumber="027033"
	    ;;
	3193 )
	    surahAndAyahNumber="027034"
	    ;;
	3194 )
	    surahAndAyahNumber="027035"
	    ;;
	3195 )
	    surahAndAyahNumber="027036"
	    ;;
	3196 )
	    surahAndAyahNumber="027037"
	    ;;
	3197 )
	    surahAndAyahNumber="027038"
	    ;;
	3198 )
	    surahAndAyahNumber="027039"
	    ;;
	3199 )
	    surahAndAyahNumber="027040"
	    ;;
	3200 )
	    surahAndAyahNumber="027041"
	    ;;
	3201 )
	    surahAndAyahNumber="027042"
	    ;;
	3202 )
	    surahAndAyahNumber="027043"
	    ;;
	3203 )
	    surahAndAyahNumber="027044"
	    ;;
	3204 )
	    surahAndAyahNumber="027045"
	    ;;
	3205 )
	    surahAndAyahNumber="027046"
	    ;;
	3206 )
	    surahAndAyahNumber="027047"
	    ;;
	3207 )
	    surahAndAyahNumber="027048"
	    ;;
	3208 )
	    surahAndAyahNumber="027049"
	    ;;
	3209 )
	    surahAndAyahNumber="027050"
	    ;;
	3210 )
	    surahAndAyahNumber="027051"
	    ;;
	3211 )
	    surahAndAyahNumber="027052"
	    ;;
	3212 )
	    surahAndAyahNumber="027053"
	    ;;
	3213 )
	    surahAndAyahNumber="027054"
	    ;;
	3214 )
	    surahAndAyahNumber="027055"
	    ;;
	3215 )
	    surahAndAyahNumber="027056"
	    ;;
	3216 )
	    surahAndAyahNumber="027057"
	    ;;
	3217 )
	    surahAndAyahNumber="027058"
	    ;;
	3218 )
	    surahAndAyahNumber="027059"
	    ;;
	3219 )
	    surahAndAyahNumber="027060"
	    ;;
	3220 )
	    surahAndAyahNumber="027061"
	    ;;
	3221 )
	    surahAndAyahNumber="027062"
	    ;;
	3222 )
	    surahAndAyahNumber="027063"
	    ;;
	3223 )
	    surahAndAyahNumber="027064"
	    ;;
	3224 )
	    surahAndAyahNumber="027065"
	    ;;
	3225 )
	    surahAndAyahNumber="027066"
	    ;;
	3226 )
	    surahAndAyahNumber="027067"
	    ;;
	3227 )
	    surahAndAyahNumber="027068"
	    ;;
	3228 )
	    surahAndAyahNumber="027069"
	    ;;
	3229 )
	    surahAndAyahNumber="027070"
	    ;;
	3230 )
	    surahAndAyahNumber="027071"
	    ;;
	3231 )
	    surahAndAyahNumber="027072"
	    ;;
	3232 )
	    surahAndAyahNumber="027073"
	    ;;
	3233 )
	    surahAndAyahNumber="027074"
	    ;;
	3234 )
	    surahAndAyahNumber="027075"
	    ;;
	3235 )
	    surahAndAyahNumber="027076"
	    ;;
	3236 )
	    surahAndAyahNumber="027077"
	    ;;
	3237 )
	    surahAndAyahNumber="027078"
	    ;;
	3238 )
	    surahAndAyahNumber="027079"
	    ;;
	3239 )
	    surahAndAyahNumber="027080"
	    ;;
	3240 )
	    surahAndAyahNumber="027081"
	    ;;
	3241 )
	    surahAndAyahNumber="027082"
	    ;;
	3242 )
	    surahAndAyahNumber="027083"
	    ;;
	3243 )
	    surahAndAyahNumber="027084"
	    ;;
	3244 )
	    surahAndAyahNumber="027085"
	    ;;
	3245 )
	    surahAndAyahNumber="027086"
	    ;;
	3246 )
	    surahAndAyahNumber="027087"
	    ;;
	3247 )
	    surahAndAyahNumber="027088"
	    ;;
	3248 )
	    surahAndAyahNumber="027089"
	    ;;
	3249 )
	    surahAndAyahNumber="027090"
	    ;;
	3250 )
	    surahAndAyahNumber="027091"
	    ;;
	3251 )
	    surahAndAyahNumber="027092"
	    ;;
	3252 )
	    surahAndAyahNumber="027093"
	    ;;
	3253 )
	    surahAndAyahNumber="028001"
	    ;;
	3254 )
	    surahAndAyahNumber="028002"
	    ;;
	3255 )
	    surahAndAyahNumber="028003"
	    ;;
	3256 )
	    surahAndAyahNumber="028004"
	    ;;
	3257 )
	    surahAndAyahNumber="028005"
	    ;;
	3258 )
	    surahAndAyahNumber="028006"
	    ;;
	3259 )
	    surahAndAyahNumber="028007"
	    ;;
	3260 )
	    surahAndAyahNumber="028008"
	    ;;
	3261 )
	    surahAndAyahNumber="028009"
	    ;;
	3262 )
	    surahAndAyahNumber="028010"
	    ;;
	3263 )
	    surahAndAyahNumber="028011"
	    ;;
	3264 )
	    surahAndAyahNumber="028012"
	    ;;
	3265 )
	    surahAndAyahNumber="028013"
	    ;;
	3266 )
	    surahAndAyahNumber="028014"
	    ;;
	3267 )
	    surahAndAyahNumber="028015"
	    ;;
	3268 )
	    surahAndAyahNumber="028016"
	    ;;
	3269 )
	    surahAndAyahNumber="028017"
	    ;;
	3270 )
	    surahAndAyahNumber="028018"
	    ;;
	3271 )
	    surahAndAyahNumber="028019"
	    ;;
	3272 )
	    surahAndAyahNumber="028020"
	    ;;
	3273 )
	    surahAndAyahNumber="028021"
	    ;;
	3274 )
	    surahAndAyahNumber="028022"
	    ;;
	3275 )
	    surahAndAyahNumber="028023"
	    ;;
	3276 )
	    surahAndAyahNumber="028024"
	    ;;
	3277 )
	    surahAndAyahNumber="028025"
	    ;;
	3278 )
	    surahAndAyahNumber="028026"
	    ;;
	3279 )
	    surahAndAyahNumber="028027"
	    ;;
	3280 )
	    surahAndAyahNumber="028028"
	    ;;
	3281 )
	    surahAndAyahNumber="028029"
	    ;;
	3282 )
	    surahAndAyahNumber="028030"
	    ;;
	3283 )
	    surahAndAyahNumber="028031"
	    ;;
	3284 )
	    surahAndAyahNumber="028032"
	    ;;
	3285 )
	    surahAndAyahNumber="028033"
	    ;;
	3286 )
	    surahAndAyahNumber="028034"
	    ;;
	3287 )
	    surahAndAyahNumber="028035"
	    ;;
	3288 )
	    surahAndAyahNumber="028036"
	    ;;
	3289 )
	    surahAndAyahNumber="028037"
	    ;;
	3290 )
	    surahAndAyahNumber="028038"
	    ;;
	3291 )
	    surahAndAyahNumber="028039"
	    ;;
	3292 )
	    surahAndAyahNumber="028040"
	    ;;
	3293 )
	    surahAndAyahNumber="028041"
	    ;;
	3294 )
	    surahAndAyahNumber="028042"
	    ;;
	3295 )
	    surahAndAyahNumber="028043"
	    ;;
	3296 )
	    surahAndAyahNumber="028044"
	    ;;
	3297 )
	    surahAndAyahNumber="028045"
	    ;;
	3298 )
	    surahAndAyahNumber="028046"
	    ;;
	3299 )
	    surahAndAyahNumber="028047"
	    ;;
	3300 )
	    surahAndAyahNumber="028048"
	    ;;
	3301 )
	    surahAndAyahNumber="028049"
	    ;;
	3302 )
	    surahAndAyahNumber="028050"
	    ;;
	3303 )
	    surahAndAyahNumber="028051"
	    ;;
	3304 )
	    surahAndAyahNumber="028052"
	    ;;
	3305 )
	    surahAndAyahNumber="028053"
	    ;;
	3306 )
	    surahAndAyahNumber="028054"
	    ;;
	3307 )
	    surahAndAyahNumber="028055"
	    ;;
	3308 )
	    surahAndAyahNumber="028056"
	    ;;
	3309 )
	    surahAndAyahNumber="028057"
	    ;;
	3310 )
	    surahAndAyahNumber="028058"
	    ;;
	3311 )
	    surahAndAyahNumber="028059"
	    ;;
	3312 )
	    surahAndAyahNumber="028060"
	    ;;
	3313 )
	    surahAndAyahNumber="028061"
	    ;;
	3314 )
	    surahAndAyahNumber="028062"
	    ;;
	3315 )
	    surahAndAyahNumber="028063"
	    ;;
	3316 )
	    surahAndAyahNumber="028064"
	    ;;
	3317 )
	    surahAndAyahNumber="028065"
	    ;;
	3318 )
	    surahAndAyahNumber="028066"
	    ;;
	3319 )
	    surahAndAyahNumber="028067"
	    ;;
	3320 )
	    surahAndAyahNumber="028068"
	    ;;
	3321 )
	    surahAndAyahNumber="028069"
	    ;;
	3322 )
	    surahAndAyahNumber="028070"
	    ;;
	3323 )
	    surahAndAyahNumber="028071"
	    ;;
	3324 )
	    surahAndAyahNumber="028072"
	    ;;
	3325 )
	    surahAndAyahNumber="028073"
	    ;;
	3326 )
	    surahAndAyahNumber="028074"
	    ;;
	3327 )
	    surahAndAyahNumber="028075"
	    ;;
	3328 )
	    surahAndAyahNumber="028076"
	    ;;
	3329 )
	    surahAndAyahNumber="028077"
	    ;;
	3330 )
	    surahAndAyahNumber="028078"
	    ;;
	3331 )
	    surahAndAyahNumber="028079"
	    ;;
	3332 )
	    surahAndAyahNumber="028080"
	    ;;
	3333 )
	    surahAndAyahNumber="028081"
	    ;;
	3334 )
	    surahAndAyahNumber="028082"
	    ;;
	3335 )
	    surahAndAyahNumber="028083"
	    ;;
	3336 )
	    surahAndAyahNumber="028084"
	    ;;
	3337 )
	    surahAndAyahNumber="028085"
	    ;;
	3338 )
	    surahAndAyahNumber="028086"
	    ;;
	3339 )
	    surahAndAyahNumber="028087"
	    ;;
	3340 )
	    surahAndAyahNumber="028088"
	    ;;
	3341 )
	    surahAndAyahNumber="029001"
	    ;;
	3342 )
	    surahAndAyahNumber="029002"
	    ;;
	3343 )
	    surahAndAyahNumber="029003"
	    ;;
	3344 )
	    surahAndAyahNumber="029004"
	    ;;
	3345 )
	    surahAndAyahNumber="029005"
	    ;;
	3346 )
	    surahAndAyahNumber="029006"
	    ;;
	3347 )
	    surahAndAyahNumber="029007"
	    ;;
	3348 )
	    surahAndAyahNumber="029008"
	    ;;
	3349 )
	    surahAndAyahNumber="029009"
	    ;;
	3350 )
	    surahAndAyahNumber="029010"
	    ;;
	3351 )
	    surahAndAyahNumber="029011"
	    ;;
	3352 )
	    surahAndAyahNumber="029012"
	    ;;
	3353 )
	    surahAndAyahNumber="029013"
	    ;;
	3354 )
	    surahAndAyahNumber="029014"
	    ;;
	3355 )
	    surahAndAyahNumber="029015"
	    ;;
	3356 )
	    surahAndAyahNumber="029016"
	    ;;
	3357 )
	    surahAndAyahNumber="029017"
	    ;;
	3358 )
	    surahAndAyahNumber="029018"
	    ;;
	3359 )
	    surahAndAyahNumber="029019"
	    ;;
	3360 )
	    surahAndAyahNumber="029020"
	    ;;
	3361 )
	    surahAndAyahNumber="029021"
	    ;;
	3362 )
	    surahAndAyahNumber="029022"
	    ;;
	3363 )
	    surahAndAyahNumber="029023"
	    ;;
	3364 )
	    surahAndAyahNumber="029024"
	    ;;
	3365 )
	    surahAndAyahNumber="029025"
	    ;;
	3366 )
	    surahAndAyahNumber="029026"
	    ;;
	3367 )
	    surahAndAyahNumber="029027"
	    ;;
	3368 )
	    surahAndAyahNumber="029028"
	    ;;
	3369 )
	    surahAndAyahNumber="029029"
	    ;;
	3370 )
	    surahAndAyahNumber="029030"
	    ;;
	3371 )
	    surahAndAyahNumber="029031"
	    ;;
	3372 )
	    surahAndAyahNumber="029032"
	    ;;
	3373 )
	    surahAndAyahNumber="029033"
	    ;;
	3374 )
	    surahAndAyahNumber="029034"
	    ;;
	3375 )
	    surahAndAyahNumber="029035"
	    ;;
	3376 )
	    surahAndAyahNumber="029036"
	    ;;
	3377 )
	    surahAndAyahNumber="029037"
	    ;;
	3378 )
	    surahAndAyahNumber="029038"
	    ;;
	3379 )
	    surahAndAyahNumber="029039"
	    ;;
	3380 )
	    surahAndAyahNumber="029040"
	    ;;
	3381 )
	    surahAndAyahNumber="029041"
	    ;;
	3382 )
	    surahAndAyahNumber="029042"
	    ;;
	3383 )
	    surahAndAyahNumber="029043"
	    ;;
	3384 )
	    surahAndAyahNumber="029044"
	    ;;
	3385 )
	    surahAndAyahNumber="029045"
	    ;;
	3386 )
	    surahAndAyahNumber="029046"
	    ;;
	3387 )
	    surahAndAyahNumber="029047"
	    ;;
	3388 )
	    surahAndAyahNumber="029048"
	    ;;
	3389 )
	    surahAndAyahNumber="029049"
	    ;;
	3390 )
	    surahAndAyahNumber="029050"
	    ;;
	3391 )
	    surahAndAyahNumber="029051"
	    ;;
	3392 )
	    surahAndAyahNumber="029052"
	    ;;
	3393 )
	    surahAndAyahNumber="029053"
	    ;;
	3394 )
	    surahAndAyahNumber="029054"
	    ;;
	3395 )
	    surahAndAyahNumber="029055"
	    ;;
	3396 )
	    surahAndAyahNumber="029056"
	    ;;
	3397 )
	    surahAndAyahNumber="029057"
	    ;;
	3398 )
	    surahAndAyahNumber="029058"
	    ;;
	3399 )
	    surahAndAyahNumber="029059"
	    ;;
	3400 )
	    surahAndAyahNumber="029060"
	    ;;
	3401 )
	    surahAndAyahNumber="029061"
	    ;;
	3402 )
	    surahAndAyahNumber="029062"
	    ;;
	3403 )
	    surahAndAyahNumber="029063"
	    ;;
	3404 )
	    surahAndAyahNumber="029064"
	    ;;
	3405 )
	    surahAndAyahNumber="029065"
	    ;;
	3406 )
	    surahAndAyahNumber="029066"
	    ;;
	3407 )
	    surahAndAyahNumber="029067"
	    ;;
	3408 )
	    surahAndAyahNumber="029068"
	    ;;
	3409 )
	    surahAndAyahNumber="029069"
	    ;;
	3410 )
	    surahAndAyahNumber="030001"
	    ;;
	3411 )
	    surahAndAyahNumber="030002"
	    ;;
	3412 )
	    surahAndAyahNumber="030003"
	    ;;
	3413 )
	    surahAndAyahNumber="030004"
	    ;;
	3414 )
	    surahAndAyahNumber="030005"
	    ;;
	3415 )
	    surahAndAyahNumber="030006"
	    ;;
	3416 )
	    surahAndAyahNumber="030007"
	    ;;
	3417 )
	    surahAndAyahNumber="030008"
	    ;;
	3418 )
	    surahAndAyahNumber="030009"
	    ;;
	3419 )
	    surahAndAyahNumber="030010"
	    ;;
	3420 )
	    surahAndAyahNumber="030011"
	    ;;
	3421 )
	    surahAndAyahNumber="030012"
	    ;;
	3422 )
	    surahAndAyahNumber="030013"
	    ;;
	3423 )
	    surahAndAyahNumber="030014"
	    ;;
	3424 )
	    surahAndAyahNumber="030015"
	    ;;
	3425 )
	    surahAndAyahNumber="030016"
	    ;;
	3426 )
	    surahAndAyahNumber="030017"
	    ;;
	3427 )
	    surahAndAyahNumber="030018"
	    ;;
	3428 )
	    surahAndAyahNumber="030019"
	    ;;
	3429 )
	    surahAndAyahNumber="030020"
	    ;;
	3430 )
	    surahAndAyahNumber="030021"
	    ;;
	3431 )
	    surahAndAyahNumber="030022"
	    ;;
	3432 )
	    surahAndAyahNumber="030023"
	    ;;
	3433 )
	    surahAndAyahNumber="030024"
	    ;;
	3434 )
	    surahAndAyahNumber="030025"
	    ;;
	3435 )
	    surahAndAyahNumber="030026"
	    ;;
	3436 )
	    surahAndAyahNumber="030027"
	    ;;
	3437 )
	    surahAndAyahNumber="030028"
	    ;;
	3438 )
	    surahAndAyahNumber="030029"
	    ;;
	3439 )
	    surahAndAyahNumber="030030"
	    ;;
	3440 )
	    surahAndAyahNumber="030031"
	    ;;
	3441 )
	    surahAndAyahNumber="030032"
	    ;;
	3442 )
	    surahAndAyahNumber="030033"
	    ;;
	3443 )
	    surahAndAyahNumber="030034"
	    ;;
	3444 )
	    surahAndAyahNumber="030035"
	    ;;
	3445 )
	    surahAndAyahNumber="030036"
	    ;;
	3446 )
	    surahAndAyahNumber="030037"
	    ;;
	3447 )
	    surahAndAyahNumber="030038"
	    ;;
	3448 )
	    surahAndAyahNumber="030039"
	    ;;
	3449 )
	    surahAndAyahNumber="030040"
	    ;;
	3450 )
	    surahAndAyahNumber="030041"
	    ;;
	3451 )
	    surahAndAyahNumber="030042"
	    ;;
	3452 )
	    surahAndAyahNumber="030043"
	    ;;
	3453 )
	    surahAndAyahNumber="030044"
	    ;;
	3454 )
	    surahAndAyahNumber="030045"
	    ;;
	3455 )
	    surahAndAyahNumber="030046"
	    ;;
	3456 )
	    surahAndAyahNumber="030047"
	    ;;
	3457 )
	    surahAndAyahNumber="030048"
	    ;;
	3458 )
	    surahAndAyahNumber="030049"
	    ;;
	3459 )
	    surahAndAyahNumber="030050"
	    ;;
	3460 )
	    surahAndAyahNumber="030051"
	    ;;
	3461 )
	    surahAndAyahNumber="030052"
	    ;;
	3462 )
	    surahAndAyahNumber="030053"
	    ;;
	3463 )
	    surahAndAyahNumber="030054"
	    ;;
	3464 )
	    surahAndAyahNumber="030055"
	    ;;
	3465 )
	    surahAndAyahNumber="030056"
	    ;;
	3466 )
	    surahAndAyahNumber="030057"
	    ;;
	3467 )
	    surahAndAyahNumber="030058"
	    ;;
	3468 )
	    surahAndAyahNumber="030059"
	    ;;
	3469 )
	    surahAndAyahNumber="030060"
	    ;;
	3470 )
	    surahAndAyahNumber="031001"
	    ;;
	3471 )
	    surahAndAyahNumber="031002"
	    ;;
	3472 )
	    surahAndAyahNumber="031003"
	    ;;
	3473 )
	    surahAndAyahNumber="031004"
	    ;;
	3474 )
	    surahAndAyahNumber="031005"
	    ;;
	3475 )
	    surahAndAyahNumber="031006"
	    ;;
	3476 )
	    surahAndAyahNumber="031007"
	    ;;
	3477 )
	    surahAndAyahNumber="031008"
	    ;;
	3478 )
	    surahAndAyahNumber="031009"
	    ;;
	3479 )
	    surahAndAyahNumber="031010"
	    ;;
	3480 )
	    surahAndAyahNumber="031011"
	    ;;
	3481 )
	    surahAndAyahNumber="031012"
	    ;;
	3482 )
	    surahAndAyahNumber="031013"
	    ;;
	3483 )
	    surahAndAyahNumber="031014"
	    ;;
	3484 )
	    surahAndAyahNumber="031015"
	    ;;
	3485 )
	    surahAndAyahNumber="031016"
	    ;;
	3486 )
	    surahAndAyahNumber="031017"
	    ;;
	3487 )
	    surahAndAyahNumber="031018"
	    ;;
	3488 )
	    surahAndAyahNumber="031019"
	    ;;
	3489 )
	    surahAndAyahNumber="031020"
	    ;;
	3490 )
	    surahAndAyahNumber="031021"
	    ;;
	3491 )
	    surahAndAyahNumber="031022"
	    ;;
	3492 )
	    surahAndAyahNumber="031023"
	    ;;
	3493 )
	    surahAndAyahNumber="031024"
	    ;;
	3494 )
	    surahAndAyahNumber="031025"
	    ;;
	3495 )
	    surahAndAyahNumber="031026"
	    ;;
	3496 )
	    surahAndAyahNumber="031027"
	    ;;
	3497 )
	    surahAndAyahNumber="031028"
	    ;;
	3498 )
	    surahAndAyahNumber="031029"
	    ;;
	3499 )
	    surahAndAyahNumber="031030"
	    ;;
	3500 )
	    surahAndAyahNumber="031031"
	    ;;
	3501 )
	    surahAndAyahNumber="031032"
	    ;;
	3502 )
	    surahAndAyahNumber="031033"
	    ;;
	3503 )
	    surahAndAyahNumber="031034"
	    ;;
	3504 )
	    surahAndAyahNumber="032001"
	    ;;
	3505 )
	    surahAndAyahNumber="032002"
	    ;;
	3506 )
	    surahAndAyahNumber="032003"
	    ;;
	3507 )
	    surahAndAyahNumber="032004"
	    ;;
	3508 )
	    surahAndAyahNumber="032005"
	    ;;
	3509 )
	    surahAndAyahNumber="032006"
	    ;;
	3510 )
	    surahAndAyahNumber="032007"
	    ;;
	3511 )
	    surahAndAyahNumber="032008"
	    ;;
	3512 )
	    surahAndAyahNumber="032009"
	    ;;
	3513 )
	    surahAndAyahNumber="032010"
	    ;;
	3514 )
	    surahAndAyahNumber="032011"
	    ;;
	3515 )
	    surahAndAyahNumber="032012"
	    ;;
	3516 )
	    surahAndAyahNumber="032013"
	    ;;
	3517 )
	    surahAndAyahNumber="032014"
	    ;;
	3518 )
	    surahAndAyahNumber="032015"
	    ;;
	3519 )
	    surahAndAyahNumber="032016"
	    ;;
	3520 )
	    surahAndAyahNumber="032017"
	    ;;
	3521 )
	    surahAndAyahNumber="032018"
	    ;;
	3522 )
	    surahAndAyahNumber="032019"
	    ;;
	3523 )
	    surahAndAyahNumber="032020"
	    ;;
	3524 )
	    surahAndAyahNumber="032021"
	    ;;
	3525 )
	    surahAndAyahNumber="032022"
	    ;;
	3526 )
	    surahAndAyahNumber="032023"
	    ;;
	3527 )
	    surahAndAyahNumber="032024"
	    ;;
	3528 )
	    surahAndAyahNumber="032025"
	    ;;
	3529 )
	    surahAndAyahNumber="032026"
	    ;;
	3530 )
	    surahAndAyahNumber="032027"
	    ;;
	3531 )
	    surahAndAyahNumber="032028"
	    ;;
	3532 )
	    surahAndAyahNumber="032029"
	    ;;
	3533 )
	    surahAndAyahNumber="032030"
	    ;;
	3534 )
	    surahAndAyahNumber="033001"
	    ;;
	3535 )
	    surahAndAyahNumber="033002"
	    ;;
	3536 )
	    surahAndAyahNumber="033003"
	    ;;
	3537 )
	    surahAndAyahNumber="033004"
	    ;;
	3538 )
	    surahAndAyahNumber="033005"
	    ;;
	3539 )
	    surahAndAyahNumber="033006"
	    ;;
	3540 )
	    surahAndAyahNumber="033007"
	    ;;
	3541 )
	    surahAndAyahNumber="033008"
	    ;;
	3542 )
	    surahAndAyahNumber="033009"
	    ;;
	3543 )
	    surahAndAyahNumber="033010"
	    ;;
	3544 )
	    surahAndAyahNumber="033011"
	    ;;
	3545 )
	    surahAndAyahNumber="033012"
	    ;;
	3546 )
	    surahAndAyahNumber="033013"
	    ;;
	3547 )
	    surahAndAyahNumber="033014"
	    ;;
	3548 )
	    surahAndAyahNumber="033015"
	    ;;
	3549 )
	    surahAndAyahNumber="033016"
	    ;;
	3550 )
	    surahAndAyahNumber="033017"
	    ;;
	3551 )
	    surahAndAyahNumber="033018"
	    ;;
	3552 )
	    surahAndAyahNumber="033019"
	    ;;
	3553 )
	    surahAndAyahNumber="033020"
	    ;;
	3554 )
	    surahAndAyahNumber="033021"
	    ;;
	3555 )
	    surahAndAyahNumber="033022"
	    ;;
	3556 )
	    surahAndAyahNumber="033023"
	    ;;
	3557 )
	    surahAndAyahNumber="033024"
	    ;;
	3558 )
	    surahAndAyahNumber="033025"
	    ;;
	3559 )
	    surahAndAyahNumber="033026"
	    ;;
	3560 )
	    surahAndAyahNumber="033027"
	    ;;
	3561 )
	    surahAndAyahNumber="033028"
	    ;;
	3562 )
	    surahAndAyahNumber="033029"
	    ;;
	3563 )
	    surahAndAyahNumber="033030"
	    ;;
	3564 )
	    surahAndAyahNumber="033031"
	    ;;
	3565 )
	    surahAndAyahNumber="033032"
	    ;;
	3566 )
	    surahAndAyahNumber="033033"
	    ;;
	3567 )
	    surahAndAyahNumber="033034"
	    ;;
	3568 )
	    surahAndAyahNumber="033035"
	    ;;
	3569 )
	    surahAndAyahNumber="033036"
	    ;;
	3570 )
	    surahAndAyahNumber="033037"
	    ;;
	3571 )
	    surahAndAyahNumber="033038"
	    ;;
	3572 )
	    surahAndAyahNumber="033039"
	    ;;
	3573 )
	    surahAndAyahNumber="033040"
	    ;;
	3574 )
	    surahAndAyahNumber="033041"
	    ;;
	3575 )
	    surahAndAyahNumber="033042"
	    ;;
	3576 )
	    surahAndAyahNumber="033043"
	    ;;
	3577 )
	    surahAndAyahNumber="033044"
	    ;;
	3578 )
	    surahAndAyahNumber="033045"
	    ;;
	3579 )
	    surahAndAyahNumber="033046"
	    ;;
	3580 )
	    surahAndAyahNumber="033047"
	    ;;
	3581 )
	    surahAndAyahNumber="033048"
	    ;;
	3582 )
	    surahAndAyahNumber="033049"
	    ;;
	3583 )
	    surahAndAyahNumber="033050"
	    ;;
	3584 )
	    surahAndAyahNumber="033051"
	    ;;
	3585 )
	    surahAndAyahNumber="033052"
	    ;;
	3586 )
	    surahAndAyahNumber="033053"
	    ;;
	3587 )
	    surahAndAyahNumber="033054"
	    ;;
	3588 )
	    surahAndAyahNumber="033055"
	    ;;
	3589 )
	    surahAndAyahNumber="033056"
	    ;;
	3590 )
	    surahAndAyahNumber="033057"
	    ;;
	3591 )
	    surahAndAyahNumber="033058"
	    ;;
	3592 )
	    surahAndAyahNumber="033059"
	    ;;
	3593 )
	    surahAndAyahNumber="033060"
	    ;;
	3594 )
	    surahAndAyahNumber="033061"
	    ;;
	3595 )
	    surahAndAyahNumber="033062"
	    ;;
	3596 )
	    surahAndAyahNumber="033063"
	    ;;
	3597 )
	    surahAndAyahNumber="033064"
	    ;;
	3598 )
	    surahAndAyahNumber="033065"
	    ;;
	3599 )
	    surahAndAyahNumber="033066"
	    ;;
	3600 )
	    surahAndAyahNumber="033067"
	    ;;
	3601 )
	    surahAndAyahNumber="033068"
	    ;;
	3602 )
	    surahAndAyahNumber="033069"
	    ;;
	3603 )
	    surahAndAyahNumber="033070"
	    ;;
	3604 )
	    surahAndAyahNumber="033071"
	    ;;
	3605 )
	    surahAndAyahNumber="033072"
	    ;;
	3606 )
	    surahAndAyahNumber="033073"
	    ;;
	3607 )
	    surahAndAyahNumber="034001"
	    ;;
	3608 )
	    surahAndAyahNumber="034002"
	    ;;
	3609 )
	    surahAndAyahNumber="034003"
	    ;;
	3610 )
	    surahAndAyahNumber="034004"
	    ;;
	3611 )
	    surahAndAyahNumber="034005"
	    ;;
	3612 )
	    surahAndAyahNumber="034006"
	    ;;
	3613 )
	    surahAndAyahNumber="034007"
	    ;;
	3614 )
	    surahAndAyahNumber="034008"
	    ;;
	3615 )
	    surahAndAyahNumber="034009"
	    ;;
	3616 )
	    surahAndAyahNumber="034010"
	    ;;
	3617 )
	    surahAndAyahNumber="034011"
	    ;;
	3618 )
	    surahAndAyahNumber="034012"
	    ;;
	3619 )
	    surahAndAyahNumber="034013"
	    ;;
	3620 )
	    surahAndAyahNumber="034014"
	    ;;
	3621 )
	    surahAndAyahNumber="034015"
	    ;;
	3622 )
	    surahAndAyahNumber="034016"
	    ;;
	3623 )
	    surahAndAyahNumber="034017"
	    ;;
	3624 )
	    surahAndAyahNumber="034018"
	    ;;
	3625 )
	    surahAndAyahNumber="034019"
	    ;;
	3626 )
	    surahAndAyahNumber="034020"
	    ;;
	3627 )
	    surahAndAyahNumber="034021"
	    ;;
	3628 )
	    surahAndAyahNumber="034022"
	    ;;
	3629 )
	    surahAndAyahNumber="034023"
	    ;;
	3630 )
	    surahAndAyahNumber="034024"
	    ;;
	3631 )
	    surahAndAyahNumber="034025"
	    ;;
	3632 )
	    surahAndAyahNumber="034026"
	    ;;
	3633 )
	    surahAndAyahNumber="034027"
	    ;;
	3634 )
	    surahAndAyahNumber="034028"
	    ;;
	3635 )
	    surahAndAyahNumber="034029"
	    ;;
	3636 )
	    surahAndAyahNumber="034030"
	    ;;
	3637 )
	    surahAndAyahNumber="034031"
	    ;;
	3638 )
	    surahAndAyahNumber="034032"
	    ;;
	3639 )
	    surahAndAyahNumber="034033"
	    ;;
	3640 )
	    surahAndAyahNumber="034034"
	    ;;
	3641 )
	    surahAndAyahNumber="034035"
	    ;;
	3642 )
	    surahAndAyahNumber="034036"
	    ;;
	3643 )
	    surahAndAyahNumber="034037"
	    ;;
	3644 )
	    surahAndAyahNumber="034038"
	    ;;
	3645 )
	    surahAndAyahNumber="034039"
	    ;;
	3646 )
	    surahAndAyahNumber="034040"
	    ;;
	3647 )
	    surahAndAyahNumber="034041"
	    ;;
	3648 )
	    surahAndAyahNumber="034042"
	    ;;
	3649 )
	    surahAndAyahNumber="034043"
	    ;;
	3650 )
	    surahAndAyahNumber="034044"
	    ;;
	3651 )
	    surahAndAyahNumber="034045"
	    ;;
	3652 )
	    surahAndAyahNumber="034046"
	    ;;
	3653 )
	    surahAndAyahNumber="034047"
	    ;;
	3654 )
	    surahAndAyahNumber="034048"
	    ;;
	3655 )
	    surahAndAyahNumber="034049"
	    ;;
	3656 )
	    surahAndAyahNumber="034050"
	    ;;
	3657 )
	    surahAndAyahNumber="034051"
	    ;;
	3658 )
	    surahAndAyahNumber="034052"
	    ;;
	3659 )
	    surahAndAyahNumber="034053"
	    ;;
	3660 )
	    surahAndAyahNumber="034054"
	    ;;
	3661 )
	    surahAndAyahNumber="035001"
	    ;;
	3662 )
	    surahAndAyahNumber="035002"
	    ;;
	3663 )
	    surahAndAyahNumber="035003"
	    ;;
	3664 )
	    surahAndAyahNumber="035004"
	    ;;
	3665 )
	    surahAndAyahNumber="035005"
	    ;;
	3666 )
	    surahAndAyahNumber="035006"
	    ;;
	3667 )
	    surahAndAyahNumber="035007"
	    ;;
	3668 )
	    surahAndAyahNumber="035008"
	    ;;
	3669 )
	    surahAndAyahNumber="035009"
	    ;;
	3670 )
	    surahAndAyahNumber="035010"
	    ;;
	3671 )
	    surahAndAyahNumber="035011"
	    ;;
	3672 )
	    surahAndAyahNumber="035012"
	    ;;
	3673 )
	    surahAndAyahNumber="035013"
	    ;;
	3674 )
	    surahAndAyahNumber="035014"
	    ;;
	3675 )
	    surahAndAyahNumber="035015"
	    ;;
	3676 )
	    surahAndAyahNumber="035016"
	    ;;
	3677 )
	    surahAndAyahNumber="035017"
	    ;;
	3678 )
	    surahAndAyahNumber="035018"
	    ;;
	3679 )
	    surahAndAyahNumber="035019"
	    ;;
	3680 )
	    surahAndAyahNumber="035020"
	    ;;
	3681 )
	    surahAndAyahNumber="035021"
	    ;;
	3682 )
	    surahAndAyahNumber="035022"
	    ;;
	3683 )
	    surahAndAyahNumber="035023"
	    ;;
	3684 )
	    surahAndAyahNumber="035024"
	    ;;
	3685 )
	    surahAndAyahNumber="035025"
	    ;;
	3686 )
	    surahAndAyahNumber="035026"
	    ;;
	3687 )
	    surahAndAyahNumber="035027"
	    ;;
	3688 )
	    surahAndAyahNumber="035028"
	    ;;
	3689 )
	    surahAndAyahNumber="035029"
	    ;;
	3690 )
	    surahAndAyahNumber="035030"
	    ;;
	3691 )
	    surahAndAyahNumber="035031"
	    ;;
	3692 )
	    surahAndAyahNumber="035032"
	    ;;
	3693 )
	    surahAndAyahNumber="035033"
	    ;;
	3694 )
	    surahAndAyahNumber="035034"
	    ;;
	3695 )
	    surahAndAyahNumber="035035"
	    ;;
	3696 )
	    surahAndAyahNumber="035036"
	    ;;
	3697 )
	    surahAndAyahNumber="035037"
	    ;;
	3698 )
	    surahAndAyahNumber="035038"
	    ;;
	3699 )
	    surahAndAyahNumber="035039"
	    ;;
	3700 )
	    surahAndAyahNumber="035040"
	    ;;
	3701 )
	    surahAndAyahNumber="035041"
	    ;;
	3702 )
	    surahAndAyahNumber="035042"
	    ;;
	3703 )
	    surahAndAyahNumber="035043"
	    ;;
	3704 )
	    surahAndAyahNumber="035044"
	    ;;
	3705 )
	    surahAndAyahNumber="035045"
	    ;;
	3706 )
	    surahAndAyahNumber="036001"
	    ;;
	3707 )
	    surahAndAyahNumber="036002"
	    ;;
	3708 )
	    surahAndAyahNumber="036003"
	    ;;
	3709 )
	    surahAndAyahNumber="036004"
	    ;;
	3710 )
	    surahAndAyahNumber="036005"
	    ;;
	3711 )
	    surahAndAyahNumber="036006"
	    ;;
	3712 )
	    surahAndAyahNumber="036007"
	    ;;
	3713 )
	    surahAndAyahNumber="036008"
	    ;;
	3714 )
	    surahAndAyahNumber="036009"
	    ;;
	3715 )
	    surahAndAyahNumber="036010"
	    ;;
	3716 )
	    surahAndAyahNumber="036011"
	    ;;
	3717 )
	    surahAndAyahNumber="036012"
	    ;;
	3718 )
	    surahAndAyahNumber="036013"
	    ;;
	3719 )
	    surahAndAyahNumber="036014"
	    ;;
	3720 )
	    surahAndAyahNumber="036015"
	    ;;
	3721 )
	    surahAndAyahNumber="036016"
	    ;;
	3722 )
	    surahAndAyahNumber="036017"
	    ;;
	3723 )
	    surahAndAyahNumber="036018"
	    ;;
	3724 )
	    surahAndAyahNumber="036019"
	    ;;
	3725 )
	    surahAndAyahNumber="036020"
	    ;;
	3726 )
	    surahAndAyahNumber="036021"
	    ;;
	3727 )
	    surahAndAyahNumber="036022"
	    ;;
	3728 )
	    surahAndAyahNumber="036023"
	    ;;
	3729 )
	    surahAndAyahNumber="036024"
	    ;;
	3730 )
	    surahAndAyahNumber="036025"
	    ;;
	3731 )
	    surahAndAyahNumber="036026"
	    ;;
	3732 )
	    surahAndAyahNumber="036027"
	    ;;
	3733 )
	    surahAndAyahNumber="036028"
	    ;;
	3734 )
	    surahAndAyahNumber="036029"
	    ;;
	3735 )
	    surahAndAyahNumber="036030"
	    ;;
	3736 )
	    surahAndAyahNumber="036031"
	    ;;
	3737 )
	    surahAndAyahNumber="036032"
	    ;;
	3738 )
	    surahAndAyahNumber="036033"
	    ;;
	3739 )
	    surahAndAyahNumber="036034"
	    ;;
	3740 )
	    surahAndAyahNumber="036035"
	    ;;
	3741 )
	    surahAndAyahNumber="036036"
	    ;;
	3742 )
	    surahAndAyahNumber="036037"
	    ;;
	3743 )
	    surahAndAyahNumber="036038"
	    ;;
	3744 )
	    surahAndAyahNumber="036039"
	    ;;
	3745 )
	    surahAndAyahNumber="036040"
	    ;;
	3746 )
	    surahAndAyahNumber="036041"
	    ;;
	3747 )
	    surahAndAyahNumber="036042"
	    ;;
	3748 )
	    surahAndAyahNumber="036043"
	    ;;
	3749 )
	    surahAndAyahNumber="036044"
	    ;;
	3750 )
	    surahAndAyahNumber="036045"
	    ;;
	3751 )
	    surahAndAyahNumber="036046"
	    ;;
	3752 )
	    surahAndAyahNumber="036047"
	    ;;
	3753 )
	    surahAndAyahNumber="036048"
	    ;;
	3754 )
	    surahAndAyahNumber="036049"
	    ;;
	3755 )
	    surahAndAyahNumber="036050"
	    ;;
	3756 )
	    surahAndAyahNumber="036051"
	    ;;
	3757 )
	    surahAndAyahNumber="036052"
	    ;;
	3758 )
	    surahAndAyahNumber="036053"
	    ;;
	3759 )
	    surahAndAyahNumber="036054"
	    ;;
	3760 )
	    surahAndAyahNumber="036055"
	    ;;
	3761 )
	    surahAndAyahNumber="036056"
	    ;;
	3762 )
	    surahAndAyahNumber="036057"
	    ;;
	3763 )
	    surahAndAyahNumber="036058"
	    ;;
	3764 )
	    surahAndAyahNumber="036059"
	    ;;
	3765 )
	    surahAndAyahNumber="036060"
	    ;;
	3766 )
	    surahAndAyahNumber="036061"
	    ;;
	3767 )
	    surahAndAyahNumber="036062"
	    ;;
	3768 )
	    surahAndAyahNumber="036063"
	    ;;
	3769 )
	    surahAndAyahNumber="036064"
	    ;;
	3770 )
	    surahAndAyahNumber="036065"
	    ;;
	3771 )
	    surahAndAyahNumber="036066"
	    ;;
	3772 )
	    surahAndAyahNumber="036067"
	    ;;
	3773 )
	    surahAndAyahNumber="036068"
	    ;;
	3774 )
	    surahAndAyahNumber="036069"
	    ;;
	3775 )
	    surahAndAyahNumber="036070"
	    ;;
	3776 )
	    surahAndAyahNumber="036071"
	    ;;
	3777 )
	    surahAndAyahNumber="036072"
	    ;;
	3778 )
	    surahAndAyahNumber="036073"
	    ;;
	3779 )
	    surahAndAyahNumber="036074"
	    ;;
	3780 )
	    surahAndAyahNumber="036075"
	    ;;
	3781 )
	    surahAndAyahNumber="036076"
	    ;;
	3782 )
	    surahAndAyahNumber="036077"
	    ;;
	3783 )
	    surahAndAyahNumber="036078"
	    ;;
	3784 )
	    surahAndAyahNumber="036079"
	    ;;
	3785 )
	    surahAndAyahNumber="036080"
	    ;;
	3786 )
	    surahAndAyahNumber="036081"
	    ;;
	3787 )
	    surahAndAyahNumber="036082"
	    ;;
	3788 )
	    surahAndAyahNumber="036083"
	    ;;
	3789 )
	    surahAndAyahNumber="037001"
	    ;;
	3790 )
	    surahAndAyahNumber="037002"
	    ;;
	3791 )
	    surahAndAyahNumber="037003"
	    ;;
	3792 )
	    surahAndAyahNumber="037004"
	    ;;
	3793 )
	    surahAndAyahNumber="037005"
	    ;;
	3794 )
	    surahAndAyahNumber="037006"
	    ;;
	3795 )
	    surahAndAyahNumber="037007"
	    ;;
	3796 )
	    surahAndAyahNumber="037008"
	    ;;
	3797 )
	    surahAndAyahNumber="037009"
	    ;;
	3798 )
	    surahAndAyahNumber="037010"
	    ;;
	3799 )
	    surahAndAyahNumber="037011"
	    ;;
	3800 )
	    surahAndAyahNumber="037012"
	    ;;
	3801 )
	    surahAndAyahNumber="037013"
	    ;;
	3802 )
	    surahAndAyahNumber="037014"
	    ;;
	3803 )
	    surahAndAyahNumber="037015"
	    ;;
	3804 )
	    surahAndAyahNumber="037016"
	    ;;
	3805 )
	    surahAndAyahNumber="037017"
	    ;;
	3806 )
	    surahAndAyahNumber="037018"
	    ;;
	3807 )
	    surahAndAyahNumber="037019"
	    ;;
	3808 )
	    surahAndAyahNumber="037020"
	    ;;
	3809 )
	    surahAndAyahNumber="037021"
	    ;;
	3810 )
	    surahAndAyahNumber="037022"
	    ;;
	3811 )
	    surahAndAyahNumber="037023"
	    ;;
	3812 )
	    surahAndAyahNumber="037024"
	    ;;
	3813 )
	    surahAndAyahNumber="037025"
	    ;;
	3814 )
	    surahAndAyahNumber="037026"
	    ;;
	3815 )
	    surahAndAyahNumber="037027"
	    ;;
	3816 )
	    surahAndAyahNumber="037028"
	    ;;
	3817 )
	    surahAndAyahNumber="037029"
	    ;;
	3818 )
	    surahAndAyahNumber="037030"
	    ;;
	3819 )
	    surahAndAyahNumber="037031"
	    ;;
	3820 )
	    surahAndAyahNumber="037032"
	    ;;
	3821 )
	    surahAndAyahNumber="037033"
	    ;;
	3822 )
	    surahAndAyahNumber="037034"
	    ;;
	3823 )
	    surahAndAyahNumber="037035"
	    ;;
	3824 )
	    surahAndAyahNumber="037036"
	    ;;
	3825 )
	    surahAndAyahNumber="037037"
	    ;;
	3826 )
	    surahAndAyahNumber="037038"
	    ;;
	3827 )
	    surahAndAyahNumber="037039"
	    ;;
	3828 )
	    surahAndAyahNumber="037040"
	    ;;
	3829 )
	    surahAndAyahNumber="037041"
	    ;;
	3830 )
	    surahAndAyahNumber="037042"
	    ;;
	3831 )
	    surahAndAyahNumber="037043"
	    ;;
	3832 )
	    surahAndAyahNumber="037044"
	    ;;
	3833 )
	    surahAndAyahNumber="037045"
	    ;;
	3834 )
	    surahAndAyahNumber="037046"
	    ;;
	3835 )
	    surahAndAyahNumber="037047"
	    ;;
	3836 )
	    surahAndAyahNumber="037048"
	    ;;
	3837 )
	    surahAndAyahNumber="037049"
	    ;;
	3838 )
	    surahAndAyahNumber="037050"
	    ;;
	3839 )
	    surahAndAyahNumber="037051"
	    ;;
	3840 )
	    surahAndAyahNumber="037052"
	    ;;
	3841 )
	    surahAndAyahNumber="037053"
	    ;;
	3842 )
	    surahAndAyahNumber="037054"
	    ;;
	3843 )
	    surahAndAyahNumber="037055"
	    ;;
	3844 )
	    surahAndAyahNumber="037056"
	    ;;
	3845 )
	    surahAndAyahNumber="037057"
	    ;;
	3846 )
	    surahAndAyahNumber="037058"
	    ;;
	3847 )
	    surahAndAyahNumber="037059"
	    ;;
	3848 )
	    surahAndAyahNumber="037060"
	    ;;
	3849 )
	    surahAndAyahNumber="037061"
	    ;;
	3850 )
	    surahAndAyahNumber="037062"
	    ;;
	3851 )
	    surahAndAyahNumber="037063"
	    ;;
	3852 )
	    surahAndAyahNumber="037064"
	    ;;
	3853 )
	    surahAndAyahNumber="037065"
	    ;;
	3854 )
	    surahAndAyahNumber="037066"
	    ;;
	3855 )
	    surahAndAyahNumber="037067"
	    ;;
	3856 )
	    surahAndAyahNumber="037068"
	    ;;
	3857 )
	    surahAndAyahNumber="037069"
	    ;;
	3858 )
	    surahAndAyahNumber="037070"
	    ;;
	3859 )
	    surahAndAyahNumber="037071"
	    ;;
	3860 )
	    surahAndAyahNumber="037072"
	    ;;
	3861 )
	    surahAndAyahNumber="037073"
	    ;;
	3862 )
	    surahAndAyahNumber="037074"
	    ;;
	3863 )
	    surahAndAyahNumber="037075"
	    ;;
	3864 )
	    surahAndAyahNumber="037076"
	    ;;
	3865 )
	    surahAndAyahNumber="037077"
	    ;;
	3866 )
	    surahAndAyahNumber="037078"
	    ;;
	3867 )
	    surahAndAyahNumber="037079"
	    ;;
	3868 )
	    surahAndAyahNumber="037080"
	    ;;
	3869 )
	    surahAndAyahNumber="037081"
	    ;;
	3870 )
	    surahAndAyahNumber="037082"
	    ;;
	3871 )
	    surahAndAyahNumber="037083"
	    ;;
	3872 )
	    surahAndAyahNumber="037084"
	    ;;
	3873 )
	    surahAndAyahNumber="037085"
	    ;;
	3874 )
	    surahAndAyahNumber="037086"
	    ;;
	3875 )
	    surahAndAyahNumber="037087"
	    ;;
	3876 )
	    surahAndAyahNumber="037088"
	    ;;
	3877 )
	    surahAndAyahNumber="037089"
	    ;;
	3878 )
	    surahAndAyahNumber="037090"
	    ;;
	3879 )
	    surahAndAyahNumber="037091"
	    ;;
	3880 )
	    surahAndAyahNumber="037092"
	    ;;
	3881 )
	    surahAndAyahNumber="037093"
	    ;;
	3882 )
	    surahAndAyahNumber="037094"
	    ;;
	3883 )
	    surahAndAyahNumber="037095"
	    ;;
	3884 )
	    surahAndAyahNumber="037096"
	    ;;
	3885 )
	    surahAndAyahNumber="037097"
	    ;;
	3886 )
	    surahAndAyahNumber="037098"
	    ;;
	3887 )
	    surahAndAyahNumber="037099"
	    ;;
	3888 )
	    surahAndAyahNumber="037100"
	    ;;
	3889 )
	    surahAndAyahNumber="037101"
	    ;;
	3890 )
	    surahAndAyahNumber="037102"
	    ;;
	3891 )
	    surahAndAyahNumber="037103"
	    ;;
	3892 )
	    surahAndAyahNumber="037104"
	    ;;
	3893 )
	    surahAndAyahNumber="037105"
	    ;;
	3894 )
	    surahAndAyahNumber="037106"
	    ;;
	3895 )
	    surahAndAyahNumber="037107"
	    ;;
	3896 )
	    surahAndAyahNumber="037108"
	    ;;
	3897 )
	    surahAndAyahNumber="037109"
	    ;;
	3898 )
	    surahAndAyahNumber="037110"
	    ;;
	3899 )
	    surahAndAyahNumber="037111"
	    ;;
	3900 )
	    surahAndAyahNumber="037112"
	    ;;
	3901 )
	    surahAndAyahNumber="037113"
	    ;;
	3902 )
	    surahAndAyahNumber="037114"
	    ;;
	3903 )
	    surahAndAyahNumber="037115"
	    ;;
	3904 )
	    surahAndAyahNumber="037116"
	    ;;
	3905 )
	    surahAndAyahNumber="037117"
	    ;;
	3906 )
	    surahAndAyahNumber="037118"
	    ;;
	3907 )
	    surahAndAyahNumber="037119"
	    ;;
	3908 )
	    surahAndAyahNumber="037120"
	    ;;
	3909 )
	    surahAndAyahNumber="037121"
	    ;;
	3910 )
	    surahAndAyahNumber="037122"
	    ;;
	3911 )
	    surahAndAyahNumber="037123"
	    ;;
	3912 )
	    surahAndAyahNumber="037124"
	    ;;
	3913 )
	    surahAndAyahNumber="037125"
	    ;;
	3914 )
	    surahAndAyahNumber="037126"
	    ;;
	3915 )
	    surahAndAyahNumber="037127"
	    ;;
	3916 )
	    surahAndAyahNumber="037128"
	    ;;
	3917 )
	    surahAndAyahNumber="037129"
	    ;;
	3918 )
	    surahAndAyahNumber="037130"
	    ;;
	3919 )
	    surahAndAyahNumber="037131"
	    ;;
	3920 )
	    surahAndAyahNumber="037132"
	    ;;
	3921 )
	    surahAndAyahNumber="037133"
	    ;;
	3922 )
	    surahAndAyahNumber="037134"
	    ;;
	3923 )
	    surahAndAyahNumber="037135"
	    ;;
	3924 )
	    surahAndAyahNumber="037136"
	    ;;
	3925 )
	    surahAndAyahNumber="037137"
	    ;;
	3926 )
	    surahAndAyahNumber="037138"
	    ;;
	3927 )
	    surahAndAyahNumber="037139"
	    ;;
	3928 )
	    surahAndAyahNumber="037140"
	    ;;
	3929 )
	    surahAndAyahNumber="037141"
	    ;;
	3930 )
	    surahAndAyahNumber="037142"
	    ;;
	3931 )
	    surahAndAyahNumber="037143"
	    ;;
	3932 )
	    surahAndAyahNumber="037144"
	    ;;
	3933 )
	    surahAndAyahNumber="037145"
	    ;;
	3934 )
	    surahAndAyahNumber="037146"
	    ;;
	3935 )
	    surahAndAyahNumber="037147"
	    ;;
	3936 )
	    surahAndAyahNumber="037148"
	    ;;
	3937 )
	    surahAndAyahNumber="037149"
	    ;;
	3938 )
	    surahAndAyahNumber="037150"
	    ;;
	3939 )
	    surahAndAyahNumber="037151"
	    ;;
	3940 )
	    surahAndAyahNumber="037152"
	    ;;
	3941 )
	    surahAndAyahNumber="037153"
	    ;;
	3942 )
	    surahAndAyahNumber="037154"
	    ;;
	3943 )
	    surahAndAyahNumber="037155"
	    ;;
	3944 )
	    surahAndAyahNumber="037156"
	    ;;
	3945 )
	    surahAndAyahNumber="037157"
	    ;;
	3946 )
	    surahAndAyahNumber="037158"
	    ;;
	3947 )
	    surahAndAyahNumber="037159"
	    ;;
	3948 )
	    surahAndAyahNumber="037160"
	    ;;
	3949 )
	    surahAndAyahNumber="037161"
	    ;;
	3950 )
	    surahAndAyahNumber="037162"
	    ;;
	3951 )
	    surahAndAyahNumber="037163"
	    ;;
	3952 )
	    surahAndAyahNumber="037164"
	    ;;
	3953 )
	    surahAndAyahNumber="037165"
	    ;;
	3954 )
	    surahAndAyahNumber="037166"
	    ;;
	3955 )
	    surahAndAyahNumber="037167"
	    ;;
	3956 )
	    surahAndAyahNumber="037168"
	    ;;
	3957 )
	    surahAndAyahNumber="037169"
	    ;;
	3958 )
	    surahAndAyahNumber="037170"
	    ;;
	3959 )
	    surahAndAyahNumber="037171"
	    ;;
	3960 )
	    surahAndAyahNumber="037172"
	    ;;
	3961 )
	    surahAndAyahNumber="037173"
	    ;;
	3962 )
	    surahAndAyahNumber="037174"
	    ;;
	3963 )
	    surahAndAyahNumber="037175"
	    ;;
	3964 )
	    surahAndAyahNumber="037176"
	    ;;
	3965 )
	    surahAndAyahNumber="037177"
	    ;;
	3966 )
	    surahAndAyahNumber="037178"
	    ;;
	3967 )
	    surahAndAyahNumber="037179"
	    ;;
	3968 )
	    surahAndAyahNumber="037180"
	    ;;
	3969 )
	    surahAndAyahNumber="037181"
	    ;;
	3970 )
	    surahAndAyahNumber="037182"
	    ;;
	3971 )
	    surahAndAyahNumber="038001"
	    ;;
	3972 )
	    surahAndAyahNumber="038002"
	    ;;
	3973 )
	    surahAndAyahNumber="038003"
	    ;;
	3974 )
	    surahAndAyahNumber="038004"
	    ;;
	3975 )
	    surahAndAyahNumber="038005"
	    ;;
	3976 )
	    surahAndAyahNumber="038006"
	    ;;
	3977 )
	    surahAndAyahNumber="038007"
	    ;;
	3978 )
	    surahAndAyahNumber="038008"
	    ;;
	3979 )
	    surahAndAyahNumber="038009"
	    ;;
	3980 )
	    surahAndAyahNumber="038010"
	    ;;
	3981 )
	    surahAndAyahNumber="038011"
	    ;;
	3982 )
	    surahAndAyahNumber="038012"
	    ;;
	3983 )
	    surahAndAyahNumber="038013"
	    ;;
	3984 )
	    surahAndAyahNumber="038014"
	    ;;
	3985 )
	    surahAndAyahNumber="038015"
	    ;;
	3986 )
	    surahAndAyahNumber="038016"
	    ;;
	3987 )
	    surahAndAyahNumber="038017"
	    ;;
	3988 )
	    surahAndAyahNumber="038018"
	    ;;
	3989 )
	    surahAndAyahNumber="038019"
	    ;;
	3990 )
	    surahAndAyahNumber="038020"
	    ;;
	3991 )
	    surahAndAyahNumber="038021"
	    ;;
	3992 )
	    surahAndAyahNumber="038022"
	    ;;
	3993 )
	    surahAndAyahNumber="038023"
	    ;;
	3994 )
	    surahAndAyahNumber="038024"
	    ;;
	3995 )
	    surahAndAyahNumber="038025"
	    ;;
	3996 )
	    surahAndAyahNumber="038026"
	    ;;
	3997 )
	    surahAndAyahNumber="038027"
	    ;;
	3998 )
	    surahAndAyahNumber="038028"
	    ;;
	3999 )
	    surahAndAyahNumber="038029"
	    ;;
	4000 )
	    surahAndAyahNumber="038030"
	    ;;
	4001 )
	    surahAndAyahNumber="038031"
	    ;;
	4002 )
	    surahAndAyahNumber="038032"
	    ;;
	4003 )
	    surahAndAyahNumber="038033"
	    ;;
	4004 )
	    surahAndAyahNumber="038034"
	    ;;
	4005 )
	    surahAndAyahNumber="038035"
	    ;;
	4006 )
	    surahAndAyahNumber="038036"
	    ;;
	4007 )
	    surahAndAyahNumber="038037"
	    ;;
	4008 )
	    surahAndAyahNumber="038038"
	    ;;
	4009 )
	    surahAndAyahNumber="038039"
	    ;;
	4010 )
	    surahAndAyahNumber="038040"
	    ;;
	4011 )
	    surahAndAyahNumber="038041"
	    ;;
	4012 )
	    surahAndAyahNumber="038042"
	    ;;
	4013 )
	    surahAndAyahNumber="038043"
	    ;;
	4014 )
	    surahAndAyahNumber="038044"
	    ;;
	4015 )
	    surahAndAyahNumber="038045"
	    ;;
	4016 )
	    surahAndAyahNumber="038046"
	    ;;
	4017 )
	    surahAndAyahNumber="038047"
	    ;;
	4018 )
	    surahAndAyahNumber="038048"
	    ;;
	4019 )
	    surahAndAyahNumber="038049"
	    ;;
	4020 )
	    surahAndAyahNumber="038050"
	    ;;
	4021 )
	    surahAndAyahNumber="038051"
	    ;;
	4022 )
	    surahAndAyahNumber="038052"
	    ;;
	4023 )
	    surahAndAyahNumber="038053"
	    ;;
	4024 )
	    surahAndAyahNumber="038054"
	    ;;
	4025 )
	    surahAndAyahNumber="038055"
	    ;;
	4026 )
	    surahAndAyahNumber="038056"
	    ;;
	4027 )
	    surahAndAyahNumber="038057"
	    ;;
	4028 )
	    surahAndAyahNumber="038058"
	    ;;
	4029 )
	    surahAndAyahNumber="038059"
	    ;;
	4030 )
	    surahAndAyahNumber="038060"
	    ;;
	4031 )
	    surahAndAyahNumber="038061"
	    ;;
	4032 )
	    surahAndAyahNumber="038062"
	    ;;
	4033 )
	    surahAndAyahNumber="038063"
	    ;;
	4034 )
	    surahAndAyahNumber="038064"
	    ;;
	4035 )
	    surahAndAyahNumber="038065"
	    ;;
	4036 )
	    surahAndAyahNumber="038066"
	    ;;
	4037 )
	    surahAndAyahNumber="038067"
	    ;;
	4038 )
	    surahAndAyahNumber="038068"
	    ;;
	4039 )
	    surahAndAyahNumber="038069"
	    ;;
	4040 )
	    surahAndAyahNumber="038070"
	    ;;
	4041 )
	    surahAndAyahNumber="038071"
	    ;;
	4042 )
	    surahAndAyahNumber="038072"
	    ;;
	4043 )
	    surahAndAyahNumber="038073"
	    ;;
	4044 )
	    surahAndAyahNumber="038074"
	    ;;
	4045 )
	    surahAndAyahNumber="038075"
	    ;;
	4046 )
	    surahAndAyahNumber="038076"
	    ;;
	4047 )
	    surahAndAyahNumber="038077"
	    ;;
	4048 )
	    surahAndAyahNumber="038078"
	    ;;
	4049 )
	    surahAndAyahNumber="038079"
	    ;;
	4050 )
	    surahAndAyahNumber="038080"
	    ;;
	4051 )
	    surahAndAyahNumber="038081"
	    ;;
	4052 )
	    surahAndAyahNumber="038082"
	    ;;
	4053 )
	    surahAndAyahNumber="038083"
	    ;;
	4054 )
	    surahAndAyahNumber="038084"
	    ;;
	4055 )
	    surahAndAyahNumber="038085"
	    ;;
	4056 )
	    surahAndAyahNumber="038086"
	    ;;
	4057 )
	    surahAndAyahNumber="038087"
	    ;;
	4058 )
	    surahAndAyahNumber="038088"
	    ;;
	4059 )
	    surahAndAyahNumber="039001"
	    ;;
	4060 )
	    surahAndAyahNumber="039002"
	    ;;
	4061 )
	    surahAndAyahNumber="039003"
	    ;;
	4062 )
	    surahAndAyahNumber="039004"
	    ;;
	4063 )
	    surahAndAyahNumber="039005"
	    ;;
	4064 )
	    surahAndAyahNumber="039006"
	    ;;
	4065 )
	    surahAndAyahNumber="039007"
	    ;;
	4066 )
	    surahAndAyahNumber="039008"
	    ;;
	4067 )
	    surahAndAyahNumber="039009"
	    ;;
	4068 )
	    surahAndAyahNumber="039010"
	    ;;
	4069 )
	    surahAndAyahNumber="039011"
	    ;;
	4070 )
	    surahAndAyahNumber="039012"
	    ;;
	4071 )
	    surahAndAyahNumber="039013"
	    ;;
	4072 )
	    surahAndAyahNumber="039014"
	    ;;
	4073 )
	    surahAndAyahNumber="039015"
	    ;;
	4074 )
	    surahAndAyahNumber="039016"
	    ;;
	4075 )
	    surahAndAyahNumber="039017"
	    ;;
	4076 )
	    surahAndAyahNumber="039018"
	    ;;
	4077 )
	    surahAndAyahNumber="039019"
	    ;;
	4078 )
	    surahAndAyahNumber="039020"
	    ;;
	4079 )
	    surahAndAyahNumber="039021"
	    ;;
	4080 )
	    surahAndAyahNumber="039022"
	    ;;
	4081 )
	    surahAndAyahNumber="039023"
	    ;;
	4082 )
	    surahAndAyahNumber="039024"
	    ;;
	4083 )
	    surahAndAyahNumber="039025"
	    ;;
	4084 )
	    surahAndAyahNumber="039026"
	    ;;
	4085 )
	    surahAndAyahNumber="039027"
	    ;;
	4086 )
	    surahAndAyahNumber="039028"
	    ;;
	4087 )
	    surahAndAyahNumber="039029"
	    ;;
	4088 )
	    surahAndAyahNumber="039030"
	    ;;
	4089 )
	    surahAndAyahNumber="039031"
	    ;;
	4090 )
	    surahAndAyahNumber="039032"
	    ;;
	4091 )
	    surahAndAyahNumber="039033"
	    ;;
	4092 )
	    surahAndAyahNumber="039034"
	    ;;
	4093 )
	    surahAndAyahNumber="039035"
	    ;;
	4094 )
	    surahAndAyahNumber="039036"
	    ;;
	4095 )
	    surahAndAyahNumber="039037"
	    ;;
	4096 )
	    surahAndAyahNumber="039038"
	    ;;
	4097 )
	    surahAndAyahNumber="039039"
	    ;;
	4098 )
	    surahAndAyahNumber="039040"
	    ;;
	4099 )
	    surahAndAyahNumber="039041"
	    ;;
	4100 )
	    surahAndAyahNumber="039042"
	    ;;
	4101 )
	    surahAndAyahNumber="039043"
	    ;;
	4102 )
	    surahAndAyahNumber="039044"
	    ;;
	4103 )
	    surahAndAyahNumber="039045"
	    ;;
	4104 )
	    surahAndAyahNumber="039046"
	    ;;
	4105 )
	    surahAndAyahNumber="039047"
	    ;;
	4106 )
	    surahAndAyahNumber="039048"
	    ;;
	4107 )
	    surahAndAyahNumber="039049"
	    ;;
	4108 )
	    surahAndAyahNumber="039050"
	    ;;
	4109 )
	    surahAndAyahNumber="039051"
	    ;;
	4110 )
	    surahAndAyahNumber="039052"
	    ;;
	4111 )
	    surahAndAyahNumber="039053"
	    ;;
	4112 )
	    surahAndAyahNumber="039054"
	    ;;
	4113 )
	    surahAndAyahNumber="039055"
	    ;;
	4114 )
	    surahAndAyahNumber="039056"
	    ;;
	4115 )
	    surahAndAyahNumber="039057"
	    ;;
	4116 )
	    surahAndAyahNumber="039058"
	    ;;
	4117 )
	    surahAndAyahNumber="039059"
	    ;;
	4118 )
	    surahAndAyahNumber="039060"
	    ;;
	4119 )
	    surahAndAyahNumber="039061"
	    ;;
	4120 )
	    surahAndAyahNumber="039062"
	    ;;
	4121 )
	    surahAndAyahNumber="039063"
	    ;;
	4122 )
	    surahAndAyahNumber="039064"
	    ;;
	4123 )
	    surahAndAyahNumber="039065"
	    ;;
	4124 )
	    surahAndAyahNumber="039066"
	    ;;
	4125 )
	    surahAndAyahNumber="039067"
	    ;;
	4126 )
	    surahAndAyahNumber="039068"
	    ;;
	4127 )
	    surahAndAyahNumber="039069"
	    ;;
	4128 )
	    surahAndAyahNumber="039070"
	    ;;
	4129 )
	    surahAndAyahNumber="039071"
	    ;;
	4130 )
	    surahAndAyahNumber="039072"
	    ;;
	4131 )
	    surahAndAyahNumber="039073"
	    ;;
	4132 )
	    surahAndAyahNumber="039074"
	    ;;
	4133 )
	    surahAndAyahNumber="039075"
	    ;;
	4134 )
	    surahAndAyahNumber="040001"
	    ;;
	4135 )
	    surahAndAyahNumber="040002"
	    ;;
	4136 )
	    surahAndAyahNumber="040003"
	    ;;
	4137 )
	    surahAndAyahNumber="040004"
	    ;;
	4138 )
	    surahAndAyahNumber="040005"
	    ;;
	4139 )
	    surahAndAyahNumber="040006"
	    ;;
	4140 )
	    surahAndAyahNumber="040007"
	    ;;
	4141 )
	    surahAndAyahNumber="040008"
	    ;;
	4142 )
	    surahAndAyahNumber="040009"
	    ;;
	4143 )
	    surahAndAyahNumber="040010"
	    ;;
	4144 )
	    surahAndAyahNumber="040011"
	    ;;
	4145 )
	    surahAndAyahNumber="040012"
	    ;;
	4146 )
	    surahAndAyahNumber="040013"
	    ;;
	4147 )
	    surahAndAyahNumber="040014"
	    ;;
	4148 )
	    surahAndAyahNumber="040015"
	    ;;
	4149 )
	    surahAndAyahNumber="040016"
	    ;;
	4150 )
	    surahAndAyahNumber="040017"
	    ;;
	4151 )
	    surahAndAyahNumber="040018"
	    ;;
	4152 )
	    surahAndAyahNumber="040019"
	    ;;
	4153 )
	    surahAndAyahNumber="040020"
	    ;;
	4154 )
	    surahAndAyahNumber="040021"
	    ;;
	4155 )
	    surahAndAyahNumber="040022"
	    ;;
	4156 )
	    surahAndAyahNumber="040023"
	    ;;
	4157 )
	    surahAndAyahNumber="040024"
	    ;;
	4158 )
	    surahAndAyahNumber="040025"
	    ;;
	4159 )
	    surahAndAyahNumber="040026"
	    ;;
	4160 )
	    surahAndAyahNumber="040027"
	    ;;
	4161 )
	    surahAndAyahNumber="040028"
	    ;;
	4162 )
	    surahAndAyahNumber="040029"
	    ;;
	4163 )
	    surahAndAyahNumber="040030"
	    ;;
	4164 )
	    surahAndAyahNumber="040031"
	    ;;
	4165 )
	    surahAndAyahNumber="040032"
	    ;;
	4166 )
	    surahAndAyahNumber="040033"
	    ;;
	4167 )
	    surahAndAyahNumber="040034"
	    ;;
	4168 )
	    surahAndAyahNumber="040035"
	    ;;
	4169 )
	    surahAndAyahNumber="040036"
	    ;;
	4170 )
	    surahAndAyahNumber="040037"
	    ;;
	4171 )
	    surahAndAyahNumber="040038"
	    ;;
	4172 )
	    surahAndAyahNumber="040039"
	    ;;
	4173 )
	    surahAndAyahNumber="040040"
	    ;;
	4174 )
	    surahAndAyahNumber="040041"
	    ;;
	4175 )
	    surahAndAyahNumber="040042"
	    ;;
	4176 )
	    surahAndAyahNumber="040043"
	    ;;
	4177 )
	    surahAndAyahNumber="040044"
	    ;;
	4178 )
	    surahAndAyahNumber="040045"
	    ;;
	4179 )
	    surahAndAyahNumber="040046"
	    ;;
	4180 )
	    surahAndAyahNumber="040047"
	    ;;
	4181 )
	    surahAndAyahNumber="040048"
	    ;;
	4182 )
	    surahAndAyahNumber="040049"
	    ;;
	4183 )
	    surahAndAyahNumber="040050"
	    ;;
	4184 )
	    surahAndAyahNumber="040051"
	    ;;
	4185 )
	    surahAndAyahNumber="040052"
	    ;;
	4186 )
	    surahAndAyahNumber="040053"
	    ;;
	4187 )
	    surahAndAyahNumber="040054"
	    ;;
	4188 )
	    surahAndAyahNumber="040055"
	    ;;
	4189 )
	    surahAndAyahNumber="040056"
	    ;;
	4190 )
	    surahAndAyahNumber="040057"
	    ;;
	4191 )
	    surahAndAyahNumber="040058"
	    ;;
	4192 )
	    surahAndAyahNumber="040059"
	    ;;
	4193 )
	    surahAndAyahNumber="040060"
	    ;;
	4194 )
	    surahAndAyahNumber="040061"
	    ;;
	4195 )
	    surahAndAyahNumber="040062"
	    ;;
	4196 )
	    surahAndAyahNumber="040063"
	    ;;
	4197 )
	    surahAndAyahNumber="040064"
	    ;;
	4198 )
	    surahAndAyahNumber="040065"
	    ;;
	4199 )
	    surahAndAyahNumber="040066"
	    ;;
	4200 )
	    surahAndAyahNumber="040067"
	    ;;
	4201 )
	    surahAndAyahNumber="040068"
	    ;;
	4202 )
	    surahAndAyahNumber="040069"
	    ;;
	4203 )
	    surahAndAyahNumber="040070"
	    ;;
	4204 )
	    surahAndAyahNumber="040071"
	    ;;
	4205 )
	    surahAndAyahNumber="040072"
	    ;;
	4206 )
	    surahAndAyahNumber="040073"
	    ;;
	4207 )
	    surahAndAyahNumber="040074"
	    ;;
	4208 )
	    surahAndAyahNumber="040075"
	    ;;
	4209 )
	    surahAndAyahNumber="040076"
	    ;;
	4210 )
	    surahAndAyahNumber="040077"
	    ;;
	4211 )
	    surahAndAyahNumber="040078"
	    ;;
	4212 )
	    surahAndAyahNumber="040079"
	    ;;
	4213 )
	    surahAndAyahNumber="040080"
	    ;;
	4214 )
	    surahAndAyahNumber="040081"
	    ;;
	4215 )
	    surahAndAyahNumber="040082"
	    ;;
	4216 )
	    surahAndAyahNumber="040083"
	    ;;
	4217 )
	    surahAndAyahNumber="040084"
	    ;;
	4218 )
	    surahAndAyahNumber="040085"
	    ;;
	4219 )
	    surahAndAyahNumber="041001"
	    ;;
	4220 )
	    surahAndAyahNumber="041002"
	    ;;
	4221 )
	    surahAndAyahNumber="041003"
	    ;;
	4222 )
	    surahAndAyahNumber="041004"
	    ;;
	4223 )
	    surahAndAyahNumber="041005"
	    ;;
	4224 )
	    surahAndAyahNumber="041006"
	    ;;
	4225 )
	    surahAndAyahNumber="041007"
	    ;;
	4226 )
	    surahAndAyahNumber="041008"
	    ;;
	4227 )
	    surahAndAyahNumber="041009"
	    ;;
	4228 )
	    surahAndAyahNumber="041010"
	    ;;
	4229 )
	    surahAndAyahNumber="041011"
	    ;;
	4230 )
	    surahAndAyahNumber="041012"
	    ;;
	4231 )
	    surahAndAyahNumber="041013"
	    ;;
	4232 )
	    surahAndAyahNumber="041014"
	    ;;
	4233 )
	    surahAndAyahNumber="041015"
	    ;;
	4234 )
	    surahAndAyahNumber="041016"
	    ;;
	4235 )
	    surahAndAyahNumber="041017"
	    ;;
	4236 )
	    surahAndAyahNumber="041018"
	    ;;
	4237 )
	    surahAndAyahNumber="041019"
	    ;;
	4238 )
	    surahAndAyahNumber="041020"
	    ;;
	4239 )
	    surahAndAyahNumber="041021"
	    ;;
	4240 )
	    surahAndAyahNumber="041022"
	    ;;
	4241 )
	    surahAndAyahNumber="041023"
	    ;;
	4242 )
	    surahAndAyahNumber="041024"
	    ;;
	4243 )
	    surahAndAyahNumber="041025"
	    ;;
	4244 )
	    surahAndAyahNumber="041026"
	    ;;
	4245 )
	    surahAndAyahNumber="041027"
	    ;;
	4246 )
	    surahAndAyahNumber="041028"
	    ;;
	4247 )
	    surahAndAyahNumber="041029"
	    ;;
	4248 )
	    surahAndAyahNumber="041030"
	    ;;
	4249 )
	    surahAndAyahNumber="041031"
	    ;;
	4250 )
	    surahAndAyahNumber="041032"
	    ;;
	4251 )
	    surahAndAyahNumber="041033"
	    ;;
	4252 )
	    surahAndAyahNumber="041034"
	    ;;
	4253 )
	    surahAndAyahNumber="041035"
	    ;;
	4254 )
	    surahAndAyahNumber="041036"
	    ;;
	4255 )
	    surahAndAyahNumber="041037"
	    ;;
	4256 )
	    surahAndAyahNumber="041038"
	    ;;
	4257 )
	    surahAndAyahNumber="041039"
	    ;;
	4258 )
	    surahAndAyahNumber="041040"
	    ;;
	4259 )
	    surahAndAyahNumber="041041"
	    ;;
	4260 )
	    surahAndAyahNumber="041042"
	    ;;
	4261 )
	    surahAndAyahNumber="041043"
	    ;;
	4262 )
	    surahAndAyahNumber="041044"
	    ;;
	4263 )
	    surahAndAyahNumber="041045"
	    ;;
	4264 )
	    surahAndAyahNumber="041046"
	    ;;
	4265 )
	    surahAndAyahNumber="041047"
	    ;;
	4266 )
	    surahAndAyahNumber="041048"
	    ;;
	4267 )
	    surahAndAyahNumber="041049"
	    ;;
	4268 )
	    surahAndAyahNumber="041050"
	    ;;
	4269 )
	    surahAndAyahNumber="041051"
	    ;;
	4270 )
	    surahAndAyahNumber="041052"
	    ;;
	4271 )
	    surahAndAyahNumber="041053"
	    ;;
	4272 )
	    surahAndAyahNumber="041054"
	    ;;
	4273 )
	    surahAndAyahNumber="042001"
	    ;;
	4274 )
	    surahAndAyahNumber="042002"
	    ;;
	4275 )
	    surahAndAyahNumber="042003"
	    ;;
	4276 )
	    surahAndAyahNumber="042004"
	    ;;
	4277 )
	    surahAndAyahNumber="042005"
	    ;;
	4278 )
	    surahAndAyahNumber="042006"
	    ;;
	4279 )
	    surahAndAyahNumber="042007"
	    ;;
	4280 )
	    surahAndAyahNumber="042008"
	    ;;
	4281 )
	    surahAndAyahNumber="042009"
	    ;;
	4282 )
	    surahAndAyahNumber="042010"
	    ;;
	4283 )
	    surahAndAyahNumber="042011"
	    ;;
	4284 )
	    surahAndAyahNumber="042012"
	    ;;
	4285 )
	    surahAndAyahNumber="042013"
	    ;;
	4286 )
	    surahAndAyahNumber="042014"
	    ;;
	4287 )
	    surahAndAyahNumber="042015"
	    ;;
	4288 )
	    surahAndAyahNumber="042016"
	    ;;
	4289 )
	    surahAndAyahNumber="042017"
	    ;;
	4290 )
	    surahAndAyahNumber="042018"
	    ;;
	4291 )
	    surahAndAyahNumber="042019"
	    ;;
	4292 )
	    surahAndAyahNumber="042020"
	    ;;
	4293 )
	    surahAndAyahNumber="042021"
	    ;;
	4294 )
	    surahAndAyahNumber="042022"
	    ;;
	4295 )
	    surahAndAyahNumber="042023"
	    ;;
	4296 )
	    surahAndAyahNumber="042024"
	    ;;
	4297 )
	    surahAndAyahNumber="042025"
	    ;;
	4298 )
	    surahAndAyahNumber="042026"
	    ;;
	4299 )
	    surahAndAyahNumber="042027"
	    ;;
	4300 )
	    surahAndAyahNumber="042028"
	    ;;
	4301 )
	    surahAndAyahNumber="042029"
	    ;;
	4302 )
	    surahAndAyahNumber="042030"
	    ;;
	4303 )
	    surahAndAyahNumber="042031"
	    ;;
	4304 )
	    surahAndAyahNumber="042032"
	    ;;
	4305 )
	    surahAndAyahNumber="042033"
	    ;;
	4306 )
	    surahAndAyahNumber="042034"
	    ;;
	4307 )
	    surahAndAyahNumber="042035"
	    ;;
	4308 )
	    surahAndAyahNumber="042036"
	    ;;
	4309 )
	    surahAndAyahNumber="042037"
	    ;;
	4310 )
	    surahAndAyahNumber="042038"
	    ;;
	4311 )
	    surahAndAyahNumber="042039"
	    ;;
	4312 )
	    surahAndAyahNumber="042040"
	    ;;
	4313 )
	    surahAndAyahNumber="042041"
	    ;;
	4314 )
	    surahAndAyahNumber="042042"
	    ;;
	4315 )
	    surahAndAyahNumber="042043"
	    ;;
	4316 )
	    surahAndAyahNumber="042044"
	    ;;
	4317 )
	    surahAndAyahNumber="042045"
	    ;;
	4318 )
	    surahAndAyahNumber="042046"
	    ;;
	4319 )
	    surahAndAyahNumber="042047"
	    ;;
	4320 )
	    surahAndAyahNumber="042048"
	    ;;
	4321 )
	    surahAndAyahNumber="042049"
	    ;;
	4322 )
	    surahAndAyahNumber="042050"
	    ;;
	4323 )
	    surahAndAyahNumber="042051"
	    ;;
	4324 )
	    surahAndAyahNumber="042052"
	    ;;
	4325 )
	    surahAndAyahNumber="042053"
	    ;;
	4326 )
	    surahAndAyahNumber="043001"
	    ;;
	4327 )
	    surahAndAyahNumber="043002"
	    ;;
	4328 )
	    surahAndAyahNumber="043003"
	    ;;
	4329 )
	    surahAndAyahNumber="043004"
	    ;;
	4330 )
	    surahAndAyahNumber="043005"
	    ;;
	4331 )
	    surahAndAyahNumber="043006"
	    ;;
	4332 )
	    surahAndAyahNumber="043007"
	    ;;
	4333 )
	    surahAndAyahNumber="043008"
	    ;;
	4334 )
	    surahAndAyahNumber="043009"
	    ;;
	4335 )
	    surahAndAyahNumber="043010"
	    ;;
	4336 )
	    surahAndAyahNumber="043011"
	    ;;
	4337 )
	    surahAndAyahNumber="043012"
	    ;;
	4338 )
	    surahAndAyahNumber="043013"
	    ;;
	4339 )
	    surahAndAyahNumber="043014"
	    ;;
	4340 )
	    surahAndAyahNumber="043015"
	    ;;
	4341 )
	    surahAndAyahNumber="043016"
	    ;;
	4342 )
	    surahAndAyahNumber="043017"
	    ;;
	4343 )
	    surahAndAyahNumber="043018"
	    ;;
	4344 )
	    surahAndAyahNumber="043019"
	    ;;
	4345 )
	    surahAndAyahNumber="043020"
	    ;;
	4346 )
	    surahAndAyahNumber="043021"
	    ;;
	4347 )
	    surahAndAyahNumber="043022"
	    ;;
	4348 )
	    surahAndAyahNumber="043023"
	    ;;
	4349 )
	    surahAndAyahNumber="043024"
	    ;;
	4350 )
	    surahAndAyahNumber="043025"
	    ;;
	4351 )
	    surahAndAyahNumber="043026"
	    ;;
	4352 )
	    surahAndAyahNumber="043027"
	    ;;
	4353 )
	    surahAndAyahNumber="043028"
	    ;;
	4354 )
	    surahAndAyahNumber="043029"
	    ;;
	4355 )
	    surahAndAyahNumber="043030"
	    ;;
	4356 )
	    surahAndAyahNumber="043031"
	    ;;
	4357 )
	    surahAndAyahNumber="043032"
	    ;;
	4358 )
	    surahAndAyahNumber="043033"
	    ;;
	4359 )
	    surahAndAyahNumber="043034"
	    ;;
	4360 )
	    surahAndAyahNumber="043035"
	    ;;
	4361 )
	    surahAndAyahNumber="043036"
	    ;;
	4362 )
	    surahAndAyahNumber="043037"
	    ;;
	4363 )
	    surahAndAyahNumber="043038"
	    ;;
	4364 )
	    surahAndAyahNumber="043039"
	    ;;
	4365 )
	    surahAndAyahNumber="043040"
	    ;;
	4366 )
	    surahAndAyahNumber="043041"
	    ;;
	4367 )
	    surahAndAyahNumber="043042"
	    ;;
	4368 )
	    surahAndAyahNumber="043043"
	    ;;
	4369 )
	    surahAndAyahNumber="043044"
	    ;;
	4370 )
	    surahAndAyahNumber="043045"
	    ;;
	4371 )
	    surahAndAyahNumber="043046"
	    ;;
	4372 )
	    surahAndAyahNumber="043047"
	    ;;
	4373 )
	    surahAndAyahNumber="043048"
	    ;;
	4374 )
	    surahAndAyahNumber="043049"
	    ;;
	4375 )
	    surahAndAyahNumber="043050"
	    ;;
	4376 )
	    surahAndAyahNumber="043051"
	    ;;
	4377 )
	    surahAndAyahNumber="043052"
	    ;;
	4378 )
	    surahAndAyahNumber="043053"
	    ;;
	4379 )
	    surahAndAyahNumber="043054"
	    ;;
	4380 )
	    surahAndAyahNumber="043055"
	    ;;
	4381 )
	    surahAndAyahNumber="043056"
	    ;;
	4382 )
	    surahAndAyahNumber="043057"
	    ;;
	4383 )
	    surahAndAyahNumber="043058"
	    ;;
	4384 )
	    surahAndAyahNumber="043059"
	    ;;
	4385 )
	    surahAndAyahNumber="043060"
	    ;;
	4386 )
	    surahAndAyahNumber="043061"
	    ;;
	4387 )
	    surahAndAyahNumber="043062"
	    ;;
	4388 )
	    surahAndAyahNumber="043063"
	    ;;
	4389 )
	    surahAndAyahNumber="043064"
	    ;;
	4390 )
	    surahAndAyahNumber="043065"
	    ;;
	4391 )
	    surahAndAyahNumber="043066"
	    ;;
	4392 )
	    surahAndAyahNumber="043067"
	    ;;
	4393 )
	    surahAndAyahNumber="043068"
	    ;;
	4394 )
	    surahAndAyahNumber="043069"
	    ;;
	4395 )
	    surahAndAyahNumber="043070"
	    ;;
	4396 )
	    surahAndAyahNumber="043071"
	    ;;
	4397 )
	    surahAndAyahNumber="043072"
	    ;;
	4398 )
	    surahAndAyahNumber="043073"
	    ;;
	4399 )
	    surahAndAyahNumber="043074"
	    ;;
	4400 )
	    surahAndAyahNumber="043075"
	    ;;
	4401 )
	    surahAndAyahNumber="043076"
	    ;;
	4402 )
	    surahAndAyahNumber="043077"
	    ;;
	4403 )
	    surahAndAyahNumber="043078"
	    ;;
	4404 )
	    surahAndAyahNumber="043079"
	    ;;
	4405 )
	    surahAndAyahNumber="043080"
	    ;;
	4406 )
	    surahAndAyahNumber="043081"
	    ;;
	4407 )
	    surahAndAyahNumber="043082"
	    ;;
	4408 )
	    surahAndAyahNumber="043083"
	    ;;
	4409 )
	    surahAndAyahNumber="043084"
	    ;;
	4410 )
	    surahAndAyahNumber="043085"
	    ;;
	4411 )
	    surahAndAyahNumber="043086"
	    ;;
	4412 )
	    surahAndAyahNumber="043087"
	    ;;
	4413 )
	    surahAndAyahNumber="043088"
	    ;;
	4414 )
	    surahAndAyahNumber="043089"
	    ;;
	4415 )
	    surahAndAyahNumber="044001"
	    ;;
	4416 )
	    surahAndAyahNumber="044002"
	    ;;
	4417 )
	    surahAndAyahNumber="044003"
	    ;;
	4418 )
	    surahAndAyahNumber="044004"
	    ;;
	4419 )
	    surahAndAyahNumber="044005"
	    ;;
	4420 )
	    surahAndAyahNumber="044006"
	    ;;
	4421 )
	    surahAndAyahNumber="044007"
	    ;;
	4422 )
	    surahAndAyahNumber="044008"
	    ;;
	4423 )
	    surahAndAyahNumber="044009"
	    ;;
	4424 )
	    surahAndAyahNumber="044010"
	    ;;
	4425 )
	    surahAndAyahNumber="044011"
	    ;;
	4426 )
	    surahAndAyahNumber="044012"
	    ;;
	4427 )
	    surahAndAyahNumber="044013"
	    ;;
	4428 )
	    surahAndAyahNumber="044014"
	    ;;
	4429 )
	    surahAndAyahNumber="044015"
	    ;;
	4430 )
	    surahAndAyahNumber="044016"
	    ;;
	4431 )
	    surahAndAyahNumber="044017"
	    ;;
	4432 )
	    surahAndAyahNumber="044018"
	    ;;
	4433 )
	    surahAndAyahNumber="044019"
	    ;;
	4434 )
	    surahAndAyahNumber="044020"
	    ;;
	4435 )
	    surahAndAyahNumber="044021"
	    ;;
	4436 )
	    surahAndAyahNumber="044022"
	    ;;
	4437 )
	    surahAndAyahNumber="044023"
	    ;;
	4438 )
	    surahAndAyahNumber="044024"
	    ;;
	4439 )
	    surahAndAyahNumber="044025"
	    ;;
	4440 )
	    surahAndAyahNumber="044026"
	    ;;
	4441 )
	    surahAndAyahNumber="044027"
	    ;;
	4442 )
	    surahAndAyahNumber="044028"
	    ;;
	4443 )
	    surahAndAyahNumber="044029"
	    ;;
	4444 )
	    surahAndAyahNumber="044030"
	    ;;
	4445 )
	    surahAndAyahNumber="044031"
	    ;;
	4446 )
	    surahAndAyahNumber="044032"
	    ;;
	4447 )
	    surahAndAyahNumber="044033"
	    ;;
	4448 )
	    surahAndAyahNumber="044034"
	    ;;
	4449 )
	    surahAndAyahNumber="044035"
	    ;;
	4450 )
	    surahAndAyahNumber="044036"
	    ;;
	4451 )
	    surahAndAyahNumber="044037"
	    ;;
	4452 )
	    surahAndAyahNumber="044038"
	    ;;
	4453 )
	    surahAndAyahNumber="044039"
	    ;;
	4454 )
	    surahAndAyahNumber="044040"
	    ;;
	4455 )
	    surahAndAyahNumber="044041"
	    ;;
	4456 )
	    surahAndAyahNumber="044042"
	    ;;
	4457 )
	    surahAndAyahNumber="044043"
	    ;;
	4458 )
	    surahAndAyahNumber="044044"
	    ;;
	4459 )
	    surahAndAyahNumber="044045"
	    ;;
	4460 )
	    surahAndAyahNumber="044046"
	    ;;
	4461 )
	    surahAndAyahNumber="044047"
	    ;;
	4462 )
	    surahAndAyahNumber="044048"
	    ;;
	4463 )
	    surahAndAyahNumber="044049"
	    ;;
	4464 )
	    surahAndAyahNumber="044050"
	    ;;
	4465 )
	    surahAndAyahNumber="044051"
	    ;;
	4466 )
	    surahAndAyahNumber="044052"
	    ;;
	4467 )
	    surahAndAyahNumber="044053"
	    ;;
	4468 )
	    surahAndAyahNumber="044054"
	    ;;
	4469 )
	    surahAndAyahNumber="044055"
	    ;;
	4470 )
	    surahAndAyahNumber="044056"
	    ;;
	4471 )
	    surahAndAyahNumber="044057"
	    ;;
	4472 )
	    surahAndAyahNumber="044058"
	    ;;
	4473 )
	    surahAndAyahNumber="044059"
	    ;;
	4474 )
	    surahAndAyahNumber="045001"
	    ;;
	4475 )
	    surahAndAyahNumber="045002"
	    ;;
	4476 )
	    surahAndAyahNumber="045003"
	    ;;
	4477 )
	    surahAndAyahNumber="045004"
	    ;;
	4478 )
	    surahAndAyahNumber="045005"
	    ;;
	4479 )
	    surahAndAyahNumber="045006"
	    ;;
	4480 )
	    surahAndAyahNumber="045007"
	    ;;
	4481 )
	    surahAndAyahNumber="045008"
	    ;;
	4482 )
	    surahAndAyahNumber="045009"
	    ;;
	4483 )
	    surahAndAyahNumber="045010"
	    ;;
	4484 )
	    surahAndAyahNumber="045011"
	    ;;
	4485 )
	    surahAndAyahNumber="045012"
	    ;;
	4486 )
	    surahAndAyahNumber="045013"
	    ;;
	4487 )
	    surahAndAyahNumber="045014"
	    ;;
	4488 )
	    surahAndAyahNumber="045015"
	    ;;
	4489 )
	    surahAndAyahNumber="045016"
	    ;;
	4490 )
	    surahAndAyahNumber="045017"
	    ;;
	4491 )
	    surahAndAyahNumber="045018"
	    ;;
	4492 )
	    surahAndAyahNumber="045019"
	    ;;
	4493 )
	    surahAndAyahNumber="045020"
	    ;;
	4494 )
	    surahAndAyahNumber="045021"
	    ;;
	4495 )
	    surahAndAyahNumber="045022"
	    ;;
	4496 )
	    surahAndAyahNumber="045023"
	    ;;
	4497 )
	    surahAndAyahNumber="045024"
	    ;;
	4498 )
	    surahAndAyahNumber="045025"
	    ;;
	4499 )
	    surahAndAyahNumber="045026"
	    ;;
	4500 )
	    surahAndAyahNumber="045027"
	    ;;
	4501 )
	    surahAndAyahNumber="045028"
	    ;;
	4502 )
	    surahAndAyahNumber="045029"
	    ;;
	4503 )
	    surahAndAyahNumber="045030"
	    ;;
	4504 )
	    surahAndAyahNumber="045031"
	    ;;
	4505 )
	    surahAndAyahNumber="045032"
	    ;;
	4506 )
	    surahAndAyahNumber="045033"
	    ;;
	4507 )
	    surahAndAyahNumber="045034"
	    ;;
	4508 )
	    surahAndAyahNumber="045035"
	    ;;
	4509 )
	    surahAndAyahNumber="045036"
	    ;;
	4510 )
	    surahAndAyahNumber="045037"
	    ;;
	4511 )
	    surahAndAyahNumber="046001"
	    ;;
	4512 )
	    surahAndAyahNumber="046002"
	    ;;
	4513 )
	    surahAndAyahNumber="046003"
	    ;;
	4514 )
	    surahAndAyahNumber="046004"
	    ;;
	4515 )
	    surahAndAyahNumber="046005"
	    ;;
	4516 )
	    surahAndAyahNumber="046006"
	    ;;
	4517 )
	    surahAndAyahNumber="046007"
	    ;;
	4518 )
	    surahAndAyahNumber="046008"
	    ;;
	4519 )
	    surahAndAyahNumber="046009"
	    ;;
	4520 )
	    surahAndAyahNumber="046010"
	    ;;
	4521 )
	    surahAndAyahNumber="046011"
	    ;;
	4522 )
	    surahAndAyahNumber="046012"
	    ;;
	4523 )
	    surahAndAyahNumber="046013"
	    ;;
	4524 )
	    surahAndAyahNumber="046014"
	    ;;
	4525 )
	    surahAndAyahNumber="046015"
	    ;;
	4526 )
	    surahAndAyahNumber="046016"
	    ;;
	4527 )
	    surahAndAyahNumber="046017"
	    ;;
	4528 )
	    surahAndAyahNumber="046018"
	    ;;
	4529 )
	    surahAndAyahNumber="046019"
	    ;;
	4530 )
	    surahAndAyahNumber="046020"
	    ;;
	4531 )
	    surahAndAyahNumber="046021"
	    ;;
	4532 )
	    surahAndAyahNumber="046022"
	    ;;
	4533 )
	    surahAndAyahNumber="046023"
	    ;;
	4534 )
	    surahAndAyahNumber="046024"
	    ;;
	4535 )
	    surahAndAyahNumber="046025"
	    ;;
	4536 )
	    surahAndAyahNumber="046026"
	    ;;
	4537 )
	    surahAndAyahNumber="046027"
	    ;;
	4538 )
	    surahAndAyahNumber="046028"
	    ;;
	4539 )
	    surahAndAyahNumber="046029"
	    ;;
	4540 )
	    surahAndAyahNumber="046030"
	    ;;
	4541 )
	    surahAndAyahNumber="046031"
	    ;;
	4542 )
	    surahAndAyahNumber="046032"
	    ;;
	4543 )
	    surahAndAyahNumber="046033"
	    ;;
	4544 )
	    surahAndAyahNumber="046034"
	    ;;
	4545 )
	    surahAndAyahNumber="046035"
	    ;;
	4546 )
	    surahAndAyahNumber="047001"
	    ;;
	4547 )
	    surahAndAyahNumber="047002"
	    ;;
	4548 )
	    surahAndAyahNumber="047003"
	    ;;
	4549 )
	    surahAndAyahNumber="047004"
	    ;;
	4550 )
	    surahAndAyahNumber="047005"
	    ;;
	4551 )
	    surahAndAyahNumber="047006"
	    ;;
	4552 )
	    surahAndAyahNumber="047007"
	    ;;
	4553 )
	    surahAndAyahNumber="047008"
	    ;;
	4554 )
	    surahAndAyahNumber="047009"
	    ;;
	4555 )
	    surahAndAyahNumber="047010"
	    ;;
	4556 )
	    surahAndAyahNumber="047011"
	    ;;
	4557 )
	    surahAndAyahNumber="047012"
	    ;;
	4558 )
	    surahAndAyahNumber="047013"
	    ;;
	4559 )
	    surahAndAyahNumber="047014"
	    ;;
	4560 )
	    surahAndAyahNumber="047015"
	    ;;
	4561 )
	    surahAndAyahNumber="047016"
	    ;;
	4562 )
	    surahAndAyahNumber="047017"
	    ;;
	4563 )
	    surahAndAyahNumber="047018"
	    ;;
	4564 )
	    surahAndAyahNumber="047019"
	    ;;
	4565 )
	    surahAndAyahNumber="047020"
	    ;;
	4566 )
	    surahAndAyahNumber="047021"
	    ;;
	4567 )
	    surahAndAyahNumber="047022"
	    ;;
	4568 )
	    surahAndAyahNumber="047023"
	    ;;
	4569 )
	    surahAndAyahNumber="047024"
	    ;;
	4570 )
	    surahAndAyahNumber="047025"
	    ;;
	4571 )
	    surahAndAyahNumber="047026"
	    ;;
	4572 )
	    surahAndAyahNumber="047027"
	    ;;
	4573 )
	    surahAndAyahNumber="047028"
	    ;;
	4574 )
	    surahAndAyahNumber="047029"
	    ;;
	4575 )
	    surahAndAyahNumber="047030"
	    ;;
	4576 )
	    surahAndAyahNumber="047031"
	    ;;
	4577 )
	    surahAndAyahNumber="047032"
	    ;;
	4578 )
	    surahAndAyahNumber="047033"
	    ;;
	4579 )
	    surahAndAyahNumber="047034"
	    ;;
	4580 )
	    surahAndAyahNumber="047035"
	    ;;
	4581 )
	    surahAndAyahNumber="047036"
	    ;;
	4582 )
	    surahAndAyahNumber="047037"
	    ;;
	4583 )
	    surahAndAyahNumber="047038"
	    ;;
	4584 )
	    surahAndAyahNumber="048001"
	    ;;
	4585 )
	    surahAndAyahNumber="048002"
	    ;;
	4586 )
	    surahAndAyahNumber="048003"
	    ;;
	4587 )
	    surahAndAyahNumber="048004"
	    ;;
	4588 )
	    surahAndAyahNumber="048005"
	    ;;
	4589 )
	    surahAndAyahNumber="048006"
	    ;;
	4590 )
	    surahAndAyahNumber="048007"
	    ;;
	4591 )
	    surahAndAyahNumber="048008"
	    ;;
	4592 )
	    surahAndAyahNumber="048009"
	    ;;
	4593 )
	    surahAndAyahNumber="048010"
	    ;;
	4594 )
	    surahAndAyahNumber="048011"
	    ;;
	4595 )
	    surahAndAyahNumber="048012"
	    ;;
	4596 )
	    surahAndAyahNumber="048013"
	    ;;
	4597 )
	    surahAndAyahNumber="048014"
	    ;;
	4598 )
	    surahAndAyahNumber="048015"
	    ;;
	4599 )
	    surahAndAyahNumber="048016"
	    ;;
	4600 )
	    surahAndAyahNumber="048017"
	    ;;
	4601 )
	    surahAndAyahNumber="048018"
	    ;;
	4602 )
	    surahAndAyahNumber="048019"
	    ;;
	4603 )
	    surahAndAyahNumber="048020"
	    ;;
	4604 )
	    surahAndAyahNumber="048021"
	    ;;
	4605 )
	    surahAndAyahNumber="048022"
	    ;;
	4606 )
	    surahAndAyahNumber="048023"
	    ;;
	4607 )
	    surahAndAyahNumber="048024"
	    ;;
	4608 )
	    surahAndAyahNumber="048025"
	    ;;
	4609 )
	    surahAndAyahNumber="048026"
	    ;;
	4610 )
	    surahAndAyahNumber="048027"
	    ;;
	4611 )
	    surahAndAyahNumber="048028"
	    ;;
	4612 )
	    surahAndAyahNumber="048029"
	    ;;
	4613 )
	    surahAndAyahNumber="049001"
	    ;;
	4614 )
	    surahAndAyahNumber="049002"
	    ;;
	4615 )
	    surahAndAyahNumber="049003"
	    ;;
	4616 )
	    surahAndAyahNumber="049004"
	    ;;
	4617 )
	    surahAndAyahNumber="049005"
	    ;;
	4618 )
	    surahAndAyahNumber="049006"
	    ;;
	4619 )
	    surahAndAyahNumber="049007"
	    ;;
	4620 )
	    surahAndAyahNumber="049008"
	    ;;
	4621 )
	    surahAndAyahNumber="049009"
	    ;;
	4622 )
	    surahAndAyahNumber="049010"
	    ;;
	4623 )
	    surahAndAyahNumber="049011"
	    ;;
	4624 )
	    surahAndAyahNumber="049012"
	    ;;
	4625 )
	    surahAndAyahNumber="049013"
	    ;;
	4626 )
	    surahAndAyahNumber="049014"
	    ;;
	4627 )
	    surahAndAyahNumber="049015"
	    ;;
	4628 )
	    surahAndAyahNumber="049016"
	    ;;
	4629 )
	    surahAndAyahNumber="049017"
	    ;;
	4630 )
	    surahAndAyahNumber="049018"
	    ;;
	4631 )
	    surahAndAyahNumber="050001"
	    ;;
	4632 )
	    surahAndAyahNumber="050002"
	    ;;
	4633 )
	    surahAndAyahNumber="050003"
	    ;;
	4634 )
	    surahAndAyahNumber="050004"
	    ;;
	4635 )
	    surahAndAyahNumber="050005"
	    ;;
	4636 )
	    surahAndAyahNumber="050006"
	    ;;
	4637 )
	    surahAndAyahNumber="050007"
	    ;;
	4638 )
	    surahAndAyahNumber="050008"
	    ;;
	4639 )
	    surahAndAyahNumber="050009"
	    ;;
	4640 )
	    surahAndAyahNumber="050010"
	    ;;
	4641 )
	    surahAndAyahNumber="050011"
	    ;;
	4642 )
	    surahAndAyahNumber="050012"
	    ;;
	4643 )
	    surahAndAyahNumber="050013"
	    ;;
	4644 )
	    surahAndAyahNumber="050014"
	    ;;
	4645 )
	    surahAndAyahNumber="050015"
	    ;;
	4646 )
	    surahAndAyahNumber="050016"
	    ;;
	4647 )
	    surahAndAyahNumber="050017"
	    ;;
	4648 )
	    surahAndAyahNumber="050018"
	    ;;
	4649 )
	    surahAndAyahNumber="050019"
	    ;;
	4650 )
	    surahAndAyahNumber="050020"
	    ;;
	4651 )
	    surahAndAyahNumber="050021"
	    ;;
	4652 )
	    surahAndAyahNumber="050022"
	    ;;
	4653 )
	    surahAndAyahNumber="050023"
	    ;;
	4654 )
	    surahAndAyahNumber="050024"
	    ;;
	4655 )
	    surahAndAyahNumber="050025"
	    ;;
	4656 )
	    surahAndAyahNumber="050026"
	    ;;
	4657 )
	    surahAndAyahNumber="050027"
	    ;;
	4658 )
	    surahAndAyahNumber="050028"
	    ;;
	4659 )
	    surahAndAyahNumber="050029"
	    ;;
	4660 )
	    surahAndAyahNumber="050030"
	    ;;
	4661 )
	    surahAndAyahNumber="050031"
	    ;;
	4662 )
	    surahAndAyahNumber="050032"
	    ;;
	4663 )
	    surahAndAyahNumber="050033"
	    ;;
	4664 )
	    surahAndAyahNumber="050034"
	    ;;
	4665 )
	    surahAndAyahNumber="050035"
	    ;;
	4666 )
	    surahAndAyahNumber="050036"
	    ;;
	4667 )
	    surahAndAyahNumber="050037"
	    ;;
	4668 )
	    surahAndAyahNumber="050038"
	    ;;
	4669 )
	    surahAndAyahNumber="050039"
	    ;;
	4670 )
	    surahAndAyahNumber="050040"
	    ;;
	4671 )
	    surahAndAyahNumber="050041"
	    ;;
	4672 )
	    surahAndAyahNumber="050042"
	    ;;
	4673 )
	    surahAndAyahNumber="050043"
	    ;;
	4674 )
	    surahAndAyahNumber="050044"
	    ;;
	4675 )
	    surahAndAyahNumber="050045"
	    ;;
	4676 )
	    surahAndAyahNumber="051001"
	    ;;
	4677 )
	    surahAndAyahNumber="051002"
	    ;;
	4678 )
	    surahAndAyahNumber="051003"
	    ;;
	4679 )
	    surahAndAyahNumber="051004"
	    ;;
	4680 )
	    surahAndAyahNumber="051005"
	    ;;
	4681 )
	    surahAndAyahNumber="051006"
	    ;;
	4682 )
	    surahAndAyahNumber="051007"
	    ;;
	4683 )
	    surahAndAyahNumber="051008"
	    ;;
	4684 )
	    surahAndAyahNumber="051009"
	    ;;
	4685 )
	    surahAndAyahNumber="051010"
	    ;;
	4686 )
	    surahAndAyahNumber="051011"
	    ;;
	4687 )
	    surahAndAyahNumber="051012"
	    ;;
	4688 )
	    surahAndAyahNumber="051013"
	    ;;
	4689 )
	    surahAndAyahNumber="051014"
	    ;;
	4690 )
	    surahAndAyahNumber="051015"
	    ;;
	4691 )
	    surahAndAyahNumber="051016"
	    ;;
	4692 )
	    surahAndAyahNumber="051017"
	    ;;
	4693 )
	    surahAndAyahNumber="051018"
	    ;;
	4694 )
	    surahAndAyahNumber="051019"
	    ;;
	4695 )
	    surahAndAyahNumber="051020"
	    ;;
	4696 )
	    surahAndAyahNumber="051021"
	    ;;
	4697 )
	    surahAndAyahNumber="051022"
	    ;;
	4698 )
	    surahAndAyahNumber="051023"
	    ;;
	4699 )
	    surahAndAyahNumber="051024"
	    ;;
	4700 )
	    surahAndAyahNumber="051025"
	    ;;
	4701 )
	    surahAndAyahNumber="051026"
	    ;;
	4702 )
	    surahAndAyahNumber="051027"
	    ;;
	4703 )
	    surahAndAyahNumber="051028"
	    ;;
	4704 )
	    surahAndAyahNumber="051029"
	    ;;
	4705 )
	    surahAndAyahNumber="051030"
	    ;;
	4706 )
	    surahAndAyahNumber="051031"
	    ;;
	4707 )
	    surahAndAyahNumber="051032"
	    ;;
	4708 )
	    surahAndAyahNumber="051033"
	    ;;
	4709 )
	    surahAndAyahNumber="051034"
	    ;;
	4710 )
	    surahAndAyahNumber="051035"
	    ;;
	4711 )
	    surahAndAyahNumber="051036"
	    ;;
	4712 )
	    surahAndAyahNumber="051037"
	    ;;
	4713 )
	    surahAndAyahNumber="051038"
	    ;;
	4714 )
	    surahAndAyahNumber="051039"
	    ;;
	4715 )
	    surahAndAyahNumber="051040"
	    ;;
	4716 )
	    surahAndAyahNumber="051041"
	    ;;
	4717 )
	    surahAndAyahNumber="051042"
	    ;;
	4718 )
	    surahAndAyahNumber="051043"
	    ;;
	4719 )
	    surahAndAyahNumber="051044"
	    ;;
	4720 )
	    surahAndAyahNumber="051045"
	    ;;
	4721 )
	    surahAndAyahNumber="051046"
	    ;;
	4722 )
	    surahAndAyahNumber="051047"
	    ;;
	4723 )
	    surahAndAyahNumber="051048"
	    ;;
	4724 )
	    surahAndAyahNumber="051049"
	    ;;
	4725 )
	    surahAndAyahNumber="051050"
	    ;;
	4726 )
	    surahAndAyahNumber="051051"
	    ;;
	4727 )
	    surahAndAyahNumber="051052"
	    ;;
	4728 )
	    surahAndAyahNumber="051053"
	    ;;
	4729 )
	    surahAndAyahNumber="051054"
	    ;;
	4730 )
	    surahAndAyahNumber="051055"
	    ;;
	4731 )
	    surahAndAyahNumber="051056"
	    ;;
	4732 )
	    surahAndAyahNumber="051057"
	    ;;
	4733 )
	    surahAndAyahNumber="051058"
	    ;;
	4734 )
	    surahAndAyahNumber="051059"
	    ;;
	4735 )
	    surahAndAyahNumber="051060"
	    ;;
	4736 )
	    surahAndAyahNumber="052001"
	    ;;
	4737 )
	    surahAndAyahNumber="052002"
	    ;;
	4738 )
	    surahAndAyahNumber="052003"
	    ;;
	4739 )
	    surahAndAyahNumber="052004"
	    ;;
	4740 )
	    surahAndAyahNumber="052005"
	    ;;
	4741 )
	    surahAndAyahNumber="052006"
	    ;;
	4742 )
	    surahAndAyahNumber="052007"
	    ;;
	4743 )
	    surahAndAyahNumber="052008"
	    ;;
	4744 )
	    surahAndAyahNumber="052009"
	    ;;
	4745 )
	    surahAndAyahNumber="052010"
	    ;;
	4746 )
	    surahAndAyahNumber="052011"
	    ;;
	4747 )
	    surahAndAyahNumber="052012"
	    ;;
	4748 )
	    surahAndAyahNumber="052013"
	    ;;
	4749 )
	    surahAndAyahNumber="052014"
	    ;;
	4750 )
	    surahAndAyahNumber="052015"
	    ;;
	4751 )
	    surahAndAyahNumber="052016"
	    ;;
	4752 )
	    surahAndAyahNumber="052017"
	    ;;
	4753 )
	    surahAndAyahNumber="052018"
	    ;;
	4754 )
	    surahAndAyahNumber="052019"
	    ;;
	4755 )
	    surahAndAyahNumber="052020"
	    ;;
	4756 )
	    surahAndAyahNumber="052021"
	    ;;
	4757 )
	    surahAndAyahNumber="052022"
	    ;;
	4758 )
	    surahAndAyahNumber="052023"
	    ;;
	4759 )
	    surahAndAyahNumber="052024"
	    ;;
	4760 )
	    surahAndAyahNumber="052025"
	    ;;
	4761 )
	    surahAndAyahNumber="052026"
	    ;;
	4762 )
	    surahAndAyahNumber="052027"
	    ;;
	4763 )
	    surahAndAyahNumber="052028"
	    ;;
	4764 )
	    surahAndAyahNumber="052029"
	    ;;
	4765 )
	    surahAndAyahNumber="052030"
	    ;;
	4766 )
	    surahAndAyahNumber="052031"
	    ;;
	4767 )
	    surahAndAyahNumber="052032"
	    ;;
	4768 )
	    surahAndAyahNumber="052033"
	    ;;
	4769 )
	    surahAndAyahNumber="052034"
	    ;;
	4770 )
	    surahAndAyahNumber="052035"
	    ;;
	4771 )
	    surahAndAyahNumber="052036"
	    ;;
	4772 )
	    surahAndAyahNumber="052037"
	    ;;
	4773 )
	    surahAndAyahNumber="052038"
	    ;;
	4774 )
	    surahAndAyahNumber="052039"
	    ;;
	4775 )
	    surahAndAyahNumber="052040"
	    ;;
	4776 )
	    surahAndAyahNumber="052041"
	    ;;
	4777 )
	    surahAndAyahNumber="052042"
	    ;;
	4778 )
	    surahAndAyahNumber="052043"
	    ;;
	4779 )
	    surahAndAyahNumber="052044"
	    ;;
	4780 )
	    surahAndAyahNumber="052045"
	    ;;
	4781 )
	    surahAndAyahNumber="052046"
	    ;;
	4782 )
	    surahAndAyahNumber="052047"
	    ;;
	4783 )
	    surahAndAyahNumber="052048"
	    ;;
	4784 )
	    surahAndAyahNumber="052049"
	    ;;
	4785 )
	    surahAndAyahNumber="053001"
	    ;;
	4786 )
	    surahAndAyahNumber="053002"
	    ;;
	4787 )
	    surahAndAyahNumber="053003"
	    ;;
	4788 )
	    surahAndAyahNumber="053004"
	    ;;
	4789 )
	    surahAndAyahNumber="053005"
	    ;;
	4790 )
	    surahAndAyahNumber="053006"
	    ;;
	4791 )
	    surahAndAyahNumber="053007"
	    ;;
	4792 )
	    surahAndAyahNumber="053008"
	    ;;
	4793 )
	    surahAndAyahNumber="053009"
	    ;;
	4794 )
	    surahAndAyahNumber="053010"
	    ;;
	4795 )
	    surahAndAyahNumber="053011"
	    ;;
	4796 )
	    surahAndAyahNumber="053012"
	    ;;
	4797 )
	    surahAndAyahNumber="053013"
	    ;;
	4798 )
	    surahAndAyahNumber="053014"
	    ;;
	4799 )
	    surahAndAyahNumber="053015"
	    ;;
	4800 )
	    surahAndAyahNumber="053016"
	    ;;
	4801 )
	    surahAndAyahNumber="053017"
	    ;;
	4802 )
	    surahAndAyahNumber="053018"
	    ;;
	4803 )
	    surahAndAyahNumber="053019"
	    ;;
	4804 )
	    surahAndAyahNumber="053020"
	    ;;
	4805 )
	    surahAndAyahNumber="053021"
	    ;;
	4806 )
	    surahAndAyahNumber="053022"
	    ;;
	4807 )
	    surahAndAyahNumber="053023"
	    ;;
	4808 )
	    surahAndAyahNumber="053024"
	    ;;
	4809 )
	    surahAndAyahNumber="053025"
	    ;;
	4810 )
	    surahAndAyahNumber="053026"
	    ;;
	4811 )
	    surahAndAyahNumber="053027"
	    ;;
	4812 )
	    surahAndAyahNumber="053028"
	    ;;
	4813 )
	    surahAndAyahNumber="053029"
	    ;;
	4814 )
	    surahAndAyahNumber="053030"
	    ;;
	4815 )
	    surahAndAyahNumber="053031"
	    ;;
	4816 )
	    surahAndAyahNumber="053032"
	    ;;
	4817 )
	    surahAndAyahNumber="053033"
	    ;;
	4818 )
	    surahAndAyahNumber="053034"
	    ;;
	4819 )
	    surahAndAyahNumber="053035"
	    ;;
	4820 )
	    surahAndAyahNumber="053036"
	    ;;
	4821 )
	    surahAndAyahNumber="053037"
	    ;;
	4822 )
	    surahAndAyahNumber="053038"
	    ;;
	4823 )
	    surahAndAyahNumber="053039"
	    ;;
	4824 )
	    surahAndAyahNumber="053040"
	    ;;
	4825 )
	    surahAndAyahNumber="053041"
	    ;;
	4826 )
	    surahAndAyahNumber="053042"
	    ;;
	4827 )
	    surahAndAyahNumber="053043"
	    ;;
	4828 )
	    surahAndAyahNumber="053044"
	    ;;
	4829 )
	    surahAndAyahNumber="053045"
	    ;;
	4830 )
	    surahAndAyahNumber="053046"
	    ;;
	4831 )
	    surahAndAyahNumber="053047"
	    ;;
	4832 )
	    surahAndAyahNumber="053048"
	    ;;
	4833 )
	    surahAndAyahNumber="053049"
	    ;;
	4834 )
	    surahAndAyahNumber="053050"
	    ;;
	4835 )
	    surahAndAyahNumber="053051"
	    ;;
	4836 )
	    surahAndAyahNumber="053052"
	    ;;
	4837 )
	    surahAndAyahNumber="053053"
	    ;;
	4838 )
	    surahAndAyahNumber="053054"
	    ;;
	4839 )
	    surahAndAyahNumber="053055"
	    ;;
	4840 )
	    surahAndAyahNumber="053056"
	    ;;
	4841 )
	    surahAndAyahNumber="053057"
	    ;;
	4842 )
	    surahAndAyahNumber="053058"
	    ;;
	4843 )
	    surahAndAyahNumber="053059"
	    ;;
	4844 )
	    surahAndAyahNumber="053060"
	    ;;
	4845 )
	    surahAndAyahNumber="053061"
	    ;;
	4846 )
	    surahAndAyahNumber="053062"
	    ;;
	4847 )
	    surahAndAyahNumber="054001"
	    ;;
	4848 )
	    surahAndAyahNumber="054002"
	    ;;
	4849 )
	    surahAndAyahNumber="054003"
	    ;;
	4850 )
	    surahAndAyahNumber="054004"
	    ;;
	4851 )
	    surahAndAyahNumber="054005"
	    ;;
	4852 )
	    surahAndAyahNumber="054006"
	    ;;
	4853 )
	    surahAndAyahNumber="054007"
	    ;;
	4854 )
	    surahAndAyahNumber="054008"
	    ;;
	4855 )
	    surahAndAyahNumber="054009"
	    ;;
	4856 )
	    surahAndAyahNumber="054010"
	    ;;
	4857 )
	    surahAndAyahNumber="054011"
	    ;;
	4858 )
	    surahAndAyahNumber="054012"
	    ;;
	4859 )
	    surahAndAyahNumber="054013"
	    ;;
	4860 )
	    surahAndAyahNumber="054014"
	    ;;
	4861 )
	    surahAndAyahNumber="054015"
	    ;;
	4862 )
	    surahAndAyahNumber="054016"
	    ;;
	4863 )
	    surahAndAyahNumber="054017"
	    ;;
	4864 )
	    surahAndAyahNumber="054018"
	    ;;
	4865 )
	    surahAndAyahNumber="054019"
	    ;;
	4866 )
	    surahAndAyahNumber="054020"
	    ;;
	4867 )
	    surahAndAyahNumber="054021"
	    ;;
	4868 )
	    surahAndAyahNumber="054022"
	    ;;
	4869 )
	    surahAndAyahNumber="054023"
	    ;;
	4870 )
	    surahAndAyahNumber="054024"
	    ;;
	4871 )
	    surahAndAyahNumber="054025"
	    ;;
	4872 )
	    surahAndAyahNumber="054026"
	    ;;
	4873 )
	    surahAndAyahNumber="054027"
	    ;;
	4874 )
	    surahAndAyahNumber="054028"
	    ;;
	4875 )
	    surahAndAyahNumber="054029"
	    ;;
	4876 )
	    surahAndAyahNumber="054030"
	    ;;
	4877 )
	    surahAndAyahNumber="054031"
	    ;;
	4878 )
	    surahAndAyahNumber="054032"
	    ;;
	4879 )
	    surahAndAyahNumber="054033"
	    ;;
	4880 )
	    surahAndAyahNumber="054034"
	    ;;
	4881 )
	    surahAndAyahNumber="054035"
	    ;;
	4882 )
	    surahAndAyahNumber="054036"
	    ;;
	4883 )
	    surahAndAyahNumber="054037"
	    ;;
	4884 )
	    surahAndAyahNumber="054038"
	    ;;
	4885 )
	    surahAndAyahNumber="054039"
	    ;;
	4886 )
	    surahAndAyahNumber="054040"
	    ;;
	4887 )
	    surahAndAyahNumber="054041"
	    ;;
	4888 )
	    surahAndAyahNumber="054042"
	    ;;
	4889 )
	    surahAndAyahNumber="054043"
	    ;;
	4890 )
	    surahAndAyahNumber="054044"
	    ;;
	4891 )
	    surahAndAyahNumber="054045"
	    ;;
	4892 )
	    surahAndAyahNumber="054046"
	    ;;
	4893 )
	    surahAndAyahNumber="054047"
	    ;;
	4894 )
	    surahAndAyahNumber="054048"
	    ;;
	4895 )
	    surahAndAyahNumber="054049"
	    ;;
	4896 )
	    surahAndAyahNumber="054050"
	    ;;
	4897 )
	    surahAndAyahNumber="054051"
	    ;;
	4898 )
	    surahAndAyahNumber="054052"
	    ;;
	4899 )
	    surahAndAyahNumber="054053"
	    ;;
	4900 )
	    surahAndAyahNumber="054054"
	    ;;
	4901 )
	    surahAndAyahNumber="054055"
	    ;;
	4902 )
	    surahAndAyahNumber="055001"
	    ;;
	4903 )
	    surahAndAyahNumber="055002"
	    ;;
	4904 )
	    surahAndAyahNumber="055003"
	    ;;
	4905 )
	    surahAndAyahNumber="055004"
	    ;;
	4906 )
	    surahAndAyahNumber="055005"
	    ;;
	4907 )
	    surahAndAyahNumber="055006"
	    ;;
	4908 )
	    surahAndAyahNumber="055007"
	    ;;
	4909 )
	    surahAndAyahNumber="055008"
	    ;;
	4910 )
	    surahAndAyahNumber="055009"
	    ;;
	4911 )
	    surahAndAyahNumber="055010"
	    ;;
	4912 )
	    surahAndAyahNumber="055011"
	    ;;
	4913 )
	    surahAndAyahNumber="055012"
	    ;;
	4914 )
	    surahAndAyahNumber="055013"
	    ;;
	4915 )
	    surahAndAyahNumber="055014"
	    ;;
	4916 )
	    surahAndAyahNumber="055015"
	    ;;
	4917 )
	    surahAndAyahNumber="055016"
	    ;;
	4918 )
	    surahAndAyahNumber="055017"
	    ;;
	4919 )
	    surahAndAyahNumber="055018"
	    ;;
	4920 )
	    surahAndAyahNumber="055019"
	    ;;
	4921 )
	    surahAndAyahNumber="055020"
	    ;;
	4922 )
	    surahAndAyahNumber="055021"
	    ;;
	4923 )
	    surahAndAyahNumber="055022"
	    ;;
	4924 )
	    surahAndAyahNumber="055023"
	    ;;
	4925 )
	    surahAndAyahNumber="055024"
	    ;;
	4926 )
	    surahAndAyahNumber="055025"
	    ;;
	4927 )
	    surahAndAyahNumber="055026"
	    ;;
	4928 )
	    surahAndAyahNumber="055027"
	    ;;
	4929 )
	    surahAndAyahNumber="055028"
	    ;;
	4930 )
	    surahAndAyahNumber="055029"
	    ;;
	4931 )
	    surahAndAyahNumber="055030"
	    ;;
	4932 )
	    surahAndAyahNumber="055031"
	    ;;
	4933 )
	    surahAndAyahNumber="055032"
	    ;;
	4934 )
	    surahAndAyahNumber="055033"
	    ;;
	4935 )
	    surahAndAyahNumber="055034"
	    ;;
	4936 )
	    surahAndAyahNumber="055035"
	    ;;
	4937 )
	    surahAndAyahNumber="055036"
	    ;;
	4938 )
	    surahAndAyahNumber="055037"
	    ;;
	4939 )
	    surahAndAyahNumber="055038"
	    ;;
	4940 )
	    surahAndAyahNumber="055039"
	    ;;
	4941 )
	    surahAndAyahNumber="055040"
	    ;;
	4942 )
	    surahAndAyahNumber="055041"
	    ;;
	4943 )
	    surahAndAyahNumber="055042"
	    ;;
	4944 )
	    surahAndAyahNumber="055043"
	    ;;
	4945 )
	    surahAndAyahNumber="055044"
	    ;;
	4946 )
	    surahAndAyahNumber="055045"
	    ;;
	4947 )
	    surahAndAyahNumber="055046"
	    ;;
	4948 )
	    surahAndAyahNumber="055047"
	    ;;
	4949 )
	    surahAndAyahNumber="055048"
	    ;;
	4950 )
	    surahAndAyahNumber="055049"
	    ;;
	4951 )
	    surahAndAyahNumber="055050"
	    ;;
	4952 )
	    surahAndAyahNumber="055051"
	    ;;
	4953 )
	    surahAndAyahNumber="055052"
	    ;;
	4954 )
	    surahAndAyahNumber="055053"
	    ;;
	4955 )
	    surahAndAyahNumber="055054"
	    ;;
	4956 )
	    surahAndAyahNumber="055055"
	    ;;
	4957 )
	    surahAndAyahNumber="055056"
	    ;;
	4958 )
	    surahAndAyahNumber="055057"
	    ;;
	4959 )
	    surahAndAyahNumber="055058"
	    ;;
	4960 )
	    surahAndAyahNumber="055059"
	    ;;
	4961 )
	    surahAndAyahNumber="055060"
	    ;;
	4962 )
	    surahAndAyahNumber="055061"
	    ;;
	4963 )
	    surahAndAyahNumber="055062"
	    ;;
	4964 )
	    surahAndAyahNumber="055063"
	    ;;
	4965 )
	    surahAndAyahNumber="055064"
	    ;;
	4966 )
	    surahAndAyahNumber="055065"
	    ;;
	4967 )
	    surahAndAyahNumber="055066"
	    ;;
	4968 )
	    surahAndAyahNumber="055067"
	    ;;
	4969 )
	    surahAndAyahNumber="055068"
	    ;;
	4970 )
	    surahAndAyahNumber="055069"
	    ;;
	4971 )
	    surahAndAyahNumber="055070"
	    ;;
	4972 )
	    surahAndAyahNumber="055071"
	    ;;
	4973 )
	    surahAndAyahNumber="055072"
	    ;;
	4974 )
	    surahAndAyahNumber="055073"
	    ;;
	4975 )
	    surahAndAyahNumber="055074"
	    ;;
	4976 )
	    surahAndAyahNumber="055075"
	    ;;
	4977 )
	    surahAndAyahNumber="055076"
	    ;;
	4978 )
	    surahAndAyahNumber="055077"
	    ;;
	4979 )
	    surahAndAyahNumber="055078"
	    ;;
	4980 )
	    surahAndAyahNumber="056001"
	    ;;
	4981 )
	    surahAndAyahNumber="056002"
	    ;;
	4982 )
	    surahAndAyahNumber="056003"
	    ;;
	4983 )
	    surahAndAyahNumber="056004"
	    ;;
	4984 )
	    surahAndAyahNumber="056005"
	    ;;
	4985 )
	    surahAndAyahNumber="056006"
	    ;;
	4986 )
	    surahAndAyahNumber="056007"
	    ;;
	4987 )
	    surahAndAyahNumber="056008"
	    ;;
	4988 )
	    surahAndAyahNumber="056009"
	    ;;
	4989 )
	    surahAndAyahNumber="056010"
	    ;;
	4990 )
	    surahAndAyahNumber="056011"
	    ;;
	4991 )
	    surahAndAyahNumber="056012"
	    ;;
	4992 )
	    surahAndAyahNumber="056013"
	    ;;
	4993 )
	    surahAndAyahNumber="056014"
	    ;;
	4994 )
	    surahAndAyahNumber="056015"
	    ;;
	4995 )
	    surahAndAyahNumber="056016"
	    ;;
	4996 )
	    surahAndAyahNumber="056017"
	    ;;
	4997 )
	    surahAndAyahNumber="056018"
	    ;;
	4998 )
	    surahAndAyahNumber="056019"
	    ;;
	4999 )
	    surahAndAyahNumber="056020"
	    ;;
	5000 )
	    surahAndAyahNumber="056021"
	    ;;
	5001 )
	    surahAndAyahNumber="056022"
	    ;;
	5002 )
	    surahAndAyahNumber="056023"
	    ;;
	5003 )
	    surahAndAyahNumber="056024"
	    ;;
	5004 )
	    surahAndAyahNumber="056025"
	    ;;
	5005 )
	    surahAndAyahNumber="056026"
	    ;;
	5006 )
	    surahAndAyahNumber="056027"
	    ;;
	5007 )
	    surahAndAyahNumber="056028"
	    ;;
	5008 )
	    surahAndAyahNumber="056029"
	    ;;
	5009 )
	    surahAndAyahNumber="056030"
	    ;;
	5010 )
	    surahAndAyahNumber="056031"
	    ;;
	5011 )
	    surahAndAyahNumber="056032"
	    ;;
	5012 )
	    surahAndAyahNumber="056033"
	    ;;
	5013 )
	    surahAndAyahNumber="056034"
	    ;;
	5014 )
	    surahAndAyahNumber="056035"
	    ;;
	5015 )
	    surahAndAyahNumber="056036"
	    ;;
	5016 )
	    surahAndAyahNumber="056037"
	    ;;
	5017 )
	    surahAndAyahNumber="056038"
	    ;;
	5018 )
	    surahAndAyahNumber="056039"
	    ;;
	5019 )
	    surahAndAyahNumber="056040"
	    ;;
	5020 )
	    surahAndAyahNumber="056041"
	    ;;
	5021 )
	    surahAndAyahNumber="056042"
	    ;;
	5022 )
	    surahAndAyahNumber="056043"
	    ;;
	5023 )
	    surahAndAyahNumber="056044"
	    ;;
	5024 )
	    surahAndAyahNumber="056045"
	    ;;
	5025 )
	    surahAndAyahNumber="056046"
	    ;;
	5026 )
	    surahAndAyahNumber="056047"
	    ;;
	5027 )
	    surahAndAyahNumber="056048"
	    ;;
	5028 )
	    surahAndAyahNumber="056049"
	    ;;
	5029 )
	    surahAndAyahNumber="056050"
	    ;;
	5030 )
	    surahAndAyahNumber="056051"
	    ;;
	5031 )
	    surahAndAyahNumber="056052"
	    ;;
	5032 )
	    surahAndAyahNumber="056053"
	    ;;
	5033 )
	    surahAndAyahNumber="056054"
	    ;;
	5034 )
	    surahAndAyahNumber="056055"
	    ;;
	5035 )
	    surahAndAyahNumber="056056"
	    ;;
	5036 )
	    surahAndAyahNumber="056057"
	    ;;
	5037 )
	    surahAndAyahNumber="056058"
	    ;;
	5038 )
	    surahAndAyahNumber="056059"
	    ;;
	5039 )
	    surahAndAyahNumber="056060"
	    ;;
	5040 )
	    surahAndAyahNumber="056061"
	    ;;
	5041 )
	    surahAndAyahNumber="056062"
	    ;;
	5042 )
	    surahAndAyahNumber="056063"
	    ;;
	5043 )
	    surahAndAyahNumber="056064"
	    ;;
	5044 )
	    surahAndAyahNumber="056065"
	    ;;
	5045 )
	    surahAndAyahNumber="056066"
	    ;;
	5046 )
	    surahAndAyahNumber="056067"
	    ;;
	5047 )
	    surahAndAyahNumber="056068"
	    ;;
	5048 )
	    surahAndAyahNumber="056069"
	    ;;
	5049 )
	    surahAndAyahNumber="056070"
	    ;;
	5050 )
	    surahAndAyahNumber="056071"
	    ;;
	5051 )
	    surahAndAyahNumber="056072"
	    ;;
	5052 )
	    surahAndAyahNumber="056073"
	    ;;
	5053 )
	    surahAndAyahNumber="056074"
	    ;;
	5054 )
	    surahAndAyahNumber="056075"
	    ;;
	5055 )
	    surahAndAyahNumber="056076"
	    ;;
	5056 )
	    surahAndAyahNumber="056077"
	    ;;
	5057 )
	    surahAndAyahNumber="056078"
	    ;;
	5058 )
	    surahAndAyahNumber="056079"
	    ;;
	5059 )
	    surahAndAyahNumber="056080"
	    ;;
	5060 )
	    surahAndAyahNumber="056081"
	    ;;
	5061 )
	    surahAndAyahNumber="056082"
	    ;;
	5062 )
	    surahAndAyahNumber="056083"
	    ;;
	5063 )
	    surahAndAyahNumber="056084"
	    ;;
	5064 )
	    surahAndAyahNumber="056085"
	    ;;
	5065 )
	    surahAndAyahNumber="056086"
	    ;;
	5066 )
	    surahAndAyahNumber="056087"
	    ;;
	5067 )
	    surahAndAyahNumber="056088"
	    ;;
	5068 )
	    surahAndAyahNumber="056089"
	    ;;
	5069 )
	    surahAndAyahNumber="056090"
	    ;;
	5070 )
	    surahAndAyahNumber="056091"
	    ;;
	5071 )
	    surahAndAyahNumber="056092"
	    ;;
	5072 )
	    surahAndAyahNumber="056093"
	    ;;
	5073 )
	    surahAndAyahNumber="056094"
	    ;;
	5074 )
	    surahAndAyahNumber="056095"
	    ;;
	5075 )
	    surahAndAyahNumber="056096"
	    ;;
	5076 )
	    surahAndAyahNumber="057001"
	    ;;
	5077 )
	    surahAndAyahNumber="057002"
	    ;;
	5078 )
	    surahAndAyahNumber="057003"
	    ;;
	5079 )
	    surahAndAyahNumber="057004"
	    ;;
	5080 )
	    surahAndAyahNumber="057005"
	    ;;
	5081 )
	    surahAndAyahNumber="057006"
	    ;;
	5082 )
	    surahAndAyahNumber="057007"
	    ;;
	5083 )
	    surahAndAyahNumber="057008"
	    ;;
	5084 )
	    surahAndAyahNumber="057009"
	    ;;
	5085 )
	    surahAndAyahNumber="057010"
	    ;;
	5086 )
	    surahAndAyahNumber="057011"
	    ;;
	5087 )
	    surahAndAyahNumber="057012"
	    ;;
	5088 )
	    surahAndAyahNumber="057013"
	    ;;
	5089 )
	    surahAndAyahNumber="057014"
	    ;;
	5090 )
	    surahAndAyahNumber="057015"
	    ;;
	5091 )
	    surahAndAyahNumber="057016"
	    ;;
	5092 )
	    surahAndAyahNumber="057017"
	    ;;
	5093 )
	    surahAndAyahNumber="057018"
	    ;;
	5094 )
	    surahAndAyahNumber="057019"
	    ;;
	5095 )
	    surahAndAyahNumber="057020"
	    ;;
	5096 )
	    surahAndAyahNumber="057021"
	    ;;
	5097 )
	    surahAndAyahNumber="057022"
	    ;;
	5098 )
	    surahAndAyahNumber="057023"
	    ;;
	5099 )
	    surahAndAyahNumber="057024"
	    ;;
	5100 )
	    surahAndAyahNumber="057025"
	    ;;
	5101 )
	    surahAndAyahNumber="057026"
	    ;;
	5102 )
	    surahAndAyahNumber="057027"
	    ;;
	5103 )
	    surahAndAyahNumber="057028"
	    ;;
	5104 )
	    surahAndAyahNumber="057029"
	    ;;
	5105 )
	    surahAndAyahNumber="058001"
	    ;;
	5106 )
	    surahAndAyahNumber="058002"
	    ;;
	5107 )
	    surahAndAyahNumber="058003"
	    ;;
	5108 )
	    surahAndAyahNumber="058004"
	    ;;
	5109 )
	    surahAndAyahNumber="058005"
	    ;;
	5110 )
	    surahAndAyahNumber="058006"
	    ;;
	5111 )
	    surahAndAyahNumber="058007"
	    ;;
	5112 )
	    surahAndAyahNumber="058008"
	    ;;
	5113 )
	    surahAndAyahNumber="058009"
	    ;;
	5114 )
	    surahAndAyahNumber="058010"
	    ;;
	5115 )
	    surahAndAyahNumber="058011"
	    ;;
	5116 )
	    surahAndAyahNumber="058012"
	    ;;
	5117 )
	    surahAndAyahNumber="058013"
	    ;;
	5118 )
	    surahAndAyahNumber="058014"
	    ;;
	5119 )
	    surahAndAyahNumber="058015"
	    ;;
	5120 )
	    surahAndAyahNumber="058016"
	    ;;
	5121 )
	    surahAndAyahNumber="058017"
	    ;;
	5122 )
	    surahAndAyahNumber="058018"
	    ;;
	5123 )
	    surahAndAyahNumber="058019"
	    ;;
	5124 )
	    surahAndAyahNumber="058020"
	    ;;
	5125 )
	    surahAndAyahNumber="058021"
	    ;;
	5126 )
	    surahAndAyahNumber="058022"
	    ;;
	5127 )
	    surahAndAyahNumber="059001"
	    ;;
	5128 )
	    surahAndAyahNumber="059002"
	    ;;
	5129 )
	    surahAndAyahNumber="059003"
	    ;;
	5130 )
	    surahAndAyahNumber="059004"
	    ;;
	5131 )
	    surahAndAyahNumber="059005"
	    ;;
	5132 )
	    surahAndAyahNumber="059006"
	    ;;
	5133 )
	    surahAndAyahNumber="059007"
	    ;;
	5134 )
	    surahAndAyahNumber="059008"
	    ;;
	5135 )
	    surahAndAyahNumber="059009"
	    ;;
	5136 )
	    surahAndAyahNumber="059010"
	    ;;
	5137 )
	    surahAndAyahNumber="059011"
	    ;;
	5138 )
	    surahAndAyahNumber="059012"
	    ;;
	5139 )
	    surahAndAyahNumber="059013"
	    ;;
	5140 )
	    surahAndAyahNumber="059014"
	    ;;
	5141 )
	    surahAndAyahNumber="059015"
	    ;;
	5142 )
	    surahAndAyahNumber="059016"
	    ;;
	5143 )
	    surahAndAyahNumber="059017"
	    ;;
	5144 )
	    surahAndAyahNumber="059018"
	    ;;
	5145 )
	    surahAndAyahNumber="059019"
	    ;;
	5146 )
	    surahAndAyahNumber="059020"
	    ;;
	5147 )
	    surahAndAyahNumber="059021"
	    ;;
	5148 )
	    surahAndAyahNumber="059022"
	    ;;
	5149 )
	    surahAndAyahNumber="059023"
	    ;;
	5150 )
	    surahAndAyahNumber="059024"
	    ;;
	5151 )
	    surahAndAyahNumber="060001"
	    ;;
	5152 )
	    surahAndAyahNumber="060002"
	    ;;
	5153 )
	    surahAndAyahNumber="060003"
	    ;;
	5154 )
	    surahAndAyahNumber="060004"
	    ;;
	5155 )
	    surahAndAyahNumber="060005"
	    ;;
	5156 )
	    surahAndAyahNumber="060006"
	    ;;
	5157 )
	    surahAndAyahNumber="060007"
	    ;;
	5158 )
	    surahAndAyahNumber="060008"
	    ;;
	5159 )
	    surahAndAyahNumber="060009"
	    ;;
	5160 )
	    surahAndAyahNumber="060010"
	    ;;
	5161 )
	    surahAndAyahNumber="060011"
	    ;;
	5162 )
	    surahAndAyahNumber="060012"
	    ;;
	5163 )
	    surahAndAyahNumber="060013"
	    ;;
	5164 )
	    surahAndAyahNumber="061001"
	    ;;
	5165 )
	    surahAndAyahNumber="061002"
	    ;;
	5166 )
	    surahAndAyahNumber="061003"
	    ;;
	5167 )
	    surahAndAyahNumber="061004"
	    ;;
	5168 )
	    surahAndAyahNumber="061005"
	    ;;
	5169 )
	    surahAndAyahNumber="061006"
	    ;;
	5170 )
	    surahAndAyahNumber="061007"
	    ;;
	5171 )
	    surahAndAyahNumber="061008"
	    ;;
	5172 )
	    surahAndAyahNumber="061009"
	    ;;
	5173 )
	    surahAndAyahNumber="061010"
	    ;;
	5174 )
	    surahAndAyahNumber="061011"
	    ;;
	5175 )
	    surahAndAyahNumber="061012"
	    ;;
	5176 )
	    surahAndAyahNumber="061013"
	    ;;
	5177 )
	    surahAndAyahNumber="061014"
	    ;;
	5178 )
	    surahAndAyahNumber="062001"
	    ;;
	5179 )
	    surahAndAyahNumber="062002"
	    ;;
	5180 )
	    surahAndAyahNumber="062003"
	    ;;
	5181 )
	    surahAndAyahNumber="062004"
	    ;;
	5182 )
	    surahAndAyahNumber="062005"
	    ;;
	5183 )
	    surahAndAyahNumber="062006"
	    ;;
	5184 )
	    surahAndAyahNumber="062007"
	    ;;
	5185 )
	    surahAndAyahNumber="062008"
	    ;;
	5186 )
	    surahAndAyahNumber="062009"
	    ;;
	5187 )
	    surahAndAyahNumber="062010"
	    ;;
	5188 )
	    surahAndAyahNumber="062011"
	    ;;
	5189 )
	    surahAndAyahNumber="063001"
	    ;;
	5190 )
	    surahAndAyahNumber="063002"
	    ;;
	5191 )
	    surahAndAyahNumber="063003"
	    ;;
	5192 )
	    surahAndAyahNumber="063004"
	    ;;
	5193 )
	    surahAndAyahNumber="063005"
	    ;;
	5194 )
	    surahAndAyahNumber="063006"
	    ;;
	5195 )
	    surahAndAyahNumber="063007"
	    ;;
	5196 )
	    surahAndAyahNumber="063008"
	    ;;
	5197 )
	    surahAndAyahNumber="063009"
	    ;;
	5198 )
	    surahAndAyahNumber="063010"
	    ;;
	5199 )
	    surahAndAyahNumber="063011"
	    ;;
	5200 )
	    surahAndAyahNumber="064001"
	    ;;
	5201 )
	    surahAndAyahNumber="064002"
	    ;;
	5202 )
	    surahAndAyahNumber="064003"
	    ;;
	5203 )
	    surahAndAyahNumber="064004"
	    ;;
	5204 )
	    surahAndAyahNumber="064005"
	    ;;
	5205 )
	    surahAndAyahNumber="064006"
	    ;;
	5206 )
	    surahAndAyahNumber="064007"
	    ;;
	5207 )
	    surahAndAyahNumber="064008"
	    ;;
	5208 )
	    surahAndAyahNumber="064009"
	    ;;
	5209 )
	    surahAndAyahNumber="064010"
	    ;;
	5210 )
	    surahAndAyahNumber="064011"
	    ;;
	5211 )
	    surahAndAyahNumber="064012"
	    ;;
	5212 )
	    surahAndAyahNumber="064013"
	    ;;
	5213 )
	    surahAndAyahNumber="064014"
	    ;;
	5214 )
	    surahAndAyahNumber="064015"
	    ;;
	5215 )
	    surahAndAyahNumber="064016"
	    ;;
	5216 )
	    surahAndAyahNumber="064017"
	    ;;
	5217 )
	    surahAndAyahNumber="064018"
	    ;;
	5218 )
	    surahAndAyahNumber="065001"
	    ;;
	5219 )
	    surahAndAyahNumber="065002"
	    ;;
	5220 )
	    surahAndAyahNumber="065003"
	    ;;
	5221 )
	    surahAndAyahNumber="065004"
	    ;;
	5222 )
	    surahAndAyahNumber="065005"
	    ;;
	5223 )
	    surahAndAyahNumber="065006"
	    ;;
	5224 )
	    surahAndAyahNumber="065007"
	    ;;
	5225 )
	    surahAndAyahNumber="065008"
	    ;;
	5226 )
	    surahAndAyahNumber="065009"
	    ;;
	5227 )
	    surahAndAyahNumber="065010"
	    ;;
	5228 )
	    surahAndAyahNumber="065011"
	    ;;
	5229 )
	    surahAndAyahNumber="065012"
	    ;;
	5230 )
	    surahAndAyahNumber="066001"
	    ;;
	5231 )
	    surahAndAyahNumber="066002"
	    ;;
	5232 )
	    surahAndAyahNumber="066003"
	    ;;
	5233 )
	    surahAndAyahNumber="066004"
	    ;;
	5234 )
	    surahAndAyahNumber="066005"
	    ;;
	5235 )
	    surahAndAyahNumber="066006"
	    ;;
	5236 )
	    surahAndAyahNumber="066007"
	    ;;
	5237 )
	    surahAndAyahNumber="066008"
	    ;;
	5238 )
	    surahAndAyahNumber="066009"
	    ;;
	5239 )
	    surahAndAyahNumber="066010"
	    ;;
	5240 )
	    surahAndAyahNumber="066011"
	    ;;
	5241 )
	    surahAndAyahNumber="066012"
	    ;;
	5242 )
	    surahAndAyahNumber="067001"
	    ;;
	5243 )
	    surahAndAyahNumber="067002"
	    ;;
	5244 )
	    surahAndAyahNumber="067003"
	    ;;
	5245 )
	    surahAndAyahNumber="067004"
	    ;;
	5246 )
	    surahAndAyahNumber="067005"
	    ;;
	5247 )
	    surahAndAyahNumber="067006"
	    ;;
	5248 )
	    surahAndAyahNumber="067007"
	    ;;
	5249 )
	    surahAndAyahNumber="067008"
	    ;;
	5250 )
	    surahAndAyahNumber="067009"
	    ;;
	5251 )
	    surahAndAyahNumber="067010"
	    ;;
	5252 )
	    surahAndAyahNumber="067011"
	    ;;
	5253 )
	    surahAndAyahNumber="067012"
	    ;;
	5254 )
	    surahAndAyahNumber="067013"
	    ;;
	5255 )
	    surahAndAyahNumber="067014"
	    ;;
	5256 )
	    surahAndAyahNumber="067015"
	    ;;
	5257 )
	    surahAndAyahNumber="067016"
	    ;;
	5258 )
	    surahAndAyahNumber="067017"
	    ;;
	5259 )
	    surahAndAyahNumber="067018"
	    ;;
	5260 )
	    surahAndAyahNumber="067019"
	    ;;
	5261 )
	    surahAndAyahNumber="067020"
	    ;;
	5262 )
	    surahAndAyahNumber="067021"
	    ;;
	5263 )
	    surahAndAyahNumber="067022"
	    ;;
	5264 )
	    surahAndAyahNumber="067023"
	    ;;
	5265 )
	    surahAndAyahNumber="067024"
	    ;;
	5266 )
	    surahAndAyahNumber="067025"
	    ;;
	5267 )
	    surahAndAyahNumber="067026"
	    ;;
	5268 )
	    surahAndAyahNumber="067027"
	    ;;
	5269 )
	    surahAndAyahNumber="067028"
	    ;;
	5270 )
	    surahAndAyahNumber="067029"
	    ;;
	5271 )
	    surahAndAyahNumber="067030"
	    ;;
	5272 )
	    surahAndAyahNumber="068001"
	    ;;
	5273 )
	    surahAndAyahNumber="068002"
	    ;;
	5274 )
	    surahAndAyahNumber="068003"
	    ;;
	5275 )
	    surahAndAyahNumber="068004"
	    ;;
	5276 )
	    surahAndAyahNumber="068005"
	    ;;
	5277 )
	    surahAndAyahNumber="068006"
	    ;;
	5278 )
	    surahAndAyahNumber="068007"
	    ;;
	5279 )
	    surahAndAyahNumber="068008"
	    ;;
	5280 )
	    surahAndAyahNumber="068009"
	    ;;
	5281 )
	    surahAndAyahNumber="068010"
	    ;;
	5282 )
	    surahAndAyahNumber="068011"
	    ;;
	5283 )
	    surahAndAyahNumber="068012"
	    ;;
	5284 )
	    surahAndAyahNumber="068013"
	    ;;
	5285 )
	    surahAndAyahNumber="068014"
	    ;;
	5286 )
	    surahAndAyahNumber="068015"
	    ;;
	5287 )
	    surahAndAyahNumber="068016"
	    ;;
	5288 )
	    surahAndAyahNumber="068017"
	    ;;
	5289 )
	    surahAndAyahNumber="068018"
	    ;;
	5290 )
	    surahAndAyahNumber="068019"
	    ;;
	5291 )
	    surahAndAyahNumber="068020"
	    ;;
	5292 )
	    surahAndAyahNumber="068021"
	    ;;
	5293 )
	    surahAndAyahNumber="068022"
	    ;;
	5294 )
	    surahAndAyahNumber="068023"
	    ;;
	5295 )
	    surahAndAyahNumber="068024"
	    ;;
	5296 )
	    surahAndAyahNumber="068025"
	    ;;
	5297 )
	    surahAndAyahNumber="068026"
	    ;;
	5298 )
	    surahAndAyahNumber="068027"
	    ;;
	5299 )
	    surahAndAyahNumber="068028"
	    ;;
	5300 )
	    surahAndAyahNumber="068029"
	    ;;
	5301 )
	    surahAndAyahNumber="068030"
	    ;;
	5302 )
	    surahAndAyahNumber="068031"
	    ;;
	5303 )
	    surahAndAyahNumber="068032"
	    ;;
	5304 )
	    surahAndAyahNumber="068033"
	    ;;
	5305 )
	    surahAndAyahNumber="068034"
	    ;;
	5306 )
	    surahAndAyahNumber="068035"
	    ;;
	5307 )
	    surahAndAyahNumber="068036"
	    ;;
	5308 )
	    surahAndAyahNumber="068037"
	    ;;
	5309 )
	    surahAndAyahNumber="068038"
	    ;;
	5310 )
	    surahAndAyahNumber="068039"
	    ;;
	5311 )
	    surahAndAyahNumber="068040"
	    ;;
	5312 )
	    surahAndAyahNumber="068041"
	    ;;
	5313 )
	    surahAndAyahNumber="068042"
	    ;;
	5314 )
	    surahAndAyahNumber="068043"
	    ;;
	5315 )
	    surahAndAyahNumber="068044"
	    ;;
	5316 )
	    surahAndAyahNumber="068045"
	    ;;
	5317 )
	    surahAndAyahNumber="068046"
	    ;;
	5318 )
	    surahAndAyahNumber="068047"
	    ;;
	5319 )
	    surahAndAyahNumber="068048"
	    ;;
	5320 )
	    surahAndAyahNumber="068049"
	    ;;
	5321 )
	    surahAndAyahNumber="068050"
	    ;;
	5322 )
	    surahAndAyahNumber="068051"
	    ;;
	5323 )
	    surahAndAyahNumber="068052"
	    ;;
	5324 )
	    surahAndAyahNumber="069001"
	    ;;
	5325 )
	    surahAndAyahNumber="069002"
	    ;;
	5326 )
	    surahAndAyahNumber="069003"
	    ;;
	5327 )
	    surahAndAyahNumber="069004"
	    ;;
	5328 )
	    surahAndAyahNumber="069005"
	    ;;
	5329 )
	    surahAndAyahNumber="069006"
	    ;;
	5330 )
	    surahAndAyahNumber="069007"
	    ;;
	5331 )
	    surahAndAyahNumber="069008"
	    ;;
	5332 )
	    surahAndAyahNumber="069009"
	    ;;
	5333 )
	    surahAndAyahNumber="069010"
	    ;;
	5334 )
	    surahAndAyahNumber="069011"
	    ;;
	5335 )
	    surahAndAyahNumber="069012"
	    ;;
	5336 )
	    surahAndAyahNumber="069013"
	    ;;
	5337 )
	    surahAndAyahNumber="069014"
	    ;;
	5338 )
	    surahAndAyahNumber="069015"
	    ;;
	5339 )
	    surahAndAyahNumber="069016"
	    ;;
	5340 )
	    surahAndAyahNumber="069017"
	    ;;
	5341 )
	    surahAndAyahNumber="069018"
	    ;;
	5342 )
	    surahAndAyahNumber="069019"
	    ;;
	5343 )
	    surahAndAyahNumber="069020"
	    ;;
	5344 )
	    surahAndAyahNumber="069021"
	    ;;
	5345 )
	    surahAndAyahNumber="069022"
	    ;;
	5346 )
	    surahAndAyahNumber="069023"
	    ;;
	5347 )
	    surahAndAyahNumber="069024"
	    ;;
	5348 )
	    surahAndAyahNumber="069025"
	    ;;
	5349 )
	    surahAndAyahNumber="069026"
	    ;;
	5350 )
	    surahAndAyahNumber="069027"
	    ;;
	5351 )
	    surahAndAyahNumber="069028"
	    ;;
	5352 )
	    surahAndAyahNumber="069029"
	    ;;
	5353 )
	    surahAndAyahNumber="069030"
	    ;;
	5354 )
	    surahAndAyahNumber="069031"
	    ;;
	5355 )
	    surahAndAyahNumber="069032"
	    ;;
	5356 )
	    surahAndAyahNumber="069033"
	    ;;
	5357 )
	    surahAndAyahNumber="069034"
	    ;;
	5358 )
	    surahAndAyahNumber="069035"
	    ;;
	5359 )
	    surahAndAyahNumber="069036"
	    ;;
	5360 )
	    surahAndAyahNumber="069037"
	    ;;
	5361 )
	    surahAndAyahNumber="069038"
	    ;;
	5362 )
	    surahAndAyahNumber="069039"
	    ;;
	5363 )
	    surahAndAyahNumber="069040"
	    ;;
	5364 )
	    surahAndAyahNumber="069041"
	    ;;
	5365 )
	    surahAndAyahNumber="069042"
	    ;;
	5366 )
	    surahAndAyahNumber="069043"
	    ;;
	5367 )
	    surahAndAyahNumber="069044"
	    ;;
	5368 )
	    surahAndAyahNumber="069045"
	    ;;
	5369 )
	    surahAndAyahNumber="069046"
	    ;;
	5370 )
	    surahAndAyahNumber="069047"
	    ;;
	5371 )
	    surahAndAyahNumber="069048"
	    ;;
	5372 )
	    surahAndAyahNumber="069049"
	    ;;
	5373 )
	    surahAndAyahNumber="069050"
	    ;;
	5374 )
	    surahAndAyahNumber="069051"
	    ;;
	5375 )
	    surahAndAyahNumber="069052"
	    ;;
	5376 )
	    surahAndAyahNumber="070001"
	    ;;
	5377 )
	    surahAndAyahNumber="070002"
	    ;;
	5378 )
	    surahAndAyahNumber="070003"
	    ;;
	5379 )
	    surahAndAyahNumber="070004"
	    ;;
	5380 )
	    surahAndAyahNumber="070005"
	    ;;
	5381 )
	    surahAndAyahNumber="070006"
	    ;;
	5382 )
	    surahAndAyahNumber="070007"
	    ;;
	5383 )
	    surahAndAyahNumber="070008"
	    ;;
	5384 )
	    surahAndAyahNumber="070009"
	    ;;
	5385 )
	    surahAndAyahNumber="070010"
	    ;;
	5386 )
	    surahAndAyahNumber="070011"
	    ;;
	5387 )
	    surahAndAyahNumber="070012"
	    ;;
	5388 )
	    surahAndAyahNumber="070013"
	    ;;
	5389 )
	    surahAndAyahNumber="070014"
	    ;;
	5390 )
	    surahAndAyahNumber="070015"
	    ;;
	5391 )
	    surahAndAyahNumber="070016"
	    ;;
	5392 )
	    surahAndAyahNumber="070017"
	    ;;
	5393 )
	    surahAndAyahNumber="070018"
	    ;;
	5394 )
	    surahAndAyahNumber="070019"
	    ;;
	5395 )
	    surahAndAyahNumber="070020"
	    ;;
	5396 )
	    surahAndAyahNumber="070021"
	    ;;
	5397 )
	    surahAndAyahNumber="070022"
	    ;;
	5398 )
	    surahAndAyahNumber="070023"
	    ;;
	5399 )
	    surahAndAyahNumber="070024"
	    ;;
	5400 )
	    surahAndAyahNumber="070025"
	    ;;
	5401 )
	    surahAndAyahNumber="070026"
	    ;;
	5402 )
	    surahAndAyahNumber="070027"
	    ;;
	5403 )
	    surahAndAyahNumber="070028"
	    ;;
	5404 )
	    surahAndAyahNumber="070029"
	    ;;
	5405 )
	    surahAndAyahNumber="070030"
	    ;;
	5406 )
	    surahAndAyahNumber="070031"
	    ;;
	5407 )
	    surahAndAyahNumber="070032"
	    ;;
	5408 )
	    surahAndAyahNumber="070033"
	    ;;
	5409 )
	    surahAndAyahNumber="070034"
	    ;;
	5410 )
	    surahAndAyahNumber="070035"
	    ;;
	5411 )
	    surahAndAyahNumber="070036"
	    ;;
	5412 )
	    surahAndAyahNumber="070037"
	    ;;
	5413 )
	    surahAndAyahNumber="070038"
	    ;;
	5414 )
	    surahAndAyahNumber="070039"
	    ;;
	5415 )
	    surahAndAyahNumber="070040"
	    ;;
	5416 )
	    surahAndAyahNumber="070041"
	    ;;
	5417 )
	    surahAndAyahNumber="070042"
	    ;;
	5418 )
	    surahAndAyahNumber="070043"
	    ;;
	5419 )
	    surahAndAyahNumber="070044"
	    ;;
	5420 )
	    surahAndAyahNumber="071001"
	    ;;
	5421 )
	    surahAndAyahNumber="071002"
	    ;;
	5422 )
	    surahAndAyahNumber="071003"
	    ;;
	5423 )
	    surahAndAyahNumber="071004"
	    ;;
	5424 )
	    surahAndAyahNumber="071005"
	    ;;
	5425 )
	    surahAndAyahNumber="071006"
	    ;;
	5426 )
	    surahAndAyahNumber="071007"
	    ;;
	5427 )
	    surahAndAyahNumber="071008"
	    ;;
	5428 )
	    surahAndAyahNumber="071009"
	    ;;
	5429 )
	    surahAndAyahNumber="071010"
	    ;;
	5430 )
	    surahAndAyahNumber="071011"
	    ;;
	5431 )
	    surahAndAyahNumber="071012"
	    ;;
	5432 )
	    surahAndAyahNumber="071013"
	    ;;
	5433 )
	    surahAndAyahNumber="071014"
	    ;;
	5434 )
	    surahAndAyahNumber="071015"
	    ;;
	5435 )
	    surahAndAyahNumber="071016"
	    ;;
	5436 )
	    surahAndAyahNumber="071017"
	    ;;
	5437 )
	    surahAndAyahNumber="071018"
	    ;;
	5438 )
	    surahAndAyahNumber="071019"
	    ;;
	5439 )
	    surahAndAyahNumber="071020"
	    ;;
	5440 )
	    surahAndAyahNumber="071021"
	    ;;
	5441 )
	    surahAndAyahNumber="071022"
	    ;;
	5442 )
	    surahAndAyahNumber="071023"
	    ;;
	5443 )
	    surahAndAyahNumber="071024"
	    ;;
	5444 )
	    surahAndAyahNumber="071025"
	    ;;
	5445 )
	    surahAndAyahNumber="071026"
	    ;;
	5446 )
	    surahAndAyahNumber="071027"
	    ;;
	5447 )
	    surahAndAyahNumber="071028"
	    ;;
	5448 )
	    surahAndAyahNumber="072001"
	    ;;
	5449 )
	    surahAndAyahNumber="072002"
	    ;;
	5450 )
	    surahAndAyahNumber="072003"
	    ;;
	5451 )
	    surahAndAyahNumber="072004"
	    ;;
	5452 )
	    surahAndAyahNumber="072005"
	    ;;
	5453 )
	    surahAndAyahNumber="072006"
	    ;;
	5454 )
	    surahAndAyahNumber="072007"
	    ;;
	5455 )
	    surahAndAyahNumber="072008"
	    ;;
	5456 )
	    surahAndAyahNumber="072009"
	    ;;
	5457 )
	    surahAndAyahNumber="072010"
	    ;;
	5458 )
	    surahAndAyahNumber="072011"
	    ;;
	5459 )
	    surahAndAyahNumber="072012"
	    ;;
	5460 )
	    surahAndAyahNumber="072013"
	    ;;
	5461 )
	    surahAndAyahNumber="072014"
	    ;;
	5462 )
	    surahAndAyahNumber="072015"
	    ;;
	5463 )
	    surahAndAyahNumber="072016"
	    ;;
	5464 )
	    surahAndAyahNumber="072017"
	    ;;
	5465 )
	    surahAndAyahNumber="072018"
	    ;;
	5466 )
	    surahAndAyahNumber="072019"
	    ;;
	5467 )
	    surahAndAyahNumber="072020"
	    ;;
	5468 )
	    surahAndAyahNumber="072021"
	    ;;
	5469 )
	    surahAndAyahNumber="072022"
	    ;;
	5470 )
	    surahAndAyahNumber="072023"
	    ;;
	5471 )
	    surahAndAyahNumber="072024"
	    ;;
	5472 )
	    surahAndAyahNumber="072025"
	    ;;
	5473 )
	    surahAndAyahNumber="072026"
	    ;;
	5474 )
	    surahAndAyahNumber="072027"
	    ;;
	5475 )
	    surahAndAyahNumber="072028"
	    ;;
	5476 )
	    surahAndAyahNumber="073001"
	    ;;
	5477 )
	    surahAndAyahNumber="073002"
	    ;;
	5478 )
	    surahAndAyahNumber="073003"
	    ;;
	5479 )
	    surahAndAyahNumber="073004"
	    ;;
	5480 )
	    surahAndAyahNumber="073005"
	    ;;
	5481 )
	    surahAndAyahNumber="073006"
	    ;;
	5482 )
	    surahAndAyahNumber="073007"
	    ;;
	5483 )
	    surahAndAyahNumber="073008"
	    ;;
	5484 )
	    surahAndAyahNumber="073009"
	    ;;
	5485 )
	    surahAndAyahNumber="073010"
	    ;;
	5486 )
	    surahAndAyahNumber="073011"
	    ;;
	5487 )
	    surahAndAyahNumber="073012"
	    ;;
	5488 )
	    surahAndAyahNumber="073013"
	    ;;
	5489 )
	    surahAndAyahNumber="073014"
	    ;;
	5490 )
	    surahAndAyahNumber="073015"
	    ;;
	5491 )
	    surahAndAyahNumber="073016"
	    ;;
	5492 )
	    surahAndAyahNumber="073017"
	    ;;
	5493 )
	    surahAndAyahNumber="073018"
	    ;;
	5494 )
	    surahAndAyahNumber="073019"
	    ;;
	5495 )
	    surahAndAyahNumber="073020"
	    ;;
	5496 )
	    surahAndAyahNumber="074001"
	    ;;
	5497 )
	    surahAndAyahNumber="074002"
	    ;;
	5498 )
	    surahAndAyahNumber="074003"
	    ;;
	5499 )
	    surahAndAyahNumber="074004"
	    ;;
	5500 )
	    surahAndAyahNumber="074005"
	    ;;
	5501 )
	    surahAndAyahNumber="074006"
	    ;;
	5502 )
	    surahAndAyahNumber="074007"
	    ;;
	5503 )
	    surahAndAyahNumber="074008"
	    ;;
	5504 )
	    surahAndAyahNumber="074009"
	    ;;
	5505 )
	    surahAndAyahNumber="074010"
	    ;;
	5506 )
	    surahAndAyahNumber="074011"
	    ;;
	5507 )
	    surahAndAyahNumber="074012"
	    ;;
	5508 )
	    surahAndAyahNumber="074013"
	    ;;
	5509 )
	    surahAndAyahNumber="074014"
	    ;;
	5510 )
	    surahAndAyahNumber="074015"
	    ;;
	5511 )
	    surahAndAyahNumber="074016"
	    ;;
	5512 )
	    surahAndAyahNumber="074017"
	    ;;
	5513 )
	    surahAndAyahNumber="074018"
	    ;;
	5514 )
	    surahAndAyahNumber="074019"
	    ;;
	5515 )
	    surahAndAyahNumber="074020"
	    ;;
	5516 )
	    surahAndAyahNumber="074021"
	    ;;
	5517 )
	    surahAndAyahNumber="074022"
	    ;;
	5518 )
	    surahAndAyahNumber="074023"
	    ;;
	5519 )
	    surahAndAyahNumber="074024"
	    ;;
	5520 )
	    surahAndAyahNumber="074025"
	    ;;
	5521 )
	    surahAndAyahNumber="074026"
	    ;;
	5522 )
	    surahAndAyahNumber="074027"
	    ;;
	5523 )
	    surahAndAyahNumber="074028"
	    ;;
	5524 )
	    surahAndAyahNumber="074029"
	    ;;
	5525 )
	    surahAndAyahNumber="074030"
	    ;;
	5526 )
	    surahAndAyahNumber="074031"
	    ;;
	5527 )
	    surahAndAyahNumber="074032"
	    ;;
	5528 )
	    surahAndAyahNumber="074033"
	    ;;
	5529 )
	    surahAndAyahNumber="074034"
	    ;;
	5530 )
	    surahAndAyahNumber="074035"
	    ;;
	5531 )
	    surahAndAyahNumber="074036"
	    ;;
	5532 )
	    surahAndAyahNumber="074037"
	    ;;
	5533 )
	    surahAndAyahNumber="074038"
	    ;;
	5534 )
	    surahAndAyahNumber="074039"
	    ;;
	5535 )
	    surahAndAyahNumber="074040"
	    ;;
	5536 )
	    surahAndAyahNumber="074041"
	    ;;
	5537 )
	    surahAndAyahNumber="074042"
	    ;;
	5538 )
	    surahAndAyahNumber="074043"
	    ;;
	5539 )
	    surahAndAyahNumber="074044"
	    ;;
	5540 )
	    surahAndAyahNumber="074045"
	    ;;
	5541 )
	    surahAndAyahNumber="074046"
	    ;;
	5542 )
	    surahAndAyahNumber="074047"
	    ;;
	5543 )
	    surahAndAyahNumber="074048"
	    ;;
	5544 )
	    surahAndAyahNumber="074049"
	    ;;
	5545 )
	    surahAndAyahNumber="074050"
	    ;;
	5546 )
	    surahAndAyahNumber="074051"
	    ;;
	5547 )
	    surahAndAyahNumber="074052"
	    ;;
	5548 )
	    surahAndAyahNumber="074053"
	    ;;
	5549 )
	    surahAndAyahNumber="074054"
	    ;;
	5550 )
	    surahAndAyahNumber="074055"
	    ;;
	5551 )
	    surahAndAyahNumber="074056"
	    ;;
	5552 )
	    surahAndAyahNumber="075001"
	    ;;
	5553 )
	    surahAndAyahNumber="075002"
	    ;;
	5554 )
	    surahAndAyahNumber="075003"
	    ;;
	5555 )
	    surahAndAyahNumber="075004"
	    ;;
	5556 )
	    surahAndAyahNumber="075005"
	    ;;
	5557 )
	    surahAndAyahNumber="075006"
	    ;;
	5558 )
	    surahAndAyahNumber="075007"
	    ;;
	5559 )
	    surahAndAyahNumber="075008"
	    ;;
	5560 )
	    surahAndAyahNumber="075009"
	    ;;
	5561 )
	    surahAndAyahNumber="075010"
	    ;;
	5562 )
	    surahAndAyahNumber="075011"
	    ;;
	5563 )
	    surahAndAyahNumber="075012"
	    ;;
	5564 )
	    surahAndAyahNumber="075013"
	    ;;
	5565 )
	    surahAndAyahNumber="075014"
	    ;;
	5566 )
	    surahAndAyahNumber="075015"
	    ;;
	5567 )
	    surahAndAyahNumber="075016"
	    ;;
	5568 )
	    surahAndAyahNumber="075017"
	    ;;
	5569 )
	    surahAndAyahNumber="075018"
	    ;;
	5570 )
	    surahAndAyahNumber="075019"
	    ;;
	5571 )
	    surahAndAyahNumber="075020"
	    ;;
	5572 )
	    surahAndAyahNumber="075021"
	    ;;
	5573 )
	    surahAndAyahNumber="075022"
	    ;;
	5574 )
	    surahAndAyahNumber="075023"
	    ;;
	5575 )
	    surahAndAyahNumber="075024"
	    ;;
	5576 )
	    surahAndAyahNumber="075025"
	    ;;
	5577 )
	    surahAndAyahNumber="075026"
	    ;;
	5578 )
	    surahAndAyahNumber="075027"
	    ;;
	5579 )
	    surahAndAyahNumber="075028"
	    ;;
	5580 )
	    surahAndAyahNumber="075029"
	    ;;
	5581 )
	    surahAndAyahNumber="075030"
	    ;;
	5582 )
	    surahAndAyahNumber="075031"
	    ;;
	5583 )
	    surahAndAyahNumber="075032"
	    ;;
	5584 )
	    surahAndAyahNumber="075033"
	    ;;
	5585 )
	    surahAndAyahNumber="075034"
	    ;;
	5586 )
	    surahAndAyahNumber="075035"
	    ;;
	5587 )
	    surahAndAyahNumber="075036"
	    ;;
	5588 )
	    surahAndAyahNumber="075037"
	    ;;
	5589 )
	    surahAndAyahNumber="075038"
	    ;;
	5590 )
	    surahAndAyahNumber="075039"
	    ;;
	5591 )
	    surahAndAyahNumber="075040"
	    ;;
	5592 )
	    surahAndAyahNumber="076001"
	    ;;
	5593 )
	    surahAndAyahNumber="076002"
	    ;;
	5594 )
	    surahAndAyahNumber="076003"
	    ;;
	5595 )
	    surahAndAyahNumber="076004"
	    ;;
	5596 )
	    surahAndAyahNumber="076005"
	    ;;
	5597 )
	    surahAndAyahNumber="076006"
	    ;;
	5598 )
	    surahAndAyahNumber="076007"
	    ;;
	5599 )
	    surahAndAyahNumber="076008"
	    ;;
	5600 )
	    surahAndAyahNumber="076009"
	    ;;
	5601 )
	    surahAndAyahNumber="076010"
	    ;;
	5602 )
	    surahAndAyahNumber="076011"
	    ;;
	5603 )
	    surahAndAyahNumber="076012"
	    ;;
	5604 )
	    surahAndAyahNumber="076013"
	    ;;
	5605 )
	    surahAndAyahNumber="076014"
	    ;;
	5606 )
	    surahAndAyahNumber="076015"
	    ;;
	5607 )
	    surahAndAyahNumber="076016"
	    ;;
	5608 )
	    surahAndAyahNumber="076017"
	    ;;
	5609 )
	    surahAndAyahNumber="076018"
	    ;;
	5610 )
	    surahAndAyahNumber="076019"
	    ;;
	5611 )
	    surahAndAyahNumber="076020"
	    ;;
	5612 )
	    surahAndAyahNumber="076021"
	    ;;
	5613 )
	    surahAndAyahNumber="076022"
	    ;;
	5614 )
	    surahAndAyahNumber="076023"
	    ;;
	5615 )
	    surahAndAyahNumber="076024"
	    ;;
	5616 )
	    surahAndAyahNumber="076025"
	    ;;
	5617 )
	    surahAndAyahNumber="076026"
	    ;;
	5618 )
	    surahAndAyahNumber="076027"
	    ;;
	5619 )
	    surahAndAyahNumber="076028"
	    ;;
	5620 )
	    surahAndAyahNumber="076029"
	    ;;
	5621 )
	    surahAndAyahNumber="076030"
	    ;;
	5622 )
	    surahAndAyahNumber="076031"
	    ;;
	5623 )
	    surahAndAyahNumber="077001"
	    ;;
	5624 )
	    surahAndAyahNumber="077002"
	    ;;
	5625 )
	    surahAndAyahNumber="077003"
	    ;;
	5626 )
	    surahAndAyahNumber="077004"
	    ;;
	5627 )
	    surahAndAyahNumber="077005"
	    ;;
	5628 )
	    surahAndAyahNumber="077006"
	    ;;
	5629 )
	    surahAndAyahNumber="077007"
	    ;;
	5630 )
	    surahAndAyahNumber="077008"
	    ;;
	5631 )
	    surahAndAyahNumber="077009"
	    ;;
	5632 )
	    surahAndAyahNumber="077010"
	    ;;
	5633 )
	    surahAndAyahNumber="077011"
	    ;;
	5634 )
	    surahAndAyahNumber="077012"
	    ;;
	5635 )
	    surahAndAyahNumber="077013"
	    ;;
	5636 )
	    surahAndAyahNumber="077014"
	    ;;
	5637 )
	    surahAndAyahNumber="077015"
	    ;;
	5638 )
	    surahAndAyahNumber="077016"
	    ;;
	5639 )
	    surahAndAyahNumber="077017"
	    ;;
	5640 )
	    surahAndAyahNumber="077018"
	    ;;
	5641 )
	    surahAndAyahNumber="077019"
	    ;;
	5642 )
	    surahAndAyahNumber="077020"
	    ;;
	5643 )
	    surahAndAyahNumber="077021"
	    ;;
	5644 )
	    surahAndAyahNumber="077022"
	    ;;
	5645 )
	    surahAndAyahNumber="077023"
	    ;;
	5646 )
	    surahAndAyahNumber="077024"
	    ;;
	5647 )
	    surahAndAyahNumber="077025"
	    ;;
	5648 )
	    surahAndAyahNumber="077026"
	    ;;
	5649 )
	    surahAndAyahNumber="077027"
	    ;;
	5650 )
	    surahAndAyahNumber="077028"
	    ;;
	5651 )
	    surahAndAyahNumber="077029"
	    ;;
	5652 )
	    surahAndAyahNumber="077030"
	    ;;
	5653 )
	    surahAndAyahNumber="077031"
	    ;;
	5654 )
	    surahAndAyahNumber="077032"
	    ;;
	5655 )
	    surahAndAyahNumber="077033"
	    ;;
	5656 )
	    surahAndAyahNumber="077034"
	    ;;
	5657 )
	    surahAndAyahNumber="077035"
	    ;;
	5658 )
	    surahAndAyahNumber="077036"
	    ;;
	5659 )
	    surahAndAyahNumber="077037"
	    ;;
	5660 )
	    surahAndAyahNumber="077038"
	    ;;
	5661 )
	    surahAndAyahNumber="077039"
	    ;;
	5662 )
	    surahAndAyahNumber="077040"
	    ;;
	5663 )
	    surahAndAyahNumber="077041"
	    ;;
	5664 )
	    surahAndAyahNumber="077042"
	    ;;
	5665 )
	    surahAndAyahNumber="077043"
	    ;;
	5666 )
	    surahAndAyahNumber="077044"
	    ;;
	5667 )
	    surahAndAyahNumber="077045"
	    ;;
	5668 )
	    surahAndAyahNumber="077046"
	    ;;
	5669 )
	    surahAndAyahNumber="077047"
	    ;;
	5670 )
	    surahAndAyahNumber="077048"
	    ;;
	5671 )
	    surahAndAyahNumber="077049"
	    ;;
	5672 )
	    surahAndAyahNumber="077050"
	    ;;
	5673 )
	    surahAndAyahNumber="078001"
	    ;;
	5674 )
	    surahAndAyahNumber="078002"
	    ;;
	5675 )
	    surahAndAyahNumber="078003"
	    ;;
	5676 )
	    surahAndAyahNumber="078004"
	    ;;
	5677 )
	    surahAndAyahNumber="078005"
	    ;;
	5678 )
	    surahAndAyahNumber="078006"
	    ;;
	5679 )
	    surahAndAyahNumber="078007"
	    ;;
	5680 )
	    surahAndAyahNumber="078008"
	    ;;
	5681 )
	    surahAndAyahNumber="078009"
	    ;;
	5682 )
	    surahAndAyahNumber="078010"
	    ;;
	5683 )
	    surahAndAyahNumber="078011"
	    ;;
	5684 )
	    surahAndAyahNumber="078012"
	    ;;
	5685 )
	    surahAndAyahNumber="078013"
	    ;;
	5686 )
	    surahAndAyahNumber="078014"
	    ;;
	5687 )
	    surahAndAyahNumber="078015"
	    ;;
	5688 )
	    surahAndAyahNumber="078016"
	    ;;
	5689 )
	    surahAndAyahNumber="078017"
	    ;;
	5690 )
	    surahAndAyahNumber="078018"
	    ;;
	5691 )
	    surahAndAyahNumber="078019"
	    ;;
	5692 )
	    surahAndAyahNumber="078020"
	    ;;
	5693 )
	    surahAndAyahNumber="078021"
	    ;;
	5694 )
	    surahAndAyahNumber="078022"
	    ;;
	5695 )
	    surahAndAyahNumber="078023"
	    ;;
	5696 )
	    surahAndAyahNumber="078024"
	    ;;
	5697 )
	    surahAndAyahNumber="078025"
	    ;;
	5698 )
	    surahAndAyahNumber="078026"
	    ;;
	5699 )
	    surahAndAyahNumber="078027"
	    ;;
	5700 )
	    surahAndAyahNumber="078028"
	    ;;
	5701 )
	    surahAndAyahNumber="078029"
	    ;;
	5702 )
	    surahAndAyahNumber="078030"
	    ;;
	5703 )
	    surahAndAyahNumber="078031"
	    ;;
	5704 )
	    surahAndAyahNumber="078032"
	    ;;
	5705 )
	    surahAndAyahNumber="078033"
	    ;;
	5706 )
	    surahAndAyahNumber="078034"
	    ;;
	5707 )
	    surahAndAyahNumber="078035"
	    ;;
	5708 )
	    surahAndAyahNumber="078036"
	    ;;
	5709 )
	    surahAndAyahNumber="078037"
	    ;;
	5710 )
	    surahAndAyahNumber="078038"
	    ;;
	5711 )
	    surahAndAyahNumber="078039"
	    ;;
	5712 )
	    surahAndAyahNumber="078040"
	    ;;
	5713 )
	    surahAndAyahNumber="079001"
	    ;;
	5714 )
	    surahAndAyahNumber="079002"
	    ;;
	5715 )
	    surahAndAyahNumber="079003"
	    ;;
	5716 )
	    surahAndAyahNumber="079004"
	    ;;
	5717 )
	    surahAndAyahNumber="079005"
	    ;;
	5718 )
	    surahAndAyahNumber="079006"
	    ;;
	5719 )
	    surahAndAyahNumber="079007"
	    ;;
	5720 )
	    surahAndAyahNumber="079008"
	    ;;
	5721 )
	    surahAndAyahNumber="079009"
	    ;;
	5722 )
	    surahAndAyahNumber="079010"
	    ;;
	5723 )
	    surahAndAyahNumber="079011"
	    ;;
	5724 )
	    surahAndAyahNumber="079012"
	    ;;
	5725 )
	    surahAndAyahNumber="079013"
	    ;;
	5726 )
	    surahAndAyahNumber="079014"
	    ;;
	5727 )
	    surahAndAyahNumber="079015"
	    ;;
	5728 )
	    surahAndAyahNumber="079016"
	    ;;
	5729 )
	    surahAndAyahNumber="079017"
	    ;;
	5730 )
	    surahAndAyahNumber="079018"
	    ;;
	5731 )
	    surahAndAyahNumber="079019"
	    ;;
	5732 )
	    surahAndAyahNumber="079020"
	    ;;
	5733 )
	    surahAndAyahNumber="079021"
	    ;;
	5734 )
	    surahAndAyahNumber="079022"
	    ;;
	5735 )
	    surahAndAyahNumber="079023"
	    ;;
	5736 )
	    surahAndAyahNumber="079024"
	    ;;
	5737 )
	    surahAndAyahNumber="079025"
	    ;;
	5738 )
	    surahAndAyahNumber="079026"
	    ;;
	5739 )
	    surahAndAyahNumber="079027"
	    ;;
	5740 )
	    surahAndAyahNumber="079028"
	    ;;
	5741 )
	    surahAndAyahNumber="079029"
	    ;;
	5742 )
	    surahAndAyahNumber="079030"
	    ;;
	5743 )
	    surahAndAyahNumber="079031"
	    ;;
	5744 )
	    surahAndAyahNumber="079032"
	    ;;
	5745 )
	    surahAndAyahNumber="079033"
	    ;;
	5746 )
	    surahAndAyahNumber="079034"
	    ;;
	5747 )
	    surahAndAyahNumber="079035"
	    ;;
	5748 )
	    surahAndAyahNumber="079036"
	    ;;
	5749 )
	    surahAndAyahNumber="079037"
	    ;;
	5750 )
	    surahAndAyahNumber="079038"
	    ;;
	5751 )
	    surahAndAyahNumber="079039"
	    ;;
	5752 )
	    surahAndAyahNumber="079040"
	    ;;
	5753 )
	    surahAndAyahNumber="079041"
	    ;;
	5754 )
	    surahAndAyahNumber="079042"
	    ;;
	5755 )
	    surahAndAyahNumber="079043"
	    ;;
	5756 )
	    surahAndAyahNumber="079044"
	    ;;
	5757 )
	    surahAndAyahNumber="079045"
	    ;;
	5758 )
	    surahAndAyahNumber="079046"
	    ;;
	5759 )
	    surahAndAyahNumber="080001"
	    ;;
	5760 )
	    surahAndAyahNumber="080002"
	    ;;
	5761 )
	    surahAndAyahNumber="080003"
	    ;;
	5762 )
	    surahAndAyahNumber="080004"
	    ;;
	5763 )
	    surahAndAyahNumber="080005"
	    ;;
	5764 )
	    surahAndAyahNumber="080006"
	    ;;
	5765 )
	    surahAndAyahNumber="080007"
	    ;;
	5766 )
	    surahAndAyahNumber="080008"
	    ;;
	5767 )
	    surahAndAyahNumber="080009"
	    ;;
	5768 )
	    surahAndAyahNumber="080010"
	    ;;
	5769 )
	    surahAndAyahNumber="080011"
	    ;;
	5770 )
	    surahAndAyahNumber="080012"
	    ;;
	5771 )
	    surahAndAyahNumber="080013"
	    ;;
	5772 )
	    surahAndAyahNumber="080014"
	    ;;
	5773 )
	    surahAndAyahNumber="080015"
	    ;;
	5774 )
	    surahAndAyahNumber="080016"
	    ;;
	5775 )
	    surahAndAyahNumber="080017"
	    ;;
	5776 )
	    surahAndAyahNumber="080018"
	    ;;
	5777 )
	    surahAndAyahNumber="080019"
	    ;;
	5778 )
	    surahAndAyahNumber="080020"
	    ;;
	5779 )
	    surahAndAyahNumber="080021"
	    ;;
	5780 )
	    surahAndAyahNumber="080022"
	    ;;
	5781 )
	    surahAndAyahNumber="080023"
	    ;;
	5782 )
	    surahAndAyahNumber="080024"
	    ;;
	5783 )
	    surahAndAyahNumber="080025"
	    ;;
	5784 )
	    surahAndAyahNumber="080026"
	    ;;
	5785 )
	    surahAndAyahNumber="080027"
	    ;;
	5786 )
	    surahAndAyahNumber="080028"
	    ;;
	5787 )
	    surahAndAyahNumber="080029"
	    ;;
	5788 )
	    surahAndAyahNumber="080030"
	    ;;
	5789 )
	    surahAndAyahNumber="080031"
	    ;;
	5790 )
	    surahAndAyahNumber="080032"
	    ;;
	5791 )
	    surahAndAyahNumber="080033"
	    ;;
	5792 )
	    surahAndAyahNumber="080034"
	    ;;
	5793 )
	    surahAndAyahNumber="080035"
	    ;;
	5794 )
	    surahAndAyahNumber="080036"
	    ;;
	5795 )
	    surahAndAyahNumber="080037"
	    ;;
	5796 )
	    surahAndAyahNumber="080038"
	    ;;
	5797 )
	    surahAndAyahNumber="080039"
	    ;;
	5798 )
	    surahAndAyahNumber="080040"
	    ;;
	5799 )
	    surahAndAyahNumber="080041"
	    ;;
	5800 )
	    surahAndAyahNumber="080042"
	    ;;
	5801 )
	    surahAndAyahNumber="081001"
	    ;;
	5802 )
	    surahAndAyahNumber="081002"
	    ;;
	5803 )
	    surahAndAyahNumber="081003"
	    ;;
	5804 )
	    surahAndAyahNumber="081004"
	    ;;
	5805 )
	    surahAndAyahNumber="081005"
	    ;;
	5806 )
	    surahAndAyahNumber="081006"
	    ;;
	5807 )
	    surahAndAyahNumber="081007"
	    ;;
	5808 )
	    surahAndAyahNumber="081008"
	    ;;
	5809 )
	    surahAndAyahNumber="081009"
	    ;;
	5810 )
	    surahAndAyahNumber="081010"
	    ;;
	5811 )
	    surahAndAyahNumber="081011"
	    ;;
	5812 )
	    surahAndAyahNumber="081012"
	    ;;
	5813 )
	    surahAndAyahNumber="081013"
	    ;;
	5814 )
	    surahAndAyahNumber="081014"
	    ;;
	5815 )
	    surahAndAyahNumber="081015"
	    ;;
	5816 )
	    surahAndAyahNumber="081016"
	    ;;
	5817 )
	    surahAndAyahNumber="081017"
	    ;;
	5818 )
	    surahAndAyahNumber="081018"
	    ;;
	5819 )
	    surahAndAyahNumber="081019"
	    ;;
	5820 )
	    surahAndAyahNumber="081020"
	    ;;
	5821 )
	    surahAndAyahNumber="081021"
	    ;;
	5822 )
	    surahAndAyahNumber="081022"
	    ;;
	5823 )
	    surahAndAyahNumber="081023"
	    ;;
	5824 )
	    surahAndAyahNumber="081024"
	    ;;
	5825 )
	    surahAndAyahNumber="081025"
	    ;;
	5826 )
	    surahAndAyahNumber="081026"
	    ;;
	5827 )
	    surahAndAyahNumber="081027"
	    ;;
	5828 )
	    surahAndAyahNumber="081028"
	    ;;
	5829 )
	    surahAndAyahNumber="081029"
	    ;;
	5830 )
	    surahAndAyahNumber="082001"
	    ;;
	5831 )
	    surahAndAyahNumber="082002"
	    ;;
	5832 )
	    surahAndAyahNumber="082003"
	    ;;
	5833 )
	    surahAndAyahNumber="082004"
	    ;;
	5834 )
	    surahAndAyahNumber="082005"
	    ;;
	5835 )
	    surahAndAyahNumber="082006"
	    ;;
	5836 )
	    surahAndAyahNumber="082007"
	    ;;
	5837 )
	    surahAndAyahNumber="082008"
	    ;;
	5838 )
	    surahAndAyahNumber="082009"
	    ;;
	5839 )
	    surahAndAyahNumber="082010"
	    ;;
	5840 )
	    surahAndAyahNumber="082011"
	    ;;
	5841 )
	    surahAndAyahNumber="082012"
	    ;;
	5842 )
	    surahAndAyahNumber="082013"
	    ;;
	5843 )
	    surahAndAyahNumber="082014"
	    ;;
	5844 )
	    surahAndAyahNumber="082015"
	    ;;
	5845 )
	    surahAndAyahNumber="082016"
	    ;;
	5846 )
	    surahAndAyahNumber="082017"
	    ;;
	5847 )
	    surahAndAyahNumber="082018"
	    ;;
	5848 )
	    surahAndAyahNumber="082019"
	    ;;
	5849 )
	    surahAndAyahNumber="083001"
	    ;;
	5850 )
	    surahAndAyahNumber="083002"
	    ;;
	5851 )
	    surahAndAyahNumber="083003"
	    ;;
	5852 )
	    surahAndAyahNumber="083004"
	    ;;
	5853 )
	    surahAndAyahNumber="083005"
	    ;;
	5854 )
	    surahAndAyahNumber="083006"
	    ;;
	5855 )
	    surahAndAyahNumber="083007"
	    ;;
	5856 )
	    surahAndAyahNumber="083008"
	    ;;
	5857 )
	    surahAndAyahNumber="083009"
	    ;;
	5858 )
	    surahAndAyahNumber="083010"
	    ;;
	5859 )
	    surahAndAyahNumber="083011"
	    ;;
	5860 )
	    surahAndAyahNumber="083012"
	    ;;
	5861 )
	    surahAndAyahNumber="083013"
	    ;;
	5862 )
	    surahAndAyahNumber="083014"
	    ;;
	5863 )
	    surahAndAyahNumber="083015"
	    ;;
	5864 )
	    surahAndAyahNumber="083016"
	    ;;
	5865 )
	    surahAndAyahNumber="083017"
	    ;;
	5866 )
	    surahAndAyahNumber="083018"
	    ;;
	5867 )
	    surahAndAyahNumber="083019"
	    ;;
	5868 )
	    surahAndAyahNumber="083020"
	    ;;
	5869 )
	    surahAndAyahNumber="083021"
	    ;;
	5870 )
	    surahAndAyahNumber="083022"
	    ;;
	5871 )
	    surahAndAyahNumber="083023"
	    ;;
	5872 )
	    surahAndAyahNumber="083024"
	    ;;
	5873 )
	    surahAndAyahNumber="083025"
	    ;;
	5874 )
	    surahAndAyahNumber="083026"
	    ;;
	5875 )
	    surahAndAyahNumber="083027"
	    ;;
	5876 )
	    surahAndAyahNumber="083028"
	    ;;
	5877 )
	    surahAndAyahNumber="083029"
	    ;;
	5878 )
	    surahAndAyahNumber="083030"
	    ;;
	5879 )
	    surahAndAyahNumber="083031"
	    ;;
	5880 )
	    surahAndAyahNumber="083032"
	    ;;
	5881 )
	    surahAndAyahNumber="083033"
	    ;;
	5882 )
	    surahAndAyahNumber="083034"
	    ;;
	5883 )
	    surahAndAyahNumber="083035"
	    ;;
	5884 )
	    surahAndAyahNumber="083036"
	    ;;
	5885 )
	    surahAndAyahNumber="084001"
	    ;;
	5886 )
	    surahAndAyahNumber="084002"
	    ;;
	5887 )
	    surahAndAyahNumber="084003"
	    ;;
	5888 )
	    surahAndAyahNumber="084004"
	    ;;
	5889 )
	    surahAndAyahNumber="084005"
	    ;;
	5890 )
	    surahAndAyahNumber="084006"
	    ;;
	5891 )
	    surahAndAyahNumber="084007"
	    ;;
	5892 )
	    surahAndAyahNumber="084008"
	    ;;
	5893 )
	    surahAndAyahNumber="084009"
	    ;;
	5894 )
	    surahAndAyahNumber="084010"
	    ;;
	5895 )
	    surahAndAyahNumber="084011"
	    ;;
	5896 )
	    surahAndAyahNumber="084012"
	    ;;
	5897 )
	    surahAndAyahNumber="084013"
	    ;;
	5898 )
	    surahAndAyahNumber="084014"
	    ;;
	5899 )
	    surahAndAyahNumber="084015"
	    ;;
	5900 )
	    surahAndAyahNumber="084016"
	    ;;
	5901 )
	    surahAndAyahNumber="084017"
	    ;;
	5902 )
	    surahAndAyahNumber="084018"
	    ;;
	5903 )
	    surahAndAyahNumber="084019"
	    ;;
	5904 )
	    surahAndAyahNumber="084020"
	    ;;
	5905 )
	    surahAndAyahNumber="084021"
	    ;;
	5906 )
	    surahAndAyahNumber="084022"
	    ;;
	5907 )
	    surahAndAyahNumber="084023"
	    ;;
	5908 )
	    surahAndAyahNumber="084024"
	    ;;
	5909 )
	    surahAndAyahNumber="084025"
	    ;;
	5910 )
	    surahAndAyahNumber="085001"
	    ;;
	5911 )
	    surahAndAyahNumber="085002"
	    ;;
	5912 )
	    surahAndAyahNumber="085003"
	    ;;
	5913 )
	    surahAndAyahNumber="085004"
	    ;;
	5914 )
	    surahAndAyahNumber="085005"
	    ;;
	5915 )
	    surahAndAyahNumber="085006"
	    ;;
	5916 )
	    surahAndAyahNumber="085007"
	    ;;
	5917 )
	    surahAndAyahNumber="085008"
	    ;;
	5918 )
	    surahAndAyahNumber="085009"
	    ;;
	5919 )
	    surahAndAyahNumber="085010"
	    ;;
	5920 )
	    surahAndAyahNumber="085011"
	    ;;
	5921 )
	    surahAndAyahNumber="085012"
	    ;;
	5922 )
	    surahAndAyahNumber="085013"
	    ;;
	5923 )
	    surahAndAyahNumber="085014"
	    ;;
	5924 )
	    surahAndAyahNumber="085015"
	    ;;
	5925 )
	    surahAndAyahNumber="085016"
	    ;;
	5926 )
	    surahAndAyahNumber="085017"
	    ;;
	5927 )
	    surahAndAyahNumber="085018"
	    ;;
	5928 )
	    surahAndAyahNumber="085019"
	    ;;
	5929 )
	    surahAndAyahNumber="085020"
	    ;;
	5930 )
	    surahAndAyahNumber="085021"
	    ;;
	5931 )
	    surahAndAyahNumber="085022"
	    ;;
	5932 )
	    surahAndAyahNumber="086001"
	    ;;
	5933 )
	    surahAndAyahNumber="086002"
	    ;;
	5934 )
	    surahAndAyahNumber="086003"
	    ;;
	5935 )
	    surahAndAyahNumber="086004"
	    ;;
	5936 )
	    surahAndAyahNumber="086005"
	    ;;
	5937 )
	    surahAndAyahNumber="086006"
	    ;;
	5938 )
	    surahAndAyahNumber="086007"
	    ;;
	5939 )
	    surahAndAyahNumber="086008"
	    ;;
	5940 )
	    surahAndAyahNumber="086009"
	    ;;
	5941 )
	    surahAndAyahNumber="086010"
	    ;;
	5942 )
	    surahAndAyahNumber="086011"
	    ;;
	5943 )
	    surahAndAyahNumber="086012"
	    ;;
	5944 )
	    surahAndAyahNumber="086013"
	    ;;
	5945 )
	    surahAndAyahNumber="086014"
	    ;;
	5946 )
	    surahAndAyahNumber="086015"
	    ;;
	5947 )
	    surahAndAyahNumber="086016"
	    ;;
	5948 )
	    surahAndAyahNumber="086017"
	    ;;
	5949 )
	    surahAndAyahNumber="087001"
	    ;;
	5950 )
	    surahAndAyahNumber="087002"
	    ;;
	5951 )
	    surahAndAyahNumber="087003"
	    ;;
	5952 )
	    surahAndAyahNumber="087004"
	    ;;
	5953 )
	    surahAndAyahNumber="087005"
	    ;;
	5954 )
	    surahAndAyahNumber="087006"
	    ;;
	5955 )
	    surahAndAyahNumber="087007"
	    ;;
	5956 )
	    surahAndAyahNumber="087008"
	    ;;
	5957 )
	    surahAndAyahNumber="087009"
	    ;;
	5958 )
	    surahAndAyahNumber="087010"
	    ;;
	5959 )
	    surahAndAyahNumber="087011"
	    ;;
	5960 )
	    surahAndAyahNumber="087012"
	    ;;
	5961 )
	    surahAndAyahNumber="087013"
	    ;;
	5962 )
	    surahAndAyahNumber="087014"
	    ;;
	5963 )
	    surahAndAyahNumber="087015"
	    ;;
	5964 )
	    surahAndAyahNumber="087016"
	    ;;
	5965 )
	    surahAndAyahNumber="087017"
	    ;;
	5966 )
	    surahAndAyahNumber="087018"
	    ;;
	5967 )
	    surahAndAyahNumber="087019"
	    ;;
	5968 )
	    surahAndAyahNumber="088001"
	    ;;
	5969 )
	    surahAndAyahNumber="088002"
	    ;;
	5970 )
	    surahAndAyahNumber="088003"
	    ;;
	5971 )
	    surahAndAyahNumber="088004"
	    ;;
	5972 )
	    surahAndAyahNumber="088005"
	    ;;
	5973 )
	    surahAndAyahNumber="088006"
	    ;;
	5974 )
	    surahAndAyahNumber="088007"
	    ;;
	5975 )
	    surahAndAyahNumber="088008"
	    ;;
	5976 )
	    surahAndAyahNumber="088009"
	    ;;
	5977 )
	    surahAndAyahNumber="088010"
	    ;;
	5978 )
	    surahAndAyahNumber="088011"
	    ;;
	5979 )
	    surahAndAyahNumber="088012"
	    ;;
	5980 )
	    surahAndAyahNumber="088013"
	    ;;
	5981 )
	    surahAndAyahNumber="088014"
	    ;;
	5982 )
	    surahAndAyahNumber="088015"
	    ;;
	5983 )
	    surahAndAyahNumber="088016"
	    ;;
	5984 )
	    surahAndAyahNumber="088017"
	    ;;
	5985 )
	    surahAndAyahNumber="088018"
	    ;;
	5986 )
	    surahAndAyahNumber="088019"
	    ;;
	5987 )
	    surahAndAyahNumber="088020"
	    ;;
	5988 )
	    surahAndAyahNumber="088021"
	    ;;
	5989 )
	    surahAndAyahNumber="088022"
	    ;;
	5990 )
	    surahAndAyahNumber="088023"
	    ;;
	5991 )
	    surahAndAyahNumber="088024"
	    ;;
	5992 )
	    surahAndAyahNumber="088025"
	    ;;
	5993 )
	    surahAndAyahNumber="088026"
	    ;;
	5994 )
	    surahAndAyahNumber="089001"
	    ;;
	5995 )
	    surahAndAyahNumber="089002"
	    ;;
	5996 )
	    surahAndAyahNumber="089003"
	    ;;
	5997 )
	    surahAndAyahNumber="089004"
	    ;;
	5998 )
	    surahAndAyahNumber="089005"
	    ;;
	5999 )
	    surahAndAyahNumber="089006"
	    ;;
	6000 )
	    surahAndAyahNumber="089007"
	    ;;
	6001 )
	    surahAndAyahNumber="089008"
	    ;;
	6002 )
	    surahAndAyahNumber="089009"
	    ;;
	6003 )
	    surahAndAyahNumber="089010"
	    ;;
	6004 )
	    surahAndAyahNumber="089011"
	    ;;
	6005 )
	    surahAndAyahNumber="089012"
	    ;;
	6006 )
	    surahAndAyahNumber="089013"
	    ;;
	6007 )
	    surahAndAyahNumber="089014"
	    ;;
	6008 )
	    surahAndAyahNumber="089015"
	    ;;
	6009 )
	    surahAndAyahNumber="089016"
	    ;;
	6010 )
	    surahAndAyahNumber="089017"
	    ;;
	6011 )
	    surahAndAyahNumber="089018"
	    ;;
	6012 )
	    surahAndAyahNumber="089019"
	    ;;
	6013 )
	    surahAndAyahNumber="089020"
	    ;;
	6014 )
	    surahAndAyahNumber="089021"
	    ;;
	6015 )
	    surahAndAyahNumber="089022"
	    ;;
	6016 )
	    surahAndAyahNumber="089023"
	    ;;
	6017 )
	    surahAndAyahNumber="089024"
	    ;;
	6018 )
	    surahAndAyahNumber="089025"
	    ;;
	6019 )
	    surahAndAyahNumber="089026"
	    ;;
	6020 )
	    surahAndAyahNumber="089027"
	    ;;
	6021 )
	    surahAndAyahNumber="089028"
	    ;;
	6022 )
	    surahAndAyahNumber="089029"
	    ;;
	6023 )
	    surahAndAyahNumber="089030"
	    ;;
	6024 )
	    surahAndAyahNumber="090001"
	    ;;
	6025 )
	    surahAndAyahNumber="090002"
	    ;;
	6026 )
	    surahAndAyahNumber="090003"
	    ;;
	6027 )
	    surahAndAyahNumber="090004"
	    ;;
	6028 )
	    surahAndAyahNumber="090005"
	    ;;
	6029 )
	    surahAndAyahNumber="090006"
	    ;;
	6030 )
	    surahAndAyahNumber="090007"
	    ;;
	6031 )
	    surahAndAyahNumber="090008"
	    ;;
	6032 )
	    surahAndAyahNumber="090009"
	    ;;
	6033 )
	    surahAndAyahNumber="090010"
	    ;;
	6034 )
	    surahAndAyahNumber="090011"
	    ;;
	6035 )
	    surahAndAyahNumber="090012"
	    ;;
	6036 )
	    surahAndAyahNumber="090013"
	    ;;
	6037 )
	    surahAndAyahNumber="090014"
	    ;;
	6038 )
	    surahAndAyahNumber="090015"
	    ;;
	6039 )
	    surahAndAyahNumber="090016"
	    ;;
	6040 )
	    surahAndAyahNumber="090017"
	    ;;
	6041 )
	    surahAndAyahNumber="090018"
	    ;;
	6042 )
	    surahAndAyahNumber="090019"
	    ;;
	6043 )
	    surahAndAyahNumber="090020"
	    ;;
	6044 )
	    surahAndAyahNumber="091001"
	    ;;
	6045 )
	    surahAndAyahNumber="091002"
	    ;;
	6046 )
	    surahAndAyahNumber="091003"
	    ;;
	6047 )
	    surahAndAyahNumber="091004"
	    ;;
	6048 )
	    surahAndAyahNumber="091005"
	    ;;
	6049 )
	    surahAndAyahNumber="091006"
	    ;;
	6050 )
	    surahAndAyahNumber="091007"
	    ;;
	6051 )
	    surahAndAyahNumber="091008"
	    ;;
	6052 )
	    surahAndAyahNumber="091009"
	    ;;
	6053 )
	    surahAndAyahNumber="091010"
	    ;;
	6054 )
	    surahAndAyahNumber="091011"
	    ;;
	6055 )
	    surahAndAyahNumber="091012"
	    ;;
	6056 )
	    surahAndAyahNumber="091013"
	    ;;
	6057 )
	    surahAndAyahNumber="091014"
	    ;;
	6058 )
	    surahAndAyahNumber="091015"
	    ;;
	6059 )
	    surahAndAyahNumber="092001"
	    ;;
	6060 )
	    surahAndAyahNumber="092002"
	    ;;
	6061 )
	    surahAndAyahNumber="092003"
	    ;;
	6062 )
	    surahAndAyahNumber="092004"
	    ;;
	6063 )
	    surahAndAyahNumber="092005"
	    ;;
	6064 )
	    surahAndAyahNumber="092006"
	    ;;
	6065 )
	    surahAndAyahNumber="092007"
	    ;;
	6066 )
	    surahAndAyahNumber="092008"
	    ;;
	6067 )
	    surahAndAyahNumber="092009"
	    ;;
	6068 )
	    surahAndAyahNumber="092010"
	    ;;
	6069 )
	    surahAndAyahNumber="092011"
	    ;;
	6070 )
	    surahAndAyahNumber="092012"
	    ;;
	6071 )
	    surahAndAyahNumber="092013"
	    ;;
	6072 )
	    surahAndAyahNumber="092014"
	    ;;
	6073 )
	    surahAndAyahNumber="092015"
	    ;;
	6074 )
	    surahAndAyahNumber="092016"
	    ;;
	6075 )
	    surahAndAyahNumber="092017"
	    ;;
	6076 )
	    surahAndAyahNumber="092018"
	    ;;
	6077 )
	    surahAndAyahNumber="092019"
	    ;;
	6078 )
	    surahAndAyahNumber="092020"
	    ;;
	6079 )
	    surahAndAyahNumber="092021"
	    ;;
	6080 )
	    surahAndAyahNumber="093001"
	    ;;
	6081 )
	    surahAndAyahNumber="093002"
	    ;;
	6082 )
	    surahAndAyahNumber="093003"
	    ;;
	6083 )
	    surahAndAyahNumber="093004"
	    ;;
	6084 )
	    surahAndAyahNumber="093005"
	    ;;
	6085 )
	    surahAndAyahNumber="093006"
	    ;;
	6086 )
	    surahAndAyahNumber="093007"
	    ;;
	6087 )
	    surahAndAyahNumber="093008"
	    ;;
	6088 )
	    surahAndAyahNumber="093009"
	    ;;
	6089 )
	    surahAndAyahNumber="093010"
	    ;;
	6090 )
	    surahAndAyahNumber="093011"
	    ;;
	6091 )
	    surahAndAyahNumber="094001"
	    ;;
	6092 )
	    surahAndAyahNumber="094002"
	    ;;
	6093 )
	    surahAndAyahNumber="094003"
	    ;;
	6094 )
	    surahAndAyahNumber="094004"
	    ;;
	6095 )
	    surahAndAyahNumber="094005"
	    ;;
	6096 )
	    surahAndAyahNumber="094006"
	    ;;
	6097 )
	    surahAndAyahNumber="094007"
	    ;;
	6098 )
	    surahAndAyahNumber="094008"
	    ;;
	6099 )
	    surahAndAyahNumber="095001"
	    ;;
	6100 )
	    surahAndAyahNumber="095002"
	    ;;
	6101 )
	    surahAndAyahNumber="095003"
	    ;;
	6102 )
	    surahAndAyahNumber="095004"
	    ;;
	6103 )
	    surahAndAyahNumber="095005"
	    ;;
	6104 )
	    surahAndAyahNumber="095006"
	    ;;
	6105 )
	    surahAndAyahNumber="095007"
	    ;;
	6106 )
	    surahAndAyahNumber="095008"
	    ;;
	6107 )
	    surahAndAyahNumber="096001"
	    ;;
	6108 )
	    surahAndAyahNumber="096002"
	    ;;
	6109 )
	    surahAndAyahNumber="096003"
	    ;;
	6110 )
	    surahAndAyahNumber="096004"
	    ;;
	6111 )
	    surahAndAyahNumber="096005"
	    ;;
	6112 )
	    surahAndAyahNumber="096006"
	    ;;
	6113 )
	    surahAndAyahNumber="096007"
	    ;;
	6114 )
	    surahAndAyahNumber="096008"
	    ;;
	6115 )
	    surahAndAyahNumber="096009"
	    ;;
	6116 )
	    surahAndAyahNumber="096010"
	    ;;
	6117 )
	    surahAndAyahNumber="096011"
	    ;;
	6118 )
	    surahAndAyahNumber="096012"
	    ;;
	6119 )
	    surahAndAyahNumber="096013"
	    ;;
	6120 )
	    surahAndAyahNumber="096014"
	    ;;
	6121 )
	    surahAndAyahNumber="096015"
	    ;;
	6122 )
	    surahAndAyahNumber="096016"
	    ;;
	6123 )
	    surahAndAyahNumber="096017"
	    ;;
	6124 )
	    surahAndAyahNumber="096018"
	    ;;
	6125 )
	    surahAndAyahNumber="096019"
	    ;;
	6126 )
	    surahAndAyahNumber="097001"
	    ;;
	6127 )
	    surahAndAyahNumber="097002"
	    ;;
	6128 )
	    surahAndAyahNumber="097003"
	    ;;
	6129 )
	    surahAndAyahNumber="097004"
	    ;;
	6130 )
	    surahAndAyahNumber="097005"
	    ;;
	6131 )
	    surahAndAyahNumber="098001"
	    ;;
	6132 )
	    surahAndAyahNumber="098002"
	    ;;
	6133 )
	    surahAndAyahNumber="098003"
	    ;;
	6134 )
	    surahAndAyahNumber="098004"
	    ;;
	6135 )
	    surahAndAyahNumber="098005"
	    ;;
	6136 )
	    surahAndAyahNumber="098006"
	    ;;
	6137 )
	    surahAndAyahNumber="098007"
	    ;;
	6138 )
	    surahAndAyahNumber="098008"
	    ;;
	6139 )
	    surahAndAyahNumber="099001"
	    ;;
	6140 )
	    surahAndAyahNumber="099002"
	    ;;
	6141 )
	    surahAndAyahNumber="099003"
	    ;;
	6142 )
	    surahAndAyahNumber="099004"
	    ;;
	6143 )
	    surahAndAyahNumber="099005"
	    ;;
	6144 )
	    surahAndAyahNumber="099006"
	    ;;
	6145 )
	    surahAndAyahNumber="099007"
	    ;;
	6146 )
	    surahAndAyahNumber="099008"
	    ;;
	6147 )
	    surahAndAyahNumber="100001"
	    ;;
	6148 )
	    surahAndAyahNumber="100002"
	    ;;
	6149 )
	    surahAndAyahNumber="100003"
	    ;;
	6150 )
	    surahAndAyahNumber="100004"
	    ;;
	6151 )
	    surahAndAyahNumber="100005"
	    ;;
	6152 )
	    surahAndAyahNumber="100006"
	    ;;
	6153 )
	    surahAndAyahNumber="100007"
	    ;;
	6154 )
	    surahAndAyahNumber="100008"
	    ;;
	6155 )
	    surahAndAyahNumber="100009"
	    ;;
	6156 )
	    surahAndAyahNumber="100010"
	    ;;
	6157 )
	    surahAndAyahNumber="100011"
	    ;;
	6158 )
	    surahAndAyahNumber="101001"
	    ;;
	6159 )
	    surahAndAyahNumber="101002"
	    ;;
	6160 )
	    surahAndAyahNumber="101003"
	    ;;
	6161 )
	    surahAndAyahNumber="101004"
	    ;;
	6162 )
	    surahAndAyahNumber="101005"
	    ;;
	6163 )
	    surahAndAyahNumber="101006"
	    ;;
	6164 )
	    surahAndAyahNumber="101007"
	    ;;
	6165 )
	    surahAndAyahNumber="101008"
	    ;;
	6166 )
	    surahAndAyahNumber="101009"
	    ;;
	6167 )
	    surahAndAyahNumber="101010"
	    ;;
	6168 )
	    surahAndAyahNumber="101011"
	    ;;
	6169 )
	    surahAndAyahNumber="102001"
	    ;;
	6170 )
	    surahAndAyahNumber="102002"
	    ;;
	6171 )
	    surahAndAyahNumber="102003"
	    ;;
	6172 )
	    surahAndAyahNumber="102004"
	    ;;
	6173 )
	    surahAndAyahNumber="102005"
	    ;;
	6174 )
	    surahAndAyahNumber="102006"
	    ;;
	6175 )
	    surahAndAyahNumber="102007"
	    ;;
	6176 )
	    surahAndAyahNumber="102008"
	    ;;
	6177 )
	    surahAndAyahNumber="103001"
	    ;;
	6178 )
	    surahAndAyahNumber="103002"
	    ;;
	6179 )
	    surahAndAyahNumber="103003"
	    ;;
	6180 )
	    surahAndAyahNumber="104001"
	    ;;
	6181 )
	    surahAndAyahNumber="104002"
	    ;;
	6182 )
	    surahAndAyahNumber="104003"
	    ;;
	6183 )
	    surahAndAyahNumber="104004"
	    ;;
	6184 )
	    surahAndAyahNumber="104005"
	    ;;
	6185 )
	    surahAndAyahNumber="104006"
	    ;;
	6186 )
	    surahAndAyahNumber="104007"
	    ;;
	6187 )
	    surahAndAyahNumber="104008"
	    ;;
	6188 )
	    surahAndAyahNumber="104009"
	    ;;
	6189 )
	    surahAndAyahNumber="105001"
	    ;;
	6190 )
	    surahAndAyahNumber="105002"
	    ;;
	6191 )
	    surahAndAyahNumber="105003"
	    ;;
	6192 )
	    surahAndAyahNumber="105004"
	    ;;
	6193 )
	    surahAndAyahNumber="105005"
	    ;;
	6194 )
	    surahAndAyahNumber="106001"
	    ;;
	6195 )
	    surahAndAyahNumber="106002"
	    ;;
	6196 )
	    surahAndAyahNumber="106003"
	    ;;
	6197 )
	    surahAndAyahNumber="106004"
	    ;;
	6198 )
	    surahAndAyahNumber="107001"
	    ;;
	6199 )
	    surahAndAyahNumber="107002"
	    ;;
	6200 )
	    surahAndAyahNumber="107003"
	    ;;
	6201 )
	    surahAndAyahNumber="107004"
	    ;;
	6202 )
	    surahAndAyahNumber="107005"
	    ;;
	6203 )
	    surahAndAyahNumber="107006"
	    ;;
	6204 )
	    surahAndAyahNumber="107007"
	    ;;
	6205 )
	    surahAndAyahNumber="108001"
	    ;;
	6206 )
	    surahAndAyahNumber="108002"
	    ;;
	6207 )
	    surahAndAyahNumber="108003"
	    ;;
	6208 )
	    surahAndAyahNumber="109001"
	    ;;
	6209 )
	    surahAndAyahNumber="109002"
	    ;;
	6210 )
	    surahAndAyahNumber="109003"
	    ;;
	6211 )
	    surahAndAyahNumber="109004"
	    ;;
	6212 )
	    surahAndAyahNumber="109005"
	    ;;
	6213 )
	    surahAndAyahNumber="109006"
	    ;;
	6214 )
	    surahAndAyahNumber="110001"
	    ;;
	6215 )
	    surahAndAyahNumber="110002"
	    ;;
	6216 )
	    surahAndAyahNumber="110003"
	    ;;
	6217 )
	    surahAndAyahNumber="111001"
	    ;;
	6218 )
	    surahAndAyahNumber="111002"
	    ;;
	6219 )
	    surahAndAyahNumber="111003"
	    ;;
	6220 )
	    surahAndAyahNumber="111004"
	    ;;
	6221 )
	    surahAndAyahNumber="111005"
	    ;;
	6222 )
	    surahAndAyahNumber="112001"
	    ;;
	6223 )
	    surahAndAyahNumber="112002"
	    ;;
	6224 )
	    surahAndAyahNumber="112003"
	    ;;
	6225 )
	    surahAndAyahNumber="112004"
	    ;;
	6226 )
	    surahAndAyahNumber="113001"
	    ;;
	6227 )
	    surahAndAyahNumber="113002"
	    ;;
	6228 )
	    surahAndAyahNumber="113003"
	    ;;
	6229 )
	    surahAndAyahNumber="113004"
	    ;;
	6230 )
	    surahAndAyahNumber="113005"
	    ;;
	6231 )
	    surahAndAyahNumber="114001"
	    ;;
	6232 )
	    surahAndAyahNumber="114002"
	    ;;
	6233 )
	    surahAndAyahNumber="114003"
	    ;;
	6234 )
	    surahAndAyahNumber="114004"
	    ;;
	6235 )
	    surahAndAyahNumber="114005"
	    ;;
	6236 )
	    surahAndAyahNumber="114006"
	    ;;
	* )
	    flag="755"
	    reset
	    echo
	    echo "The Sūrah/Ayah Number you entered in:"
	    echo
	    echo "$surahAndAyahNumber"
	    echo
	    echo "is invalid! Please provide a number"
	    echo "between 1 and 6236 without leading"
	    echo "zeros. i.e., 7 instead of 0007, or"
	    echo "850 instead of 0850."
	    echo
	    exit
    esac
}



####################
# This function gives the
# list of ayat of a given
# surah in an array format
give_surah_ayats_list(){
    local surahNumber="$1"
    case $surahNumber in
	
	1 )
            ayaat_list_of_given_surah=( "001001" "001002" "001003" "001004" "001005" "001006" "001007" )
            ;;
	2 )
            ayaat_list_of_given_surah=( "002001" "002002" "002003" "002004" "002005" "002006" "002007" "002008" "002009" "002010" "002011" "002012" "002013" "002014" "002015" "002016" "002017" "002018" "002019" "002020" "002021" "002022" "002023" "002024" "002025" "002026" "002027" "002028" "002029" "002030" "002031" "002032" "002033" "002034" "002035" "002036" "002037" "002038" "002039" "002040" "002041" "002042" "002043" "002044" "002045" "002046" "002047" "002048" "002049" "002050" "002051" "002052" "002053" "002054" "002055" "002056" "002057" "002058" "002059" "002060" "002061" "002062" "002063" "002064" "002065" "002066" "002067" "002068" "002069" "002070" "002071" "002072" "002073" "002074" "002075" "002076" "002077" "002078" "002079" "002080" "002081" "002082" "002083" "002084" "002085" "002086" "002087" "002088" "002089" "002090" "002091" "002092" "002093" "002094" "002095" "002096" "002097" "002098" "002099" "002100" "002101" "002102" "002103" "002104" "002105" "002106" "002107" "002108" "002109" "002110" "002111" "002112" "002113" "002114" "002115" "002116" "002117" "002118" "002119" "002120" "002121" "002122" "002123" "002124" "002125" "002126" "002127" "002128" "002129" "002130" "002131" "002132" "002133" "002134" "002135" "002136" "002137" "002138" "002139" "002140" "002141" "002142" "002143" "002144" "002145" "002146" "002147" "002148" "002149" "002150" "002151" "002152" "002153" "002154" "002155" "002156" "002157" "002158" "002159" "002160" "002161" "002162" "002163" "002164" "002165" "002166" "002167" "002168" "002169" "002170" "002171" "002172" "002173" "002174" "002175" "002176" "002177" "002178" "002179" "002180" "002181" "002182" "002183" "002184" "002185" "002186" "002187" "002188" "002189" "002190" "002191" "002192" "002193" "002194" "002195" "002196" "002197" "002198" "002199" "002200" "002201" "002202" "002203" "002204" "002205" "002206" "002207" "002208" "002209" "002210" "002211" "002212" "002213" "002214" "002215" "002216" "002217" "002218" "002219" "002220" "002221" "002222" "002223" "002224" "002225" "002226" "002227" "002228" "002229" "002230" "002231" "002232" "002233" "002234" "002235" "002236" "002237" "002238" "002239" "002240" "002241" "002242" "002243" "002244" "002245" "002246" "002247" "002248" "002249" "002250" "002251" "002252" "002253" "002254" "002255" "002256" "002257" "002258" "002259" "002260" "002261" "002262" "002263" "002264" "002265" "002266" "002267" "002268" "002269" "002270" "002271" "002272" "002273" "002274" "002275" "002276" "002277" "002278" "002279" "002280" "002281" "002282" "002283" "002284" "002285" "002286" )
	    ;;
	3 )
            ayaat_list_of_given_surah=( "003001" "003002" "003003" "003004" "003005" "003006" "003007" "003008" "003009" "003010" "003011" "003012" "003013" "003014" "003015" "003016" "003017" "003018" "003019" "003020" "003021" "003022" "003023" "003024" "003025" "003026" "003027" "003028" "003029" "003030" "003031" "003032" "003033" "003034" "003035" "003036" "003037" "003038" "003039" "003040" "003041" "003042" "003043" "003044" "003045" "003046" "003047" "003048" "003049" "003050" "003051" "003052" "003053" "003054" "003055" "003056" "003057" "003058" "003059" "003060" "003061" "003062" "003063" "003064" "003065" "003066" "003067" "003068" "003069" "003070" "003071" "003072" "003073" "003074" "003075" "003076" "003077" "003078" "003079" "003080" "003081" "003082" "003083" "003084" "003085" "003086" "003087" "003088" "003089" "003090" "003091" "003092" "003093" "003094" "003095" "003096" "003097" "003098" "003099" "003100" "003101" "003102" "003103" "003104" "003105" "003106" "003107" "003108" "003109" "003110" "003111" "003112" "003113" "003114" "003115" "003116" "003117" "003118" "003119" "003120" "003121" "003122" "003123" "003124" "003125" "003126" "003127" "003128" "003129" "003130" "003131" "003132" "003133" "003134" "003135" "003136" "003137" "003138" "003139" "003140" "003141" "003142" "003143" "003144" "003145" "003146" "003147" "003148" "003149" "003150" "003151" "003152" "003153" "003154" "003155" "003156" "003157" "003158" "003159" "003160" "003161" "003162" "003163" "003164" "003165" "003166" "003167" "003168" "003169" "003170" "003171" "003172" "003173" "003174" "003175" "003176" "003177" "003178" "003179" "003180" "003181" "003182" "003183" "003184" "003185" "003186" "003187" "003188" "003189" "003190" "003191" "003192" "003193" "003194" "003195" "003196" "003197" "003198" "003199" "003200" )
	    ;;
	4 )
            ayaat_list_of_given_surah=( "004001" "004002" "004003" "004004" "004005" "004006" "004007" "004008" "004009" "004010" "004011" "004012" "004013" "004014" "004015" "004016" "004017" "004018" "004019" "004020" "004021" "004022" "004023" "004024" "004025" "004026" "004027" "004028" "004029" "004030" "004031" "004032" "004033" "004034" "004035" "004036" "004037" "004038" "004039" "004040" "004041" "004042" "004043" "004044" "004045" "004046" "004047" "004048" "004049" "004050" "004051" "004052" "004053" "004054" "004055" "004056" "004057" "004058" "004059" "004060" "004061" "004062" "004063" "004064" "004065" "004066" "004067" "004068" "004069" "004070" "004071" "004072" "004073" "004074" "004075" "004076" "004077" "004078" "004079" "004080" "004081" "004082" "004083" "004084" "004085" "004086" "004087" "004088" "004089" "004090" "004091" "004092" "004093" "004094" "004095" "004096" "004097" "004098" "004099" "004100" "004101" "004102" "004103" "004104" "004105" "004106" "004107" "004108" "004109" "004110" "004111" "004112" "004113" "004114" "004115" "004116" "004117" "004118" "004119" "004120" "004121" "004122" "004123" "004124" "004125" "004126" "004127" "004128" "004129" "004130" "004131" "004132" "004133" "004134" "004135" "004136" "004137" "004138" "004139" "004140" "004141" "004142" "004143" "004144" "004145" "004146" "004147" "004148" "004149" "004150" "004151" "004152" "004153" "004154" "004155" "004156" "004157" "004158" "004159" "004160" "004161" "004162" "004163" "004164" "004165" "004166" "004167" "004168" "004169" "004170" "004171" "004172" "004173" "004174" "004175" "004176" )
	    ;;
	5 )
            ayaat_list_of_given_surah=( "005001" "005002" "005003" "005004" "005005" "005006" "005007" "005008" "005009" "005010" "005011" "005012" "005013" "005014" "005015" "005016" "005017" "005018" "005019" "005020" "005021" "005022" "005023" "005024" "005025" "005026" "005027" "005028" "005029" "005030" "005031" "005032" "005033" "005034" "005035" "005036" "005037" "005038" "005039" "005040" "005041" "005042" "005043" "005044" "005045" "005046" "005047" "005048" "005049" "005050" "005051" "005052" "005053" "005054" "005055" "005056" "005057" "005058" "005059" "005060" "005061" "005062" "005063" "005064" "005065" "005066" "005067" "005068" "005069" "005070" "005071" "005072" "005073" "005074" "005075" "005076" "005077" "005078" "005079" "005080" "005081" "005082" "005083" "005084" "005085" "005086" "005087" "005088" "005089" "005090" "005091" "005092" "005093" "005094" "005095" "005096" "005097" "005098" "005099" "005100" "005101" "005102" "005103" "005104" "005105" "005106" "005107" "005108" "005109" "005110" "005111" "005112" "005113" "005114" "005115" "005116" "005117" "005118" "005119" "005120" )
	    ;;
	6 )
            ayaat_list_of_given_surah=( "006001" "006002" "006003" "006004" "006005" "006006" "006007" "006008" "006009" "006010" "006011" "006012" "006013" "006014" "006015" "006016" "006017" "006018" "006019" "006020" "006021" "006022" "006023" "006024" "006025" "006026" "006027" "006028" "006029" "006030" "006031" "006032" "006033" "006034" "006035" "006036" "006037" "006038" "006039" "006040" "006041" "006042" "006043" "006044" "006045" "006046" "006047" "006048" "006049" "006050" "006051" "006052" "006053" "006054" "006055" "006056" "006057" "006058" "006059" "006060" "006061" "006062" "006063" "006064" "006065" "006066" "006067" "006068" "006069" "006070" "006071" "006072" "006073" "006074" "006075" "006076" "006077" "006078" "006079" "006080" "006081" "006082" "006083" "006084" "006085" "006086" "006087" "006088" "006089" "006090" "006091" "006092" "006093" "006094" "006095" "006096" "006097" "006098" "006099" "006100" "006101" "006102" "006103" "006104" "006105" "006106" "006107" "006108" "006109" "006110" "006111" "006112" "006113" "006114" "006115" "006116" "006117" "006118" "006119" "006120" "006121" "006122" "006123" "006124" "006125" "006126" "006127" "006128" "006129" "006130" "006131" "006132" "006133" "006134" "006135" "006136" "006137" "006138" "006139" "006140" "006141" "006142" "006143" "006144" "006145" "006146" "006147" "006148" "006149" "006150" "006151" "006152" "006153" "006154" "006155" "006156" "006157" "006158" "006159" "006160" "006161" "006162" "006163" "006164" "006165" )
	    ;;
	7 )
            ayaat_list_of_given_surah=( "007001" "007002" "007003" "007004" "007005" "007006" "007007" "007008" "007009" "007010" "007011" "007012" "007013" "007014" "007015" "007016" "007017" "007018" "007019" "007020" "007021" "007022" "007023" "007024" "007025" "007026" "007027" "007028" "007029" "007030" "007031" "007032" "007033" "007034" "007035" "007036" "007037" "007038" "007039" "007040" "007041" "007042" "007043" "007044" "007045" "007046" "007047" "007048" "007049" "007050" "007051" "007052" "007053" "007054" "007055" "007056" "007057" "007058" "007059" "007060" "007061" "007062" "007063" "007064" "007065" "007066" "007067" "007068" "007069" "007070" "007071" "007072" "007073" "007074" "007075" "007076" "007077" "007078" "007079" "007080" "007081" "007082" "007083" "007084" "007085" "007086" "007087" "007088" "007089" "007090" "007091" "007092" "007093" "007094" "007095" "007096" "007097" "007098" "007099" "007100" "007101" "007102" "007103" "007104" "007105" "007106" "007107" "007108" "007109" "007110" "007111" "007112" "007113" "007114" "007115" "007116" "007117" "007118" "007119" "007120" "007121" "007122" "007123" "007124" "007125" "007126" "007127" "007128" "007129" "007130" "007131" "007132" "007133" "007134" "007135" "007136" "007137" "007138" "007139" "007140" "007141" "007142" "007143" "007144" "007145" "007146" "007147" "007148" "007149" "007150" "007151" "007152" "007153" "007154" "007155" "007156" "007157" "007158" "007159" "007160" "007161" "007162" "007163" "007164" "007165" "007166" "007167" "007168" "007169" "007170" "007171" "007172" "007173" "007174" "007175" "007176" "007177" "007178" "007179" "007180" "007181" "007182" "007183" "007184" "007185" "007186" "007187" "007188" "007189" "007190" "007191" "007192" "007193" "007194" "007195" "007196" "007197" "007198" "007199" "007200" "007201" "007202" "007203" "007204" "007205" "007206" )
	    ;;
	8 )
            ayaat_list_of_given_surah=( "008001" "008002" "008003" "008004" "008005" "008006" "008007" "008008" "008009" "008010" "008011" "008012" "008013" "008014" "008015" "008016" "008017" "008018" "008019" "008020" "008021" "008022" "008023" "008024" "008025" "008026" "008027" "008028" "008029" "008030" "008031" "008032" "008033" "008034" "008035" "008036" "008037" "008038" "008039" "008040" "008041" "008042" "008043" "008044" "008045" "008046" "008047" "008048" "008049" "008050" "008051" "008052" "008053" "008054" "008055" "008056" "008057" "008058" "008059" "008060" "008061" "008062" "008063" "008064" "008065" "008066" "008067" "008068" "008069" "008070" "008071" "008072" "008073" "008074" "008075" )
	    ;;
	9 )
            ayaat_list_of_given_surah=( "009001" "009002" "009003" "009004" "009005" "009006" "009007" "009008" "009009" "009010" "009011" "009012" "009013" "009014" "009015" "009016" "009017" "009018" "009019" "009020" "009021" "009022" "009023" "009024" "009025" "009026" "009027" "009028" "009029" "009030" "009031" "009032" "009033" "009034" "009035" "009036" "009037" "009038" "009039" "009040" "009041" "009042" "009043" "009044" "009045" "009046" "009047" "009048" "009049" "009050" "009051" "009052" "009053" "009054" "009055" "009056" "009057" "009058" "009059" "009060" "009061" "009062" "009063" "009064" "009065" "009066" "009067" "009068" "009069" "009070" "009071" "009072" "009073" "009074" "009075" "009076" "009077" "009078" "009079" "009080" "009081" "009082" "009083" "009084" "009085" "009086" "009087" "009088" "009089" "009090" "009091" "009092" "009093" "009094" "009095" "009096" "009097" "009098" "009099" "009100" "009101" "009102" "009103" "009104" "009105" "009106" "009107" "009108" "009109" "009110" "009111" "009112" "009113" "009114" "009115" "009116" "009117" "009118" "009119" "009120" "009121" "009122" "009123" "009124" "009125" "009126" "009127" "009128" "009129" )
	    ;;
	10 )
            ayaat_list_of_given_surah=( "010001" "010002" "010003" "010004" "010005" "010006" "010007" "010008" "010009" "010010" "010011" "010012" "010013" "010014" "010015" "010016" "010017" "010018" "010019" "010020" "010021" "010022" "010023" "010024" "010025" "010026" "010027" "010028" "010029" "010030" "010031" "010032" "010033" "010034" "010035" "010036" "010037" "010038" "010039" "010040" "010041" "010042" "010043" "010044" "010045" "010046" "010047" "010048" "010049" "010050" "010051" "010052" "010053" "010054" "010055" "010056" "010057" "010058" "010059" "010060" "010061" "010062" "010063" "010064" "010065" "010066" "010067" "010068" "010069" "010070" "010071" "010072" "010073" "010074" "010075" "010076" "010077" "010078" "010079" "010080" "010081" "010082" "010083" "010084" "010085" "010086" "010087" "010088" "010089" "010090" "010091" "010092" "010093" "010094" "010095" "010096" "010097" "010098" "010099" "010100" "010101" "010102" "010103" "010104" "010105" "010106" "010107" "010108" "010109" )
	    ;;
	11 )
            ayaat_list_of_given_surah=( "011001" "011002" "011003" "011004" "011005" "011006" "011007" "011008" "011009" "011010" "011011" "011012" "011013" "011014" "011015" "011016" "011017" "011018" "011019" "011020" "011021" "011022" "011023" "011024" "011025" "011026" "011027" "011028" "011029" "011030" "011031" "011032" "011033" "011034" "011035" "011036" "011037" "011038" "011039" "011040" "011041" "011042" "011043" "011044" "011045" "011046" "011047" "011048" "011049" "011050" "011051" "011052" "011053" "011054" "011055" "011056" "011057" "011058" "011059" "011060" "011061" "011062" "011063" "011064" "011065" "011066" "011067" "011068" "011069" "011070" "011071" "011072" "011073" "011074" "011075" "011076" "011077" "011078" "011079" "011080" "011081" "011082" "011083" "011084" "011085" "011086" "011087" "011088" "011089" "011090" "011091" "011092" "011093" "011094" "011095" "011096" "011097" "011098" "011099" "011100" "011101" "011102" "011103" "011104" "011105" "011106" "011107" "011108" "011109" "011110" "011111" "011112" "011113" "011114" "011115" "011116" "011117" "011118" "011119" "011120" "011121" "011122" "011123" )
	    ;;
	12 )
            ayaat_list_of_given_surah=( "012001" "012002" "012003" "012004" "012005" "012006" "012007" "012008" "012009" "012010" "012011" "012012" "012013" "012014" "012015" "012016" "012017" "012018" "012019" "012020" "012021" "012022" "012023" "012024" "012025" "012026" "012027" "012028" "012029" "012030" "012031" "012032" "012033" "012034" "012035" "012036" "012037" "012038" "012039" "012040" "012041" "012042" "012043" "012044" "012045" "012046" "012047" "012048" "012049" "012050" "012051" "012052" "012053" "012054" "012055" "012056" "012057" "012058" "012059" "012060" "012061" "012062" "012063" "012064" "012065" "012066" "012067" "012068" "012069" "012070" "012071" "012072" "012073" "012074" "012075" "012076" "012077" "012078" "012079" "012080" "012081" "012082" "012083" "012084" "012085" "012086" "012087" "012088" "012089" "012090" "012091" "012092" "012093" "012094" "012095" "012096" "012097" "012098" "012099" "012100" "012101" "012102" "012103" "012104" "012105" "012106" "012107" "012108" "012109" "012110" "012111" )
	    ;;
	13 )
            ayaat_list_of_given_surah=( "013001" "013002" "013003" "013004" "013005" "013006" "013007" "013008" "013009" "013010" "013011" "013012" "013013" "013014" "013015" "013016" "013017" "013018" "013019" "013020" "013021" "013022" "013023" "013024" "013025" "013026" "013027" "013028" "013029" "013030" "013031" "013032" "013033" "013034" "013035" "013036" "013037" "013038" "013039" "013040" "013041" "013042" "013043" )
	    ;;
	14 )
            ayaat_list_of_given_surah=( "014001" "014002" "014003" "014004" "014005" "014006" "014007" "014008" "014009" "014010" "014011" "014012" "014013" "014014" "014015" "014016" "014017" "014018" "014019" "014020" "014021" "014022" "014023" "014024" "014025" "014026" "014027" "014028" "014029" "014030" "014031" "014032" "014033" "014034" "014035" "014036" "014037" "014038" "014039" "014040" "014041" "014042" "014043" "014044" "014045" "014046" "014047" "014048" "014049" "014050" "014051" "014052" )
	    ;;
	15 )
            ayaat_list_of_given_surah=( "015001" "015002" "015003" "015004" "015005" "015006" "015007" "015008" "015009" "015010" "015011" "015012" "015013" "015014" "015015" "015016" "015017" "015018" "015019" "015020" "015021" "015022" "015023" "015024" "015025" "015026" "015027" "015028" "015029" "015030" "015031" "015032" "015033" "015034" "015035" "015036" "015037" "015038" "015039" "015040" "015041" "015042" "015043" "015044" "015045" "015046" "015047" "015048" "015049" "015050" "015051" "015052" "015053" "015054" "015055" "015056" "015057" "015058" "015059" "015060" "015061" "015062" "015063" "015064" "015065" "015066" "015067" "015068" "015069" "015070" "015071" "015072" "015073" "015074" "015075" "015076" "015077" "015078" "015079" "015080" "015081" "015082" "015083" "015084" "015085" "015086" "015087" "015088" "015089" "015090" "015091" "015092" "015093" "015094" "015095" "015096" "015097" "015098" "015099" )
	    ;;
	16 )
            ayaat_list_of_given_surah=( "016001" "016002" "016003" "016004" "016005" "016006" "016007" "016008" "016009" "016010" "016011" "016012" "016013" "016014" "016015" "016016" "016017" "016018" "016019" "016020" "016021" "016022" "016023" "016024" "016025" "016026" "016027" "016028" "016029" "016030" "016031" "016032" "016033" "016034" "016035" "016036" "016037" "016038" "016039" "016040" "016041" "016042" "016043" "016044" "016045" "016046" "016047" "016048" "016049" "016050" "016051" "016052" "016053" "016054" "016055" "016056" "016057" "016058" "016059" "016060" "016061" "016062" "016063" "016064" "016065" "016066" "016067" "016068" "016069" "016070" "016071" "016072" "016073" "016074" "016075" "016076" "016077" "016078" "016079" "016080" "016081" "016082" "016083" "016084" "016085" "016086" "016087" "016088" "016089" "016090" "016091" "016092" "016093" "016094" "016095" "016096" "016097" "016098" "016099" "016100" "016101" "016102" "016103" "016104" "016105" "016106" "016107" "016108" "016109" "016110" "016111" "016112" "016113" "016114" "016115" "016116" "016117" "016118" "016119" "016120" "016121" "016122" "016123" "016124" "016125" "016126" "016127" "016128" )
	    ;;
	17 )
            ayaat_list_of_given_surah=( "017001" "017002" "017003" "017004" "017005" "017006" "017007" "017008" "017009" "017010" "017011" "017012" "017013" "017014" "017015" "017016" "017017" "017018" "017019" "017020" "017021" "017022" "017023" "017024" "017025" "017026" "017027" "017028" "017029" "017030" "017031" "017032" "017033" "017034" "017035" "017036" "017037" "017038" "017039" "017040" "017041" "017042" "017043" "017044" "017045" "017046" "017047" "017048" "017049" "017050" "017051" "017052" "017053" "017054" "017055" "017056" "017057" "017058" "017059" "017060" "017061" "017062" "017063" "017064" "017065" "017066" "017067" "017068" "017069" "017070" "017071" "017072" "017073" "017074" "017075" "017076" "017077" "017078" "017079" "017080" "017081" "017082" "017083" "017084" "017085" "017086" "017087" "017088" "017089" "017090" "017091" "017092" "017093" "017094" "017095" "017096" "017097" "017098" "017099" "017100" "017101" "017102" "017103" "017104" "017105" "017106" "017107" "017108" "017109" "017110" "017111" )
	    ;;
	18 )
            ayaat_list_of_given_surah=( "018001" "018002" "018003" "018004" "018005" "018006" "018007" "018008" "018009" "018010" "018011" "018012" "018013" "018014" "018015" "018016" "018017" "018018" "018019" "018020" "018021" "018022" "018023" "018024" "018025" "018026" "018027" "018028" "018029" "018030" "018031" "018032" "018033" "018034" "018035" "018036" "018037" "018038" "018039" "018040" "018041" "018042" "018043" "018044" "018045" "018046" "018047" "018048" "018049" "018050" "018051" "018052" "018053" "018054" "018055" "018056" "018057" "018058" "018059" "018060" "018061" "018062" "018063" "018064" "018065" "018066" "018067" "018068" "018069" "018070" "018071" "018072" "018073" "018074" "018075" "018076" "018077" "018078" "018079" "018080" "018081" "018082" "018083" "018084" "018085" "018086" "018087" "018088" "018089" "018090" "018091" "018092" "018093" "018094" "018095" "018096" "018097" "018098" "018099" "018100" "018101" "018102" "018103" "018104" "018105" "018106" "018107" "018108" "018109" "018110" )
	    ;;
	19 )
            ayaat_list_of_given_surah=( "019001" "019002" "019003" "019004" "019005" "019006" "019007" "019008" "019009" "019010" "019011" "019012" "019013" "019014" "019015" "019016" "019017" "019018" "019019" "019020" "019021" "019022" "019023" "019024" "019025" "019026" "019027" "019028" "019029" "019030" "019031" "019032" "019033" "019034" "019035" "019036" "019037" "019038" "019039" "019040" "019041" "019042" "019043" "019044" "019045" "019046" "019047" "019048" "019049" "019050" "019051" "019052" "019053" "019054" "019055" "019056" "019057" "019058" "019059" "019060" "019061" "019062" "019063" "019064" "019065" "019066" "019067" "019068" "019069" "019070" "019071" "019072" "019073" "019074" "019075" "019076" "019077" "019078" "019079" "019080" "019081" "019082" "019083" "019084" "019085" "019086" "019087" "019088" "019089" "019090" "019091" "019092" "019093" "019094" "019095" "019096" "019097" "019098" )
	    ;;
	20 )
            ayaat_list_of_given_surah=( "020001" "020002" "020003" "020004" "020005" "020006" "020007" "020008" "020009" "020010" "020011" "020012" "020013" "020014" "020015" "020016" "020017" "020018" "020019" "020020" "020021" "020022" "020023" "020024" "020025" "020026" "020027" "020028" "020029" "020030" "020031" "020032" "020033" "020034" "020035" "020036" "020037" "020038" "020039" "020040" "020041" "020042" "020043" "020044" "020045" "020046" "020047" "020048" "020049" "020050" "020051" "020052" "020053" "020054" "020055" "020056" "020057" "020058" "020059" "020060" "020061" "020062" "020063" "020064" "020065" "020066" "020067" "020068" "020069" "020070" "020071" "020072" "020073" "020074" "020075" "020076" "020077" "020078" "020079" "020080" "020081" "020082" "020083" "020084" "020085" "020086" "020087" "020088" "020089" "020090" "020091" "020092" "020093" "020094" "020095" "020096" "020097" "020098" "020099" "020100" "020101" "020102" "020103" "020104" "020105" "020106" "020107" "020108" "020109" "020110" "020111" "020112" "020113" "020114" "020115" "020116" "020117" "020118" "020119" "020120" "020121" "020122" "020123" "020124" "020125" "020126" "020127" "020128" "020129" "020130" "020131" "020132" "020133" "020134" "020135" )
	    ;;
	21 )
            ayaat_list_of_given_surah=( "021001" "021002" "021003" "021004" "021005" "021006" "021007" "021008" "021009" "021010" "021011" "021012" "021013" "021014" "021015" "021016" "021017" "021018" "021019" "021020" "021021" "021022" "021023" "021024" "021025" "021026" "021027" "021028" "021029" "021030" "021031" "021032" "021033" "021034" "021035" "021036" "021037" "021038" "021039" "021040" "021041" "021042" "021043" "021044" "021045" "021046" "021047" "021048" "021049" "021050" "021051" "021052" "021053" "021054" "021055" "021056" "021057" "021058" "021059" "021060" "021061" "021062" "021063" "021064" "021065" "021066" "021067" "021068" "021069" "021070" "021071" "021072" "021073" "021074" "021075" "021076" "021077" "021078" "021079" "021080" "021081" "021082" "021083" "021084" "021085" "021086" "021087" "021088" "021089" "021090" "021091" "021092" "021093" "021094" "021095" "021096" "021097" "021098" "021099" "021100" "021101" "021102" "021103" "021104" "021105" "021106" "021107" "021108" "021109" "021110" "021111" "021112" )
	    ;;
	22 )
            ayaat_list_of_given_surah=( "022001" "022002" "022003" "022004" "022005" "022006" "022007" "022008" "022009" "022010" "022011" "022012" "022013" "022014" "022015" "022016" "022017" "022018" "022019" "022020" "022021" "022022" "022023" "022024" "022025" "022026" "022027" "022028" "022029" "022030" "022031" "022032" "022033" "022034" "022035" "022036" "022037" "022038" "022039" "022040" "022041" "022042" "022043" "022044" "022045" "022046" "022047" "022048" "022049" "022050" "022051" "022052" "022053" "022054" "022055" "022056" "022057" "022058" "022059" "022060" "022061" "022062" "022063" "022064" "022065" "022066" "022067" "022068" "022069" "022070" "022071" "022072" "022073" "022074" "022075" "022076" "022077" "022078" )
	    ;;
	23 )
            ayaat_list_of_given_surah=( "023001" "023002" "023003" "023004" "023005" "023006" "023007" "023008" "023009" "023010" "023011" "023012" "023013" "023014" "023015" "023016" "023017" "023018" "023019" "023020" "023021" "023022" "023023" "023024" "023025" "023026" "023027" "023028" "023029" "023030" "023031" "023032" "023033" "023034" "023035" "023036" "023037" "023038" "023039" "023040" "023041" "023042" "023043" "023044" "023045" "023046" "023047" "023048" "023049" "023050" "023051" "023052" "023053" "023054" "023055" "023056" "023057" "023058" "023059" "023060" "023061" "023062" "023063" "023064" "023065" "023066" "023067" "023068" "023069" "023070" "023071" "023072" "023073" "023074" "023075" "023076" "023077" "023078" "023079" "023080" "023081" "023082" "023083" "023084" "023085" "023086" "023087" "023088" "023089" "023090" "023091" "023092" "023093" "023094" "023095" "023096" "023097" "023098" "023099" "023100" "023101" "023102" "023103" "023104" "023105" "023106" "023107" "023108" "023109" "023110" "023111" "023112" "023113" "023114" "023115" "023116" "023117" "023118" )
	    ;;
	24 )
            ayaat_list_of_given_surah=( "024001" "024002" "024003" "024004" "024005" "024006" "024007" "024008" "024009" "024010" "024011" "024012" "024013" "024014" "024015" "024016" "024017" "024018" "024019" "024020" "024021" "024022" "024023" "024024" "024025" "024026" "024027" "024028" "024029" "024030" "024031" "024032" "024033" "024034" "024035" "024036" "024037" "024038" "024039" "024040" "024041" "024042" "024043" "024044" "024045" "024046" "024047" "024048" "024049" "024050" "024051" "024052" "024053" "024054" "024055" "024056" "024057" "024058" "024059" "024060" "024061" "024062" "024063" "024064" )
	    ;;
	25 )
            ayaat_list_of_given_surah=( "025001" "025002" "025003" "025004" "025005" "025006" "025007" "025008" "025009" "025010" "025011" "025012" "025013" "025014" "025015" "025016" "025017" "025018" "025019" "025020" "025021" "025022" "025023" "025024" "025025" "025026" "025027" "025028" "025029" "025030" "025031" "025032" "025033" "025034" "025035" "025036" "025037" "025038" "025039" "025040" "025041" "025042" "025043" "025044" "025045" "025046" "025047" "025048" "025049" "025050" "025051" "025052" "025053" "025054" "025055" "025056" "025057" "025058" "025059" "025060" "025061" "025062" "025063" "025064" "025065" "025066" "025067" "025068" "025069" "025070" "025071" "025072" "025073" "025074" "025075" "025076" "025077" )
	    ;;
	26 )
            ayaat_list_of_given_surah=( "026001" "026002" "026003" "026004" "026005" "026006" "026007" "026008" "026009" "026010" "026011" "026012" "026013" "026014" "026015" "026016" "026017" "026018" "026019" "026020" "026021" "026022" "026023" "026024" "026025" "026026" "026027" "026028" "026029" "026030" "026031" "026032" "026033" "026034" "026035" "026036" "026037" "026038" "026039" "026040" "026041" "026042" "026043" "026044" "026045" "026046" "026047" "026048" "026049" "026050" "026051" "026052" "026053" "026054" "026055" "026056" "026057" "026058" "026059" "026060" "026061" "026062" "026063" "026064" "026065" "026066" "026067" "026068" "026069" "026070" "026071" "026072" "026073" "026074" "026075" "026076" "026077" "026078" "026079" "026080" "026081" "026082" "026083" "026084" "026085" "026086" "026087" "026088" "026089" "026090" "026091" "026092" "026093" "026094" "026095" "026096" "026097" "026098" "026099" "026100" "026101" "026102" "026103" "026104" "026105" "026106" "026107" "026108" "026109" "026110" "026111" "026112" "026113" "026114" "026115" "026116" "026117" "026118" "026119" "026120" "026121" "026122" "026123" "026124" "026125" "026126" "026127" "026128" "026129" "026130" "026131" "026132" "026133" "026134" "026135" "026136" "026137" "026138" "026139" "026140" "026141" "026142" "026143" "026144" "026145" "026146" "026147" "026148" "026149" "026150" "026151" "026152" "026153" "026154" "026155" "026156" "026157" "026158" "026159" "026160" "026161" "026162" "026163" "026164" "026165" "026166" "026167" "026168" "026169" "026170" "026171" "026172" "026173" "026174" "026175" "026176" "026177" "026178" "026179" "026180" "026181" "026182" "026183" "026184" "026185" "026186" "026187" "026188" "026189" "026190" "026191" "026192" "026193" "026194" "026195" "026196" "026197" "026198" "026199" "026200" "026201" "026202" "026203" "026204" "026205" "026206" "026207" "026208" "026209" "026210" "026211" "026212" "026213" "026214" "026215" "026216" "026217" "026218" "026219" "026220" "026221" "026222" "026223" "026224" "026225" "026226" "026227" )
	    ;;
	27 )
            ayaat_list_of_given_surah=( "027001" "027002" "027003" "027004" "027005" "027006" "027007" "027008" "027009" "027010" "027011" "027012" "027013" "027014" "027015" "027016" "027017" "027018" "027019" "027020" "027021" "027022" "027023" "027024" "027025" "027026" "027027" "027028" "027029" "027030" "027031" "027032" "027033" "027034" "027035" "027036" "027037" "027038" "027039" "027040" "027041" "027042" "027043" "027044" "027045" "027046" "027047" "027048" "027049" "027050" "027051" "027052" "027053" "027054" "027055" "027056" "027057" "027058" "027059" "027060" "027061" "027062" "027063" "027064" "027065" "027066" "027067" "027068" "027069" "027070" "027071" "027072" "027073" "027074" "027075" "027076" "027077" "027078" "027079" "027080" "027081" "027082" "027083" "027084" "027085" "027086" "027087" "027088" "027089" "027090" "027091" "027092" "027093" )
	    ;;
	28 )
            ayaat_list_of_given_surah=( "028001" "028002" "028003" "028004" "028005" "028006" "028007" "028008" "028009" "028010" "028011" "028012" "028013" "028014" "028015" "028016" "028017" "028018" "028019" "028020" "028021" "028022" "028023" "028024" "028025" "028026" "028027" "028028" "028029" "028030" "028031" "028032" "028033" "028034" "028035" "028036" "028037" "028038" "028039" "028040" "028041" "028042" "028043" "028044" "028045" "028046" "028047" "028048" "028049" "028050" "028051" "028052" "028053" "028054" "028055" "028056" "028057" "028058" "028059" "028060" "028061" "028062" "028063" "028064" "028065" "028066" "028067" "028068" "028069" "028070" "028071" "028072" "028073" "028074" "028075" "028076" "028077" "028078" "028079" "028080" "028081" "028082" "028083" "028084" "028085" "028086" "028087" "028088" )
	    ;;
	29 )
            ayaat_list_of_given_surah=( "029001" "029002" "029003" "029004" "029005" "029006" "029007" "029008" "029009" "029010" "029011" "029012" "029013" "029014" "029015" "029016" "029017" "029018" "029019" "029020" "029021" "029022" "029023" "029024" "029025" "029026" "029027" "029028" "029029" "029030" "029031" "029032" "029033" "029034" "029035" "029036" "029037" "029038" "029039" "029040" "029041" "029042" "029043" "029044" "029045" "029046" "029047" "029048" "029049" "029050" "029051" "029052" "029053" "029054" "029055" "029056" "029057" "029058" "029059" "029060" "029061" "029062" "029063" "029064" "029065" "029066" "029067" "029068" "029069" )
	    ;;
	30 )
            ayaat_list_of_given_surah=( "030001" "030002" "030003" "030004" "030005" "030006" "030007" "030008" "030009" "030010" "030011" "030012" "030013" "030014" "030015" "030016" "030017" "030018" "030019" "030020" "030021" "030022" "030023" "030024" "030025" "030026" "030027" "030028" "030029" "030030" "030031" "030032" "030033" "030034" "030035" "030036" "030037" "030038" "030039" "030040" "030041" "030042" "030043" "030044" "030045" "030046" "030047" "030048" "030049" "030050" "030051" "030052" "030053" "030054" "030055" "030056" "030057" "030058" "030059" "030060" )
	    ;;
	31 )
            ayaat_list_of_given_surah=( "031001" "031002" "031003" "031004" "031005" "031006" "031007" "031008" "031009" "031010" "031011" "031012" "031013" "031014" "031015" "031016" "031017" "031018" "031019" "031020" "031021" "031022" "031023" "031024" "031025" "031026" "031027" "031028" "031029" "031030" "031031" "031032" "031033" "031034" )
	    ;;
	32 )
            ayaat_list_of_given_surah=( "032001" "032002" "032003" "032004" "032005" "032006" "032007" "032008" "032009" "032010" "032011" "032012" "032013" "032014" "032015" "032016" "032017" "032018" "032019" "032020" "032021" "032022" "032023" "032024" "032025" "032026" "032027" "032028" "032029" "032030" )
	    ;;
	33 )
            ayaat_list_of_given_surah=( "033001" "033002" "033003" "033004" "033005" "033006" "033007" "033008" "033009" "033010" "033011" "033012" "033013" "033014" "033015" "033016" "033017" "033018" "033019" "033020" "033021" "033022" "033023" "033024" "033025" "033026" "033027" "033028" "033029" "033030" "033031" "033032" "033033" "033034" "033035" "033036" "033037" "033038" "033039" "033040" "033041" "033042" "033043" "033044" "033045" "033046" "033047" "033048" "033049" "033050" "033051" "033052" "033053" "033054" "033055" "033056" "033057" "033058" "033059" "033060" "033061" "033062" "033063" "033064" "033065" "033066" "033067" "033068" "033069" "033070" "033071" "033072" "033073" )
	    ;;
	34 )
            ayaat_list_of_given_surah=( "034001" "034002" "034003" "034004" "034005" "034006" "034007" "034008" "034009" "034010" "034011" "034012" "034013" "034014" "034015" "034016" "034017" "034018" "034019" "034020" "034021" "034022" "034023" "034024" "034025" "034026" "034027" "034028" "034029" "034030" "034031" "034032" "034033" "034034" "034035" "034036" "034037" "034038" "034039" "034040" "034041" "034042" "034043" "034044" "034045" "034046" "034047" "034048" "034049" "034050" "034051" "034052" "034053" "034054" )
	    ;;
	35 )
            ayaat_list_of_given_surah=( "035001" "035002" "035003" "035004" "035005" "035006" "035007" "035008" "035009" "035010" "035011" "035012" "035013" "035014" "035015" "035016" "035017" "035018" "035019" "035020" "035021" "035022" "035023" "035024" "035025" "035026" "035027" "035028" "035029" "035030" "035031" "035032" "035033" "035034" "035035" "035036" "035037" "035038" "035039" "035040" "035041" "035042" "035043" "035044" "035045" )
	    ;;
	36 )
            ayaat_list_of_given_surah=( "036001" "036002" "036003" "036004" "036005" "036006" "036007" "036008" "036009" "036010" "036011" "036012" "036013" "036014" "036015" "036016" "036017" "036018" "036019" "036020" "036021" "036022" "036023" "036024" "036025" "036026" "036027" "036028" "036029" "036030" "036031" "036032" "036033" "036034" "036035" "036036" "036037" "036038" "036039" "036040" "036041" "036042" "036043" "036044" "036045" "036046" "036047" "036048" "036049" "036050" "036051" "036052" "036053" "036054" "036055" "036056" "036057" "036058" "036059" "036060" "036061" "036062" "036063" "036064" "036065" "036066" "036067" "036068" "036069" "036070" "036071" "036072" "036073" "036074" "036075" "036076" "036077" "036078" "036079" "036080" "036081" "036082" "036083" )
	    ;;
	37 )
            ayaat_list_of_given_surah=( "037001" "037002" "037003" "037004" "037005" "037006" "037007" "037008" "037009" "037010" "037011" "037012" "037013" "037014" "037015" "037016" "037017" "037018" "037019" "037020" "037021" "037022" "037023" "037024" "037025" "037026" "037027" "037028" "037029" "037030" "037031" "037032" "037033" "037034" "037035" "037036" "037037" "037038" "037039" "037040" "037041" "037042" "037043" "037044" "037045" "037046" "037047" "037048" "037049" "037050" "037051" "037052" "037053" "037054" "037055" "037056" "037057" "037058" "037059" "037060" "037061" "037062" "037063" "037064" "037065" "037066" "037067" "037068" "037069" "037070" "037071" "037072" "037073" "037074" "037075" "037076" "037077" "037078" "037079" "037080" "037081" "037082" "037083" "037084" "037085" "037086" "037087" "037088" "037089" "037090" "037091" "037092" "037093" "037094" "037095" "037096" "037097" "037098" "037099" "037100" "037101" "037102" "037103" "037104" "037105" "037106" "037107" "037108" "037109" "037110" "037111" "037112" "037113" "037114" "037115" "037116" "037117" "037118" "037119" "037120" "037121" "037122" "037123" "037124" "037125" "037126" "037127" "037128" "037129" "037130" "037131" "037132" "037133" "037134" "037135" "037136" "037137" "037138" "037139" "037140" "037141" "037142" "037143" "037144" "037145" "037146" "037147" "037148" "037149" "037150" "037151" "037152" "037153" "037154" "037155" "037156" "037157" "037158" "037159" "037160" "037161" "037162" "037163" "037164" "037165" "037166" "037167" "037168" "037169" "037170" "037171" "037172" "037173" "037174" "037175" "037176" "037177" "037178" "037179" "037180" "037181" "037182" )
	    ;;
	38 )
            ayaat_list_of_given_surah=( "038001" "038002" "038003" "038004" "038005" "038006" "038007" "038008" "038009" "038010" "038011" "038012" "038013" "038014" "038015" "038016" "038017" "038018" "038019" "038020" "038021" "038022" "038023" "038024" "038025" "038026" "038027" "038028" "038029" "038030" "038031" "038032" "038033" "038034" "038035" "038036" "038037" "038038" "038039" "038040" "038041" "038042" "038043" "038044" "038045" "038046" "038047" "038048" "038049" "038050" "038051" "038052" "038053" "038054" "038055" "038056" "038057" "038058" "038059" "038060" "038061" "038062" "038063" "038064" "038065" "038066" "038067" "038068" "038069" "038070" "038071" "038072" "038073" "038074" "038075" "038076" "038077" "038078" "038079" "038080" "038081" "038082" "038083" "038084" "038085" "038086" "038087" "038088" )
	    ;;
	39 )
            ayaat_list_of_given_surah=( "039001" "039002" "039003" "039004" "039005" "039006" "039007" "039008" "039009" "039010" "039011" "039012" "039013" "039014" "039015" "039016" "039017" "039018" "039019" "039020" "039021" "039022" "039023" "039024" "039025" "039026" "039027" "039028" "039029" "039030" "039031" "039032" "039033" "039034" "039035" "039036" "039037" "039038" "039039" "039040" "039041" "039042" "039043" "039044" "039045" "039046" "039047" "039048" "039049" "039050" "039051" "039052" "039053" "039054" "039055" "039056" "039057" "039058" "039059" "039060" "039061" "039062" "039063" "039064" "039065" "039066" "039067" "039068" "039069" "039070" "039071" "039072" "039073" "039074" "039075" )
	    ;;
	40 )
            ayaat_list_of_given_surah=( "040001" "040002" "040003" "040004" "040005" "040006" "040007" "040008" "040009" "040010" "040011" "040012" "040013" "040014" "040015" "040016" "040017" "040018" "040019" "040020" "040021" "040022" "040023" "040024" "040025" "040026" "040027" "040028" "040029" "040030" "040031" "040032" "040033" "040034" "040035" "040036" "040037" "040038" "040039" "040040" "040041" "040042" "040043" "040044" "040045" "040046" "040047" "040048" "040049" "040050" "040051" "040052" "040053" "040054" "040055" "040056" "040057" "040058" "040059" "040060" "040061" "040062" "040063" "040064" "040065" "040066" "040067" "040068" "040069" "040070" "040071" "040072" "040073" "040074" "040075" "040076" "040077" "040078" "040079" "040080" "040081" "040082" "040083" "040084" "040085" )
	    ;;
	41 )
            ayaat_list_of_given_surah=( "041001" "041002" "041003" "041004" "041005" "041006" "041007" "041008" "041009" "041010" "041011" "041012" "041013" "041014" "041015" "041016" "041017" "041018" "041019" "041020" "041021" "041022" "041023" "041024" "041025" "041026" "041027" "041028" "041029" "041030" "041031" "041032" "041033" "041034" "041035" "041036" "041037" "041038" "041039" "041040" "041041" "041042" "041043" "041044" "041045" "041046" "041047" "041048" "041049" "041050" "041051" "041052" "041053" "041054" )
	    ;;
	42 )
            ayaat_list_of_given_surah=( "042001" "042002" "042003" "042004" "042005" "042006" "042007" "042008" "042009" "042010" "042011" "042012" "042013" "042014" "042015" "042016" "042017" "042018" "042019" "042020" "042021" "042022" "042023" "042024" "042025" "042026" "042027" "042028" "042029" "042030" "042031" "042032" "042033" "042034" "042035" "042036" "042037" "042038" "042039" "042040" "042041" "042042" "042043" "042044" "042045" "042046" "042047" "042048" "042049" "042050" "042051" "042052" "042053" )
	    ;;
	43 )
            ayaat_list_of_given_surah=( "043001" "043002" "043003" "043004" "043005" "043006" "043007" "043008" "043009" "043010" "043011" "043012" "043013" "043014" "043015" "043016" "043017" "043018" "043019" "043020" "043021" "043022" "043023" "043024" "043025" "043026" "043027" "043028" "043029" "043030" "043031" "043032" "043033" "043034" "043035" "043036" "043037" "043038" "043039" "043040" "043041" "043042" "043043" "043044" "043045" "043046" "043047" "043048" "043049" "043050" "043051" "043052" "043053" "043054" "043055" "043056" "043057" "043058" "043059" "043060" "043061" "043062" "043063" "043064" "043065" "043066" "043067" "043068" "043069" "043070" "043071" "043072" "043073" "043074" "043075" "043076" "043077" "043078" "043079" "043080" "043081" "043082" "043083" "043084" "043085" "043086" "043087" "043088" "043089" )
	    ;;
	44 )
            ayaat_list_of_given_surah=( "044001" "044002" "044003" "044004" "044005" "044006" "044007" "044008" "044009" "044010" "044011" "044012" "044013" "044014" "044015" "044016" "044017" "044018" "044019" "044020" "044021" "044022" "044023" "044024" "044025" "044026" "044027" "044028" "044029" "044030" "044031" "044032" "044033" "044034" "044035" "044036" "044037" "044038" "044039" "044040" "044041" "044042" "044043" "044044" "044045" "044046" "044047" "044048" "044049" "044050" "044051" "044052" "044053" "044054" "044055" "044056" "044057" "044058" "044059" )
	    ;;
	45 )
            ayaat_list_of_given_surah=( "045001" "045002" "045003" "045004" "045005" "045006" "045007" "045008" "045009" "045010" "045011" "045012" "045013" "045014" "045015" "045016" "045017" "045018" "045019" "045020" "045021" "045022" "045023" "045024" "045025" "045026" "045027" "045028" "045029" "045030" "045031" "045032" "045033" "045034" "045035" "045036" "045037" )
	    ;;
	46 )
            ayaat_list_of_given_surah=( "046001" "046002" "046003" "046004" "046005" "046006" "046007" "046008" "046009" "046010" "046011" "046012" "046013" "046014" "046015" "046016" "046017" "046018" "046019" "046020" "046021" "046022" "046023" "046024" "046025" "046026" "046027" "046028" "046029" "046030" "046031" "046032" "046033" "046034" "046035" )
	    ;;
	47 )
            ayaat_list_of_given_surah=( "047001" "047002" "047003" "047004" "047005" "047006" "047007" "047008" "047009" "047010" "047011" "047012" "047013" "047014" "047015" "047016" "047017" "047018" "047019" "047020" "047021" "047022" "047023" "047024" "047025" "047026" "047027" "047028" "047029" "047030" "047031" "047032" "047033" "047034" "047035" "047036" "047037" "047038" )
	    ;;
	48 )
            ayaat_list_of_given_surah=( "048001" "048002" "048003" "048004" "048005" "048006" "048007" "048008" "048009" "048010" "048011" "048012" "048013" "048014" "048015" "048016" "048017" "048018" "048019" "048020" "048021" "048022" "048023" "048024" "048025" "048026" "048027" "048028" "048029" )
	    ;;
	49 )
            ayaat_list_of_given_surah=( "049001" "049002" "049003" "049004" "049005" "049006" "049007" "049008" "049009" "049010" "049011" "049012" "049013" "049014" "049015" "049016" "049017" "049018" )
	    ;;
	50 )
            ayaat_list_of_given_surah=( "050001" "050002" "050003" "050004" "050005" "050006" "050007" "050008" "050009" "050010" "050011" "050012" "050013" "050014" "050015" "050016" "050017" "050018" "050019" "050020" "050021" "050022" "050023" "050024" "050025" "050026" "050027" "050028" "050029" "050030" "050031" "050032" "050033" "050034" "050035" "050036" "050037" "050038" "050039" "050040" "050041" "050042" "050043" "050044" "050045" )
	    ;;
	51 )
            ayaat_list_of_given_surah=( "051001" "051002" "051003" "051004" "051005" "051006" "051007" "051008" "051009" "051010" "051011" "051012" "051013" "051014" "051015" "051016" "051017" "051018" "051019" "051020" "051021" "051022" "051023" "051024" "051025" "051026" "051027" "051028" "051029" "051030" "051031" "051032" "051033" "051034" "051035" "051036" "051037" "051038" "051039" "051040" "051041" "051042" "051043" "051044" "051045" "051046" "051047" "051048" "051049" "051050" "051051" "051052" "051053" "051054" "051055" "051056" "051057" "051058" "051059" "051060" )
	    ;;
	52 )
            ayaat_list_of_given_surah=( "052001" "052002" "052003" "052004" "052005" "052006" "052007" "052008" "052009" "052010" "052011" "052012" "052013" "052014" "052015" "052016" "052017" "052018" "052019" "052020" "052021" "052022" "052023" "052024" "052025" "052026" "052027" "052028" "052029" "052030" "052031" "052032" "052033" "052034" "052035" "052036" "052037" "052038" "052039" "052040" "052041" "052042" "052043" "052044" "052045" "052046" "052047" "052048" "052049" )
	    ;;
	53 )
            ayaat_list_of_given_surah=( "053001" "053002" "053003" "053004" "053005" "053006" "053007" "053008" "053009" "053010" "053011" "053012" "053013" "053014" "053015" "053016" "053017" "053018" "053019" "053020" "053021" "053022" "053023" "053024" "053025" "053026" "053027" "053028" "053029" "053030" "053031" "053032" "053033" "053034" "053035" "053036" "053037" "053038" "053039" "053040" "053041" "053042" "053043" "053044" "053045" "053046" "053047" "053048" "053049" "053050" "053051" "053052" "053053" "053054" "053055" "053056" "053057" "053058" "053059" "053060" "053061" "053062" )
	    ;;
	54 )
            ayaat_list_of_given_surah=( "054001" "054002" "054003" "054004" "054005" "054006" "054007" "054008" "054009" "054010" "054011" "054012" "054013" "054014" "054015" "054016" "054017" "054018" "054019" "054020" "054021" "054022" "054023" "054024" "054025" "054026" "054027" "054028" "054029" "054030" "054031" "054032" "054033" "054034" "054035" "054036" "054037" "054038" "054039" "054040" "054041" "054042" "054043" "054044" "054045" "054046" "054047" "054048" "054049" "054050" "054051" "054052" "054053" "054054" "054055" )
	    ;;
	55 )
            ayaat_list_of_given_surah=( "055001" "055002" "055003" "055004" "055005" "055006" "055007" "055008" "055009" "055010" "055011" "055012" "055013" "055014" "055015" "055016" "055017" "055018" "055019" "055020" "055021" "055022" "055023" "055024" "055025" "055026" "055027" "055028" "055029" "055030" "055031" "055032" "055033" "055034" "055035" "055036" "055037" "055038" "055039" "055040" "055041" "055042" "055043" "055044" "055045" "055046" "055047" "055048" "055049" "055050" "055051" "055052" "055053" "055054" "055055" "055056" "055057" "055058" "055059" "055060" "055061" "055062" "055063" "055064" "055065" "055066" "055067" "055068" "055069" "055070" "055071" "055072" "055073" "055074" "055075" "055076" "055077" "055078" )
	    ;;
	56 )
            ayaat_list_of_given_surah=( "056001" "056002" "056003" "056004" "056005" "056006" "056007" "056008" "056009" "056010" "056011" "056012" "056013" "056014" "056015" "056016" "056017" "056018" "056019" "056020" "056021" "056022" "056023" "056024" "056025" "056026" "056027" "056028" "056029" "056030" "056031" "056032" "056033" "056034" "056035" "056036" "056037" "056038" "056039" "056040" "056041" "056042" "056043" "056044" "056045" "056046" "056047" "056048" "056049" "056050" "056051" "056052" "056053" "056054" "056055" "056056" "056057" "056058" "056059" "056060" "056061" "056062" "056063" "056064" "056065" "056066" "056067" "056068" "056069" "056070" "056071" "056072" "056073" "056074" "056075" "056076" "056077" "056078" "056079" "056080" "056081" "056082" "056083" "056084" "056085" "056086" "056087" "056088" "056089" "056090" "056091" "056092" "056093" "056094" "056095" "056096" )
	    ;;
	57 )
            ayaat_list_of_given_surah=( "057001" "057002" "057003" "057004" "057005" "057006" "057007" "057008" "057009" "057010" "057011" "057012" "057013" "057014" "057015" "057016" "057017" "057018" "057019" "057020" "057021" "057022" "057023" "057024" "057025" "057026" "057027" "057028" "057029" )
	    ;;
	58 )
            ayaat_list_of_given_surah=( "058001" "058002" "058003" "058004" "058005" "058006" "058007" "058008" "058009" "058010" "058011" "058012" "058013" "058014" "058015" "058016" "058017" "058018" "058019" "058020" "058021" "058022" )
	    ;;
	59 )
            ayaat_list_of_given_surah=( "059001" "059002" "059003" "059004" "059005" "059006" "059007" "059008" "059009" "059010" "059011" "059012" "059013" "059014" "059015" "059016" "059017" "059018" "059019" "059020" "059021" "059022" "059023" "059024" )
	    ;;
	60 )
            ayaat_list_of_given_surah=( "060001" "060002" "060003" "060004" "060005" "060006" "060007" "060008" "060009" "060010" "060011" "060012" "060013" )
	    ;;
	61 )
            ayaat_list_of_given_surah=( "061001" "061002" "061003" "061004" "061005" "061006" "061007" "061008" "061009" "061010" "061011" "061012" "061013" "061014" )
	    ;;
	62 )
            ayaat_list_of_given_surah=( "062001" "062002" "062003" "062004" "062005" "062006" "062007" "062008" "062009" "062010" "062011" )
	    ;;
	63 )
            ayaat_list_of_given_surah=( "063001" "063002" "063003" "063004" "063005" "063006" "063007" "063008" "063009" "063010" "063011" )
	    ;;
	64 )
            ayaat_list_of_given_surah=( "064001" "064002" "064003" "064004" "064005" "064006" "064007" "064008" "064009" "064010" "064011" "064012" "064013" "064014" "064015" "064016" "064017" "064018" )
	    ;;
	65 )
            ayaat_list_of_given_surah=( "065001" "065002" "065003" "065004" "065005" "065006" "065007" "065008" "065009" "065010" "065011" "065012" )
	    ;;
	66 )
            ayaat_list_of_given_surah=( "066001" "066002" "066003" "066004" "066005" "066006" "066007" "066008" "066009" "066010" "066011" "066012" )
	    ;;
	67 )
            ayaat_list_of_given_surah=( "067001" "067002" "067003" "067004" "067005" "067006" "067007" "067008" "067009" "067010" "067011" "067012" "067013" "067014" "067015" "067016" "067017" "067018" "067019" "067020" "067021" "067022" "067023" "067024" "067025" "067026" "067027" "067028" "067029" "067030" )
	    ;;
	68 )
            ayaat_list_of_given_surah=( "068001" "068002" "068003" "068004" "068005" "068006" "068007" "068008" "068009" "068010" "068011" "068012" "068013" "068014" "068015" "068016" "068017" "068018" "068019" "068020" "068021" "068022" "068023" "068024" "068025" "068026" "068027" "068028" "068029" "068030" "068031" "068032" "068033" "068034" "068035" "068036" "068037" "068038" "068039" "068040" "068041" "068042" "068043" "068044" "068045" "068046" "068047" "068048" "068049" "068050" "068051" "068052" )
	    ;;
	69 )
            ayaat_list_of_given_surah=( "069001" "069002" "069003" "069004" "069005" "069006" "069007" "069008" "069009" "069010" "069011" "069012" "069013" "069014" "069015" "069016" "069017" "069018" "069019" "069020" "069021" "069022" "069023" "069024" "069025" "069026" "069027" "069028" "069029" "069030" "069031" "069032" "069033" "069034" "069035" "069036" "069037" "069038" "069039" "069040" "069041" "069042" "069043" "069044" "069045" "069046" "069047" "069048" "069049" "069050" "069051" "069052" )
	    ;;
	70 )
            ayaat_list_of_given_surah=( "070001" "070002" "070003" "070004" "070005" "070006" "070007" "070008" "070009" "070010" "070011" "070012" "070013" "070014" "070015" "070016" "070017" "070018" "070019" "070020" "070021" "070022" "070023" "070024" "070025" "070026" "070027" "070028" "070029" "070030" "070031" "070032" "070033" "070034" "070035" "070036" "070037" "070038" "070039" "070040" "070041" "070042" "070043" "070044" )
	    ;;
	71 )
            ayaat_list_of_given_surah=( "071001" "071002" "071003" "071004" "071005" "071006" "071007" "071008" "071009" "071010" "071011" "071012" "071013" "071014" "071015" "071016" "071017" "071018" "071019" "071020" "071021" "071022" "071023" "071024" "071025" "071026" "071027" "071028" )
	    ;;
	72 )
            ayaat_list_of_given_surah=( "072001" "072002" "072003" "072004" "072005" "072006" "072007" "072008" "072009" "072010" "072011" "072012" "072013" "072014" "072015" "072016" "072017" "072018" "072019" "072020" "072021" "072022" "072023" "072024" "072025" "072026" "072027" "072028" )
	    ;;
	73 )
            ayaat_list_of_given_surah=( "073001" "073002" "073003" "073004" "073005" "073006" "073007" "073008" "073009" "073010" "073011" "073012" "073013" "073014" "073015" "073016" "073017" "073018" "073019" "073020" )
	    ;;
	74 )
            ayaat_list_of_given_surah=( "074001" "074002" "074003" "074004" "074005" "074006" "074007" "074008" "074009" "074010" "074011" "074012" "074013" "074014" "074015" "074016" "074017" "074018" "074019" "074020" "074021" "074022" "074023" "074024" "074025" "074026" "074027" "074028" "074029" "074030" "074031" "074032" "074033" "074034" "074035" "074036" "074037" "074038" "074039" "074040" "074041" "074042" "074043" "074044" "074045" "074046" "074047" "074048" "074049" "074050" "074051" "074052" "074053" "074054" "074055" "074056" )
	    ;;
	75 )
            ayaat_list_of_given_surah=( "075001" "075002" "075003" "075004" "075005" "075006" "075007" "075008" "075009" "075010" "075011" "075012" "075013" "075014" "075015" "075016" "075017" "075018" "075019" "075020" "075021" "075022" "075023" "075024" "075025" "075026" "075027" "075028" "075029" "075030" "075031" "075032" "075033" "075034" "075035" "075036" "075037" "075038" "075039" "075040" )
	    ;;
	76 )
            ayaat_list_of_given_surah=( "076001" "076002" "076003" "076004" "076005" "076006" "076007" "076008" "076009" "076010" "076011" "076012" "076013" "076014" "076015" "076016" "076017" "076018" "076019" "076020" "076021" "076022" "076023" "076024" "076025" "076026" "076027" "076028" "076029" "076030" "076031" )
	    ;;
	77 )
            ayaat_list_of_given_surah=( "077001" "077002" "077003" "077004" "077005" "077006" "077007" "077008" "077009" "077010" "077011" "077012" "077013" "077014" "077015" "077016" "077017" "077018" "077019" "077020" "077021" "077022" "077023" "077024" "077025" "077026" "077027" "077028" "077029" "077030" "077031" "077032" "077033" "077034" "077035" "077036" "077037" "077038" "077039" "077040" "077041" "077042" "077043" "077044" "077045" "077046" "077047" "077048" "077049" "077050" )
	    ;;
	78 )
            ayaat_list_of_given_surah=( "078001" "078002" "078003" "078004" "078005" "078006" "078007" "078008" "078009" "078010" "078011" "078012" "078013" "078014" "078015" "078016" "078017" "078018" "078019" "078020" "078021" "078022" "078023" "078024" "078025" "078026" "078027" "078028" "078029" "078030" "078031" "078032" "078033" "078034" "078035" "078036" "078037" "078038" "078039" "078040" )
	    ;;
	79 )
            ayaat_list_of_given_surah=( "079001" "079002" "079003" "079004" "079005" "079006" "079007" "079008" "079009" "079010" "079011" "079012" "079013" "079014" "079015" "079016" "079017" "079018" "079019" "079020" "079021" "079022" "079023" "079024" "079025" "079026" "079027" "079028" "079029" "079030" "079031" "079032" "079033" "079034" "079035" "079036" "079037" "079038" "079039" "079040" "079041" "079042" "079043" "079044" "079045" "079046" )
	    ;;
	80 )
            ayaat_list_of_given_surah=( "080001" "080002" "080003" "080004" "080005" "080006" "080007" "080008" "080009" "080010" "080011" "080012" "080013" "080014" "080015" "080016" "080017" "080018" "080019" "080020" "080021" "080022" "080023" "080024" "080025" "080026" "080027" "080028" "080029" "080030" "080031" "080032" "080033" "080034" "080035" "080036" "080037" "080038" "080039" "080040" "080041" "080042" )
	    ;;
	81 )
            ayaat_list_of_given_surah=( "081001" "081002" "081003" "081004" "081005" "081006" "081007" "081008" "081009" "081010" "081011" "081012" "081013" "081014" "081015" "081016" "081017" "081018" "081019" "081020" "081021" "081022" "081023" "081024" "081025" "081026" "081027" "081028" "081029" )
	    ;;
	82 )
            ayaat_list_of_given_surah=( "082001" "082002" "082003" "082004" "082005" "082006" "082007" "082008" "082009" "082010" "082011" "082012" "082013" "082014" "082015" "082016" "082017" "082018" "082019" )
	    ;;
	83 )
            ayaat_list_of_given_surah=( "083001" "083002" "083003" "083004" "083005" "083006" "083007" "083008" "083009" "083010" "083011" "083012" "083013" "083014" "083015" "083016" "083017" "083018" "083019" "083020" "083021" "083022" "083023" "083024" "083025" "083026" "083027" "083028" "083029" "083030" "083031" "083032" "083033" "083034" "083035" "083036" )
	    ;;
	84 )
            ayaat_list_of_given_surah=( "084001" "084002" "084003" "084004" "084005" "084006" "084007" "084008" "084009" "084010" "084011" "084012" "084013" "084014" "084015" "084016" "084017" "084018" "084019" "084020" "084021" "084022" "084023" "084024" "084025" )
	    ;;
	85 )
            ayaat_list_of_given_surah=( "085001" "085002" "085003" "085004" "085005" "085006" "085007" "085008" "085009" "085010" "085011" "085012" "085013" "085014" "085015" "085016" "085017" "085018" "085019" "085020" "085021" "085022" )
	    ;;
	86 )
            ayaat_list_of_given_surah=( "086001" "086002" "086003" "086004" "086005" "086006" "086007" "086008" "086009" "086010" "086011" "086012" "086013" "086014" "086015" "086016" "086017" )
	    ;;
	87 )
            ayaat_list_of_given_surah=( "087001" "087002" "087003" "087004" "087005" "087006" "087007" "087008" "087009" "087010" "087011" "087012" "087013" "087014" "087015" "087016" "087017" "087018" "087019" )
	    ;;
	88 )
            ayaat_list_of_given_surah=( "088001" "088002" "088003" "088004" "088005" "088006" "088007" "088008" "088009" "088010" "088011" "088012" "088013" "088014" "088015" "088016" "088017" "088018" "088019" "088020" "088021" "088022" "088023" "088024" "088025" "088026" )
	    ;;
	89 )
            ayaat_list_of_given_surah=( "089001" "089002" "089003" "089004" "089005" "089006" "089007" "089008" "089009" "089010" "089011" "089012" "089013" "089014" "089015" "089016" "089017" "089018" "089019" "089020" "089021" "089022" "089023" "089024" "089025" "089026" "089027" "089028" "089029" "089030" )
	    ;;
	90 )
            ayaat_list_of_given_surah=( "090001" "090002" "090003" "090004" "090005" "090006" "090007" "090008" "090009" "090010" "090011" "090012" "090013" "090014" "090015" "090016" "090017" "090018" "090019" "090020" )
	    ;;
	91 )
            ayaat_list_of_given_surah=( "091001" "091002" "091003" "091004" "091005" "091006" "091007" "091008" "091009" "091010" "091011" "091012" "091013" "091014" "091015" )
	    ;;
	92 )
            ayaat_list_of_given_surah=( "092001" "092002" "092003" "092004" "092005" "092006" "092007" "092008" "092009" "092010" "092011" "092012" "092013" "092014" "092015" "092016" "092017" "092018" "092019" "092020" "092021" )
	    ;;
	93 )
            ayaat_list_of_given_surah=( "093001" "093002" "093003" "093004" "093005" "093006" "093007" "093008" "093009" "093010" "093011" )
	    ;;
	94 )
            ayaat_list_of_given_surah=( "094001" "094002" "094003" "094004" "094005" "094006" "094007" "094008" )
	    ;;
	95 )
            ayaat_list_of_given_surah=( "095001" "095002" "095003" "095004" "095005" "095006" "095007" "095008" )
	    ;;
        96)
	    ayaat_list_of_given_surah=( "096001" "096002" "096003" "096004" "096005" "096006" "096007" "096008" "096009" "096010" "096011" "096012" "096013" "096014" "096015" "096016" "096017" "096018" "096019" )
	    ;;
	97 )
	    ayaat_list_of_given_surah=( "097001" "097002" "097003" "097004" "097005" )
	    ;;
	98 )
	    ayaat_list_of_given_surah=( "098001" "098002" "098003" "098004" "098005" "098006" "098007" "098008" )
	    ;;
	99 )
	    ayaat_list_of_given_surah=( "099001" "099002" "099003" "099004" "099005" "099006" "099007" "099008" )
	    ;;
	100 )
	    ayaat_list_of_given_surah=( "100001" "100002" "100003" "100004" "100005" "100006" "100007" "100008" "100009" "100010" "100011" )
	    ;;
	101 )
	    ayaat_list_of_given_surah=( "101001" "101002" "101003" "101004" "101005" "101006" "101007" "101008" "101009" "101010" "101011" )
	    ;;
	102 )
	    ayaat_list_of_given_surah=( "102001" "102002" "102003" "102004" "102005" "102006" "102007" "102008" )
	    ;;
	103 )
	    ayaat_list_of_given_surah=( "103001" "103002" "103003" )
	    ;;
	104 )
	    ayaat_list_of_given_surah=( "104001" "104002" "104003" "104004" "104005" "104006" "104007" "104008" "104009" )
	    ;;
	105 )
	    ayaat_list_of_given_surah=( "105001" "105002" "105003" "105004" "105005" )
	    ;;
	106 )
	    ayaat_list_of_given_surah=( "106001" "106002" "106003" "106004" )
	    ;;
	107 )
	    ayaat_list_of_given_surah=( "107001" "107002" "107003" "107004" "107005" "107006" "107007" )
	    ;;
	108)
	    ayaat_list_of_given_surah=( "108001" "108002" "108003" )
	    ;;
	109 )
	    ayaat_list_of_given_surah=( "109001" "109002" "109003" "109004" "109005" "109006" )
	    ;;
	110 )
	    ayaat_list_of_given_surah=( "110001" "110002" "110003" )
	    ;;
	111 )
	    ayaat_list_of_given_surah=( "111001" "111002" "111003" "111004" "111005" )
	    ;;
	112 )
	    ayaat_list_of_given_surah=( "112001" "112002" "112003" "112004" )
	    ;;
	113 )
	    ayaat_list_of_given_surah=( "113001" "113002" "113003" "113004" "113005" )
	    ;;
	114 )
	    ayaat_list_of_given_surah=( "114001" "114002" "114003" "114004" "114005" "114006" )
	    ;;
	*)
	    flag="755"
	    reset
	    echo
	    echo "The Sūrah number you entered in:"
	    echo
	    echo "$surahNumber"
	    echo
	    echo "is invalid! Please provide a number"
	    echo "between 1 and 114 without leading"
	    echo "zeros. i.e., 8 instead of 008."
	    echo
	    exit
    esac
}


# This function gives the Surah
# number without leading zeros
show_surah_number_without_leading_zeros(){
    local ayah_id=`basename "$1"`
    case $ayah_id in
	001000 |  001001 |  001002 |  001003 |  001004 |  001005 |  001006 |  001007 )
            surah_number_without_leading_zeros="1"
	    ;;
	002000 | 002001 | 002002 | 002003 | 002004 | 002005 | 002006 | 002007 | 002008 | 002009 | 002010 | 002011 | 002012 | 002013 | 002014 | 002015 | 002016 | 002017 | 002018 | 002019 | 002020 | 002021 | 002022 | 002023 | 002024 | 002025 | 002026 | 002027 | 002028 | 002029 | 002030 | 002031 | 002032 | 002033 | 002034 | 002035 | 002036 | 002037 | 002038 | 002039 | 002040 | 002041 | 002042 | 002043 | 002044 | 002045 | 002046 | 002047 | 002048 | 002049 | 002050 | 002051 | 002052 | 002053 | 002054 | 002055 | 002056 | 002057 | 002058 | 002059 | 002060 | 002061 | 002062 | 002063 | 002064 | 002065 | 002066 | 002067 | 002068 | 002069 | 002070 | 002071 | 002072 | 002073 | 002074 | 002075 | 002076 | 002077 | 002078 | 002079 | 002080 | 002081 | 002082 | 002083 | 002084 | 002085 | 002086 | 002087 | 002088 | 002089 | 002090 | 002091 | 002092 | 002093 | 002094 | 002095 | 002096 | 002097 | 002098 | 002099 | 002100 | 002101 | 002102 | 002103 | 002104 | 002105 | 002106 | 002107 | 002108 | 002109 | 002110 | 002111 | 002112 | 002113 | 002114 | 002115 | 002116 | 002117 | 002118 | 002119 | 002120 | 002121 | 002122 | 002123 | 002124 | 002125 | 002126 | 002127 | 002128 | 002129 | 002130 | 002131 | 002132 | 002133 | 002134 | 002135 | 002136 | 002137 | 002138 | 002139 | 002140 | 002141 | 002142 | 002143 | 002144 | 002145 | 002146 | 002147 | 002148 | 002149 | 002150 | 002151 | 002152 | 002153 | 002154 | 002155 | 002156 | 002157 | 002158 | 002159 | 002160 | 002161 | 002162 | 002163 | 002164 | 002165 | 002166 | 002167 | 002168 | 002169 | 002170 | 002171 | 002172 | 002173 | 002174 | 002175 | 002176 | 002177 | 002178 | 002179 | 002180 | 002181 | 002182 | 002183 | 002184 | 002185 | 002186 | 002187 | 002188 | 002189 | 002190 | 002191 | 002192 | 002193 | 002194 | 002195 | 002196 | 002197 | 002198 | 002199 | 002200 | 002201 | 002202 | 002203 | 002204 | 002205 | 002206 | 002207 | 002208 | 002209 | 002210 | 002211 | 002212 | 002213 | 002214 | 002215 | 002216 | 002217 | 002218 | 002219 | 002220 | 002221 | 002222 | 002223 | 002224 | 002225 | 002226 | 002227 | 002228 | 002229 | 002230 | 002231 | 002232 | 002233 | 002234 | 002235 | 002236 | 002237 | 002238 | 002239 | 002240 | 002241 | 002242 | 002243 | 002244 | 002245 | 002246 | 002247 | 002248 | 002249 | 002250 | 002251 | 002252 | 002253 | 002254 | 002255 | 002256 | 002257 | 002258 | 002259 | 002260 | 002261 | 002262 | 002263 | 002264 | 002265 | 002266 | 002267 | 002268 | 002269 | 002270 | 002271 | 002272 | 002273 | 002274 | 002275 | 002276 | 002277 | 002278 | 002279 | 002280 | 002281 | 002282 | 002283 | 002284 | 002285 | 002286 )
            surah_number_without_leading_zeros="2"
	    ;;
	003000 | 003001 | 003002 | 003003 | 003004 | 003005 | 003006 | 003007 | 003008 | 003009 | 003010 | 003011 | 003012 | 003013 | 003014 | 003015 | 003016 | 003017 | 003018 | 003019 | 003020 | 003021 | 003022 | 003023 | 003024 | 003025 | 003026 | 003027 | 003028 | 003029 | 003030 | 003031 | 003032 | 003033 | 003034 | 003035 | 003036 | 003037 | 003038 | 003039 | 003040 | 003041 | 003042 | 003043 | 003044 | 003045 | 003046 | 003047 | 003048 | 003049 | 003050 | 003051 | 003052 | 003053 | 003054 | 003055 | 003056 | 003057 | 003058 | 003059 | 003060 | 003061 | 003062 | 003063 | 003064 | 003065 | 003066 | 003067 | 003068 | 003069 | 003070 | 003071 | 003072 | 003073 | 003074 | 003075 | 003076 | 003077 | 003078 | 003079 | 003080 | 003081 | 003082 | 003083 | 003084 | 003085 | 003086 | 003087 | 003088 | 003089 | 003090 | 003091 | 003092 | 003093 | 003094 | 003095 | 003096 | 003097 | 003098 | 003099 | 003100 | 003101 | 003102 | 003103 | 003104 | 003105 | 003106 | 003107 | 003108 | 003109 | 003110 | 003111 | 003112 | 003113 | 003114 | 003115 | 003116 | 003117 | 003118 | 003119 | 003120 | 003121 | 003122 | 003123 | 003124 | 003125 | 003126 | 003127 | 003128 | 003129 | 003130 | 003131 | 003132 | 003133 | 003134 | 003135 | 003136 | 003137 | 003138 | 003139 | 003140 | 003141 | 003142 | 003143 | 003144 | 003145 | 003146 | 003147 | 003148 | 003149 | 003150 | 003151 | 003152 | 003153 | 003154 | 003155 | 003156 | 003157 | 003158 | 003159 | 003160 | 003161 | 003162 | 003163 | 003164 | 003165 | 003166 | 003167 | 003168 | 003169 | 003170 | 003171 | 003172 | 003173 | 003174 | 003175 | 003176 | 003177 | 003178 | 003179 | 003180 | 003181 | 003182 | 003183 | 003184 | 003185 | 003186 | 003187 | 003188 | 003189 | 003190 | 003191 | 003192 | 003193 | 003194 | 003195 | 003196 | 003197 | 003198 | 003199 | 003200 )
            surah_number_without_leading_zeros="3"
	    ;;
	004000 | 004001 | 004002 | 004003 | 004004 | 004005 | 004006 | 004007 | 004008 | 004009 | 004010 | 004011 | 004012 | 004013 | 004014 | 004015 | 004016 | 004017 | 004018 | 004019 | 004020 | 004021 | 004022 | 004023 | 004024 | 004025 | 004026 | 004027 | 004028 | 004029 | 004030 | 004031 | 004032 | 004033 | 004034 | 004035 | 004036 | 004037 | 004038 | 004039 | 004040 | 004041 | 004042 | 004043 | 004044 | 004045 | 004046 | 004047 | 004048 | 004049 | 004050 | 004051 | 004052 | 004053 | 004054 | 004055 | 004056 | 004057 | 004058 | 004059 | 004060 | 004061 | 004062 | 004063 | 004064 | 004065 | 004066 | 004067 | 004068 | 004069 | 004070 | 004071 | 004072 | 004073 | 004074 | 004075 | 004076 | 004077 | 004078 | 004079 | 004080 | 004081 | 004082 | 004083 | 004084 | 004085 | 004086 | 004087 | 004088 | 004089 | 004090 | 004091 | 004092 | 004093 | 004094 | 004095 | 004096 | 004097 | 004098 | 004099 | 004100 | 004101 | 004102 | 004103 | 004104 | 004105 | 004106 | 004107 | 004108 | 004109 | 004110 | 004111 | 004112 | 004113 | 004114 | 004115 | 004116 | 004117 | 004118 | 004119 | 004120 | 004121 | 004122 | 004123 | 004124 | 004125 | 004126 | 004127 | 004128 | 004129 | 004130 | 004131 | 004132 | 004133 | 004134 | 004135 | 004136 | 004137 | 004138 | 004139 | 004140 | 004141 | 004142 | 004143 | 004144 | 004145 | 004146 | 004147 | 004148 | 004149 | 004150 | 004151 | 004152 | 004153 | 004154 | 004155 | 004156 | 004157 | 004158 | 004159 | 004160 | 004161 | 004162 | 004163 | 004164 | 004165 | 004166 | 004167 | 004168 | 004169 | 004170 | 004171 | 004172 | 004173 | 004174 | 004175 | 004176 )
            surah_number_without_leading_zeros="4"
	    ;;
	005000 | 005001 | 005002 | 005003 | 005004 | 005005 | 005006 | 005007 | 005008 | 005009 | 005010 | 005011 | 005012 | 005013 | 005014 | 005015 | 005016 | 005017 | 005018 | 005019 | 005020 | 005021 | 005022 | 005023 | 005024 | 005025 | 005026 | 005027 | 005028 | 005029 | 005030 | 005031 | 005032 | 005033 | 005034 | 005035 | 005036 | 005037 | 005038 | 005039 | 005040 | 005041 | 005042 | 005043 | 005044 | 005045 | 005046 | 005047 | 005048 | 005049 | 005050 | 005051 | 005052 | 005053 | 005054 | 005055 | 005056 | 005057 | 005058 | 005059 | 005060 | 005061 | 005062 | 005063 | 005064 | 005065 | 005066 | 005067 | 005068 | 005069 | 005070 | 005071 | 005072 | 005073 | 005074 | 005075 | 005076 | 005077 | 005078 | 005079 | 005080 | 005081 | 005082 | 005083 | 005084 | 005085 | 005086 | 005087 | 005088 | 005089 | 005090 | 005091 | 005092 | 005093 | 005094 | 005095 | 005096 | 005097 | 005098 | 005099 | 005100 | 005101 | 005102 | 005103 | 005104 | 005105 | 005106 | 005107 | 005108 | 005109 | 005110 | 005111 | 005112 | 005113 | 005114 | 005115 | 005116 | 005117 | 005118 | 005119 | 005120 )
            surah_number_without_leading_zeros="5"
	    ;;
	006000 | 006001 | 006002 | 006003 | 006004 | 006005 | 006006 | 006007 | 006008 | 006009 | 006010 | 006011 | 006012 | 006013 | 006014 | 006015 | 006016 | 006017 | 006018 | 006019 | 006020 | 006021 | 006022 | 006023 | 006024 | 006025 | 006026 | 006027 | 006028 | 006029 | 006030 | 006031 | 006032 | 006033 | 006034 | 006035 | 006036 | 006037 | 006038 | 006039 | 006040 | 006041 | 006042 | 006043 | 006044 | 006045 | 006046 | 006047 | 006048 | 006049 | 006050 | 006051 | 006052 | 006053 | 006054 | 006055 | 006056 | 006057 | 006058 | 006059 | 006060 | 006061 | 006062 | 006063 | 006064 | 006065 | 006066 | 006067 | 006068 | 006069 | 006070 | 006071 | 006072 | 006073 | 006074 | 006075 | 006076 | 006077 | 006078 | 006079 | 006080 | 006081 | 006082 | 006083 | 006084 | 006085 | 006086 | 006087 | 006088 | 006089 | 006090 | 006091 | 006092 | 006093 | 006094 | 006095 | 006096 | 006097 | 006098 | 006099 | 006100 | 006101 | 006102 | 006103 | 006104 | 006105 | 006106 | 006107 | 006108 | 006109 | 006110 | 006111 | 006112 | 006113 | 006114 | 006115 | 006116 | 006117 | 006118 | 006119 | 006120 | 006121 | 006122 | 006123 | 006124 | 006125 | 006126 | 006127 | 006128 | 006129 | 006130 | 006131 | 006132 | 006133 | 006134 | 006135 | 006136 | 006137 | 006138 | 006139 | 006140 | 006141 | 006142 | 006143 | 006144 | 006145 | 006146 | 006147 | 006148 | 006149 | 006150 | 006151 | 006152 | 006153 | 006154 | 006155 | 006156 | 006157 | 006158 | 006159 | 006160 | 006161 | 006162 | 006163 | 006164 | 006165 )
            surah_number_without_leading_zeros="6"
	    ;;
	007000 | 007001 | 007002 | 007003 | 007004 | 007005 | 007006 | 007007 | 007008 | 007009 | 007010 | 007011 | 007012 | 007013 | 007014 | 007015 | 007016 | 007017 | 007018 | 007019 | 007020 | 007021 | 007022 | 007023 | 007024 | 007025 | 007026 | 007027 | 007028 | 007029 | 007030 | 007031 | 007032 | 007033 | 007034 | 007035 | 007036 | 007037 | 007038 | 007039 | 007040 | 007041 | 007042 | 007043 | 007044 | 007045 | 007046 | 007047 | 007048 | 007049 | 007050 | 007051 | 007052 | 007053 | 007054 | 007055 | 007056 | 007057 | 007058 | 007059 | 007060 | 007061 | 007062 | 007063 | 007064 | 007065 | 007066 | 007067 | 007068 | 007069 | 007070 | 007071 | 007072 | 007073 | 007074 | 007075 | 007076 | 007077 | 007078 | 007079 | 007080 | 007081 | 007082 | 007083 | 007084 | 007085 | 007086 | 007087 | 007088 | 007089 | 007090 | 007091 | 007092 | 007093 | 007094 | 007095 | 007096 | 007097 | 007098 | 007099 | 007100 | 007101 | 007102 | 007103 | 007104 | 007105 | 007106 | 007107 | 007108 | 007109 | 007110 | 007111 | 007112 | 007113 | 007114 | 007115 | 007116 | 007117 | 007118 | 007119 | 007120 | 007121 | 007122 | 007123 | 007124 | 007125 | 007126 | 007127 | 007128 | 007129 | 007130 | 007131 | 007132 | 007133 | 007134 | 007135 | 007136 | 007137 | 007138 | 007139 | 007140 | 007141 | 007142 | 007143 | 007144 | 007145 | 007146 | 007147 | 007148 | 007149 | 007150 | 007151 | 007152 | 007153 | 007154 | 007155 | 007156 | 007157 | 007158 | 007159 | 007160 | 007161 | 007162 | 007163 | 007164 | 007165 | 007166 | 007167 | 007168 | 007169 | 007170 | 007171 | 007172 | 007173 | 007174 | 007175 | 007176 | 007177 | 007178 | 007179 | 007180 | 007181 | 007182 | 007183 | 007184 | 007185 | 007186 | 007187 | 007188 | 007189 | 007190 | 007191 | 007192 | 007193 | 007194 | 007195 | 007196 | 007197 | 007198 | 007199 | 007200 | 007201 | 007202 | 007203 | 007204 | 007205 | 007206 )
            surah_number_without_leading_zeros="7"
	    ;;
	008000 | 008001 | 008002 | 008003 | 008004 | 008005 | 008006 | 008007 | 008008 | 008009 | 008010 | 008011 | 008012 | 008013 | 008014 | 008015 | 008016 | 008017 | 008018 | 008019 | 008020 | 008021 | 008022 | 008023 | 008024 | 008025 | 008026 | 008027 | 008028 | 008029 | 008030 | 008031 | 008032 | 008033 | 008034 | 008035 | 008036 | 008037 | 008038 | 008039 | 008040 | 008041 | 008042 | 008043 | 008044 | 008045 | 008046 | 008047 | 008048 | 008049 | 008050 | 008051 | 008052 | 008053 | 008054 | 008055 | 008056 | 008057 | 008058 | 008059 | 008060 | 008061 | 008062 | 008063 | 008064 | 008065 | 008066 | 008067 | 008068 | 008069 | 008070 | 008071 | 008072 | 008073 | 008074 | 008075 )
            surah_number_without_leading_zeros="8"
	    ;;
	009000 | 009001 | 009002 | 009003 | 009004 | 009005 | 009006 | 009007 | 009008 | 009009 | 009010 | 009011 | 009012 | 009013 | 009014 | 009015 | 009016 | 009017 | 009018 | 009019 | 009020 | 009021 | 009022 | 009023 | 009024 | 009025 | 009026 | 009027 | 009028 | 009029 | 009030 | 009031 | 009032 | 009033 | 009034 | 009035 | 009036 | 009037 | 009038 | 009039 | 009040 | 009041 | 009042 | 009043 | 009044 | 009045 | 009046 | 009047 | 009048 | 009049 | 009050 | 009051 | 009052 | 009053 | 009054 | 009055 | 009056 | 009057 | 009058 | 009059 | 009060 | 009061 | 009062 | 009063 | 009064 | 009065 | 009066 | 009067 | 009068 | 009069 | 009070 | 009071 | 009072 | 009073 | 009074 | 009075 | 009076 | 009077 | 009078 | 009079 | 009080 | 009081 | 009082 | 009083 | 009084 | 009085 | 009086 | 009087 | 009088 | 009089 | 009090 | 009091 | 009092 | 009093 | 009094 | 009095 | 009096 | 009097 | 009098 | 009099 | 009100 | 009101 | 009102 | 009103 | 009104 | 009105 | 009106 | 009107 | 009108 | 009109 | 009110 | 009111 | 009112 | 009113 | 009114 | 009115 | 009116 | 009117 | 009118 | 009119 | 009120 | 009121 | 009122 | 009123 | 009124 | 009125 | 009126 | 009127 | 009128 | 009129 )
            surah_number_without_leading_zeros="9"
	    ;;
	010000 | 010001 | 010002 | 010003 | 010004 | 010005 | 010006 | 010007 | 010008 | 010009 | 010010 | 010011 | 010012 | 010013 | 010014 | 010015 | 010016 | 010017 | 010018 | 010019 | 010020 | 010021 | 010022 | 010023 | 010024 | 010025 | 010026 | 010027 | 010028 | 010029 | 010030 | 010031 | 010032 | 010033 | 010034 | 010035 | 010036 | 010037 | 010038 | 010039 | 010040 | 010041 | 010042 | 010043 | 010044 | 010045 | 010046 | 010047 | 010048 | 010049 | 010050 | 010051 | 010052 | 010053 | 010054 | 010055 | 010056 | 010057 | 010058 | 010059 | 010060 | 010061 | 010062 | 010063 | 010064 | 010065 | 010066 | 010067 | 010068 | 010069 | 010070 | 010071 | 010072 | 010073 | 010074 | 010075 | 010076 | 010077 | 010078 | 010079 | 010080 | 010081 | 010082 | 010083 | 010084 | 010085 | 010086 | 010087 | 010088 | 010089 | 010090 | 010091 | 010092 | 010093 | 010094 | 010095 | 010096 | 010097 | 010098 | 010099 | 010100 | 010101 | 010102 | 010103 | 010104 | 010105 | 010106 | 010107 | 010108 | 010109 )
            surah_number_without_leading_zeros="10"
	    ;;
	011000 | 011001 | 011002 | 011003 | 011004 | 011005 | 011006 | 011007 | 011008 | 011009 | 011010 | 011011 | 011012 | 011013 | 011014 | 011015 | 011016 | 011017 | 011018 | 011019 | 011020 | 011021 | 011022 | 011023 | 011024 | 011025 | 011026 | 011027 | 011028 | 011029 | 011030 | 011031 | 011032 | 011033 | 011034 | 011035 | 011036 | 011037 | 011038 | 011039 | 011040 | 011041 | 011042 | 011043 | 011044 | 011045 | 011046 | 011047 | 011048 | 011049 | 011050 | 011051 | 011052 | 011053 | 011054 | 011055 | 011056 | 011057 | 011058 | 011059 | 011060 | 011061 | 011062 | 011063 | 011064 | 011065 | 011066 | 011067 | 011068 | 011069 | 011070 | 011071 | 011072 | 011073 | 011074 | 011075 | 011076 | 011077 | 011078 | 011079 | 011080 | 011081 | 011082 | 011083 | 011084 | 011085 | 011086 | 011087 | 011088 | 011089 | 011090 | 011091 | 011092 | 011093 | 011094 | 011095 | 011096 | 011097 | 011098 | 011099 | 011100 | 011101 | 011102 | 011103 | 011104 | 011105 | 011106 | 011107 | 011108 | 011109 | 011110 | 011111 | 011112 | 011113 | 011114 | 011115 | 011116 | 011117 | 011118 | 011119 | 011120 | 011121 | 011122 | 011123 )
            surah_number_without_leading_zeros="11"
	    ;;
	012000 | 012001 | 012002 | 012003 | 012004 | 012005 | 012006 | 012007 | 012008 | 012009 | 012010 | 012011 | 012012 | 012013 | 012014 | 012015 | 012016 | 012017 | 012018 | 012019 | 012020 | 012021 | 012022 | 012023 | 012024 | 012025 | 012026 | 012027 | 012028 | 012029 | 012030 | 012031 | 012032 | 012033 | 012034 | 012035 | 012036 | 012037 | 012038 | 012039 | 012040 | 012041 | 012042 | 012043 | 012044 | 012045 | 012046 | 012047 | 012048 | 012049 | 012050 | 012051 | 012052 | 012053 | 012054 | 012055 | 012056 | 012057 | 012058 | 012059 | 012060 | 012061 | 012062 | 012063 | 012064 | 012065 | 012066 | 012067 | 012068 | 012069 | 012070 | 012071 | 012072 | 012073 | 012074 | 012075 | 012076 | 012077 | 012078 | 012079 | 012080 | 012081 | 012082 | 012083 | 012084 | 012085 | 012086 | 012087 | 012088 | 012089 | 012090 | 012091 | 012092 | 012093 | 012094 | 012095 | 012096 | 012097 | 012098 | 012099 | 012100 | 012101 | 012102 | 012103 | 012104 | 012105 | 012106 | 012107 | 012108 | 012109 | 012110 | 012111 )
            surah_number_without_leading_zeros="12"
	    ;;
	013000 | 013001 | 013002 | 013003 | 013004 | 013005 | 013006 | 013007 | 013008 | 013009 | 013010 | 013011 | 013012 | 013013 | 013014 | 013015 | 013016 | 013017 | 013018 | 013019 | 013020 | 013021 | 013022 | 013023 | 013024 | 013025 | 013026 | 013027 | 013028 | 013029 | 013030 | 013031 | 013032 | 013033 | 013034 | 013035 | 013036 | 013037 | 013038 | 013039 | 013040 | 013041 | 013042 | 013043 )
            surah_number_without_leading_zeros="13"
	    ;;
	014000 | 014001 | 014002 | 014003 | 014004 | 014005 | 014006 | 014007 | 014008 | 014009 | 014010 | 014011 | 014012 | 014013 | 014014 | 014015 | 014016 | 014017 | 014018 | 014019 | 014020 | 014021 | 014022 | 014023 | 014024 | 014025 | 014026 | 014027 | 014028 | 014029 | 014030 | 014031 | 014032 | 014033 | 014034 | 014035 | 014036 | 014037 | 014038 | 014039 | 014040 | 014041 | 014042 | 014043 | 014044 | 014045 | 014046 | 014047 | 014048 | 014049 | 014050 | 014051 | 014052 )
            surah_number_without_leading_zeros="14"
	    ;;
	015000 | 015001 | 015002 | 015003 | 015004 | 015005 | 015006 | 015007 | 015008 | 015009 | 015010 | 015011 | 015012 | 015013 | 015014 | 015015 | 015016 | 015017 | 015018 | 015019 | 015020 | 015021 | 015022 | 015023 | 015024 | 015025 | 015026 | 015027 | 015028 | 015029 | 015030 | 015031 | 015032 | 015033 | 015034 | 015035 | 015036 | 015037 | 015038 | 015039 | 015040 | 015041 | 015042 | 015043 | 015044 | 015045 | 015046 | 015047 | 015048 | 015049 | 015050 | 015051 | 015052 | 015053 | 015054 | 015055 | 015056 | 015057 | 015058 | 015059 | 015060 | 015061 | 015062 | 015063 | 015064 | 015065 | 015066 | 015067 | 015068 | 015069 | 015070 | 015071 | 015072 | 015073 | 015074 | 015075 | 015076 | 015077 | 015078 | 015079 | 015080 | 015081 | 015082 | 015083 | 015084 | 015085 | 015086 | 015087 | 015088 | 015089 | 015090 | 015091 | 015092 | 015093 | 015094 | 015095 | 015096 | 015097 | 015098 | 015099 )
            surah_number_without_leading_zeros="15"
	    ;;
	016000 | 016001 | 016002 | 016003 | 016004 | 016005 | 016006 | 016007 | 016008 | 016009 | 016010 | 016011 | 016012 | 016013 | 016014 | 016015 | 016016 | 016017 | 016018 | 016019 | 016020 | 016021 | 016022 | 016023 | 016024 | 016025 | 016026 | 016027 | 016028 | 016029 | 016030 | 016031 | 016032 | 016033 | 016034 | 016035 | 016036 | 016037 | 016038 | 016039 | 016040 | 016041 | 016042 | 016043 | 016044 | 016045 | 016046 | 016047 | 016048 | 016049 | 016050 | 016051 | 016052 | 016053 | 016054 | 016055 | 016056 | 016057 | 016058 | 016059 | 016060 | 016061 | 016062 | 016063 | 016064 | 016065 | 016066 | 016067 | 016068 | 016069 | 016070 | 016071 | 016072 | 016073 | 016074 | 016075 | 016076 | 016077 | 016078 | 016079 | 016080 | 016081 | 016082 | 016083 | 016084 | 016085 | 016086 | 016087 | 016088 | 016089 | 016090 | 016091 | 016092 | 016093 | 016094 | 016095 | 016096 | 016097 | 016098 | 016099 | 016100 | 016101 | 016102 | 016103 | 016104 | 016105 | 016106 | 016107 | 016108 | 016109 | 016110 | 016111 | 016112 | 016113 | 016114 | 016115 | 016116 | 016117 | 016118 | 016119 | 016120 | 016121 | 016122 | 016123 | 016124 | 016125 | 016126 | 016127 | 016128 )
            surah_number_without_leading_zeros="16"
	    ;;
	017000 | 017001 | 017002 | 017003 | 017004 | 017005 | 017006 | 017007 | 017008 | 017009 | 017010 | 017011 | 017012 | 017013 | 017014 | 017015 | 017016 | 017017 | 017018 | 017019 | 017020 | 017021 | 017022 | 017023 | 017024 | 017025 | 017026 | 017027 | 017028 | 017029 | 017030 | 017031 | 017032 | 017033 | 017034 | 017035 | 017036 | 017037 | 017038 | 017039 | 017040 | 017041 | 017042 | 017043 | 017044 | 017045 | 017046 | 017047 | 017048 | 017049 | 017050 | 017051 | 017052 | 017053 | 017054 | 017055 | 017056 | 017057 | 017058 | 017059 | 017060 | 017061 | 017062 | 017063 | 017064 | 017065 | 017066 | 017067 | 017068 | 017069 | 017070 | 017071 | 017072 | 017073 | 017074 | 017075 | 017076 | 017077 | 017078 | 017079 | 017080 | 017081 | 017082 | 017083 | 017084 | 017085 | 017086 | 017087 | 017088 | 017089 | 017090 | 017091 | 017092 | 017093 | 017094 | 017095 | 017096 | 017097 | 017098 | 017099 | 017100 | 017101 | 017102 | 017103 | 017104 | 017105 | 017106 | 017107 | 017108 | 017109 | 017110 | 017111 )
            surah_number_without_leading_zeros="17"
	    ;;
	018000 | 018001 | 018002 | 018003 | 018004 | 018005 | 018006 | 018007 | 018008 | 018009 | 018010 | 018011 | 018012 | 018013 | 018014 | 018015 | 018016 | 018017 | 018018 | 018019 | 018020 | 018021 | 018022 | 018023 | 018024 | 018025 | 018026 | 018027 | 018028 | 018029 | 018030 | 018031 | 018032 | 018033 | 018034 | 018035 | 018036 | 018037 | 018038 | 018039 | 018040 | 018041 | 018042 | 018043 | 018044 | 018045 | 018046 | 018047 | 018048 | 018049 | 018050 | 018051 | 018052 | 018053 | 018054 | 018055 | 018056 | 018057 | 018058 | 018059 | 018060 | 018061 | 018062 | 018063 | 018064 | 018065 | 018066 | 018067 | 018068 | 018069 | 018070 | 018071 | 018072 | 018073 | 018074 | 018075 | 018076 | 018077 | 018078 | 018079 | 018080 | 018081 | 018082 | 018083 | 018084 | 018085 | 018086 | 018087 | 018088 | 018089 | 018090 | 018091 | 018092 | 018093 | 018094 | 018095 | 018096 | 018097 | 018098 | 018099 | 018100 | 018101 | 018102 | 018103 | 018104 | 018105 | 018106 | 018107 | 018108 | 018109 | 018110 )
            surah_number_without_leading_zeros="18"
	    ;;
	019000 | 019001 | 019002 | 019003 | 019004 | 019005 | 019006 | 019007 | 019008 | 019009 | 019010 | 019011 | 019012 | 019013 | 019014 | 019015 | 019016 | 019017 | 019018 | 019019 | 019020 | 019021 | 019022 | 019023 | 019024 | 019025 | 019026 | 019027 | 019028 | 019029 | 019030 | 019031 | 019032 | 019033 | 019034 | 019035 | 019036 | 019037 | 019038 | 019039 | 019040 | 019041 | 019042 | 019043 | 019044 | 019045 | 019046 | 019047 | 019048 | 019049 | 019050 | 019051 | 019052 | 019053 | 019054 | 019055 | 019056 | 019057 | 019058 | 019059 | 019060 | 019061 | 019062 | 019063 | 019064 | 019065 | 019066 | 019067 | 019068 | 019069 | 019070 | 019071 | 019072 | 019073 | 019074 | 019075 | 019076 | 019077 | 019078 | 019079 | 019080 | 019081 | 019082 | 019083 | 019084 | 019085 | 019086 | 019087 | 019088 | 019089 | 019090 | 019091 | 019092 | 019093 | 019094 | 019095 | 019096 | 019097 | 019098 )
            surah_number_without_leading_zeros="19"
	    ;;
	020000 | 020001 | 020002 | 020003 | 020004 | 020005 | 020006 | 020007 | 020008 | 020009 | 020010 | 020011 | 020012 | 020013 | 020014 | 020015 | 020016 | 020017 | 020018 | 020019 | 020020 | 020021 | 020022 | 020023 | 020024 | 020025 | 020026 | 020027 | 020028 | 020029 | 020030 | 020031 | 020032 | 020033 | 020034 | 020035 | 020036 | 020037 | 020038 | 020039 | 020040 | 020041 | 020042 | 020043 | 020044 | 020045 | 020046 | 020047 | 020048 | 020049 | 020050 | 020051 | 020052 | 020053 | 020054 | 020055 | 020056 | 020057 | 020058 | 020059 | 020060 | 020061 | 020062 | 020063 | 020064 | 020065 | 020066 | 020067 | 020068 | 020069 | 020070 | 020071 | 020072 | 020073 | 020074 | 020075 | 020076 | 020077 | 020078 | 020079 | 020080 | 020081 | 020082 | 020083 | 020084 | 020085 | 020086 | 020087 | 020088 | 020089 | 020090 | 020091 | 020092 | 020093 | 020094 | 020095 | 020096 | 020097 | 020098 | 020099 | 020100 | 020101 | 020102 | 020103 | 020104 | 020105 | 020106 | 020107 | 020108 | 020109 | 020110 | 020111 | 020112 | 020113 | 020114 | 020115 | 020116 | 020117 | 020118 | 020119 | 020120 | 020121 | 020122 | 020123 | 020124 | 020125 | 020126 | 020127 | 020128 | 020129 | 020130 | 020131 | 020132 | 020133 | 020134 | 020135 )
            surah_number_without_leading_zeros="20"
	    ;;
	021000 | 021001 | 021002 | 021003 | 021004 | 021005 | 021006 | 021007 | 021008 | 021009 | 021010 | 021011 | 021012 | 021013 | 021014 | 021015 | 021016 | 021017 | 021018 | 021019 | 021020 | 021021 | 021022 | 021023 | 021024 | 021025 | 021026 | 021027 | 021028 | 021029 | 021030 | 021031 | 021032 | 021033 | 021034 | 021035 | 021036 | 021037 | 021038 | 021039 | 021040 | 021041 | 021042 | 021043 | 021044 | 021045 | 021046 | 021047 | 021048 | 021049 | 021050 | 021051 | 021052 | 021053 | 021054 | 021055 | 021056 | 021057 | 021058 | 021059 | 021060 | 021061 | 021062 | 021063 | 021064 | 021065 | 021066 | 021067 | 021068 | 021069 | 021070 | 021071 | 021072 | 021073 | 021074 | 021075 | 021076 | 021077 | 021078 | 021079 | 021080 | 021081 | 021082 | 021083 | 021084 | 021085 | 021086 | 021087 | 021088 | 021089 | 021090 | 021091 | 021092 | 021093 | 021094 | 021095 | 021096 | 021097 | 021098 | 021099 | 021100 | 021101 | 021102 | 021103 | 021104 | 021105 | 021106 | 021107 | 021108 | 021109 | 021110 | 021111 | 021112 )
            surah_number_without_leading_zeros="21"
	    ;;
	022000 | 022001 | 022002 | 022003 | 022004 | 022005 | 022006 | 022007 | 022008 | 022009 | 022010 | 022011 | 022012 | 022013 | 022014 | 022015 | 022016 | 022017 | 022018 | 022019 | 022020 | 022021 | 022022 | 022023 | 022024 | 022025 | 022026 | 022027 | 022028 | 022029 | 022030 | 022031 | 022032 | 022033 | 022034 | 022035 | 022036 | 022037 | 022038 | 022039 | 022040 | 022041 | 022042 | 022043 | 022044 | 022045 | 022046 | 022047 | 022048 | 022049 | 022050 | 022051 | 022052 | 022053 | 022054 | 022055 | 022056 | 022057 | 022058 | 022059 | 022060 | 022061 | 022062 | 022063 | 022064 | 022065 | 022066 | 022067 | 022068 | 022069 | 022070 | 022071 | 022072 | 022073 | 022074 | 022075 | 022076 | 022077 | 022078 )
            surah_number_without_leading_zeros="22"
	    ;;
	023000 | 023001 | 023002 | 023003 | 023004 | 023005 | 023006 | 023007 | 023008 | 023009 | 023010 | 023011 | 023012 | 023013 | 023014 | 023015 | 023016 | 023017 | 023018 | 023019 | 023020 | 023021 | 023022 | 023023 | 023024 | 023025 | 023026 | 023027 | 023028 | 023029 | 023030 | 023031 | 023032 | 023033 | 023034 | 023035 | 023036 | 023037 | 023038 | 023039 | 023040 | 023041 | 023042 | 023043 | 023044 | 023045 | 023046 | 023047 | 023048 | 023049 | 023050 | 023051 | 023052 | 023053 | 023054 | 023055 | 023056 | 023057 | 023058 | 023059 | 023060 | 023061 | 023062 | 023063 | 023064 | 023065 | 023066 | 023067 | 023068 | 023069 | 023070 | 023071 | 023072 | 023073 | 023074 | 023075 | 023076 | 023077 | 023078 | 023079 | 023080 | 023081 | 023082 | 023083 | 023084 | 023085 | 023086 | 023087 | 023088 | 023089 | 023090 | 023091 | 023092 | 023093 | 023094 | 023095 | 023096 | 023097 | 023098 | 023099 | 023100 | 023101 | 023102 | 023103 | 023104 | 023105 | 023106 | 023107 | 023108 | 023109 | 023110 | 023111 | 023112 | 023113 | 023114 | 023115 | 023116 | 023117 | 023118 )
            surah_number_without_leading_zeros="23"
	    ;;
	024000 | 024001 | 024002 | 024003 | 024004 | 024005 | 024006 | 024007 | 024008 | 024009 | 024010 | 024011 | 024012 | 024013 | 024014 | 024015 | 024016 | 024017 | 024018 | 024019 | 024020 | 024021 | 024022 | 024023 | 024024 | 024025 | 024026 | 024027 | 024028 | 024029 | 024030 | 024031 | 024032 | 024033 | 024034 | 024035 | 024036 | 024037 | 024038 | 024039 | 024040 | 024041 | 024042 | 024043 | 024044 | 024045 | 024046 | 024047 | 024048 | 024049 | 024050 | 024051 | 024052 | 024053 | 024054 | 024055 | 024056 | 024057 | 024058 | 024059 | 024060 | 024061 | 024062 | 024063 | 024064 )
            surah_number_without_leading_zeros="24"
	    ;;
	025000 | 025001 | 025002 | 025003 | 025004 | 025005 | 025006 | 025007 | 025008 | 025009 | 025010 | 025011 | 025012 | 025013 | 025014 | 025015 | 025016 | 025017 | 025018 | 025019 | 025020 | 025021 | 025022 | 025023 | 025024 | 025025 | 025026 | 025027 | 025028 | 025029 | 025030 | 025031 | 025032 | 025033 | 025034 | 025035 | 025036 | 025037 | 025038 | 025039 | 025040 | 025041 | 025042 | 025043 | 025044 | 025045 | 025046 | 025047 | 025048 | 025049 | 025050 | 025051 | 025052 | 025053 | 025054 | 025055 | 025056 | 025057 | 025058 | 025059 | 025060 | 025061 | 025062 | 025063 | 025064 | 025065 | 025066 | 025067 | 025068 | 025069 | 025070 | 025071 | 025072 | 025073 | 025074 | 025075 | 025076 | 025077 )
            surah_number_without_leading_zeros="25"
	    ;;
	026000 | 026001 | 026002 | 026003 | 026004 | 026005 | 026006 | 026007 | 026008 | 026009 | 026010 | 026011 | 026012 | 026013 | 026014 | 026015 | 026016 | 026017 | 026018 | 026019 | 026020 | 026021 | 026022 | 026023 | 026024 | 026025 | 026026 | 026027 | 026028 | 026029 | 026030 | 026031 | 026032 | 026033 | 026034 | 026035 | 026036 | 026037 | 026038 | 026039 | 026040 | 026041 | 026042 | 026043 | 026044 | 026045 | 026046 | 026047 | 026048 | 026049 | 026050 | 026051 | 026052 | 026053 | 026054 | 026055 | 026056 | 026057 | 026058 | 026059 | 026060 | 026061 | 026062 | 026063 | 026064 | 026065 | 026066 | 026067 | 026068 | 026069 | 026070 | 026071 | 026072 | 026073 | 026074 | 026075 | 026076 | 026077 | 026078 | 026079 | 026080 | 026081 | 026082 | 026083 | 026084 | 026085 | 026086 | 026087 | 026088 | 026089 | 026090 | 026091 | 026092 | 026093 | 026094 | 026095 | 026096 | 026097 | 026098 | 026099 | 026100 | 026101 | 026102 | 026103 | 026104 | 026105 | 026106 | 026107 | 026108 | 026109 | 026110 | 026111 | 026112 | 026113 | 026114 | 026115 | 026116 | 026117 | 026118 | 026119 | 026120 | 026121 | 026122 | 026123 | 026124 | 026125 | 026126 | 026127 | 026128 | 026129 | 026130 | 026131 | 026132 | 026133 | 026134 | 026135 | 026136 | 026137 | 026138 | 026139 | 026140 | 026141 | 026142 | 026143 | 026144 | 026145 | 026146 | 026147 | 026148 | 026149 | 026150 | 026151 | 026152 | 026153 | 026154 | 026155 | 026156 | 026157 | 026158 | 026159 | 026160 | 026161 | 026162 | 026163 | 026164 | 026165 | 026166 | 026167 | 026168 | 026169 | 026170 | 026171 | 026172 | 026173 | 026174 | 026175 | 026176 | 026177 | 026178 | 026179 | 026180 | 026181 | 026182 | 026183 | 026184 | 026185 | 026186 | 026187 | 026188 | 026189 | 026190 | 026191 | 026192 | 026193 | 026194 | 026195 | 026196 | 026197 | 026198 | 026199 | 026200 | 026201 | 026202 | 026203 | 026204 | 026205 | 026206 | 026207 | 026208 | 026209 | 026210 | 026211 | 026212 | 026213 | 026214 | 026215 | 026216 | 026217 | 026218 | 026219 | 026220 | 026221 | 026222 | 026223 | 026224 | 026225 | 026226 | 026227 )
            surah_number_without_leading_zeros="26"
	    ;;
	027000 | 027001 | 027002 | 027003 | 027004 | 027005 | 027006 | 027007 | 027008 | 027009 | 027010 | 027011 | 027012 | 027013 | 027014 | 027015 | 027016 | 027017 | 027018 | 027019 | 027020 | 027021 | 027022 | 027023 | 027024 | 027025 | 027026 | 027027 | 027028 | 027029 | 027030 | 027031 | 027032 | 027033 | 027034 | 027035 | 027036 | 027037 | 027038 | 027039 | 027040 | 027041 | 027042 | 027043 | 027044 | 027045 | 027046 | 027047 | 027048 | 027049 | 027050 | 027051 | 027052 | 027053 | 027054 | 027055 | 027056 | 027057 | 027058 | 027059 | 027060 | 027061 | 027062 | 027063 | 027064 | 027065 | 027066 | 027067 | 027068 | 027069 | 027070 | 027071 | 027072 | 027073 | 027074 | 027075 | 027076 | 027077 | 027078 | 027079 | 027080 | 027081 | 027082 | 027083 | 027084 | 027085 | 027086 | 027087 | 027088 | 027089 | 027090 | 027091 | 027092 | 027093 )
            surah_number_without_leading_zeros="27"
	    ;;
	028000 | 028001 | 028002 | 028003 | 028004 | 028005 | 028006 | 028007 | 028008 | 028009 | 028010 | 028011 | 028012 | 028013 | 028014 | 028015 | 028016 | 028017 | 028018 | 028019 | 028020 | 028021 | 028022 | 028023 | 028024 | 028025 | 028026 | 028027 | 028028 | 028029 | 028030 | 028031 | 028032 | 028033 | 028034 | 028035 | 028036 | 028037 | 028038 | 028039 | 028040 | 028041 | 028042 | 028043 | 028044 | 028045 | 028046 | 028047 | 028048 | 028049 | 028050 | 028051 | 028052 | 028053 | 028054 | 028055 | 028056 | 028057 | 028058 | 028059 | 028060 | 028061 | 028062 | 028063 | 028064 | 028065 | 028066 | 028067 | 028068 | 028069 | 028070 | 028071 | 028072 | 028073 | 028074 | 028075 | 028076 | 028077 | 028078 | 028079 | 028080 | 028081 | 028082 | 028083 | 028084 | 028085 | 028086 | 028087 | 028088 )
            surah_number_without_leading_zeros="28"
	    ;;
	029000 | 029001 | 029002 | 029003 | 029004 | 029005 | 029006 | 029007 | 029008 | 029009 | 029010 | 029011 | 029012 | 029013 | 029014 | 029015 | 029016 | 029017 | 029018 | 029019 | 029020 | 029021 | 029022 | 029023 | 029024 | 029025 | 029026 | 029027 | 029028 | 029029 | 029030 | 029031 | 029032 | 029033 | 029034 | 029035 | 029036 | 029037 | 029038 | 029039 | 029040 | 029041 | 029042 | 029043 | 029044 | 029045 | 029046 | 029047 | 029048 | 029049 | 029050 | 029051 | 029052 | 029053 | 029054 | 029055 | 029056 | 029057 | 029058 | 029059 | 029060 | 029061 | 029062 | 029063 | 029064 | 029065 | 029066 | 029067 | 029068 | 029069 )
            surah_number_without_leading_zeros="29"
	    ;;
	030000 | 030001 | 030002 | 030003 | 030004 | 030005 | 030006 | 030007 | 030008 | 030009 | 030010 | 030011 | 030012 | 030013 | 030014 | 030015 | 030016 | 030017 | 030018 | 030019 | 030020 | 030021 | 030022 | 030023 | 030024 | 030025 | 030026 | 030027 | 030028 | 030029 | 030030 | 030031 | 030032 | 030033 | 030034 | 030035 | 030036 | 030037 | 030038 | 030039 | 030040 | 030041 | 030042 | 030043 | 030044 | 030045 | 030046 | 030047 | 030048 | 030049 | 030050 | 030051 | 030052 | 030053 | 030054 | 030055 | 030056 | 030057 | 030058 | 030059 | 030060 )
            surah_number_without_leading_zeros="30"
	    ;;
	031000 | 031001 | 031002 | 031003 | 031004 | 031005 | 031006 | 031007 | 031008 | 031009 | 031010 | 031011 | 031012 | 031013 | 031014 | 031015 | 031016 | 031017 | 031018 | 031019 | 031020 | 031021 | 031022 | 031023 | 031024 | 031025 | 031026 | 031027 | 031028 | 031029 | 031030 | 031031 | 031032 | 031033 | 031034 )
            surah_number_without_leading_zeros="31"
	    ;;
	032000 | 032001 | 032002 | 032003 | 032004 | 032005 | 032006 | 032007 | 032008 | 032009 | 032010 | 032011 | 032012 | 032013 | 032014 | 032015 | 032016 | 032017 | 032018 | 032019 | 032020 | 032021 | 032022 | 032023 | 032024 | 032025 | 032026 | 032027 | 032028 | 032029 | 032030 )
            surah_number_without_leading_zeros="32"
	    ;;
	033000 | 033001 | 033002 | 033003 | 033004 | 033005 | 033006 | 033007 | 033008 | 033009 | 033010 | 033011 | 033012 | 033013 | 033014 | 033015 | 033016 | 033017 | 033018 | 033019 | 033020 | 033021 | 033022 | 033023 | 033024 | 033025 | 033026 | 033027 | 033028 | 033029 | 033030 | 033031 | 033032 | 033033 | 033034 | 033035 | 033036 | 033037 | 033038 | 033039 | 033040 | 033041 | 033042 | 033043 | 033044 | 033045 | 033046 | 033047 | 033048 | 033049 | 033050 | 033051 | 033052 | 033053 | 033054 | 033055 | 033056 | 033057 | 033058 | 033059 | 033060 | 033061 | 033062 | 033063 | 033064 | 033065 | 033066 | 033067 | 033068 | 033069 | 033070 | 033071 | 033072 | 033073 )
            surah_number_without_leading_zeros="33"
	    ;;
	034000 | 034001 | 034002 | 034003 | 034004 | 034005 | 034006 | 034007 | 034008 | 034009 | 034010 | 034011 | 034012 | 034013 | 034014 | 034015 | 034016 | 034017 | 034018 | 034019 | 034020 | 034021 | 034022 | 034023 | 034024 | 034025 | 034026 | 034027 | 034028 | 034029 | 034030 | 034031 | 034032 | 034033 | 034034 | 034035 | 034036 | 034037 | 034038 | 034039 | 034040 | 034041 | 034042 | 034043 | 034044 | 034045 | 034046 | 034047 | 034048 | 034049 | 034050 | 034051 | 034052 | 034053 | 034054 )
            surah_number_without_leading_zeros="34"
	    ;;
	035000 | 035001 | 035002 | 035003 | 035004 | 035005 | 035006 | 035007 | 035008 | 035009 | 035010 | 035011 | 035012 | 035013 | 035014 | 035015 | 035016 | 035017 | 035018 | 035019 | 035020 | 035021 | 035022 | 035023 | 035024 | 035025 | 035026 | 035027 | 035028 | 035029 | 035030 | 035031 | 035032 | 035033 | 035034 | 035035 | 035036 | 035037 | 035038 | 035039 | 035040 | 035041 | 035042 | 035043 | 035044 | 035045 )
            surah_number_without_leading_zeros="35"
	    ;;
	036000 | 036001 | 036002 | 036003 | 036004 | 036005 | 036006 | 036007 | 036008 | 036009 | 036010 | 036011 | 036012 | 036013 | 036014 | 036015 | 036016 | 036017 | 036018 | 036019 | 036020 | 036021 | 036022 | 036023 | 036024 | 036025 | 036026 | 036027 | 036028 | 036029 | 036030 | 036031 | 036032 | 036033 | 036034 | 036035 | 036036 | 036037 | 036038 | 036039 | 036040 | 036041 | 036042 | 036043 | 036044 | 036045 | 036046 | 036047 | 036048 | 036049 | 036050 | 036051 | 036052 | 036053 | 036054 | 036055 | 036056 | 036057 | 036058 | 036059 | 036060 | 036061 | 036062 | 036063 | 036064 | 036065 | 036066 | 036067 | 036068 | 036069 | 036070 | 036071 | 036072 | 036073 | 036074 | 036075 | 036076 | 036077 | 036078 | 036079 | 036080 | 036081 | 036082 | 036083 )
            surah_number_without_leading_zeros="36"
	    ;;
	037000 | 037001 | 037002 | 037003 | 037004 | 037005 | 037006 | 037007 | 037008 | 037009 | 037010 | 037011 | 037012 | 037013 | 037014 | 037015 | 037016 | 037017 | 037018 | 037019 | 037020 | 037021 | 037022 | 037023 | 037024 | 037025 | 037026 | 037027 | 037028 | 037029 | 037030 | 037031 | 037032 | 037033 | 037034 | 037035 | 037036 | 037037 | 037038 | 037039 | 037040 | 037041 | 037042 | 037043 | 037044 | 037045 | 037046 | 037047 | 037048 | 037049 | 037050 | 037051 | 037052 | 037053 | 037054 | 037055 | 037056 | 037057 | 037058 | 037059 | 037060 | 037061 | 037062 | 037063 | 037064 | 037065 | 037066 | 037067 | 037068 | 037069 | 037070 | 037071 | 037072 | 037073 | 037074 | 037075 | 037076 | 037077 | 037078 | 037079 | 037080 | 037081 | 037082 | 037083 | 037084 | 037085 | 037086 | 037087 | 037088 | 037089 | 037090 | 037091 | 037092 | 037093 | 037094 | 037095 | 037096 | 037097 | 037098 | 037099 | 037100 | 037101 | 037102 | 037103 | 037104 | 037105 | 037106 | 037107 | 037108 | 037109 | 037110 | 037111 | 037112 | 037113 | 037114 | 037115 | 037116 | 037117 | 037118 | 037119 | 037120 | 037121 | 037122 | 037123 | 037124 | 037125 | 037126 | 037127 | 037128 | 037129 | 037130 | 037131 | 037132 | 037133 | 037134 | 037135 | 037136 | 037137 | 037138 | 037139 | 037140 | 037141 | 037142 | 037143 | 037144 | 037145 | 037146 | 037147 | 037148 | 037149 | 037150 | 037151 | 037152 | 037153 | 037154 | 037155 | 037156 | 037157 | 037158 | 037159 | 037160 | 037161 | 037162 | 037163 | 037164 | 037165 | 037166 | 037167 | 037168 | 037169 | 037170 | 037171 | 037172 | 037173 | 037174 | 037175 | 037176 | 037177 | 037178 | 037179 | 037180 | 037181 | 037182 )
            surah_number_without_leading_zeros="37"
	    ;;
	038000 | 038001 | 038002 | 038003 | 038004 | 038005 | 038006 | 038007 | 038008 | 038009 | 038010 | 038011 | 038012 | 038013 | 038014 | 038015 | 038016 | 038017 | 038018 | 038019 | 038020 | 038021 | 038022 | 038023 | 038024 | 038025 | 038026 | 038027 | 038028 | 038029 | 038030 | 038031 | 038032 | 038033 | 038034 | 038035 | 038036 | 038037 | 038038 | 038039 | 038040 | 038041 | 038042 | 038043 | 038044 | 038045 | 038046 | 038047 | 038048 | 038049 | 038050 | 038051 | 038052 | 038053 | 038054 | 038055 | 038056 | 038057 | 038058 | 038059 | 038060 | 038061 | 038062 | 038063 | 038064 | 038065 | 038066 | 038067 | 038068 | 038069 | 038070 | 038071 | 038072 | 038073 | 038074 | 038075 | 038076 | 038077 | 038078 | 038079 | 038080 | 038081 | 038082 | 038083 | 038084 | 038085 | 038086 | 038087 | 038088 )
            surah_number_without_leading_zeros="38"
	    ;;
	039000 | 039001 | 039002 | 039003 | 039004 | 039005 | 039006 | 039007 | 039008 | 039009 | 039010 | 039011 | 039012 | 039013 | 039014 | 039015 | 039016 | 039017 | 039018 | 039019 | 039020 | 039021 | 039022 | 039023 | 039024 | 039025 | 039026 | 039027 | 039028 | 039029 | 039030 | 039031 | 039032 | 039033 | 039034 | 039035 | 039036 | 039037 | 039038 | 039039 | 039040 | 039041 | 039042 | 039043 | 039044 | 039045 | 039046 | 039047 | 039048 | 039049 | 039050 | 039051 | 039052 | 039053 | 039054 | 039055 | 039056 | 039057 | 039058 | 039059 | 039060 | 039061 | 039062 | 039063 | 039064 | 039065 | 039066 | 039067 | 039068 | 039069 | 039070 | 039071 | 039072 | 039073 | 039074 | 039075 )
            surah_number_without_leading_zeros="39"
	    ;;
	040000 | 040001 | 040002 | 040003 | 040004 | 040005 | 040006 | 040007 | 040008 | 040009 | 040010 | 040011 | 040012 | 040013 | 040014 | 040015 | 040016 | 040017 | 040018 | 040019 | 040020 | 040021 | 040022 | 040023 | 040024 | 040025 | 040026 | 040027 | 040028 | 040029 | 040030 | 040031 | 040032 | 040033 | 040034 | 040035 | 040036 | 040037 | 040038 | 040039 | 040040 | 040041 | 040042 | 040043 | 040044 | 040045 | 040046 | 040047 | 040048 | 040049 | 040050 | 040051 | 040052 | 040053 | 040054 | 040055 | 040056 | 040057 | 040058 | 040059 | 040060 | 040061 | 040062 | 040063 | 040064 | 040065 | 040066 | 040067 | 040068 | 040069 | 040070 | 040071 | 040072 | 040073 | 040074 | 040075 | 040076 | 040077 | 040078 | 040079 | 040080 | 040081 | 040082 | 040083 | 040084 | 040085 )
            surah_number_without_leading_zeros="40"
	    ;;
	041000 | 041001 | 041002 | 041003 | 041004 | 041005 | 041006 | 041007 | 041008 | 041009 | 041010 | 041011 | 041012 | 041013 | 041014 | 041015 | 041016 | 041017 | 041018 | 041019 | 041020 | 041021 | 041022 | 041023 | 041024 | 041025 | 041026 | 041027 | 041028 | 041029 | 041030 | 041031 | 041032 | 041033 | 041034 | 041035 | 041036 | 041037 | 041038 | 041039 | 041040 | 041041 | 041042 | 041043 | 041044 | 041045 | 041046 | 041047 | 041048 | 041049 | 041050 | 041051 | 041052 | 041053 | 041054 )
            surah_number_without_leading_zeros="41"
	    ;;
	042000 | 042001 | 042002 | 042003 | 042004 | 042005 | 042006 | 042007 | 042008 | 042009 | 042010 | 042011 | 042012 | 042013 | 042014 | 042015 | 042016 | 042017 | 042018 | 042019 | 042020 | 042021 | 042022 | 042023 | 042024 | 042025 | 042026 | 042027 | 042028 | 042029 | 042030 | 042031 | 042032 | 042033 | 042034 | 042035 | 042036 | 042037 | 042038 | 042039 | 042040 | 042041 | 042042 | 042043 | 042044 | 042045 | 042046 | 042047 | 042048 | 042049 | 042050 | 042051 | 042052 | 042053 )
            surah_number_without_leading_zeros="42"
	    ;;
	043000 | 043001 | 043002 | 043003 | 043004 | 043005 | 043006 | 043007 | 043008 | 043009 | 043010 | 043011 | 043012 | 043013 | 043014 | 043015 | 043016 | 043017 | 043018 | 043019 | 043020 | 043021 | 043022 | 043023 | 043024 | 043025 | 043026 | 043027 | 043028 | 043029 | 043030 | 043031 | 043032 | 043033 | 043034 | 043035 | 043036 | 043037 | 043038 | 043039 | 043040 | 043041 | 043042 | 043043 | 043044 | 043045 | 043046 | 043047 | 043048 | 043049 | 043050 | 043051 | 043052 | 043053 | 043054 | 043055 | 043056 | 043057 | 043058 | 043059 | 043060 | 043061 | 043062 | 043063 | 043064 | 043065 | 043066 | 043067 | 043068 | 043069 | 043070 | 043071 | 043072 | 043073 | 043074 | 043075 | 043076 | 043077 | 043078 | 043079 | 043080 | 043081 | 043082 | 043083 | 043084 | 043085 | 043086 | 043087 | 043088 | 043089 )
            surah_number_without_leading_zeros="43"
	    ;;
	044000 | 044001 | 044002 | 044003 | 044004 | 044005 | 044006 | 044007 | 044008 | 044009 | 044010 | 044011 | 044012 | 044013 | 044014 | 044015 | 044016 | 044017 | 044018 | 044019 | 044020 | 044021 | 044022 | 044023 | 044024 | 044025 | 044026 | 044027 | 044028 | 044029 | 044030 | 044031 | 044032 | 044033 | 044034 | 044035 | 044036 | 044037 | 044038 | 044039 | 044040 | 044041 | 044042 | 044043 | 044044 | 044045 | 044046 | 044047 | 044048 | 044049 | 044050 | 044051 | 044052 | 044053 | 044054 | 044055 | 044056 | 044057 | 044058 | 044059 )
            surah_number_without_leading_zeros="44"
	    ;;
	045000 | 045001 | 045002 | 045003 | 045004 | 045005 | 045006 | 045007 | 045008 | 045009 | 045010 | 045011 | 045012 | 045013 | 045014 | 045015 | 045016 | 045017 | 045018 | 045019 | 045020 | 045021 | 045022 | 045023 | 045024 | 045025 | 045026 | 045027 | 045028 | 045029 | 045030 | 045031 | 045032 | 045033 | 045034 | 045035 | 045036 | 045037 )
            surah_number_without_leading_zeros="45"
	    ;;
	046000 | 046001 | 046002 | 046003 | 046004 | 046005 | 046006 | 046007 | 046008 | 046009 | 046010 | 046011 | 046012 | 046013 | 046014 | 046015 | 046016 | 046017 | 046018 | 046019 | 046020 | 046021 | 046022 | 046023 | 046024 | 046025 | 046026 | 046027 | 046028 | 046029 | 046030 | 046031 | 046032 | 046033 | 046034 | 046035 )
            surah_number_without_leading_zeros="46"
	    ;;
	047000 | 047001 | 047002 | 047003 | 047004 | 047005 | 047006 | 047007 | 047008 | 047009 | 047010 | 047011 | 047012 | 047013 | 047014 | 047015 | 047016 | 047017 | 047018 | 047019 | 047020 | 047021 | 047022 | 047023 | 047024 | 047025 | 047026 | 047027 | 047028 | 047029 | 047030 | 047031 | 047032 | 047033 | 047034 | 047035 | 047036 | 047037 | 047038 )
            surah_number_without_leading_zeros="47"
	    ;;
	048000 | 048001 | 048002 | 048003 | 048004 | 048005 | 048006 | 048007 | 048008 | 048009 | 048010 | 048011 | 048012 | 048013 | 048014 | 048015 | 048016 | 048017 | 048018 | 048019 | 048020 | 048021 | 048022 | 048023 | 048024 | 048025 | 048026 | 048027 | 048028 | 048029 )
            surah_number_without_leading_zeros="48"
	    ;;
	049000 | 049001 | 049002 | 049003 | 049004 | 049005 | 049006 | 049007 | 049008 | 049009 | 049010 | 049011 | 049012 | 049013 | 049014 | 049015 | 049016 | 049017 | 049018 )
            surah_number_without_leading_zeros="49"
	    ;;
	050000 | 050001 | 050002 | 050003 | 050004 | 050005 | 050006 | 050007 | 050008 | 050009 | 050010 | 050011 | 050012 | 050013 | 050014 | 050015 | 050016 | 050017 | 050018 | 050019 | 050020 | 050021 | 050022 | 050023 | 050024 | 050025 | 050026 | 050027 | 050028 | 050029 | 050030 | 050031 | 050032 | 050033 | 050034 | 050035 | 050036 | 050037 | 050038 | 050039 | 050040 | 050041 | 050042 | 050043 | 050044 | 050045 )
            surah_number_without_leading_zeros="50"
	    ;;
	051000 | 051001 | 051002 | 051003 | 051004 | 051005 | 051006 | 051007 | 051008 | 051009 | 051010 | 051011 | 051012 | 051013 | 051014 | 051015 | 051016 | 051017 | 051018 | 051019 | 051020 | 051021 | 051022 | 051023 | 051024 | 051025 | 051026 | 051027 | 051028 | 051029 | 051030 | 051031 | 051032 | 051033 | 051034 | 051035 | 051036 | 051037 | 051038 | 051039 | 051040 | 051041 | 051042 | 051043 | 051044 | 051045 | 051046 | 051047 | 051048 | 051049 | 051050 | 051051 | 051052 | 051053 | 051054 | 051055 | 051056 | 051057 | 051058 | 051059 | 051060 )
            surah_number_without_leading_zeros="51"
	    ;;
	052000 | 052001 | 052002 | 052003 | 052004 | 052005 | 052006 | 052007 | 052008 | 052009 | 052010 | 052011 | 052012 | 052013 | 052014 | 052015 | 052016 | 052017 | 052018 | 052019 | 052020 | 052021 | 052022 | 052023 | 052024 | 052025 | 052026 | 052027 | 052028 | 052029 | 052030 | 052031 | 052032 | 052033 | 052034 | 052035 | 052036 | 052037 | 052038 | 052039 | 052040 | 052041 | 052042 | 052043 | 052044 | 052045 | 052046 | 052047 | 052048 | 052049 )
            surah_number_without_leading_zeros="52"
	    ;;
	053000 | 053001 | 053002 | 053003 | 053004 | 053005 | 053006 | 053007 | 053008 | 053009 | 053010 | 053011 | 053012 | 053013 | 053014 | 053015 | 053016 | 053017 | 053018 | 053019 | 053020 | 053021 | 053022 | 053023 | 053024 | 053025 | 053026 | 053027 | 053028 | 053029 | 053030 | 053031 | 053032 | 053033 | 053034 | 053035 | 053036 | 053037 | 053038 | 053039 | 053040 | 053041 | 053042 | 053043 | 053044 | 053045 | 053046 | 053047 | 053048 | 053049 | 053050 | 053051 | 053052 | 053053 | 053054 | 053055 | 053056 | 053057 | 053058 | 053059 | 053060 | 053061 | 053062 )
            surah_number_without_leading_zeros="53"
	    ;;
	054000 | 054001 | 054002 | 054003 | 054004 | 054005 | 054006 | 054007 | 054008 | 054009 | 054010 | 054011 | 054012 | 054013 | 054014 | 054015 | 054016 | 054017 | 054018 | 054019 | 054020 | 054021 | 054022 | 054023 | 054024 | 054025 | 054026 | 054027 | 054028 | 054029 | 054030 | 054031 | 054032 | 054033 | 054034 | 054035 | 054036 | 054037 | 054038 | 054039 | 054040 | 054041 | 054042 | 054043 | 054044 | 054045 | 054046 | 054047 | 054048 | 054049 | 054050 | 054051 | 054052 | 054053 | 054054 | 054055 )
            surah_number_without_leading_zeros="54"
	    ;;
	055000 | 055001 | 055002 | 055003 | 055004 | 055005 | 055006 | 055007 | 055008 | 055009 | 055010 | 055011 | 055012 | 055013 | 055014 | 055015 | 055016 | 055017 | 055018 | 055019 | 055020 | 055021 | 055022 | 055023 | 055024 | 055025 | 055026 | 055027 | 055028 | 055029 | 055030 | 055031 | 055032 | 055033 | 055034 | 055035 | 055036 | 055037 | 055038 | 055039 | 055040 | 055041 | 055042 | 055043 | 055044 | 055045 | 055046 | 055047 | 055048 | 055049 | 055050 | 055051 | 055052 | 055053 | 055054 | 055055 | 055056 | 055057 | 055058 | 055059 | 055060 | 055061 | 055062 | 055063 | 055064 | 055065 | 055066 | 055067 | 055068 | 055069 | 055070 | 055071 | 055072 | 055073 | 055074 | 055075 | 055076 | 055077 | 055078 )
            surah_number_without_leading_zeros="55"
	    ;;
	056000 | 056001 | 056002 | 056003 | 056004 | 056005 | 056006 | 056007 | 056008 | 056009 | 056010 | 056011 | 056012 | 056013 | 056014 | 056015 | 056016 | 056017 | 056018 | 056019 | 056020 | 056021 | 056022 | 056023 | 056024 | 056025 | 056026 | 056027 | 056028 | 056029 | 056030 | 056031 | 056032 | 056033 | 056034 | 056035 | 056036 | 056037 | 056038 | 056039 | 056040 | 056041 | 056042 | 056043 | 056044 | 056045 | 056046 | 056047 | 056048 | 056049 | 056050 | 056051 | 056052 | 056053 | 056054 | 056055 | 056056 | 056057 | 056058 | 056059 | 056060 | 056061 | 056062 | 056063 | 056064 | 056065 | 056066 | 056067 | 056068 | 056069 | 056070 | 056071 | 056072 | 056073 | 056074 | 056075 | 056076 | 056077 | 056078 | 056079 | 056080 | 056081 | 056082 | 056083 | 056084 | 056085 | 056086 | 056087 | 056088 | 056089 | 056090 | 056091 | 056092 | 056093 | 056094 | 056095 | 056096 )
            surah_number_without_leading_zeros="56"
	    ;;
	057000 | 057001 | 057002 | 057003 | 057004 | 057005 | 057006 | 057007 | 057008 | 057009 | 057010 | 057011 | 057012 | 057013 | 057014 | 057015 | 057016 | 057017 | 057018 | 057019 | 057020 | 057021 | 057022 | 057023 | 057024 | 057025 | 057026 | 057027 | 057028 | 057029 )
            surah_number_without_leading_zeros="57"
	    ;;
	058000 | 058001 | 058002 | 058003 | 058004 | 058005 | 058006 | 058007 | 058008 | 058009 | 058010 | 058011 | 058012 | 058013 | 058014 | 058015 | 058016 | 058017 | 058018 | 058019 | 058020 | 058021 | 058022 )
            surah_number_without_leading_zeros="58"
	    ;;
	059000 | 059001 | 059002 | 059003 | 059004 | 059005 | 059006 | 059007 | 059008 | 059009 | 059010 | 059011 | 059012 | 059013 | 059014 | 059015 | 059016 | 059017 | 059018 | 059019 | 059020 | 059021 | 059022 | 059023 | 059024 )
            surah_number_without_leading_zeros="59"
	    ;;
	060000 | 060001 | 060002 | 060003 | 060004 | 060005 | 060006 | 060007 | 060008 | 060009 | 060010 | 060011 | 060012 | 060013 )
            surah_number_without_leading_zeros="60"
	    ;;
	061000 | 061001 | 061002 | 061003 | 061004 | 061005 | 061006 | 061007 | 061008 | 061009 | 061010 | 061011 | 061012 | 061013 | 061014 )
            surah_number_without_leading_zeros="61"
	    ;;
	062000 | 062001 | 062002 | 062003 | 062004 | 062005 | 062006 | 062007 | 062008 | 062009 | 062010 | 062011 )
            surah_number_without_leading_zeros="62"
	    ;;
	063000 | 063001 | 063002 | 063003 | 063004 | 063005 | 063006 | 063007 | 063008 | 063009 | 063010 | 063011 )
            surah_number_without_leading_zeros="63"
	    ;;
	064000 | 064001 | 064002 | 064003 | 064004 | 064005 | 064006 | 064007 | 064008 | 064009 | 064010 | 064011 | 064012 | 064013 | 064014 | 064015 | 064016 | 064017 | 064018 )
            surah_number_without_leading_zeros="64"
	    ;;
	065000 | 065001 | 065002 | 065003 | 065004 | 065005 | 065006 | 065007 | 065008 | 065009 | 065010 | 065011 | 065012 )
            surah_number_without_leading_zeros="65"
	    ;;
	066000 | 066001 | 066002 | 066003 | 066004 | 066005 | 066006 | 066007 | 066008 | 066009 | 066010 | 066011 | 066012 )
            surah_number_without_leading_zeros="66"
	    ;;
	067000 | 067001 | 067002 | 067003 | 067004 | 067005 | 067006 | 067007 | 067008 | 067009 | 067010 | 067011 | 067012 | 067013 | 067014 | 067015 | 067016 | 067017 | 067018 | 067019 | 067020 | 067021 | 067022 | 067023 | 067024 | 067025 | 067026 | 067027 | 067028 | 067029 | 067030 )
            surah_number_without_leading_zeros="67"
	    ;;
	068000 | 068001 | 068002 | 068003 | 068004 | 068005 | 068006 | 068007 | 068008 | 068009 | 068010 | 068011 | 068012 | 068013 | 068014 | 068015 | 068016 | 068017 | 068018 | 068019 | 068020 | 068021 | 068022 | 068023 | 068024 | 068025 | 068026 | 068027 | 068028 | 068029 | 068030 | 068031 | 068032 | 068033 | 068034 | 068035 | 068036 | 068037 | 068038 | 068039 | 068040 | 068041 | 068042 | 068043 | 068044 | 068045 | 068046 | 068047 | 068048 | 068049 | 068050 | 068051 | 068052 )
            surah_number_without_leading_zeros="68"
	    ;;
	069000 | 069001 | 069002 | 069003 | 069004 | 069005 | 069006 | 069007 | 069008 | 069009 | 069010 | 069011 | 069012 | 069013 | 069014 | 069015 | 069016 | 069017 | 069018 | 069019 | 069020 | 069021 | 069022 | 069023 | 069024 | 069025 | 069026 | 069027 | 069028 | 069029 | 069030 | 069031 | 069032 | 069033 | 069034 | 069035 | 069036 | 069037 | 069038 | 069039 | 069040 | 069041 | 069042 | 069043 | 069044 | 069045 | 069046 | 069047 | 069048 | 069049 | 069050 | 069051 | 069052 )
            surah_number_without_leading_zeros="69"
	    ;;
	070000 | 070001 | 070002 | 070003 | 070004 | 070005 | 070006 | 070007 | 070008 | 070009 | 070010 | 070011 | 070012 | 070013 | 070014 | 070015 | 070016 | 070017 | 070018 | 070019 | 070020 | 070021 | 070022 | 070023 | 070024 | 070025 | 070026 | 070027 | 070028 | 070029 | 070030 | 070031 | 070032 | 070033 | 070034 | 070035 | 070036 | 070037 | 070038 | 070039 | 070040 | 070041 | 070042 | 070043 | 070044 )
            surah_number_without_leading_zeros="70"
	    ;;
	071000 | 071001 | 071002 | 071003 | 071004 | 071005 | 071006 | 071007 | 071008 | 071009 | 071010 | 071011 | 071012 | 071013 | 071014 | 071015 | 071016 | 071017 | 071018 | 071019 | 071020 | 071021 | 071022 | 071023 | 071024 | 071025 | 071026 | 071027 | 071028 )
            surah_number_without_leading_zeros="71"
	    ;;
	072000 | 072001 | 072002 | 072003 | 072004 | 072005 | 072006 | 072007 | 072008 | 072009 | 072010 | 072011 | 072012 | 072013 | 072014 | 072015 | 072016 | 072017 | 072018 | 072019 | 072020 | 072021 | 072022 | 072023 | 072024 | 072025 | 072026 | 072027 | 072028 )
            surah_number_without_leading_zeros="72"
	    ;;
	073000 | 073001 | 073002 | 073003 | 073004 | 073005 | 073006 | 073007 | 073008 | 073009 | 073010 | 073011 | 073012 | 073013 | 073014 | 073015 | 073016 | 073017 | 073018 | 073019 | 073020 )
            surah_number_without_leading_zeros="73"
	    ;;
	074000 | 074001 | 074002 | 074003 | 074004 | 074005 | 074006 | 074007 | 074008 | 074009 | 074010 | 074011 | 074012 | 074013 | 074014 | 074015 | 074016 | 074017 | 074018 | 074019 | 074020 | 074021 | 074022 | 074023 | 074024 | 074025 | 074026 | 074027 | 074028 | 074029 | 074030 | 074031 | 074032 | 074033 | 074034 | 074035 | 074036 | 074037 | 074038 | 074039 | 074040 | 074041 | 074042 | 074043 | 074044 | 074045 | 074046 | 074047 | 074048 | 074049 | 074050 | 074051 | 074052 | 074053 | 074054 | 074055 | 074056 )
            surah_number_without_leading_zeros="74"
	    ;;
	075000 | 075001 | 075002 | 075003 | 075004 | 075005 | 075006 | 075007 | 075008 | 075009 | 075010 | 075011 | 075012 | 075013 | 075014 | 075015 | 075016 | 075017 | 075018 | 075019 | 075020 | 075021 | 075022 | 075023 | 075024 | 075025 | 075026 | 075027 | 075028 | 075029 | 075030 | 075031 | 075032 | 075033 | 075034 | 075035 | 075036 | 075037 | 075038 | 075039 | 075040 )
            surah_number_without_leading_zeros="75"
	    ;;
	076000 | 076001 | 076002 | 076003 | 076004 | 076005 | 076006 | 076007 | 076008 | 076009 | 076010 | 076011 | 076012 | 076013 | 076014 | 076015 | 076016 | 076017 | 076018 | 076019 | 076020 | 076021 | 076022 | 076023 | 076024 | 076025 | 076026 | 076027 | 076028 | 076029 | 076030 | 076031 )
            surah_number_without_leading_zeros="76"
	    ;;
	077000 | 077001 | 077002 | 077003 | 077004 | 077005 | 077006 | 077007 | 077008 | 077009 | 077010 | 077011 | 077012 | 077013 | 077014 | 077015 | 077016 | 077017 | 077018 | 077019 | 077020 | 077021 | 077022 | 077023 | 077024 | 077025 | 077026 | 077027 | 077028 | 077029 | 077030 | 077031 | 077032 | 077033 | 077034 | 077035 | 077036 | 077037 | 077038 | 077039 | 077040 | 077041 | 077042 | 077043 | 077044 | 077045 | 077046 | 077047 | 077048 | 077049 | 077050 )
            surah_number_without_leading_zeros="77"
	    ;;
	078000 | 078001 | 078002 | 078003 | 078004 | 078005 | 078006 | 078007 | 078008 | 078009 | 078010 | 078011 | 078012 | 078013 | 078014 | 078015 | 078016 | 078017 | 078018 | 078019 | 078020 | 078021 | 078022 | 078023 | 078024 | 078025 | 078026 | 078027 | 078028 | 078029 | 078030 | 078031 | 078032 | 078033 | 078034 | 078035 | 078036 | 078037 | 078038 | 078039 | 078040 )
            surah_number_without_leading_zeros="78"
	    ;;
	079000 | 079001 | 079002 | 079003 | 079004 | 079005 | 079006 | 079007 | 079008 | 079009 | 079010 | 079011 | 079012 | 079013 | 079014 | 079015 | 079016 | 079017 | 079018 | 079019 | 079020 | 079021 | 079022 | 079023 | 079024 | 079025 | 079026 | 079027 | 079028 | 079029 | 079030 | 079031 | 079032 | 079033 | 079034 | 079035 | 079036 | 079037 | 079038 | 079039 | 079040 | 079041 | 079042 | 079043 | 079044 | 079045 | 079046 )
            surah_number_without_leading_zeros="79"
	    ;;
	080000 | 080001 | 080002 | 080003 | 080004 | 080005 | 080006 | 080007 | 080008 | 080009 | 080010 | 080011 | 080012 | 080013 | 080014 | 080015 | 080016 | 080017 | 080018 | 080019 | 080020 | 080021 | 080022 | 080023 | 080024 | 080025 | 080026 | 080027 | 080028 | 080029 | 080030 | 080031 | 080032 | 080033 | 080034 | 080035 | 080036 | 080037 | 080038 | 080039 | 080040 | 080041 | 080042 )
            surah_number_without_leading_zeros="80"
	    ;;
	081000 | 081001 | 081002 | 081003 | 081004 | 081005 | 081006 | 081007 | 081008 | 081009 | 081010 | 081011 | 081012 | 081013 | 081014 | 081015 | 081016 | 081017 | 081018 | 081019 | 081020 | 081021 | 081022 | 081023 | 081024 | 081025 | 081026 | 081027 | 081028 | 081029 )
            surah_number_without_leading_zeros="81"
	    ;;
	082000 | 082001 | 082002 | 082003 | 082004 | 082005 | 082006 | 082007 | 082008 | 082009 | 082010 | 082011 | 082012 | 082013 | 082014 | 082015 | 082016 | 082017 | 082018 | 082019 )
            surah_number_without_leading_zeros="82"
	    ;;
	083000 | 083001 | 083002 | 083003 | 083004 | 083005 | 083006 | 083007 | 083008 | 083009 | 083010 | 083011 | 083012 | 083013 | 083014 | 083015 | 083016 | 083017 | 083018 | 083019 | 083020 | 083021 | 083022 | 083023 | 083024 | 083025 | 083026 | 083027 | 083028 | 083029 | 083030 | 083031 | 083032 | 083033 | 083034 | 083035 | 083036 )
            surah_number_without_leading_zeros="83"
	    ;;
	084000 | 084001 | 084002 | 084003 | 084004 | 084005 | 084006 | 084007 | 084008 | 084009 | 084010 | 084011 | 084012 | 084013 | 084014 | 084015 | 084016 | 084017 | 084018 | 084019 | 084020 | 084021 | 084022 | 084023 | 084024 | 084025 )
            surah_number_without_leading_zeros="84"
	    ;;
	085000 | 085001 | 085002 | 085003 | 085004 | 085005 | 085006 | 085007 | 085008 | 085009 | 085010 | 085011 | 085012 | 085013 | 085014 | 085015 | 085016 | 085017 | 085018 | 085019 | 085020 | 085021 | 085022 )
            surah_number_without_leading_zeros="85"
	    ;;
	086000 | 086001 | 086002 | 086003 | 086004 | 086005 | 086006 | 086007 | 086008 | 086009 | 086010 | 086011 | 086012 | 086013 | 086014 | 086015 | 086016 | 086017 )
            surah_number_without_leading_zeros="86"
	    ;;
	087000 | 087001 | 087002 | 087003 | 087004 | 087005 | 087006 | 087007 | 087008 | 087009 | 087010 | 087011 | 087012 | 087013 | 087014 | 087015 | 087016 | 087017 | 087018 | 087019 )
            surah_number_without_leading_zeros="87"
	    ;;
	088000 | 088001 | 088002 | 088003 | 088004 | 088005 | 088006 | 088007 | 088008 | 088009 | 088010 | 088011 | 088012 | 088013 | 088014 | 088015 | 088016 | 088017 | 088018 | 088019 | 088020 | 088021 | 088022 | 088023 | 088024 | 088025 | 088026 )
            surah_number_without_leading_zeros="88"
	    ;;
	089000 | 089001 | 089002 | 089003 | 089004 | 089005 | 089006 | 089007 | 089008 | 089009 | 089010 | 089011 | 089012 | 089013 | 089014 | 089015 | 089016 | 089017 | 089018 | 089019 | 089020 | 089021 | 089022 | 089023 | 089024 | 089025 | 089026 | 089027 | 089028 | 089029 | 089030 )
            surah_number_without_leading_zeros="89"
	    ;;
	090000 | 090001 | 090002 | 090003 | 090004 | 090005 | 090006 | 090007 | 090008 | 090009 | 090010 | 090011 | 090012 | 090013 | 090014 | 090015 | 090016 | 090017 | 090018 | 090019 | 090020 )
            surah_number_without_leading_zeros="90"
	    ;;
	091000 | 091001 | 091002 | 091003 | 091004 | 091005 | 091006 | 091007 | 091008 | 091009 | 091010 | 091011 | 091012 | 091013 | 091014 | 091015 )
            surah_number_without_leading_zeros="91"
	    ;;
	092000 | 092001 | 092002 | 092003 | 092004 | 092005 | 092006 | 092007 | 092008 | 092009 | 092010 | 092011 | 092012 | 092013 | 092014 | 092015 | 092016 | 092017 | 092018 | 092019 | 092020 | 092021 )
            surah_number_without_leading_zeros="92"
	    ;;
	093000 | 093001 | 093002 | 093003 | 093004 | 093005 | 093006 | 093007 | 093008 | 093009 | 093010 | 093011 )
            surah_number_without_leading_zeros="93"
	    ;;
	094000 | 094001 | 094002 | 094003 | 094004 | 094005 | 094006 | 094007 | 094008 )
            surah_number_without_leading_zeros="94"
	    ;;
	095000 | 095001 | 095002 | 095003 | 095004 | 095005 | 095006 | 095007 | 095008 )
            surah_number_without_leading_zeros="95"
	    ;;
	096000 | 096001 | 096002 | 096003 | 096004 | 096005 | 096006 | 096007 | 096008 | 096009 | 096010 | 096011 | 096012 | 096013 | 096014 | 096015 | 096016 | 096017 | 096018 | 096019 )
            surah_number_without_leading_zeros="96"
	    ;;
	097000 | 097001 | 097002 | 097003 | 097004 | 097005 )
            surah_number_without_leading_zeros="97"
	    ;;
	098000 | 098001 | 098002 | 098003 | 098004 | 098005 | 098006 | 098007 | 098008 )
            surah_number_without_leading_zeros="98"
	    ;;
	099000 | 099001 | 099002 | 099003 | 099004 | 099005 | 099006 | 099007 | 099008 )
            surah_number_without_leading_zeros="99"
	    ;;
	100000 | 100001 | 100002 | 100003 | 100004 | 100005 | 100006 | 100007 | 100008 | 100009 | 100010 | 100011 )
            surah_number_without_leading_zeros="100"
	    ;;
	101000 | 101001 | 101002 | 101003 | 101004 | 101005 | 101006 | 101007 | 101008 | 101009 | 101010 | 101011 )
            surah_number_without_leading_zeros="101"
	    ;;
	102000 | 102001 | 102002 | 102003 | 102004 | 102005 | 102006 | 102007 | 102008 )
            surah_number_without_leading_zeros="102"
	    ;;
	103000 | 103001 | 103002 | 103003 )
            surah_number_without_leading_zeros="103"
	    ;;
	104000 | 104001 | 104002 | 104003 | 104004 | 104005 | 104006 | 104007 | 104008 | 104009 )
            surah_number_without_leading_zeros="104"
	    ;;
	105000 | 105001 | 105002 | 105003 | 105004 | 105005 )
            surah_number_without_leading_zeros="105"
	    ;;
	106000 | 106001 | 106002 | 106003 | 106004 )
            surah_number_without_leading_zeros="106"
	    ;;
	107000 | 107001 | 107002 | 107003 | 107004 | 107005 | 107006 | 107007 )
            surah_number_without_leading_zeros="107"
	    ;;
	108000 | 108001 | 108002 | 108003 )
            surah_number_without_leading_zeros="108"
	    ;;
	109000 | 109001 | 109002 | 109003 | 109004 | 109005 | 109006 )
            surah_number_without_leading_zeros="109"
	    ;;
	110000 | 110001 | 110002 | 110003 )
            surah_number_without_leading_zeros="110"
	    ;;
	111000 | 111001 | 111002 | 111003 | 111004 | 111005 )
            surah_number_without_leading_zeros="111"
	    ;;
	112000 | 112001 | 112002 | 112003 | 112004 )
            surah_number_without_leading_zeros="112"
	    ;;
	113000 | 113001 | 113002 | 113003 | 113004 | 113005 )
            surah_number_without_leading_zeros="113"
	    ;;
	114000 | 114001 | 114002 | 114003 | 114004 | 114005 | 114006 )
            surah_number_without_leading_zeros="114"
	    ;;
	* )
    esac
}


get-number-of-ayaat-of-the-surah-to-which-this-ayah-belongs(){
    local ayah_id="$1"

    # get the number of the Sūrah
    # to which this ayah belongs to.
    # This function will put for us
    # the Sūrah number in the var:
    # "$surah_number_without_leading_zeros"
    show_surah_number_without_leading_zeros "$ayah_id"

    # Now, that we know the Sūrah
    # let's fetch its number of ayaat
    # The value will be stored in
    # ${ayaat_list_of_given_surah[*]}"
    # and this is an array. To get the
    # number of ayaat of the Sūrah, we
    # simply retrieve the number of
    # elements of the array.
    give_surah_ayats_list "$surah_number_without_leading_zeros"

    number_of_verses_of_surah="${#ayaat_list_of_given_surah[*]}"
}


##### Set of functions that give the #####
##### list of verses of various units #####
show_list_of_verses_that_belong_to_this_rub_ul_hizb(){
    local file="$1"
    case "$file" in
	1 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 001001 001002 001003 001004 001005 001006 001007 002001 002002 002003 002004 002005 002006 002007 002008 002009 002010 002011 002012 002013 002014 002015 002016 002017 002018 002019 002020 002021 002022 002023 002024 002025 )
	    ;;
	2 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 002026 002027 002028 002029 002030 002031 002032 002033 002034 002035 002036 002037 002038 002039 002040 002041 002042 002043 )
	    ;;
	3 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 002044 002045 002046 002047 002048 002049 002050 002051 002052 002053 002054 002055 002056 002057 002058 002059 )
	    ;;
	4 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 002060 002061 002062 002063 002064 002065 002066 002067 002068 002069 002070 002071 002072 002073 002074 )
	    ;;
	5 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 002075 002076 002077 002078 002079 002080 002081 002082 002083 002084 002085 002086 002087 002088 002089 002090 002091 )
	    ;;
	6 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 002092 002093 002094 002095 002096 002097 002098 002099 002100 002101 002102 002103 002104 002105 )
	    ;;
	7 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 002106 002107 002108 002109 002110 002111 002112 002113 002114 002115 002116 002117 002118 002119 002120 002121 002122 002123 )
	    ;;
	8 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 002124 002125 002126 002127 002128 002129 002130 002131 002132 002133 002134 002135 002136 002137 002138 002139 002140 002141 )
	    ;;
	9 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 002142 002143 002144 002145 002146 002147 002148 002149 002150 002151 002152 002153 002154 002155 002156 002157 )
	    ;;
	10 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 002158 002159 002160 002161 002162 002163 002164 002165 002166 002167 002168 002169 002170 002171 002172 002173 002174 002175 002176 )
	    ;;
	11 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 002177 002178 002179 002180 002181 002182 002183 002184 002185 002186 002187 002188 )
	    ;;
	12 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 002189 002190 002191 002192 002193 002194 002195 002196 002197 002198 002199 002200 002201 002202 )
	    ;;
	13 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 002203 002204 002205 002206 002207 002208 002209 002210 002211 002212 002213 002214 002215 002216 002217 002218 )
	    ;;
	14 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 002219 002220 002221 002222 002223 002224 002225 002226 002227 002228 002229 002230 002231 002232 )
	    ;;
	15 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 002233 002234 002235 002236 002237 002238 002239 002240 002241 002242 )
	    ;;
	16 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 002243 002244 002245 002246 002247 002248 002249 002250 002251 002252 )
	    ;;
	17 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 002253 002254 002255 002256 002257 002258 002259 002260 002261 002262 )
	    ;;
	18 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 002263 002264 002265 002266 002267 002268 002269 002270 002271 )
	    ;;
	19 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 002272 002273 002274 002275 002276 002277 002278 002279 002280 002281 002282 )
	    ;;
	20 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 002283 002284 002285 002286 003001 003002 003003 003004 003005 003006 003007 003008 003009 003010 003011 003012 003013 003014 )
	    ;;
	21 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 003015 003016 003017 003018 003019 003020 003021 003022 003023 003024 003025 003026 003027 003028 003029 003030 003031 003032 )
	    ;;
	22 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 003033 003034 003035 003036 003037 003038 003039 003040 003041 003042 003043 003044 003045 003046 003047 003048 003049 003050 003051 )
	    ;;
	23 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 003052 003053 003054 003055 003056 003057 003058 003059 003060 003061 003062 003063 003064 003065 003066 003067 003068 003069 003070 003071 003072 003073 003074 )
	    ;;
	24 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 003075 003076 003077 003078 003079 003080 003081 003082 003083 003084 003085 003086 003087 003088 003089 003090 003091 003092 )
	    ;;
	25 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 003093 003094 003095 003096 003097 003098 003099 003100 003101 003102 003103 003104 003105 003106 003107 003108 003109 003110 003111 003112 )
	    ;;
	26 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 003113 003114 003115 003116 003117 003118 003119 003120 003121 003122 003123 003124 003125 003126 003127 003128 003129 003130 003131 003132 )
	    ;;
	27 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 003133 003134 003135 003136 003137 003138 003139 003140 003141 003142 003143 003144 003145 003146 003147 003148 003149 003150 003151 003152 )
	    ;;
	28 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 003153 003154 003155 003156 003157 003158 003159 003160 003161 003162 003163 003164 003165 003166 003167 003168 003169 003170 )
	    ;;
	29 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 003171 003172 003173 003174 003175 003176 003177 003178 003179 003180 003181 003182 003183 003184 003185 )
	    ;;
	30 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 003186 003187 003188 003189 003190 003191 003192 003193 003194 003195 003196 003197 003198 003199 003200 )
	    ;;
	31 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 004001 004002 004003 004004 004005 004006 004007 004008 004009 004010 004011 )
	    ;;
	32 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 004012 004013 004014 004015 004016 004017 004018 004019 004020 004021 004022 004023 )
	    ;;
	33 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 004024 004025 004026 004027 004028 004029 004030 004031 004032 004033 004034 004035 )
	    ;;
	34 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 004036 004037 004038 004039 004040 004041 004042 004043 004044 004045 004046 004047 004048 004049 004050 004051 004052 004053 004054 004055 004056 004057 )
	    ;;
	35 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 004058 004059 004060 004061 004062 004063 004064 004065 004066 004067 004068 004069 004070 004071 004072 004073 )
	    ;;
	36 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 004074 004075 004076 004077 004078 004079 004080 004081 004082 004083 004084 004085 004086 004087 )
	    ;;
	37 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 004088 004089 004090 004091 004092 004093 004094 004095 004096 004097 004098 004099 )
	    ;;
	38 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 004100 004101 004102 004103 004104 004105 004106 004107 004108 004109 004110 004111 004112 004113 )
	    ;;
	39 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 004114 004115 004116 004117 004118 004119 004120 004121 004122 004123 004124 004125 004126 004127 004128 004129 004130 004131 004132 004133 004134 )
	    ;;
	40 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 004135 004136 004137 004138 004139 004140 004141 004142 004143 004144 004145 004146 004147 )
	    ;;
	41 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 004148 004149 004150 004151 004152 004153 004154 004155 004156 004157 004158 004159 004160 004161 004162 )
	    ;;
	42 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 004163 004164 004165 004166 004167 004168 004169 004170 004171 004172 004173 004174 004175 004176 )
	    ;;
	43 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 005001 005002 005003 005004 005005 005006 005007 005008 005009 005010 005011 )
	    ;;
	44 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 005012 005013 005014 005015 005016 005017 005018 005019 005020 005021 005022 005023 005024 005025 005026 )
	    ;;
	45 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 005027 005028 005029 005030 005031 005032 005033 005034 005035 005036 005037 005038 005039 005040 )
	    ;;
	46 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 005041 005042 005043 005044 005045 005046 005047 005048 005049 005050 )
	    ;;
	47 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 005051 005052 005053 005054 005055 005056 005057 005058 005059 005060 005061 005062 005063 005064 005065 005066 )
	    ;;
	48 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 005067 005068 005069 005070 005071 005072 005073 005074 005075 005076 005077 005078 005079 005080 005081 )
	    ;;
	49 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 005082 005083 005084 005085 005086 005087 005088 005089 005090 005091 005092 005093 005094 005095 005096 )
	    ;;
	50 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 005097 005098 005099 005100 005101 005102 005103 005104 005105 005106 005107 005108 )
	    ;;
	51 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 005109 005110 005111 005112 005113 005114 005115 005116 005117 005118 005119 005120 006001 006002 006003 006004 006005 006006 006007 006008 006009 006010 006011 006012 )
	    ;;
	52 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 006013 006014 006015 006016 006017 006018 006019 006020 006021 006022 006023 006024 006025 006026 006027 006028 006029 006030 006031 006032 006033 006034 006035 )
	    ;;
	53 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 006036 006037 006038 006039 006040 006041 006042 006043 006044 006045 006046 006047 006048 006049 006050 006051 006052 006053 006054 006055 006056 006057 006058 )
	    ;;
	54 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 006059 006060 006061 006062 006063 006064 006065 006066 006067 006068 006069 006070 006071 006072 006073 )
	    ;;
	55 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 006074 006075 006076 006077 006078 006079 006080 006081 006082 006083 006084 006085 006086 006087 006088 006089 006090 006091 006092 006093 006094 )
	    ;;
	56 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 006095 006096 006097 006098 006099 006100 006101 006102 006103 006104 006105 006106 006107 006108 006109 006110 )
	    ;;
	57 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 006111 006112 006113 006114 006115 006116 006117 006118 006119 006120 006121 006122 006123 006124 006125 006126 )
	    ;;
	58 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 006127 006128 006129 006130 006131 006132 006133 006134 006135 006136 006137 006138 006139 006140 )
	    ;;
	59 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 006141 006142 006143 006144 006145 006146 006147 006148 006149 006150 )
	    ;;
	60 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 006151 006152 006153 006154 006155 006156 006157 006158 006159 006160 006161 006162 006163 006164 006165 )
	    ;;
	61 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 007001 007002 007003 007004 007005 007006 007007 007008 007009 007010 007011 007012 007013 007014 007015 007016 007017 007018 007019 007020 007021 007022 007023 007024 007025 007026 007027 007028 007029 007030 )
	    ;;
	62 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 007031 007032 007033 007034 007035 007036 007037 007038 007039 007040 007041 007042 007043 007044 007045 007046 )
	    ;;
	63 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 007047 007048 007049 007050 007051 007052 007053 007054 007055 007056 007057 007058 007059 007060 007061 007062 007063 007064 )
	    ;;
	64 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 007065 007066 007067 007068 007069 007070 007071 007072 007073 007074 007075 007076 007077 007078 007079 007080 007081 007082 007083 007084 007085 007086 007087 )
	    ;;
	65 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 007088 007089 007090 007091 007092 007093 007094 007095 007096 007097 007098 007099 007100 007101 007102 007103 007104 007105 007106 007107 007108 007109 007110 007111 007112 007113 007114 007115 007116 )
	    ;;
	66 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 007117 007118 007119 007120 007121 007122 007123 007124 007125 007126 007127 007128 007129 007130 007131 007132 007133 007134 007135 007136 007137 007138 007139 007140 007141 )
	    ;;
	67 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 007142 007143 007144 007145 007146 007147 007148 007149 007150 007151 007152 007153 007154 007155 )
	    ;;
	68 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 007156 007157 007158 007159 007160 007161 007162 007163 007164 007165 007166 007167 007168 007169 007170 )
	    ;;
	69 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 007171 007172 007173 007174 007175 007176 007177 007178 007179 007180 007181 007182 007183 007184 007185 007186 007187 007188 )
	    ;;
	70 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 007189 007190 007191 007192 007193 007194 007195 007196 007197 007198 007199 007200 007201 007202 007203 007204 007205 007206 )
	    ;;
	71 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 008001 008002 008003 008004 008005 008006 008007 008008 008009 008010 008011 008012 008013 008014 008015 008016 008017 008018 008019 008020 008021 )
	    ;;
	72 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 008022 008023 008024 008025 008026 008027 008028 008029 008030 008031 008032 008033 008034 008035 008036 008037 008038 008039 008040 )
	    ;;
	73 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 008041 008042 008043 008044 008045 008046 008047 008048 008049 008050 008051 008052 008053 008054 008055 008056 008057 008058 008059 008060 )
	    ;;
	74 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 008061 008062 008063 008064 008065 008066 008067 008068 008069 008070 008071 008072 008073 008074 008075 )
	    ;;
	75 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 009001 009002 009003 009004 009005 009006 009007 009008 009009 009010 009011 009012 009013 009014 009015 009016 009017 009018 )
	    ;;
	76 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 009019 009020 009021 009022 009023 009024 009025 009026 009027 009028 009029 009030 009031 009032 009033 )
	    ;;
	77 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 009034 009035 009036 009037 009038 009039 009040 009041 009042 009043 009044 009045 )
	    ;;
	78 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 009046 009047 009048 009049 009050 009051 009052 009053 009054 009055 009056 009057 009058 009059 )
	    ;;
	79 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 009060 009061 009062 009063 009064 009065 009066 009067 009068 009069 009070 009071 009072 009073 009074 )
	    ;;
	80 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 009075 009076 009077 009078 009079 009080 009081 009082 009083 009084 009085 009086 009087 009088 009089 009090 009091 009092 )
	    ;;
	81 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 009093 009094 009095 009096 009097 009098 009099 009100 009101 009102 009103 009104 009105 009106 009107 009108 009109 009110 )
	    ;;
	83 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 009122 009123 009124 009125 009126 009127 009128 009129 010001 010002 010003 010004 010005 010006 010007 010008 010009 010010 )
	    ;;
	84 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 010011 010012 010013 010014 010015 010016 010017 010018 010019 010020 010021 010022 010023 010024 010025 )
	    ;;
	82 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 009111 009112 009113 009114 009115 009116 009117 009118 009119 009120 009121 )
	    ;;
	85 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 010026 010027 010028 010029 010030 010031 010032 010033 010034 010035 010036 010037 010038 010039 010040 010041 010042 010043 010044 010045 010046 010047 010048 010049 010050 010051 010052 )
	    ;;
	86 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 010053 010054 010055 010056 010057 010058 010059 010060 010061 010062 010063 010064 010065 010066 010067 010068 010069 010070 )
	    ;;
	87 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 010071 010072 010073 010074 010075 010076 010077 010078 010079 010080 010081 010082 010083 010084 010085 010086 010087 010088 010089 )
	    ;;
	88 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 010090 010091 010092 010093 010094 010095 010096 010097 010098 010099 010100 010101 010102 010103 010104 010105 010106 010107 010108 010109 011001 011002 011003 011004 011005 )
	    ;;
	89 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 011006 011007 011008 011009 011010 011011 011012 011013 011014 011015 011016 011017 011018 011019 011020 011021 011022 011023 )
	    ;;
	90 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 011024 011025 011026 011027 011028 011029 011030 011031 011032 011033 011034 011035 011036 011037 011038 011039 011040 )
	    ;;
	91 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 011041 011042 011043 011044 011045 011046 011047 011048 011049 011050 011051 011052 011053 011054 011055 011056 011057 011058 011059 011060 )
	    ;;
	92 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 011061 011062 011063 011064 011065 011066 011067 011068 011069 011070 011071 011072 011073 011074 011075 011076 011077 011078 011079 011080 011081 011082 011083 )
	    ;;
	93 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 011084 011085 011086 011087 011088 011089 011090 011091 011092 011093 011094 011095 011096 011097 011098 011099 011100 011101 011102 011103 011104 011105 011106 011107 )
	    ;;
	94 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 011108 011109 011110 011111 011112 011113 011114 011115 011116 011117 011118 011119 011120 011121 011122 011123 012001 012002 012003 012004 012005 012006 )
	    ;;
	95 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 012007 012008 012009 012010 012011 012012 012013 012014 012015 012016 012017 012018 012019 012020 012021 012022 012023 012024 012025 012026 012027 012028 012029 )
	    ;;
	96 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 012030 012031 012032 012033 012034 012035 012036 012037 012038 012039 012040 012041 012042 012043 012044 012045 012046 012047 012048 012049 012050 012051 012052 )
	    ;;
	97 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 012053 012054 012055 012056 012057 012058 012059 012060 012061 012062 012063 012064 012065 012066 012067 012068 012069 012070 012071 012072 012073 012074 012075 012076 )
	    ;;
	98 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 012077 012078 012079 012080 012081 012082 012083 012084 012085 012086 012087 012088 012089 012090 012091 012092 012093 012094 012095 012096 012097 012098 012099 012100 )
	    ;;
	99 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 012101 012102 012103 012104 012105 012106 012107 012108 012109 012110 012111 013001 013002 013003 013004 )
	    ;;
	100 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 013005 013006 013007 013008 013009 013010 013011 013012 013013 013014 013015 013016 013017 013018 )
	    ;;
	101 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 013019 013020 013021 013022 013023 013024 013025 013026 013027 013028 013029 013030 013031 013032 013033 013034 )
	    ;;
	102 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 013035 013036 013037 013038 013039 013040 013041 013042 013043 014001 014002 014003 014004 014005 014006 014007 014008 014009 )
	    ;;
	103 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 014010 014011 014012 014013 014014 014015 014016 014017 014018 014019 014020 014021 014022 014023 014024 014025 014026 014027 )
	    ;;
	104 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 014028 014029 014030 014031 014032 014033 014034 014035 014036 014037 014038 014039 014040 014041 014042 014043 014044 014045 014046 014047 014048 014049 014050 014051 014052 )
	    ;;
	105 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 015001 015002 015003 015004 015005 015006 015007 015008 015009 015010 015011 015012 015013 015014 015015 015016 015017 015018 015019 015020 015021 015022 015023 015024 015025 015026 015027 015028 015029 015030 015031 015032 015033 015034 015035 015036 015037 015038 015039 015040 015041 015042 015043 015044 015045 015046 015047 015048 015049 )
	    ;;
	106 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 015050 015051 015052 015053 015054 015055 015056 015057 015058 015059 015060 015061 015062 015063 015064 015065 015066 015067 015068 015069 015070 015071 015072 015073 015074 015075 015076 015077 015078 015079 015080 015081 015082 015083 015084 015085 015086 015087 015088 015089 015090 015091 015092 015093 015094 015095 015096 015097 015098 015099 )
	    ;;
	107 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 016001 016002 016003 016004 016005 016006 016007 016008 016009 016010 016011 016012 016013 016014 016015 016016 016017 016018 016019 016020 016021 016022 016023 016024 016025 016026 016027 016028 016029 )
	    ;;
	108 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 016030 016031 016032 016033 016034 016035 016036 016037 016038 016039 016040 016041 016042 016043 016044 016045 016046 016047 016048 016049 016050 )
	    ;;
	109 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 016051 016052 016053 016054 016055 016056 016057 016058 016059 016060 016061 016062 016063 016064 016065 016066 016067 016068 016069 016070 016071 016072 016073 016074 )
	    ;;
	110 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 016075 016076 016077 016078 016079 016080 016081 016082 016083 016084 016085 016086 016087 016088 016089 )
	    ;;
	111 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 016090 016091 016092 016093 016094 016095 016096 016097 016098 016099 016100 016101 016102 016103 016104 016105 016106 016107 016108 016109 016110 )
	    ;;
	112 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 016111 016112 016113 016114 016115 016116 016117 016118 016119 016120 016121 016122 016123 016124 016125 016126 016127 016128 )
	    ;;
	113 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 017001 017002 017003 017004 017005 017006 017007 017008 017009 017010 017011 017012 017013 017014 017015 017016 017017 017018 017019 017020 017021 017022 )
	    ;;
	114 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 017023 017024 017025 017026 017027 017028 017029 017030 017031 017032 017033 017034 017035 017036 017037 017038 017039 017040 017041 017042 017043 017044 017045 017046 017047 017048 017049 )
	    ;;
	115 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 017050 017051 017052 017053 017054 017055 017056 017057 017058 017059 017060 017061 017062 017063 017064 017065 017066 017067 017068 017069 )
	    ;;
	116 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 017070 017071 017072 017073 017074 017075 017076 017077 017078 017079 017080 017081 017082 017083 017084 017085 017086 017087 017088 017089 017090 017091 017092 017093 017094 017095 017096 017097 017098 )
	    ;;
	117 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 017099 017100 017101 017102 017103 017104 017105 017106 017107 017108 017109 017110 017111 018001 018002 018003 018004 018005 018006 018007 018008 018009 018010 018011 018012 018013 018014 018015 018016 )
	    ;;
	118 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 018017 018018 018019 018020 018021 018022 018023 018024 018025 018026 018027 018028 018029 018030 018031 )
	    ;;
	119 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 018032 018033 018034 018035 018036 018037 018038 018039 018040 018041 018042 018043 018044 018045 018046 018047 018048 018049 018050 )
	    ;;
	120 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 018051 018052 018053 018054 018055 018056 018057 018058 018059 018060 018061 018062 018063 018064 018065 018066 018067 018068 018069 018070 018071 018072 018073 018074 )
	    ;;
	121 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 018075 018076 018077 018078 018079 018080 018081 018082 018083 018084 018085 018086 018087 018088 018089 018090 018091 018092 018093 018094 018095 018096 018097 018098 )
	    ;;
	122 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 018099 018100 018101 018102 018103 018104 018105 018106 018107 018108 018109 018110 019001 019002 019003 019004 019005 019006 019007 019008 019009 019010 019011 019012 019013 019014 019015 019016 019017 019018 019019 019020 019021 )
	    ;;
	123 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 019022 019023 019024 019025 019026 019027 019028 019029 019030 019031 019032 019033 019034 019035 019036 019037 019038 019039 019040 019041 019042 019043 019044 019045 019046 019047 019048 019049 019050 019051 019052 019053 019054 019055 019056 019057 019058 )
	    ;;
	124 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 019059 019060 019061 019062 019063 019064 019065 019066 019067 019068 019069 019070 019071 019072 019073 019074 019075 019076 019077 019078 019079 019080 019081 019082 019083 019084 019085 019086 019087 019088 019089 019090 019091 019092 019093 019094 019095 019096 019097 019098 )
	    ;;
	125 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 020001 020002 020003 020004 020005 020006 020007 020008 020009 020010 020011 020012 020013 020014 020015 020016 020017 020018 020019 020020 020021 020022 020023 020024 020025 020026 020027 020028 020029 020030 020031 020032 020033 020034 020035 020036 020037 020038 020039 020040 020041 020042 020043 020044 020045 020046 020047 020048 020049 020050 020051 020052 020053 020054 )
	    ;;
	126 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 020055 020056 020057 020058 020059 020060 020061 020062 020063 020064 020065 020066 020067 020068 020069 020070 020071 020072 020073 020074 020075 020076 020077 020078 020079 020080 020081 020082 )
	    ;;
	127 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 020083 020084 020085 020086 020087 020088 020089 020090 020091 020092 020093 020094 020095 020096 020097 020098 020099 020100 020101 020102 020103 020104 020105 020106 020107 020108 020109 020110 )
	    ;;
	128 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 020111 020112 020113 020114 020115 020116 020117 020118 020119 020120 020121 020122 020123 020124 020125 020126 020127 020128 020129 020130 020131 020132 020133 020134 020135 )
	    ;;
	129 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 021001 021002 021003 021004 021005 021006 021007 021008 021009 021010 021011 021012 021013 021014 021015 021016 021017 021018 021019 021020 021021 021022 021023 021024 021025 021026 021027 021028 )
	    ;;
	130 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 021029 021030 021031 021032 021033 021034 021035 021036 021037 021038 021039 021040 021041 021042 021043 021044 021045 021046 021047 021048 021049 021050 )
	    ;;
	131 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 021051 021052 021053 021054 021055 021056 021057 021058 021059 021060 021061 021062 021063 021064 021065 021066 021067 021068 021069 021070 021071 021072 021073 021074 021075 021076 021077 021078 021079 021080 021081 021082 )
	    ;;
	132 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 021083 021084 021085 021086 021087 021088 021089 021090 021091 021092 021093 021094 021095 021096 021097 021098 021099 021100 021101 021102 021103 021104 021105 021106 021107 021108 021109 021110 021111 021112 )
	    ;;
	133 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 022001 022002 022003 022004 022005 022006 022007 022008 022009 022010 022011 022012 022013 022014 022015 022016 022017 022018 )
	    ;;
	134 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 022019 022020 022021 022022 022023 022024 022025 022026 022027 022028 022029 022030 022031 022032 022033 022034 022035 022036 022037 )
	    ;;
	135 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 022038 022039 022040 022041 022042 022043 022044 022045 022046 022047 022048 022049 022050 022051 022052 022053 022054 022055 022056 022057 022058 022059 )
	    ;;
	136 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 022060 022061 022062 022063 022064 022065 022066 022067 022068 022069 022070 022071 022072 022073 022074 022075 022076 022077 022078 )
	    ;;
	137 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 023001 023002 023003 023004 023005 023006 023007 023008 023009 023010 023011 023012 023013 023014 023015 023016 023017 023018 023019 023020 023021 023022 023023 023024 023025 023026 023027 023028 023029 023030 023031 023032 023033 023034 023035 )
	    ;;
	138 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 023036 023037 023038 023039 023040 023041 023042 023043 023044 023045 023046 023047 023048 023049 023050 023051 023052 023053 023054 023055 023056 023057 023058 023059 023060 023061 023062 023063 023064 023065 023066 023067 023068 023069 023070 023071 023072 023073 023074 )
	    ;;
	139 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 023075 023076 023077 023078 023079 023080 023081 023082 023083 023084 023085 023086 023087 023088 023089 023090 023091 023092 023093 023094 023095 023096 023097 023098 023099 023100 023101 023102 023103 023104 023105 023106 023107 023108 023109 023110 023111 023112 023113 023114 023115 023116 023117 023118 )
	    ;;
	140 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 024001 024002 024003 024004 024005 024006 024007 024008 024009 024010 024011 024012 024013 024014 024015 024016 024017 024018 024019 024020 )
	    ;;
	141 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 024021 024022 024023 024024 024025 024026 024027 024028 024029 024030 024031 024032 024033 024034 )
	    ;;
	142 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 024035 024036 024037 024038 024039 024040 024041 024042 024043 024044 024045 024046 024047 024048 024049 024050 024051 024052 )
	    ;;
	143 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 024053 024054 024055 024056 024057 024058 024059 024060 024061 024062 024063 024064 )
	    ;;
	144 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 025001 025002 025003 025004 025005 025006 025007 025008 025009 025010 025011 025012 025013 025014 025015 025016 025017 025018 025019 025020 )
	    ;;
	145 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 025021 025022 025023 025024 025025 025026 025027 025028 025029 025030 025031 025032 025033 025034 025035 025036 025037 025038 025039 025040 025041 025042 025043 025044 025045 025046 025047 025048 025049 025050 025051 025052 )
	    ;;
	146 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 025053 025054 025055 025056 025057 025058 025059 025060 025061 025062 025063 025064 025065 025066 025067 025068 025069 025070 025071 025072 025073 025074 025075 025076 025077 )
	    ;;
	147 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 026001 026002 026003 026004 026005 026006 026007 026008 026009 026010 026011 026012 026013 026014 026015 026016 026017 026018 026019 026020 026021 026022 026023 026024 026025 026026 026027 026028 026029 026030 026031 026032 026033 026034 026035 026036 026037 026038 026039 026040 026041 026042 026043 026044 026045 026046 026047 026048 026049 026050 026051 )
	    ;;
	148 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 026052 026053 026054 026055 026056 026057 026058 026059 026060 026061 026062 026063 026064 026065 026066 026067 026068 026069 026070 026071 026072 026073 026074 026075 026076 026077 026078 026079 026080 026081 026082 026083 026084 026085 026086 026087 026088 026089 026090 026091 026092 026093 026094 026095 026096 026097 026098 026099 026100 026101 026102 026103 026104 026105 026106 026107 026108 026109 026110 )
	    ;;
	149 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 026111 026112 026113 026114 026115 026116 026117 026118 026119 026120 026121 026122 026123 026124 026125 026126 026127 026128 026129 026130 026131 026132 026133 026134 026135 026136 026137 026138 026139 026140 026141 026142 026143 026144 026145 026146 026147 026148 026149 026150 026151 026152 026153 026154 026155 026156 026157 026158 026159 026160 026161 026162 026163 026164 026165 026166 026167 026168 026169 026170 026171 026172 026173 026174 026175 026176 026177 026178 026179 026180 )
	    ;;
	150 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 026181 026182 026183 026184 026185 026186 026187 026188 026189 026190 026191 026192 026193 026194 026195 026196 026197 026198 026199 026200 026201 026202 026203 026204 026205 026206 026207 026208 026209 026210 026211 026212 026213 026214 026215 026216 026217 026218 026219 026220 026221 026222 026223 026224 026225 026226 026227 )
	    ;;
	151 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 027001 027002 027003 027004 027005 027006 027007 027008 027009 027010 027011 027012 027013 027014 027015 027016 027017 027018 027019 027020 027021 027022 027023 027024 027025 027026 )
	    ;;
	152 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 027027 027028 027029 027030 027031 027032 027033 027034 027035 027036 027037 027038 027039 027040 027041 027042 027043 027044 027045 027046 027047 027048 027049 027050 027051 027052 027053 027054 027055 )
	    ;;
	153 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 027056 027057 027058 027059 027060 027061 027062 027063 027064 027065 027066 027067 027068 027069 027070 027071 027072 027073 027074 027075 027076 027077 027078 027079 027080 027081 )
	    ;;
	154 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 027082 027083 027084 027085 027086 027087 027088 027089 027090 027091 027092 027093 028001 028002 028003 028004 028005 028006 028007 028008 028009 028010 028011 )
	    ;;
	155 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 028012 028013 028014 028015 028016 028017 028018 028019 028020 028021 028022 028023 028024 028025 028026 028027 028028 )
	    ;;
	156 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 028029 028030 028031 028032 028033 028034 028035 028036 028037 028038 028039 028040 028041 028042 028043 028044 028045 028046 028047 028048 028049 028050 )
	    ;;
	157 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 028051 028052 028053 028054 028055 028056 028057 028058 028059 028060 028061 028062 028063 028064 028065 028066 028067 028068 028069 028070 028071 028072 028073 028074 028075 )
	    ;;
	158 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 028076 028077 028078 028079 028080 028081 028082 028083 028084 028085 028086 028087 028088 )
	    ;;
	159 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 029001 029002 029003 029004 029005 029006 029007 029008 029009 029010 029011 029012 029013 029014 029015 029016 029017 029018 029019 029020 029021 029022 029023 029024 029025 )
	    ;;
	160 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 029026 029027 029028 029029 029030 029031 029032 029033 029034 029035 029036 029037 029038 029039 029040 029041 029042 029043 029044 029045 )
	    ;;
	161 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 029046 029047 029048 029049 029050 029051 029052 029053 029054 029055 029056 029057 029058 029059 029060 029061 029062 029063 029064 029065 029066 029067 029068 029069 )
	    ;;
	162 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 030001 030002 030003 030004 030005 030006 030007 030008 030009 030010 030011 030012 030013 030014 030015 030016 030017 030018 030019 030020 030021 030022 030023 030024 030025 030026 030027 030028 030029 030030 )
	    ;;
	163 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 030031 030032 030033 030034 030035 030036 030037 030038 030039 030040 030041 030042 030043 030044 030045 030046 030047 030048 030049 030050 030051 030052 030053 )
	    ;;
	164 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 030054 030055 030056 030057 030058 030059 030060 031001 031002 031003 031004 031005 031006 031007 031008 031009 031010 031011 031012 031013 031014 031015 031016 031017 031018 031019 031020 031021 )
	    ;;
	165 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 031022 031023 031024 031025 031026 031027 031028 031029 031030 031031 031032 031033 031034 032001 032002 032003 032004 032005 032006 032007 032008 032009 032010 )
	    ;;
	166 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 032011 032012 032013 032014 032015 032016 032017 032018 032019 032020 032021 032022 032023 032024 032025 032026 032027 032028 032029 032030 )
	    ;;
	167 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 033001 033002 033003 033004 033005 033006 033007 033008 033009 033010 033011 033012 033013 033014 033015 033016 033017 )
	    ;;
	168 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 033018 033019 033020 033021 033022 033023 033024 033025 033026 033027 033028 033029 033030 )
	    ;;
	169 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 033031 033032 033033 033034 033035 033036 033037 033038 033039 033040 033041 033042 033043 033044 033045 033046 033047 033048 033049 033050 )
	    ;;
	170 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 033051 033052 033053 033054 033055 033056 033057 033058 033059 )
	    ;;
	171 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 033060 033061 033062 033063 033064 033065 033066 033067 033068 033069 033070 033071 033072 033073 034001 034002 034003 034004 034005 034006 034007 034008 034009 )
	    ;;
	172 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 034010 034011 034012 034013 034014 034015 034016 034017 034018 034019 034020 034021 034022 034023 )
	    ;;
	173 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 034024 034025 034026 034027 034028 034029 034030 034031 034032 034033 034034 034035 034036 034037 034038 034039 034040 034041 034042 034043 034044 034045 )
	    ;;
	174 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 034046 034047 034048 034049 034050 034051 034052 034053 034054 035001 035002 035003 035004 035005 035006 035007 035008 035009 035010 035011 035012 035013 035014 )
	    ;;
	175 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 035015 035016 035017 035018 035019 035020 035021 035022 035023 035024 035025 035026 035027 035028 035029 035030 035031 035032 035033 035034 035035 035036 035037 035038 035039 035040 )
	    ;;
	176 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 035041 035042 035043 035044 035045 036001 036002 036003 036004 036005 036006 036007 036008 036009 036010 036011 036012 036013 036014 036015 036016 036017 036018 036019 036020 036021 036022 036023 036024 036025 036026 036027 )
	    ;;
	177 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 036028 036029 036030 036031 036032 036033 036034 036035 036036 036037 036038 036039 036040 036041 036042 036043 036044 036045 036046 036047 036048 036049 036050 036051 036052 036053 036054 036055 036056 036057 036058 036059 )
	    ;;
	178 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 036060 036061 036062 036063 036064 036065 036066 036067 036068 036069 036070 036071 036072 036073 036074 036075 036076 036077 036078 036079 036080 036081 036082 036083 037001 037002 037003 037004 037005 037006 037007 037008 037009 037010 037011 037012 037013 037014 037015 037016 037017 037018 037019 037020 037021 )
	    ;;
	179 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 037022 037023 037024 037025 037026 037027 037028 037029 037030 037031 037032 037033 037034 037035 037036 037037 037038 037039 037040 037041 037042 037043 037044 037045 037046 037047 037048 037049 037050 037051 037052 037053 037054 037055 037056 037057 037058 037059 037060 037061 037062 037063 037064 037065 037066 037067 037068 037069 037070 037071 037072 037073 037074 037075 037076 037077 037078 037079 037080 037081 037082 )
	    ;;
	180 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 037083 037084 037085 037086 037087 037088 037089 037090 037091 037092 037093 037094 037095 037096 037097 037098 037099 037100 037101 037102 037103 037104 037105 037106 037107 037108 037109 037110 037111 037112 037113 037114 037115 037116 037117 037118 037119 037120 037121 037122 037123 037124 037125 037126 037127 037128 037129 037130 037131 037132 037133 037134 037135 037136 037137 037138 037139 037140 037141 037142 037143 037144 )
	    ;;
	181 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 037145 037146 037147 037148 037149 037150 037151 037152 037153 037154 037155 037156 037157 037158 037159 037160 037161 037162 037163 037164 037165 037166 037167 037168 037169 037170 037171 037172 037173 037174 037175 037176 037177 037178 037179 037180 037181 037182 038001 038002 038003 038004 038005 038006 038007 038008 038009 038010 038011 038012 038013 038014 038015 038016 038017 038018 038019 038020 )
	    ;;
	182 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 038021 038022 038023 038024 038025 038026 038027 038028 038029 038030 038031 038032 038033 038034 038035 038036 038037 038038 038039 038040 038041 038042 038043 038044 038045 038046 038047 038048 038049 038050 038051 )
	    ;;
	183 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 038052 038053 038054 038055 038056 038057 038058 038059 038060 038061 038062 038063 038064 038065 038066 038067 038068 038069 038070 038071 038072 038073 038074 038075 038076 038077 038078 038079 038080 038081 038082 038083 038084 038085 038086 038087 038088 039001 039002 039003 039004 039005 039006 039007 )
	    ;;
	184 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 039008 039009 039010 039011 039012 039013 039014 039015 039016 039017 039018 039019 039020 039021 039022 039023 039024 039025 039026 039027 039028 039029 039030 039031 )
	    ;;
	185 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 039032 039033 039034 039035 039036 039037 039038 039039 039040 039041 039042 039043 039044 039045 039046 039047 039048 039049 039050 039051 039052 )
	    ;;
	186 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 039053 039054 039055 039056 039057 039058 039059 039060 039061 039062 039063 039064 039065 039066 039067 039068 039069 039070 039071 039072 039073 039074 039075 )
	    ;;
	187 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 040001 040002 040003 040004 040005 040006 040007 040008 040009 040010 040011 040012 040013 040014 040015 040016 040017 040018 040019 040020 )
	    ;;
	188 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 040021 040022 040023 040024 040025 040026 040027 040028 040029 040030 040031 040032 040033 040034 040035 040036 040037 040038 040039 040040 )
	    ;;
	189 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 040041 040042 040043 040044 040045 040046 040047 040048 040049 040050 040051 040052 040053 040054 040055 040056 040057 040058 040059 040060 040061 040062 040063 040064 040065 )
	    ;;
	190 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 040066 040067 040068 040069 040070 040071 040072 040073 040074 040075 040076 040077 040078 040079 040080 040081 040082 040083 040084 040085 041001 041002 041003 041004 041005 041006 041007 041008 )
	    ;;
	191 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 041009 041010 041011 041012 041013 041014 041015 041016 041017 041018 041019 041020 041021 041022 041023 041024 )
	    ;;
	192 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 041025 041026 041027 041028 041029 041030 041031 041032 041033 041034 041035 041036 041037 041038 041039 041040 041041 041042 041043 041044 041045 041046 )
	    ;;
	193 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 041047 041048 041049 041050 041051 041052 041053 041054 042001 042002 042003 042004 042005 042006 042007 042008 042009 042010 042011 042012 )
	    ;;
	194 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 042013 042014 042015 042016 042017 042018 042019 042020 042021 042022 042023 042024 042025 042026 )
	    ;;
	195 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 042027 042028 042029 042030 042031 042032 042033 042034 042035 042036 042037 042038 042039 042040 042041 042042 042043 042044 042045 042046 042047 042048 042049 042050 )
	    ;;
	196 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 042051 042052 042053 043001 043002 043003 043004 043005 043006 043007 043008 043009 043010 043011 043012 043013 043014 043015 043016 043017 043018 043019 043020 043021 043022 043023 )
	    ;;
	197 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 043024 043025 043026 043027 043028 043029 043030 043031 043032 043033 043034 043035 043036 043037 043038 043039 043040 043041 043042 043043 043044 043045 043046 043047 043048 043049 043050 043051 043052 043053 043054 043055 043056 )
	    ;;
	198 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 043057 043058 043059 043060 043061 043062 043063 043064 043065 043066 043067 043068 043069 043070 043071 043072 043073 043074 043075 043076 043077 043078 043079 043080 043081 043082 043083 043084 043085 043086 043087 043088 043089 044001 044002 044003 044004 044005 044006 044007 044008 044009 044010 044011 044012 044013 044014 044015 044016 )
	    ;;
	199 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 044017 044018 044019 044020 044021 044022 044023 044024 044025 044026 044027 044028 044029 044030 044031 044032 044033 044034 044035 044036 044037 044038 044039 044040 044041 044042 044043 044044 044045 044046 044047 044048 044049 044050 044051 044052 044053 044054 044055 044056 044057 044058 044059 045001 045002 045003 045004 045005 045006 045007 045008 045009 045010 045011 )
	    ;;
	200 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 045012 045013 045014 045015 045016 045017 045018 045019 045020 045021 045022 045023 045024 045025 045026 045027 045028 045029 045030 045031 045032 045033 045034 045035 045036 045037 )
	    ;;
	201 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 046001 046002 046003 046004 046005 046006 046007 046008 046009 046010 046011 046012 046013 046014 046015 046016 046017 046018 046019 046020 )
	    ;;
	202 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 046021 046022 046023 046024 046025 046026 046027 046028 046029 046030 046031 046032 046033 046034 046035 047001 047002 047003 047004 047005 047006 047007 047008 047009 )
	    ;;
	203 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 047010 047011 047012 047013 047014 047015 047016 047017 047018 047019 047020 047021 047022 047023 047024 047025 047026 047027 047028 047029 047030 047031 047032 )
	    ;;
	204 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 047033 047034 047035 047036 047037 047038 048001 048002 048003 048004 048005 048006 048007 048008 048009 048010 048011 048012 048013 048014 048015 048016 048017 )
	    ;;
	205 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 048018 048019 048020 048021 048022 048023 048024 048025 048026 048027 048028 048029 )
	    ;;
	206 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 049001 049002 049003 049004 049005 049006 049007 049008 049009 049010 049011 049012 049013 )
	    ;;
	207 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 049014 049015 049016 049017 049018 050001 050002 050003 050004 050005 050006 050007 050008 050009 050010 050011 050012 050013 050014 050015 050016 050017 050018 050019 050020 050021 050022 050023 050024 050025 050026 )
	    ;;
	208 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 050027 050028 050029 050030 050031 050032 050033 050034 050035 050036 050037 050038 050039 050040 050041 050042 050043 050044 050045 051001 051002 051003 051004 051005 051006 051007 051008 051009 051010 051011 051012 051013 051014 051015 051016 051017 051018 051019 051020 051021 051022 051023 051024 051025 051026 051027 051028 051029 051030 )
	    ;;
	209 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 051031 051032 051033 051034 051035 051036 051037 051038 051039 051040 051041 051042 051043 051044 051045 051046 051047 051048 051049 051050 051051 051052 051053 051054 051055 051056 051057 051058 051059 051060 052001 052002 052003 052004 052005 052006 052007 052008 052009 052010 052011 052012 052013 052014 052015 052016 052017 052018 052019 052020 052021 052022 052023 )
	    ;;
	210 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 052024 052025 052026 052027 052028 052029 052030 052031 052032 052033 052034 052035 052036 052037 052038 052039 052040 052041 052042 052043 052044 052045 052046 052047 052048 052049 053001 053002 053003 053004 053005 053006 053007 053008 053009 053010 053011 053012 053013 053014 053015 053016 053017 053018 053019 053020 053021 053022 053023 053024 053025 )
	    ;;
	211 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 053026 053027 053028 053029 053030 053031 053032 053033 053034 053035 053036 053037 053038 053039 053040 053041 053042 053043 053044 053045 053046 053047 053048 053049 053050 053051 053052 053053 053054 053055 053056 053057 053058 053059 053060 053061 053062 054001 054002 054003 054004 054005 054006 054007 054008 )
	    ;;
	212 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 054009 054010 054011 054012 054013 054014 054015 054016 054017 054018 054019 054020 054021 054022 054023 054024 054025 054026 054027 054028 054029 054030 054031 054032 054033 054034 054035 054036 054037 054038 054039 054040 054041 054042 054043 054044 054045 054046 054047 054048 054049 054050 054051 054052 054053 054054 054055 )
	    ;;
	213 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 055001 055002 055003 055004 055005 055006 055007 055008 055009 055010 055011 055012 055013 055014 055015 055016 055017 055018 055019 055020 055021 055022 055023 055024 055025 055026 055027 055028 055029 055030 055031 055032 055033 055034 055035 055036 055037 055038 055039 055040 055041 055042 055043 055044 055045 055046 055047 055048 055049 055050 055051 055052 055053 055054 055055 055056 055057 055058 055059 055060 055061 055062 055063 055064 055065 055066 055067 055068 055069 055070 055071 055072 055073 055074 055075 055076 055077 055078 )
	    ;;
	214 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 056001 056002 056003 056004 056005 056006 056007 056008 056009 056010 056011 056012 056013 056014 056015 056016 056017 056018 056019 056020 056021 056022 056023 056024 056025 056026 056027 056028 056029 056030 056031 056032 056033 056034 056035 056036 056037 056038 056039 056040 056041 056042 056043 056044 056045 056046 056047 056048 056049 056050 056051 056052 056053 056054 056055 056056 056057 056058 056059 056060 056061 056062 056063 056064 056065 056066 056067 056068 056069 056070 056071 056072 056073 056074 )
	    ;;
	215 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 056075 056076 056077 056078 056079 056080 056081 056082 056083 056084 056085 056086 056087 056088 056089 056090 056091 056092 056093 056094 056095 056096 057001 057002 057003 057004 057005 057006 057007 057008 057009 057010 057011 057012 057013 057014 057015 )
	    ;;
	216 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 057016 057017 057018 057019 057020 057021 057022 057023 057024 057025 057026 057027 057028 057029 )
	    ;;
	217 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 058001 058002 058003 058004 058005 058006 058007 058008 058009 058010 058011 058012 058013 )
	    ;;
	218 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 058014 058015 058016 058017 058018 058019 058020 058021 058022 059001 059002 059003 059004 059005 059006 059007 059008 059009 059010 )
	    ;;
	219 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 059011 059012 059013 059014 059015 059016 059017 059018 059019 059020 059021 059022 059023 059024 060001 060002 060003 060004 060005 060006 )
	    ;;
	220 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 060007 060008 060009 060010 060011 060012 060013 061001 061002 061003 061004 061005 061006 061007 061008 061009 061010 061011 061012 061013 061014 )
	    ;;
	221 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 062001 062002 062003 062004 062005 062006 062007 062008 062009 062010 062011 063001 063002 063003 )
	    ;;
	222 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 063004 063005 063006 063007 063008 063009 063010 063011 064001 064002 064003 064004 064005 064006 064007 064008 064009 064010 064011 064012 064013 064014 064015 064016 064017 064018 )
	    ;;
	223 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 065001 065002 065003 065004 065005 065006 065007 065008 065009 065010 065011 065012 )
	    ;;
	224 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 066001 066002 066003 066004 066005 066006 066007 066008 066009 066010 066011 066012 )
	    ;;
	225 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 067001 067002 067003 067004 067005 067006 067007 067008 067009 067010 067011 067012 067013 067014 067015 067016 067017 067018 067019 067020 067021 067022 067023 067024 067025 067026 067027 067028 067029 067030 )
	    ;;
	226 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 068001 068002 068003 068004 068005 068006 068007 068008 068009 068010 068011 068012 068013 068014 068015 068016 068017 068018 068019 068020 068021 068022 068023 068024 068025 068026 068027 068028 068029 068030 068031 068032 068033 068034 068035 068036 068037 068038 068039 068040 068041 068042 068043 068044 068045 068046 068047 068048 068049 068050 068051 068052 )
	    ;;
	227 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 069001 069002 069003 069004 069005 069006 069007 069008 069009 069010 069011 069012 069013 069014 069015 069016 069017 069018 069019 069020 069021 069022 069023 069024 069025 069026 069027 069028 069029 069030 069031 069032 069033 069034 069035 069036 069037 069038 069039 069040 069041 069042 069043 069044 069045 069046 069047 069048 069049 069050 069051 069052 070001 070002 070003 070004 070005 070006 070007 070008 070009 070010 070011 070012 070013 070014 070015 070016 070017 070018 )
	    ;;
	228 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 070019 070020 070021 070022 070023 070024 070025 070026 070027 070028 070029 070030 070031 070032 070033 070034 070035 070036 070037 070038 070039 070040 070041 070042 070043 070044 071001 071002 071003 071004 071005 071006 071007 071008 071009 071010 071011 071012 071013 071014 071015 071016 071017 071018 071019 071020 071021 071022 071023 071024 071025 071026 071027 071028 )
	    ;;
	229 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 072001 072002 072003 072004 072005 072006 072007 072008 072009 072010 072011 072012 072013 072014 072015 072016 072017 072018 072019 072020 072021 072022 072023 072024 072025 072026 072027 072028 073001 073002 073003 073004 073005 073006 073007 073008 073009 073010 073011 073012 073013 073014 073015 073016 073017 073018 073019 )
	    ;;
	230 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 073020 074001 074002 074003 074004 074005 074006 074007 074008 074009 074010 074011 074012 074013 074014 074015 074016 074017 074018 074019 074020 074021 074022 074023 074024 074025 074026 074027 074028 074029 074030 074031 074032 074033 074034 074035 074036 074037 074038 074039 074040 074041 074042 074043 074044 074045 074046 074047 074048 074049 074050 074051 074052 074053 074054 074055 074056 )
	    ;;
	231 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 075001 075002 075003 075004 075005 075006 075007 075008 075009 075010 075011 075012 075013 075014 075015 075016 075017 075018 075019 075020 075021 075022 075023 075024 075025 075026 075027 075028 075029 075030 075031 075032 075033 075034 075035 075036 075037 075038 075039 075040 076001 076002 076003 076004 076005 076006 076007 076008 076009 076010 076011 076012 076013 076014 076015 076016 076017 076018 )
	    ;;
	232 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 076019 076020 076021 076022 076023 076024 076025 076026 076027 076028 076029 076030 076031 077001 077002 077003 077004 077005 077006 077007 077008 077009 077010 077011 077012 077013 077014 077015 077016 077017 077018 077019 077020 077021 077022 077023 077024 077025 077026 077027 077028 077029 077030 077031 077032 077033 077034 077035 077036 077037 077038 077039 077040 077041 077042 077043 077044 077045 077046 077047 077048 077049 077050 )
	    ;;
	233 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 078001 078002 078003 078004 078005 078006 078007 078008 078009 078010 078011 078012 078013 078014 078015 078016 078017 078018 078019 078020 078021 078022 078023 078024 078025 078026 078027 078028 078029 078030 078031 078032 078033 078034 078035 078036 078037 078038 078039 078040 079001 079002 079003 079004 079005 079006 079007 079008 079009 079010 079011 079012 079013 079014 079015 079016 079017 079018 079019 079020 079021 079022 079023 079024 079025 079026 079027 079028 079029 079030 079031 079032 079033 079034 079035 079036 079037 079038 079039 079040 079041 079042 079043 079044 079045 079046 )
	    ;;
	234 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 080001 080002 080003 080004 080005 080006 080007 080008 080009 080010 080011 080012 080013 080014 080015 080016 080017 080018 080019 080020 080021 080022 080023 080024 080025 080026 080027 080028 080029 080030 080031 080032 080033 080034 080035 080036 080037 080038 080039 080040 080041 080042 081001 081002 081003 081004 081005 081006 081007 081008 081009 081010 081011 081012 081013 081014 081015 081016 081017 081018 081019 081020 081021 081022 081023 081024 081025 081026 081027 081028 081029 )
	    ;;
	235 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 082001 082002 082003 082004 082005 082006 082007 082008 082009 082010 082011 082012 082013 082014 082015 082016 082017 082018 082019 083001 083002 083003 083004 083005 083006 083007 083008 083009 083010 083011 083012 083013 083014 083015 083016 083017 083018 083019 083020 083021 083022 083023 083024 083025 083026 083027 083028 083029 083030 083031 083032 083033 083034 083035 083036 )
	    ;;
	236 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 084001 084002 084003 084004 084005 084006 084007 084008 084009 084010 084011 084012 084013 084014 084015 084016 084017 084018 084019 084020 084021 084022 084023 084024 084025 085001 085002 085003 085004 085005 085006 085007 085008 085009 085010 085011 085012 085013 085014 085015 085016 085017 085018 085019 085020 085021 085022 086001 086002 086003 086004 086005 086006 086007 086008 086009 086010 086011 086012 086013 086014 086015 086016 086017 )
	    ;;
	237 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 087001 087002 087003 087004 087005 087006 087007 087008 087009 087010 087011 087012 087013 087014 087015 087016 087017 087018 087019 088001 088002 088003 088004 088005 088006 088007 088008 088009 088010 088011 088012 088013 088014 088015 088016 088017 088018 088019 088020 088021 088022 088023 088024 088025 088026 089001 089002 089003 089004 089005 089006 089007 089008 089009 089010 089011 089012 089013 089014 089015 089016 089017 089018 089019 089020 089021 089022 089023 089024 089025 089026 089027 089028 089029 089030 )
	    ;;
	238 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 090001 090002 090003 090004 090005 090006 090007 090008 090009 090010 090011 090012 090013 090014 090015 090016 090017 090018 090019 090020 091001 091002 091003 091004 091005 091006 091007 091008 091009 091010 091011 091012 091013 091014 091015 092001 092002 092003 092004 092005 092006 092007 092008 092009 092010 092011 092012 092013 092014 092015 092016 092017 092018 092019 092020 092021 093001 093002 093003 093004 093005 093006 093007 093008 093009 093010 093011 )
	    ;;
	239 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 094001 094002 094003 094004 094005 094006 094007 094008 095001 095002 095003 095004 095005 095006 095007 095008 096001 096002 096003 096004 096005 096006 096007 096008 096009 096010 096011 096012 096013 096014 096015 096016 096017 096018 096019 097001 097002 097003 097004 097005 098001 098002 098003 098004 098005 098006 098007 098008 099001 099002 099003 099004 099005 099006 099007 099008 100001 100002 100003 100004 100005 100006 100007 100008 )
	    ;;
	240 )
	    list_of_verses_that_belong_to_this_RUB_UL_HIZB=( 100009 100010 100011 101001 101002 101003 101004 101005 101006 101007 101008 101009 101010 101011 102001 102002 102003 102004 102005 102006 102007 102008 103001 103002 103003 104001 104002 104003 104004 104005 104006 104007 104008 104009 105001 105002 105003 105004 105005 106001 106002 106003 106004 107001 107002 107003 107004 107005 107006 107007 108001 108002 108003 109001 109002 109003 109004 109005 109006 110001 110002 110003 111001 111002 111003 111004 111005 112001 112002 112003 112004 113001 113002 113003 113004 113005 114001 114002 114003 114004 114005 114006 )
	    ;;
	* )
	    echo
	    echo "The value you entered: '$file' is invalid!"
	    echo; exit
	    ;;
    esac
}


show_list_of_verses_that_belong_to_this_page_number(){
    local pageNumber="$1"
    case "$pageNumber" in
	1 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 001001 001002 001003 001004 001005 001006 001007 )
	    ;;
	2 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002001 002002 002003 002004 002005 )
	    ;;
	3 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002006 002007 002008 002009 002010 002011 002012 002013 002014 002015 002016 )
	    ;;
	4 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002017 002018 002019 002020 002021 002022 002023 002024 )
	    ;;
	5 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002025 002026 002027 002028 002029 )
	    ;;
	6 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002030 002031 002032 002033 002034 002035 002036 002037 )
	    ;;
	7 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002038 002039 002040 002041 002042 002043 002044 002045 002046 002047 002048 )
	    ;;
	8 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002049 002050 002051 002052 002053 002054 002055 002056 002057 )
	    ;;
	9 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002058 002059 002060 002061 )
	    ;;
	10 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002062 002063 002064 002065 002066 002067 002068 002069 )
	    ;;
	11 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002070 002071 002072 002073 002074 002075 002076 )
	    ;;
	12 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002077 002078 002079 002080 002081 002082 002083 )
	    ;;
	13 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002084 002085 002086 002087 002088 )
	    ;;
	14 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002089 002090 002091 002092 002093 )
	    ;;
	15 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002094 002095 002096 002097 002098 002099 002100 002101 )
	    ;;
	16 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002102 002103 002104 002105 )
	    ;;
	17 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002106 002107 002108 002109 002110 002111 002112 )
	    ;;
	18 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002113 002114 002115 002116 002117 002118 002119 )
	    ;;
	19 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002120 002121 002122 002123 002124 002125 002126 )
	    ;;
	20 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002127 002128 002129 002130 002131 002132 002133 002134 )
	    ;;
	21 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002135 002136 002137 002138 002139 002140 002141 )
	    ;;
	22 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002142 002143 002144 002145 )
	    ;;
	23 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002146 002147 002148 002149 002150 002151 002152 002153 )
	    ;;
	24 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002154 002155 002156 002157 002158 002159 002160 002161 002162 002163 )
	    ;;
	25 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002164 002165 002166 002167 002168 002169 )
	    ;;
	26 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002170 002171 002172 002173 002174 002175 002176 )
	    ;;
	27 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002177 002178 002179 002180 002181 )
	    ;;
	28 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002182 002183 002184 002185 002186 )
	    ;;
	29 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002187 002188 002189 002190 )
	    ;;
	30 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002191 002192 002193 002194 002195 002196 )
	    ;;
	31 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002197 002198 002199 002200 002201 002202 )
	    ;;
	32 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002203 002204 002205 002206 002207 002208 002209 002210 )
	    ;;
	33 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002211 002212 002213 002214 002215 )
	    ;;
	34 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002216 002217 002218 002219 )
	    ;;
	35 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002220 002221 002222 002223 002224 )
	    ;;
	36 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002225 002226 002227 002228 002229 002230 )
	    ;;
	37 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002231 002232 002233 )
	    ;;
	38 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002234 002235 002236 002237 )
	    ;;
	39 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002238 002239 002240 002241 002242 002243 002244 002245 )
	    ;;
	40 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002246 002247 002248 )
	    ;;
	41 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002249 002250 002251 002252 )
	    ;;
	42 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002253 002254 002255 002256 )
	    ;;
	43 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002257 002258 002259 )
	    ;;
	44 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002260 002261 002262 002263 002264 )
	    ;;
	45 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002265 002266 002267 002268 002269 )
	    ;;
	46 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002270 002271 002272 002273 002274 )
	    ;;
	47 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002275 002276 002277 002278 002279 002280 002281 )
	    ;;
	48 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002282 )
	    ;;
	49 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 002283 002284 002285 002286 )
	    ;;
	50 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003001 003002 003003 003004 003005 003006 003007 003008 003009 )
	    ;;
	51 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003010 003011 003012 003013 003014 003015 )
	    ;;
	52 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003016 003017 003018 003019 003020 003021 003022 )
	    ;;
	53 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003023 003024 003025 003026 003027 003028 003029 )
	    ;;
	54 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003030 003031 003032 003033 003034 003035 003036 003037 )
	    ;;
	55 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003038 003039 003040 003041 003042 003043 003044 003045 )
	    ;;
	56 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003046 003047 003048 003049 003050 003051 003052 )
	    ;;
	57 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003053 003054 003055 003056 003057 003058 003059 003060 003061 )
	    ;;
	58 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003062 003063 003064 003065 003066 003067 003068 003069 003070 )
	    ;;
	59 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003071 003072 003073 003074 003075 003076 003077 )
	    ;;
	60 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003078 003079 003080 003081 003082 003083 )
	    ;;
	61 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003084 003085 003086 003087 003088 003089 003090 003091 )
	    ;;
	62 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003092 003093 003094 003095 003096 003097 003098 003099 003100 )
	    ;;
	63 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003101 003102 003103 003104 003105 003106 003107 003108 )
	    ;;
	64 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003109 003110 003111 003112 003113 003114 003115 )
	    ;;
	65 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003116 003117 003118 003119 003120 003121 )
	    ;;
	66 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003122 003123 003124 003125 003126 003127 003128 003129 003130 003131 003132 )
	    ;;
	67 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003133 003134 003135 003136 003137 003138 003139 003140 )
	    ;;
	68 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003141 003142 003143 003144 003145 003146 003147 003148 )
	    ;;
	69 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003149 003150 003151 003152 003153 )
	    ;;
	70 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003154 003155 003156 003157 )
	    ;;
	71 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003158 003159 003160 003161 003162 003163 003164 003165 )
	    ;;
	72 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003166 003167 003168 003169 003170 003171 003172 003173 )
	    ;;
	73 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003174 003175 003176 003177 003178 003179 003180 )
	    ;;
	74 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003181 003182 003183 003184 003185 003186 )
	    ;;
	75 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003187 003188 003189 003190 003191 003192 003193 003194 )
	    ;;
	76 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 003195 003196 003197 003198 003199 003200 )
	    ;;
	77 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004001 004002 004003 004004 004005 004006 )
	    ;;
	78 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004007 004008 004009 004010 004011 )
	    ;;
	79 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004012 004013 004014 )
	    ;;
	80 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004015 004016 004017 004018 004019 )
	    ;;
	81 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004020 004021 004022 004023 )
	    ;;
	82 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004024 004025 004026 )
	    ;;
	83 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004027 004028 004029 004030 004031 004032 004033 )
	    ;;
	84 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004034 004035 004036 004037 )
	    ;;
	85 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004038 004039 004040 004041 004042 004043 004044 )
	    ;;
	86 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004045 004046 004047 004048 004049 004050 004051 )
	    ;;
	87 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004052 004053 004054 004055 004056 004057 004058 004059 )
	    ;;
	88 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004060 004061 004062 004063 004064 004065 )
	    ;;
	89 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004066 004067 004068 004069 004070 004071 004072 004073 004074 )
	    ;;
	90 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004075 004076 004077 004078 004079 )
	    ;;
	91 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004080 004081 004082 004083 004084 004085 004086 )
	    ;;
	92 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004087 004088 004089 004090 004091 )
	    ;;
	93 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004092 004093 004094 )
	    ;;
	94 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004095 004096 004097 004098 004099 004100 004101 )
	    ;;
	95 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004102 004103 004104 004105 )
	    ;;
	96 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004106 004107 004108 004109 004110 004111 004112 004113 )
	    ;;
	97 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004114 004115 004116 004117 004118 004119 004120 004121 )
	    ;;
	98 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004122 004123 004124 004125 004126 004127 )
	    ;;
	99 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004128 004129 004130 004131 004132 004133 004134 )
	    ;;
	100 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004135 004136 004137 004138 004139 004140 )
	    ;;
	101 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004141 004142 004143 004144 004145 004146 004147 )
	    ;;
	102 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004148 004149 004150 004151 004152 004153 004154 )
	    ;;
	103 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004155 004156 004157 004158 004159 004160 004161 004162 )
	    ;;
	104 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004163 004164 004165 004166 004167 004168 004169 004170 )
	    ;;
	105 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004171 004172 004173 004174 004175 )
	    ;;
	106 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 004176 005001 005002 )
	    ;;
	107 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 005003 005004 005005 )
	    ;;
	108 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 005006 005007 005008 005009 )
	    ;;
	109 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 005010 005011 005012 005013 )
	    ;;
	110 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 005014 005015 005016 005017 )
	    ;;
	111 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 005018 005019 005020 005021 005022 005023 )
	    ;;
	112 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 005024 005025 005026 005027 005028 005029 005030 005031 )
	    ;;
	113 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 005032 005033 005034 005035 005036 )
	    ;;
	114 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 005037 005038 005039 005040 005041 )
	    ;;
	115 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 005042 005043 005044 005045 )
	    ;;
	116 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 005046 005047 005048 005049 005050 )
	    ;;
	117 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 005051 005052 005053 005054 005055 005056 005057 )
	    ;;
	118 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 005058 005059 005060 005061 005062 005063 005064 )
	    ;;
	119 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 005065 005066 005067 005068 005069 005070 )
	    ;;
	120 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 005071 005072 005073 005074 005075 005076 )
	    ;;
	121 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 005077 005078 005079 005080 005081 005082 )
	    ;;
	122 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 005083 005084 005085 005086 005087 005088 005089 )
	    ;;
	123 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 005090 005091 005092 005093 005094 005095 )
	    ;;
	124 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 005096 005097 005098 005099 005100 005101 005102 005103 )
	    ;;
	125 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 005104 005105 005106 005107 005108 )
	    ;;
	126 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 005109 005110 005111 005112 005113 )
	    ;;
	127 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 005114 005115 005116 005117 005118 005119 005120 )
	    ;;
	128 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006001 006002 006003 006004 006005 006006 006007 006008 )
	    ;;
	129 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006009 006010 006011 006012 006013 006014 006015 006016 006017 006018 )
	    ;;
	130 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006019 006020 006021 006022 006023 006024 006025 006026 006027 )
	    ;;
	131 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006028 006029 006030 006031 006032 006033 006034 006035 )
	    ;;
	132 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006036 006037 006038 006039 006040 006041 006042 006043 006044 )
	    ;;
	133 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006045 006046 006047 006048 006049 006050 006051 006052 )
	    ;;
	134 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006053 006054 006055 006056 006057 006058 006059 )
	    ;;
	135 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006060 006061 006062 006063 006064 006065 006066 006067 006068 )
	    ;;
	136 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006069 006070 006071 006072 006073 )
	    ;;
	137 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006074 006075 006076 006077 006078 006079 006080 006081 )
	    ;;
	138 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006082 006083 006084 006085 006086 006087 006088 006089 006090 )
	    ;;
	139 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006091 006092 006093 006094 )
	    ;;
	140 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006095 006096 006097 006098 006099 006100 006101 )
	    ;;
	141 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006102 006103 006104 006105 006106 006107 006108 006109 006110 )
	    ;;
	142 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006111 006112 006113 006114 006115 006116 006117 006118 )
	    ;;
	143 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006119 006120 006121 006122 006123 006124 )
	    ;;
	144 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006125 006126 006127 006128 006129 006130 006131 )
	    ;;
	145 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006132 006133 006134 006135 006136 006137 )
	    ;;
	146 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006138 006139 006140 006141 006142 )
	    ;;
	147 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006143 006144 006145 006146 )
	    ;;
	148 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006147 006148 006149 006150 006151 )
	    ;;
	149 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006152 006153 006154 006155 006156 006157 )
	    ;;
	150 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 006158 006159 006160 006161 006162 006163 006164 006165 )
	    ;;
	151 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007001 007002 007003 007004 007005 007006 007007 007008 007009 007010 007011 )
	    ;;
	152 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007012 007013 007014 007015 007016 007017 007018 007019 007020 007021 007022 )
	    ;;
	153 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007023 007024 007025 007026 007027 007028 007029 007030 )
	    ;;
	154 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007031 007032 007033 007034 007035 007036 007037 )
	    ;;
	155 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007038 007039 007040 007041 007042 007043 )
	    ;;
	156 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007044 007045 007046 007047 007048 007049 007050 007051 )
	    ;;
	157 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007052 007053 007054 007055 007056 007057 )
	    ;;
	158 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007058 007059 007060 007061 007062 007063 007064 007065 007066 007067 )
	    ;;
	159 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007068 007069 007070 007071 007072 007073 )
	    ;;
	160 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007074 007075 007076 007077 007078 007079 007080 007081 )
	    ;;
	161 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007082 007083 007084 007085 007086 007087 )
	    ;;
	162 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007088 007089 007090 007091 007092 007093 007094 007095 )
	    ;;
	163 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007096 007097 007098 007099 007100 007101 007102 007103 007104 )
	    ;;
	164 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007105 007106 007107 007108 007109 007110 007111 007112 007113 007114 007115 007116 007117 007118 007119 007120 )
	    ;;
	165 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007121 007122 007123 007124 007125 007126 007127 007128 007129 007130 )
	    ;;
	166 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007131 007132 007133 007134 007135 007136 007137 )
	    ;;
	167 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007138 007139 007140 007141 007142 007143 )
	    ;;
	168 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007144 007145 007146 007147 007148 007149 )
	    ;;
	169 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007150 007151 007152 007153 007154 007155 )
	    ;;
	170 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007156 007157 007158 007159 )
	    ;;
	171 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007160 007161 007162 007163 )
	    ;;
	172 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007164 007165 007166 007167 007168 007169 007170 )
	    ;;
	173 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007171 007172 007173 007174 007175 007176 007177 007178 )
	    ;;
	174 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007179 007180 007181 007182 007183 007184 007185 007186 007187 )
	    ;;
	175 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007188 007189 007190 007191 007192 007193 007194 007195 )
	    ;;
	176 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 007196 007197 007198 007199 007200 007201 007202 007203 007204 007205 007206 )
	    ;;
	177 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 008001 008002 008003 008004 008005 008006 008007 008008 )
	    ;;
	178 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 008009 008010 008011 008012 008013 008014 008015 008016 )
	    ;;
	179 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 008017 008018 008019 008020 008021 008022 008023 008024 008025 )
	    ;;
	180 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 008026 008027 008028 008029 008030 008031 008032 008033 )
	    ;;
	181 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 008034 008035 008036 008037 008038 008039 008040 )
	    ;;
	182 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 008041 008042 008043 008044 008045 )
	    ;;
	183 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 008046 008047 008048 008049 008050 008051 008052 )
	    ;;
	184 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 008053 008054 008055 008056 008057 008058 008059 008060 008061 )
	    ;;
	185 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 008062 008063 008064 008065 008066 008067 008068 008069 )
	    ;;
	186 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 008070 008071 008072 008073 008074 008075 )
	    ;;
	187 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 009001 009002 009003 009004 009005 009006 )
	    ;;
	188 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 009007 009008 009009 009010 009011 009012 009013 )
	    ;;
	189 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 009014 009015 009016 009017 009018 009019 009020 )
	    ;;
	190 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 009021 009022 009023 009024 009025 009026 )
	    ;;
	191 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 009027 009028 009029 009030 009031 )
	    ;;
	192 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 009032 009033 009034 009035 009036 )
	    ;;
	193 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 009037 009038 009039 009040 )
	    ;;
	194 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 009041 009042 009043 009044 009045 009046 009047 )
	    ;;
	195 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 009048 009049 009050 009051 009052 009053 009054 )
	    ;;
	196 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 009055 009056 009057 009058 009059 009060 009061 )
	    ;;
	197 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 009062 009063 009064 009065 009066 009067 009068 )
	    ;;
	198 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 009069 009070 009071 009072 )
	    ;;
	199 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 009073 009074 009075 009076 009077 009078 009079 )
	    ;;
	200 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 009080 009081 009082 009083 009084 009085 009086 )
	    ;;
	201 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 009087 009088 009089 009090 009091 009092 009093 )
	    ;;
	202 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 009094 009095 009096 009097 009098 009099 )
	    ;;
	203 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 009100 009101 009102 009103 009104 009105 009106 )
	    ;;
	204 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 009107 009108 009109 009110 009111 )
	    ;;
	205 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 009112 009113 009114 009115 009116 009117 )
	    ;;
	206 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 009118 009119 009120 009121 009122 )
	    ;;
	207 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 009123 009124 009125 009126 009127 009128 009129 )
	    ;;
	208 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 010001 010002 010003 010004 010005 010006 )
	    ;;
	209 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 010007 010008 010009 010010 010011 010012 010013 010014 )
	    ;;
	210 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 010015 010016 010017 010018 010019 010020 )
	    ;;
	211 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 010021 010022 010023 010024 010025 )
	    ;;
	212 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 010026 010027 010028 010029 010030 010031 010032 010033 )
	    ;;
	213 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 010034 010035 010036 010037 010038 010039 010040 010041 010042 )
	    ;;
	214 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 010043 010044 010045 010046 010047 010048 010049 010050 010051 010052 010053 )
	    ;;
	215 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 010054 010055 010056 010057 010058 010059 010060 010061 )
	    ;;
	216 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 010062 010063 010064 010065 010066 010067 010068 010069 010070 )
	    ;;
	217 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 010071 010072 010073 010074 010075 010076 010077 010078 )
	    ;;
	218 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 010079 010080 010081 010082 010083 010084 010085 010086 010087 010088 )
	    ;;
	219 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 010089 010090 010091 010092 010093 010094 010095 010096 010097 )
	    ;;
	220 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 010098 010099 010100 010101 010102 010103 010104 010105 010106 )
	    ;;
	221 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 010107 010108 010109 011001 011002 011003 011004 011005 )
	    ;;
	222 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 011006 011007 011008 011009 011010 011011 011012 )
	    ;;
	223 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 011013 011014 011015 011016 011017 011018 011019 )
	    ;;
	224 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 011020 011021 011022 011023 011024 011025 011026 011027 011028 )
	    ;;
	225 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 011029 011030 011031 011032 011033 011034 011035 011036 011037 )
	    ;;
	226 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 011038 011039 011040 011041 011042 011043 011044 011045 )
	    ;;
	227 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 011046 011047 011048 011049 011050 011051 011052 011053 )
	    ;;
	228 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 011054 011055 011056 011057 011058 011059 011060 011061 011062 )
	    ;;
	229 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 011063 011064 011065 011066 011067 011068 011069 011070 011071 )
	    ;;
	230 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 011072 011073 011074 011075 011076 011077 011078 011079 011080 011081 )
	    ;;
	231 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 011082 011083 011084 011085 011086 011087 011088 )
	    ;;
	232 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 011089 011090 011091 011092 011093 011094 011095 011096 011097 )
	    ;;
	233 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 011098 011099 011100 011101 011102 011103 011104 011105 011106 011107 011108 )
	    ;;
	234 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 011109 011110 011111 011112 011113 011114 011115 011116 011117 )
	    ;;
	235 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 011118 011119 011120 011121 011122 011123 012001 012002 012003 012004 )
	    ;;
	236 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 012005 012006 012007 012008 012009 012010 012011 012012 012013 012014 )
	    ;;
	237 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 012015 012016 012017 012018 012019 012020 012021 012022 )
	    ;;
	238 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 012023 012024 012025 012026 012027 012028 012029 012030 )
	    ;;
	239 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 012031 012032 012033 012034 012035 012036 012037 )
	    ;;
	240 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 012038 012039 012040 012041 012042 012043 )
	    ;;
	241 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 012044 012045 012046 012047 012048 012049 012050 012051 012052 )
	    ;;
	242 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 012053 012054 012055 012056 012057 012058 012059 012060 012061 012062 012063 )
	    ;;
	243 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 012064 012065 012066 012067 012068 012069 )
	    ;;
	244 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 012070 012071 012072 012073 012074 012075 012076 012077 012078 )
	    ;;
	245 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 012079 012080 012081 012082 012083 012084 012085 012086 )
	    ;;
	246 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 012087 012088 012089 012090 012091 012092 012093 012094 012095 )
	    ;;
	247 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 012096 012097 012098 012099 012100 012101 012102 012103 )
	    ;;
	248 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 012104 012105 012106 012107 012108 012109 012110 012111 )
	    ;;
	249 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 013001 013002 013003 013004 013005 )
	    ;;
	250 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 013006 013007 013008 013009 013010 013011 013012 013013 )
	    ;;
	251 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 013014 013015 013016 013017 013018 )
	    ;;
	252 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 013019 013020 013021 013022 013023 013024 013025 013026 013027 013028 )
	    ;;
	253 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 013029 013030 013031 013032 013033 013034 )
	    ;;
	254 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 013035 013036 013037 013038 013039 013040 013041 013042 )
	    ;;
	255 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 013043 014001 014002 014003 014004 014005 )
	    ;;
	256 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 014006 014007 014008 014009 014010 )
	    ;;
	257 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 014011 014012 014013 014014 014015 014016 014017 014018 )
	    ;;
	258 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 014019 014020 014021 014022 014023 014024 )
	    ;;
	259 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 014025 014026 014027 014028 014029 014030 014031 014032 014033 )
	    ;;
	260 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 014034 014035 014036 014037 014038 014039 014040 014041 014042 )
	    ;;
	261 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 014043 014044 014045 014046 014047 014048 014049 014050 014051 014052 )
	    ;;
	262 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 015001 015002 015003 015004 015005 015006 015007 015008 015009 015010 015011 015012 015013 015014 015015 )
	    ;;
	263 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 015016 015017 015018 015019 015020 015021 015022 015023 015024 015025 015026 015027 015028 015029 015030 015031 )
	    ;;
	264 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 015032 015033 015034 015035 015036 015037 015038 015039 015040 015041 015042 015043 015044 015045 015046 015047 015048 015049 015050 015051 )
	    ;;
	265 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 015052 015053 015054 015055 015056 015057 015058 015059 015060 015061 015062 015063 015064 015065 015066 015067 015068 015069 015070 )
	    ;;
	266 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 015071 015072 015073 015074 015075 015076 015077 015078 015079 015080 015081 015082 015083 015084 015085 015086 015087 015088 015089 015090 )
	    ;;
	267 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 015091 015092 015093 015094 015095 015096 015097 015098 015099 016001 016002 016003 016004 016005 016006 )
	    ;;
	268 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 016007 016008 016009 016010 016011 016012 016013 016014 )
	    ;;
	269 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 016015 016016 016017 016018 016019 016020 016021 016022 016023 016024 016025 016026 )
	    ;;
	270 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 016027 016028 016029 016030 016031 016032 016033 016034 )
	    ;;
	271 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 016035 016036 016037 016038 016039 016040 016041 016042 )
	    ;;
	272 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 016043 016044 016045 016046 016047 016048 016049 016050 016051 016052 016053 016054 )
	    ;;
	273 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 016055 016056 016057 016058 016059 016060 016061 016062 016063 016064 )
	    ;;
	274 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 016065 016066 016067 016068 016069 016070 016071 016072 )
	    ;;
	275 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 016073 016074 016075 016076 016077 016078 016079 )
	    ;;
	276 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 016080 016081 016082 016083 016084 016085 016086 016087 )
	    ;;
	277 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 016088 016089 016090 016091 016092 016093 )
	    ;;
	278 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 016094 016095 016096 016097 016098 016099 016100 016101 016102 )
	    ;;
	279 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 016103 016104 016105 016106 016107 016108 016109 016110 )
	    ;;
	280 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 016111 016112 016113 016114 016115 016116 016117 016118 )
	    ;;
	281 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 016119 016120 016121 016122 016123 016124 016125 016126 016127 016128 )
	    ;;
	282 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 017001 017002 017003 017004 017005 017006 017007 )
	    ;;
	283 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 017008 017009 017010 017011 017012 017013 017014 017015 017016 017017 )
	    ;;
	284 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 017018 017019 017020 017021 017022 017023 017024 017025 017026 017027 )
	    ;;
	285 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 017028 017029 017030 017031 017032 017033 017034 017035 017036 017037 017038 )
	    ;;
	286 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 017039 017040 017041 017042 017043 017044 017045 017046 017047 017048 017049 )
	    ;;
	287 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 017050 017051 017052 017053 017054 017055 017056 017057 017058 )
	    ;;
	288 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 017059 017060 017061 017062 017063 017064 017065 017066 )
	    ;;
	289 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 017067 017068 017069 017070 017071 017072 017073 017074 017075 )
	    ;;
	290 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 017076 017077 017078 017079 017080 017081 017082 017083 017084 017085 017086 )
	    ;;
	291 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 017087 017088 017089 017090 017091 017092 017093 017094 017095 017096 )
	    ;;
	292 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 017097 017098 017099 017100 017101 017102 017103 017104 )
	    ;;
	293 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 017105 017106 017107 017108 017109 017110 017111 018001 018002 018003 018004 )
	    ;;
	294 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 018005 018006 018007 018008 018009 018010 018011 018012 018013 018014 018015 )
	    ;;
	295 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 018016 018017 018018 018019 018020 )
	    ;;
	296 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 018021 018022 018023 018024 018025 018026 018027 )
	    ;;
	297 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 018028 018029 018030 018031 018032 018033 018034 )
	    ;;
	298 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 018035 018036 018037 018038 018039 018040 018041 018042 018043 018044 018045 )
	    ;;
	299 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 018046 018047 018048 018049 018050 018051 018052 018053 )
	    ;;
	300 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 018054 018055 018056 018057 018058 018059 018060 018061 )
	    ;;
	301 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 018062 018063 018064 018065 018066 018067 018068 018069 018070 018071 018072 018073 018074 )
	    ;;
	302 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 018075 018076 018077 018078 018079 018080 018081 018082 018083 )
	    ;;
	303 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 018084 018085 018086 018087 018088 018089 018090 018091 018092 018093 018094 018095 018096 018097 )
	    ;;
	304 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 018098 018099 018100 018101 018102 018103 018104 018105 018106 018107 018108 018109 018110 )
	    ;;
	305 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 019001 019002 019003 019004 019005 019006 019007 019008 019009 019010 019011 )
	    ;;
	306 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 019012 019013 019014 019015 019016 019017 019018 019019 019020 019021 019022 019023 019024 019025 )
	    ;;
	307 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 019026 019027 019028 019029 019030 019031 019032 019033 019034 019035 019036 019037 019038 )
	    ;;
	308 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 019039 019040 019041 019042 019043 019044 019045 019046 019047 019048 019049 019050 019051 )
	    ;;
	309 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 019052 019053 019054 019055 019056 019057 019058 019059 019060 019061 019062 019063 019064 )
	    ;;
	310 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 019065 019066 019067 019068 019069 019070 019071 019072 019073 019074 019075 019076 )
	    ;;
	311 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 019077 019078 019079 019080 019081 019082 019083 019084 019085 019086 019087 019088 019089 019090 019091 019092 019093 019094 019095 )
	    ;;
	312 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 019096 019097 019098 020001 020002 020003 020004 020005 020006 020007 020008 020009 020010 020011 020012 )
	    ;;
	313 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 020013 020014 020015 020016 020017 020018 020019 020020 020021 020022 020023 020024 020025 020026 020027 020028 020029 020030 020031 020032 020033 020034 020035 020036 020037 )
	    ;;
	314 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 020038 020039 020040 020041 020042 020043 020044 020045 020046 020047 020048 020049 020050 020051 )
	    ;;
	315 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 020052 020053 020054 020055 020056 020057 020058 020059 020060 020061 020062 020063 020064 )
	    ;;
	316 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 020065 020066 020067 020068 020069 020070 020071 020072 020073 020074 020075 020076 )
	    ;;
	317 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 020077 020078 020079 020080 020081 020082 020083 020084 020085 020086 020087 )
	    ;;
	318 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 020088 020089 020090 020091 020092 020093 020094 020095 020096 020097 020098 )
	    ;;
	319 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 020099 020100 020101 020102 020103 020104 020105 020106 020107 020108 020109 020110 020111 020112 020113 )
	    ;;
	320 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 020114 020115 020116 020117 020118 020119 020120 020121 020122 020123 020124 020125 )
	    ;;
	321 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 020126 020127 020128 020129 020130 020131 020132 020133 020134 020135 )
	    ;;
	322 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 021001 021002 021003 021004 021005 021006 021007 021008 021009 021010 )
	    ;;
	323 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 021011 021012 021013 021014 021015 021016 021017 021018 021019 021020 021021 021022 021023 021024 )
	    ;;
	324 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 021025 021026 021027 021028 021029 021030 021031 021032 021033 021034 021035 )
	    ;;
	325 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 021036 021037 021038 021039 021040 021041 021042 021043 021044 )
	    ;;
	326 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 021045 021046 021047 021048 021049 021050 021051 021052 021053 021054 021055 021056 021057 )
	    ;;
	327 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 021058 021059 021060 021061 021062 021063 021064 021065 021066 021067 021068 021069 021070 021071 021072 )
	    ;;
	328 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 021073 021074 021075 021076 021077 021078 021079 021080 021081 )
	    ;;
	329 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 021082 021083 021084 021085 021086 021087 021088 021089 021090 )
	    ;;
	330 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 021091 021092 021093 021094 021095 021096 021097 021098 021099 021100 021101 )
	    ;;
	331 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 021102 021103 021104 021105 021106 021107 021108 021109 021110 021111 021112 )
	    ;;
	332 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 022001 022002 022003 022004 022005 )
	    ;;
	333 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 022006 022007 022008 022009 022010 022011 022012 022013 022014 022015 )
	    ;;
	334 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 022016 022017 022018 022019 022020 022021 022022 022023 )
	    ;;
	335 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 022024 022025 022026 022027 022028 022029 022030 )
	    ;;
	336 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 022031 022032 022033 022034 022035 022036 022037 022038 )
	    ;;
	337 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 022039 022040 022041 022042 022043 022044 022045 022046 )
	    ;;
	338 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 022047 022048 022049 022050 022051 022052 022053 022054 022055 )
	    ;;
	339 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 022056 022057 022058 022059 022060 022061 022062 022063 022064 )
	    ;;
	340 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 022065 022066 022067 022068 022069 022070 022071 022072 )
	    ;;
	341 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 022073 022074 022075 022076 022077 022078 )
	    ;;
	342 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 023001 023002 023003 023004 023005 023006 023007 023008 023009 023010 023011 023012 023013 023014 023015 023016 023017 )
	    ;;
	343 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 023018 023019 023020 023021 023022 023023 023024 023025 023026 023027 )
	    ;;
	344 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 023028 023029 023030 023031 023032 023033 023034 023035 023036 023037 023038 023039 023040 023041 023042 )
	    ;;
	345 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 023043 023044 023045 023046 023047 023048 023049 023050 023051 023052 023053 023054 023055 023056 023057 023058 023059 )
	    ;;
	346 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 023060 023061 023062 023063 023064 023065 023066 023067 023068 023069 023070 023071 023072 023073 023074 )
	    ;;
	347 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 023075 023076 023077 023078 023079 023080 023081 023082 023083 023084 023085 023086 023087 023088 023089 )
	    ;;
	348 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 023090 023091 023092 023093 023094 023095 023096 023097 023098 023099 023100 023101 023102 023103 023104 )
	    ;;
	349 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 023105 023106 023107 023108 023109 023110 023111 023112 023113 023114 023115 023116 023117 023118 )
	    ;;
	350 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 024001 024002 024003 024004 024005 024006 024007 024008 024009 024010 )
	    ;;
	351 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 024011 024012 024013 024014 024015 024016 024017 024018 024019 024020 )
	    ;;
	352 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 024021 024022 024023 024024 024025 024026 024027 )
	    ;;
	353 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 024028 024029 024030 024031 )
	    ;;
	354 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 024032 024033 024034 024035 024036 )
	    ;;
	355 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 024037 024038 024039 024040 024041 024042 024043 )
	    ;;
	356 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 024044 024045 024046 024047 024048 024049 024050 024051 024052 024053 )
	    ;;
	357 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 024054 024055 024056 024057 024058 )
	    ;;
	358 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 024059 024060 024061 )
	    ;;
	359 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 024062 024063 024064 025001 025002 )
	    ;;
	360 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 025003 025004 025005 025006 025007 025008 025009 025010 025011 )
	    ;;
	361 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 025012 025013 025014 025015 025016 025017 025018 025019 025020 )
	    ;;
	362 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 025021 025022 025023 025024 025025 025026 025027 025028 025029 025030 025031 025032 )
	    ;;
	363 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 025033 025034 025035 025036 025037 025038 025039 025040 025041 025042 025043 )
	    ;;
	364 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 025044 025045 025046 025047 025048 025049 025050 025051 025052 025053 025054 025055 )
	    ;;
	365 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 025056 025057 025058 025059 025060 025061 025062 025063 025064 025065 025066 025067 )
	    ;;
	366 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 025068 025069 025070 025071 025072 025073 025074 025075 025076 025077 )
	    ;;
	367 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 026001 026002 026003 026004 026005 026006 026007 026008 026009 026010 026011 026012 026013 026014 026015 026016 026017 026018 026019 )
	    ;;
	368 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 026020 026021 026022 026023 026024 026025 026026 026027 026028 026029 026030 026031 026032 026033 026034 026035 026036 026037 026038 026039 )
	    ;;
	369 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 026040 026041 026042 026043 026044 026045 026046 026047 026048 026049 026050 026051 026052 026053 026054 026055 026056 026057 026058 026059 026060 )
	    ;;
	370 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 026061 026062 026063 026064 026065 026066 026067 026068 026069 026070 026071 026072 026073 026074 026075 026076 026077 026078 026079 026080 026081 026082 026083 )
	    ;;
	371 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 026084 026085 026086 026087 026088 026089 026090 026091 026092 026093 026094 026095 026096 026097 026098 026099 026100 026101 026102 026103 026104 026105 026106 026107 026108 026109 026110 026111 )
	    ;;
	372 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 026112 026113 026114 026115 026116 026117 026118 026119 026120 026121 026122 026123 026124 026125 026126 026127 026128 026129 026130 026131 026132 026133 026134 026135 026136 )
	    ;;
	373 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 026137 026138 026139 026140 026141 026142 026143 026144 026145 026146 026147 026148 026149 026150 026151 026152 026153 026154 026155 026156 026157 026158 026159 )
	    ;;
	374 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 026160 026161 026162 026163 026164 026165 026166 026167 026168 026169 026170 026171 026172 026173 026174 026175 026176 026177 026178 026179 026180 026181 026182 026183 )
	    ;;
	375 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 026184 026185 026186 026187 026188 026189 026190 026191 026192 026193 026194 026195 026196 026197 026198 026199 026200 026201 026202 026203 026204 026205 026206 )
	    ;;
	376 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 026207 026208 026209 026210 026211 026212 026213 026214 026215 026216 026217 026218 026219 026220 026221 026222 026223 026224 026225 026226 026227 )
	    ;;
	377 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 027001 027002 027003 027004 027005 027006 027007 027008 027009 027010 027011 027012 027013 )
	    ;;
	378 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 027014 027015 027016 027017 027018 027019 027020 027021 027022 )
	    ;;
	379 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 027023 027024 027025 027026 027027 027028 027029 027030 027031 027032 027033 027034 027035 )
	    ;;
	380 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 027036 027037 027038 027039 027040 027041 027042 027043 027044 )
	    ;;
	381 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 027045 027046 027047 027048 027049 027050 027051 027052 027053 027054 027055 )
	    ;;
	382 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 027056 027057 027058 027059 027060 027061 027062 027063 )
	    ;;
	383 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 027064 027065 027066 027067 027068 027069 027070 027071 027072 027073 027074 027075 027076 )
	    ;;
	384 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 027077 027078 027079 027080 027081 027082 027083 027084 027085 027086 027087 027088 )
	    ;;
	385 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 027089 027090 027091 027092 027093 028001 028002 028003 028004 028005 )
	    ;;
	386 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 028006 028007 028008 028009 028010 028011 028012 028013 )
	    ;;
	387 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 028014 028015 028016 028017 028018 028019 028020 028021 )
	    ;;
	388 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 028022 028023 028024 028025 028026 028027 028028 )
	    ;;
	389 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 028029 028030 028031 028032 028033 028034 028035 )
	    ;;
	390 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 028036 028037 028038 028039 028040 028041 028042 028043 )
	    ;;
	391 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 028044 028045 028046 028047 028048 028049 028050 )
	    ;;
	392 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 028051 028052 028053 028054 028055 028056 028057 028058 028059 )
	    ;;
	393 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 028060 028061 028062 028063 028064 028065 028066 028067 028068 028069 028070 )
	    ;;
	394 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 028071 028072 028073 028074 028075 028076 028077 )
	    ;;
	395 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 028078 028079 028080 028081 028082 028083 028084 )
	    ;;
	396 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 028085 028086 028087 028088 029001 029002 029003 029004 029005 029006 )
	    ;;
	397 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 029007 029008 029009 029010 029011 029012 029013 029014 )
	    ;;
	398 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 029015 029016 029017 029018 029019 029020 029021 029022 029023 )
	    ;;
	399 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 029024 029025 029026 029027 029028 029029 029030 )
	    ;;
	400 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 029031 029032 029033 029034 029035 029036 029037 029038 )
	    ;;
	401 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 029039 029040 029041 029042 029043 029044 029045 )
	    ;;
	402 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 029046 029047 029048 029049 029050 029051 029052 )
	    ;;
	403 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 029053 029054 029055 029056 029057 029058 029059 029060 029061 029062 029063 )
	    ;;
	404 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 029064 029065 029066 029067 029068 029069 030001 030002 030003 030004 030005 )
	    ;;
	405 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 030006 030007 030008 030009 030010 030011 030012 030013 030014 030015 )
	    ;;
	406 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 030016 030017 030018 030019 030020 030021 030022 030023 030024 )
	    ;;
	407 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 030025 030026 030027 030028 030029 030030 030031 030032 )
	    ;;
	408 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 030033 030034 030035 030036 030037 030038 030039 030040 030041 )
	    ;;
	409 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 030042 030043 030044 030045 030046 030047 030048 030049 030050 )
	    ;;
	410 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 030051 030052 030053 030054 030055 030056 030057 030058 030059 030060 )
	    ;;
	411 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 031001 031002 031003 031004 031005 031006 031007 031008 031009 031010 031011 )
	    ;;
	412 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 031012 031013 031014 031015 031016 031017 031018 031019 )
	    ;;
	413 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 031020 031021 031022 031023 031024 031025 031026 031027 031028 )
	    ;;
	414 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 031029 031030 031031 031032 031033 031034 )
	    ;;
	415 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 032001 032002 032003 032004 032005 032006 032007 032008 032009 032010 032011 )
	    ;;
	416 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 032012 032013 032014 032015 032016 032017 032018 032019 032020 )
	    ;;
	417 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 032021 032022 032023 032024 032025 032026 032027 032028 032029 032030 )
	    ;;
	418 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 033001 033002 033003 033004 033005 033006 )
	    ;;
	419 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 033007 033008 033009 033010 033011 033012 033013 033014 033015 )
	    ;;
	420 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 033016 033017 033018 033019 033020 033021 033022 )
	    ;;
	421 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 033023 033024 033025 033026 033027 033028 033029 033030 )
	    ;;
	422 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 033031 033032 033033 033034 033035 )
	    ;;
	423 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 033036 033037 033038 033039 033040 033041 033042 033043 )
	    ;;
	424 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 033044 033045 033046 033047 033048 033049 033050 )
	    ;;
	425 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 033051 033052 033053 033054 )
	    ;;
	426 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 033055 033056 033057 033058 033059 033060 033061 033062 )
	    ;;
	427 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 033063 033064 033065 033066 033067 033068 033069 033070 033071 033072 033073 )
	    ;;
	428 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 034001 034002 034003 034004 034005 034006 034007 )
	    ;;
	429 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 034008 034009 034010 034011 034012 034013 034014 )
	    ;;
	430 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 034015 034016 034017 034018 034019 034020 034021 034022 )
	    ;;
	431 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 034023 034024 034025 034026 034027 034028 034029 034030 034031 )
	    ;;
	432 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 034032 034033 034034 034035 034036 034037 034038 034039 )
	    ;;
	433 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 034040 034041 034042 034043 034044 034045 034046 034047 034048 )
	    ;;
	434 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 034049 034050 034051 034052 034053 034054 035001 035002 035003 )
	    ;;
	435 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 035004 035005 035006 035007 035008 035009 035010 035011 )
	    ;;
	436 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 035012 035013 035014 035015 035016 035017 035018 )
	    ;;
	437 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 035019 035020 035021 035022 035023 035024 035025 035026 035027 035028 035029 035030 )
	    ;;
	438 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 035031 035032 035033 035034 035035 035036 035037 035038 )
	    ;;
	439 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 035039 035040 035041 035042 035043 035044 )
	    ;;
	440 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 035045 036001 036002 036003 036004 036005 036006 036007 036008 036009 036010 036011 036012 )
	    ;;
	441 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 036013 036014 036015 036016 036017 036018 036019 036020 036021 036022 036023 036024 036025 036026 036027 )
	    ;;
	442 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 036028 036029 036030 036031 036032 036033 036034 036035 036036 036037 036038 036039 036040 )
	    ;;
	443 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 036041 036042 036043 036044 036045 036046 036047 036048 036049 036050 036051 036052 036053 036054 )
	    ;;
	444 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 036055 036056 036057 036058 036059 036060 036061 036062 036063 036064 036065 036066 036067 036068 036069 036070 )
	    ;;
	445 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 036071 036072 036073 036074 036075 036076 036077 036078 036079 036080 036081 036082 036083 )
	    ;;
	446 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 037001 037002 037003 037004 037005 037006 037007 037008 037009 037010 037011 037012 037013 037014 037015 037016 037017 037018 037019 037020 037021 037022 037023 037024 )
	    ;;
	447 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 037025 037026 037027 037028 037029 037030 037031 037032 037033 037034 037035 037036 037037 037038 037039 037040 037041 037042 037043 037044 037045 037046 037047 037048 037049 037050 037051 )
	    ;;
	448 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 037052 037053 037054 037055 037056 037057 037058 037059 037060 037061 037062 037063 037064 037065 037066 037067 037068 037069 037070 037071 037072 037073 037074 037075 037076 )
	    ;;
	449 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 037077 037078 037079 037080 037081 037082 037083 037084 037085 037086 037087 037088 037089 037090 037091 037092 037093 037094 037095 037096 037097 037098 037099 037100 037101 037102 )
	    ;;
	450 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 037103 037104 037105 037106 037107 037108 037109 037110 037111 037112 037113 037114 037115 037116 037117 037118 037119 037120 037121 037122 037123 037124 037125 037126 )
	    ;;
	451 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 037127 037128 037129 037130 037131 037132 037133 037134 037135 037136 037137 037138 037139 037140 037141 037142 037143 037144 037145 037146 037147 037148 037149 037150 037151 037152 037153 )
	    ;;
	452 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 037154 037155 037156 037157 037158 037159 037160 037161 037162 037163 037164 037165 037166 037167 037168 037169 037170 037171 037172 037173 037174 037175 037176 037177 037178 037179 037180 037181 037182 )
	    ;;
	453 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 038001 038002 038003 038004 038005 038006 038007 038008 038009 038010 038011 038012 038013 038014 038015 038016 )
	    ;;
	454 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 038017 038018 038019 038020 038021 038022 038023 038024 038025 038026 )
	    ;;
	455 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 038027 038028 038029 038030 038031 038032 038033 038034 038035 038036 038037 038038 038039 038040 038041 038042 )
	    ;;
	456 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 038043 038044 038045 038046 038047 038048 038049 038050 038051 038052 038053 038054 038055 038056 038057 038058 038059 038060 038061 )
	    ;;
	457 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 038062 038063 038064 038065 038066 038067 038068 038069 038070 038071 038072 038073 038074 038075 038076 038077 038078 038079 038080 038081 038082 038083 )
	    ;;
	458 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 038084 038085 038086 038087 038088 039001 039002 039003 039004 039005 )
	    ;;
	459 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 039006 039007 039008 039009 039010 )
	    ;;
	460 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 039011 039012 039013 039014 039015 039016 039017 039018 039019 039020 039021 )
	    ;;
	461 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 039022 039023 039024 039025 039026 039027 039028 039029 039030 039031 )
	    ;;
	462 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 039032 039033 039034 039035 039036 039037 039038 039039 039040 )
	    ;;
	463 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 039041 039042 039043 039044 039045 039046 039047 )
	    ;;
	464 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 039048 039049 039050 039051 039052 039053 039054 039055 039056 )
	    ;;
	465 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 039057 039058 039059 039060 039061 039062 039063 039064 039065 039066 039067 )
	    ;;
	466 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 039068 039069 039070 039071 039072 039073 039074 )
	    ;;
	467 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 039075 040001 040002 040003 040004 040005 040006 040007 )
	    ;;
	468 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 040008 040009 040010 040011 040012 040013 040014 040015 040016 )
	    ;;
	469 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 040017 040018 040019 040020 040021 040022 040023 040024 040025 )
	    ;;
	470 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 040026 040027 040028 040029 040030 040031 040032 040033 )
	    ;;
	471 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 040034 040035 040036 040037 040038 040039 040040 )
	    ;;
	472 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 040041 040042 040043 040044 040045 040046 040047 040048 040049 )
	    ;;
	473 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 040050 040051 040052 040053 040054 040055 040056 040057 040058 )
	    ;;
	474 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 040059 040060 040061 040062 040063 040064 040065 040066 )
	    ;;
	475 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 040067 040068 040069 040070 040071 040072 040073 040074 040075 040076 040077 )
	    ;;
	476 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 040078 040079 040080 040081 040082 040083 040084 040085 )
	    ;;
	477 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 041001 041002 041003 041004 041005 041006 041007 041008 041009 041010 041011 )
	    ;;
	478 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 041012 041013 041014 041015 041016 041017 041018 041019 041020 )
	    ;;
	479 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 041021 041022 041023 041024 041025 041026 041027 041028 041029 )
	    ;;
	480 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 041030 041031 041032 041033 041034 041035 041036 041037 041038 )
	    ;;
	481 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 041039 041040 041041 041042 041043 041044 041045 041046 )
	    ;;
	482 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 041047 041048 041049 041050 041051 041052 041053 041054 )
	    ;;
	483 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 042001 042002 042003 042004 042005 042006 042007 042008 042009 042010 )
	    ;;
	484 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 042011 042012 042013 042014 042015 )
	    ;;
	485 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 042016 042017 042018 042019 042020 042021 042022 )
	    ;;
	486 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 042023 042024 042025 042026 042027 042028 042029 042030 042031 )
	    ;;
	487 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 042032 042033 042034 042035 042036 042037 042038 042039 042040 042041 042042 042043 042044 )
	    ;;
	488 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 042045 042046 042047 042048 042049 042050 042051 )
	    ;;
	489 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 042052 042053 043001 043002 043003 043004 043005 043006 043007 043008 043009 043010 )
	    ;;
	490 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 043011 043012 043013 043014 043015 043016 043017 043018 043019 043020 043021 043022 )
	    ;;
	491 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 043023 043024 043025 043026 043027 043028 043029 043030 043031 043032 043033 )
	    ;;
	492 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 043034 043035 043036 043037 043038 043039 043040 043041 043042 043043 043044 043045 043046 043047 )
	    ;;
	493 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 043048 043049 043050 043051 043052 043053 043054 043055 043056 043057 043058 043059 043060 )
	    ;;
	494 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 043061 043062 043063 043064 043065 043066 043067 043068 043069 043070 043071 043072 043073 )
	    ;;
	495 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 043074 043075 043076 043077 043078 043079 043080 043081 043082 043083 043084 043085 043086 043087 043088 043089 )
	    ;;
	496 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 044001 044002 044003 044004 044005 044006 044007 044008 044009 044010 044011 044012 044013 044014 044015 044016 044017 044018 )
	    ;;
	497 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 044019 044020 044021 044022 044023 044024 044025 044026 044027 044028 044029 044030 044031 044032 044033 044034 044035 044036 044037 044038 044039 )
	    ;;
	498 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 044040 044041 044042 044043 044044 044045 044046 044047 044048 044049 044050 044051 044052 044053 044054 044055 044056 044057 044058 044059 )
	    ;;
	499 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 045001 045002 045003 045004 045005 045006 045007 045008 045009 045010 045011 045012 045013 )
	    ;;
	500 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 045014 045015 045016 045017 045018 045019 045020 045021 045022 )
	    ;;
	501 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 045023 045024 045025 045026 045027 045028 045029 045030 045031 045032 )
	    ;;
	502 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 045033 045034 045035 045036 045037 046001 046002 046003 046004 046005 )
	    ;;
	503 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 046006 046007 046008 046009 046010 046011 046012 046013 046014 )
	    ;;
	504 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 046015 046016 046017 046018 046019 046020 )
	    ;;
	505 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 046021 046022 046023 046024 046025 046026 046027 046028 )
	    ;;
	506 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 046029 046030 046031 046032 046033 046034 046035 )
	    ;;
	507 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 047001 047002 047003 047004 047005 047006 047007 047008 047009 047010 047011 )
	    ;;
	508 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 047012 047013 047014 047015 047016 047017 047018 047019 )
	    ;;
	509 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 047020 047021 047022 047023 047024 047025 047026 047027 047028 047029 )
	    ;;
	510 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 047030 047031 047032 047033 047034 047035 047036 047037 047038 )
	    ;;
	511 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 048001 048002 048003 048004 048005 048006 048007 048008 048009 )
	    ;;
	512 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 048010 048011 048012 048013 048014 048015 )
	    ;;
	513 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 048016 048017 048018 048019 048020 048021 048022 048023 )
	    ;;
	514 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 048024 048025 048026 048027 048028 )
	    ;;
	515 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 048029 049001 049002 049003 049004 )
	    ;;
	516 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 049005 049006 049007 049008 049009 049010 049011 )
	    ;;
	517 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 049012 049013 049014 049015 049016 049017 049018 )
	    ;;
	518 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 050001 050002 050003 050004 050005 050006 050007 050008 050009 050010 050011 050012 050013 050014 050015 )
	    ;;
	519 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 050016 050017 050018 050019 050020 050021 050022 050023 050024 050025 050026 050027 050028 050029 050030 050031 050032 050033 050034 050035 )
	    ;;
	520 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 050036 050037 050038 050039 050040 050041 050042 050043 050044 050045 051001 051002 051003 051004 051005 051006 )
	    ;;
	521 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 051007 051008 051009 051010 051011 051012 051013 051014 051015 051016 051017 051018 051019 051020 051021 051022 051023 051024 051025 051026 051027 051028 051029 051030 )
	    ;;
	522 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 051031 051032 051033 051034 051035 051036 051037 051038 051039 051040 051041 051042 051043 051044 051045 051046 051047 051048 051049 051050 051051 )
	    ;;
	523 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 051052 051053 051054 051055 051056 051057 051058 051059 051060 052001 052002 052003 052004 052005 052006 052007 052008 052009 052010 052011 052012 052013 052014 )
	    ;;
	524 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 052015 052016 052017 052018 052019 052020 052021 052022 052023 052024 052025 052026 052027 052028 052029 052030 052031 )
	    ;;
	525 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 052032 052033 052034 052035 052036 052037 052038 052039 052040 052041 052042 052043 052044 052045 052046 052047 052048 052049 )
	    ;;
	526 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 053001 053002 053003 053004 053005 053006 053007 053008 053009 053010 053011 053012 053013 053014 053015 053016 053017 053018 053019 053020 053021 053022 053023 053024 053025 053026 )
	    ;;
	527 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 053027 053028 053029 053030 053031 053032 053033 053034 053035 053036 053037 053038 053039 053040 053041 053042 053043 053044 )
	    ;;
	528 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 053045 053046 053047 053048 053049 053050 053051 053052 053053 053054 053055 053056 053057 053058 053059 053060 053061 053062 054001 054002 054003 054004 054005 054006 )
	    ;;
	529 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 054007 054008 054009 054010 054011 054012 054013 054014 054015 054016 054017 054018 054019 054020 054021 054022 054023 054024 054025 054026 054027 )
	    ;;
	530 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 054028 054029 054030 054031 054032 054033 054034 054035 054036 054037 054038 054039 054040 054041 054042 054043 054044 054045 054046 054047 054048 054049 )
	    ;;
	531 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 054050 054051 054052 054053 054054 054055 055001 055002 055003 055004 055005 055006 055007 055008 055009 055010 055011 055012 055013 055014 055015 055016 )
	    ;;
	532 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 055017 055018 055019 055020 055021 055022 055023 055024 055025 055026 055027 055028 055029 055030 055031 055032 055033 055034 055035 055036 055037 055038 055039 055040 )
	    ;;
	533 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 055041 055042 055043 055044 055045 055046 055047 055048 055049 055050 055051 055052 055053 055054 055055 055056 055057 055058 055059 055060 055061 055062 055063 055064 055065 055066 055067 )
	    ;;
	534 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 055068 055069 055070 055071 055072 055073 055074 055075 055076 055077 055078 056001 056002 056003 056004 056005 056006 056007 056008 056009 056010 056011 056012 056013 056014 056015 056016 )
	    ;;
	535 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 056017 056018 056019 056020 056021 056022 056023 056024 056025 056026 056027 056028 056029 056030 056031 056032 056033 056034 056035 056036 056037 056038 056039 056040 056041 056042 056043 056044 056045 056046 056047 056048 056049 056050 )
	    ;;
	536 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 056051 056052 056053 056054 056055 056056 056057 056058 056059 056060 056061 056062 056063 056064 056065 056066 056067 056068 056069 056070 056071 056072 056073 056074 056075 056076 )
	    ;;
	537 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 056077 056078 056079 056080 056081 056082 056083 056084 056085 056086 056087 056088 056089 056090 056091 056092 056093 056094 056095 056096 057001 057002 057003 )
	    ;;
	538 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 057004 057005 057006 057007 057008 057009 057010 057011 )
	    ;;
	539 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 057012 057013 057014 057015 057016 057017 057018 )
	    ;;
	540 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 057019 057020 057021 057022 057023 057024 )
	    ;;
	541 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 057025 057026 057027 057028 057029 )
	    ;;
	542 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 058001 058002 058003 058004 058005 058006 )
	    ;;
	543 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 058007 058008 058009 058010 058011 )
	    ;;
	544 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 058012 058013 058014 058015 058016 058017 058018 058019 058020 058021 )
	    ;;
	545 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 058022 059001 059002 059003 )
	    ;;
	546 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 059004 059005 059006 059007 059008 059009 )
	    ;;
	547 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 059010 059011 059012 059013 059014 059015 059016 )
	    ;;
	548 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 059017 059018 059019 059020 059021 059022 059023 059024 )
	    ;;
	549 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 060001 060002 060003 060004 060005 )
	    ;;
	550 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 060006 060007 060008 060009 060010 060011 )
	    ;;
	551 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 060012 060013 061001 061002 061003 061004 061005 )
	    ;;
	552 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 061006 061007 061008 061009 061010 061011 061012 061013 061014 )
	    ;;
	553 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 062001 062002 062003 062004 062005 062006 062007 062008 )
	    ;;
	554 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 062009 062010 062011 063001 063002 063003 063004 )
	    ;;
	555 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 063005 063006 063007 063008 063009 063010 063011 )
	    ;;
	556 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 064001 064002 064003 064004 064005 064006 064007 064008 064009 )
	    ;;
	557 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 064010 064011 064012 064013 064014 064015 064016 064017 064018 )
	    ;;
	558 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 065001 065002 065003 065004 065005 )
	    ;;
	559 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 065006 065007 065008 065009 065010 065011 065012 )
	    ;;
	560 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 066001 066002 066003 066004 066005 066006 066007 )
	    ;;
	561 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 066008 066009 066010 066011 066012 )
	    ;;
	562 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 067001 067002 067003 067004 067005 067006 067007 067008 067009 067010 067011 067012 )
	    ;;
	563 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 067013 067014 067015 067016 067017 067018 067019 067020 067021 067022 067023 067024 067025 067026 )
	    ;;
	564 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 067027 067028 067029 067030 068001 068002 068003 068004 068005 068006 068007 068008 068009 068010 068011 068012 068013 068014 068015 )
	    ;;
	565 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 068016 068017 068018 068019 068020 068021 068022 068023 068024 068025 068026 068027 068028 068029 068030 068031 068032 068033 068034 068035 068036 068037 068038 068039 068040 068041 068042 )
	    ;;
	566 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 068043 068044 068045 068046 068047 068048 068049 068050 068051 068052 069001 069002 069003 069004 069005 069006 069007 069008 )
	    ;;
	567 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 069009 069010 069011 069012 069013 069014 069015 069016 069017 069018 069019 069020 069021 069022 069023 069024 069025 069026 069027 069028 069029 069030 069031 069032 069033 069034 )
	    ;;
	568 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 069035 069036 069037 069038 069039 069040 069041 069042 069043 069044 069045 069046 069047 069048 069049 069050 069051 069052 070001 070002 070003 070004 070005 070006 070007 070008 070009 070010 )
	    ;;
	569 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 070011 070012 070013 070014 070015 070016 070017 070018 070019 070020 070021 070022 070023 070024 070025 070026 070027 070028 070029 070030 070031 070032 070033 070034 070035 070036 070037 070038 070039 )
	    ;;
	570 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 070040 070041 070042 070043 070044 071001 071002 071003 071004 071005 071006 071007 071008 071009 071010 )
	    ;;
	571 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 071011 071012 071013 071014 071015 071016 071017 071018 071019 071020 071021 071022 071023 071024 071025 071026 071027 071028 )
	    ;;
	572 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 072001 072002 072003 072004 072005 072006 072007 072008 072009 072010 072011 072012 072013 )
	    ;;
	573 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 072014 072015 072016 072017 072018 072019 072020 072021 072022 072023 072024 072025 072026 072027 072028 )
	    ;;
	574 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 073001 073002 073003 073004 073005 073006 073007 073008 073009 073010 073011 073012 073013 073014 073015 073016 073017 073018 073019 )
	    ;;
	575 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 073020 074001 074002 074003 074004 074005 074006 074007 074008 074009 074010 074011 074012 074013 074014 074015 074016 074017 )
	    ;;
	576 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 074018 074019 074020 074021 074022 074023 074024 074025 074026 074027 074028 074029 074030 074031 074032 074033 074034 074035 074036 074037 074038 074039 074040 074041 074042 074043 074044 074045 074046 074047 )
	    ;;
	577 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 074048 074049 074050 074051 074052 074053 074054 074055 074056 075001 075002 075003 075004 075005 075006 075007 075008 075009 075010 075011 075012 075013 075014 075015 075016 075017 075018 075019 )
	    ;;
	578 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 075020 075021 075022 075023 075024 075025 075026 075027 075028 075029 075030 075031 075032 075033 075034 075035 075036 075037 075038 075039 075040 076001 076002 076003 076004 076005 )
	    ;;
	579 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 076006 076007 076008 076009 076010 076011 076012 076013 076014 076015 076016 076017 076018 076019 076020 076021 076022 076023 076024 076025 )
	    ;;
	580 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 076026 076027 076028 076029 076030 076031 077001 077002 077003 077004 077005 077006 077007 077008 077009 077010 077011 077012 077013 077014 077015 077016 077017 077018 077019 )
	    ;;
	581 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 077020 077021 077022 077023 077024 077025 077026 077027 077028 077029 077030 077031 077032 077033 077034 077035 077036 077037 077038 077039 077040 077041 077042 077043 077044 077045 077046 077047 077048 077049 077050 )
	    ;;
	582 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 078001 078002 078003 078004 078005 078006 078007 078008 078009 078010 078011 078012 078013 078014 078015 078016 078017 078018 078019 078020 078021 078022 078023 078024 078025 078026 078027 078028 078029 078030 )
	    ;;
	583 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 078031 078032 078033 078034 078035 078036 078037 078038 078039 078040 079001 079002 079003 079004 079005 079006 079007 079008 079009 079010 079011 079012 079013 079014 079015 )
	    ;;
	584 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 079016 079017 079018 079019 079020 079021 079022 079023 079024 079025 079026 079027 079028 079029 079030 079031 079032 079033 079034 079035 079036 079037 079038 079039 079040 079041 079042 079043 079044 079045 079046 )
	    ;;
	585 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 080001 080002 080003 080004 080005 080006 080007 080008 080009 080010 080011 080012 080013 080014 080015 080016 080017 080018 080019 080020 080021 080022 080023 080024 080025 080026 080027 080028 080029 080030 080031 080032 080033 080034 080035 080036 080037 080038 080039 080040 080041 080042 )
	    ;;
	586 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 081001 081002 081003 081004 081005 081006 081007 081008 081009 081010 081011 081012 081013 081014 081015 081016 081017 081018 081019 081020 081021 081022 081023 081024 081025 081026 081027 081028 081029 )
	    ;;
	587 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 082001 082002 082003 082004 082005 082006 082007 082008 082009 082010 082011 082012 082013 082014 082015 082016 082017 082018 082019 083001 083002 083003 083004 083005 083006 )
	    ;;
	588 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 083007 083008 083009 083010 083011 083012 083013 083014 083015 083016 083017 083018 083019 083020 083021 083022 083023 083024 083025 083026 083027 083028 083029 083030 083031 083032 083033 083034 )
	    ;;
	589 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 083035 083036 084001 084002 084003 084004 084005 084006 084007 084008 084009 084010 084011 084012 084013 084014 084015 084016 084017 084018 084019 084020 084021 084022 084023 084024 084025 )
	    ;;
	590 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 085001 085002 085003 085004 085005 085006 085007 085008 085009 085010 085011 085012 085013 085014 085015 085016 085017 085018 085019 085020 085021 085022 )
	    ;;
	591 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 086001 086002 086003 086004 086005 086006 086007 086008 086009 086010 086011 086012 086013 086014 086015 086016 086017 087001 087002 087003 087004 087005 087006 087007 087008 087009 087010 087011 087012 087013 087014 087015 )
	    ;;
	592 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 087016 087017 087018 087019 088001 088002 088003 088004 088005 088006 088007 088008 088009 088010 088011 088012 088013 088014 088015 088016 088017 088018 088019 088020 088021 088022 088023 088024 088025 088026 )
	    ;;
	593 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 089001 089002 089003 089004 089005 089006 089007 089008 089009 089010 089011 089012 089013 089014 089015 089016 089017 089018 089019 089020 089021 089022 089023 )
	    ;;
	594 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 089024 089025 089026 089027 089028 089029 089030 090001 090002 090003 090004 090005 090006 090007 090008 090009 090010 090011 090012 090013 090014 090015 090016 090017 090018 090019 090020 )
	    ;;
	595 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 091001 091002 091003 091004 091005 091006 091007 091008 091009 091010 091011 091012 091013 091014 091015 092001 092002 092003 092004 092005 092006 092007 092008 092009 092010 092011 092012 092013 092014 )
	    ;;
	596 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 092015 092016 092017 092018 092019 092020 092021 093001 093002 093003 093004 093005 093006 093007 093008 093009 093010 093011 094001 094002 094003 094004 094005 094006 094007 094008 )
	    ;;
	597 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 095001 095002 095003 095004 095005 095006 095007 095008 096001 096002 096003 096004 096005 096006 096007 096008 096009 096010 096011 096012 096013 096014 096015 096016 096017 096018 096019 )
	    ;;
	598 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 097001 097002 097003 097004 097005 098001 098002 098003 098004 098005 098006 098007 )
	    ;;
	599 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 098008 099001 099002 099003 099004 099005 099006 099007 099008 100001 100002 100003 100004 100005 100006 100007 100008 100009 )
	    ;;
	600 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 100010 100011 101001 101002 101003 101004 101005 101006 101007 101008 101009 101010 101011 102001 102002 102003 102004 102005 102006 102007 102008 )
	    ;;
	601 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 103001 103002 103003 104001 104002 104003 104004 104005 104006 104007 104008 104009 105001 105002 105003 105004 105005 )
	    ;;
	602 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 106001 106002 106003 106004 107001 107002 107003 107004 107005 107006 107007 108001 108002 108003 )
	    ;;
	603 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 109001 109002 109003 109004 109005 109006 110001 110002 110003 111001 111002 111003 111004 111005 )
	    ;;
	604 )
	    list_of_verses_that_belong_to_this_PAGE_NUMBER=( 112001 112002 112003 112004 113001 113002 113003 113004 113005 114001 114002 114003 114004 114005 114006 )
	    ;;
	* )
	    echo
	    echo "The value you entered is invalid!"
	    echo; exit
	    ;;
    esac
}


show_list_of_verses_that_belong_to_this_juz(){
    local juzNumber="$1"
    case "$juzNumber" in
	1 )
	    list_of_verses_that_belong_to_this_JUZ=( 001001 001002 001003 001004 001005 001006 001007 002001 002002 002003 002004 002005 002006 002007 002008 002009 002010 002011 002012 002013 002014 002015 002016 002017 002018 002019 002020 002021 002022 002023 002024 002025 002026 002027 002028 002029 002030 002031 002032 002033 002034 002035 002036 002037 002038 002039 002040 002041 002042 002043 002044 002045 002046 002047 002048 002049 002050 002051 002052 002053 002054 002055 002056 002057 002058 002059 002060 002061 002062 002063 002064 002065 002066 002067 002068 002069 002070 002071 002072 002073 002074 002075 002076 002077 002078 002079 002080 002081 002082 002083 002084 002085 002086 002087 002088 002089 002090 002091 002092 002093 002094 002095 002096 002097 002098 002099 002100 002101 002102 002103 002104 002105 002106 002107 002108 002109 002110 002111 002112 002113 002114 002115 002116 002117 002118 002119 002120 002121 002122 002123 002124 002125 002126 002127 002128 002129 002130 002131 002132 002133 002134 002135 002136 002137 002138 002139 002140 002141 )
	    ;;
	2 )
	    list_of_verses_that_belong_to_this_JUZ=( 002142 002143 002144 002145 002146 002147 002148 002149 002150 002151 002152 002153 002154 002155 002156 002157 002158 002159 002160 002161 002162 002163 002164 002165 002166 002167 002168 002169 002170 002171 002172 002173 002174 002175 002176 002177 002178 002179 002180 002181 002182 002183 002184 002185 002186 002187 002188 002189 002190 002191 002192 002193 002194 002195 002196 002197 002198 002199 002200 002201 002202 002203 002204 002205 002206 002207 002208 002209 002210 002211 002212 002213 002214 002215 002216 002217 002218 002219 002220 002221 002222 002223 002224 002225 002226 002227 002228 002229 002230 002231 002232 002233 002234 002235 002236 002237 002238 002239 002240 002241 002242 002243 002244 002245 002246 002247 002248 002249 002250 002251 002252 )
	    ;;
	3 )
	    list_of_verses_that_belong_to_this_JUZ=( 002253 002254 002255 002256 002257 002258 002259 002260 002261 002262 002263 002264 002265 002266 002267 002268 002269 002270 002271 002272 002273 002274 002275 002276 002277 002278 002279 002280 002281 002282 002283 002284 002285 002286 003001 003002 003003 003004 003005 003006 003007 003008 003009 003010 003011 003012 003013 003014 003015 003016 003017 003018 003019 003020 003021 003022 003023 003024 003025 003026 003027 003028 003029 003030 003031 003032 003033 003034 003035 003036 003037 003038 003039 003040 003041 003042 003043 003044 003045 003046 003047 003048 003049 003050 003051 003052 003053 003054 003055 003056 003057 003058 003059 003060 003061 003062 003063 003064 003065 003066 003067 003068 003069 003070 003071 003072 003073 003074 003075 003076 003077 003078 003079 003080 003081 003082 003083 003084 003085 003086 003087 003088 003089 003090 003091 003092 )
	    ;;
	4 )
	    list_of_verses_that_belong_to_this_JUZ=( 003093 003094 003095 003096 003097 003098 003099 003100 003101 003102 003103 003104 003105 003106 003107 003108 003109 003110 003111 003112 003113 003114 003115 003116 003117 003118 003119 003120 003121 003122 003123 003124 003125 003126 003127 003128 003129 003130 003131 003132 003133 003134 003135 003136 003137 003138 003139 003140 003141 003142 003143 003144 003145 003146 003147 003148 003149 003150 003151 003152 003153 003154 003155 003156 003157 003158 003159 003160 003161 003162 003163 003164 003165 003166 003167 003168 003169 003170 003171 003172 003173 003174 003175 003176 003177 003178 003179 003180 003181 003182 003183 003184 003185 003186 003187 003188 003189 003190 003191 003192 003193 003194 003195 003196 003197 003198 003199 003200 004001 004002 004003 004004 004005 004006 004007 004008 004009 004010 004011 004012 004013 004014 004015 004016 004017 004018 004019 004020 004021 004022 004023 )
	    ;;
	5 )
	    list_of_verses_that_belong_to_this_JUZ=( 004024 004025 004026 004027 004028 004029 004030 004031 004032 004033 004034 004035 004036 004037 004038 004039 004040 004041 004042 004043 004044 004045 004046 004047 004048 004049 004050 004051 004052 004053 004054 004055 004056 004057 004058 004059 004060 004061 004062 004063 004064 004065 004066 004067 004068 004069 004070 004071 004072 004073 004074 004075 004076 004077 004078 004079 004080 004081 004082 004083 004084 004085 004086 004087 004088 004089 004090 004091 004092 004093 004094 004095 004096 004097 004098 004099 004100 004101 004102 004103 004104 004105 004106 004107 004108 004109 004110 004111 004112 004113 004114 004115 004116 004117 004118 004119 004120 004121 004122 004123 004124 004125 004126 004127 004128 004129 004130 004131 004132 004133 004134 004135 004136 004137 004138 004139 004140 004141 004142 004143 004144 004145 004146 004147 )
	    ;;
	6 )
	    list_of_verses_that_belong_to_this_JUZ=( 004148 004149 004150 004151 004152 004153 004154 004155 004156 004157 004158 004159 004160 004161 004162 004163 004164 004165 004166 004167 004168 004169 004170 004171 004172 004173 004174 004175 004176 005001 005002 005003 005004 005005 005006 005007 005008 005009 005010 005011 005012 005013 005014 005015 005016 005017 005018 005019 005020 005021 005022 005023 005024 005025 005026 005027 005028 005029 005030 005031 005032 005033 005034 005035 005036 005037 005038 005039 005040 005041 005042 005043 005044 005045 005046 005047 005048 005049 005050 005051 005052 005053 005054 005055 005056 005057 005058 005059 005060 005061 005062 005063 005064 005065 005066 005067 005068 005069 005070 005071 005072 005073 005074 005075 005076 005077 005078 005079 005080 005081 )
	    ;;
	7 )
	    list_of_verses_that_belong_to_this_JUZ=( 005082 005083 005084 005085 005086 005087 005088 005089 005090 005091 005092 005093 005094 005095 005096 005097 005098 005099 005100 005101 005102 005103 005104 005105 005106 005107 005108 005109 005110 005111 005112 005113 005114 005115 005116 005117 005118 005119 005120 006001 006002 006003 006004 006005 006006 006007 006008 006009 006010 006011 006012 006013 006014 006015 006016 006017 006018 006019 006020 006021 006022 006023 006024 006025 006026 006027 006028 006029 006030 006031 006032 006033 006034 006035 006036 006037 006038 006039 006040 006041 006042 006043 006044 006045 006046 006047 006048 006049 006050 006051 006052 006053 006054 006055 006056 006057 006058 006059 006060 006061 006062 006063 006064 006065 006066 006067 006068 006069 006070 006071 006072 006073 006074 006075 006076 006077 006078 006079 006080 006081 006082 006083 006084 006085 006086 006087 006088 006089 006090 006091 006092 006093 006094 006095 006096 006097 006098 006099 006100 006101 006102 006103 006104 006105 006106 006107 006108 006109 006110 )
	    ;;
	8 )
	    list_of_verses_that_belong_to_this_JUZ=( 006111 006112 006113 006114 006115 006116 006117 006118 006119 006120 006121 006122 006123 006124 006125 006126 006127 006128 006129 006130 006131 006132 006133 006134 006135 006136 006137 006138 006139 006140 006141 006142 006143 006144 006145 006146 006147 006148 006149 006150 006151 006152 006153 006154 006155 006156 006157 006158 006159 006160 006161 006162 006163 006164 006165 007001 007002 007003 007004 007005 007006 007007 007008 007009 007010 007011 007012 007013 007014 007015 007016 007017 007018 007019 007020 007021 007022 007023 007024 007025 007026 007027 007028 007029 007030 007031 007032 007033 007034 007035 007036 007037 007038 007039 007040 007041 007042 007043 007044 007045 007046 007047 007048 007049 007050 007051 007052 007053 007054 007055 007056 007057 007058 007059 007060 007061 007062 007063 007064 007065 007066 007067 007068 007069 007070 007071 007072 007073 007074 007075 007076 007077 007078 007079 007080 007081 007082 007083 007084 007085 007086 007087 )
	    ;;
	9 )
	    list_of_verses_that_belong_to_this_JUZ=( 007088 007089 007090 007091 007092 007093 007094 007095 007096 007097 007098 007099 007100 007101 007102 007103 007104 007105 007106 007107 007108 007109 007110 007111 007112 007113 007114 007115 007116 007117 007118 007119 007120 007121 007122 007123 007124 007125 007126 007127 007128 007129 007130 007131 007132 007133 007134 007135 007136 007137 007138 007139 007140 007141 007142 007143 007144 007145 007146 007147 007148 007149 007150 007151 007152 007153 007154 007155 007156 007157 007158 007159 007160 007161 007162 007163 007164 007165 007166 007167 007168 007169 007170 007171 007172 007173 007174 007175 007176 007177 007178 007179 007180 007181 007182 007183 007184 007185 007186 007187 007188 007189 007190 007191 007192 007193 007194 007195 007196 007197 007198 007199 007200 007201 007202 007203 007204 007205 007206 008001 008002 008003 008004 008005 008006 008007 008008 008009 008010 008011 008012 008013 008014 008015 008016 008017 008018 008019 008020 008021 008022 008023 008024 008025 008026 008027 008028 008029 008030 008031 008032 008033 008034 008035 008036 008037 008038 008039 008040 )
	    ;;
	10 )
	    list_of_verses_that_belong_to_this_JUZ=( 008041 008042 008043 008044 008045 008046 008047 008048 008049 008050 008051 008052 008053 008054 008055 008056 008057 008058 008059 008060 008061 008062 008063 008064 008065 008066 008067 008068 008069 008070 008071 008072 008073 008074 008075 009001 009002 009003 009004 009005 009006 009007 009008 009009 009010 009011 009012 009013 009014 009015 009016 009017 009018 009019 009020 009021 009022 009023 009024 009025 009026 009027 009028 009029 009030 009031 009032 009033 009034 009035 009036 009037 009038 009039 009040 009041 009042 009043 009044 009045 009046 009047 009048 009049 009050 009051 009052 009053 009054 009055 009056 009057 009058 009059 009060 009061 009062 009063 009064 009065 009066 009067 009068 009069 009070 009071 009072 009073 009074 009075 009076 009077 009078 009079 009080 009081 009082 009083 009084 009085 009086 009087 009088 009089 009090 009091 009092 )
	    ;;
	11 )
	    list_of_verses_that_belong_to_this_JUZ=( 009093 009094 009095 009096 009097 009098 009099 009100 009101 009102 009103 009104 009105 009106 009107 009108 009109 009110 009111 009112 009113 009114 009115 009116 009117 009118 009119 009120 009121 009122 009123 009124 009125 009126 009127 009128 009129 010001 010002 010003 010004 010005 010006 010007 010008 010009 010010 010011 010012 010013 010014 010015 010016 010017 010018 010019 010020 010021 010022 010023 010024 010025 010026 010027 010028 010029 010030 010031 010032 010033 010034 010035 010036 010037 010038 010039 010040 010041 010042 010043 010044 010045 010046 010047 010048 010049 010050 010051 010052 010053 010054 010055 010056 010057 010058 010059 010060 010061 010062 010063 010064 010065 010066 010067 010068 010069 010070 010071 010072 010073 010074 010075 010076 010077 010078 010079 010080 010081 010082 010083 010084 010085 010086 010087 010088 010089 010090 010091 010092 010093 010094 010095 010096 010097 010098 010099 010100 010101 010102 010103 010104 010105 010106 010107 010108 010109 011001 011002 011003 011004 011005 )
	    ;;
	12 )
	    list_of_verses_that_belong_to_this_JUZ=( 011006 011007 011008 011009 011010 011011 011012 011013 011014 011015 011016 011017 011018 011019 011020 011021 011022 011023 011024 011025 011026 011027 011028 011029 011030 011031 011032 011033 011034 011035 011036 011037 011038 011039 011040 011041 011042 011043 011044 011045 011046 011047 011048 011049 011050 011051 011052 011053 011054 011055 011056 011057 011058 011059 011060 011061 011062 011063 011064 011065 011066 011067 011068 011069 011070 011071 011072 011073 011074 011075 011076 011077 011078 011079 011080 011081 011082 011083 011084 011085 011086 011087 011088 011089 011090 011091 011092 011093 011094 011095 011096 011097 011098 011099 011100 011101 011102 011103 011104 011105 011106 011107 011108 011109 011110 011111 011112 011113 011114 011115 011116 011117 011118 011119 011120 011121 011122 011123 012001 012002 012003 012004 012005 012006 012007 012008 012009 012010 012011 012012 012013 012014 012015 012016 012017 012018 012019 012020 012021 012022 012023 012024 012025 012026 012027 012028 012029 012030 012031 012032 012033 012034 012035 012036 012037 012038 012039 012040 012041 012042 012043 012044 012045 012046 012047 012048 012049 012050 012051 012052 )
	    ;;
	13 )
	    list_of_verses_that_belong_to_this_JUZ=( 012053 012054 012055 012056 012057 012058 012059 012060 012061 012062 012063 012064 012065 012066 012067 012068 012069 012070 012071 012072 012073 012074 012075 012076 012077 012078 012079 012080 012081 012082 012083 012084 012085 012086 012087 012088 012089 012090 012091 012092 012093 012094 012095 012096 012097 012098 012099 012100 012101 012102 012103 012104 012105 012106 012107 012108 012109 012110 012111 013001 013002 013003 013004 013005 013006 013007 013008 013009 013010 013011 013012 013013 013014 013015 013016 013017 013018 013019 013020 013021 013022 013023 013024 013025 013026 013027 013028 013029 013030 013031 013032 013033 013034 013035 013036 013037 013038 013039 013040 013041 013042 013043 014001 014002 014003 014004 014005 014006 014007 014008 014009 014010 014011 014012 014013 014014 014015 014016 014017 014018 014019 014020 014021 014022 014023 014024 014025 014026 014027 014028 014029 014030 014031 014032 014033 014034 014035 014036 014037 014038 014039 014040 014041 014042 014043 014044 014045 014046 014047 014048 014049 014050 014051 014052 )
	    ;;
	14 )
	    list_of_verses_that_belong_to_this_JUZ=( 015001 015002 015003 015004 015005 015006 015007 015008 015009 015010 015011 015012 015013 015014 015015 015016 015017 015018 015019 015020 015021 015022 015023 015024 015025 015026 015027 015028 015029 015030 015031 015032 015033 015034 015035 015036 015037 015038 015039 015040 015041 015042 015043 015044 015045 015046 015047 015048 015049 015050 015051 015052 015053 015054 015055 015056 015057 015058 015059 015060 015061 015062 015063 015064 015065 015066 015067 015068 015069 015070 015071 015072 015073 015074 015075 015076 015077 015078 015079 015080 015081 015082 015083 015084 015085 015086 015087 015088 015089 015090 015091 015092 015093 015094 015095 015096 015097 015098 015099 016001 016002 016003 016004 016005 016006 016007 016008 016009 016010 016011 016012 016013 016014 016015 016016 016017 016018 016019 016020 016021 016022 016023 016024 016025 016026 016027 016028 016029 016030 016031 016032 016033 016034 016035 016036 016037 016038 016039 016040 016041 016042 016043 016044 016045 016046 016047 016048 016049 016050 016051 016052 016053 016054 016055 016056 016057 016058 016059 016060 016061 016062 016063 016064 016065 016066 016067 016068 016069 016070 016071 016072 016073 016074 016075 016076 016077 016078 016079 016080 016081 016082 016083 016084 016085 016086 016087 016088 016089 016090 016091 016092 016093 016094 016095 016096 016097 016098 016099 016100 016101 016102 016103 016104 016105 016106 016107 016108 016109 016110 016111 016112 016113 016114 016115 016116 016117 016118 016119 016120 016121 016122 016123 016124 016125 016126 016127 016128 )
	    ;;
	15 )
	    list_of_verses_that_belong_to_this_JUZ=( 017001 017002 017003 017004 017005 017006 017007 017008 017009 017010 017011 017012 017013 017014 017015 017016 017017 017018 017019 017020 017021 017022 017023 017024 017025 017026 017027 017028 017029 017030 017031 017032 017033 017034 017035 017036 017037 017038 017039 017040 017041 017042 017043 017044 017045 017046 017047 017048 017049 017050 017051 017052 017053 017054 017055 017056 017057 017058 017059 017060 017061 017062 017063 017064 017065 017066 017067 017068 017069 017070 017071 017072 017073 017074 017075 017076 017077 017078 017079 017080 017081 017082 017083 017084 017085 017086 017087 017088 017089 017090 017091 017092 017093 017094 017095 017096 017097 017098 017099 017100 017101 017102 017103 017104 017105 017106 017107 017108 017109 017110 017111 018001 018002 018003 018004 018005 018006 018007 018008 018009 018010 018011 018012 018013 018014 018015 018016 018017 018018 018019 018020 018021 018022 018023 018024 018025 018026 018027 018028 018029 018030 018031 018032 018033 018034 018035 018036 018037 018038 018039 018040 018041 018042 018043 018044 018045 018046 018047 018048 018049 018050 018051 018052 018053 018054 018055 018056 018057 018058 018059 018060 018061 018062 018063 018064 018065 018066 018067 018068 018069 018070 018071 018072 018073 018074 )
	    ;;
	16 )
	    list_of_verses_that_belong_to_this_JUZ=( 018075 018076 018077 018078 018079 018080 018081 018082 018083 018084 018085 018086 018087 018088 018089 018090 018091 018092 018093 018094 018095 018096 018097 018098 018099 018100 018101 018102 018103 018104 018105 018106 018107 018108 018109 018110 019001 019002 019003 019004 019005 019006 019007 019008 019009 019010 019011 019012 019013 019014 019015 019016 019017 019018 019019 019020 019021 019022 019023 019024 019025 019026 019027 019028 019029 019030 019031 019032 019033 019034 019035 019036 019037 019038 019039 019040 019041 019042 019043 019044 019045 019046 019047 019048 019049 019050 019051 019052 019053 019054 019055 019056 019057 019058 019059 019060 019061 019062 019063 019064 019065 019066 019067 019068 019069 019070 019071 019072 019073 019074 019075 019076 019077 019078 019079 019080 019081 019082 019083 019084 019085 019086 019087 019088 019089 019090 019091 019092 019093 019094 019095 019096 019097 019098 020001 020002 020003 020004 020005 020006 020007 020008 020009 020010 020011 020012 020013 020014 020015 020016 020017 020018 020019 020020 020021 020022 020023 020024 020025 020026 020027 020028 020029 020030 020031 020032 020033 020034 020035 020036 020037 020038 020039 020040 020041 020042 020043 020044 020045 020046 020047 020048 020049 020050 020051 020052 020053 020054 020055 020056 020057 020058 020059 020060 020061 020062 020063 020064 020065 020066 020067 020068 020069 020070 020071 020072 020073 020074 020075 020076 020077 020078 020079 020080 020081 020082 020083 020084 020085 020086 020087 020088 020089 020090 020091 020092 020093 020094 020095 020096 020097 020098 020099 020100 020101 020102 020103 020104 020105 020106 020107 020108 020109 020110 020111 020112 020113 020114 020115 020116 020117 020118 020119 020120 020121 020122 020123 020124 020125 020126 020127 020128 020129 020130 020131 020132 020133 020134 020135 )
	    ;;
	17 )
	    list_of_verses_that_belong_to_this_JUZ=( 021001 021002 021003 021004 021005 021006 021007 021008 021009 021010 021011 021012 021013 021014 021015 021016 021017 021018 021019 021020 021021 021022 021023 021024 021025 021026 021027 021028 021029 021030 021031 021032 021033 021034 021035 021036 021037 021038 021039 021040 021041 021042 021043 021044 021045 021046 021047 021048 021049 021050 021051 021052 021053 021054 021055 021056 021057 021058 021059 021060 021061 021062 021063 021064 021065 021066 021067 021068 021069 021070 021071 021072 021073 021074 021075 021076 021077 021078 021079 021080 021081 021082 021083 021084 021085 021086 021087 021088 021089 021090 021091 021092 021093 021094 021095 021096 021097 021098 021099 021100 021101 021102 021103 021104 021105 021106 021107 021108 021109 021110 021111 021112 022001 022002 022003 022004 022005 022006 022007 022008 022009 022010 022011 022012 022013 022014 022015 022016 022017 022018 022019 022020 022021 022022 022023 022024 022025 022026 022027 022028 022029 022030 022031 022032 022033 022034 022035 022036 022037 022038 022039 022040 022041 022042 022043 022044 022045 022046 022047 022048 022049 022050 022051 022052 022053 022054 022055 022056 022057 022058 022059 022060 022061 022062 022063 022064 022065 022066 022067 022068 022069 022070 022071 022072 022073 022074 022075 022076 022077 022078 )
	    ;;
	18 )
	    list_of_verses_that_belong_to_this_JUZ=( 023001 023002 023003 023004 023005 023006 023007 023008 023009 023010 023011 023012 023013 023014 023015 023016 023017 023018 023019 023020 023021 023022 023023 023024 023025 023026 023027 023028 023029 023030 023031 023032 023033 023034 023035 023036 023037 023038 023039 023040 023041 023042 023043 023044 023045 023046 023047 023048 023049 023050 023051 023052 023053 023054 023055 023056 023057 023058 023059 023060 023061 023062 023063 023064 023065 023066 023067 023068 023069 023070 023071 023072 023073 023074 023075 023076 023077 023078 023079 023080 023081 023082 023083 023084 023085 023086 023087 023088 023089 023090 023091 023092 023093 023094 023095 023096 023097 023098 023099 023100 023101 023102 023103 023104 023105 023106 023107 023108 023109 023110 023111 023112 023113 023114 023115 023116 023117 023118 024001 024002 024003 024004 024005 024006 024007 024008 024009 024010 024011 024012 024013 024014 024015 024016 024017 024018 024019 024020 024021 024022 024023 024024 024025 024026 024027 024028 024029 024030 024031 024032 024033 024034 024035 024036 024037 024038 024039 024040 024041 024042 024043 024044 024045 024046 024047 024048 024049 024050 024051 024052 024053 024054 024055 024056 024057 024058 024059 024060 024061 024062 024063 024064 025001 025002 025003 025004 025005 025006 025007 025008 025009 025010 025011 025012 025013 025014 025015 025016 025017 025018 025019 025020 )
	    ;;
	19 )
	    list_of_verses_that_belong_to_this_JUZ=( 025021 025022 025023 025024 025025 025026 025027 025028 025029 025030 025031 025032 025033 025034 025035 025036 025037 025038 025039 025040 025041 025042 025043 025044 025045 025046 025047 025048 025049 025050 025051 025052 025053 025054 025055 025056 025057 025058 025059 025060 025061 025062 025063 025064 025065 025066 025067 025068 025069 025070 025071 025072 025073 025074 025075 025076 025077 026001 026002 026003 026004 026005 026006 026007 026008 026009 026010 026011 026012 026013 026014 026015 026016 026017 026018 026019 026020 026021 026022 026023 026024 026025 026026 026027 026028 026029 026030 026031 026032 026033 026034 026035 026036 026037 026038 026039 026040 026041 026042 026043 026044 026045 026046 026047 026048 026049 026050 026051 026052 026053 026054 026055 026056 026057 026058 026059 026060 026061 026062 026063 026064 026065 026066 026067 026068 026069 026070 026071 026072 026073 026074 026075 026076 026077 026078 026079 026080 026081 026082 026083 026084 026085 026086 026087 026088 026089 026090 026091 026092 026093 026094 026095 026096 026097 026098 026099 026100 026101 026102 026103 026104 026105 026106 026107 026108 026109 026110 026111 026112 026113 026114 026115 026116 026117 026118 026119 026120 026121 026122 026123 026124 026125 026126 026127 026128 026129 026130 026131 026132 026133 026134 026135 026136 026137 026138 026139 026140 026141 026142 026143 026144 026145 026146 026147 026148 026149 026150 026151 026152 026153 026154 026155 026156 026157 026158 026159 026160 026161 026162 026163 026164 026165 026166 026167 026168 026169 026170 026171 026172 026173 026174 026175 026176 026177 026178 026179 026180 026181 026182 026183 026184 026185 026186 026187 026188 026189 026190 026191 026192 026193 026194 026195 026196 026197 026198 026199 026200 026201 026202 026203 026204 026205 026206 026207 026208 026209 026210 026211 026212 026213 026214 026215 026216 026217 026218 026219 026220 026221 026222 026223 026224 026225 026226 026227 027001 027002 027003 027004 027005 027006 027007 027008 027009 027010 027011 027012 027013 027014 027015 027016 027017 027018 027019 027020 027021 027022 027023 027024 027025 027026 027027 027028 027029 027030 027031 027032 027033 027034 027035 027036 027037 027038 027039 027040 027041 027042 027043 027044 027045 027046 027047 027048 027049 027050 027051 027052 027053 027054 027055 )
	    ;;
	20 )
	    list_of_verses_that_belong_to_this_JUZ=( 027056 027057 027058 027059 027060 027061 027062 027063 027064 027065 027066 027067 027068 027069 027070 027071 027072 027073 027074 027075 027076 027077 027078 027079 027080 027081 027082 027083 027084 027085 027086 027087 027088 027089 027090 027091 027092 027093 028001 028002 028003 028004 028005 028006 028007 028008 028009 028010 028011 028012 028013 028014 028015 028016 028017 028018 028019 028020 028021 028022 028023 028024 028025 028026 028027 028028 028029 028030 028031 028032 028033 028034 028035 028036 028037 028038 028039 028040 028041 028042 028043 028044 028045 028046 028047 028048 028049 028050 028051 028052 028053 028054 028055 028056 028057 028058 028059 028060 028061 028062 028063 028064 028065 028066 028067 028068 028069 028070 028071 028072 028073 028074 028075 028076 028077 028078 028079 028080 028081 028082 028083 028084 028085 028086 028087 028088 029001 029002 029003 029004 029005 029006 029007 029008 029009 029010 029011 029012 029013 029014 029015 029016 029017 029018 029019 029020 029021 029022 029023 029024 029025 029026 029027 029028 029029 029030 029031 029032 029033 029034 029035 029036 029037 029038 029039 029040 029041 029042 029043 029044 029045 )
	    ;;
	21 )
	    list_of_verses_that_belong_to_this_JUZ=( 029046 029047 029048 029049 029050 029051 029052 029053 029054 029055 029056 029057 029058 029059 029060 029061 029062 029063 029064 029065 029066 029067 029068 029069 030001 030002 030003 030004 030005 030006 030007 030008 030009 030010 030011 030012 030013 030014 030015 030016 030017 030018 030019 030020 030021 030022 030023 030024 030025 030026 030027 030028 030029 030030 030031 030032 030033 030034 030035 030036 030037 030038 030039 030040 030041 030042 030043 030044 030045 030046 030047 030048 030049 030050 030051 030052 030053 030054 030055 030056 030057 030058 030059 030060 031001 031002 031003 031004 031005 031006 031007 031008 031009 031010 031011 031012 031013 031014 031015 031016 031017 031018 031019 031020 031021 031022 031023 031024 031025 031026 031027 031028 031029 031030 031031 031032 031033 031034 032001 032002 032003 032004 032005 032006 032007 032008 032009 032010 032011 032012 032013 032014 032015 032016 032017 032018 032019 032020 032021 032022 032023 032024 032025 032026 032027 032028 032029 032030 033001 033002 033003 033004 033005 033006 033007 033008 033009 033010 033011 033012 033013 033014 033015 033016 033017 033018 033019 033020 033021 033022 033023 033024 033025 033026 033027 033028 033029 033030 )
	    ;;
	22 )
	    list_of_verses_that_belong_to_this_JUZ=( 033031 033032 033033 033034 033035 033036 033037 033038 033039 033040 033041 033042 033043 033044 033045 033046 033047 033048 033049 033050 033051 033052 033053 033054 033055 033056 033057 033058 033059 033060 033061 033062 033063 033064 033065 033066 033067 033068 033069 033070 033071 033072 033073 034001 034002 034003 034004 034005 034006 034007 034008 034009 034010 034011 034012 034013 034014 034015 034016 034017 034018 034019 034020 034021 034022 034023 034024 034025 034026 034027 034028 034029 034030 034031 034032 034033 034034 034035 034036 034037 034038 034039 034040 034041 034042 034043 034044 034045 034046 034047 034048 034049 034050 034051 034052 034053 034054 035001 035002 035003 035004 035005 035006 035007 035008 035009 035010 035011 035012 035013 035014 035015 035016 035017 035018 035019 035020 035021 035022 035023 035024 035025 035026 035027 035028 035029 035030 035031 035032 035033 035034 035035 035036 035037 035038 035039 035040 035041 035042 035043 035044 035045 036001 036002 036003 036004 036005 036006 036007 036008 036009 036010 036011 036012 036013 036014 036015 036016 036017 036018 036019 036020 036021 036022 036023 036024 036025 036026 036027 )
	    ;;
	23 )
	    list_of_verses_that_belong_to_this_JUZ=( 036028 036029 036030 036031 036032 036033 036034 036035 036036 036037 036038 036039 036040 036041 036042 036043 036044 036045 036046 036047 036048 036049 036050 036051 036052 036053 036054 036055 036056 036057 036058 036059 036060 036061 036062 036063 036064 036065 036066 036067 036068 036069 036070 036071 036072 036073 036074 036075 036076 036077 036078 036079 036080 036081 036082 036083 037001 037002 037003 037004 037005 037006 037007 037008 037009 037010 037011 037012 037013 037014 037015 037016 037017 037018 037019 037020 037021 037022 037023 037024 037025 037026 037027 037028 037029 037030 037031 037032 037033 037034 037035 037036 037037 037038 037039 037040 037041 037042 037043 037044 037045 037046 037047 037048 037049 037050 037051 037052 037053 037054 037055 037056 037057 037058 037059 037060 037061 037062 037063 037064 037065 037066 037067 037068 037069 037070 037071 037072 037073 037074 037075 037076 037077 037078 037079 037080 037081 037082 037083 037084 037085 037086 037087 037088 037089 037090 037091 037092 037093 037094 037095 037096 037097 037098 037099 037100 037101 037102 037103 037104 037105 037106 037107 037108 037109 037110 037111 037112 037113 037114 037115 037116 037117 037118 037119 037120 037121 037122 037123 037124 037125 037126 037127 037128 037129 037130 037131 037132 037133 037134 037135 037136 037137 037138 037139 037140 037141 037142 037143 037144 037145 037146 037147 037148 037149 037150 037151 037152 037153 037154 037155 037156 037157 037158 037159 037160 037161 037162 037163 037164 037165 037166 037167 037168 037169 037170 037171 037172 037173 037174 037175 037176 037177 037178 037179 037180 037181 037182 038001 038002 038003 038004 038005 038006 038007 038008 038009 038010 038011 038012 038013 038014 038015 038016 038017 038018 038019 038020 038021 038022 038023 038024 038025 038026 038027 038028 038029 038030 038031 038032 038033 038034 038035 038036 038037 038038 038039 038040 038041 038042 038043 038044 038045 038046 038047 038048 038049 038050 038051 038052 038053 038054 038055 038056 038057 038058 038059 038060 038061 038062 038063 038064 038065 038066 038067 038068 038069 038070 038071 038072 038073 038074 038075 038076 038077 038078 038079 038080 038081 038082 038083 038084 038085 038086 038087 038088 039001 039002 039003 039004 039005 039006 039007 039008 039009 039010 039011 039012 039013 039014 039015 039016 039017 039018 039019 039020 039021 039022 039023 039024 039025 039026 039027 039028 039029 039030 039031 )
	    ;;
	24 )
	    list_of_verses_that_belong_to_this_JUZ=( 039032 039033 039034 039035 039036 039037 039038 039039 039040 039041 039042 039043 039044 039045 039046 039047 039048 039049 039050 039051 039052 039053 039054 039055 039056 039057 039058 039059 039060 039061 039062 039063 039064 039065 039066 039067 039068 039069 039070 039071 039072 039073 039074 039075 040001 040002 040003 040004 040005 040006 040007 040008 040009 040010 040011 040012 040013 040014 040015 040016 040017 040018 040019 040020 040021 040022 040023 040024 040025 040026 040027 040028 040029 040030 040031 040032 040033 040034 040035 040036 040037 040038 040039 040040 040041 040042 040043 040044 040045 040046 040047 040048 040049 040050 040051 040052 040053 040054 040055 040056 040057 040058 040059 040060 040061 040062 040063 040064 040065 040066 040067 040068 040069 040070 040071 040072 040073 040074 040075 040076 040077 040078 040079 040080 040081 040082 040083 040084 040085 041001 041002 041003 041004 041005 041006 041007 041008 041009 041010 041011 041012 041013 041014 041015 041016 041017 041018 041019 041020 041021 041022 041023 041024 041025 041026 041027 041028 041029 041030 041031 041032 041033 041034 041035 041036 041037 041038 041039 041040 041041 041042 041043 041044 041045 041046 )
	    ;;
	25 )
	    list_of_verses_that_belong_to_this_JUZ=( 041047 041048 041049 041050 041051 041052 041053 041054 042001 042002 042003 042004 042005 042006 042007 042008 042009 042010 042011 042012 042013 042014 042015 042016 042017 042018 042019 042020 042021 042022 042023 042024 042025 042026 042027 042028 042029 042030 042031 042032 042033 042034 042035 042036 042037 042038 042039 042040 042041 042042 042043 042044 042045 042046 042047 042048 042049 042050 042051 042052 042053 043001 043002 043003 043004 043005 043006 043007 043008 043009 043010 043011 043012 043013 043014 043015 043016 043017 043018 043019 043020 043021 043022 043023 043024 043025 043026 043027 043028 043029 043030 043031 043032 043033 043034 043035 043036 043037 043038 043039 043040 043041 043042 043043 043044 043045 043046 043047 043048 043049 043050 043051 043052 043053 043054 043055 043056 043057 043058 043059 043060 043061 043062 043063 043064 043065 043066 043067 043068 043069 043070 043071 043072 043073 043074 043075 043076 043077 043078 043079 043080 043081 043082 043083 043084 043085 043086 043087 043088 043089 044001 044002 044003 044004 044005 044006 044007 044008 044009 044010 044011 044012 044013 044014 044015 044016 044017 044018 044019 044020 044021 044022 044023 044024 044025 044026 044027 044028 044029 044030 044031 044032 044033 044034 044035 044036 044037 044038 044039 044040 044041 044042 044043 044044 044045 044046 044047 044048 044049 044050 044051 044052 044053 044054 044055 044056 044057 044058 044059 045001 045002 045003 045004 045005 045006 045007 045008 045009 045010 045011 045012 045013 045014 045015 045016 045017 045018 045019 045020 045021 045022 045023 045024 045025 045026 045027 045028 045029 045030 045031 045032 045033 045034 045035 045036 045037 )
	    ;;
	26 )
	    list_of_verses_that_belong_to_this_JUZ=( 046001 046002 046003 046004 046005 046006 046007 046008 046009 046010 046011 046012 046013 046014 046015 046016 046017 046018 046019 046020 046021 046022 046023 046024 046025 046026 046027 046028 046029 046030 046031 046032 046033 046034 046035 047001 047002 047003 047004 047005 047006 047007 047008 047009 047010 047011 047012 047013 047014 047015 047016 047017 047018 047019 047020 047021 047022 047023 047024 047025 047026 047027 047028 047029 047030 047031 047032 047033 047034 047035 047036 047037 047038 048001 048002 048003 048004 048005 048006 048007 048008 048009 048010 048011 048012 048013 048014 048015 048016 048017 048018 048019 048020 048021 048022 048023 048024 048025 048026 048027 048028 048029 049001 049002 049003 049004 049005 049006 049007 049008 049009 049010 049011 049012 049013 049014 049015 049016 049017 049018 050001 050002 050003 050004 050005 050006 050007 050008 050009 050010 050011 050012 050013 050014 050015 050016 050017 050018 050019 050020 050021 050022 050023 050024 050025 050026 050027 050028 050029 050030 050031 050032 050033 050034 050035 050036 050037 050038 050039 050040 050041 050042 050043 050044 050045 051001 051002 051003 051004 051005 051006 051007 051008 051009 051010 051011 051012 051013 051014 051015 051016 051017 051018 051019 051020 051021 051022 051023 051024 051025 051026 051027 051028 051029 051030 )
	    ;;
	27 )
	    list_of_verses_that_belong_to_this_JUZ=( 051031 051032 051033 051034 051035 051036 051037 051038 051039 051040 051041 051042 051043 051044 051045 051046 051047 051048 051049 051050 051051 051052 051053 051054 051055 051056 051057 051058 051059 051060 052001 052002 052003 052004 052005 052006 052007 052008 052009 052010 052011 052012 052013 052014 052015 052016 052017 052018 052019 052020 052021 052022 052023 052024 052025 052026 052027 052028 052029 052030 052031 052032 052033 052034 052035 052036 052037 052038 052039 052040 052041 052042 052043 052044 052045 052046 052047 052048 052049 053001 053002 053003 053004 053005 053006 053007 053008 053009 053010 053011 053012 053013 053014 053015 053016 053017 053018 053019 053020 053021 053022 053023 053024 053025 053026 053027 053028 053029 053030 053031 053032 053033 053034 053035 053036 053037 053038 053039 053040 053041 053042 053043 053044 053045 053046 053047 053048 053049 053050 053051 053052 053053 053054 053055 053056 053057 053058 053059 053060 053061 053062 054001 054002 054003 054004 054005 054006 054007 054008 054009 054010 054011 054012 054013 054014 054015 054016 054017 054018 054019 054020 054021 054022 054023 054024 054025 054026 054027 054028 054029 054030 054031 054032 054033 054034 054035 054036 054037 054038 054039 054040 054041 054042 054043 054044 054045 054046 054047 054048 054049 054050 054051 054052 054053 054054 054055 055001 055002 055003 055004 055005 055006 055007 055008 055009 055010 055011 055012 055013 055014 055015 055016 055017 055018 055019 055020 055021 055022 055023 055024 055025 055026 055027 055028 055029 055030 055031 055032 055033 055034 055035 055036 055037 055038 055039 055040 055041 055042 055043 055044 055045 055046 055047 055048 055049 055050 055051 055052 055053 055054 055055 055056 055057 055058 055059 055060 055061 055062 055063 055064 055065 055066 055067 055068 055069 055070 055071 055072 055073 055074 055075 055076 055077 055078 056001 056002 056003 056004 056005 056006 056007 056008 056009 056010 056011 056012 056013 056014 056015 056016 056017 056018 056019 056020 056021 056022 056023 056024 056025 056026 056027 056028 056029 056030 056031 056032 056033 056034 056035 056036 056037 056038 056039 056040 056041 056042 056043 056044 056045 056046 056047 056048 056049 056050 056051 056052 056053 056054 056055 056056 056057 056058 056059 056060 056061 056062 056063 056064 056065 056066 056067 056068 056069 056070 056071 056072 056073 056074 056075 056076 056077 056078 056079 056080 056081 056082 056083 056084 056085 056086 056087 056088 056089 056090 056091 056092 056093 056094 056095 056096 057001 057002 057003 057004 057005 057006 057007 057008 057009 057010 057011 057012 057013 057014 057015 057016 057017 057018 057019 057020 057021 057022 057023 057024 057025 057026 057027 057028 057029 )
	    ;;
	28 )
	    list_of_verses_that_belong_to_this_JUZ=( 058001 058002 058003 058004 058005 058006 058007 058008 058009 058010 058011 058012 058013 058014 058015 058016 058017 058018 058019 058020 058021 058022 059001 059002 059003 059004 059005 059006 059007 059008 059009 059010 059011 059012 059013 059014 059015 059016 059017 059018 059019 059020 059021 059022 059023 059024 060001 060002 060003 060004 060005 060006 060007 060008 060009 060010 060011 060012 060013 061001 061002 061003 061004 061005 061006 061007 061008 061009 061010 061011 061012 061013 061014 062001 062002 062003 062004 062005 062006 062007 062008 062009 062010 062011 063001 063002 063003 063004 063005 063006 063007 063008 063009 063010 063011 064001 064002 064003 064004 064005 064006 064007 064008 064009 064010 064011 064012 064013 064014 064015 064016 064017 064018 065001 065002 065003 065004 065005 065006 065007 065008 065009 065010 065011 065012 066001 066002 066003 066004 066005 066006 066007 066008 066009 066010 066011 066012 )
	    ;;
	29 )
	    list_of_verses_that_belong_to_this_JUZ=( 067001 067002 067003 067004 067005 067006 067007 067008 067009 067010 067011 067012 067013 067014 067015 067016 067017 067018 067019 067020 067021 067022 067023 067024 067025 067026 067027 067028 067029 067030 068001 068002 068003 068004 068005 068006 068007 068008 068009 068010 068011 068012 068013 068014 068015 068016 068017 068018 068019 068020 068021 068022 068023 068024 068025 068026 068027 068028 068029 068030 068031 068032 068033 068034 068035 068036 068037 068038 068039 068040 068041 068042 068043 068044 068045 068046 068047 068048 068049 068050 068051 068052 069001 069002 069003 069004 069005 069006 069007 069008 069009 069010 069011 069012 069013 069014 069015 069016 069017 069018 069019 069020 069021 069022 069023 069024 069025 069026 069027 069028 069029 069030 069031 069032 069033 069034 069035 069036 069037 069038 069039 069040 069041 069042 069043 069044 069045 069046 069047 069048 069049 069050 069051 069052 070001 070002 070003 070004 070005 070006 070007 070008 070009 070010 070011 070012 070013 070014 070015 070016 070017 070018 070019 070020 070021 070022 070023 070024 070025 070026 070027 070028 070029 070030 070031 070032 070033 070034 070035 070036 070037 070038 070039 070040 070041 070042 070043 070044 071001 071002 071003 071004 071005 071006 071007 071008 071009 071010 071011 071012 071013 071014 071015 071016 071017 071018 071019 071020 071021 071022 071023 071024 071025 071026 071027 071028 072001 072002 072003 072004 072005 072006 072007 072008 072009 072010 072011 072012 072013 072014 072015 072016 072017 072018 072019 072020 072021 072022 072023 072024 072025 072026 072027 072028 073001 073002 073003 073004 073005 073006 073007 073008 073009 073010 073011 073012 073013 073014 073015 073016 073017 073018 073019 073020 074001 074002 074003 074004 074005 074006 074007 074008 074009 074010 074011 074012 074013 074014 074015 074016 074017 074018 074019 074020 074021 074022 074023 074024 074025 074026 074027 074028 074029 074030 074031 074032 074033 074034 074035 074036 074037 074038 074039 074040 074041 074042 074043 074044 074045 074046 074047 074048 074049 074050 074051 074052 074053 074054 074055 074056 075001 075002 075003 075004 075005 075006 075007 075008 075009 075010 075011 075012 075013 075014 075015 075016 075017 075018 075019 075020 075021 075022 075023 075024 075025 075026 075027 075028 075029 075030 075031 075032 075033 075034 075035 075036 075037 075038 075039 075040 076001 076002 076003 076004 076005 076006 076007 076008 076009 076010 076011 076012 076013 076014 076015 076016 076017 076018 076019 076020 076021 076022 076023 076024 076025 076026 076027 076028 076029 076030 076031 077001 077002 077003 077004 077005 077006 077007 077008 077009 077010 077011 077012 077013 077014 077015 077016 077017 077018 077019 077020 077021 077022 077023 077024 077025 077026 077027 077028 077029 077030 077031 077032 077033 077034 077035 077036 077037 077038 077039 077040 077041 077042 077043 077044 077045 077046 077047 077048 077049 077050 )
	    ;;
	30 )
	    list_of_verses_that_belong_to_this_JUZ=( 078001 078002 078003 078004 078005 078006 078007 078008 078009 078010 078011 078012 078013 078014 078015 078016 078017 078018 078019 078020 078021 078022 078023 078024 078025 078026 078027 078028 078029 078030 078031 078032 078033 078034 078035 078036 078037 078038 078039 078040 079001 079002 079003 079004 079005 079006 079007 079008 079009 079010 079011 079012 079013 079014 079015 079016 079017 079018 079019 079020 079021 079022 079023 079024 079025 079026 079027 079028 079029 079030 079031 079032 079033 079034 079035 079036 079037 079038 079039 079040 079041 079042 079043 079044 079045 079046 080001 080002 080003 080004 080005 080006 080007 080008 080009 080010 080011 080012 080013 080014 080015 080016 080017 080018 080019 080020 080021 080022 080023 080024 080025 080026 080027 080028 080029 080030 080031 080032 080033 080034 080035 080036 080037 080038 080039 080040 080041 080042 081001 081002 081003 081004 081005 081006 081007 081008 081009 081010 081011 081012 081013 081014 081015 081016 081017 081018 081019 081020 081021 081022 081023 081024 081025 081026 081027 081028 081029 082001 082002 082003 082004 082005 082006 082007 082008 082009 082010 082011 082012 082013 082014 082015 082016 082017 082018 082019 083001 083002 083003 083004 083005 083006 083007 083008 083009 083010 083011 083012 083013 083014 083015 083016 083017 083018 083019 083020 083021 083022 083023 083024 083025 083026 083027 083028 083029 083030 083031 083032 083033 083034 083035 083036 084001 084002 084003 084004 084005 084006 084007 084008 084009 084010 084011 084012 084013 084014 084015 084016 084017 084018 084019 084020 084021 084022 084023 084024 084025 085001 085002 085003 085004 085005 085006 085007 085008 085009 085010 085011 085012 085013 085014 085015 085016 085017 085018 085019 085020 085021 085022 086001 086002 086003 086004 086005 086006 086007 086008 086009 086010 086011 086012 086013 086014 086015 086016 086017 087001 087002 087003 087004 087005 087006 087007 087008 087009 087010 087011 087012 087013 087014 087015 087016 087017 087018 087019 088001 088002 088003 088004 088005 088006 088007 088008 088009 088010 088011 088012 088013 088014 088015 088016 088017 088018 088019 088020 088021 088022 088023 088024 088025 088026 089001 089002 089003 089004 089005 089006 089007 089008 089009 089010 089011 089012 089013 089014 089015 089016 089017 089018 089019 089020 089021 089022 089023 089024 089025 089026 089027 089028 089029 089030 090001 090002 090003 090004 090005 090006 090007 090008 090009 090010 090011 090012 090013 090014 090015 090016 090017 090018 090019 090020 091001 091002 091003 091004 091005 091006 091007 091008 091009 091010 091011 091012 091013 091014 091015 092001 092002 092003 092004 092005 092006 092007 092008 092009 092010 092011 092012 092013 092014 092015 092016 092017 092018 092019 092020 092021 093001 093002 093003 093004 093005 093006 093007 093008 093009 093010 093011 094001 094002 094003 094004 094005 094006 094007 094008 095001 095002 095003 095004 095005 095006 095007 095008 096001 096002 096003 096004 096005 096006 096007 096008 096009 096010 096011 096012 096013 096014 096015 096016 096017 096018 096019 097001 097002 097003 097004 097005 098001 098002 098003 098004 098005 098006 098007 098008 099001 099002 099003 099004 099005 099006 099007 099008 100001 100002 100003 100004 100005 100006 100007 100008 100009 100010 100011 101001 101002 101003 101004 101005 101006 101007 101008 101009 101010 101011 102001 102002 102003 102004 102005 102006 102007 102008 103001 103002 103003 104001 104002 104003 104004 104005 104006 104007 104008 104009 105001 105002 105003 105004 105005 106001 106002 106003 106004 107001 107002 107003 107004 107005 107006 107007 108001 108002 108003 109001 109002 109003 109004 109005 109006 110001 110002 110003 111001 111002 111003 111004 111005 112001 112002 112003 112004 113001 113002 113003 113004 113005 114001 114002 114003 114004 114005 114006 )
	    ;;
	* )
	    echo
	    echo "The value you entered is invalid!"
	    echo; exit
	    ;;
    esac
}


show_list_of_verses_that_belong_to_this_hizb(){
    local hizbNumber="$1"
    case "$hizbNumber" in
	1 )
	    list_of_verses_that_belong_to_this_HIZB=( 001001 001002 001003 001004 001005 001006 001007 002001 002002 002003 002004 002005 002006 002007 002008 002009 002010 002011 002012 002013 002014 002015 002016 002017 002018 002019 002020 002021 002022 002023 002024 002025 002026 002027 002028 002029 002030 002031 002032 002033 002034 002035 002036 002037 002038 002039 002040 002041 002042 002043 002044 002045 002046 002047 002048 002049 002050 002051 002052 002053 002054 002055 002056 002057 002058 002059 002060 002061 002062 002063 002064 002065 002066 002067 002068 002069 002070 002071 002072 002073 002074 )
	    ;;
	2 )
	    list_of_verses_that_belong_to_this_HIZB=( 002075 002076 002077 002078 002079 002080 002081 002082 002083 002084 002085 002086 002087 002088 002089 002090 002091 002092 002093 002094 002095 002096 002097 002098 002099 002100 002101 002102 002103 002104 002105 002106 002107 002108 002109 002110 002111 002112 002113 002114 002115 002116 002117 002118 002119 002120 002121 002122 002123 002124 002125 002126 002127 002128 002129 002130 002131 002132 002133 002134 002135 002136 002137 002138 002139 002140 002141 )
	    ;;
	3 )
	    list_of_verses_that_belong_to_this_HIZB=( 002142 002143 002144 002145 002146 002147 002148 002149 002150 002151 002152 002153 002154 002155 002156 002157 002158 002159 002160 002161 002162 002163 002164 002165 002166 002167 002168 002169 002170 002171 002172 002173 002174 002175 002176 002177 002178 002179 002180 002181 002182 002183 002184 002185 002186 002187 002188 002189 002190 002191 002192 002193 002194 002195 002196 002197 002198 002199 002200 002201 002202 )
	    ;;
	4 )
	    list_of_verses_that_belong_to_this_HIZB=( 002203 002204 002205 002206 002207 002208 002209 002210 002211 002212 002213 002214 002215 002216 002217 002218 002219 002220 002221 002222 002223 002224 002225 002226 002227 002228 002229 002230 002231 002232 002233 002234 002235 002236 002237 002238 002239 002240 002241 002242 002243 002244 002245 002246 002247 002248 002249 002250 002251 002252 )
	    ;;
	5 )
	    list_of_verses_that_belong_to_this_HIZB=( 002253 002254 002255 002256 002257 002258 002259 002260 002261 002262 002263 002264 002265 002266 002267 002268 002269 002270 002271 002272 002273 002274 002275 002276 002277 002278 002279 002280 002281 002282 002283 002284 002285 002286 003001 003002 003003 003004 003005 003006 003007 003008 003009 003010 003011 003012 003013 003014 )
	    ;;
	6 )
	    list_of_verses_that_belong_to_this_HIZB=( 003015 003016 003017 003018 003019 003020 003021 003022 003023 003024 003025 003026 003027 003028 003029 003030 003031 003032 003033 003034 003035 003036 003037 003038 003039 003040 003041 003042 003043 003044 003045 003046 003047 003048 003049 003050 003051 003052 003053 003054 003055 003056 003057 003058 003059 003060 003061 003062 003063 003064 003065 003066 003067 003068 003069 003070 003071 003072 003073 003074 003075 003076 003077 003078 003079 003080 003081 003082 003083 003084 003085 003086 003087 003088 003089 003090 003091 003092 )
	    ;;
	7 )
	    list_of_verses_that_belong_to_this_HIZB=( 003093 003094 003095 003096 003097 003098 003099 003100 003101 003102 003103 003104 003105 003106 003107 003108 003109 003110 003111 003112 003113 003114 003115 003116 003117 003118 003119 003120 003121 003122 003123 003124 003125 003126 003127 003128 003129 003130 003131 003132 003133 003134 003135 003136 003137 003138 003139 003140 003141 003142 003143 003144 003145 003146 003147 003148 003149 003150 003151 003152 003153 003154 003155 003156 003157 003158 003159 003160 003161 003162 003163 003164 003165 003166 003167 003168 003169 003170 )
	    ;;
	8 )
	    list_of_verses_that_belong_to_this_HIZB=( 003171 003172 003173 003174 003175 003176 003177 003178 003179 003180 003181 003182 003183 003184 003185 003186 003187 003188 003189 003190 003191 003192 003193 003194 003195 003196 003197 003198 003199 003200 004001 004002 004003 004004 004005 004006 004007 004008 004009 004010 004011 004012 004013 004014 004015 004016 004017 004018 004019 004020 004021 004022 004023 )
	    ;;
	9 )
	    list_of_verses_that_belong_to_this_HIZB=( 004024 004025 004026 004027 004028 004029 004030 004031 004032 004033 004034 004035 004036 004037 004038 004039 004040 004041 004042 004043 004044 004045 004046 004047 004048 004049 004050 004051 004052 004053 004054 004055 004056 004057 004058 004059 004060 004061 004062 004063 004064 004065 004066 004067 004068 004069 004070 004071 004072 004073 004074 004075 004076 004077 004078 004079 004080 004081 004082 004083 004084 004085 004086 004087 )
	    ;;
	10 )
	    list_of_verses_that_belong_to_this_HIZB=( 004088 004089 004090 004091 004092 004093 004094 004095 004096 004097 004098 004099 004100 004101 004102 004103 004104 004105 004106 004107 004108 004109 004110 004111 004112 004113 004114 004115 004116 004117 004118 004119 004120 004121 004122 004123 004124 004125 004126 004127 004128 004129 004130 004131 004132 004133 004134 004135 004136 004137 004138 004139 004140 004141 004142 004143 004144 004145 004146 004147 )
	    ;;
	11 )
	    list_of_verses_that_belong_to_this_HIZB=( 004148 004149 004150 004151 004152 004153 004154 004155 004156 004157 004158 004159 004160 004161 004162 004163 004164 004165 004166 004167 004168 004169 004170 004171 004172 004173 004174 004175 004176 005001 005002 005003 005004 005005 005006 005007 005008 005009 005010 005011 005012 005013 005014 005015 005016 005017 005018 005019 005020 005021 005022 005023 005024 005025 005026 )
	    ;;
	12 )
	    list_of_verses_that_belong_to_this_HIZB=( 005027 005028 005029 005030 005031 005032 005033 005034 005035 005036 005037 005038 005039 005040 005041 005042 005043 005044 005045 005046 005047 005048 005049 005050 005051 005052 005053 005054 005055 005056 005057 005058 005059 005060 005061 005062 005063 005064 005065 005066 005067 005068 005069 005070 005071 005072 005073 005074 005075 005076 005077 005078 005079 005080 005081 )
	    ;;
	13 )
	    list_of_verses_that_belong_to_this_HIZB=( 005082 005083 005084 005085 005086 005087 005088 005089 005090 005091 005092 005093 005094 005095 005096 005097 005098 005099 005100 005101 005102 005103 005104 005105 005106 005107 005108 005109 005110 005111 005112 005113 005114 005115 005116 005117 005118 005119 005120 006001 006002 006003 006004 006005 006006 006007 006008 006009 006010 006011 006012 006013 006014 006015 006016 006017 006018 006019 006020 006021 006022 006023 006024 006025 006026 006027 006028 006029 006030 006031 006032 006033 006034 006035 )
	    ;;
	14 )
	    list_of_verses_that_belong_to_this_HIZB=( 006036 006037 006038 006039 006040 006041 006042 006043 006044 006045 006046 006047 006048 006049 006050 006051 006052 006053 006054 006055 006056 006057 006058 006059 006060 006061 006062 006063 006064 006065 006066 006067 006068 006069 006070 006071 006072 006073 006074 006075 006076 006077 006078 006079 006080 006081 006082 006083 006084 006085 006086 006087 006088 006089 006090 006091 006092 006093 006094 006095 006096 006097 006098 006099 006100 006101 006102 006103 006104 006105 006106 006107 006108 006109 006110 )
	    ;;
	15 )
	    list_of_verses_that_belong_to_this_HIZB=( 006111 006112 006113 006114 006115 006116 006117 006118 006119 006120 006121 006122 006123 006124 006125 006126 006127 006128 006129 006130 006131 006132 006133 006134 006135 006136 006137 006138 006139 006140 006141 006142 006143 006144 006145 006146 006147 006148 006149 006150 006151 006152 006153 006154 006155 006156 006157 006158 006159 006160 006161 006162 006163 006164 006165 )
	    ;;
	16 )
	    list_of_verses_that_belong_to_this_HIZB=( 007001 007002 007003 007004 007005 007006 007007 007008 007009 007010 007011 007012 007013 007014 007015 007016 007017 007018 007019 007020 007021 007022 007023 007024 007025 007026 007027 007028 007029 007030 007031 007032 007033 007034 007035 007036 007037 007038 007039 007040 007041 007042 007043 007044 007045 007046 007047 007048 007049 007050 007051 007052 007053 007054 007055 007056 007057 007058 007059 007060 007061 007062 007063 007064 007065 007066 007067 007068 007069 007070 007071 007072 007073 007074 007075 007076 007077 007078 007079 007080 007081 007082 007083 007084 007085 007086 007087 )
	    ;;
	17 )
	    list_of_verses_that_belong_to_this_HIZB=( 007088 007089 007090 007091 007092 007093 007094 007095 007096 007097 007098 007099 007100 007101 007102 007103 007104 007105 007106 007107 007108 007109 007110 007111 007112 007113 007114 007115 007116 007117 007118 007119 007120 007121 007122 007123 007124 007125 007126 007127 007128 007129 007130 007131 007132 007133 007134 007135 007136 007137 007138 007139 007140 007141 007142 007143 007144 007145 007146 007147 007148 007149 007150 007151 007152 007153 007154 007155 007156 007157 007158 007159 007160 007161 007162 007163 007164 007165 007166 007167 007168 007169 007170 )
	    ;;
	18 )
	    list_of_verses_that_belong_to_this_HIZB=( 007171 007172 007173 007174 007175 007176 007177 007178 007179 007180 007181 007182 007183 007184 007185 007186 007187 007188 007189 007190 007191 007192 007193 007194 007195 007196 007197 007198 007199 007200 007201 007202 007203 007204 007205 007206 008001 008002 008003 008004 008005 008006 008007 008008 008009 008010 008011 008012 008013 008014 008015 008016 008017 008018 008019 008020 008021 008022 008023 008024 008025 008026 008027 008028 008029 008030 008031 008032 008033 008034 008035 008036 008037 008038 008039 008040 )
	    ;;
	19 )
	    list_of_verses_that_belong_to_this_HIZB=( 008041 008042 008043 008044 008045 008046 008047 008048 008049 008050 008051 008052 008053 008054 008055 008056 008057 008058 008059 008060 008061 008062 008063 008064 008065 008066 008067 008068 008069 008070 008071 008072 008073 008074 008075 009001 009002 009003 009004 009005 009006 009007 009008 009009 009010 009011 009012 009013 009014 009015 009016 009017 009018 009019 009020 009021 009022 009023 009024 009025 009026 009027 009028 009029 009030 009031 009032 009033 )
	    ;;
	20 )
	    list_of_verses_that_belong_to_this_HIZB=( 009034 009035 009036 009037 009038 009039 009040 009041 009042 009043 009044 009045 009046 009047 009048 009049 009050 009051 009052 009053 009054 009055 009056 009057 009058 009059 009060 009061 009062 009063 009064 009065 009066 009067 009068 009069 009070 009071 009072 009073 009074 009075 009076 009077 009078 009079 009080 009081 009082 009083 009084 009085 009086 009087 009088 009089 009090 009091 009092 )
	    ;;
	21 )
	    list_of_verses_that_belong_to_this_HIZB=( 009093 009094 009095 009096 009097 009098 009099 009100 009101 009102 009103 009104 009105 009106 009107 009108 009109 009110 009111 009112 009113 009114 009115 009116 009117 009118 009119 009120 009121 009122 009123 009124 009125 009126 009127 009128 009129 010001 010002 010003 010004 010005 010006 010007 010008 010009 010010 010011 010012 010013 010014 010015 010016 010017 010018 010019 010020 010021 010022 010023 010024 010025 )
	    ;;
	22 )
	    list_of_verses_that_belong_to_this_HIZB=( 010026 010027 010028 010029 010030 010031 010032 010033 010034 010035 010036 010037 010038 010039 010040 010041 010042 010043 010044 010045 010046 010047 010048 010049 010050 010051 010052 010053 010054 010055 010056 010057 010058 010059 010060 010061 010062 010063 010064 010065 010066 010067 010068 010069 010070 010071 010072 010073 010074 010075 010076 010077 010078 010079 010080 010081 010082 010083 010084 010085 010086 010087 010088 010089 010090 010091 010092 010093 010094 010095 010096 010097 010098 010099 010100 010101 010102 010103 010104 010105 010106 010107 010108 010109 011001 011002 011003 011004 011005 )
	    ;;
	23 )
	    list_of_verses_that_belong_to_this_HIZB=( 011006 011007 011008 011009 011010 011011 011012 011013 011014 011015 011016 011017 011018 011019 011020 011021 011022 011023 011024 011025 011026 011027 011028 011029 011030 011031 011032 011033 011034 011035 011036 011037 011038 011039 011040 011041 011042 011043 011044 011045 011046 011047 011048 011049 011050 011051 011052 011053 011054 011055 011056 011057 011058 011059 011060 011061 011062 011063 011064 011065 011066 011067 011068 011069 011070 011071 011072 011073 011074 011075 011076 011077 011078 011079 011080 011081 011082 011083 )
	    ;;
	24 )
	    list_of_verses_that_belong_to_this_HIZB=( 011084 011085 011086 011087 011088 011089 011090 011091 011092 011093 011094 011095 011096 011097 011098 011099 011100 011101 011102 011103 011104 011105 011106 011107 011108 011109 011110 011111 011112 011113 011114 011115 011116 011117 011118 011119 011120 011121 011122 011123 012001 012002 012003 012004 012005 012006 012007 012008 012009 012010 012011 012012 012013 012014 012015 012016 012017 012018 012019 012020 012021 012022 012023 012024 012025 012026 012027 012028 012029 012030 012031 012032 012033 012034 012035 012036 012037 012038 012039 012040 012041 012042 012043 012044 012045 012046 012047 012048 012049 012050 012051 012052 )
	    ;;
	25 )
	    list_of_verses_that_belong_to_this_HIZB=( 012053 012054 012055 012056 012057 012058 012059 012060 012061 012062 012063 012064 012065 012066 012067 012068 012069 012070 012071 012072 012073 012074 012075 012076 012077 012078 012079 012080 012081 012082 012083 012084 012085 012086 012087 012088 012089 012090 012091 012092 012093 012094 012095 012096 012097 012098 012099 012100 012101 012102 012103 012104 012105 012106 012107 012108 012109 012110 012111 013001 013002 013003 013004 013005 013006 013007 013008 013009 013010 013011 013012 013013 013014 013015 013016 013017 013018 )
	    ;;
	26 )
	    list_of_verses_that_belong_to_this_HIZB=( 013019 013020 013021 013022 013023 013024 013025 013026 013027 013028 013029 013030 013031 013032 013033 013034 013035 013036 013037 013038 013039 013040 013041 013042 013043 014001 014002 014003 014004 014005 014006 014007 014008 014009 014010 014011 014012 014013 014014 014015 014016 014017 014018 014019 014020 014021 014022 014023 014024 014025 014026 014027 014028 014029 014030 014031 014032 014033 014034 014035 014036 014037 014038 014039 014040 014041 014042 014043 014044 014045 014046 014047 014048 014049 014050 014051 014052 )
	    ;;
	27 )
	    list_of_verses_that_belong_to_this_HIZB=( 015001 015002 015003 015004 015005 015006 015007 015008 015009 015010 015011 015012 015013 015014 015015 015016 015017 015018 015019 015020 015021 015022 015023 015024 015025 015026 015027 015028 015029 015030 015031 015032 015033 015034 015035 015036 015037 015038 015039 015040 015041 015042 015043 015044 015045 015046 015047 015048 015049 015050 015051 015052 015053 015054 015055 015056 015057 015058 015059 015060 015061 015062 015063 015064 015065 015066 015067 015068 015069 015070 015071 015072 015073 015074 015075 015076 015077 015078 015079 015080 015081 015082 015083 015084 015085 015086 015087 015088 015089 015090 015091 015092 015093 015094 015095 015096 015097 015098 015099 016001 016002 016003 016004 016005 016006 016007 016008 016009 016010 016011 016012 016013 016014 016015 016016 016017 016018 016019 016020 016021 016022 016023 016024 016025 016026 016027 016028 016029 016030 016031 016032 016033 016034 016035 016036 016037 016038 016039 016040 016041 016042 016043 016044 016045 016046 016047 016048 016049 016050 )
	    ;;
	28 )
	    list_of_verses_that_belong_to_this_HIZB=( 016051 016052 016053 016054 016055 016056 016057 016058 016059 016060 016061 016062 016063 016064 016065 016066 016067 016068 016069 016070 016071 016072 016073 016074 016075 016076 016077 016078 016079 016080 016081 016082 016083 016084 016085 016086 016087 016088 016089 016090 016091 016092 016093 016094 016095 016096 016097 016098 016099 016100 016101 016102 016103 016104 016105 016106 016107 016108 016109 016110 016111 016112 016113 016114 016115 016116 016117 016118 016119 016120 016121 016122 016123 016124 016125 016126 016127 016128 )
	    ;;
	29 )
	    list_of_verses_that_belong_to_this_HIZB=( 017001 017002 017003 017004 017005 017006 017007 017008 017009 017010 017011 017012 017013 017014 017015 017016 017017 017018 017019 017020 017021 017022 017023 017024 017025 017026 017027 017028 017029 017030 017031 017032 017033 017034 017035 017036 017037 017038 017039 017040 017041 017042 017043 017044 017045 017046 017047 017048 017049 017050 017051 017052 017053 017054 017055 017056 017057 017058 017059 017060 017061 017062 017063 017064 017065 017066 017067 017068 017069 017070 017071 017072 017073 017074 017075 017076 017077 017078 017079 017080 017081 017082 017083 017084 017085 017086 017087 017088 017089 017090 017091 017092 017093 017094 017095 017096 017097 017098 )
	    ;;
	30 )
	    list_of_verses_that_belong_to_this_HIZB=( 017099 017100 017101 017102 017103 017104 017105 017106 017107 017108 017109 017110 017111 018001 018002 018003 018004 018005 018006 018007 018008 018009 018010 018011 018012 018013 018014 018015 018016 018017 018018 018019 018020 018021 018022 018023 018024 018025 018026 018027 018028 018029 018030 018031 018032 018033 018034 018035 018036 018037 018038 018039 018040 018041 018042 018043 018044 018045 018046 018047 018048 018049 018050 018051 018052 018053 018054 018055 018056 018057 018058 018059 018060 018061 018062 018063 018064 018065 018066 018067 018068 018069 018070 018071 018072 018073 018074 )
	    ;;
	31 )
	    list_of_verses_that_belong_to_this_HIZB=( 018075 018076 018077 018078 018079 018080 018081 018082 018083 018084 018085 018086 018087 018088 018089 018090 018091 018092 018093 018094 018095 018096 018097 018098 018099 018100 018101 018102 018103 018104 018105 018106 018107 018108 018109 018110 019001 019002 019003 019004 019005 019006 019007 019008 019009 019010 019011 019012 019013 019014 019015 019016 019017 019018 019019 019020 019021 019022 019023 019024 019025 019026 019027 019028 019029 019030 019031 019032 019033 019034 019035 019036 019037 019038 019039 019040 019041 019042 019043 019044 019045 019046 019047 019048 019049 019050 019051 019052 019053 019054 019055 019056 019057 019058 019059 019060 019061 019062 019063 019064 019065 019066 019067 019068 019069 019070 019071 019072 019073 019074 019075 019076 019077 019078 019079 019080 019081 019082 019083 019084 019085 019086 019087 019088 019089 019090 019091 019092 019093 019094 019095 019096 019097 019098 )
	    ;;
	32 )
	    list_of_verses_that_belong_to_this_HIZB=( 020001 020002 020003 020004 020005 020006 020007 020008 020009 020010 020011 020012 020013 020014 020015 020016 020017 020018 020019 020020 020021 020022 020023 020024 020025 020026 020027 020028 020029 020030 020031 020032 020033 020034 020035 020036 020037 020038 020039 020040 020041 020042 020043 020044 020045 020046 020047 020048 020049 020050 020051 020052 020053 020054 020055 020056 020057 020058 020059 020060 020061 020062 020063 020064 020065 020066 020067 020068 020069 020070 020071 020072 020073 020074 020075 020076 020077 020078 020079 020080 020081 020082 020083 020084 020085 020086 020087 020088 020089 020090 020091 020092 020093 020094 020095 020096 020097 020098 020099 020100 020101 020102 020103 020104 020105 020106 020107 020108 020109 020110 020111 020112 020113 020114 020115 020116 020117 020118 020119 020120 020121 020122 020123 020124 020125 020126 020127 020128 020129 020130 020131 020132 020133 020134 020135 )
	    ;;
	33 )
	    list_of_verses_that_belong_to_this_HIZB=( 021001 021002 021003 021004 021005 021006 021007 021008 021009 021010 021011 021012 021013 021014 021015 021016 021017 021018 021019 021020 021021 021022 021023 021024 021025 021026 021027 021028 021029 021030 021031 021032 021033 021034 021035 021036 021037 021038 021039 021040 021041 021042 021043 021044 021045 021046 021047 021048 021049 021050 021051 021052 021053 021054 021055 021056 021057 021058 021059 021060 021061 021062 021063 021064 021065 021066 021067 021068 021069 021070 021071 021072 021073 021074 021075 021076 021077 021078 021079 021080 021081 021082 021083 021084 021085 021086 021087 021088 021089 021090 021091 021092 021093 021094 021095 021096 021097 021098 021099 021100 021101 021102 021103 021104 021105 021106 021107 021108 021109 021110 021111 021112 )
	    ;;
	34 )
	    list_of_verses_that_belong_to_this_HIZB=( 022001 022002 022003 022004 022005 022006 022007 022008 022009 022010 022011 022012 022013 022014 022015 022016 022017 022018 022019 022020 022021 022022 022023 022024 022025 022026 022027 022028 022029 022030 022031 022032 022033 022034 022035 022036 022037 022038 022039 022040 022041 022042 022043 022044 022045 022046 022047 022048 022049 022050 022051 022052 022053 022054 022055 022056 022057 022058 022059 022060 022061 022062 022063 022064 022065 022066 022067 022068 022069 022070 022071 022072 022073 022074 022075 022076 022077 022078 )
	    ;;
	35 )
	    list_of_verses_that_belong_to_this_HIZB=( 023001 023002 023003 023004 023005 023006 023007 023008 023009 023010 023011 023012 023013 023014 023015 023016 023017 023018 023019 023020 023021 023022 023023 023024 023025 023026 023027 023028 023029 023030 023031 023032 023033 023034 023035 023036 023037 023038 023039 023040 023041 023042 023043 023044 023045 023046 023047 023048 023049 023050 023051 023052 023053 023054 023055 023056 023057 023058 023059 023060 023061 023062 023063 023064 023065 023066 023067 023068 023069 023070 023071 023072 023073 023074 023075 023076 023077 023078 023079 023080 023081 023082 023083 023084 023085 023086 023087 023088 023089 023090 023091 023092 023093 023094 023095 023096 023097 023098 023099 023100 023101 023102 023103 023104 023105 023106 023107 023108 023109 023110 023111 023112 023113 023114 023115 023116 023117 023118 024001 024002 024003 024004 024005 024006 024007 024008 024009 024010 024011 024012 024013 024014 024015 024016 024017 024018 024019 024020 )
	    ;;
	36 )
	    list_of_verses_that_belong_to_this_HIZB=( 024021 024022 024023 024024 024025 024026 024027 024028 024029 024030 024031 024032 024033 024034 024035 024036 024037 024038 024039 024040 024041 024042 024043 024044 024045 024046 024047 024048 024049 024050 024051 024052 024053 024054 024055 024056 024057 024058 024059 024060 024061 024062 024063 024064 025001 025002 025003 025004 025005 025006 025007 025008 025009 025010 025011 025012 025013 025014 025015 025016 025017 025018 025019 025020 )
	    ;;
	37 )
	    list_of_verses_that_belong_to_this_HIZB=( 025021 025022 025023 025024 025025 025026 025027 025028 025029 025030 025031 025032 025033 025034 025035 025036 025037 025038 025039 025040 025041 025042 025043 025044 025045 025046 025047 025048 025049 025050 025051 025052 025053 025054 025055 025056 025057 025058 025059 025060 025061 025062 025063 025064 025065 025066 025067 025068 025069 025070 025071 025072 025073 025074 025075 025076 025077 026001 026002 026003 026004 026005 026006 026007 026008 026009 026010 026011 026012 026013 026014 026015 026016 026017 026018 026019 026020 026021 026022 026023 026024 026025 026026 026027 026028 026029 026030 026031 026032 026033 026034 026035 026036 026037 026038 026039 026040 026041 026042 026043 026044 026045 026046 026047 026048 026049 026050 026051 026052 026053 026054 026055 026056 026057 026058 026059 026060 026061 026062 026063 026064 026065 026066 026067 026068 026069 026070 026071 026072 026073 026074 026075 026076 026077 026078 026079 026080 026081 026082 026083 026084 026085 026086 026087 026088 026089 026090 026091 026092 026093 026094 026095 026096 026097 026098 026099 026100 026101 026102 026103 026104 026105 026106 026107 026108 026109 026110 )
	    ;;
	38 )
	    list_of_verses_that_belong_to_this_HIZB=( 026111 026112 026113 026114 026115 026116 026117 026118 026119 026120 026121 026122 026123 026124 026125 026126 026127 026128 026129 026130 026131 026132 026133 026134 026135 026136 026137 026138 026139 026140 026141 026142 026143 026144 026145 026146 026147 026148 026149 026150 026151 026152 026153 026154 026155 026156 026157 026158 026159 026160 026161 026162 026163 026164 026165 026166 026167 026168 026169 026170 026171 026172 026173 026174 026175 026176 026177 026178 026179 026180 026181 026182 026183 026184 026185 026186 026187 026188 026189 026190 026191 026192 026193 026194 026195 026196 026197 026198 026199 026200 026201 026202 026203 026204 026205 026206 026207 026208 026209 026210 026211 026212 026213 026214 026215 026216 026217 026218 026219 026220 026221 026222 026223 026224 026225 026226 026227 027001 027002 027003 027004 027005 027006 027007 027008 027009 027010 027011 027012 027013 027014 027015 027016 027017 027018 027019 027020 027021 027022 027023 027024 027025 027026 027027 027028 027029 027030 027031 027032 027033 027034 027035 027036 027037 027038 027039 027040 027041 027042 027043 027044 027045 027046 027047 027048 027049 027050 027051 027052 027053 027054 027055 )
	    ;;
	39 )
	    list_of_verses_that_belong_to_this_HIZB=( 027056 027057 027058 027059 027060 027061 027062 027063 027064 027065 027066 027067 027068 027069 027070 027071 027072 027073 027074 027075 027076 027077 027078 027079 027080 027081 027082 027083 027084 027085 027086 027087 027088 027089 027090 027091 027092 027093 028001 028002 028003 028004 028005 028006 028007 028008 028009 028010 028011 028012 028013 028014 028015 028016 028017 028018 028019 028020 028021 028022 028023 028024 028025 028026 028027 028028 028029 028030 028031 028032 028033 028034 028035 028036 028037 028038 028039 028040 028041 028042 028043 028044 028045 028046 028047 028048 028049 028050 )
	    ;;
	40 )
	    list_of_verses_that_belong_to_this_HIZB=( 028051 028052 028053 028054 028055 028056 028057 028058 028059 028060 028061 028062 028063 028064 028065 028066 028067 028068 028069 028070 028071 028072 028073 028074 028075 028076 028077 028078 028079 028080 028081 028082 028083 028084 028085 028086 028087 028088 029001 029002 029003 029004 029005 029006 029007 029008 029009 029010 029011 029012 029013 029014 029015 029016 029017 029018 029019 029020 029021 029022 029023 029024 029025 029026 029027 029028 029029 029030 029031 029032 029033 029034 029035 029036 029037 029038 029039 029040 029041 029042 029043 029044 029045 )
	    ;;
	41 )
	    list_of_verses_that_belong_to_this_HIZB=( 029046 029047 029048 029049 029050 029051 029052 029053 029054 029055 029056 029057 029058 029059 029060 029061 029062 029063 029064 029065 029066 029067 029068 029069 030001 030002 030003 030004 030005 030006 030007 030008 030009 030010 030011 030012 030013 030014 030015 030016 030017 030018 030019 030020 030021 030022 030023 030024 030025 030026 030027 030028 030029 030030 030031 030032 030033 030034 030035 030036 030037 030038 030039 030040 030041 030042 030043 030044 030045 030046 030047 030048 030049 030050 030051 030052 030053 030054 030055 030056 030057 030058 030059 030060 031001 031002 031003 031004 031005 031006 031007 031008 031009 031010 031011 031012 031013 031014 031015 031016 031017 031018 031019 031020 031021 )
	    ;;
	42 )
	    list_of_verses_that_belong_to_this_HIZB=( 031022 031023 031024 031025 031026 031027 031028 031029 031030 031031 031032 031033 031034 032001 032002 032003 032004 032005 032006 032007 032008 032009 032010 032011 032012 032013 032014 032015 032016 032017 032018 032019 032020 032021 032022 032023 032024 032025 032026 032027 032028 032029 032030 033001 033002 033003 033004 033005 033006 033007 033008 033009 033010 033011 033012 033013 033014 033015 033016 033017 033018 033019 033020 033021 033022 033023 033024 033025 033026 033027 033028 033029 033030 )
	    ;;
	43 )
	    list_of_verses_that_belong_to_this_HIZB=( 033031 033032 033033 033034 033035 033036 033037 033038 033039 033040 033041 033042 033043 033044 033045 033046 033047 033048 033049 033050 033051 033052 033053 033054 033055 033056 033057 033058 033059 033060 033061 033062 033063 033064 033065 033066 033067 033068 033069 033070 033071 033072 033073 034001 034002 034003 034004 034005 034006 034007 034008 034009 034010 034011 034012 034013 034014 034015 034016 034017 034018 034019 034020 034021 034022 034023 )
	    ;;
	44 )
	    list_of_verses_that_belong_to_this_HIZB=( 034024 034025 034026 034027 034028 034029 034030 034031 034032 034033 034034 034035 034036 034037 034038 034039 034040 034041 034042 034043 034044 034045 034046 034047 034048 034049 034050 034051 034052 034053 034054 035001 035002 035003 035004 035005 035006 035007 035008 035009 035010 035011 035012 035013 035014 035015 035016 035017 035018 035019 035020 035021 035022 035023 035024 035025 035026 035027 035028 035029 035030 035031 035032 035033 035034 035035 035036 035037 035038 035039 035040 035041 035042 035043 035044 035045 036001 036002 036003 036004 036005 036006 036007 036008 036009 036010 036011 036012 036013 036014 036015 036016 036017 036018 036019 036020 036021 036022 036023 036024 036025 036026 036027 )
	    ;;
	45 )
	    list_of_verses_that_belong_to_this_HIZB=( 036028 036029 036030 036031 036032 036033 036034 036035 036036 036037 036038 036039 036040 036041 036042 036043 036044 036045 036046 036047 036048 036049 036050 036051 036052 036053 036054 036055 036056 036057 036058 036059 036060 036061 036062 036063 036064 036065 036066 036067 036068 036069 036070 036071 036072 036073 036074 036075 036076 036077 036078 036079 036080 036081 036082 036083 037001 037002 037003 037004 037005 037006 037007 037008 037009 037010 037011 037012 037013 037014 037015 037016 037017 037018 037019 037020 037021 037022 037023 037024 037025 037026 037027 037028 037029 037030 037031 037032 037033 037034 037035 037036 037037 037038 037039 037040 037041 037042 037043 037044 037045 037046 037047 037048 037049 037050 037051 037052 037053 037054 037055 037056 037057 037058 037059 037060 037061 037062 037063 037064 037065 037066 037067 037068 037069 037070 037071 037072 037073 037074 037075 037076 037077 037078 037079 037080 037081 037082 037083 037084 037085 037086 037087 037088 037089 037090 037091 037092 037093 037094 037095 037096 037097 037098 037099 037100 037101 037102 037103 037104 037105 037106 037107 037108 037109 037110 037111 037112 037113 037114 037115 037116 037117 037118 037119 037120 037121 037122 037123 037124 037125 037126 037127 037128 037129 037130 037131 037132 037133 037134 037135 037136 037137 037138 037139 037140 037141 037142 037143 037144 )
	    ;;
	46 )
	    list_of_verses_that_belong_to_this_HIZB=( 037145 037146 037147 037148 037149 037150 037151 037152 037153 037154 037155 037156 037157 037158 037159 037160 037161 037162 037163 037164 037165 037166 037167 037168 037169 037170 037171 037172 037173 037174 037175 037176 037177 037178 037179 037180 037181 037182 038001 038002 038003 038004 038005 038006 038007 038008 038009 038010 038011 038012 038013 038014 038015 038016 038017 038018 038019 038020 038021 038022 038023 038024 038025 038026 038027 038028 038029 038030 038031 038032 038033 038034 038035 038036 038037 038038 038039 038040 038041 038042 038043 038044 038045 038046 038047 038048 038049 038050 038051 038052 038053 038054 038055 038056 038057 038058 038059 038060 038061 038062 038063 038064 038065 038066 038067 038068 038069 038070 038071 038072 038073 038074 038075 038076 038077 038078 038079 038080 038081 038082 038083 038084 038085 038086 038087 038088 039001 039002 039003 039004 039005 039006 039007 039008 039009 039010 039011 039012 039013 039014 039015 039016 039017 039018 039019 039020 039021 039022 039023 039024 039025 039026 039027 039028 039029 039030 039031 )
	    ;;
	47 )
	    list_of_verses_that_belong_to_this_HIZB=( 039032 039033 039034 039035 039036 039037 039038 039039 039040 039041 039042 039043 039044 039045 039046 039047 039048 039049 039050 039051 039052 039053 039054 039055 039056 039057 039058 039059 039060 039061 039062 039063 039064 039065 039066 039067 039068 039069 039070 039071 039072 039073 039074 039075 040001 040002 040003 040004 040005 040006 040007 040008 040009 040010 040011 040012 040013 040014 040015 040016 040017 040018 040019 040020 040021 040022 040023 040024 040025 040026 040027 040028 040029 040030 040031 040032 040033 040034 040035 040036 040037 040038 040039 040040 )
	    ;;
	48 )
	    list_of_verses_that_belong_to_this_HIZB=( 040041 040042 040043 040044 040045 040046 040047 040048 040049 040050 040051 040052 040053 040054 040055 040056 040057 040058 040059 040060 040061 040062 040063 040064 040065 040066 040067 040068 040069 040070 040071 040072 040073 040074 040075 040076 040077 040078 040079 040080 040081 040082 040083 040084 040085 041001 041002 041003 041004 041005 041006 041007 041008 041009 041010 041011 041012 041013 041014 041015 041016 041017 041018 041019 041020 041021 041022 041023 041024 041025 041026 041027 041028 041029 041030 041031 041032 041033 041034 041035 041036 041037 041038 041039 041040 041041 041042 041043 041044 041045 041046 )
	    ;;
	49 )
	    list_of_verses_that_belong_to_this_HIZB=( 041047 041048 041049 041050 041051 041052 041053 041054 042001 042002 042003 042004 042005 042006 042007 042008 042009 042010 042011 042012 042013 042014 042015 042016 042017 042018 042019 042020 042021 042022 042023 042024 042025 042026 042027 042028 042029 042030 042031 042032 042033 042034 042035 042036 042037 042038 042039 042040 042041 042042 042043 042044 042045 042046 042047 042048 042049 042050 042051 042052 042053 043001 043002 043003 043004 043005 043006 043007 043008 043009 043010 043011 043012 043013 043014 043015 043016 043017 043018 043019 043020 043021 043022 043023 )
	    ;;
	50 )
	    list_of_verses_that_belong_to_this_HIZB=( 043024 043025 043026 043027 043028 043029 043030 043031 043032 043033 043034 043035 043036 043037 043038 043039 043040 043041 043042 043043 043044 043045 043046 043047 043048 043049 043050 043051 043052 043053 043054 043055 043056 043057 043058 043059 043060 043061 043062 043063 043064 043065 043066 043067 043068 043069 043070 043071 043072 043073 043074 043075 043076 043077 043078 043079 043080 043081 043082 043083 043084 043085 043086 043087 043088 043089 044001 044002 044003 044004 044005 044006 044007 044008 044009 044010 044011 044012 044013 044014 044015 044016 044017 044018 044019 044020 044021 044022 044023 044024 044025 044026 044027 044028 044029 044030 044031 044032 044033 044034 044035 044036 044037 044038 044039 044040 044041 044042 044043 044044 044045 044046 044047 044048 044049 044050 044051 044052 044053 044054 044055 044056 044057 044058 044059 045001 045002 045003 045004 045005 045006 045007 045008 045009 045010 045011 045012 045013 045014 045015 045016 045017 045018 045019 045020 045021 045022 045023 045024 045025 045026 045027 045028 045029 045030 045031 045032 045033 045034 045035 045036 045037 )
	    ;;
	51 )
	    list_of_verses_that_belong_to_this_HIZB=( 046001 046002 046003 046004 046005 046006 046007 046008 046009 046010 046011 046012 046013 046014 046015 046016 046017 046018 046019 046020 046021 046022 046023 046024 046025 046026 046027 046028 046029 046030 046031 046032 046033 046034 046035 047001 047002 047003 047004 047005 047006 047007 047008 047009 047010 047011 047012 047013 047014 047015 047016 047017 047018 047019 047020 047021 047022 047023 047024 047025 047026 047027 047028 047029 047030 047031 047032 047033 047034 047035 047036 047037 047038 048001 048002 048003 048004 048005 048006 048007 048008 048009 048010 048011 048012 048013 048014 048015 048016 048017 )
	    ;;
	52 )
	    list_of_verses_that_belong_to_this_HIZB=( 048018 048019 048020 048021 048022 048023 048024 048025 048026 048027 048028 048029 049001 049002 049003 049004 049005 049006 049007 049008 049009 049010 049011 049012 049013 049014 049015 049016 049017 049018 050001 050002 050003 050004 050005 050006 050007 050008 050009 050010 050011 050012 050013 050014 050015 050016 050017 050018 050019 050020 050021 050022 050023 050024 050025 050026 050027 050028 050029 050030 050031 050032 050033 050034 050035 050036 050037 050038 050039 050040 050041 050042 050043 050044 050045 051001 051002 051003 051004 051005 051006 051007 051008 051009 051010 051011 051012 051013 051014 051015 051016 051017 051018 051019 051020 051021 051022 051023 051024 051025 051026 051027 051028 051029 051030 )
	    ;;
	53 )
	    list_of_verses_that_belong_to_this_HIZB=( 051031 051032 051033 051034 051035 051036 051037 051038 051039 051040 051041 051042 051043 051044 051045 051046 051047 051048 051049 051050 051051 051052 051053 051054 051055 051056 051057 051058 051059 051060 052001 052002 052003 052004 052005 052006 052007 052008 052009 052010 052011 052012 052013 052014 052015 052016 052017 052018 052019 052020 052021 052022 052023 052024 052025 052026 052027 052028 052029 052030 052031 052032 052033 052034 052035 052036 052037 052038 052039 052040 052041 052042 052043 052044 052045 052046 052047 052048 052049 053001 053002 053003 053004 053005 053006 053007 053008 053009 053010 053011 053012 053013 053014 053015 053016 053017 053018 053019 053020 053021 053022 053023 053024 053025 053026 053027 053028 053029 053030 053031 053032 053033 053034 053035 053036 053037 053038 053039 053040 053041 053042 053043 053044 053045 053046 053047 053048 053049 053050 053051 053052 053053 053054 053055 053056 053057 053058 053059 053060 053061 053062 054001 054002 054003 054004 054005 054006 054007 054008 054009 054010 054011 054012 054013 054014 054015 054016 054017 054018 054019 054020 054021 054022 054023 054024 054025 054026 054027 054028 054029 054030 054031 054032 054033 054034 054035 054036 054037 054038 054039 054040 054041 054042 054043 054044 054045 054046 054047 054048 054049 054050 054051 054052 054053 054054 054055 )
	    ;;
	54 )
	    list_of_verses_that_belong_to_this_HIZB=( 055001 055002 055003 055004 055005 055006 055007 055008 055009 055010 055011 055012 055013 055014 055015 055016 055017 055018 055019 055020 055021 055022 055023 055024 055025 055026 055027 055028 055029 055030 055031 055032 055033 055034 055035 055036 055037 055038 055039 055040 055041 055042 055043 055044 055045 055046 055047 055048 055049 055050 055051 055052 055053 055054 055055 055056 055057 055058 055059 055060 055061 055062 055063 055064 055065 055066 055067 055068 055069 055070 055071 055072 055073 055074 055075 055076 055077 055078 056001 056002 056003 056004 056005 056006 056007 056008 056009 056010 056011 056012 056013 056014 056015 056016 056017 056018 056019 056020 056021 056022 056023 056024 056025 056026 056027 056028 056029 056030 056031 056032 056033 056034 056035 056036 056037 056038 056039 056040 056041 056042 056043 056044 056045 056046 056047 056048 056049 056050 056051 056052 056053 056054 056055 056056 056057 056058 056059 056060 056061 056062 056063 056064 056065 056066 056067 056068 056069 056070 056071 056072 056073 056074 056075 056076 056077 056078 056079 056080 056081 056082 056083 056084 056085 056086 056087 056088 056089 056090 056091 056092 056093 056094 056095 056096 057001 057002 057003 057004 057005 057006 057007 057008 057009 057010 057011 057012 057013 057014 057015 057016 057017 057018 057019 057020 057021 057022 057023 057024 057025 057026 057027 057028 057029 )
	    ;;
	55 )
	    list_of_verses_that_belong_to_this_HIZB=( 058001 058002 058003 058004 058005 058006 058007 058008 058009 058010 058011 058012 058013 058014 058015 058016 058017 058018 058019 058020 058021 058022 059001 059002 059003 059004 059005 059006 059007 059008 059009 059010 059011 059012 059013 059014 059015 059016 059017 059018 059019 059020 059021 059022 059023 059024 060001 060002 060003 060004 060005 060006 060007 060008 060009 060010 060011 060012 060013 061001 061002 061003 061004 061005 061006 061007 061008 061009 061010 061011 061012 061013 061014 )
	    ;;
	56 )
	    list_of_verses_that_belong_to_this_HIZB=( 062001 062002 062003 062004 062005 062006 062007 062008 062009 062010 062011 063001 063002 063003 063004 063005 063006 063007 063008 063009 063010 063011 064001 064002 064003 064004 064005 064006 064007 064008 064009 064010 064011 064012 064013 064014 064015 064016 064017 064018 065001 065002 065003 065004 065005 065006 065007 065008 065009 065010 065011 065012 066001 066002 066003 066004 066005 066006 066007 066008 066009 066010 066011 066012 )
	    ;;
	57 )
	    list_of_verses_that_belong_to_this_HIZB=( 067001 067002 067003 067004 067005 067006 067007 067008 067009 067010 067011 067012 067013 067014 067015 067016 067017 067018 067019 067020 067021 067022 067023 067024 067025 067026 067027 067028 067029 067030 068001 068002 068003 068004 068005 068006 068007 068008 068009 068010 068011 068012 068013 068014 068015 068016 068017 068018 068019 068020 068021 068022 068023 068024 068025 068026 068027 068028 068029 068030 068031 068032 068033 068034 068035 068036 068037 068038 068039 068040 068041 068042 068043 068044 068045 068046 068047 068048 068049 068050 068051 068052 069001 069002 069003 069004 069005 069006 069007 069008 069009 069010 069011 069012 069013 069014 069015 069016 069017 069018 069019 069020 069021 069022 069023 069024 069025 069026 069027 069028 069029 069030 069031 069032 069033 069034 069035 069036 069037 069038 069039 069040 069041 069042 069043 069044 069045 069046 069047 069048 069049 069050 069051 069052 070001 070002 070003 070004 070005 070006 070007 070008 070009 070010 070011 070012 070013 070014 070015 070016 070017 070018 070019 070020 070021 070022 070023 070024 070025 070026 070027 070028 070029 070030 070031 070032 070033 070034 070035 070036 070037 070038 070039 070040 070041 070042 070043 070044 071001 071002 071003 071004 071005 071006 071007 071008 071009 071010 071011 071012 071013 071014 071015 071016 071017 071018 071019 071020 071021 071022 071023 071024 071025 071026 071027 071028 )
	    ;;
	58 )
	    list_of_verses_that_belong_to_this_HIZB=( 072001 072002 072003 072004 072005 072006 072007 072008 072009 072010 072011 072012 072013 072014 072015 072016 072017 072018 072019 072020 072021 072022 072023 072024 072025 072026 072027 072028 073001 073002 073003 073004 073005 073006 073007 073008 073009 073010 073011 073012 073013 073014 073015 073016 073017 073018 073019 073020 074001 074002 074003 074004 074005 074006 074007 074008 074009 074010 074011 074012 074013 074014 074015 074016 074017 074018 074019 074020 074021 074022 074023 074024 074025 074026 074027 074028 074029 074030 074031 074032 074033 074034 074035 074036 074037 074038 074039 074040 074041 074042 074043 074044 074045 074046 074047 074048 074049 074050 074051 074052 074053 074054 074055 074056 075001 075002 075003 075004 075005 075006 075007 075008 075009 075010 075011 075012 075013 075014 075015 075016 075017 075018 075019 075020 075021 075022 075023 075024 075025 075026 075027 075028 075029 075030 075031 075032 075033 075034 075035 075036 075037 075038 075039 075040 076001 076002 076003 076004 076005 076006 076007 076008 076009 076010 076011 076012 076013 076014 076015 076016 076017 076018 076019 076020 076021 076022 076023 076024 076025 076026 076027 076028 076029 076030 076031 077001 077002 077003 077004 077005 077006 077007 077008 077009 077010 077011 077012 077013 077014 077015 077016 077017 077018 077019 077020 077021 077022 077023 077024 077025 077026 077027 077028 077029 077030 077031 077032 077033 077034 077035 077036 077037 077038 077039 077040 077041 077042 077043 077044 077045 077046 077047 077048 077049 077050 )
	    ;;
	59 )
	    list_of_verses_that_belong_to_this_HIZB=( 078001 078002 078003 078004 078005 078006 078007 078008 078009 078010 078011 078012 078013 078014 078015 078016 078017 078018 078019 078020 078021 078022 078023 078024 078025 078026 078027 078028 078029 078030 078031 078032 078033 078034 078035 078036 078037 078038 078039 078040 079001 079002 079003 079004 079005 079006 079007 079008 079009 079010 079011 079012 079013 079014 079015 079016 079017 079018 079019 079020 079021 079022 079023 079024 079025 079026 079027 079028 079029 079030 079031 079032 079033 079034 079035 079036 079037 079038 079039 079040 079041 079042 079043 079044 079045 079046 080001 080002 080003 080004 080005 080006 080007 080008 080009 080010 080011 080012 080013 080014 080015 080016 080017 080018 080019 080020 080021 080022 080023 080024 080025 080026 080027 080028 080029 080030 080031 080032 080033 080034 080035 080036 080037 080038 080039 080040 080041 080042 081001 081002 081003 081004 081005 081006 081007 081008 081009 081010 081011 081012 081013 081014 081015 081016 081017 081018 081019 081020 081021 081022 081023 081024 081025 081026 081027 081028 081029 082001 082002 082003 082004 082005 082006 082007 082008 082009 082010 082011 082012 082013 082014 082015 082016 082017 082018 082019 083001 083002 083003 083004 083005 083006 083007 083008 083009 083010 083011 083012 083013 083014 083015 083016 083017 083018 083019 083020 083021 083022 083023 083024 083025 083026 083027 083028 083029 083030 083031 083032 083033 083034 083035 083036 084001 084002 084003 084004 084005 084006 084007 084008 084009 084010 084011 084012 084013 084014 084015 084016 084017 084018 084019 084020 084021 084022 084023 084024 084025 085001 085002 085003 085004 085005 085006 085007 085008 085009 085010 085011 085012 085013 085014 085015 085016 085017 085018 085019 085020 085021 085022 086001 086002 086003 086004 086005 086006 086007 086008 086009 086010 086011 086012 086013 086014 086015 086016 086017 )
	    ;;
	60 )
	    list_of_verses_that_belong_to_this_HIZB=( 087001 087002 087003 087004 087005 087006 087007 087008 087009 087010 087011 087012 087013 087014 087015 087016 087017 087018 087019 088001 088002 088003 088004 088005 088006 088007 088008 088009 088010 088011 088012 088013 088014 088015 088016 088017 088018 088019 088020 088021 088022 088023 088024 088025 088026 089001 089002 089003 089004 089005 089006 089007 089008 089009 089010 089011 089012 089013 089014 089015 089016 089017 089018 089019 089020 089021 089022 089023 089024 089025 089026 089027 089028 089029 089030 090001 090002 090003 090004 090005 090006 090007 090008 090009 090010 090011 090012 090013 090014 090015 090016 090017 090018 090019 090020 091001 091002 091003 091004 091005 091006 091007 091008 091009 091010 091011 091012 091013 091014 091015 092001 092002 092003 092004 092005 092006 092007 092008 092009 092010 092011 092012 092013 092014 092015 092016 092017 092018 092019 092020 092021 093001 093002 093003 093004 093005 093006 093007 093008 093009 093010 093011 094001 094002 094003 094004 094005 094006 094007 094008 095001 095002 095003 095004 095005 095006 095007 095008 096001 096002 096003 096004 096005 096006 096007 096008 096009 096010 096011 096012 096013 096014 096015 096016 096017 096018 096019 097001 097002 097003 097004 097005 098001 098002 098003 098004 098005 098006 098007 098008 099001 099002 099003 099004 099005 099006 099007 099008 100001 100002 100003 100004 100005 100006 100007 100008 100009 100010 100011 101001 101002 101003 101004 101005 101006 101007 101008 101009 101010 101011 102001 102002 102003 102004 102005 102006 102007 102008 103001 103002 103003 104001 104002 104003 104004 104005 104006 104007 104008 104009 105001 105002 105003 105004 105005 106001 106002 106003 106004 107001 107002 107003 107004 107005 107006 107007 108001 108002 108003 109001 109002 109003 109004 109005 109006 110001 110002 110003 111001 111002 111003 111004 111005 112001 112002 112003 112004 113001 113002 113003 113004 113005 114001 114002 114003 114004 114005 114006 )
	    ;;
	* )
	    echo
	    echo "The value you entered is invalid!"
	    echo; exit
	    ;;
    esac
}


####################
tafsir_look_up_plain_text(){
    local tafsir_files_dir="$1"
    local outFilePath="$2"
    
    reset
    echo
    echo "Please make sure your translation"
    echo "files are correctly named."
    echo "This program only recognizes"
    echo "files that have the following"
    echo "extension: *.$taf_file_ext. For"
    echo "instance: en-hilali.$taf_file_ext"
    echo "or: en-sahih.$taf_file_ext"
    echo

    # get into the folder containing
    # the tafsir files in plain text
    if [[ -d "$tafsir_files_dir" ]]
    then
	cd "$tafsir_files_dir"
    else
	echo "The directory:"
	echo "$tafsir_files_dir"
	echo 'does not exist or is not accessible!'
	echo
	echo "Please make sure the tafsir files"
	echo "and directories actually exist."
	exit
    fi

    echo
    echo "The output file is:"
    echo "$outFilePath"
    echo

    # starting the verse tafsir/translation look-up
    for file in *.$taf_file_ext
    do
	echo; echo "Working with file:"
	echo "\"${file}"\"; echo
	
	echo "${file%.$taf_file_ext}:" >> "$outFilePath"
	
	# make a look-up with sed
	# while providing it with
	# the line number of the
	# current ayah

	# expand ${set_of_ayat_to_pass_to_tafsir_lookup[@]}"
	# into a list of options that are passed to the function
	# convert_surahAndAyahNumber_to_tanzil_ayahLineNumber

	# Debug
	#reset; echo; echo "set_of_ayat_to_pass_to_tafsir_lookup:"
	#echo "${set_of_ayat_to_pass_to_tafsir_lookup[*]}"
	#echo; exit
	
	# Let us sort the array first
	OLDIFS=$IFS; IFS=' '
	sorted_set_of_ayat_to_pass_to_tafsir_lookup=($(sort <<<"${set_of_ayat_to_pass_to_tafsir_lookup[*]}"))
	IFS=$OLDIFS


	# Debug
	#reset
	#echo; echo "sorted_set_of_ayat_to_pass_to_tafsir_lookup:"
	#echo "${sorted_set_of_ayat_to_pass_to_tafsir_lookup[*]}"
	#echo; exit
	
	for ayah in "${sorted_set_of_ayat_to_pass_to_tafsir_lookup[@]}"
	do
	    # after each iteration, the function sets a new value for
	    # $ayahLineNumber. That value which is the line number of
	    # the given verse, as it appears in any zekr/tanzil Quran /
	    # translation file is used by sed to fetch the ayah we are
	    # looking for and generates its tafsir in the desired format
	    # 'txt' or 'html'
	    convert_surahAndAyahNumber_to_tanzil_ayahLineNumber $(echo "$ayah")
	    # Filling up the array of line numbers to be passed to sed
	    array_of_line_numbers_to_be_passed_to_sed_for_look_up+=( `echo $ayahLineNumber` )
	done

	# Debug
	#reset; echo;
	#echo "array_of_line_numbers_to_be_passed_to_sed_for_look_up:"
	#echo "${array_of_line_numbers_to_be_passed_to_sed_for_look_up[*]}"
	#echo; exit
	
	# Internal function performing
	# sed lookup on the playlist files
	open_tanzil_or_zekr_file_for_sed_look_up(){
	    7z x -so "${file}" | sed -n $(for ayah in "${array_of_line_numbers_to_be_passed_to_sed_for_look_up[@]}"; do echo -n "-e $ayah{p} "; done)
	}

	# print the array of tafsirs contents #
	n=0
	open_tanzil_or_zekr_file_for_sed_look_up | \
	    while read line
	    do
		echo -n "${sorted_set_of_ayat_to_pass_to_tafsir_lookup[$n]}: " >> "$outFilePath"
		echo "$line" >> "$outFilePath"
		((++n))
	    done

	unset array_of_line_numbers_to_be_passed_to_sed_for_look_up
	# If we don't do this, each verse tafsir will end up
	# being written to output file more than once !

	echo >> "$outFilePath"
    done
    
    echo
    echo "Seems all the operation have"
    echo "been completed successfully!"
    echo

    # get out of that folder
    cd ..
}



####################
tafsir_look_up_html(){
    local tafsir_files_dir="$1"
    local outFilePath="$2"
    
    reset
    echo
    echo "Please make sure your translation"
    echo "files are correctly named."
    echo "This program only recognizes"
    echo "files that have the following"
    echo "extension: *.$taf_file_ext. For"
    echo "instance: en-hilali.$taf_file_ext"
    echo "or: en-sahih.$taf_file_ext"
    echo

    # get into the folder containing
    # the tafsir files in plain text
    if [[ -d "$tafsir_files_dir" ]]
    then
	cd "$tafsir_files_dir"
    else
	echo "The directory:"
	echo "$tafsir_files_dir"
	echo 'does not exist or is not accessible!'
	echo
	echo "Please make sure the tafsir files"
	echo "and directories actually exist."
	exit
    fi

    echo
    echo "The output file is:"
    echo "$outFilePath"
    echo

    # since this one is an HTML file
    # we put the required tags to make
    # it valid enough
    echo '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">' >> "$outFilePath"
    echo "<html>" >> "$outFilePath"
    echo "<head>" >> "$outFilePath"
    echo '<meta http-equiv="content-type" content="text/html; charset=utf-8"/>' >> "$outFilePath"
    echo '<meta name="author" content="Abu-Djuwairiyyah Karim"/>'  >> "$outFilePath"
    echo "<title>One Ayah Tafsir</title>" >> "$outFilePath"
    echo "</head>" >> "$outFilePath"
    echo "<body>" >> "$outFilePath"

    # starting the verse tafsir/translation look-up
    for file in *.$taf_file_ext
    do
	echo; echo "Working with file:"
	echo "\"${file}"\"; echo

	# write the tafsir filename
	echo "<h3><u>${file%.$taf_file_ext}</u>:</h3>" \
	     >> "$outFilePath"

	# Create a new <div> tag
	# for layout consistency
	echo "<div>" >> "$outFilePath"
	
	# make a look-up with sed
	# while providing it with
	# the line number of the
	# current ayah

	# expand ${set_of_ayat_to_pass_to_tafsir_lookup[@]}"
	# into a list of options that are passed to the function
	# convert_surahAndAyahNumber_to_tanzil_ayahLineNumber

	# Let us sort the array first
	OLDIFS=$IFS; IFS=' '
	sorted_set_of_ayat_to_pass_to_tafsir_lookup=($(sort <<<"${set_of_ayat_to_pass_to_tafsir_lookup[*]}"))
	IFS=$OLDIFS

	
	for ayah in "${sorted_set_of_ayat_to_pass_to_tafsir_lookup[@]}"
	do
	    # after each iteration, the function sets a new value for
	    # $ayahLineNumber. That value which is the line number of
	    # the given verse, as it appears in any zekr/tanzil Quran /
	    # translation file is used by sed to fetch the ayah we are
	    # looking for and generates its tafsir in the desired format
	    # 'txt' or 'html'
	    convert_surahAndAyahNumber_to_tanzil_ayahLineNumber $(echo "$ayah")
	    # Filling up the array of line numbers to be passed to sed
	    array_of_line_numbers_to_be_passed_to_sed_for_look_up+=( `echo $ayahLineNumber` )
	done
	
	# Internal function performing
	# sed lookup on the playlist files
	open_tanzil_or_zekr_file_for_sed_look_up(){
	    7z x -so "${file}" | sed -n $(for ayah in "${array_of_line_numbers_to_be_passed_to_sed_for_look_up[@]}"; do echo -n "-e $ayah{p} "; done)
	}
	
	# print the array of tafsirs contents #
	n=0
	open_tanzil_or_zekr_file_for_sed_look_up | \
	    while read line
	    do
		echo -n "<p><b>${sorted_set_of_ayat_to_pass_to_tafsir_lookup[$n]}:</b> " >> "$outFilePath"
		echo "$line </p></div>" >> "$outFilePath"
		((++n))
	    done

	# This code is broken
	#mapfile -t ayaat_tafsirs_array_to_be_dumped_to_outfile < <(open_tanzil_or_zekr_file_for_sed_look_up)
	#readarray -t ayaat_tafsirs_array_to_be_dumped_to_outfile <<< $(open_tanzil_or_zekr_file_for_sed_look_up)
	#
	# Now, we have the tafsirs of all the verses we want from the
	# current tafsir file we are dealing with right now. All we
	# have to do is write them to file using a loop. The verses
	# are contained in an array.
	# Since we would like to print the ayah number before
	# writing it to file
	# we will have to print the contents of the 2 arrays
	# "${sorted_set_of_ayat_to_pass_to_tafsir_lookup[@]}"
	# "${ayaat_tafsirs_array_to_be_dumped_to_outfile[@]}"
	#n=${#sorted_set_of_ayat_to_pass_to_tafsir_lookup}
	#for ((i=0;i<$n;i++))
	#do
	#echo "<p><b>${sorted_set_of_ayat_to_pass_to_tafsir_lookup[$i]}:</b> \
	    #${ayaat_tafsirs_array_to_be_dumped_to_outfile[$i]}</p></div>" >> "$outFilePath"
	#done
	
	# If we don't do this, each verse tafsir will end up
	# being written to output file more than once !
	unset array_of_line_numbers_to_be_passed_to_sed_for_look_up
    done
    
    # putting in the ending HTML tags
    echo "</body>" >> "$outFilePath"
    echo "</html>" >> "$outFilePath"
    
    echo
    echo "Seems all the operation have"
    echo "been completed successfully!"
    echo

    # get out of that folder
    cd ..
}


invoque_tafsir_lookup_separate_ayaat(){
    local output_tafsir_file="$1"
    # generate an array from
    # the one ayah or the set
    # of ayat entered by the
    # user.
    #
    # before, we have to check if
    # the user entered ayaat range
    # in the format the following
    # format: 001001_001007
    if [[ "$entered_set_of_suwar_or_set_of_ayat" =~ .*_.* ]]
    then
	# the presence of the underscore
	# indicates us that the user
	# entered ayaat range. We
	# thus split the string into
	# 2 parts: $first and $last

	# Backup current $IFS
	OLDIFS=$IFS; IFS='_' read first last \
			<<< "$entered_set_of_suwar_or_set_of_ayat"

	# Here, we will use the first
	# element and the last element
	# of the range to generate the
	# line numbers. Remember that
	# those lines
	# correspond to the addresses of
	# the verses as they appear in
	# zekr/tanzil files. Once we get
	# the lines, we will use another
	# function to convert them to real
	# verses like 001001 or 001007 and
	# we pass the list as an array to
	# the remaining program for it to
	# go ahead and generate the tafsirs.

	# The first run with the var
	# "$first" will get us the line
	# number of this given verse
	convert_surahAndAyahNumber_to_tanzil_ayahLineNumber $(echo "$first")
	range_first_ayah_line_num="$ayahLineNumber"

	# The second run with the var
	# "$last" will get us the line
	# number of that given verse
	convert_surahAndAyahNumber_to_tanzil_ayahLineNumber $(echo "$last")
	range_last_ayah_line_num="$ayahLineNumber"
	
	for ((a="$range_first_ayah_line_num"; \
	      a<="$range_last_ayah_line_num"; a++))
	do
	    set_of_line_numbers_to_convert_to_ayat_names=( "${set_of_line_numbers_to_convert_to_ayat_names[@]}" "$a" )
	done
	
	# Restore the IFS
	IFS=$OLDIFS

	# Raise the range flag
	range_flag="yes"
	
	# begin - debug #
	#busybox reset
	#echo "First verse of range: $first"
	#echo "Last verse of range: $last"
	#echo
	#echo "First line-number of range: $range_first_ayah_line_num"
	#echo "Last line-number of range: $range_last_ayah_line_num"
	#echo
	#echo "Contents of the generated array"
	#echo "from the above first and last"
	#echo "values, expanded:"; echo
	#echo "${set_of_line_numbers_to_convert_to_ayat_names[@]}"
	# end of debug #

	# We convert the line numbers contained in the array
	# "${set_of_line_numbers_to_convert_to_ayat_names[@]}"
	# into SūrahNumber+AyahNumber (6-digits) using the
	# function "conv_ayahLineNumber_to_surahAndAyahNumber"
	for tanzil_line_number in "${set_of_line_numbers_to_convert_to_ayat_names[@]}"
	do
	    conv_ayahLineNumber_to_surahAndAyahNumber $(echo "$tanzil_line_number")
	    current_ayah_to_add_to_array="$surahAndAyahNumber"
	    set_of_ayat_to_pass_to_tafsir_lookup=( "${set_of_ayat_to_pass_to_tafsir_lookup[@]}" \
						       "$current_ayah_to_add_to_array" )
	    
	done

	# begin - debug #
	#echo; echo "I have tried to convert these"
	#echo "line numbers into SūrahNum+AyahNum"
	#echo "This is the result:"
	#echo; echo "${set_of_ayat_to_pass_to_tafsir_lookup[@]}"
	#echo; exit $?
	# end - debug #

    else

	OLDIFS=$IFS; IFS=' ' read -r -a set_of_ayat_to_pass_to_tafsir_lookup \
			<<< "$entered_set_of_suwar_or_set_of_ayat" # Here, this
	# variable only holds ayat list, not
	# a chapter number. It is so because
	# if we reach here, it is because
	# the option -a was passed to script
	IFS=$OLDIFS
    fi
    
    # Sorting the array holding
    # suwar names to be processed
    OLDIFS=$IFS; IFS=' '
    sorted_set_of_ayat_to_pass_to_tafsir_lookup=($(sort <<<"${set_of_ayat_to_pass_to_tafsir_lookup[*]}"))
    # restore the backed-up one
    IFS=$OLDIFS

    # clean up the file contents
    # if it exists, otherwise
    # create a fresh one
    cat /dev/null > "$output_tafsir_file"

    # Which of the 2 functions to invoke
    # Also searches for tafsir files in
    # $HOME/.tafsir and the root folder
    # of this very script
    if [[ "$outputFormat" == "txt" ]]
    then
	if [ -d "$txt_tafasir_folder_thisScriptRoot" ]
	then
	    tafsir_look_up_plain_text \
		"$txt_tafasir_folder_thisScriptRoot" \
		"$output_tafsir_file"
	    
	elif [ -d "$txt_tafasir_folder_users_home" ]
	then
	    tafsir_look_up_plain_text \
		"$txt_tafasir_folder_users_home" \
		"$output_tafsir_file"
	fi
	
    elif [[ "$outputFormat" == "htm" ]]
    then
	if [ -d "$html_tafasir_folder_thisScriptRoot" ]
	then
	    tafsir_look_up_html \
		"$html_tafasir_folder_thisScriptRoot" \
		"$output_tafsir_file"
	    
	elif [ -d "$html_tafasir_folder_users_home" ]
	then
	    tafsir_look_up_html \
		"$html_tafasir_folder_users_home" \
		"$output_tafsir_file"
	fi
    fi
}


invoque_tafsir_lookup_full_suwar(){
    local extension="$1"
    # generate an array from
    # the one Sūrah number or
    # the set of Sūrah names
    # entered by the user.
    #
    # before, we have to check if
    # the user entered ayaat range
    # in the format the following
    # format: 9_15 for instance
    if [[ "$entered_set_of_suwar_or_set_of_ayat" =~ .*_.* ]]
    then
	# the presence of the underscore
	# indicates us that the user
	# entered suwar range. We
	# thus split the string into
	# 2 parts: $first and $last
	
	# Backup current $IFS
	OLDIFS=$IFS; IFS='_' read first last \
			<<< "$entered_set_of_suwar_or_set_of_ayat"

	# generating the range from
	# the fist and last element.
	# BASH will convert 8..15 to
	# 8, 9, 10, 11, 12, 13, 14, 15
	# throught the code below. We
	# then convert the generated
	# list into an array at the
	# same time
	for ((a="$first"; a<="$last"; a++))
	do
	    set_of_suwar_to_convert_to_ayat=( "${set_of_suwar_to_convert_to_ayat[@]}" "$a" )
	done
	
	# Restore the IFS
	IFS=$OLDIFS

	# Raise the range flag
	range_flag="yes"

	# begin - debug #
	# busybox reset
	# echo "First element of range: $first"
	# echo "Second element of range: $last"
	# echo
	# echo "Contents of the generated array"
	# echo "from the above first and last"
	# echo "values, expanded:"; echo
	# echo "${set_of_suwar_to_convert_to_ayat[@]}"
	# echo; exit $?
	# end of debug #

    else

	OLDIFS=$IFS; IFS=' ' read -r -a set_of_suwar_to_convert_to_ayat \
			<<< "$entered_set_of_suwar_or_set_of_ayat" # Here, this
	# variable only holds Suwar list, not
	# ayat numbers. It is so because
	# if we reach here, it is because
	# the option -s was passed to script
	IFS=$OLDIFS
    fi

    # Sorting the array holding
    # suwar names to be processed
    OLDIFS=$IFS; IFS=' '
    sorted_set_of_suwar_to_convert_to_ayat=($(sort <<<"${set_of_suwar_to_convert_to_ayat[*]}"))
    # restore the old IFS
    IFS=$OLDIFS
    
    for surah in "${sorted_set_of_suwar_to_convert_to_ayat[@]}"
    do
	# We will pad the Sūrah
	# numbers with leading
	# zeros before creating
	# the output files.
	
	# Copy Sūrah number before
	# altering it.
	surah_leadZ="$surah"

	# We'll use this "$((10#$a))"
	# to force printf to interpret
	# the value as decimal number,
	# otherwise it will interpret
	# it as an octal number if it
	# happens to start with zeros!
	
	output_surah_tafsir_file="$out_taf_file_dirname/Tafsir Surah `printf "%03d" $((10#$surah_leadZ))`.$extension"
	# clean up the file contents
	# if it exists, otherwise
	# create a fresh one
	cat /dev/null > "$output_surah_tafsir_file"

	# the following function takes
	# Sūrah number as param and it
	# returns the ayat of the Sūrah
	# as an array. The array and its
	# values are stored in
	# ${ayaat_list_of_given_surah[*]}
	give_surah_ayats_list "$surah"

	# Let us copy the contents of the
	# ${ayaat_list_of_given_surah[*]}
	# array into
	# "$set_of_ayat_to_pass_to_tafsir_lookup"
	set_of_ayat_to_pass_to_tafsir_lookup=("${ayaat_list_of_given_surah[@]}")


	# Which of the 2 functions to invoke
	# Also searches for tafsir files in
	# $HOME/.tafsir and the root folder
	# of this very script
	if [[ "$outputFormat" == "txt" ]]
	then
	    if [ -d "$txt_tafasir_folder_thisScriptRoot" ]
	    then
		tafsir_look_up_plain_text \
		    "$txt_tafasir_folder_thisScriptRoot" \
		    "$output_surah_tafsir_file"
		
	    elif [ -d "$txt_tafasir_folder_users_home" ]
	    then
		tafsir_look_up_plain_text \
		    "$txt_tafasir_folder_users_home" \
	            "$output_surah_tafsir_file"
	    fi
	    
	elif [[ "$outputFormat" == "htm" ]]
	then
	    if [ -d "$html_tafasir_folder_thisScriptRoot" ]
	    then
		tafsir_look_up_html \
		    "$html_tafasir_folder_thisScriptRoot" \
		    "$output_surah_tafsir_file"
		
	    elif [ -d "$html_tafasir_folder_users_home" ]
	    then
		tafsir_look_up_html \
		    "$html_tafasir_folder_thisScriptRoot" \
		    "$output_surah_tafsir_file"
	    fi
	fi
	
    done
}



# This function looks very much like the
# "invoque_tafsir_lookup_full_suwar"
# function. So, I will not comment it
# much. It will be used to look for the
# tafsir of whole units of the Quran: Juz,
# Ḥizb, Rub-`ul-Ḥizb, Page-Number, etc.
# It is a copy of the above mentioned
# function. I prefer to leave it alone
# and make a copy here that I will be
# able to modify without breaking the
# program.
invoque_tafsir_lookup_koran_unit(){
    local extension="$1"
    local koran_unit_name=""

    case "$query_type_suwar_or_ayat" in
	-J )
	    koran_unit_name="Juz"
	    ;;
	-H )
	    koran_unit_name="Ḥizb"
	    ;;
	-R )
	    koran_unit_name="Rub-ul-Ḥizb"	  
	    ;;
	-P )
	    koran_unit_name="Page-Number"
	    ;;
	* )
	    echo; echo "This shouldn't have happened!"
	    echo "Internal error N°1! Check the source code."
	    echo; exit
    esac
    
    
    if [[ "$entered_koran_unit_number" =~ .*_.* ]]
    then
	OLDIFS=$IFS; IFS='_'
	read first last <<< "$entered_koran_unit_number"

	for ((a="$first"; a<="$last"; a++))
	do
	    set_of_koran_unit_to_convert_to_ayat=( "${set_of_koran_unit_to_convert_to_ayat[@]}" "$a" )
	done
	IFS=$OLDIFS
    else
	OLDIFS=$IFS; IFS=' '
	read -r -a set_of_koran_unit_to_convert_to_ayat <<< "$entered_koran_unit_number"
	IFS=$OLDIFS
    fi

    OLDIFS=$IFS; IFS=' '
    sorted_set_of_koran_unit_to_convert_to_ayat=($(sort <<<"${set_of_koran_unit_to_convert_to_ayat[*]}"))
    IFS=$OLDIFS
    
    for koran_unit in "${sorted_set_of_koran_unit_to_convert_to_ayat[@]}"
    do
	koran_unit_leadZ="$koran_unit"
	
	output_koran_unit_tafsir_file="$out_taf_file_dirname/Tafsir $koran_unit_name `printf "%03d" $((10#$koran_unit_leadZ))`.$extension"

	cat /dev/null > "$output_koran_unit_tafsir_file"

	case "$query_type_suwar_or_ayat" in
	    -J )
		# getting the list of ayaat of this unit
		show_list_of_verses_that_belong_to_this_juz "$koran_unit"

		# copying the array to our local array
		# that will be used by this function
		list_of_verses_that_belong_to_this_KORAN_UNIT=("${list_of_verses_that_belong_to_this_JUZ[@]}")
		;;
	    -H )
		show_list_of_verses_that_belong_to_this_hizb "$koran_unit"

		list_of_verses_that_belong_to_this_KORAN_UNIT=("${list_of_verses_that_belong_to_this_HIZB[@]}")
		;;
	    -R )
		show_list_of_verses_that_belong_to_this_rub_ul_hizb "$koran_unit"

		list_of_verses_that_belong_to_this_KORAN_UNIT=("${list_of_verses_that_belong_to_this_RUB_UL_HIZB[@]}")
		;;
	    -P )
		show_list_of_verses_that_belong_to_this_page_number "$koran_unit"

		list_of_verses_that_belong_to_this_KORAN_UNIT=("${list_of_verses_that_belong_to_this_PAGE_NUMBER[@]}")
		;;
	    * )
		echo; echo "This shouldn't have happened!"
		echo "Internal error N°2! Check the source code."
		echo; exit
	esac

	# Debug
	#reset; echo; echo "list_of_verses_that_belong_to_this_KORAN_UNIT:"
	#echo "${list_of_verses_that_belong_to_this_KORAN_UNIT[@]}"
	#echo; exit

	set_of_ayat_to_pass_to_tafsir_lookup=("${list_of_verses_that_belong_to_this_KORAN_UNIT[@]}")

	# Debug:
	#reset
	#echo; echo "set_of_ayat_to_pass_to_tafsir_lookup:"
	#echo "${set_of_ayat_to_pass_to_tafsir_lookup[@]}"
	#echo; exit

	# Which of the 2 functions to invoke
	# Also searches for tafsir files in
	# $HOME/.tafsir and the root folder
	# of this very script
	if [[ "$outputFormat" == "txt" ]]
	then
	    if [ -d "$txt_tafasir_folder_thisScriptRoot" ]
	    then
		tafsir_look_up_plain_text \
		    "$txt_tafasir_folder_thisScriptRoot" \
		    "$output_koran_unit_tafsir_file"
		
	    elif [ -d "$txt_tafasir_folder_users_home" ]
	    then
		tafsir_look_up_plain_text \
		    "$txt_tafasir_folder_users_home" \
	            "$output_koran_unit_tafsir_file"
	    fi
	    
	elif [[ "$outputFormat" == "htm" ]]
	then
	    if [ -d "$html_tafasir_folder_thisScriptRoot" ]
	    then
		tafsir_look_up_html \
		    "$html_tafasir_folder_thisScriptRoot" \
		    "$output_koran_unit_tafsir_file"
		
	    elif [ -d "$html_tafasir_folder_users_home" ]
	    then
		tafsir_look_up_html \
		    "$html_tafasir_folder_users_home" \
		    "$output_koran_unit_tafsir_file"
	    fi
	fi

    done
}



check_desired_format_txt_or_html_for_separate_ayaat(){
    if [[ "$outputFormat" == "txt" ]]
    then
	invoque_tafsir_lookup_separate_ayaat \
	    "$ayaat_out_txt_taf_file"
	
    elif [[ "$outputFormat" == "htm" ]]
    then
	invoque_tafsir_lookup_separate_ayaat \
	    "$ayaat_out_htm_taf_file"
    else
	echo; echo; reset
	echo "The format you entered:"
	echo
	echo \""$outputFormat"\"
	echo
	echo "is neither 'htm' nor 'txt'."
	echo "It is thus invalid!"
	echo; echo; exit
    fi
}



check_desired_format_txt_or_html_for_full_suwar(){
    if [[ "$outputFormat" == "txt" ]]
    then
	invoque_tafsir_lookup_full_suwar \
	    "$inputExt_txt"
	
    elif [[ "$outputFormat" == "htm" ]]
    then
	invoque_tafsir_lookup_full_suwar \
	    "$inputExt_html"
    else
	echo; echo; reset
	echo "The format you entered:"
	echo
	echo \""$outputFormat"\"
	echo
	echo "is neither 'htm' nor 'txt'."
	echo "It is thus invalid!"
	echo; echo; exit
    fi
}



check_desired_format_txt_or_html_for_koran_unit(){
    if [[ "$outputFormat" == "txt" ]]
    then
        invoque_tafsir_lookup_koran_unit \
	    "$inputExt_txt"
	
    elif [[ "$outputFormat" == "htm" ]]
    then
        invoque_tafsir_lookup_koran_unit \
	    "$inputExt_html"
    else
	echo; echo; reset
	echo "The format you entered:"
	echo
	echo \""$outputFormat"\"
	echo
	echo "is neither 'htm' nor 'txt'."
	echo "It is thus invalid!"
	echo; echo; exit
    fi
}



main_function(){
    if [[ "$query_type_suwar_or_ayat" == "-s" ]]
    then
	check_desired_format_txt_or_html_for_full_suwar

    elif [[ "$query_type_suwar_or_ayat" == "-a" ]]
    then
	check_desired_format_txt_or_html_for_separate_ayaat

    else # -J, -H, -R, -P
	check_desired_format_txt_or_html_for_koran_unit
    fi
}


#########################################
##### Command line parameters check #####
#########################################
usage="

 SYNOPSIS
     `basename $0` -a|--ayaat verse(s) -s|--suwar sûrah(s) -f|--tafsir-format format of the tafsir files to generate: txt || htm -h|--help -J|--juz -H|--hizb -R|--rub-ul-hizb -P|--page-number -t|--txt-tafasir -x|--htm-tafasir -o|--output-file-root
  
DESCRIPTION
 This script, if given zekr/tanzil translation/tafsir files with the
 \"*trans.zekr\" extension, or the  \"*trans.zekr.7z\" extension will
 generate/or show the tafsir one or more ayat, one or more suwar
 passed through the command line as follows:

 -a|--ayaat takes 3-digits designating the Sūrah number followed by
 3 other digits for the given verse. For example: 005012  means:
 Sūrah 5, verse 12. Here one can provide verses in this format -
 one or more, quoted  for instance: '002102 005075 009105'. One
 can also provide ayah numbers  in range. For instance:
 '001001_001007'  in such case, the separating character
 between the two ayaat numbers has to be the underscore character:

 '_'
 
 -f|--tafsir-format takes either htm or txt. Quoiting is not needed.
 This is the format in which the file should be generated.

 -s|--suwar takes  SūrahNumber  (without leading zeros). Here you can
 input many Sūrah names at the same time. For instance:  '1 9 107 50'
 ==> this is four Sūrah numbers. The list of Sūrah  has to be quoted
 also. You can also provide Sūrah numbers in range. For instance:
 '100_105', '1_13' ... In such case, the separating character between
 the two Sūrah numbers has to also be the underscore character.

 '_'

 -J|--juz generate tafsir for a given Juz, set of or range of Juz.
 -H|--hizb generate for Hizb, set of Hizb or range of Hizb.
 -R|--rub-ul-hizb generate for Rub-ul-Hizb, set of or range of Rub-ul-Hizb
 -P|--page-number generate for page, set of or range of pages
 -t|--txt-tafasir txt tafasir files folder
 -x|--htm-tafasir html tafasir files folder
 -o|--output-file-root output folder root folder
 -h|--help display this help message.

 Examples:

 ONE AYAH OR ONE SÛRAH:
 E.g.1 (v1): `basename $0` -f htm -s 15
 E.g.1 (v2): `basename $0` --tafsir-format txt --suwar 16

 E.g.2 (v1): `basename $0` -f txt -a 002102
 E.g.2 (v2): `basename $0` --tafsir-format htm --ayaat 002282

 SEPARATE ÂYÂT OR SUWAR:
 E.g.1 (v1): `basename $0` -f htm -s '1 18 111'
 E.g.1 (v2): `basename $0` --tafsir-format txt --suwar '16 17 15'

 E.g.2 (v1): `basename $0` -f txt -a '002102 002023 006100' 
 E.g.2 (v2): `basename $0` --tafsir-format htm --ayaat '002282 003156 110005'
 
 RANGE OF SUWAR OR ÂYÂT:
 E.g.1 (v1): `basename $0` -f htm -s '90_100'
 E.g.1 (v2): `basename $0` --tafsir-format txt --suwar '107_114'

 E.g.2 (v1): `basename $0` -f txt -a '002102_002110' 
 E.g.2 (v2): `basename $0` --tafsir-format htm --ayaat '002280_003010'

 in E.g.1 we generate a tafsir for the whole Sūrah 15 of the Quran,
 thus the option -s in E.g.2 we generate a tafsir for verse number 102
 of Sûratul-Baqarah, thus the  -a option and the 002102 value entered."




export error_msg_surah_juz_hizb_rubUlHizb_page="
You entered a value for either Sūrah, Juz, Ḥizb,
Rub-\`ul-Ḥizb or Page number which seems wrong.
Numeric values are needed here. You need to provide
the numbers like this:

* between 1 and 114 for Suwarr
* between 1 and 30 for Juz
* between 1 and 60 for Ḥizb
* between 1 and 240 for Rub-\`ul-Ḥizb
* between 1 and 604 for Pages

All these numbers should be provided without any
leading zeros. I.e., 1 instead of 001 and so on.
"

export error_msg_ayaat="
You entered a value for either ayah id which
seems wrong. Numeric values are needed here.
You need to provide the ayaat ids like this:
3-digits for Sūrah number + 3-digits for Ayah
number like this: 001001, 002106 or 114006.

Contrary to all other units (Juz, Ḥizb, etc.)
here, these ayaat_ids should be provided with
leading zeros. Instead of 1 provide 001 etc.
"

export error_msg_rortrl_files_creation="
You requested the creation of the
following files:

* RECITE_ONCE_LIST
* RECITE_THRICE_LIST
* RECITE_LAST_LIST

You need to create these files in case
an error happened that prevents the audios
to be played in the correct order. i.e.,
the program skips some verses or any other
reason that makes you want to do this.

This parameter takes as the sole option,
either the number '1', or any other number.
'1' makes the program generate the first
stage files: RECITE_ONCE and RECITE_THRICE
files. Any other number, other than 1, will
make the program generate RECITE_LAST file.

A numeric value should be provided here,
without quoting, i.e., 1 instead of '1' or \"1\""

error_msg_user_entered_more_than_one_unit_part1="
You already entered option:"

error_msg_user_entered_more_than_one_unit_part2="
This is the set of Suwar or Āyāt or Juz, Ḥizb ...
that you entered:"

error_msg_user_entered_more_than_one_unit_part3="
Please note that you cannot provide at the same time
the following options: -a -s -J -H -R and -P. As they
refers to different ways of arranging Quranic verses,
they cannot be queried at the same time. Choose one!
"

check_numeric_values_have_been_provided(){
    local pos_param="$1"
    local error_msg_text="$2"
    # numeric values are needed
    case "pos_param" in
	[a-z])
	    echo
	    echo "$error_msg_text"
	    echo
	    echo "The value you entered is: $pos_param"
	    echo; exit 1
	    ;;
	* )
	    # Everything is okay
	    ;;
    esac
}


if [[ -z "$1" ]] || [[ "$" == "" ]]
then
    reset
    echo "$usage"; echo
    exit
fi


OPTS=`getopt -o a:s:f:J:H:R:P:t:x:o:h --long ayaat:,suwar:,tafsir-format:,juz:,hizb:,rub-ul-hizb:,page-number:,output-file-root:,htm-tafasir:,txt-tafasir:,help -- "$@"`

if [ $? != 0 ]
then
    reset
    echo; echo "$usage"; echo
    echo " Failed parsing options." >&2
    echo    
    exit 1
fi

eval set -- "$OPTS"

while true; do
    case "$1" in
	-a|--ayaat )
	    check_numeric_values_have_been_provided "$2" "$error_msg_ayaat"
	    AYAAT_FLAG="TRUE"
	    if [[  "$SUWAR_FLAG" == "TRUE" || \
		       "$JUZ_FLAG" == "TRUE" || \
		       "$HIZB_FLAG" == "TRUE" || \
		       "$RUB_UL_HIZB_FLAG" == "TRUE" || \
		       "$PAGE_NUMBER_FLAG" == "TRUE" ]]
	    then
		echo -n "$error_msg_user_entered_more_than_one_unit_part1"
		echo "'$query_type_suwar_or_ayat'"
		#echo -n "$error_msg_user_entered_more_than_one_unit_part2"
		#echo "'$entered_set_of_suwar_or_set_of_ayat'"
		echo "$error_msg_user_entered_more_than_one_unit_part3"
		exit 1
	    fi
	    entered_set_of_suwar_or_set_of_ayat="$2"
	    query_type_suwar_or_ayat="-a"
	    shift 2
	    ;;
	-s|--suwar )
	    check_numeric_values_have_been_provided "$2" "$error_msg_surah_juz_hizb_rubUlHizb_page"
	    SUWAR_FLAG="TRUE"
	    if [[ "$AYAAT_FLAG" == "TRUE" || \
		      "$JUZ_FLAG" == "TRUE" || \
		      "$HIZB_FLAG" == "TRUE" || \
		      "$RUB_UL_HIZB_FLAG" == "TRUE" || \
		      "$PAGE_NUMBER_FLAG" == "TRUE" ]]
	    then
		echo -n "$error_msg_user_entered_more_than_one_unit_part1"
		echo "'$query_type_suwar_or_ayat'"
		#echo -n "$error_msg_user_entered_more_than_one_unit_part2"
		#echo "'$entered_set_of_suwar_or_set_of_ayat'"
		echo "$error_msg_user_entered_more_than_one_unit_part3"
		exit 1
	    fi
	    entered_set_of_suwar_or_set_of_ayat="$2"
	    query_type_suwar_or_ayat="-s"
	    shift 2
	    ;;
	-J|--juz )
	    check_numeric_values_have_been_provided "$2" "$error_msg_surah_juz_hizb_rubUlHizb_page"
	    JUZ_FLAG="TRUE"
	    if [[ "$AYAAT_FLAG" == "TRUE" || \
		      "$SUWAR_FLAG" == "TRUE" || \
		      "$HIZB_FLAG" == "TRUE" || \
		      "$RUB_UL_HIZB_FLAG" == "TRUE" || \
		      "$PAGE_NUMBER_FLAG" == "TRUE" ]]
	    then
		echo -n "$error_msg_user_entered_more_than_one_unit_part1"
		echo "'$query_type_suwar_or_ayat'"
		#echo -n "$error_msg_user_entered_more_than_one_unit_part2"
		#echo "'$entered_koran_unit_number'"
		echo "$error_msg_user_entered_more_than_one_unit_part3"
		exit 1
	    fi
	    entered_koran_unit_number="$2"
	    query_type_suwar_or_ayat="-J"
	    shift 2
	    ;;
	-H|--hizb )
	    check_numeric_values_have_been_provided "$2" "$error_msg_surah_juz_hizb_rubUlHizb_page"
	    HIZB_FLAG="TRUE"
	    if [[ "$AYAAT_FLAG" == "TRUE" || \
		      "$SUWAR_FLAG" == "TRUE" || \
		      "$JUZ_FLAG" == "TRUE" || \
		      "$RUB_UL_HIZB_FLAG" == "TRUE" || \
		      "$PAGE_NUMBER_FLAG" == "TRUE" ]]
	    then
		echo -n "$error_msg_user_entered_more_than_one_unit_part1"
		echo "'$query_type_suwar_or_ayat'"
		#echo -n "$error_msg_user_entered_more_than_one_unit_part2"
		#echo "'$entered_koran_unit_number'"
		echo "$error_msg_user_entered_more_than_one_unit_part3"
		exit 1
	    fi
	    entered_koran_unit_number="$2"
	    query_type_suwar_or_ayat="-H"
	    shift 2
	    ;;
	-R|--rub-ul-hizb )
	    check_numeric_values_have_been_provided "$2" "$error_msg_surah_juz_hizb_rubUlHizb_page"
	    RUB_UL_HIZB_FLAG="TRUE"
	    if [[ "$AYAAT_FLAG" == "TRUE" || \
		      "$SUWAR_FLAG" == "TRUE" || \
		      "$JUZ_FLAG" == "TRUE" || \
		      "$HIZB_FLAG" == "TRUE" || \
		      "$PAGE_NUMBER_FLAG" == "TRUE" ]]
	    then
		echo -n "$error_msg_user_entered_more_than_one_unit_part1"
		echo "'$query_type_suwar_or_ayat'"
		#echo -n "$error_msg_user_entered_more_than_one_unit_part2"
		#echo "'$entered_koran_unit_number'"
		echo "$error_msg_user_entered_more_than_one_unit_part3"
		exit 1
	    fi
	    entered_koran_unit_number="$2"
	    query_type_suwar_or_ayat="-R"
	    shift 2
	    ;;
	-P|--page-number )
	    check_numeric_values_have_been_provided "$2" "$error_msg_surah_juz_hizb_rubUlHizb_page"
	    PAGE_NUMBER_FLAG="TRUE"
	    if [[ "$AYAAT_FLAG" == "TRUE" || \
		      "$SUWAR_FLAG" == "TRUE" || \
		      "$JUZ_FLAG" == "TRUE" || \
		      "$HIZB_FLAG" == "TRUE" || \
		      "$RUB_UL_HIZB_FLAG" == "TRUE" ]]
	    then
		echo -n "$error_msg_user_entered_more_than_one_unit_part1"
		echo "'$query_type_suwar_or_ayat'"
		#echo -n "$error_msg_user_entered_more_than_one_unit_part2"
		#echo "'$entered_koran_unit_number'"
		echo "$error_msg_user_entered_more_than_one_unit_part3"
		exit 1
	    fi
	    entered_koran_unit_number="$2"
	    query_type_suwar_or_ayat="-P"
	    shift 2
	    ;;
	-t|--txt-tafasir )
	    # Overrive the script's root
	    # folder tafsir folder value
	    txt_tafasir_folder_thisScriptRoot="$2"
	    # Overrive the user's home
	    # folder tafsir folder value
	    txt_tafasir_folder_users_home=""
	    shift 2
	    ;;
	-x|--htm-tafasir )
	    # Overrive the script's root
	    # folder tafsir folder value
	    html_tafasir_folder_thisScriptRoot="$2"
	    # Overrive the user's home
	    # folder tafsir folder value
	    html_tafasir_folder_users_home=""
	    shift 2
	    ;;
	-o|--output-file-root )
	    # Try to create the folder
	    mkdir -p "${2}"
	    #
	    # If we were able to create the folder
	    # we'll use it, otherwise we work
	    # with the default one.
	    if [[ -d "${2}" ]]
	    then
		out_taf_file_dirname="${2}"
		ayaat_out_txt_taf_file="${2}/tafsir.txt"
		ayaat_out_htm_taf_file="${2}/tafsir.html"
	    else
		echo
		echo "The folder you provided is not accessible:"
		echo "${2}"; echo
		echo "We revert to the default one."
	    fi
	    shift 2
	    ;;	
	-f|--tafsir-format )
	    if [[ ! "$2" == "txt" && \
		      ! "$2" == "htm" && \
		      ! "$2" == "t" && \
		      ! "$2" == "h" ]]
	    then
		echo
		echo "By entering option -f or --tafsir-format,"
		echo "you choose the format of the output tafsir"
		echo "file. '-f htm' or '--tafsir-format htm'"
		echo "will generate an html file. Note that this"
		echo "is the default behaviour. Replace the 'htm'"
		echo "value with 'txt' to generate a plain text file"
		echo "Here, the value you provided is neither 'htm'"
		echo "nor 'txt'. Note that for simplicity, you can"
		echo "replace 'txt' with 't' and 'htm' with 'h'."
		echo "This is what you entered: $2"
		echo; exit
	    fi
	    outputFormat="$2"
	    shift 2
	    ;;
	-h|---help )
	    reset
	    echo "$usage"
	    shift
	    ;;
	-- )
	    shift
	    break
	    ;;
    esac
done




# This will trigger every needed
# function and launch the tafsir
# files generation
main_function

exit $? # Script execution never gets past this line

####################
# Some array manipulation scripts

# get length of an array
aLength=${#ayaat_list_of_given_surah[@]}

# echo the whole contents of an array
printf "%s\n" "${ayaat_list_of_given_surah[@]}"

echo ${ayaat_list_of_given_surah[@]} | tr " " "\n"

for ayah in "${ayaat_list_of_given_surah[@]}"; do echo "$ayah"; done

cat <<EOF

The features of this script
** Can generate html tafsir files
** Can generate plain text tafsir files

* the app has the ability to: ([55%] [5/9])
 1. [X] create a html output file
 2. [X] create a txt output file
 3. [X] generate tafsir for a single ayah
 4. [X] generate tafsir for many ayat provided by the user
 5. [X] generate tafsir for whole Sûwar (user provides Sūrah number)
 6. [ ] launch Firefox/Chrome with the html tafsir file
 7. [ ] copy the txt file contents to the android clipboard
 8. [ ] launch @voice-aloud-reader with the txt file
 9. [ ] launch @voice-aloud-reader with the html file

EOF

# Check a program is installed
type foo >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
hash foo 2>/dev/null || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }




if [[ "$AYAAT_FLAG" == "TRUE" || \
	  "$SUWAR_FLAG" == "TRUE" || \
	  "$JUZ_FLAG" == "TRUE" || \
	  "$HIZB_FLAG" == "TRUE" || \
	  "$RUB_UL_HIZB_FLAG" == "TRUE" || \
	  "$PAGE_NUMBER_FLAG" == "TRUE" ]]
then
    echo
    echo "$error_msg_user_entered_more_than_one_unit"
    exit 1
fi
