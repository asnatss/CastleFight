globals
    effect array gridFx
    boolean array gridOn
endglobals

function Grid_Create takes player p returns nothing
    local integer id = GetPlayerId(p)
    local integer i
    local integer j
    local integer startindex
    local integer index
    local integer step
    local integer side
    local real startX1 = -5888
    local real startY1 = 704
    local real startX2 = -3328
    local real startY2 = 768
    local string e = ".mdx"

    if id <= 3 then
        set side = 1
    else
        set side = -1
    endif
    
    if (GetLocalPlayer() == p) then
        set e = "Grid(NoYellow).mdx"
    endif


    set i = 0
    set j = 0
    set step = 15
    set startindex = 0
    loop
        exitwhen i > 2
        // i = Y ; j = X
        set j = 0
        loop
            exitwhen j > 4
                set index = startindex + j + i * 5 + id * 48
                set gridFx[index] = AddSpecialEffect(e, side * startX1 + 512 * j * side, startY1 + 512 * i)
                set gridFx[index + step] = AddSpecialEffect(e, side * startX1 + 512 * j * side, (-1) * startY1 - 512 * i)
                set j = j + 1
        endloop
        set i = i + 1
    endloop

    set i = 0
    set j = 0
    set step = 9
    set startindex = 30
    loop
        exitwhen i > 2
        // i = Y ; j = X
        set j = 0
        loop
            exitwhen j > 2
                set index = startindex + j + i * 3 + id * 48
                set gridFx[index] = AddSpecialEffect(e, side * startX2 + 512 * j * side, startY2 + 512 * i)
                set gridFx[index + step] = AddSpecialEffect(e, side * startX2 + 512 * j * side, (-1) * startY2 - 512 * i)
                set j = j + 1
        endloop
        set i = i + 1
    endloop

    set gridOn[id] = true
endfunction

function Grid_Destroy takes player p returns nothing
    local integer id = GetPlayerId(p)
    local integer i = 0

    loop
        exitwhen i >= 48
        if gridFx[i + id * 48] != null then
            call DestroyEffect(gridFx[i + id * 48])
            set gridFx[i + id * 48] = null
        endif
        set i = i + 1
    endloop

    set gridOn[id] = false
endfunction

function Grid_Toggle takes player p returns nothing
    local integer id = GetPlayerId(p)

    if gridOn[id] then
        call DisplayTextToForce( bj_FORCE_PLAYER[id], "Grid disable" )
        call Grid_Destroy(p)
    else
        call DisplayTextToForce( bj_FORCE_PLAYER[id], "Grid enable" )
        call Grid_Create(p)
    endif
endfunction

function Grid_Chat takes nothing returns nothing
    if SubString(GetEventPlayerChatString(), 0, 5) == "-grid" then
        call Grid_Toggle(GetTriggerPlayer())
    endif
endfunction

function InitTrig_grid takes nothing returns nothing
    local trigger t = CreateTrigger(  )
    local integer i = 0

    loop
        exitwhen i > 2
        call TriggerRegisterPlayerChatEvent(t, Player(i), "", false)
        call TriggerRegisterPlayerChatEvent(t, Player(i+6), "", false)
        set i = i + 1
    endloop
    
    call TriggerAddAction(t, function Grid_Chat)
endfunction
