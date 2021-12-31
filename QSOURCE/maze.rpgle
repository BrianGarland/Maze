**FREE
CTL-OPT DFTACTGRP(*NO) ACTGRP(*NEW);

DCL-F MAZEFM WORKSTN INFDS(DSPFDS);



DCL-C #LEFT      x'31'; //F1
DCL-C #RIGHT     x'32'; //F2
DCL-C #EXIT      x'33'; //F3
DCL-C #FORWARD   X'38'; //F8
DCL-C #DEBUG     X'3B'; //Page Down

DCL-C NORTH 1;
DCL-C EAST  2;
DCL-C SOUTH 3;
DCL-C WEST  4;

DCL-C NORMAL x'20';
DCL-C RED    x'29';
DCL-C WHITE  x'23';

DCL-DS DSPFDS;
    FKey CHAR(1) POS(369);
END-DS;


DCL-S DebugFlag IND INZ(*OFF);
DCL-S DirX      INT(5) DIM(4);
DCL-S DirY      INT(5) DIM(4);
DCL-S EOJ       IND INZ(*OFF);
DCL-S MazeData  CHAR(100);
DCL-S PlayerDir INT(5);
DCL-S PlayerX   INT(5);
DCL-S PlayerY   INT(5);
DCL-S NewX      INT(5);
DCL-S NewY      INT(5);



InitMaze();

DOU EOJ;

    DrawMaze();

    SELECT;
    WHEN FKey = #LEFT;
        PlayerDir -= 1;
        IF playerDir < NORTH;
            PlayerDir = WEST;
        ENDIF;

    WHEN FKey = #RIGHT;
        PlayerDir += 1;
        IF playerDir > WEST;
            PlayerDir = NORTH;
        ENDIF;

    WHEN FKey = #EXIT;
        EOJ = *ON;

    WHEN FKey = #FORWARD;
        newX = playerX + dirX(PlayerDir);
        newY = playerY + dirY(PlayerDir);
        IF Maze(NewX:NewY) = '0';
            playerX = newX;
            playerY = newY;
        ENDIF;

    WHEN FKey = #DEBUG;
        DebugFlag = NOT(DebugFlag);

    ENDSL;

ENDDO;

*INLR = *ON;
RETURN;



//--------------------------------------
DCL-PROC InitMaze;
DCL-PI *N;
END-PI;

    MazeData = '1111111111'
             + '1101010001'
             + '1000010101'
             + '1101000001'
             + '1101010101'
             + '1000000001'
             + '1101011011'
             + '1101011011'
             + '1100000001'
             + '1111111111';

    PlayerX = 2;
    PlayerY = 5;
    PlayerDir = 3;

    DirX(1) = -1;
    DirX(2) =  0;
    DirX(3) =  1;
    DirX(4) =  0;

    DirY(1) =  0;
    DirY(2) =  1;
    DirY(3) =  0;
    DirY(4) = -1;

END-PROC;



