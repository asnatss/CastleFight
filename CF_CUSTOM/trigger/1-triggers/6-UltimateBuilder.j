globals
    unit array PlayerBuilder
    integer array PlayerBuildings

    integer array RecBuilings
    boolean RecCheck = false
    image array RecIcons
    texttag array RecText
    effect array RecGrid
    image array RecGridIcon

    integer Cn
    integer dn
    integer Dn
    integer fn
    integer Fn
    integer gn
    integer Gn
    integer hn
    integer Hn
    integer jn
    integer Jn
    integer array AllBuildings
    string array PlayerColor

    boolean UltimateCheck=false
    //integer xx=0

    integer array Wa
    integer array ya
    integer array Ya
    integer array za
    integer array Za
    integer array vn
    integer array xn
    integer array on
    integer array rn
    integer array in
    integer array nn

    integer Vn
    integer En
    integer Xn
    integer On
    integer Rn
    integer In
    integer An
    integer Nn
    integer bn
    integer Bn
    integer cn

    integer array buildings
    texttag array PlayerNames
    image array BuildingIcons
    string iconFormat = ".blp"

    //texttag array wa
    //image array va
    force TeamLeft = CreateForce()
    force TeamRight = CreateForce()
endglobals

function PlayerBuildersClear takes nothing returns nothing
    local integer i = 0
    local integer j = 0

    loop
        exitwhen i > 2
        set PlayerBuilder[i] = null
        set PlayerBuilder[i + 6] = null

        set i = i + 1
    endloop

    loop
        exitwhen j > 2
        set i = 0
        loop
            exitwhen i > 5
            set RecBuilings[i + j * 6] = 0
            set RecBuilings[i + (j + 6) * 6] = 0

            set i = i + 1
        endloop

        set j = j + 1
    endloop
endfunction

function RecomClear takes nothing returns nothing
    local integer i = 0

    if not RecCheck then
        return
    endif

    if RecText[0] != null then
        call DestroyTextTag(RecText[i])
        set RecText[0] = null
    endif
    if RecText[1] != null then
        call DestroyTextTag(RecText[1])
        set RecText[1] = null
    endif

    loop
        exitwhen i > 2

        if RecIcons[i] != null then
            call SetImageRenderAlways(RecIcons[i],false)
            call ShowImage(RecIcons[i],false)
            call DestroyImage(RecIcons[i])
            set RecIcons[i] = null
        endif
        if RecIcons[i + 6] != null then
            call SetImageRenderAlways(RecIcons[i + 6],false)
            call ShowImage(RecIcons[i + 6],false)
            call DestroyImage(RecIcons[i + 6])
            set RecIcons[i + 6] = null
        endif
        set i = i + 1
    endloop

    set i = 0
    loop
        exitwhen i > 9

        if RecGridIcon[i] != null then
            call SetImageRenderAlways(RecGridIcon[i],false)
            call ShowImage(RecGridIcon[i],false)
            call DestroyImage(RecGridIcon[i])
            set RecGridIcon[i] = null
        endif

        set i = i + 1
    endloop

    set RecCheck = false
endfunction

function RecomBuildingPos takes integer teamid returns nothing
    local real startx = -6144
    local real starty = 512 - 64
    local real x

    local integer index = 0
    local integer i = 0

    local player pLoc = GetLocalPlayer()
    local player p = Player(0)


    if teamid != 1 then
        set startx = startx * -1 - 128
        set index = 5
        set p = Player(6)
    endif

    set RecGridIcon[index + 0] = CreateImage("building_floor.blp", 128, 128, 0, startx, starty, 260, 0, 0, 0, 3)
    set RecGridIcon[index + 1] = CreateImage("building_floor.blp", 128, 128, 0, startx + 128 * teamid, starty + 128, 260, 0, 0, 0, 3)
    set RecGridIcon[index + 2] = CreateImage("building_floor.blp", 128, 128, 0, startx + 256 * teamid, starty + 256, 260, 0, 0, 0, 3)
    set RecGridIcon[index + 3] = CreateImage("building_floor.blp", 128, 128, 0, startx + 128 * teamid, starty + 384, 260, 0, 0, 0, 3)
    set RecGridIcon[index + 4] = CreateImage("building_floor.blp", 128, 128, 0, startx + 512 * teamid, starty, 260, 0, 0, 0, 3)

    loop
        exitwhen i > 4
        call SetImageConstantHeight(RecGridIcon[index + i], true, 260)
        call SetImageRenderAlways(RecGridIcon[index + i], true)
        
        if p == pLoc or IsPlayerAlly(p, pLoc) then
            call ShowImage(RecGridIcon[index + i], true)
        else
            call ShowImage(RecGridIcon[index + i], false)
        endif

        set i = i + 1
    endloop
endfunction

function RecomText takes integer teamid returns nothing
    local integer startx = -4560
    local force team = TeamLeft
    local integer index = 0

    if teamid != 1 then
        set startx = startx * teamid - 200
        set team = TeamRight
        set index = 1
    endif

    set RecText[index] = CreateTextTag()
    call SetTextTagText(RecText[index], "|cffff8c00Recommendations:|r", .024)
    call SetTextTagPos(RecText[index], startx, 65, 16.)
    call SetTextTagVisibility(RecText[index], false)
    call ShowTextTagForceBJ(true, RecText[index], team)
    call SetTextTagPermanent(RecText[index], true)

    set team = null
