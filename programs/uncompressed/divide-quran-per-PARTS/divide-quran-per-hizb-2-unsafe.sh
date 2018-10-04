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
# Karim ibn Mu?ammad as-Salafî
#
# Extension of input files
export inputExt="oga"
# Remove file extension otherwise filename expansion wouldn't be possible
for file in *."$inputExt"; do echo "$file"; done | parallel --bar 'mv -f {} {.}'

mkdir {01..60}

mv -f {001001..002074} 01
mv -f {002075..002141} 02
mv -f {002142..002202} 03
mv -f {002203..002252} 04
mv -f {002253..003014} 05
mv -f {003015..003092} 06
mv -f {003093..003170} 07
mv -f {003171..004023} 08
mv -f {004024..004087} 09
mv -f {004088..004147} 10
mv -f {004148..005026} 11
mv -f {005027..005081} 12
mv -f {005082..006035} 13
mv -f {006036..006110} 14
mv -f {006111..006165} 15
mv -f {006166..007087} 16
mv -f {007088..007170} 17
mv -f {007171..008040} 18
mv -f {008041..009033} 19
mv -f {009034..009092} 20
mv -f {009093..010025} 21
mv -f {010026..011005} 22
mv -f {011006..011083} 23
mv -f {011084..012052} 24
mv -f {012053..013018} 25
mv -f {013019..014052} 26
mv -f {014053..016050} 27
mv -f {016051..016128} 28
mv -f {016129..017098} 29
mv -f {017099..018074} 30
mv -f {018075..019098} 31
mv -f {019099..020135} 32
mv -f {020136..021112} 33
mv -f {021113..022078} 34
mv -f {022079..024020} 35
mv -f {024021..025020} 36
mv -f {025021..026110} 37
mv -f {026111..027055} 38
mv -f {027056..028050} 39
mv -f {028051..029045} 40
mv -f {029046..031021} 41
mv -f {031022..033030} 42
mv -f {033031..034023} 43
mv -f {034024..036027} 44
mv -f {036028..037144} 45
mv -f {037145..039031} 46
mv -f {039032..040040} 47
mv -f {040041..041046} 48
mv -f {041047..043023} 49
mv -f {043024..045037} 50
mv -f {045038..048017} 51
mv -f {048018..051030} 52
mv -f {051031..054055} 53
mv -f {054056..057029} 54
mv -f {057030..061014} 55
mv -f {061015..066012} 56
mv -f {066013..071028} 57
mv -f {071029..077050} 58
mv -f {077051..086017} 59
mv -f {086018..114006} 60

# Restore file extension
restore_file_extension(){
    for file in *
    do
	if [ -d "$file" ]
	then
	    cd "$file" && parallel 'mv -f {} {}."$inputExt"' ::: *
	    cd ..
	fi
    done
}

restore_file_extension
exit $?
