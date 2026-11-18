// Our co-op functions for 969 (decoded gsc-tool names). Added to your own decompiled copy of the level script.

coop_precache()
{
    coop_defaults();
    var_0 = [ "coop_body1", "coop_head1", "coop_hands1", "coop_body2", "coop_head2", "coop_hands2" ];

    foreach ( var_1 in var_0 )
    {
        if ( coop_get( var_1 ) != "" )
            precachemodel( coop_get( var_1 ) );
    }

    precachemodel( "head_delta_elite_a" );
    precachemodel( "head_delta_elite_b" );
    precachemodel( "head_delta_elite_c" );
    precachemodel( "head_delta_elite_d" );
}

coop_models()
{
    level waittill( "loadout complete" );
    coop_set( "coop_diag", "3_loadout_done" );
    wait 0.5;
    coop_status( "COOP MODELS BT v32: script running | player2=" + isdefined( level.player2 ) );
    wait 2;
    coop_status( "p2=" + isdefined( level.player2 ) + " hands1=[" + coop_get( "coop_hands1" ) + "] body1=[" + coop_get( "coop_body1" ) + "] head1=[" + coop_get( "coop_head1" ) + "] anim=[" + coop_get( "coop_anim" ) + "] preview=[" + coop_get( "coop_preview" ) + "]" );
    coop_preview();
    coop_apply();
    coop_set( "coop_diag", "4_applied_once_player2=" + isdefined( level.player2 ) );
    wait 3;
    coop_apply();
    wait 5;
    coop_apply();
    coop_set( "coop_diag", "5_applied_three_times_player2=" + isdefined( level.player2 ) );

    if ( !isdefined( level.lvl_visionset ) || level.lvl_visionset == "" )
        level.lvl_visionset = "ny_manhattan";

    level.coop_incap_weapon = "deserteagle";
    precacheitem( "deserteagle" );
    thread coop_stance_hud();

    foreach ( var_9 in level.players )
        var_9 thread coop_vision_guard();

    coop_status( "applied 3 times | p2=" + isdefined( level.player2 ) + " | " + coop_get( "coop_diag2" ) + " | " + coop_get( "coop_diag3" ) );
    wait 90;
    level.coop_hud destroy();
}

coop_status( var_0 )
{
    if ( !isdefined( level.coop_hud ) )
    {
        level.coop_hud = newhudelem();
        level.coop_hud.x = 20;
        level.coop_hud.y = 70;
        level.coop_hud.alignx = "left";
        level.coop_hud.aligny = "top";
        level.coop_hud.horzalign = "left";
        level.coop_hud.vertalign = "top";
        level.coop_hud.fontscale = 1.3;
        level.coop_hud.sort = 100;
        level.coop_hud.alpha = 1;
    }

    level.coop_hud settext( var_0 );
}