endfunction

function RecomBuildingIcons takes integer teamid, integer f, integer b1, integer b2 returns nothing
    local real startx = -4608
    local real x
    local real y = -50
    local integer i = 0
    local integer index = 0
    local integer array b
    local player pLoc = GetLocalPlayer()
    local player p = Player(0)
    
    set b[0] = b2
    set b[1] = b1
    set b[2] = f

    if teamid != 1 then
        set startx = startx * teamid - 100
        set p = Player(6)
    endif

    set index = GetPlayerId(p)
    loop
        exitwhen i > 2

        set x = startx + i * 100 * teamid

        set RecIcons[index + i] = CreateImage(UnitId2String(b[i]) + iconFormat, 98, 98, 0, x, y, 270, 0, 0, 0, 3)
        call SetImageConstantHeight(RecIcons[index + i], true, 270)
        call SetImageRenderAlways(RecIcons[index + i], true)
        if p == pLoc or IsPlayerAlly(p, pLoc) then
            call ShowImage(RecIcons[index + i], true)
        else
            call ShowImage(RecIcons[index + i], false)
        endif

        set i = i + 1
    endloop

    set p = null
    set pLoc = null
endfunction

function RecomCreateListBuildings takes integer pId returns nothing
    local integer id = GetUnitTypeId(PlayerBuilder[pId])
    
    if id == 'h075' then
        return
    elseif id == 'h00C' then
        set RecBuilings[0 + pId * 6] = 'h000'
        set RecBuilings[1 + pId * 6] = 'h003'
        set RecBuilings[3 + pId * 6] = 'h015'
        set RecBuilings[4 + pId * 6] = 'h037'
    elseif id == 'h019' then
        set RecBuilings[0 + pId * 6] = 'h029'
        set RecBuilings[1 + pId * 6] = 'h02B'
        set RecBuilings[2 + pId * 6] = 'h02H'
        set RecBuilings[3 + pId * 6] = 'h02P'
        set RecBuilings[4 + pId * 6] = 'h02K'
    elseif id == 'h00P' then
        set RecBuilings[0 + pId * 6] = 'h08X'
        set RecBuilings[1 + pId * 6] = 'h00T'
        set RecBuilings[2 + pId * 6] = 'h00V'
    elseif id == 'u006' then
        set RecBuilings[0 + pId * 6] = 'h04V'
        set RecBuilings[1 + pId * 6] = 'h04L'
        set RecBuilings[2 + pId * 6] = 'h04O'
    elseif id == 'h00E' then
        set RecBuilings[0 + pId * 6] = 'h020'
        set RecBuilings[1 + pId * 6] = 'h00J'
        set RecBuilings[2 + pId * 6] = 'h01Y'
        set RecBuilings[3 + pId * 6] = 'h00F'
    elseif id == 'h017' then
        set RecBuilings[0 + pId * 6] = 'h049'
        set RecBuilings[1 + pId * 6] = 'h03U'
        set RecBuilings[2 + pId * 6] = 'h03K'
        set RecBuilings[3 + pId * 6] = 'h03T'
    elseif id == 'h089' then
        set RecBuilings[0 + pId * 6] = 'h00S'
        set RecBuilings[1 + pId * 6] = 'h088'
        set RecBuilings[2 + pId * 6] = 'h07M'
        set RecBuilings[3 + pId * 6] = 'h07O'
        set RecBuilings[4 + pId * 6] = 'h00B'
    elseif id == 'h018' then
        set RecBuilings[0 + pId * 6] = 'h01R'
        set RecBuilings[1 + pId * 6] = 'h01K'
        set RecBuilings[2 + pId * 6] = 'h01N'
    elseif id == 'h00O' then
        set RecBuilings[0 + pId * 6] = 'h01I'
        set RecBuilings[1 + pId * 6] = 'h01D'
        set RecBuilings[2 + pId * 6] = 'h01C'
        set RecBuilings[3 + pId * 6] = 'h025'
    elseif id == 'h06P' then
        set RecBuilings[1 + pId * 6] = 'h05X'
        set RecBuilings[3 + pId * 6] = 'h05T'
        set RecBuilings[4 + pId * 6] = 'h05V'
    elseif id == 'h01A' then
        set RecBuilings[0 + pId * 6] = 'h002'
        set RecBuilings[1 + pId * 6] = 'h00Y'
        set RecBuilings[2 + pId * 6] = 'h013'
        set RecBuilings[3 + pId * 6] = 'h023'
    elseif id == 'h051' then
        set RecBuilings[1 + pId * 6] = 'h03X'
        set RecBuilings[2 + pId * 6] = 'h045'
        set RecBuilings[3 + pId * 6] = 'h042'
        set RecBuilings[4 + pId * 6] = 'h040'
    endif
endfunction

