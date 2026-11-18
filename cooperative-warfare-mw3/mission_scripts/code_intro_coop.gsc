// Our co-op functions for code_intro (decoded gsc-tool names). Added to your own decompiled copy of the level script.

coop_hv_cfg( var_0, var_1 )
{
    if ( isdefined( level.coop_cfg ) && isdefined( level.coop_cfg[var_0] ) )
        return level.coop_cfg[var_0];

    return var_1;
}

coop_humvee_p2( var_0 )
{
    var_1 = newhudelem();
    var_1.x = 20;
    var_1.y = 170;
    var_1.alignx = "left";
    var_1.aligny = "top";
    var_1.horzalign = "left";
    var_1.vertalign = "top";
    var_1.fontscale = 1.3;
    var_1.sort = 100;
    var_1 settext( "v0.0.49h34 humvee: waiting for P2" );
    var_2 = 0;

    while ( !isdefined( level.player2 ) && var_2 < 200 )
    {
        wait 0.05;
        var_2++;
    }

    if ( !isdefined( level.player2 ) )
    {
        var_1 settext( "v0.0.49h34 humvee: no P2, skipped" );
        return;
    }

    var_3 = getent( "intro_humvee", "targetname" );
    var_4 = level.player_arms gettagorigin( "tag_player" );
    var_5 = ( 0, 0, 0 );

    if ( isdefined( var_3 ) )
    {
        var_6 = anglestoright( ( 0, var_0.angles[1], 0 ) );
        var_7 = vectordot( var_4 - var_0.origin, var_6 );

        if ( var_7 < 0 )
            var_5 = var_6 * 36;
        else
            var_5 = var_6 * -36;
    }
    else
        var_5 = anglestoright( level.player_arms.angles ) * 26;

    var_5 = ( var_5[0], var_5[1], 0 );
    level.coop_p2_node = spawn( "script_origin", var_0.origin + var_5 );
    level.coop_p2_node.angles = var_0.angles;
    level.coop_p2_arms = maps\_utility::spawn_anim_model( "player_rig" );
    level.coop_p2_arms.origin = level.coop_p2_node.origin;
    level.coop_p2_arms.angles = level.coop_p2_node.angles;
    level.coop_p2_arms hide();
    level.coop_p2_node maps\_anim::anim_first_frame_solo( level.coop_p2_arms, "ny_intro" );
    level.player2 freezecontrols( 1 );
    level.player2 disableweapons();
    level.player2 playerlinktoblend( level.coop_p2_arms, "tag_player", 0.5 );
    var_1 settext( "v0.0.49h34 humvee: P2 own rig, fixed side, shift " + int( var_5[0] ) + "/" + int( var_5[1] ) );
    level waittill( "coop_humvee_done" );
    wait 0.5;
    level.player2 unlink();

    if ( isdefined( level.coop_p2_arms ) )
        level.coop_p2_arms delete();

    if ( isdefined( level.coop_p2_node ) )
        level.coop_p2_node delete();

    thread coop_hv_release( var_1 );
}

coop_hv_p2_play()
{
    if ( !isdefined( level.coop_p2_arms ) || !isdefined( level.coop_p2_node ) )
        return;

    level.coop_p2_node thread maps\_anim::anim_single_solo( level.coop_p2_arms, "ny_intro" );
}

coop_hv_p2_vis( var_0 )
{
    if ( !isdefined( level.coop_p2_arms ) || !isdefined( level.player2 ) )
        return;

    if ( var_0 )
    {
        level.coop_p2_arms show();
    }
    else
        level.coop_p2_arms hide();
}

coop_hv_release( var_0 )
{
    var_1 = level.player.angles[1];
    var_2 = anglestoright( ( 0, var_1, 0 ) );
    var_3 = anglestoforward( ( 0, var_1, 0 ) );
    var_4 = [];
    var_4[0] = var_2 * -44;
    var_4[1] = var_2 * 44;
    var_4[2] = var_3 * -60;
    var_4[3] = var_2 * -70 + var_3 * -30;
    var_4[4] = var_2 * 70 + var_3 * -30;
    var_4[5] = var_3 * 60;
    var_5 = 0;

    for ( var_6 = 0; var_6 < 8; var_6++ )
    {
        var_7 = level.player.origin + ( 0, 0, 24 );
        var_8 = level.player.origin + var_4[var_5 % 6] + ( 0, 0, 24 );
        var_9 = bullettrace( var_7, var_8, 0, undefined )["position"];

        if ( distance( var_9, var_8 ) > 3 )
        {
            var_5++;
            continue;
        }

        var_10 = bullettrace( var_8, var_8 - ( 0, 0, 80 ), 0, undefined )["position"];
        level.player2 setorigin( var_10 + ( 0, 0, 2 ) );
        level.player2 setplayerangles( ( 0, var_1, 0 ) );
        wait 0.4;

        if ( level.player2 isonground() && distance2d( level.player.origin, level.player2.origin ) < 130 )
            break;

        var_5++;
    }

    if ( distance2d( level.player.origin, level.player2.origin ) > 130 )
    {
        level.player2 setorigin( level.player.origin + var_4[0] + ( 0, 0, 4 ) );
        level.player2 setplayerangles( ( 0, var_1, 0 ) );
    }

    level.player2 freezecontrols( 0 );
    level.player2 enableweapons();
    level.player2 enableoffhandweapons();
    var_0 settext( "v0.0.49h34 humvee: P2 released beside P1 (try " + var_6 + ")" );
    for ( var_11 = 0; var_11 < 60; var_11++ )
    {
        wait 0.3;

        if ( distance2d( level.player.origin, level.player2.origin ) > 110 )
        {
            var_12 = level.player.angles[1];
            level.player2 setorigin( level.player.origin + anglestoright( ( 0, var_12, 0 ) ) * -44 + ( 0, 0, 4 ) );
            level.player2 setplayerangles( ( 0, var_12, 0 ) );
        }
    }

    var_0 destroy();
}
