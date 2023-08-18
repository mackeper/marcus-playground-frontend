module Pages.Games.CS.Autoexec exposing (getConfig)


getConfig : String
getConfig =
    """<pre>// Visual
fps_max "400";

hud_showtargetid "1";
viewmodel_presetpos "1";
cl_righthand "1";
mat_monitorgamma "2.200000";
mat_monitorgamma_tv_enabled "0";

// Radar
cl_drawhud_force_radar "0";
cl_radar_scale "0.4";
cl_radar_rotate "0";
cl_radar_always_centered "0";
cl_radar_icon_scale_min "0.8";

// Mouse
m_rawinput "1";
sensitivity "0.9";
zoom_sensitivity_ratio_mouse "0.82";

// Crosshair
cl_crosshair_drawoutline "1";
cl_crosshair_outlinethickness "0.1";
cl_crosshairthickness "0";
cl_crosshairdot "0";
cl_crosshairgap "0";
cl_crosshairgap_useweaponvalue "0";
cl_crosshairsize "1.2";
cl_crosshairstyle "4";
cl_crosshairusealpha "1";
cl_crosshairalpha "255";
cl_crosshaircolor "1";

// Sound
snd_deathcamera_volume "0.0";
snd_mapobjective_volume "0.0";
snd_menumusic_volume "0.0";
snd_mute_losefocus "0";
snd_roundend_volume "0";
snd_roundstart_volume "0";
snd_tensecondwarning_volume "0.3";

// Gameplay
cl_autowepswitch "0";
r_drawtracers_firstperson "1";
gameinstructor_enable "0";
cl_autohelp "0";
cl_showhelp "0";

// Bindings
bind "f" "use weapon_knife;use weapon_flashbang";
bind "c" "use weapon_knife;use weapon_smokegrenade";
bind "x" "use weapon_knife;use weapon_molotov;use weapon_incgrenade";
bind "z" "player_ping";
bind "MWHEELDOWN" "+jump";
bind "n" "-attack";
bind "Backspace" "+jump;-attack;";
bindtoggle "MWHEELUP" "cl_righthand";
bind "v" "+voicerecord";
bind "MOUSE5" "r_cleardecals";
bind "[" toggleconsole;
bind "q" "+lookatweapon;r_cleardecals";
</pre>"""
