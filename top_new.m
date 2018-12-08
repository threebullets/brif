clc
clear
%%
[max_angle_tan,min_angle_tan,max_x,min_x,max_y,min_y ] = get_threshold( );
%%
%Couple_Spot_in_Every_Frame = Couple_Spot_in_Every_Frame(max_angle_tan,min_angle_tan,max_x,min_x,max_y,min_y );
%%
[ temp_track_result ]...
    = Couple_Spot_Trj_new(max_angle_tan,min_angle_tan,max_x,min_x,max_y,min_y);
%%
step3 = data_cleaning(temp_track_result);

%%
% visualization( step3 );