function RecomMain takes integer team returns boolean
    local integer i = 0
    local integer iMax
    local integer j = 0
    local integer jMax
    local integer value
    local integer id = 0

    local integer frontValue = StringHash("frontvalue")
    local integer backValue  = StringHash("backvalue")

    // результат
    local integer frontMaxV = 0
    local integer frontId = 0
    local integer frontP = -1

    local integer backMaxV1 = 0
    local integer backId1 = 0
    local integer backP1 = -1

    local integer backMaxV2 = 0
    local integer backId2 = 0
    local integer backP2 = -1

    // проверка игроков
    if team != 1 then
        set i = 6
    endif
    set iMax = i + 2
    loop
        exitwhen i > iMax
        if PlayerBuilder[i] == null then
            return false
        endif
        call RecomCreateListBuildings(i)
        set i = i + 1
    endloop

    // единый проход по всем зданиям

    if team != 1 then
        set j = 6
    endif
    set jMax = j + 2

    loop
        exitwhen j > jMax
        set i = 0
        loop
            exitwhen i > 5
            set id = RecBuilings[i + j * 6]
            if id != 0 then
                set value = LoadInteger(Mo, id, frontValue)
                if value > frontMaxV then
                    set frontMaxV = value
                    set frontId   = id
                    set frontP    = j
                endif
            endif
            set i = i + 1
        endloop
        set j = j + 1
    endloop

    if frontP == -1 then
        return false
    endif

    set j = 0
    if team != 1 then
        set j = 6
    endif
    set jMax = j + 2

    loop
        exitwhen j > jMax
        if j != frontP then
            set i = 0
            loop
                exitwhen i > 5
                set id = RecBuilings[i + j * 6]
                if id != 0 then
                    set value = LoadInteger(Mo, id, backValue)
                    if value > backMaxV1 then
                        if j != backP1 then
                            set backMaxV2 = backMaxV1
                            set backId2   = backId1
                            set backP2    = backP1
                        endif

                        set backMaxV1 = value
                        set backId1   = id
                        set backP1    = j
                    elseif value > backMaxV2 and j != backP1 then
                        set backMaxV2 = value
                        set backId2   = id
                        set backP2    = j
                    endif
                endif
                set i = i + 1
            endloop
        endif
        set j = j + 1
    endloop

    if backP1 == -1 or backP2 == -1 then
        return false
    endif

    call RecomBuildingIcons(team, frontId, backId1, backId2)

    return true

    // frontId  – лучший фронт
    // backId1  – лучший бэк
    // backId2  – второй бэк
endfunction

function RecomStart takes nothing returns nothing
    local boolean RecSuccessL = false
    local boolean RecSuccessR = false
    set RecCheck = true

    set RecSuccessL = RecomMain(1)
    if RecSuccessL then
        call RecomText(1)
    endif

    set RecSuccessR = RecomMain(-1)
    if RecSuccessR then
        call RecomText(-1)
    endif

    call RecomBuildingPos(1)
    call RecomBuildingPos(-1)
endfunction

function pd takes nothing returns nothing // Показать всем после таймера текст или картинки ультимейтов
    local integer i = 0
    if not UltimateCheck then
        return
    endif

    loop
        exitwhen i > 3
        if PlayerNames[i] != null then
            call SetTextTagVisibility(PlayerNames[i], true)
        endif
        if PlayerNames[i + 6] != null then
            call SetTextTagVisibility(PlayerNames[i + 6], true)
        endif
        set i = i + 1
    endloop

    set i = 0
    loop
        exitwhen i > 33
        if BuildingIcons[i] != null then
            call ShowImage(BuildingIcons[i], true)
        endif
        if BuildingIcons[i + 6 * 11] != null then
            call ShowImage(BuildingIcons[i + 6 * 11], true)
        endif
        set i = i + 1
    endloop

    set UltimateCheck = false
endfunction

function ClearTextsAndIcons takes nothing returns nothing
    local integer i = 0

    loop
        exitwhen i > 3

        if PlayerNames[i] != null then
            call DestroyTextTag(PlayerNames[i])
            set PlayerNames[i] = null
        endif
        if PlayerNames[i + 6] != null then
            call DestroyTextTag(PlayerNames[i + 6])
            set PlayerNames[i + 6] = null
        endif
        set i = i + 1
    endloop

    set i = 0
    loop
        exitwhen i > 33

        if BuildingIcons[i] != null then
            call SetImageRenderAlways(BuildingIcons[i],false)
            call ShowImage(BuildingIcons[i],false)
            call DestroyImage(BuildingIcons[i])
            set BuildingIcons[i] = null
        endif
        if BuildingIcons[i + 66] != null then
            call SetImageRenderAlways(BuildingIcons[i + 66],false)
            call ShowImage(BuildingIcons[i + 66],false)
            call DestroyImage(BuildingIcons[i + 66])
            set BuildingIcons[i + 66] = null
        endif
        set i = i + 1
    endloop
endfunction

