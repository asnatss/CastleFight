//! nocjass
//! zinc
library InfoBoard {
    image QR_CODE;
    
    function onInit() {
        integer i;
        
        for (0 <= i <= bj_MAX_PLAYERS) CreateFogModifierRectBJ(true, Player(i), FOG_OF_WAR_VISIBLE, gg_rct_InfoBoard);
        
        QR_CODE = CreateImageBJ("qrcode.blp", 512., Location(1184., -2144.), 0., 2);
        SetImageRenderAlways(QR_CODE, true);
        ShowImage(QR_CODE, true);
    }
}
//! endzinc
//! endnocjass