//--------------------------------------
DCL-PROC DrawMaze;
DCL-PI *N;
END-PI;

    DCL-S dm INT(5);
    DCL-S l  INT(5);
    DCL-S MazeLine VARCHAR(21) DIM(10);
    DCL-S x  INT(5);
    DCL-S y  INT(5);
    DCL-S xl INT(5);
    DCL-S yl INT(5);
    DCL-S xr INT(5);
    DCL-S yr INT(5);

    CLEAR Line01;
    CLEAR Line02;
    CLEAR Line03;
    CLEAR Line04;
    CLEAR Line05;
    CLEAR Line06;
    CLEAR Line07;
    CLEAR Line08;
    CLEAR Line09;
    CLEAR Line10;
    CLEAR Line11;
    CLEAR Line12;
    CLEAR Line13;
    CLEAR Line14;
    CLEAR Line15;
    CLEAR Line16;
    CLEAR Line17;
    CLEAR Line18;
    CLEAR Line19;
    CLEAR Line20;
    CLEAR Line21;
    CLEAR Line22;
    CLEAR Line23;
    CLEAR Line24;
    CLEAR Line25;
    CLEAR Line26;

    dm = 1;
    IF playerDir = 2 or playerDir = 4;
        dm = -1;
    ENDIF;

    FOR l = 4 DOWNTO 0;
       x = playerX + (l*dirX(playerDir));
       y = playerY + (l*dirY(playerDir));
       IF x >= 1 AND x <= 10 AND y >= 1 AND y <= 10;
           xl = x + (dirY(playerDir) * dm);
           yl = y + (dirX(playerDir) * dm);
           IF maze(xl:yl) = '1';
               Left(l);
           ENDIF;
           xr = x - (dirY(playerDir) * dm);
           yr = y - (dirX(playerDir) * dm);
           IF maze(xr:yr) = '1';
               Right(l);
           ENDIF;
           IF maze(x:y) = '1';
               Mid(l);
           ENDIF;
       ENDIF;
    ENDFOR;

    sx   = playerX;
    sy   = playerY;
    sdir = PlayerDir;

    IF DebugFlag;
        FOR x = 1 TO 10;
            FOR y = 1 TO 10;
                SELECT;
                WHEN x = PlayerX AND y = PlayerY;
                    MazeLine(x) += RED + Maze(x:y);
                WHEN x = PlayerX AND y = PlayerY+1;
                    MazeLine(x) += WHITE + Maze(x:y);
                OTHER;
                    MazeLine(x) += ' ' + Maze(x:y);
                ENDSL;
            ENDFOR;
            MazeLine(x) += ' ';
        ENDFOR;
        %SUBST(Line09:108:23) = WHITE + '                     ' + NORMAL;
        %SUBST(Line09:108:23) = WHITE + MazeLine(01) + NORMAL;
        %SUBST(Line10:108:23) = WHITE + MazeLine(02) + NORMAL;
        %SUBST(Line11:108:23) = WHITE + MazeLine(03) + NORMAL;
        %SUBST(Line12:108:23) = WHITE + MazeLine(04) + NORMAL;
        %SUBST(Line13:108:23) = WHITE + MazeLine(05) + NORMAL;
        %SUBST(Line14:108:23) = WHITE + MazeLine(06) + NORMAL;
        %SUBST(Line15:108:23) = WHITE + MazeLine(07) + NORMAL;
        %SUBST(Line16:108:23) = WHITE + MazeLine(08) + NORMAL;
        %SUBST(Line17:108:23) = WHITE + MazeLine(09) + NORMAL;
        %SUBST(Line18:108:23) = WHITE + MazeLine(10) + NORMAL;
        %SUBST(Line19:108:23) = WHITE + '                     ' + NORMAL;
    ENDIF;

    EXFMT S1;

    RETURN;

END-PROC;



//--------------------------------------
DCL-PROC Maze;
DCL-PI *N CHAR(1);
    x INT(5);
    y INT(5);
END-PI;

    RETURN %SUBST(MazeData:(x-1)*10+y:1);

END-PROC;



//--------------------------------------
DCL-PROC Left;
DCL-PI *N;
    l INT(5);
