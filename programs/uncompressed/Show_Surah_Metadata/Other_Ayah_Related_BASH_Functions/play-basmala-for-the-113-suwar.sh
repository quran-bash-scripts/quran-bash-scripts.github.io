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
# Karim ibn Muammad as-Salafî
#

play_bismillah(){
    local file="$1"
    case $file in
	001001 | 002001 | 003001 | 004001 | 005001 | \
            006001 | 007001 | 008001 | 010001 | \
            011001 | 012001 | 013001 | 014001 | 015001 | \
            016001 | 017001 | 018001 | 019001 | 020001 | \
            021001 | 022001 | 023001 | 024001 | 025001 | \
            026001 | 027001 | 028001 | 029001 | 030001 | \
            031001 | 032001 | 033001 | 034001 | 035001 | \
            036001 | 037001 | 038001 | 039001 | 040001 | \
            041001 | 042001 | 043001 | 044001 | 045001 | \
            046001 | 047001 | 048001 | 049001 | 050001 | \
            051001 | 052001 | 053001 | 054001 | 055001 | \
            056001 | 057001 | 058001 | 059001 | 060001 | \
            061001 | 062001 | 063001 | 064001 | 065001 | \
            066001 | 067001 | 068001 | 069001 | 070001 | \
            071001 | 072001 | 073001 | 074001 | 075001 | \
            076001 | 077001 | 078001 | 079001 | 080001 | \
            081001 | 082001 | 083001 | 084001 | 085001 | \
            086001 | 087001 | 088001 | 089001 | 090001 | \
            091001 | 092001 | 093001 | 094001 | 095001 | \
            096001 | 097001 | 098001 | 099001 | 100001 | \
            101001 | 102001 | 103001 | 104001 | 105001 | \
            106001 | 107001 | 108001 | 109001 | 110001 | \
            111001 | 112001 | 113001 | 114001 )
            mpv --vid=no --speed 1.75 $thisScriptFullPath/bismillah.oga
            ;;
    esac
}

play_bismillah "${1}"