function gG takes nothing returns nothing
    call ClearTextsAndIcons()
    call RecomClear()

    set UltimateCheck = true
    set Wa[0]='h04V'
    set Wa[1]='h000'
    set Wa[2]='h029'
    set Wa[3]='h020'
    set Wa[4]='h049'
    set Wa[5]='h01I'
    set Wa[6]='h01R'
    set Wa[7]='h08X'
    set Wa[8]='h00S'
    set Wa[9]='h05J'
    set Wa[10]='h002'
    set Wa[11]='h04A'
    set Vn=11
    set ya[0]='h04L'
    set ya[1]='h003'
    set ya[2]='h02B'
    set ya[3]='h00J'
    set ya[4]='h03U'
    set ya[5]='h01D'
    set ya[6]='h01K'
    set ya[7]='h00T'
    set ya[8]='h088'
    set ya[9]='h05X'
    set ya[10]='h00Y'
    set ya[11]='h03X'
    set En=11
    set Ya[0]='h04O'
    set Ya[1]='h004'
    set Ya[2]='h02H'
    set Ya[3]='h01Y'
    set Ya[4]='h03K'
    set Ya[5]='h01C'
    set Ya[6]='h01N'
    set Ya[7]='h00V'
    set Ya[8]='h07M'
    set Ya[9]='h05M'
    set Ya[10]='h013'
    set Ya[11]='h045'
    set Xn=11
    set za[0]='h04S'
    set za[1]='h015'
    set za[2]='h02P'
    set za[3]='h00F'
    set za[4]='h03T'
    set za[5]='h025'
    set za[6]='h01L'
    set za[7]='h06Y'
    set za[8]='h07O'
    set za[9]='h05T'
    set za[10]='h023'
    set za[11]='h042'
    set On=11
    set Za[0]='h04Q'
    set Za[1]='h037'
    set Za[2]='h02K'
    set Za[3]='h01B'
    set Za[4]='h03I'
    set Za[5]='h009'
    set Za[6]='h01T'
    set Za[7]='h070'
    set Za[8]='h00B'
    set Za[9]='h05V'
    set Za[10]='h027'
    set Za[11]='h040'
    set Rn=11
    set vn[0]='h04U'
    set vn[1]='h00K'
    set vn[2]='h02I'
    set vn[3]='h01Z'
    set vn[4]='h03S'
    set vn[5]='h007'
    set vn[6]='h01S'
    set vn[7]='h09X'
    set vn[8]='h011'
    set vn[9]='h05U'
    set vn[10]='h028'
    set vn[11]='h062'
    set In=11
    set xn[0]='h04K'
    set xn[1]='h010'
    set xn[2]='h02N'
    set xn[3]='h00I'
    set xn[4]='h060'
    set xn[5]='h01M'
    set xn[6]='h00A'
    set xn[7]='h00Z'
    set xn[8]='h08P'
    set xn[9]='h09T'
    set xn[10]='h02C'
    set xn[11]='h060'
    set An=11
    set on[0]='h04R'
    set on[1]='h001'
    set on[2]='h02R'
    set on[3]='h00M'
    set on[4]='h047'
    set on[5]='h01F'
    set on[6]='h01P'
    set on[7]='h005'
    set on[8]='h07H'
    set on[9]='h069'
    set on[10]='h02A'
    set on[11]='h05Z'
    set Nn=11
    set rn[0]='n01J'
    set rn[1]='h006'
    set rn[2]='o000'
    set rn[3]='h00G'
    set rn[4]='h03Q'
    set rn[5]='h05I'
    set rn[6]='h01O'
    set rn[7]='h014'
    set rn[8]='h073'
    set rn[9]='h05L'
    set rn[10]='n02D'
    set rn[11]='h061'
    set rn[12]='h076'
    set bn=12
    set in[0]='h04T'
    set in[1]='h05G'
    set in[2]='h02O'
    set in[3]='h00N'
    set in[4]='h03O'
    set in[5]='h01E'
    set in[6]='h01Q'
    set in[7]='h059'
    set in[8]='h07I'
    set in[9]='h06J'
    set in[10]='h02D'
    set in[11]='h063'
    set Bn=11
    if(Wr)then
        set nn[0]='null'
        set nn[1]='null'
        set nn[2]='null'
        set nn[3]='null'
        set nn[4]='null'
        set nn[5]='null'
        set nn[6]='null'
        set nn[7]='null'
        set nn[8]='null'
        set nn[9]='null'
        set nn[10]='h071'
        set nn[11]='null'
        set cn=11
    else
        set nn[0]='h008'
        set nn[1]='h008'
        set nn[2]='h008'
        set nn[3]='h008'
        set nn[4]='h008'
        set nn[5]='h008'
        set nn[6]='h008'
        set nn[7]='h008'
        set nn[8]='h008'
        set nn[9]='h008'
        set nn[10]='h071'
        set nn[11]='h008'
        set cn=11
    endif
endfunction

function AllBuildingsAvailable takes boolean b, player p returns nothing
    local integer i = 0
    loop
        exitwhen i > 123
            call SetPlayerUnitAvailableBJ(AllBuildings[i], b, p)
        set i = i + 1
    endloop
endfunction