END-PI;

    SELECT;
        WHEN l = 4;
            // we cannot see this far
        WHEN l = 3;
            %SUBST(Line11:51:5) = *ALL'X';
            %SUBST(Line12:51:10) = *ALL'X';
            %SUBST(Line13:51:10) = *ALL'X';
            %SUBST(Line14:51:10) = *ALL'X';
            %SUBST(Line15:51:10) = *ALL'X';
            %SUBST(Line16:51:5) = *ALL'X';
            %SUBST(Line11:41:10) = *ALL'+';
            %SUBST(Line12:41:10) = *ALL'+';
            %SUBST(Line13:41:10) = *ALL'+';
            %SUBST(Line14:41:10) = *ALL'+';
            %SUBST(Line15:41:10) = *ALL'+';
            %SUBST(Line16:41:10) = *ALL'+';
        WHEN l = 2;
            %SUBST(Line09:41:5) = *ALL'X';
            %SUBST(Line10:41:10) = *ALL'X';
            %SUBST(Line11:41:10) = *ALL'X';
            %SUBST(Line12:41:10) = *ALL'X';
            %SUBST(Line13:41:10) = *ALL'X';
            %SUBST(Line14:41:10) = *ALL'X';
            %SUBST(Line15:41:10) = *ALL'X';
            %SUBST(Line16:41:10) = *ALL'X';
            %SUBST(Line17:41:10) = *ALL'X';
            %SUBST(Line18:41:5) = *ALL'X';
            %SUBST(Line09:26:15) = *ALL'+';
            %SUBST(Line10:26:15) = *ALL'+';
            %SUBST(Line11:26:15) = *ALL'+';
            %SUBST(Line12:26:15) = *ALL'+';
            %SUBST(Line13:26:15) = *ALL'+';
            %SUBST(Line14:26:15) = *ALL'+';
            %SUBST(Line15:26:15) = *ALL'+';
            %SUBST(Line16:26:15) = *ALL'+';
            %SUBST(Line17:26:15) = *ALL'+';
            %SUBST(Line18:26:15) = *ALL'+';
        WHEN l = 1;
            %SUBST(Line06:26:5) = *ALL'X';
            %SUBST(Line07:26:10) = *ALL'X';
            %SUBST(Line08:26:15) = *ALL'X';
            %SUBST(Line09:26:15) = *ALL'X';
            %SUBST(Line10:26:15) = *ALL'X';
            %SUBST(Line11:26:15) = *ALL'X';
            %SUBST(Line12:26:15) = *ALL'X';
            %SUBST(Line13:26:15) = *ALL'X';
            %SUBST(Line14:26:15) = *ALL'X';
            %SUBST(Line15:26:15) = *ALL'X';
            %SUBST(Line16:26:15) = *ALL'X';
            %SUBST(Line17:26:15) = *ALL'X';
            %SUBST(Line18:26:15) = *ALL'X';
            %SUBST(Line19:26:15) = *ALL'X';
            %SUBST(Line20:26:10) = *ALL'X';
            %SUBST(Line21:26:5) = *ALL'X';
            %SUBST(Line06:1:25) = *ALL'+';
            %SUBST(Line07:1:25) = *ALL'+';
            %SUBST(Line08:1:25) = *ALL'+';
            %SUBST(Line09:1:25) = *ALL'+';
            %SUBST(Line10:1:25) = *ALL'+';
            %SUBST(Line11:1:25) = *ALL'+';
            %SUBST(Line12:1:25) = *ALL'+';
            %SUBST(Line13:1:25) = *ALL'+';
            %SUBST(Line14:1:25) = *ALL'+';
            %SUBST(Line15:1:25) = *ALL'+';
            %SUBST(Line16:1:25) = *ALL'+';
            %SUBST(Line17:1:25) = *ALL'+';
            %SUBST(Line18:1:25) = *ALL'+';
            %SUBST(Line19:1:25) = *ALL'+';
            %SUBST(Line20:1:25) = *ALL'+';
            %SUBST(Line21:1:25) = *ALL'+';
        WHEN l = 0;
            %SUBST(Line01:1:5) = *ALL'X';
            %SUBST(Line02:1:10) = *ALL'X';
            %SUBST(Line03:1:15) = *ALL'X';
            %SUBST(Line04:1:20) = *ALL'X';
            %SUBST(Line05:1:25) = *ALL'X';
            %SUBST(Line06:1:25) = *ALL'X';
            %SUBST(Line07:1:25) = *ALL'X';
            %SUBST(Line08:1:25) = *ALL'X';
            %SUBST(Line09:1:25) = *ALL'X';
            %SUBST(Line10:1:25) = *ALL'X';
            %SUBST(Line11:1:25) = *ALL'X';
            %SUBST(Line12:1:25) = *ALL'X';
            %SUBST(Line13:1:25) = *ALL'X';
            %SUBST(Line14:1:25) = *ALL'X';
            %SUBST(Line15:1:25) = *ALL'X';
            %SUBST(Line16:1:25) = *ALL'X';
            %SUBST(Line17:1:25) = *ALL'X';
            %SUBST(Line18:1:25) = *ALL'X';
            %SUBST(Line19:1:25) = *ALL'X';
            %SUBST(Line20:1:25) = *ALL'X';
            %SUBST(Line21:1:25) = *ALL'X';
            %SUBST(Line22:1:25) = *ALL'X';
            %SUBST(Line23:1:20) = *ALL'X';
            %SUBST(Line24:1:15) = *ALL'X';
            %SUBST(Line25:1:10) = *ALL'X';
            %SUBST(Line26:1:5) = *ALL'X';
    ENDSL;

