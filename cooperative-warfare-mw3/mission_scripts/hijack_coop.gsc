// Our co-op functions for hijack (decoded gsc-tool names). Added to your own decompiled copy of the level script.

coop_flag( var_0 )
{
    if ( !isdefined( level.flag ) )
        return 0;

    if ( !isdefined( level.flag[var_0] ) )
        return 0;

    return level.flag[var_0];
}

coop_default( var_0, var_1 )
{
    var_2 = getdvar( var_0 );

    if ( var_2 == "" )
        var_2 = var_1;
    else if ( var_2 == "none" )
        var_2 = "";

    level.coop_cfg[var_0] = var_2;
}

coop_get( var_0 )
{
    if ( !isdefined( level.coop_cfg ) )
        return "";

    if ( !isdefined( level.coop_cfg[var_0] ) )
        return "";

    return level.coop_cfg[var_0];
}

coop_precache()
{
    level.coop_cfg = [];
    coop_default( "coop_body1", "coop_body_loyalist_d" );
    coop_default( "coop_head1", "head_fso_a" );
    coop_default( "coop_body2", "coop_body_loyalist_d" );
    coop_default( "coop_head2", "head_fso_d" );
    coop_default( "coop_hands", "viewhands_fso" );
    coop_default( "coop_anim", "1" );
    level.coop_incap_weapon = "fnfiveseven";
    var_0 = [ "coop_body1", "coop_head1", "coop_body2", "coop_head2" ];

    foreach ( var_1 in var_0 )
    {
        if ( coop_get( var_1 ) != "" )
            precachemodel( coop_get( var_1 ) );
    }

    precacheitem( "fnfiveseven" );
}

coop_models()
{
    level waittill( "loadout complete" );
    wait 2.5;
    coop_apply();
    wait 3;
    coop_apply();
    wait 5;
    coop_apply();
}

coop_apply()
{
    level.player setviewmodel( coop_get( "coop_hands" ) );
    level.player maps\_utility::setmodelfunc( ::coop_body1 );

    if ( coop_get( "coop_anim" ) == "1" )
        level.player setanim( %code, 1, 0 );

    if ( !isdefined( level.player2 ) )
        return;

    level.player2 setviewmodel( coop_get( "coop_hands" ) );
    level.player2 maps\_utility::setmodelfunc( ::coop_body2 );

    if ( coop_get( "coop_anim" ) == "1" )
        level.player2 setanim( %code, 1, 0 );
}

coop_body1()
{
    self setmodel( coop_get( "coop_body1" ) );

    if ( coop_get( "coop_head1" ) != "" )
        self attach( coop_get( "coop_head1" ), "", 1 );
}

coop_body2()
{
    self setmodel( coop_get( "coop_body2" ) );

    if ( coop_get( "coop_head2" ) != "" )
        self attach( coop_get( "coop_head2" ), "", 1 );
}

coop_p2_place()
{
    var_0 = level.player.angles[1];
    var_1 = anglestoright( ( 0, var_0, 0 ) );
    var_2 = anglestoforward( ( 0, var_0, 0 ) );
    var_3 = [];
    var_3[0] = var_1 * -40 + var_2 * -20;
    var_3[1] = var_1 * 40 + var_2 * -20;
    var_3[2] = var_2 * -56;
    var_3[3] = var_1 * -52 + var_2 * -52;
    var_3[4] = var_1 * 52 + var_2 * -52;
    var_3[5] = var_1 * -70;
    var_3[6] = var_1 * 70;
    var_3[7] = var_2 * 56;
    var_4 = level.player.origin + var_3[0];

    for ( var_5 = 0; var_5 < var_3.size; var_5++ )
    {
        var_6 = level.player.origin + ( 0, 0, 32 );
        var_7 = level.player.origin + var_3[var_5] + ( 0, 0, 32 );
        var_8 = bullettracepassed( var_6, var_7, 0, undefined );
        var_9 = bullettracepassed( var_7, var_7 + ( 0, 0, 40 ), 0, undefined );
        var_10 = bullettracepassed( var_7, var_7 + var_1 * 22, 0, undefined ) && bullettracepassed( var_7, var_7 - var_1 * 22, 0, undefined ) && bullettracepassed( var_7, var_7 + var_2 * 22, 0, undefined ) && bullettracepassed( var_7, var_7 - var_2 * 22, 0, undefined );
        var_11 = bullettrace( var_7, var_7 - ( 0, 0, 70 ), 0, undefined );

        if ( var_8 && var_9 && var_10 && var_11["fraction"] < 1 )
        {
            var_4 = var_11["position"] + ( 0, 0, 2 );
            break;
        }
    }

    level.player2 setorigin( var_4 );
    level.player2 setplayerangles( level.player getplayerangles() );
}

