// Our co-op functions for intro (decoded gsc-tool names). Added to your own decompiled copy of the level script.

coop_precache()
{
    coop_defaults();
    coop_set( "coop_diag", "1_precache_ran_v15" );
    precachemodel( "viewhands_yuri" );
    precachemodel( "viewhands_sas" );
    precachemodel( "viewhands_player_sas" );
    var_0 = [ "coop_body1", "coop_head1", "coop_hands1", "coop_body2", "coop_head2", "coop_hands2" ];

    foreach ( var_1 in var_0 )
    {
        if ( coop_get( var_1 ) != "" )
            precachemodel( coop_get( var_1 ) );
    }

    precacheitem( "deserteagle" );
    precachemodel( "head_russian_military_d_black" );
    precachemodel( "head_russian_military_dd_black" );
    precachemodel( "head_russian_military_e_black" );
    precachemodel( "head_russian_military_f_black" );
}

coop_models()
{
    coop_set( "coop_diag", "2_waiting_for_loadout" );
    level waittill( "loadout complete" );
    coop_set( "coop_diag", "3_loadout_done" );
    wait 0.5;
    coop_status( "COOP MODELS PNG v32: script running | player2=" + isdefined( level.player2 ) );
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
    var_0 = coop_get( "coop_hands1" );

    if ( var_0 == "" )
        var_0 = "viewhands_yuri";

    level.player setviewmodel( var_0 );

    if ( coop_get( "coop_body1" ) != "" )
    {
        level.player maps\_utility::setmodelfunc( ::coop_body1 );

        if ( coop_get( "coop_anim" ) == "1" )
            level.player setanim( %code, 1, 0 );
    }

    if ( !isdefined( level.player2 ) )
        return;

    var_0 = coop_get( "coop_hands2" );

    if ( var_0 == "" )
        var_0 = "viewhands_yuri";

    level.player2 setviewmodel( var_0 );

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

coop_head_lineup()
{
    common_scripts\utility::flag_wait( "intro_room_heli_crash_complete" );
    var_0 = [ "head_russian_military_d_black", "head_russian_military_dd_black", "head_russian_military_e_black", "head_russian_military_f_black" ];
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
    var_2 settext( "HEAD TEST: A B C D left to right (60s)" );

    for ( var_3 = 0; var_3 < 4; var_3++ )
    {
        var_1[var_3] = spawn( "script_model", level.player.origin );
        var_1[var_3] setmodel( "coop_body_loyalist_d" );
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
    coop_default( "coop_body1", "coop_body_loyalist_d" );
    coop_default( "coop_head1", "head_sp_loyalist_tom_hat_body_d" );
    coop_default( "coop_hands1", "" );
    coop_default( "coop_body2", "coop_body_loyalist_d" );
    coop_default( "coop_head2", "head_russian_military_d_black" );
    coop_default( "coop_hands2", "viewhands_sas" );
    coop_default( "coop_cuthands2", "viewhands_player_sas" );
    coop_default( "coop_anim", "1" );
    level.coop_incap_weapon = "deserteagle";
    thread coop_stance_hud();
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

coop_follow_rig()
{
    var_0 = 0;

    while ( var_0 < 600 )
    {
        if ( isdefined( level.player2 ) && isdefined( level.player_rig ) )
            break;

        wait 0.1;
        var_0++;
    }

    if ( !isdefined( level.player2 ) || !isdefined( level.player_rig ) )
    {
        coop_status( "follow: no player2/rig" );
        return;
    }

    common_scripts\utility::flag_wait( "intro_dialog_shot_7" );
    level.player2 disableweapons();
    level.player2 disableoffhandweapons();
    var_5 = coop_get( "coop_cuthands2" );

    if ( var_5 == "" )
        var_5 = "viewhands_player_sas";

    var_6 = common_scripts\utility::getstruct( "anim_intro_room_before", "targetname" );
    var_7 = common_scripts\utility::getstruct( "anim_intro_room", "targetname" );
    var_8 = spawn( "script_origin", var_6.origin );
    var_8.angles = var_6.angles;
    var_9 = maps\_utility::spawn_anim_model( "player_rig", var_6.origin );
    var_9 setmodel( var_5 );
    var_12 = -30;
    var_13 = -72;
    var_14 = 16;
    var_15 = level.player_rig gettagorigin( "tag_player" );
    var_16 = [];
    var_16[0] = ( -34, -6, 0 );
    var_16[1] = ( 34, -6, 0 );
    var_16[2] = ( -34, -34, 0 );
    var_16[3] = ( 34, -34, 0 );
    var_16[4] = ( -30, -72, 0 );
    var_16[5] = ( 30, -72, 0 );
    var_17 = -1;

    for ( var_18 = 0; var_18 < var_16.size; var_18++ )
    {
        var_19 = anglestoright( var_6.angles ) * var_16[var_18][0] + anglestoforward( var_6.angles ) * var_16[var_18][1];
        var_20 = var_15 + var_19;
        var_21 = bullettracepassed( var_15, var_20, 0, undefined );
        var_22 = bullettracepassed( var_20, var_20 + anglestoright( var_6.angles ) * 28, 0, undefined ) && bullettracepassed( var_20, var_20 - anglestoright( var_6.angles ) * 28, 0, undefined ) && bullettracepassed( var_20, var_20 + anglestoforward( var_6.angles ) * 28, 0, undefined ) && bullettracepassed( var_20, var_20 - anglestoforward( var_6.angles ) * 28, 0, undefined );

        if ( var_21 && var_22 )
        {
            var_17 = var_18;
            break;
        }
    }

    if ( var_17 < 0 )
        var_17 = 4;

    var_12 = var_16[var_17][0];
    var_13 = var_16[var_17][1];
    var_10 = anglestoright( var_6.angles ) * var_12 + anglestoforward( var_6.angles ) * var_13;
    var_8.origin = var_6.origin + var_10 + ( 0, 0, var_14 );
    level.coop_rig2 = var_9;
    level.coop_cam2 = common_scripts\utility::spawn_tag_origin();
    level.coop_cam2.origin = var_9 gettagorigin( "tag_player" );
    level.coop_cam2.angles = var_9 gettagangles( "tag_player" );
    level.coop_cam2 linkto( var_9, "tag_player", ( 0, 0, 0 ), ( 14, 0, 0 ) );
    level.player2 playerlinktodelta( level.coop_cam2, "tag_origin", 1, 10, 10, 5, 0 );
    var_8 thread maps\_anim::anim_single_solo( var_9, "intro_opening_shot07" );
    coop_status( "follow: p2 rig " + var_5 + " seat " + var_17 + " cam pitch 14 base +16" );
    thread coop_brace_shake( level.player );
    thread coop_rig2_shot8( var_7, var_9 );

    while ( !common_scripts\utility::flag( "intro_room_heli_crash_complete" ) )
    {
        level.player2 setdepthoffield( 0, 0, 7000, 10000, 0, 0 );
        wait 0.05;
    }

    level.player2 unlink();
    level.coop_cam2 delete();
    var_9 delete();
    var_8 delete();
    level.player2 setorigin( level.player.origin - anglestoforward( ( 0, level.player.angles[1], 0 ) ) * 24 + anglestoright( ( 0, level.player.angles[1], 0 ) ) * -40 + ( 0, 0, 4 ) );
    level.player2 setplayerangles( ( 0, level.player.angles[1], 0 ) );
    level.player2 enableweapons();
    level.player2 enableoffhandweapons();
    coop_status( "follow: released" );
}

coop_rig2_shot8( var_0, var_1 )
{
    common_scripts\utility::flag_wait( "intro_dialog_shot_8" );

    if ( !isdefined( var_1 ) )
        return;

    var_2 = level.player_rig gettagorigin( "tag_player" );
    var_3 = [];
    var_3[0] = ( -26, -72, 0 );
    var_3[1] = ( 26, -72, 0 );
    var_3[2] = ( -48, 0, 0 );
    var_3[3] = ( 48, 0, 0 );
    var_3[4] = ( -30, -40, 0 );
    var_3[5] = ( 30, -40, 0 );
    var_3[6] = ( 0, -50, 0 );
    var_3[7] = ( -26, 72, 0 );
    var_3[8] = ( 26, 72, 0 );
    var_3[9] = ( 0, 50, 0 );
    var_4 = -1;

    for ( var_5 = 0; var_5 < var_3.size; var_5++ )
    {
        var_6 = anglestoright( var_0.angles ) * var_3[var_5][0] + anglestoforward( var_0.angles ) * var_3[var_5][1];
        var_7 = var_2 + var_6;
        var_8 = bullettracepassed( var_2, var_7, 0, undefined );
        var_9 = bullettracepassed( var_7, var_7 + ( 0, 0, 40 ), 0, undefined );
        var_10 = bullettrace( var_7, var_7 - ( 0, 0, 90 ), 0, undefined );

        if ( var_8 && var_9 && var_10["fraction"] < 1 )
        {
            var_4 = var_5;
            break;
        }
    }

    if ( var_4 < 0 )
        var_4 = 0;

    var_11 = anglestoright( var_0.angles ) * var_3[var_4][0] + anglestoforward( var_0.angles ) * var_3[var_4][1];
    var_12 = spawn( "script_origin", var_0.origin + var_11 + ( 0, 0, 16 ) );
    var_12.angles = var_0.angles;
    var_12 thread maps\_anim::anim_single_solo( var_1, "intro_opening_shot08" );
    coop_status( "follow: shot8 shift choice " + var_4 + " of " + var_3.size );
}

coop_brace_shake( var_0 )
{
    common_scripts\utility::flag_wait( "intro_dialog_shot_8" );
    earthquake( 0.3, 3, var_0.origin, 800 );
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