END-PROC;



//--------------------------------------
DCL-PROC Right;
DCL-PI *N;
    l INT(5);
END-PI;

    SELECT;
        WHEN l = 4;
            // we cannot see this far
        WHEN l = 3;
            %SUBST(Line11:76:5) = *ALL'X';
            %SUBST(Line12:71:10) = *ALL'X';
            %SUBST(Line13:71:10) = *ALL'X';
            %SUBST(Line14:71:10) = *ALL'X';
            %SUBST(Line15:71:10) = *ALL'X';
            %SUBST(Line16:76:5) = *ALL'X';
            %SUBST(Line11:81:10) = *ALL'+';
            %SUBST(Line12:81:10) = *ALL'+';
            %SUBST(Line13:81:10) = *ALL'+';
            %SUBST(Line14:81:10) = *ALL'+';
            %SUBST(Line15:81:10) = *ALL'+';
            %SUBST(Line16:81:10) = *ALL'+';
        WHEN l = 2;
            %SUBST(Line09:86:5) = *ALL'X';
            %SUBST(Line10:81:10) = *ALL'X';
            %SUBST(Line11:81:10) = *ALL'X';
            %SUBST(Line12:81:10) = *ALL'X';
            %SUBST(Line13:81:10) = *ALL'X';
            %SUBST(Line14:81:10) = *ALL'X';
            %SUBST(Line15:81:10) = *ALL'X';
            %SUBST(Line16:81:10) = *ALL'X';
            %SUBST(Line17:81:10) = *ALL'X';
            %SUBST(Line18:86:5) = *ALL'X';
            %SUBST(Line09:91:15) = *ALL'+';
            %SUBST(Line10:91:15) = *ALL'+';
            %SUBST(Line11:91:15) = *ALL'+';
            %SUBST(Line12:91:15) = *ALL'+';
            %SUBST(Line13:91:15) = *ALL'+';
            %SUBST(Line14:91:15) = *ALL'+';
            %SUBST(Line15:91:15) = *ALL'+';
            %SUBST(Line16:91:15) = *ALL'+';
            %SUBST(Line17:91:15) = *ALL'+';
            %SUBST(Line18:91:15) = *ALL'+';
        WHEN l = 1;
            %SUBST(Line06:101:5) = *ALL'X';
            %SUBST(Line07:96:10) = *ALL'X';
            %SUBST(Line08:91:15) = *ALL'X';
            %SUBST(Line09:91:15) = *ALL'X';
            %SUBST(Line10:91:15) = *ALL'X';
            %SUBST(Line11:91:15) = *ALL'X';
            %SUBST(Line12:91:15) = *ALL'X';
            %SUBST(Line13:91:15) = *ALL'X';
            %SUBST(Line14:91:15) = *ALL'X';
            %SUBST(Line15:91:15) = *ALL'X';
            %SUBST(Line16:91:15) = *ALL'X';
            %SUBST(Line17:91:15) = *ALL'X';
            %SUBST(Line18:91:15) = *ALL'X';
            %SUBST(Line19:91:15) = *ALL'X';
            %SUBST(Line20:96:10) = *ALL'X';
            %SUBST(Line21:101:5) = *ALL'X';
            %SUBST(Line06:106:25) = *ALL'+';
            %SUBST(Line07:106:25) = *ALL'+';
            %SUBST(Line08:106:25) = *ALL'+';
            %SUBST(Line09:106:25) = *ALL'+';
            %SUBST(Line10:106:25) = *ALL'+';
            %SUBST(Line11:106:25) = *ALL'+';
            %SUBST(Line12:106:25) = *ALL'+';
            %SUBST(Line13:106:25) = *ALL'+';
            %SUBST(Line14:106:25) = *ALL'+';
            %SUBST(Line15:106:25) = *ALL'+';
            %SUBST(Line16:106:25) = *ALL'+';
            %SUBST(Line17:106:25) = *ALL'+';
            %SUBST(Line18:106:25) = *ALL'+';
            %SUBST(Line19:106:25) = *ALL'+';
            %SUBST(Line20:106:25) = *ALL'+';
            %SUBST(Line21:106:25) = *ALL'+';
        WHEN l = 0;
            %SUBST(Line01:126:5) = *ALL'X';
            %SUBST(Line02:121:10) = *ALL'X';
            %SUBST(Line03:116:15) = *ALL'X';
            %SUBST(Line04:111:20) = *ALL'X';
            %SUBST(Line05:106:25) = *ALL'X';
            %SUBST(Line06:106:25) = *ALL'X';
            %SUBST(Line07:106:25) = *ALL'X';
            %SUBST(Line08:106:25) = *ALL'X';
            %SUBST(Line09:106:25) = *ALL'X';
            %SUBST(Line10:106:25) = *ALL'X';
            %SUBST(Line11:106:25) = *ALL'X';
            %SUBST(Line12:106:25) = *ALL'X';
            %SUBST(Line13:106:25) = *ALL'X';
            %SUBST(Line14:106:25) = *ALL'X';
            %SUBST(Line15:106:25) = *ALL'X';
            %SUBST(Line16:106:25) = *ALL'X';
            %SUBST(Line17:106:25) = *ALL'X';
            %SUBST(Line18:106:25) = *ALL'X';
            %SUBST(Line19:106:25) = *ALL'X';
            %SUBST(Line20:106:25) = *ALL'X';
            %SUBST(Line21:106:25) = *ALL'X';
            %SUBST(Line22:106:25) = *ALL'X';
            %SUBST(Line23:111:20) = *ALL'X';
            %SUBST(Line24:116:15) = *ALL'X';
            %SUBST(Line25:121:10) = *ALL'X';
            %SUBST(Line26:126:5) = *ALL'X';
    ENDSL;

