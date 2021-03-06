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
# Karim ibn Muammad as-Salaf�
#

# Extension of input files
export inputExt="oga"
# Remove file extension otherwise filename expansion wouldn't be possible
for file in *"$inputExt"; do echo "$file"; done | parallel --bar 'mv -f {} {.}'

mkdir -p 001 && mv -f {001001..001007} 001
mkdir -p 002 && mv -f {002001..002005} 002
mkdir -p 003 && mv -f {002006..002016} 003
mkdir -p 004 && mv -f {002017..002024} 004
mkdir -p 005 && mv -f {002025..002029} 005
mkdir -p 006 && mv -f {002030..002037} 006
mkdir -p 007 && mv -f {002038..002048} 007
mkdir -p 008 && mv -f {002049..002057} 008
mkdir -p 009 && mv -f {002058..002061} 009
mkdir -p 010 && mv -f {002062..002069} 010
mkdir -p 011 && mv -f {002070..002076} 011
mkdir -p 012 && mv -f {002077..002083} 012
mkdir -p 013 && mv -f {002084..002088} 013
mkdir -p 014 && mv -f {002089..002093} 014
mkdir -p 015 && mv -f {002094..002101} 015
mkdir -p 016 && mv -f {002102..002105} 016
mkdir -p 017 && mv -f {002106..002112} 017
mkdir -p 018 && mv -f {002113..002119} 018
mkdir -p 019 && mv -f {002120..002126} 019
mkdir -p 020 && mv -f {002127..002134} 020
mkdir -p 021 && mv -f {002135..002141} 021
mkdir -p 022 && mv -f {002142..002145} 022
mkdir -p 023 && mv -f {002146..002153} 023
mkdir -p 024 && mv -f {002154..002163} 024
mkdir -p 025 && mv -f {002164..002169} 025
mkdir -p 026 && mv -f {002170..002176} 026
mkdir -p 027 && mv -f {002177..002181} 027
mkdir -p 028 && mv -f {002182..002186} 028
mkdir -p 029 && mv -f {002187..002190} 029
mkdir -p 030 && mv -f {002191..002196} 030
mkdir -p 031 && mv -f {002197..002202} 031
mkdir -p 032 && mv -f {002203..002210} 032
mkdir -p 033 && mv -f {002211..002215} 033
mkdir -p 034 && mv -f {002216..002219} 034
mkdir -p 035 && mv -f {002220..002224} 035
mkdir -p 036 && mv -f {002225..002230} 036
mkdir -p 037 && mv -f {002231..002233} 037
mkdir -p 038 && mv -f {002234..002237} 038
mkdir -p 039 && mv -f {002238..002245} 039
mkdir -p 040 && mv -f {002246..002248} 040
mkdir -p 041 && mv -f {002249..002252} 041
mkdir -p 042 && mv -f {002253..002256} 042
mkdir -p 043 && mv -f {002257..002259} 043
mkdir -p 044 && mv -f {002260..002264} 044
mkdir -p 045 && mv -f {002265..002269} 045
mkdir -p 046 && mv -f {002270..002274} 046
mkdir -p 047 && mv -f {002275..002281} 047
mkdir -p 048 && mv -f {002282..002282} 048
mkdir -p 049 && mv -f {002283..002286} 049
mkdir -p 050 && mv -f {003001..003009} 050
mkdir -p 051 && mv -f {003010..003015} 051
mkdir -p 052 && mv -f {003016..003022} 052
mkdir -p 053 && mv -f {003023..003029} 053
mkdir -p 054 && mv -f {003030..003037} 054
mkdir -p 055 && mv -f {003038..003045} 055
mkdir -p 056 && mv -f {003046..003052} 056
mkdir -p 057 && mv -f {003053..003061} 057
mkdir -p 058 && mv -f {003062..003070} 058
mkdir -p 059 && mv -f {003071..003077} 059
mkdir -p 060 && mv -f {003078..003083} 060
mkdir -p 061 && mv -f {003084..003091} 061
mkdir -p 062 && mv -f {003092..003100} 062
mkdir -p 063 && mv -f {003101..003108} 063
mkdir -p 064 && mv -f {003109..003115} 064
mkdir -p 065 && mv -f {003116..003121} 065
mkdir -p 066 && mv -f {003122..003132} 066
mkdir -p 067 && mv -f {003133..003140} 067
mkdir -p 068 && mv -f {003141..003148} 068
mkdir -p 069 && mv -f {003149..003153} 069
mkdir -p 070 && mv -f {003154..003157} 070
mkdir -p 071 && mv -f {003158..003165} 071
mkdir -p 072 && mv -f {003166..003173} 072
mkdir -p 073 && mv -f {003174..003180} 073
mkdir -p 074 && mv -f {003181..003186} 074
mkdir -p 075 && mv -f {003187..003194} 075
mkdir -p 076 && mv -f {003195..003200} 076
mkdir -p 077 && mv -f {004001..004006} 077
mkdir -p 078 && mv -f {004007..004011} 078
mkdir -p 079 && mv -f {004012..004014} 079
mkdir -p 080 && mv -f {004015..004019} 080
mkdir -p 081 && mv -f {004020..004023} 081
mkdir -p 082 && mv -f {004024..004026} 082
mkdir -p 083 && mv -f {004027..004033} 083
mkdir -p 084 && mv -f {004034..004037} 084
mkdir -p 085 && mv -f {004038..004044} 085
mkdir -p 086 && mv -f {004045..004051} 086
mkdir -p 087 && mv -f {004052..004059} 087
mkdir -p 088 && mv -f {004060..004065} 088
mkdir -p 089 && mv -f {004066..004074} 089
mkdir -p 090 && mv -f {004075..004079} 090
mkdir -p 091 && mv -f {004080..004086} 091
mkdir -p 092 && mv -f {004087..004091} 092
mkdir -p 093 && mv -f {004092..004094} 093
mkdir -p 094 && mv -f {004095..004101} 094
mkdir -p 095 && mv -f {004102..004105} 095
mkdir -p 096 && mv -f {004106..004113} 096
mkdir -p 097 && mv -f {004114..004121} 097
mkdir -p 098 && mv -f {004122..004127} 098
mkdir -p 099 && mv -f {004128..004134} 099
mkdir -p 100 && mv -f {004135..004140} 100
mkdir -p 101 && mv -f {004141..004147} 101
mkdir -p 102 && mv -f {004148..004154} 102
mkdir -p 103 && mv -f {004155..004162} 103
mkdir -p 104 && mv -f {004163..004170} 104
mkdir -p 105 && mv -f {004171..004175} 105
mkdir -p 106 && mv -f {004176..005002} 106
mkdir -p 107 && mv -f {005003..005005} 107
mkdir -p 108 && mv -f {005006..005009} 108
mkdir -p 109 && mv -f {005010..005013} 109
mkdir -p 110 && mv -f {005014..005017} 110
mkdir -p 111 && mv -f {005018..005023} 111
mkdir -p 112 && mv -f {005024..005031} 112
mkdir -p 113 && mv -f {005032..005036} 113
mkdir -p 114 && mv -f {005037..005041} 114
mkdir -p 115 && mv -f {005042..005045} 115
mkdir -p 116 && mv -f {005046..005050} 116
mkdir -p 117 && mv -f {005051..005057} 117
mkdir -p 118 && mv -f {005058..005064} 118
mkdir -p 119 && mv -f {005065..005070} 119
mkdir -p 120 && mv -f {005071..005076} 120
mkdir -p 121 && mv -f {005077..005082} 121
mkdir -p 122 && mv -f {005083..005089} 122
mkdir -p 123 && mv -f {005090..005095} 123
mkdir -p 124 && mv -f {005096..005103} 124
mkdir -p 125 && mv -f {005104..005108} 125
mkdir -p 126 && mv -f {005109..005113} 126
mkdir -p 127 && mv -f {005114..005120} 127
mkdir -p 128 && mv -f {006001..006008} 128
mkdir -p 129 && mv -f {006009..006018} 129
mkdir -p 130 && mv -f {006019..006027} 130
mkdir -p 131 && mv -f {006028..006035} 131
mkdir -p 132 && mv -f {006036..006044} 132
mkdir -p 133 && mv -f {006045..006052} 133
mkdir -p 134 && mv -f {006053..006059} 134
mkdir -p 135 && mv -f {006060..006068} 135
mkdir -p 136 && mv -f {006069..006073} 136
mkdir -p 137 && mv -f {006074..006081} 137
mkdir -p 138 && mv -f {006082..006090} 138
mkdir -p 139 && mv -f {006091..006094} 139
mkdir -p 140 && mv -f {006095..006101} 140
mkdir -p 141 && mv -f {006102..006110} 141
mkdir -p 142 && mv -f {006111..006118} 142
mkdir -p 143 && mv -f {006119..006124} 143
mkdir -p 144 && mv -f {006125..006131} 144
mkdir -p 145 && mv -f {006132..006137} 145
mkdir -p 146 && mv -f {006138..006142} 146
mkdir -p 147 && mv -f {006143..006146} 147
mkdir -p 148 && mv -f {006147..006151} 148
mkdir -p 149 && mv -f {006152..006157} 149
mkdir -p 150 && mv -f {006158..006165} 150
mkdir -p 151 && mv -f {007001..007011} 151
mkdir -p 152 && mv -f {007012..007022} 152
mkdir -p 153 && mv -f {007023..007030} 153
mkdir -p 154 && mv -f {007031..007037} 154
mkdir -p 155 && mv -f {007038..007043} 155
mkdir -p 156 && mv -f {007044..007051} 156
mkdir -p 157 && mv -f {007052..007057} 157
mkdir -p 158 && mv -f {007058..007067} 158
mkdir -p 159 && mv -f {007068..007073} 159
mkdir -p 160 && mv -f {007074..007081} 160
mkdir -p 161 && mv -f {007082..007087} 161
mkdir -p 162 && mv -f {007088..007095} 162
mkdir -p 163 && mv -f {007096..007104} 163
mkdir -p 164 && mv -f {007105..007120} 164
mkdir -p 165 && mv -f {007121..007130} 165
mkdir -p 166 && mv -f {007131..007137} 166
mkdir -p 167 && mv -f {007138..007143} 167
mkdir -p 168 && mv -f {007144..007149} 168
mkdir -p 169 && mv -f {007150..007155} 169
mkdir -p 170 && mv -f {007156..007159} 170
mkdir -p 171 && mv -f {007160..007163} 171
mkdir -p 172 && mv -f {007164..007170} 172
mkdir -p 173 && mv -f {007171..007178} 173
mkdir -p 174 && mv -f {007179..007187} 174
mkdir -p 175 && mv -f {007188..007195} 175
mkdir -p 176 && mv -f {007196..007206} 176
mkdir -p 177 && mv -f {008001..008008} 177
mkdir -p 178 && mv -f {008009..008016} 178
mkdir -p 179 && mv -f {008017..008025} 179
mkdir -p 180 && mv -f {008026..008033} 180
mkdir -p 181 && mv -f {008034..008040} 181
mkdir -p 182 && mv -f {008041..008045} 182
mkdir -p 183 && mv -f {008046..008052} 183
mkdir -p 184 && mv -f {008053..008061} 184
mkdir -p 185 && mv -f {008062..008069} 185
mkdir -p 186 && mv -f {008070..008075} 186
mkdir -p 187 && mv -f {009001..009006} 187
mkdir -p 188 && mv -f {009007..009013} 188
mkdir -p 189 && mv -f {009014..009020} 189
mkdir -p 190 && mv -f {009021..009026} 190
mkdir -p 191 && mv -f {009027..009031} 191
mkdir -p 192 && mv -f {009032..009036} 192
mkdir -p 193 && mv -f {009037..009040} 193
mkdir -p 194 && mv -f {009041..009047} 194
mkdir -p 195 && mv -f {009048..009054} 195
mkdir -p 196 && mv -f {009055..009061} 196
mkdir -p 197 && mv -f {009062..009068} 197
mkdir -p 198 && mv -f {009069..009072} 198
mkdir -p 199 && mv -f {009073..009079} 199
mkdir -p 200 && mv -f {009080..009086} 200
mkdir -p 201 && mv -f {009087..009093} 201
mkdir -p 202 && mv -f {009094..009099} 202
mkdir -p 203 && mv -f {009100..009106} 203
mkdir -p 204 && mv -f {009107..009111} 204
mkdir -p 205 && mv -f {009112..009117} 205
mkdir -p 206 && mv -f {009118..009122} 206
mkdir -p 207 && mv -f {009123..009129} 207
mkdir -p 208 && mv -f {010001..010006} 208
mkdir -p 209 && mv -f {010007..010014} 209
mkdir -p 210 && mv -f {010015..010020} 210
mkdir -p 211 && mv -f {010021..010025} 211
mkdir -p 212 && mv -f {010026..010033} 212
mkdir -p 213 && mv -f {010034..010042} 213
mkdir -p 214 && mv -f {010043..010053} 214
mkdir -p 215 && mv -f {010054..010061} 215
mkdir -p 216 && mv -f {010062..010070} 216
mkdir -p 217 && mv -f {010071..010078} 217
mkdir -p 218 && mv -f {010079..010088} 218
mkdir -p 219 && mv -f {010089..010097} 219
mkdir -p 220 && mv -f {010098..010106} 220
mkdir -p 221 && mv -f {010107..011005} 221
mkdir -p 222 && mv -f {011006..011012} 222
mkdir -p 223 && mv -f {011013..011019} 223
mkdir -p 224 && mv -f {011020..011028} 224
mkdir -p 225 && mv -f {011029..011037} 225
mkdir -p 226 && mv -f {011038..011045} 226
mkdir -p 227 && mv -f {011046..011053} 227
mkdir -p 228 && mv -f {011054..011062} 228
mkdir -p 229 && mv -f {011063..011071} 229
mkdir -p 230 && mv -f {011072..011081} 230
mkdir -p 231 && mv -f {011082..011088} 231
mkdir -p 232 && mv -f {011089..011097} 232
mkdir -p 233 && mv -f {011098..011108} 233
mkdir -p 234 && mv -f {011109..011117} 234
mkdir -p 235 && mv -f {011118..012004} 235
mkdir -p 236 && mv -f {012005..012014} 236
mkdir -p 237 && mv -f {012015..012022} 237
mkdir -p 238 && mv -f {012023..012030} 238
mkdir -p 239 && mv -f {012031..012037} 239
mkdir -p 240 && mv -f {012038..012043} 240
mkdir -p 241 && mv -f {012044..012052} 241
mkdir -p 242 && mv -f {012053..012063} 242
mkdir -p 243 && mv -f {012064..012069} 243
mkdir -p 244 && mv -f {012070..012078} 244
mkdir -p 245 && mv -f {012079..012086} 245
mkdir -p 246 && mv -f {012087..012095} 246
mkdir -p 247 && mv -f {012096..012103} 247
mkdir -p 248 && mv -f {012104..012111} 248
mkdir -p 249 && mv -f {013001..013005} 249
mkdir -p 250 && mv -f {013006..013013} 250
mkdir -p 251 && mv -f {013014..013018} 251
mkdir -p 252 && mv -f {013019..013028} 252
mkdir -p 253 && mv -f {013029..013034} 253
mkdir -p 254 && mv -f {013035..013042} 254
mkdir -p 255 && mv -f {013043..014005} 255
mkdir -p 256 && mv -f {014006..014010} 256
mkdir -p 257 && mv -f {014011..014018} 257
mkdir -p 258 && mv -f {014019..014024} 258
mkdir -p 259 && mv -f {014025..014033} 259
mkdir -p 260 && mv -f {014034..014042} 260
mkdir -p 261 && mv -f {014043..014052} 261
mkdir -p 262 && mv -f {015001..015015} 262
mkdir -p 263 && mv -f {015016..015031} 263
mkdir -p 264 && mv -f {015032..015051} 264
mkdir -p 265 && mv -f {015052..015070} 265
mkdir -p 266 && mv -f {015071..015090} 266
mkdir -p 267 && mv -f {015091..016006} 267
mkdir -p 268 && mv -f {016007..016014} 268
mkdir -p 269 && mv -f {016015..016026} 269
mkdir -p 270 && mv -f {016027..016034} 270
mkdir -p 271 && mv -f {016035..016042} 271
mkdir -p 272 && mv -f {016043..016054} 272
mkdir -p 273 && mv -f {016055..016064} 273
mkdir -p 274 && mv -f {016065..016072} 274
mkdir -p 275 && mv -f {016073..016079} 275
mkdir -p 276 && mv -f {016080..016087} 276
mkdir -p 277 && mv -f {016088..016093} 277
mkdir -p 278 && mv -f {016094..016102} 278
mkdir -p 279 && mv -f {016103..016110} 279
mkdir -p 280 && mv -f {016111..016118} 280
mkdir -p 281 && mv -f {016119..016128} 281
mkdir -p 282 && mv -f {017001..017007} 282
mkdir -p 283 && mv -f {017008..017017} 283
mkdir -p 284 && mv -f {017018..017027} 284
mkdir -p 285 && mv -f {017028..017038} 285
mkdir -p 286 && mv -f {017039..017049} 286
mkdir -p 287 && mv -f {017050..017058} 287
mkdir -p 288 && mv -f {017059..017066} 288
mkdir -p 289 && mv -f {017067..017075} 289
mkdir -p 290 && mv -f {017076..017086} 290
mkdir -p 291 && mv -f {017087..017096} 291
mkdir -p 292 && mv -f {017097..017104} 292
mkdir -p 293 && mv -f {017105..018004} 293
mkdir -p 294 && mv -f {018005..018015} 294
mkdir -p 295 && mv -f {018016..018020} 295
mkdir -p 296 && mv -f {018021..018027} 296
mkdir -p 297 && mv -f {018028..018034} 297
mkdir -p 298 && mv -f {018035..018045} 298
mkdir -p 299 && mv -f {018046..018053} 299
mkdir -p 300 && mv -f {018054..018061} 300
mkdir -p 301 && mv -f {018062..018074} 301
mkdir -p 302 && mv -f {018075..018083} 302
mkdir -p 303 && mv -f {018084..018097} 303
mkdir -p 304 && mv -f {018098..018110} 304
mkdir -p 305 && mv -f {019001..019011} 305
mkdir -p 306 && mv -f {019012..019025} 306
mkdir -p 307 && mv -f {019026..019038} 307
mkdir -p 308 && mv -f {019039..019051} 308
mkdir -p 309 && mv -f {019052..019064} 309
mkdir -p 310 && mv -f {019065..019076} 310
mkdir -p 311 && mv -f {019077..019095} 311
mkdir -p 312 && mv -f {019096..020012} 312
mkdir -p 313 && mv -f {020013..020037} 313
mkdir -p 314 && mv -f {020038..020051} 314
mkdir -p 315 && mv -f {020052..020064} 315
mkdir -p 316 && mv -f {020065..020076} 316
mkdir -p 317 && mv -f {020077..020087} 317
mkdir -p 318 && mv -f {020088..020098} 318
mkdir -p 319 && mv -f {020099..020113} 319
mkdir -p 320 && mv -f {020114..020125} 320
mkdir -p 321 && mv -f {020126..020135} 321
mkdir -p 322 && mv -f {021001..021010} 322
mkdir -p 323 && mv -f {021011..021024} 323
mkdir -p 324 && mv -f {021025..021035} 324
mkdir -p 325 && mv -f {021036..021044} 325
mkdir -p 326 && mv -f {021045..021057} 326
mkdir -p 327 && mv -f {021058..021072} 327
mkdir -p 328 && mv -f {021073..021081} 328
mkdir -p 329 && mv -f {021082..021090} 329
mkdir -p 330 && mv -f {021091..021101} 330
mkdir -p 331 && mv -f {021102..021112} 331
mkdir -p 332 && mv -f {022001..022005} 332
mkdir -p 333 && mv -f {022006..022015} 333
mkdir -p 334 && mv -f {022016..022023} 334
mkdir -p 335 && mv -f {022024..022030} 335
mkdir -p 336 && mv -f {022031..022038} 336
mkdir -p 337 && mv -f {022039..022046} 337
mkdir -p 338 && mv -f {022047..022055} 338
mkdir -p 339 && mv -f {022056..022064} 339
mkdir -p 340 && mv -f {022065..022072} 340
mkdir -p 341 && mv -f {022073..022078} 341
mkdir -p 342 && mv -f {023001..023017} 342
mkdir -p 343 && mv -f {023018..023027} 343
mkdir -p 344 && mv -f {023028..023042} 344
mkdir -p 345 && mv -f {023043..023059} 345
mkdir -p 346 && mv -f {023060..023074} 346
mkdir -p 347 && mv -f {023075..023089} 347
mkdir -p 348 && mv -f {023090..023104} 348
mkdir -p 349 && mv -f {023105..023118} 349
mkdir -p 350 && mv -f {024001..024010} 350
mkdir -p 351 && mv -f {024011..024020} 351
mkdir -p 352 && mv -f {024021..024027} 352
mkdir -p 353 && mv -f {024028..024031} 353
mkdir -p 354 && mv -f {024032..024036} 354
mkdir -p 355 && mv -f {024037..024043} 355
mkdir -p 356 && mv -f {024044..024053} 356
mkdir -p 357 && mv -f {024054..024058} 357
mkdir -p 358 && mv -f {024059..024061} 358
mkdir -p 359 && mv -f {024062..025002} 359
mkdir -p 360 && mv -f {025003..025011} 360
mkdir -p 361 && mv -f {025012..025020} 361
mkdir -p 362 && mv -f {025021..025032} 362
mkdir -p 363 && mv -f {025033..025043} 363
mkdir -p 364 && mv -f {025044..025055} 364
mkdir -p 365 && mv -f {025056..025067} 365
mkdir -p 366 && mv -f {025068..025077} 366
mkdir -p 367 && mv -f {026001..026019} 367
mkdir -p 368 && mv -f {026020..026039} 368
mkdir -p 369 && mv -f {026040..026060} 369
mkdir -p 370 && mv -f {026061..026083} 370
mkdir -p 371 && mv -f {026084..026111} 371
mkdir -p 372 && mv -f {026112..026136} 372
mkdir -p 373 && mv -f {026137..026159} 373
mkdir -p 374 && mv -f {026160..026183} 374
mkdir -p 375 && mv -f {026184..026206} 375
mkdir -p 376 && mv -f {026207..026227} 376
mkdir -p 377 && mv -f {027001..027013} 377
mkdir -p 378 && mv -f {027014..027022} 378
mkdir -p 379 && mv -f {027023..027035} 379
mkdir -p 380 && mv -f {027036..027044} 380
mkdir -p 381 && mv -f {027045..027055} 381
mkdir -p 382 && mv -f {027056..027063} 382
mkdir -p 383 && mv -f {027064..027076} 383
mkdir -p 384 && mv -f {027077..027088} 384
mkdir -p 385 && mv -f {027089..028005} 385
mkdir -p 386 && mv -f {028006..028013} 386
mkdir -p 387 && mv -f {028014..028021} 387
mkdir -p 388 && mv -f {028022..028028} 388
mkdir -p 389 && mv -f {028029..028035} 389
mkdir -p 390 && mv -f {028036..028043} 390
mkdir -p 391 && mv -f {028044..028050} 391
mkdir -p 392 && mv -f {028051..028059} 392
mkdir -p 393 && mv -f {028060..028070} 393
mkdir -p 394 && mv -f {028071..028077} 394
mkdir -p 395 && mv -f {028078..028084} 395
mkdir -p 396 && mv -f {028085..029006} 396
mkdir -p 397 && mv -f {029007..029014} 397
mkdir -p 398 && mv -f {029015..029023} 398
mkdir -p 399 && mv -f {029024..029030} 399
mkdir -p 400 && mv -f {029031..029038} 400
mkdir -p 401 && mv -f {029039..029045} 401
mkdir -p 402 && mv -f {029046..029052} 402
mkdir -p 403 && mv -f {029053..029063} 403
mkdir -p 404 && mv -f {029064..030005} 404
mkdir -p 405 && mv -f {030006..030015} 405
mkdir -p 406 && mv -f {030016..030024} 406
mkdir -p 407 && mv -f {030025..030032} 407
mkdir -p 408 && mv -f {030033..030041} 408
mkdir -p 409 && mv -f {030042..030050} 409
mkdir -p 410 && mv -f {030051..030060} 410
mkdir -p 411 && mv -f {031001..031011} 411
mkdir -p 412 && mv -f {031012..031019} 412
mkdir -p 413 && mv -f {031020..031028} 413
mkdir -p 414 && mv -f {031029..031034} 414
mkdir -p 415 && mv -f {032001..032011} 415
mkdir -p 416 && mv -f {032012..032020} 416
mkdir -p 417 && mv -f {032021..032030} 417
mkdir -p 418 && mv -f {033001..033006} 418
mkdir -p 419 && mv -f {033007..033015} 419
mkdir -p 420 && mv -f {033016..033022} 420
mkdir -p 421 && mv -f {033023..033030} 421
mkdir -p 422 && mv -f {033031..033035} 422
mkdir -p 423 && mv -f {033036..033043} 423
mkdir -p 424 && mv -f {033044..033050} 424
mkdir -p 425 && mv -f {033051..033054} 425
mkdir -p 426 && mv -f {033055..033062} 426
mkdir -p 427 && mv -f {033063..033073} 427
mkdir -p 428 && mv -f {034001..034007} 428
mkdir -p 429 && mv -f {034008..034014} 429
mkdir -p 430 && mv -f {034015..034022} 430
mkdir -p 431 && mv -f {034023..034031} 431
mkdir -p 432 && mv -f {034032..034039} 432
mkdir -p 433 && mv -f {034040..034048} 433
mkdir -p 434 && mv -f {034049..035003} 434
mkdir -p 435 && mv -f {035004..035011} 435
mkdir -p 436 && mv -f {035012..035018} 436
mkdir -p 437 && mv -f {035019..035030} 437
mkdir -p 438 && mv -f {035031..035038} 438
mkdir -p 439 && mv -f {035039..035044} 439
mkdir -p 440 && mv -f {035045..036012} 440
mkdir -p 441 && mv -f {036013..036027} 441
mkdir -p 442 && mv -f {036028..036040} 442
mkdir -p 443 && mv -f {036041..036054} 443
mkdir -p 444 && mv -f {036055..036070} 444
mkdir -p 445 && mv -f {036071..036083} 445
mkdir -p 446 && mv -f {037001..037024} 446
mkdir -p 447 && mv -f {037025..037051} 447
mkdir -p 448 && mv -f {037052..037076} 448
mkdir -p 449 && mv -f {037077..037102} 449
mkdir -p 450 && mv -f {037103..037126} 450
mkdir -p 451 && mv -f {037127..037153} 451
mkdir -p 452 && mv -f {037154..037182} 452
mkdir -p 453 && mv -f {038001..038016} 453
mkdir -p 454 && mv -f {038017..038026} 454
mkdir -p 455 && mv -f {038027..038042} 455
mkdir -p 456 && mv -f {038043..038061} 456
mkdir -p 457 && mv -f {038062..038083} 457
mkdir -p 458 && mv -f {038084..039005} 458
mkdir -p 459 && mv -f {039006..039010} 459
mkdir -p 460 && mv -f {039011..039021} 460
mkdir -p 461 && mv -f {039022..039031} 461
mkdir -p 462 && mv -f {039032..039040} 462
mkdir -p 463 && mv -f {039041..039047} 463
mkdir -p 464 && mv -f {039048..039056} 464
mkdir -p 465 && mv -f {039057..039067} 465
mkdir -p 466 && mv -f {039068..039074} 466
mkdir -p 467 && mv -f {039075..040007} 467
mkdir -p 468 && mv -f {040008..040016} 468
mkdir -p 469 && mv -f {040017..040025} 469
mkdir -p 470 && mv -f {040026..040033} 470
mkdir -p 471 && mv -f {040034..040040} 471
mkdir -p 472 && mv -f {040041..040049} 472
mkdir -p 473 && mv -f {040050..040058} 473
mkdir -p 474 && mv -f {040059..040066} 474
mkdir -p 475 && mv -f {040067..040077} 475
mkdir -p 476 && mv -f {040078..040085} 476
mkdir -p 477 && mv -f {041001..041011} 477
mkdir -p 478 && mv -f {041012..041020} 478
mkdir -p 479 && mv -f {041021..041029} 479
mkdir -p 480 && mv -f {041030..041038} 480
mkdir -p 481 && mv -f {041039..041046} 481
mkdir -p 482 && mv -f {041047..041054} 482
mkdir -p 483 && mv -f {042001..042010} 483
mkdir -p 484 && mv -f {042011..042015} 484
mkdir -p 485 && mv -f {042016..042022} 485
mkdir -p 486 && mv -f {042023..042031} 486
mkdir -p 487 && mv -f {042032..042044} 487
mkdir -p 488 && mv -f {042045..042051} 488
mkdir -p 489 && mv -f {042052..043010} 489
mkdir -p 490 && mv -f {043011..043022} 490
mkdir -p 491 && mv -f {043023..043033} 491
mkdir -p 492 && mv -f {043034..043047} 492
mkdir -p 493 && mv -f {043048..043060} 493
mkdir -p 494 && mv -f {043061..043073} 494
mkdir -p 495 && mv -f {043074..043089} 495
mkdir -p 496 && mv -f {044001..044018} 496
mkdir -p 497 && mv -f {044019..044039} 497
mkdir -p 498 && mv -f {044040..044059} 498
mkdir -p 499 && mv -f {045001..045013} 499
mkdir -p 500 && mv -f {045014..045022} 500
mkdir -p 501 && mv -f {045023..045032} 501
mkdir -p 502 && mv -f {045033..046005} 502
mkdir -p 503 && mv -f {046006..046014} 503
mkdir -p 504 && mv -f {046015..046020} 504
mkdir -p 505 && mv -f {046021..046028} 505
mkdir -p 506 && mv -f {046029..046035} 506
mkdir -p 507 && mv -f {047001..047011} 507
mkdir -p 508 && mv -f {047012..047019} 508
mkdir -p 509 && mv -f {047020..047029} 509
mkdir -p 510 && mv -f {047030..047038} 510
mkdir -p 511 && mv -f {048001..048009} 511
mkdir -p 512 && mv -f {048010..048015} 512
mkdir -p 513 && mv -f {048016..048023} 513
mkdir -p 514 && mv -f {048024..048028} 514
mkdir -p 515 && mv -f {048029..049004} 515
mkdir -p 516 && mv -f {049005..049011} 516
mkdir -p 517 && mv -f {049012..049018} 517
mkdir -p 518 && mv -f {050001..050015} 518
mkdir -p 519 && mv -f {050016..050035} 519
mkdir -p 520 && mv -f {050036..051006} 520
mkdir -p 521 && mv -f {051007..051030} 521
mkdir -p 522 && mv -f {051031..051051} 522
mkdir -p 523 && mv -f {051052..052014} 523
mkdir -p 524 && mv -f {052015..052031} 524
mkdir -p 525 && mv -f {052032..052049} 525
mkdir -p 526 && mv -f {053001..053026} 526
mkdir -p 527 && mv -f {053027..053044} 527
mkdir -p 528 && mv -f {053045..054006} 528
mkdir -p 529 && mv -f {054007..054027} 529
mkdir -p 530 && mv -f {054028..054049} 530
mkdir -p 531 && mv -f {054050..055016} 531
mkdir -p 532 && mv -f {055017..055040} 532
mkdir -p 533 && mv -f {055041..055067} 533
mkdir -p 534 && mv -f {055068..056016} 534
mkdir -p 535 && mv -f {056017..056050} 535
mkdir -p 536 && mv -f {056051..056076} 536
mkdir -p 537 && mv -f {056077..057003} 537
mkdir -p 538 && mv -f {057004..057011} 538
mkdir -p 539 && mv -f {057012..057018} 539
mkdir -p 540 && mv -f {057019..057024} 540
mkdir -p 541 && mv -f {057025..057029} 541
mkdir -p 542 && mv -f {058001..058006} 542
mkdir -p 543 && mv -f {058007..058011} 543
mkdir -p 544 && mv -f {058012..058021} 544
mkdir -p 545 && mv -f {058022..059003} 545
mkdir -p 546 && mv -f {059004..059009} 546
mkdir -p 547 && mv -f {059010..059016} 547
mkdir -p 548 && mv -f {059017..059024} 548
mkdir -p 549 && mv -f {060001..060005} 549
mkdir -p 550 && mv -f {060006..060011} 550
mkdir -p 551 && mv -f {060012..061005} 551
mkdir -p 552 && mv -f {061006..061014} 552
mkdir -p 553 && mv -f {062001..062008} 553
mkdir -p 554 && mv -f {062009..063004} 554
mkdir -p 555 && mv -f {063005..063011} 555
mkdir -p 556 && mv -f {064001..064009} 556
mkdir -p 557 && mv -f {064010..064018} 557
mkdir -p 558 && mv -f {065001..065005} 558
mkdir -p 559 && mv -f {065006..065012} 559
mkdir -p 560 && mv -f {066001..066007} 560
mkdir -p 561 && mv -f {066008..066012} 561
mkdir -p 562 && mv -f {067001..067012} 562
mkdir -p 563 && mv -f {067013..067026} 563
mkdir -p 564 && mv -f {067027..068015} 564
mkdir -p 565 && mv -f {068016..068042} 565
mkdir -p 566 && mv -f {068043..069008} 566
mkdir -p 567 && mv -f {069009..069034} 567
mkdir -p 568 && mv -f {069035..070010} 568
mkdir -p 569 && mv -f {070011..070039} 569
mkdir -p 570 && mv -f {070040..071010} 570
mkdir -p 571 && mv -f {071011..071028} 571
mkdir -p 572 && mv -f {072001..072013} 572
mkdir -p 573 && mv -f {072014..072028} 573
mkdir -p 574 && mv -f {073001..073019} 574
mkdir -p 575 && mv -f {073020..074017} 575
mkdir -p 576 && mv -f {074018..074047} 576
mkdir -p 577 && mv -f {074048..075019} 577
mkdir -p 578 && mv -f {075020..076005} 578
mkdir -p 579 && mv -f {076006..076025} 579
mkdir -p 580 && mv -f {076026..077019} 580
mkdir -p 581 && mv -f {077020..077050} 581
mkdir -p 582 && mv -f {078001..078030} 582
mkdir -p 583 && mv -f {078031..079015} 583
mkdir -p 584 && mv -f {079016..079046} 584
mkdir -p 585 && mv -f {080001..080042} 585
mkdir -p 586 && mv -f {081001..081029} 586
mkdir -p 587 && mv -f {082001..083006} 587
mkdir -p 588 && mv -f {083007..083034} 588
mkdir -p 589 && mv -f {083035..084025} 589
mkdir -p 590 && mv -f {085001..085022} 590
mkdir -p 591 && mv -f {086001..087015} 591
mkdir -p 592 && mv -f {087016..088026} 592
mkdir -p 593 && mv -f {089001..089023} 593
mkdir -p 594 && mv -f {089024..090020} 594
mkdir -p 595 && mv -f {091001..092014} 595
mkdir -p 596 && mv -f {092015..094008} 596
mkdir -p 597 && mv -f {095001..096019} 597
mkdir -p 598 && mv -f {097001..098007} 598
mkdir -p 599 && mv -f {098008..100009} 599
mkdir -p 600 && mv -f {100010..102008} 600
mkdir -p 601 && mv -f {103001..105005} 601
mkdir -p 602 && mv -f {106001..108003} 602
mkdir -p 603 && mv -f {109001..111005} 603
mkdir -p 604 && mv -f {112001..114006} 604

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
