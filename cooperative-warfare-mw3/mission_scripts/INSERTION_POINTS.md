# Insertion points (calls into our co-op functions inside the game's own functions)

969: in main(): coop_precache();
969: in main(): thread coop_models();
code_intro: in humvee_intro(): thread coop_humvee_p2( var_0 );
code_intro: in humvee_intro(): thread coop_hv_p2_vis( 1 );
code_intro: in humvee_intro(): thread coop_hv_p2_play();
code_intro: in humvee_intro(): thread coop_hv_p2_vis( 0 );
hijack: in main(): coop_precache();
hijack: in main(): thread coop_models();
hijack: in main(): thread coop_p2_setup();
hijack: in main(): thread coop_keep_together();
innocent: in main(): coop_precache();
innocent: in main(): thread coop_models();
innocent: in main(): thread coop_p2_setup();
innocent: in main(): thread coop_keep_together();
intro: in main(): coop_precache();
intro: in main(): thread coop_models();
intro: in intro_transition(): thread coop_follow_rig();
london: in main(): coop_precache();
london: in main(): thread coop_models();
london: in main(): thread coop_keep_together();
