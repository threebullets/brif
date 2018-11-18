function [max_angle_tan,min_angle_tan,max_x,min_x,max_y,min_y ] = get_threshold( )
% Filename            :       get_threshold.m
% Date                :       2018-09-19
% Description         :       Calculate displacement,angle and velocity.
%% data path
m_path = mfilename('fullpath');
slash_num = strfind(m_path,'\');
file_path = m_path(1:slash_num(end-1));
input_path = strcat(file_path,'input');
output_path = strcat(file_path,'output');
% make file for output path
if (exist(output_path,'dir')==0)
    mkdir(output_path);
end
output_path = strcat(file_path,'output\');
%% read Particle trajectories Data
[filename,pathname]=uigetfile({'*.*','All Files(*.*)'},'Select reference image',...
                          input_path);
raw_data=importdata(strcat(pathname,filename));
%% init
angle = raw_data.data(:,10);
length = raw_data.data(:,13);
%% Calculate
angle_tan = tand(angle);                               % imageJ?????????????tand()????tan??tan()????tan?
max_angle_tan = max(angle_tan);                        % ???????tan?
min_angle_tan = min(angle_tan);                        % ???????tan?

% max_angle = max(angle);
% min_angle = min(angle);
% max_length = max(length);
% min_length = min(length);
% max_x = max_length * cosd(max_angle);
% min_x = min_length * cosd(min_angle);
% max_y = abs(max_length * sind(min_angle));
% min_y = abs(min_length * sind(max_angle));

x = length .* cosd(angle);                            %x???? = ?? * cos????
max_x = max(x);                                       %?????x?
min_x = min(x);                                       %?????x?
y = length .* sind(angle);                            %x???? = ?? * cos????
max_y = max(abs(y));                                  %?????y?
min_y = min(abs(y));                                  %?????y?