END-PROC;



//--------------------------------------
DCL-PROC Mid;
DCL-PI *N;
    l INT(5);
END-PI;

    SELECT;
        WHEN l = 4;
            %SUBST(Line13:61:10) = *ALL'X';
            %SUBST(Line14:61:10) = *ALL'X';
            %SUBST(Line13:51:10) = *ALL'+';
            %SUBST(Line14:51:10) = *ALL'+';
            %SUBST(Line13:71:10) = *ALL'+';
            %SUBST(Line14:71:10) = *ALL'+';
        WHEN l = 3;
            %SUBST(Line11:51:30) = *ALL'X';
            %SUBST(Line12:51:30) = *ALL'X';
            %SUBST(Line13:51:30) = *ALL'X';
            %SUBST(Line14:51:30) = *ALL'X';
            %SUBST(Line15:51:30) = *ALL'X';
            %SUBST(Line16:51:30) = *ALL'X';
        WHEN l = 2;
            %SUBST(Line09:41:50) = *ALL'X';
            %SUBST(Line10:41:50) = *ALL'X';
            %SUBST(Line11:41:50) = *ALL'X';
            %SUBST(Line12:41:50) = *ALL'X';
            %SUBST(Line13:41:50) = *ALL'X';
            %SUBST(Line14:41:50) = *ALL'X';
            %SUBST(Line15:41:50) = *ALL'X';
            %SUBST(Line16:41:50) = *ALL'X';
            %SUBST(Line17:41:50) = *ALL'X';
            %SUBST(Line18:41:50) = *ALL'X';
        WHEN l = 1;
            %SUBST(Line06:26:80) = *ALL'X';
            %SUBST(Line07:26:80) = *ALL'X';
            %SUBST(Line08:26:80) = *ALL'X';
            %SUBST(Line09:26:80) = *ALL'X';
            %SUBST(Line10:26:80) = *ALL'X';
            %SUBST(Line11:26:80) = *ALL'X';
            %SUBST(Line12:26:80) = *ALL'X';
            %SUBST(Line13:26:80) = *ALL'X';
            %SUBST(Line14:26:80) = *ALL'X';
            %SUBST(Line15:26:80) = *ALL'X';
            %SUBST(Line16:26:80) = *ALL'X';
            %SUBST(Line17:26:80) = *ALL'X';
            %SUBST(Line18:26:80) = *ALL'X';
            %SUBST(Line19:26:80) = *ALL'X';
            %SUBST(Line20:26:80) = *ALL'X';
            %SUBST(Line21:26:80) = *ALL'X';
        WHEN l = 0;
            // You'd be standing in a solid wall here
    ENDSL;

END-PROC;



