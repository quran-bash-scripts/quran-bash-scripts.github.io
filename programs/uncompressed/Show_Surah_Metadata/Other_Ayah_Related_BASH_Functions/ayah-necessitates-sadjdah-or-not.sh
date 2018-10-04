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
# Copyright (C) Hijri 1439, 1440
#
# Copyright (C) Gregorian 2017, 2018 Abu-Djuwairiyyah
# Karim ibn Muḥammad as-Salafî
#

export sadjdah=""

necessitates_sadjdah_or_not(){
    local file="$1"
    case $file in
	007206 | 013015 | 016050 | 017109 | 019058 | 022018 | 022077 | 025060 | 027026 | 032015 | 038024 | 041038 | 053062 | 084021 | 096019 )
            sadjdah="Yes ۩"
            #sleep 2
            #$play_helper_audio --speed 1.0 $thisScriptFullPath/sujud-at-tilawa-1.oga
            #sleep 2
            #$play_helper_audio --speed 1.0 $thisScriptFullPath/sujud-at-tilawa-2.oga
            termux-vibrate &
           
;;
	*)
            sadjdah="No"
;;
    esac
}

necessitates_sadjdah_or_not "${1}"

echo; echo "Does your verse necessitate Sudjûd ?"
echo "Answer: $sadjdah"
echo
exit $?
