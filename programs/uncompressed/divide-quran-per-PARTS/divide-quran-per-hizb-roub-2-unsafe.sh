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
# Extension of input files
export inputExt="oga"
# Remove file extension otherwise filename expansion wouldn't be possible
for file in *."$inputExt"; do echo "$file"; done | parallel --bar 'mv -f {} {.}'

mkdir -p 001 && mv -f {001001..002025} 001
mkdir -p 002 && mv -f {002026..002043} 002
mkdir -p 003 && mv -f {002044..002059} 003
mkdir -p 004 && mv -f {002060..002074} 004
mkdir -p 005 && mv -f {002075..002091} 005
mkdir -p 006 && mv -f {002092..002105} 006
mkdir -p 007 && mv -f {002106..002123} 007
mkdir -p 008 && mv -f {002124..002141} 008
mkdir -p 009 && mv -f {002142..002157} 009
mkdir -p 010 && mv -f {002158..002176} 010
mkdir -p 011 && mv -f {002177..002188} 011
mkdir -p 012 && mv -f {002189..002202} 012
mkdir -p 013 && mv -f {002203..002218} 013
mkdir -p 014 && mv -f {002219..002232} 014
mkdir -p 015 && mv -f {002233..002242} 015
mkdir -p 016 && mv -f {002243..002252} 016
mkdir -p 017 && mv -f {002253..002262} 017
mkdir -p 018 && mv -f {002263..002271} 018
mkdir -p 019 && mv -f {002272..002282} 019
mkdir -p 020 && mv -f {002283..003014} 020
mkdir -p 021 && mv -f {003015..003032} 021
mkdir -p 022 && mv -f {003033..003051} 022
mkdir -p 023 && mv -f {003052..003074} 023
mkdir -p 024 && mv -f {003075..003092} 024
mkdir -p 025 && mv -f {003093..003112} 025
mkdir -p 026 && mv -f {003113..003132} 026
mkdir -p 027 && mv -f {003133..003152} 027
mkdir -p 028 && mv -f {003153..003170} 028
mkdir -p 029 && mv -f {003171..003185} 029
mkdir -p 030 && mv -f {003186..003200} 030
mkdir -p 031 && mv -f {004001..004011} 031
mkdir -p 032 && mv -f {004012..004023} 032
mkdir -p 033 && mv -f {004024..004035} 033
mkdir -p 034 && mv -f {004036..004057} 034
mkdir -p 035 && mv -f {004058..004073} 035
mkdir -p 036 && mv -f {004074..004087} 036
mkdir -p 037 && mv -f {004088..004099} 037
mkdir -p 038 && mv -f {004100..004113} 038
mkdir -p 039 && mv -f {004114..004134} 039
mkdir -p 040 && mv -f {004135..004147} 040
mkdir -p 041 && mv -f {004148..004162} 041
mkdir -p 042 && mv -f {004163..004176} 042
mkdir -p 043 && mv -f {005001..005011} 043
mkdir -p 044 && mv -f {005012..005026} 044
mkdir -p 045 && mv -f {005027..005040} 045
mkdir -p 046 && mv -f {005041..005050} 046
mkdir -p 047 && mv -f {005051..005066} 047
mkdir -p 048 && mv -f {005067..005081} 048
mkdir -p 049 && mv -f {005082..005096} 049
mkdir -p 050 && mv -f {005097..005108} 050
mkdir -p 051 && mv -f {005109..006012} 051
mkdir -p 052 && mv -f {006013..006035} 052
mkdir -p 053 && mv -f {006036..006058} 053
mkdir -p 054 && mv -f {006059..006073} 054
mkdir -p 055 && mv -f {006074..006094} 055
mkdir -p 056 && mv -f {006095..006110} 056
mkdir -p 057 && mv -f {006111..006126} 057
mkdir -p 058 && mv -f {006127..006140} 058
mkdir -p 059 && mv -f {006141..006150} 059
mkdir -p 060 && mv -f {006151..006165} 060
mkdir -p 061 && mv -f {007001..007030} 061
mkdir -p 062 && mv -f {007031..007046} 062
mkdir -p 063 && mv -f {007047..007064} 063
mkdir -p 064 && mv -f {007065..007087} 064
mkdir -p 065 && mv -f {007088..007116} 065
mkdir -p 066 && mv -f {007117..007141} 066
mkdir -p 067 && mv -f {007142..007155} 067
mkdir -p 068 && mv -f {007156..007170} 068
mkdir -p 069 && mv -f {007171..007188} 069
mkdir -p 070 && mv -f {007189..007206} 070
mkdir -p 071 && mv -f {008001..008021} 071
mkdir -p 072 && mv -f {008022..008040} 072
mkdir -p 073 && mv -f {008041..008060} 073
mkdir -p 074 && mv -f {008061..008075} 074
mkdir -p 075 && mv -f {009001..009018} 075
mkdir -p 076 && mv -f {009019..009033} 076
mkdir -p 077 && mv -f {009034..009045} 077
mkdir -p 078 && mv -f {009046..009059} 078
mkdir -p 079 && mv -f {009060..009074} 079
mkdir -p 080 && mv -f {009075..009092} 080
mkdir -p 081 && mv -f {009093..009110} 081
mkdir -p 082 && mv -f {009111..009121} 082
mkdir -p 083 && mv -f {009122..010010} 083
mkdir -p 084 && mv -f {010011..010025} 084
mkdir -p 085 && mv -f {010026..010052} 085
mkdir -p 086 && mv -f {010053..010070} 086
mkdir -p 087 && mv -f {010071..010089} 087
mkdir -p 088 && mv -f {010090..011005} 088
mkdir -p 089 && mv -f {011006..011023} 089
mkdir -p 090 && mv -f {011024..011040} 090
mkdir -p 091 && mv -f {011041..011060} 091
mkdir -p 092 && mv -f {011061..011083} 092
mkdir -p 093 && mv -f {011084..011107} 093
mkdir -p 094 && mv -f {011108..012006} 094
mkdir -p 095 && mv -f {012007..012029} 095
mkdir -p 096 && mv -f {012030..012052} 096
mkdir -p 097 && mv -f {012053..012076} 097
mkdir -p 098 && mv -f {012077..012100} 098
mkdir -p 099 && mv -f {012101..013004} 099
mkdir -p 100 && mv -f {013005..013018} 100
mkdir -p 101 && mv -f {013019..013034} 101
mkdir -p 102 && mv -f {013035..014009} 102
mkdir -p 103 && mv -f {014010..014027} 103
mkdir -p 104 && mv -f {014028..014052} 104
mkdir -p 105 && mv -f {015001..015049} 105
mkdir -p 106 && mv -f {015050..015099} 106
mkdir -p 107 && mv -f {016001..016029} 107
mkdir -p 108 && mv -f {016030..016050} 108
mkdir -p 109 && mv -f {016051..016074} 109
mkdir -p 110 && mv -f {016075..016089} 110
mkdir -p 111 && mv -f {016090..016110} 111
mkdir -p 112 && mv -f {016111..016128} 112
mkdir -p 113 && mv -f {017001..017022} 113
mkdir -p 114 && mv -f {017023..017049} 114
mkdir -p 115 && mv -f {017050..017069} 115
mkdir -p 116 && mv -f {017070..017098} 116
mkdir -p 117 && mv -f {017099..018016} 117
mkdir -p 118 && mv -f {018017..018031} 118
mkdir -p 119 && mv -f {018032..018050} 119
mkdir -p 120 && mv -f {018051..018074} 120
mkdir -p 121 && mv -f {018075..018098} 121
mkdir -p 122 && mv -f {018099..019021} 122
mkdir -p 123 && mv -f {019022..019058} 123
mkdir -p 124 && mv -f {019059..019098} 124
mkdir -p 125 && mv -f {020001..020054} 125
mkdir -p 126 && mv -f {020055..020082} 126
mkdir -p 127 && mv -f {020083..020110} 127
mkdir -p 128 && mv -f {020111..020135} 128
mkdir -p 129 && mv -f {021001..021028} 129
mkdir -p 130 && mv -f {021029..021050} 130
mkdir -p 131 && mv -f {021051..021082} 131
mkdir -p 132 && mv -f {021083..021112} 132
mkdir -p 133 && mv -f {022001..022018} 133
mkdir -p 134 && mv -f {022019..022037} 134
mkdir -p 135 && mv -f {022038..022059} 135
mkdir -p 136 && mv -f {022060..022078} 136
mkdir -p 137 && mv -f {023001..023035} 137
mkdir -p 138 && mv -f {023036..023074} 138
mkdir -p 139 && mv -f {023075..023118} 139
mkdir -p 140 && mv -f {024001..024020} 140
mkdir -p 141 && mv -f {024021..024034} 141
mkdir -p 142 && mv -f {024035..024052} 142
mkdir -p 143 && mv -f {024053..024064} 143
mkdir -p 144 && mv -f {025001..025020} 144
mkdir -p 145 && mv -f {025021..025052} 145
mkdir -p 146 && mv -f {025053..025077} 146
mkdir -p 147 && mv -f {026001..026051} 147
mkdir -p 148 && mv -f {026052..026110} 148
mkdir -p 149 && mv -f {026111..026180} 149
mkdir -p 150 && mv -f {026181..026227} 150
mkdir -p 151 && mv -f {027001..027026} 151
mkdir -p 152 && mv -f {027027..027055} 152
mkdir -p 153 && mv -f {027056..027081} 153
mkdir -p 154 && mv -f {027082..028011} 154
mkdir -p 155 && mv -f {028012..028028} 155
mkdir -p 156 && mv -f {028029..028050} 156
mkdir -p 157 && mv -f {028051..028075} 157
mkdir -p 158 && mv -f {028076..028088} 158
mkdir -p 159 && mv -f {029001..029025} 159
mkdir -p 160 && mv -f {029026..029045} 160
mkdir -p 161 && mv -f {029046..029069} 161
mkdir -p 162 && mv -f {030001..030030} 162
mkdir -p 163 && mv -f {030031..030053} 163
mkdir -p 164 && mv -f {030054..031021} 164
mkdir -p 165 && mv -f {031022..032010} 165
mkdir -p 166 && mv -f {032011..032030} 166
mkdir -p 167 && mv -f {033001..033017} 167
mkdir -p 168 && mv -f {033018..033030} 168
mkdir -p 169 && mv -f {033031..033050} 169
mkdir -p 170 && mv -f {033051..033059} 170
mkdir -p 171 && mv -f {033060..034009} 171
mkdir -p 172 && mv -f {034010..034023} 172
mkdir -p 173 && mv -f {034024..034045} 173
mkdir -p 174 && mv -f {034046..035014} 174
mkdir -p 175 && mv -f {035015..035040} 175
mkdir -p 176 && mv -f {035041..036027} 176
mkdir -p 177 && mv -f {036028..036059} 177
mkdir -p 178 && mv -f {036060..037021} 178
mkdir -p 179 && mv -f {037022..037082} 179
mkdir -p 180 && mv -f {037083..037144} 180
mkdir -p 181 && mv -f {037145..038020} 181
mkdir -p 182 && mv -f {038021..038051} 182
mkdir -p 183 && mv -f {038052..039007} 183
mkdir -p 184 && mv -f {039008..039031} 184
mkdir -p 185 && mv -f {039032..039052} 185
mkdir -p 186 && mv -f {039053..039075} 186
mkdir -p 187 && mv -f {040001..040020} 187
mkdir -p 188 && mv -f {040021..040040} 188
mkdir -p 189 && mv -f {040041..040065} 189
mkdir -p 190 && mv -f {040066..041008} 190
mkdir -p 191 && mv -f {041009..041024} 191
mkdir -p 192 && mv -f {041025..041046} 192
mkdir -p 193 && mv -f {041047..042012} 193
mkdir -p 194 && mv -f {042013..042026} 194
mkdir -p 195 && mv -f {042027..042050} 195
mkdir -p 196 && mv -f {042051..043023} 196
mkdir -p 197 && mv -f {043024..043056} 197
mkdir -p 198 && mv -f {043057..044016} 198
mkdir -p 199 && mv -f {044017..045011} 199
mkdir -p 200 && mv -f {045012..045037} 200
mkdir -p 201 && mv -f {046001..046020} 201
mkdir -p 202 && mv -f {046021..047009} 202
mkdir -p 203 && mv -f {047010..047032} 203
mkdir -p 204 && mv -f {047033..048017} 204
mkdir -p 205 && mv -f {048018..048029} 205
mkdir -p 206 && mv -f {049001..049013} 206
mkdir -p 207 && mv -f {049014..050026} 207
mkdir -p 208 && mv -f {050027..051030} 208
mkdir -p 209 && mv -f {051031..052023} 209
mkdir -p 210 && mv -f {052024..053025} 210
mkdir -p 211 && mv -f {053026..054008} 211
mkdir -p 212 && mv -f {054009..054055} 212
mkdir -p 213 && mv -f {055001..055078} 213
mkdir -p 214 && mv -f {056001..056074} 214
mkdir -p 215 && mv -f {056075..057015} 215
mkdir -p 216 && mv -f {057016..057029} 216
mkdir -p 217 && mv -f {058001..058013} 217
mkdir -p 218 && mv -f {058014..059010} 218
mkdir -p 219 && mv -f {059011..060006} 219
mkdir -p 220 && mv -f {060007..061014} 220
mkdir -p 221 && mv -f {062001..063003} 221
mkdir -p 222 && mv -f {063004..064018} 222
mkdir -p 223 && mv -f {065001..065012} 223
mkdir -p 224 && mv -f {066001..066012} 224
mkdir -p 225 && mv -f {067001..067030} 225
mkdir -p 226 && mv -f {068001..068052} 226
mkdir -p 227 && mv -f {069001..070018} 227
mkdir -p 228 && mv -f {070019..071028} 228
mkdir -p 229 && mv -f {072001..073019} 229
mkdir -p 230 && mv -f {073020..074056} 230
mkdir -p 231 && mv -f {075001..076018} 231
mkdir -p 232 && mv -f {076019..077050} 232
mkdir -p 233 && mv -f {078001..079046} 233
mkdir -p 234 && mv -f {080001..081029} 234
mkdir -p 235 && mv -f {082001..083036} 235
mkdir -p 236 && mv -f {084001..086017} 236
mkdir -p 237 && mv -f {087001..089030} 237
mkdir -p 238 && mv -f {090001..093011} 238
mkdir -p 239 && mv -f {094001..100008} 239
mkdir -p 240 && mv -f {100009..114006} 240

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