function CreatePlayerName takes player p returns nothing
    local real startx
    local integer pId = GetPlayerId(p)
    local force team

    if pId < 3 then
        set startx = -1200 + pId * 400
        set team = TeamLeft
    elseif pId < 9 then
        set startx = 125 + (pId - 6) * 400
        set team = TeamRight
    endif

    set PlayerNames[pId] = CreateTextTag()
    call SetTextTagText(PlayerNames[pId], PlayerColor[pId] + GetPlayerName(p), .024)
    call SetTextTagPos(PlayerNames[pId], startx, -1500, 16.)
    call SetTextTagVisibility(PlayerNames[pId], false)
    call ShowTextTagForceBJ(true, PlayerNames[pId], team)
    call SetTextTagPermanent(PlayerNames[pId], true)

    set team = null
endfunction

function RandomBuildings takes nothing returns nothing
    local integer i
    //call DisplayTextToForce( bj_FORCE_PLAYER[0], "RandomBuildings" )
    set i = GetRandomInt(0, Vn)
    set buildings[0] = Wa[i]
    set Wa[i]=Wa[Vn]
    set Vn=Vn-1

    set i = GetRandomInt(0, En)
    set buildings[1] = ya[i]
    set ya[i]=ya[En]
    set En=En-1

    set i = GetRandomInt(0, Xn)
    set buildings[2] = Ya[i]
    set Ya[i]=Ya[Xn]
    set Xn=Xn-1

    set i = GetRandomInt(0, On)
    set buildings[3] = za[i]
    set za[i]=za[On]
    set On=On-1

    set i = GetRandomInt(0, Rn)
    set buildings[4] = Za[i]
    set Za[i]=Za[Rn]
    set Rn=Rn-1

    set i = GetRandomInt(0, In)
    set buildings[5] = vn[i]
    set vn[i]=vn[In]
    set In=In-1

    set i = GetRandomInt(0, An)
    set buildings[6] = xn[i]
    set xn[i]=xn[An]
    set An=An-1

    set i = GetRandomInt(0, Nn)
    set buildings[7] = on[i]
    set on[i]=on[Nn]
    set Nn=Nn-1

    set i = GetRandomInt(0, bn)
    set buildings[8] = rn[i]
    set rn[i]=rn[bn]
    set bn=bn-1

    set i = GetRandomInt(0, Bn)
    set buildings[9] = in[i]
    set in[i]=in[Bn]
    set Bn=Bn-1

    set i = GetRandomInt(0, cn)
    set buildings[10] = nn[i]
    set nn[i]=nn[cn]
    set cn=cn-1
endfunction

function CreateBuildingIcons takes player p returns nothing
    local real startx
    local integer pId = GetPlayerId(p)
    local player pLoc = GetLocalPlayer()
    local boolean pObs = IsPlayerObserver(pLoc)
    local integer i = 0
    local integer j = 0
    local integer index
    local real x
    local real y

    if pId < 3 then
        set startx = -1350 + pId * 400
    elseif pId < 9 then
        set startx = -50 + (pId - 6) * 400
    endif

    

    loop
        exitwhen j > 2
        set i = 0
        loop
            exitwhen i > 3 or (i == 3 and j == 2)
            set index = i + 4 * j + pId * 11 // всего 11 зданий на каждого игрока
            if buildings[i + 4 * j] != null then
                set x = startx + i * 100
                set y = -1750 - j * 100
                set BuildingIcons[index] = CreateImage(UnitId2String(buildings[i + 4 * j]) + iconFormat, 98, 98, 0, x, y, 135, 0, 0, 0, 3)
                call SetImageConstantHeight(BuildingIcons[index], true, 135)
                call SetImageRenderAlways(BuildingIcons[index], true)
                if(p == pLoc or IsPlayerAlly(p, pLoc) or pObs) then
                    call ShowImage(BuildingIcons[index], true)
                else
                    call ShowImage(BuildingIcons[index], false)
                endif
            endif
            set i = i + 1
        endloop
        set j = j + 1
    endloop
endfunction

// Функция типо основной

function FG takes nothing returns nothing
    local integer i=0
    loop
        if(Li[i]=='h075')then
            call AllBuildingsAvailable(true, Player(i))
            if(Wr)then
                call SetPlayerUnitAvailableBJ('h008',false,Player(i))
            endif
            if(wr)then
                call SetPlayerUnitAvailableBJ('h001',false,Player(i))
                call SetPlayerUnitAvailableBJ('h048',false,Player(i))
                call SetPlayerUnitAvailableBJ('h01E',false,Player(i))
            endif
        endif
        set i=i+1
        exitwhen i>11
    endloop
endfunction