coop_p2_setup()
{
    level waittill( "loadout complete" );
    var_0 = 0;

    while ( !isdefined( level.player2 ) && var_0 < 200 )
    {
        wait 0.1;
        var_0++;
    }

    if ( !isdefined( level.player2 ) )
        return;

    level.player2 takeallweapons();
    level.player2 disableweapons();
    level.player2 allowsprint( 0 );
    level.player2 setmovespeedscale( 0.35 );
    level.player2 enableinvulnerability();
    level.player2 freezecontrols( 1 );
    var_1 = 0;

    while ( !coop_flag( "introscreen_done" ) && var_1 < 600 )
    {
        coop_p2_place();
        wait 0.1;
        var_1++;
    }

    wait 3;
    coop_p2_place();
    level.player2 setmovespeedscale( 0.35 );
    level.player2 freezecontrols( 0 );
}

coop_keep_together()
{
    var_5 = newhudelem();
    var_5.x = 20;
    var_5.y = 95;
    var_5.alignx = "left";
    var_5.aligny = "top";
    var_5.horzalign = "left";
    var_5.vertalign = "top";
    var_5.fontscale = 1.3;
    var_5.sort = 100;
    var_5 settext( "v0.0.49h34 hijack: waiting for players" );
    var_0 = 0;
    var_3 = 0;

    for ( ;; )
    {
        wait 0.25;

        if ( !isdefined( level.player2 ) || !isdefined( level.player ) )
            continue;

        var_1 = distance2d( level.player.origin, level.player2.origin );
        var_2 = abs( level.player.origin[2] - level.player2.origin[2] );
        var_5 settext( "v0.0.49h34 hijack: P1 " + level.player getstance() + " | P2 " + level.player2 getstance() + " | dist " + int( var_1 ) + " dz " + int( var_2 ) + " moves " + var_3 + " zerog " + isdefined( level.zerog_player_rig ) );

        if ( !coop_flag( "introscreen_done" ) || isdefined( level.zerog_player_rig ) )
            continue;

        if ( var_0 > 0 )
        {
            var_0--;
            continue;
        }

        if ( var_1 > 700 || var_2 > 300 )
        {
            coop_p2_place();
            var_3++;
            var_0 = 8;
        }
    }
}

coop_cp_menu()
{
    var_0 = 0;

    while ( !isdefined( level.player ) && var_0 < 480 )
    {
        wait 0.25;
        var_0++;
    }

    wait 4;
    var_1 = [];
    var_1[0] = "kp_end";
    var_1[1] = "kp_downarrow";
    var_1[2] = "kp_pgdn";
    var_1[3] = "kp_leftarrow";
    var_1[4] = "kp_5";
    var_1[5] = "kp_rightarrow";
    var_1[6] = "kp_home";
    var_1[7] = "kp_uparrow";
    var_1[8] = "kp_pgup";
    var_2 = 0;
    var_3 = 0;
    var_4 = [];

    for ( ;; )
    {
        wait 0.05;

        if ( !isdefined( level.start_functions ) )
            continue;

        if ( level.player buttonpressed( "kp_ins" ) || level.player buttonpressed( "F9" ) )
        {
            if ( !var_3 )
            {
                var_3 = 1;

                if ( var_2 )
                {
                    var_2 = 0;

                    for ( var_5 = 0; var_5 < var_4.size; var_5++ )
                        var_4[var_5] destroy();

                    var_4 = [];
                }
                else
                {
                    var_6 = [];

                    for ( var_5 = 0; var_5 < level.start_functions.size; var_5++ )
                    {
                        var_7 = level.start_functions[var_5]["name"];

                        if ( issubstr( var_7, "no_game" ) )
                            continue;

                        var_6[var_6.size] = var_7;
                    }

                    level.coop_cp_names = var_6;

                    if ( var_6.size > 0 )
                    {
                        var_2 = 1;
                        var_8 = newhudelem();
                        var_8.x = 80;
                        var_8.y = 300;
                        var_8.alignx = "left";
                        var_8.aligny = "middle";
                        var_8.fontscale = 1.3;
                        var_8.sort = 1000;
                        var_8 settext( "v0.0.49h34 checkpoints: press 1-9 (number row or numpad), F9 closes" );
                        var_4[var_4.size] = var_8;

                        for ( var_5 = 0; var_5 < var_6.size && var_5 < 9; var_5++ )
                        {
                            var_8 = newhudelem();
                            var_8.x = 80;
                            var_8.y = 320 + var_5 * 16;
                            var_8.alignx = "left";
                            var_8.aligny = "middle";
                            var_8.fontscale = 1.3;
                            var_8.sort = 1000;
                            var_8 settext( ( var_5 + 1 ) + "  " + var_6[var_5] );
                            var_4[var_4.size] = var_8;
                        }
                    }
                }
            }
        }
        else
            var_3 = 0;

        if ( !var_2 )
            continue;

        for ( var_5 = 0; var_5 < 9; var_5++ )
        {
            if ( var_5 >= level.coop_cp_names.size )
                continue;

            if ( level.player buttonpressed( var_1[var_5] ) || level.player buttonpressed( "" + ( var_5 + 1 ) ) )
            {
                setdvar( "start", level.coop_cp_names[var_5] );
                level.player openpopupmenu( "start" );
                wait 1;
                map_restart( 0 );
                return;
            }
        }
    }
}