coop_apply()
{
    if ( coop_get( "coop_hands1" ) != "" )
        level.player setviewmodel( coop_get( "coop_hands1" ) );

    if ( coop_get( "coop_body1" ) != "" )
    {
        level.player maps\_utility::setmodelfunc( ::coop_body1 );

        if ( coop_get( "coop_anim" ) == "1" )
            level.player setanim( %code, 1, 0 );
    }

    if ( !isdefined( level.player2 ) )
        return;

    if ( coop_get( "coop_hands2" ) != "" )
        level.player2 setviewmodel( coop_get( "coop_hands2" ) );

    if ( coop_get( "coop_body2" ) != "" )
    {
        level.player2 maps\_utility::setmodelfunc( ::coop_body2 );

        if ( coop_get( "coop_anim" ) == "1" )
            level.player2 setanim( %code, 1, 0 );
    }

    coop_set( "coop_diag3", "apply ran, coop_anim=" + coop_get( "coop_anim" ) + ", player2=" + isdefined( level.player2 ) );
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

coop_stance_hud()
{
    var_0 = newhudelem();
    var_0.x = 20;
    var_0.y = 95;
    var_0.alignx = "left";
    var_0.aligny = "top";
    var_0.horzalign = "left";
    var_0.vertalign = "top";
    var_0.fontscale = 1.3;
    var_0.sort = 100;

    for ( ;; )
    {
        if ( isdefined( level.player2 ) )
        {
            var_1 = "-";
            var_2 = "-";

            if ( isdefined( level.player.laststand ) )
                var_1 = level.player.laststand;

            if ( isdefined( level.player2.laststand ) )
                var_2 = level.player2.laststand;

            var_0 settext( "v0.0.49h34 P1 " + level.player getstance() + " spd " + int( length( level.player getvelocity() ) ) + " gnd " + level.player isonground() + " dn " + var_1 + " " + level.player getcurrentweapon() + " | P2 " + level.player2 getstance() + " spd " + int( length( level.player2 getvelocity() ) ) + " gnd " + level.player2 isonground() + " dn " + var_2 + " " + level.player2 getcurrentweapon() );
        }

        wait 0.25;
    }
}

coop_vision_guard()
{
    for ( ;; )
    {
        self waittill( "exiting_uav_control" );
        wait 1.3;
        self visionsetnakedforplayer( level.lvl_visionset, 0.5 );
        wait 1.2;
        self visionsetnakedforplayer( level.lvl_visionset, 0.5 );
    }
}

coop_head_lineup()
{
    var_0 = [ "head_delta_elite_a", "head_delta_elite_b", "head_delta_elite_c", "head_delta_elite_d" ];
    var_1 = [];
    var_2 = newhudelem();
    var_2.x = 20;
    var_2.y = 110;
    var_2.alignx = "left";
    var_2.aligny = "top";
    var_2.horzalign = "left";
    var_2.vertalign = "top";
    var_2.fontscale = 1.3;
    var_2.alpha = 1;
    var_2 settext( "HEAD TEST: A B C D left to right in front of player 1 (60s)" );

    for ( var_3 = 0; var_3 < 4; var_3++ )
    {
        var_1[var_3] = spawn( "script_model", level.player.origin );
        var_1[var_3] setmodel( "coop_body_delta_aa" );
        var_1[var_3] attach( var_0[var_3], "", 1 );
    }

    for ( var_4 = 0; var_4 < 600; var_4++ )
    {
        var_5 = level.player getplayerangles();
        var_6 = anglestoforward( ( 0, var_5[1], 0 ) );
        var_7 = anglestoright( ( 0, var_5[1], 0 ) );

        for ( var_3 = 0; var_3 < 4; var_3++ )
        {
            var_1[var_3].origin = level.player.origin + var_6 * 130 + var_7 * ( ( var_3 - 1.5 ) * 45 );
            var_1[var_3].angles = ( 0, var_5[1] + 180, 0 );
        }

        wait 0.1;
    }

    for ( var_3 = 0; var_3 < 4; var_3++ )
        var_1[var_3] delete();

    var_2 destroy();
}

coop_preview()
{
    if ( isdefined( level.player2 ) )
        return;

    coop_set( "coop_diag2", "preview: not requested (coop_preview=" + coop_get( "coop_preview" ) + ")" );

    if ( coop_get( "coop_preview" ) != "1" )
        return;

    coop_set( "coop_diag2", "preview: requested, body1=[" + coop_get( "coop_body1" ) + "]" );
    thread coop_preview_one( coop_get( "coop_body1" ), coop_get( "coop_head1" ), 0 );

    if ( coop_get( "coop_body2" ) != "" )
        thread coop_preview_one( coop_get( "coop_body2" ), coop_get( "coop_head2" ), 1 );
}

coop_preview_one( var_0, var_1, var_2 )
{
    if ( var_0 == "" )
        return;

    var_3 = spawn( "script_model", level.player.origin );
    var_3 setmodel( var_0 );

    if ( var_1 != "" )
        var_3 attach( var_1, "", 1 );

    coop_set( "coop_diag2", "preview: model spawned (" + var_0 + ") and following player 1" );

    for ( ;; )
    {
        var_4 = level.player getplayerangles();
        var_5 = anglestoforward( ( 0, var_4[1], 0 ) );
        var_6 = anglestoright( ( 0, var_4[1], 0 ) );
        var_3.origin = level.player.origin + var_5 * 90 + var_6 * ( var_2 * 50 - 25 );
        var_3.angles = ( 0, var_4[1] + 180, 0 );
        wait 0.1;
    }
}

coop_defaults()
{
    level.coop_cfg = [];
    level.coop_cfg["coop_diag"] = "";
    level.coop_cfg["coop_diag2"] = "";
    level.coop_cfg["coop_diag3"] = "";
    coop_default( "coop_hv_x", 0 );
    coop_default( "coop_hv_y", -34 );
    coop_default( "coop_hv_z", 0 );
    coop_default( "coop_body1", "coop_body_delta_aa" );
    coop_default( "coop_head1", "head_delta_elite_a" );
    coop_default( "coop_hands1", "" );
    coop_default( "coop_body2", "coop_body_us_army" );
    coop_default( "coop_head2", "coop_head_us_army" );
    coop_default( "coop_hands2", "" );
    coop_default( "coop_anim", "1" );
    coop_default( "coop_preview", "1" );
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

coop_set( var_0, var_1 )
{
    if ( !isdefined( level.coop_cfg ) )
        level.coop_cfg = [];

    level.coop_cfg[var_0] = var_1;
    setdvar( var_0, var_1 );
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
