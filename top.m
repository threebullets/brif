clc
clear
%%
[max_angle_tan,min_angle_tan,max_x,min_x,max_y,min_y ] = get_threshold( );
Couple_Spot_in_Every_Frame = Couple_Spot_in_Every_Frame(max_angle_tan,min_angle_tan,max_x,min_x,max_y,min_y );
%%
[ couple_trj_group,long_trj_group,long_trj_sequence,track_result ]...
    = Couple_Spot_Trj(max_angle_tan,min_angle_tan,max_x,min_x,max_y,min_y);
%%
data_cleaning(track_result);