// Основная функция
function GG takes nothing returns nothing
    local unit u=GetTriggerUnit()
    local player p
    local integer i


    if(GetUnitTypeId(u)!='h075')then
        set u=null
        return
    endif
    set p=GetOwningPlayer(u)
    set i=GetPlayerId(GetOwningPlayer(u))

    call AllBuildingsAvailable(false, Player(i))
    
    call RandomBuildings()

    //call DisplayTextToForce( bj_FORCE_ALL_PLAYERS, "Игрок: " + GetPlayerName(p) + " " + UnitId2String(buildings[0]) )

    // Блок с рекомендациями
    set RecBuilings[0 + i * 6] = buildings[0]
    set RecBuilings[1 + i * 6] = buildings[1]
    set RecBuilings[2 + i * 6] = buildings[2]
    set RecBuilings[3 + i * 6] = buildings[3]
    set RecBuilings[4 + i * 6] = buildings[4]
    set RecBuilings[5 + i * 6] = buildings[5]
    // Конец

    call SetPlayerUnitAvailableBJ(buildings[0],true,Player(i))
    call SetPlayerUnitAvailableBJ(buildings[1],true,Player(i))
    call SetPlayerUnitAvailableBJ(buildings[2],true,Player(i))
    call SetPlayerUnitAvailableBJ(buildings[3],true,Player(i))
    call SetPlayerUnitAvailableBJ(buildings[4],true,Player(i))
    call SetPlayerUnitAvailableBJ(buildings[5],true,Player(i))
    call SetPlayerUnitAvailableBJ(buildings[6],true,Player(i))
    call SetPlayerUnitAvailableBJ(buildings[7],true,Player(i))
    call SetPlayerUnitAvailableBJ(buildings[8],true,Player(i))
    call SetPlayerUnitAvailableBJ(buildings[9],true,Player(i))
    call SetPlayerUnitAvailableBJ(buildings[10],true,Player(i))

    call CreatePlayerName(p)
    call CreateBuildingIcons(p)

    set u=null
endfunction

function YJ takes nothing returns nothing
    call GG()
endfunction

function yJ takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='h075')
endfunction

function ListValueInit takes nothing returns nothing
    local integer frontValue = StringHash("frontvalue")
    local integer backValue = StringHash("backvalue")

    // Human
    call SaveInteger(Mo, 'h000', frontValue, 20)
    call SaveInteger(Mo, 'h000', backValue, 0)

    call SaveInteger(Mo, 'h003', frontValue, 0)
    call SaveInteger(Mo, 'h003', backValue, 15)

    call SaveInteger(Mo, 'h015', frontValue, 0)
    call SaveInteger(Mo, 'h015', backValue, 15)

    call SaveInteger(Mo, 'h037', frontValue, 18)
    call SaveInteger(Mo, 'h037', backValue, 0)

    // Orc

    call SaveInteger(Mo, 'h029', frontValue, 16)
    call SaveInteger(Mo, 'h029', backValue, 0)

    call SaveInteger(Mo, 'h02B', frontValue, 0)
    call SaveInteger(Mo, 'h02B', backValue, 13)

    call SaveInteger(Mo, 'h02H', frontValue, 0)
    call SaveInteger(Mo, 'h02H', backValue, 10)

    call SaveInteger(Mo, 'h02P', frontValue, 0)
    call SaveInteger(Mo, 'h02P', backValue, 17)

    call SaveInteger(Mo, 'h02K', frontValue, 12)
    call SaveInteger(Mo, 'h02K', backValue, 0)

    // Light Elf

    call SaveInteger(Mo, 'h08X', frontValue, 0)
    call SaveInteger(Mo, 'h08X', backValue, 14)

    call SaveInteger(Mo, 'h00T', frontValue, 15)
    call SaveInteger(Mo, 'h00T', backValue, 0)

    call SaveInteger(Mo, 'h00V', frontValue, 0)
    call SaveInteger(Mo, 'h00V', backValue, 18)

    // Корапт

    call SaveInteger(Mo, 'h04V', frontValue, 20)
    call SaveInteger(Mo, 'h04V', backValue, 0)

    call SaveInteger(Mo, 'h04L', frontValue, 0)
    call SaveInteger(Mo, 'h04L', backValue, 14)

    call SaveInteger(Mo, 'h04O', frontValue, 0)
    call SaveInteger(Mo, 'h04O', backValue, 16)

    // Naga

    call SaveInteger(Mo, 'h020', frontValue, 15)
    call SaveInteger(Mo, 'h020', backValue, 0)

    call SaveInteger(Mo, 'h00J', frontValue, 0)
    call SaveInteger(Mo, 'h00J', backValue, 14)

    call SaveInteger(Mo, 'h01Y', frontValue, 0)
    call SaveInteger(Mo, 'h01Y', backValue, 18)

    call SaveInteger(Mo, 'h00F', frontValue, 16)
    call SaveInteger(Mo, 'h00F', backValue, 0)

    // Northrend

    call SaveInteger(Mo, 'h049', frontValue, 14)
    call SaveInteger(Mo, 'h049', backValue, 0)

    call SaveInteger(Mo, 'h03U', frontValue, 0)
    call SaveInteger(Mo, 'h03U', backValue, 13)

    call SaveInteger(Mo, 'h03K', frontValue, 0)
    call SaveInteger(Mo, 'h03K', backValue, 14)

    call SaveInteger(Mo, 'h03T', frontValue, 15)
    call SaveInteger(Mo, 'h03T', backValue, 0)

    // Night Elf

    call SaveInteger(Mo, 'h00S', frontValue, 0)
    call SaveInteger(Mo, 'h00S', backValue, 20)

    call SaveInteger(Mo, 'h088', frontValue, 0)
    call SaveInteger(Mo, 'h088', backValue, 14)

    call SaveInteger(Mo, 'h07M', frontValue, 0)
    call SaveInteger(Mo, 'h07M', backValue, 10)

    call SaveInteger(Mo, 'h07O', frontValue, 13)
    call SaveInteger(Mo, 'h07O', backValue, 0)

    call SaveInteger(Mo, 'h00B', frontValue, 0)
    call SaveInteger(Mo, 'h00B', backValue, 12)

    // Undead

    call SaveInteger(Mo, 'h01R', frontValue, 20)
    call SaveInteger(Mo, 'h01R', backValue, 0)

    call SaveInteger(Mo, 'h01K', frontValue, 0)
    call SaveInteger(Mo, 'h01K', backValue, 13)

    call SaveInteger(Mo, 'h01N', frontValue, 15)
    call SaveInteger(Mo, 'h01N', backValue, 0)

    // Chaos

    call SaveInteger(Mo, 'h01I', frontValue, 0)
    call SaveInteger(Mo, 'h01I', backValue, 10)

    call SaveInteger(Mo, 'h01D', frontValue, 10)
    call SaveInteger(Mo, 'h01D', backValue, 0)

    call SaveInteger(Mo, 'h01C', frontValue, 0)
    call SaveInteger(Mo, 'h01C', backValue, 20)

    call SaveInteger(Mo, 'h025', frontValue, 18)
    call SaveInteger(Mo, 'h025', backValue, 0)

    // Механик

    call SaveInteger(Mo, 'h05X', frontValue, 0)
    call SaveInteger(Mo, 'h05X', backValue, 15)

    call SaveInteger(Mo, 'h05T', frontValue, 16)
    call SaveInteger(Mo, 'h05T', backValue, 0)

    call SaveInteger(Mo, 'h05V', frontValue, 15)
    call SaveInteger(Mo, 'h05V', backValue, 0)

    // Природа

    call SaveInteger(Mo, 'h002', frontValue, 12)
    call SaveInteger(Mo, 'h002', backValue, 0)

    call SaveInteger(Mo, 'h00Y', frontValue, 0)
    call SaveInteger(Mo, 'h00Y', backValue, 14)

    call SaveInteger(Mo, 'h013', frontValue, 0)
    call SaveInteger(Mo, 'h013', backValue, 18)

    call SaveInteger(Mo, 'h023', frontValue, 18)
    call SaveInteger(Mo, 'h023', backValue, 0)

    // Elemental

    call SaveInteger(Mo, 'h03X', frontValue, 17)
    call SaveInteger(Mo, 'h03X', backValue, 0)

    call SaveInteger(Mo, 'h045', frontValue, 0)
    call SaveInteger(Mo, 'h045', backValue, 16)

    call SaveInteger(Mo, 'h042', frontValue, 0)
    call SaveInteger(Mo, 'h042', backValue, 20)

    call SaveInteger(Mo, 'h040', frontValue, 15)
    call SaveInteger(Mo, 'h040', backValue, 0)
