// Our co-op functions for london (decoded gsc-tool names). Added to your own decompiled copy of the level script.

coop_precache()
{
    coop_defaults();
    precachemodel( "viewhands_sas" );
    var_0 = [ "coop_body1", "coop_head1", "coop_body2", "coop_head2" ];

    foreach ( var_1 in var_0 )
    {
        if ( coop_get( var_1 ) != "" )
            precachemodel( coop_get( var_1 ) );
    }

    precacheitem( "fnfiveseven" );
}

coop_defaults()
{
    level.coop_cfg = [];
    coop_default( "coop_body1", "coop_body_us_army" );
    coop_default( "coop_head1", "head_sas_a" );
    coop_default( "coop_body2", "coop_body_sas_assault" );
    coop_default( "coop_head2", "head_sas_b" );
    coop_default( "coop_hands", "viewhands_sas" );
    coop_default( "coop_anim", "1" );
    level.coop_incap_weapon = "fnfiveseven";
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

coop_models()
{
    thread coop_stance_hud();
    thread coop_p2_vision();
    level waittill( "loadout complete" );
    wait 0.5;
    wait 2;
    coop_apply();
    wait 2;
    level.coop_tags_ok = 1;
    wait 1;
    coop_apply();
    wait 5;
    coop_apply();
}

coop_p2_place()
{
    var_0 = level.player.origin + anglestoright( ( 0, level.player.angles[1], 0 ) ) * -40;
    level.player2 setorigin( var_0 );
    level.player2 setplayerangles( level.player getplayerangles() );
}

coop_keep_together()
{
    level waittill( "loadout complete" );
    wait 3;
    var_0 = 0;

    for ( ;; )
    {
        wait 0.5;

        if ( !isdefined( level.player2 ) || !isdefined( level.player ) )
            continue;

        if ( var_0 > 0 )
        {
            var_0--;
            continue;
        }

        if ( !coop_flag( "uav_slamzoom_done" ) || coop_flag( "uav_hud_enabled" ) )
            continue;

        var_1 = distance2d( level.player.origin, level.player2.origin );
        var_2 = abs( level.player.origin[2] - level.player2.origin[2] );

        if ( var_1 > 700 || var_2 > 300 )
        {
            coop_p2_place();
            var_0 = 6;
        }
    }
}

coop_flag( var_0 )
{
    if ( !isdefined( level.flag ) )
        return 0;

    if ( !isdefined( level.flag[var_0] ) )
        return 0;

    return level.flag[var_0];
}

coop_p2_vision()
{
    for ( var_0 = 0; var_0 < 1200; var_0++ )
    {
        if ( isdefined( level.player2 ) && coop_flag( "uav_hud_enabled" ) )
        {
            level.player2 thermalvisionoff();
            level.player2 visionsetnakedforplayer( "london_docks", 0 );
        }

        if ( isdefined( level.player2 ) && coop_flag( "uav_slamzoom_done" ) )
        {
            wait 2;
            level.player2 thermalvisionoff();
            level.player2 visionsetnakedforplayer( "london_docks", 0.5 );
            return;
        }

        wait 0.25;
    }
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
    var_2 = newhudelem();
    var_2.x = 20;
    var_2.y = 120;
    var_2.alignx = "left";
    var_2.aligny = "top";
    var_2.horzalign = "left";
    var_2.vertalign = "top";
    var_2.fontscale = 1.3;
    var_2.sort = 100;
    var_3 = newhudelem();
    var_3.x = 20;
    var_3.y = 145;
    var_3.alignx = "left";
    var_3.aligny = "top";
    var_3.horzalign = "left";
    var_3.vertalign = "top";
    var_3.fontscale = 1.3;
    var_3.sort = 100;

    for ( ;; )
    {
        if ( isdefined( level.player2 ) && isdefined( level.coop_tags_ok ) )
            var_3 settext( "v0.0.49h34 tags rel feet (z/wrist-to-gun/head z) P1(US ARMY body) " + coop_tagtxt( level.player ) + " | P2(SAS body) " + coop_tagtxt( level.player2 ) );

        if ( isdefined( level.player2 ) )
            var_0 settext( "v0.0.49h34 P1 " + level.player getstance() + " spd " + int( length( level.player getvelocity() ) ) + " gnd " + level.player isonground() + " " + level.player getcurrentweapon() + " | P2 " + level.player2 getstance() + " spd " + int( length( level.player2 getvelocity() ) ) + " gnd " + level.player2 isonground() + " " + level.player2 getcurrentweapon() );

        var_2 settext( "flags: intro " + coop_flag( "introscreen_complete" ) + " uavhud " + coop_flag( "uav_hud_enabled" ) + " onplayer " + coop_flag( "uav_focusing_on_player" ) + " slam " + coop_flag( "uav_slamzoom" ) + " slamdone " + coop_flag( "uav_slamzoom_done" ) + " alley " + coop_flag( "alley_start" ) );
        wait 0.25;
    }
}

coop_tagtxt( var_0 )
{
    var_1 = var_0 gettagorigin( "tag_weapon_right" );
    var_2 = var_0 gettagorigin( "j_wrist_ri" );
    var_3 = var_0 gettagorigin( "j_head" );
    var_4 = var_0 gettagangles( "j_wrist_ri" );
    return int( var_1[2] - var_0.origin[2] ) + "/" + int( distance( var_1, var_2 ) ) + "/" + int( var_3[2] - var_0.origin[2] ) + " wep " + int( var_1[2] - var_2[2] ) + " wa " + int( var_4[0] ) + "/" + int( var_4[2] );
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