endfunction

function ListBuildingsInit takes nothing returns nothing
    set AllBuildings[0] = 'h04V'
    set AllBuildings[1] = 'h000'
    set AllBuildings[2] = 'h029'
    set AllBuildings[3] = 'h020'
    set AllBuildings[4] = 'h049'
    set AllBuildings[5] = 'h01I'
    set AllBuildings[6] = 'h01R'
    set AllBuildings[7] = 'h08X'
    set AllBuildings[8] = 'h00S'
    set AllBuildings[9] = 'h05J'
    set AllBuildings[10] = 'h002'
    set AllBuildings[11] = 'h04A'
    set AllBuildings[12] = 'h04L'
    set AllBuildings[13] = 'h003'
    set AllBuildings[14] = 'h02B'
    set AllBuildings[15] = 'h00J'
    set AllBuildings[16] = 'h03U'
    set AllBuildings[17] = 'h01D'
    set AllBuildings[18] = 'h01K'
    set AllBuildings[19] = 'h00T'
    set AllBuildings[20] = 'h088'
    set AllBuildings[21] = 'h05X'
    set AllBuildings[22] = 'h00Y'
    set AllBuildings[23] = 'h03X'
    set AllBuildings[24] = 'h04O'
    set AllBuildings[25] = 'h004'
    set AllBuildings[26] = 'h02H'
    set AllBuildings[27] = 'h01Y'
    set AllBuildings[28] = 'h03K'
    set AllBuildings[29] = 'h01C'
    set AllBuildings[30] = 'h01N'
    set AllBuildings[31] = 'h00V'
    set AllBuildings[32] = 'h07M'
    set AllBuildings[33] = 'h05M'
    set AllBuildings[34] = 'h013'
    set AllBuildings[35] = 'h045'
    set AllBuildings[36] = 'h04S'
    set AllBuildings[37] = 'h015'
    set AllBuildings[38] = 'h02P'
    set AllBuildings[39] = 'h00F'
    set AllBuildings[40] = 'h03T'
    set AllBuildings[41] = 'h025'
    set AllBuildings[42] = 'h01L'
    set AllBuildings[43] = 'h06Y'
    set AllBuildings[44] = 'h07O'
    set AllBuildings[45] = 'h05T'
    set AllBuildings[46] = 'h023'
    set AllBuildings[47] = 'h042'
    set AllBuildings[48] = 'h04Q'
    set AllBuildings[49] = 'h037'
    set AllBuildings[50] = 'h02K'
    set AllBuildings[51] = 'h01B'
    set AllBuildings[52] = 'h03I'
    set AllBuildings[53] = 'h009'
    set AllBuildings[54] = 'h01T'
    set AllBuildings[55] = 'h070'
    set AllBuildings[56] = 'h00B'
    set AllBuildings[57] = 'h05V'
    set AllBuildings[58] = 'h027'
    set AllBuildings[59] = 'h040'
    set AllBuildings[60] = 'h04U'
    set AllBuildings[61] = 'h00K'
    set AllBuildings[62] = 'h02I'
    set AllBuildings[63] = 'h01Z'
    set AllBuildings[64] = 'h03S'
    set AllBuildings[65] = 'h007'
    set AllBuildings[66] = 'h01S'
    set AllBuildings[67] = 'h09X'
    set AllBuildings[68] = 'h011'
    set AllBuildings[69] = 'h05U'
    set AllBuildings[70] = 'h028'
    set AllBuildings[71] = 'h062'
    set AllBuildings[72] = 'h04K'
    set AllBuildings[73] = 'h010'
    set AllBuildings[74] = 'h02N'
    set AllBuildings[75] = 'h00I'
    set AllBuildings[76] = 'h048'
    set AllBuildings[77] = 'h01M'
    set AllBuildings[78] = 'h00A'
    set AllBuildings[79] = 'h00Z'
    set AllBuildings[80] = 'h08P'
    set AllBuildings[81] = 'h09T'
    set AllBuildings[82] = 'h02C'
    set AllBuildings[83] = 'h060'
    set AllBuildings[84] = 'h04R'
    set AllBuildings[85] = 'h001'
    set AllBuildings[86] = 'h02R'
    set AllBuildings[87] = 'h00M'
    set AllBuildings[88] = 'h047'
    set AllBuildings[89] = 'h01F'
    set AllBuildings[90] = 'h01P'
    set AllBuildings[91] = 'h005'
    set AllBuildings[92] = 'h07H'
    set AllBuildings[93] = 'h069'
    set AllBuildings[94] = 'h02A'
    set AllBuildings[95] = 'h05Z'
    set AllBuildings[96] = 'n01J'
    set AllBuildings[97] = 'h006'
    set AllBuildings[98] = 'o000'
    set AllBuildings[99] = 'h00G'
    set AllBuildings[100] = 'h03Q'
    set AllBuildings[101] = 'h05I'
    set AllBuildings[102] = 'h01O'
    set AllBuildings[103] = 'h014'
    set AllBuildings[104] = 'h073'
    set AllBuildings[105] = 'h05L'
    set AllBuildings[106] = 'n02D'
    set AllBuildings[107] = 'h061'
    set AllBuildings[108] = 'h076'
    set AllBuildings[109] = 'h04T'
    set AllBuildings[110] = 'h05G'
    set AllBuildings[111] = 'h02O'
    set AllBuildings[112] = 'h00N'
    set AllBuildings[113] = 'h03O'
    set AllBuildings[114] = 'h01E'
    set AllBuildings[115] = 'h01Q'
    set AllBuildings[116] = 'h059'
    set AllBuildings[117] = 'h07I'
    set AllBuildings[118] = 'h06J'
    set AllBuildings[119] = 'h02D'
    set AllBuildings[120] = 'h063'
    set AllBuildings[121] = 'h071'
    set AllBuildings[122] = 'h008'
endfunction

function InitTrig_UltimateBuilder takes nothing returns nothing
    local trigger t = CreateTrigger(  )

    call ListBuildingsInit()
    call ListValueInit()
    set PlayerColor[0] = "|cFFea272b"
    set PlayerColor[1] = "|cFF3a4de0"
    set PlayerColor[2] = "|cFF13d8c5"
    set PlayerColor[6] = "|cFF10c928"
    set PlayerColor[7] = "|cFFea3fc5"
    set PlayerColor[8] = "|cFF8b9695"

    call ForceAddPlayer(TeamLeft, Player(0))
    call ForceAddPlayer(TeamLeft, Player(1))
    call ForceAddPlayer(TeamLeft, Player(2))
    call ForceAddPlayer(TeamRight, Player(6))
    call ForceAddPlayer(TeamRight, Player(7))
    call ForceAddPlayer(TeamRight, Player(8))

    call TriggerRegisterEnterRectSimple(t, gg_rct_MapArea)
    call TriggerAddCondition(t,Condition(function yJ))
    call TriggerAddAction(t,function GG)
endfunction