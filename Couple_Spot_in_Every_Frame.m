function [ Couple_Spot_in_Every_Frame ] = Couple_Spot_in_Every_Frame(angle_threshold_max,angle_threshold_min,distance_x_threshold_max,distance_x_threshold_min,distance_y_threshold_max,distance_y_threshold_min)
% Filename            :       spot_group.m
% Date                :       2018-09-19
% Description         :       Find two correlated spots through specific strong
% correlation condition with a certain threshold. The output results are
% arranged by frame to frame for later calulation.
% Input:angle_threshold_max，angle_threshold_min,distance_x_threshold_max,distance_x_threshold_min,distance_y_threshold_max,distance_y_threshold_min
% Output:Couple_Spot_in_Every_Frame
%% data path
m_path = mfilename('fullpath');
slash_num = strfind(m_path,'\');
file_path = m_path(1:slash_num(end-1));
input_path = strcat(file_path,'input');
output_path = strcat(file_path,'output');
% make file for output path
if (exist(output_path,'dir')==0)%如果文件夹不存在
    mkdir(output_path);
end
output_path = strcat(file_path,'output\');
%% read Particle trajectories Data
[filename,pathname]=uigetfile({'*.*','All Files(*.*)'},'Select Spots in tracks statistics',...
                          input_path);
raw_data=importdata(strcat(pathname,filename));
%% init
data = raw_data.data;
SPOT_ID = raw_data.data(:,1);
X = raw_data.data(:,4);
Y = -raw_data.data(:,5);
FRAME = raw_data.data(:,8);
TRACK_ID = raw_data.data(:,2);
MEAN_INTENSITY = raw_data.data(:,12);
TOTAL_INTENSITY = raw_data.data(:,16);
[M,~] = size(SPOT_ID);
%% Calculate
tic
Couple_Spot_in_Every_Frame = zeros(); 
s = 1;
total_frame_number =max(FRAME);
for i = 0 : total_frame_number     %0-999帧循环
    [U,~] = find(FRAME == i);
    [u,~] = size(U);
    for j = 1 : u                  %每帧内所有粒子两两对比
        source_column_number = U(j);
        xs = X(source_column_number);
        ys = Y(source_column_number);
        for k = j+1 : u
            destination_column_number = U(k);
            xd = X(destination_column_number);
            yd = Y(destination_column_number); 
            angle = (yd-ys)/(xd-xs);
            distance_x = abs(xd-xs);
            distance_y = abs(yd-ys);
            if (distance_x>=distance_x_threshold_max)
                continue;
            end
            if (distance_x<=distance_x_threshold_min)
                continue;
            end
            if (distance_y>=distance_y_threshold_max)
                continue;
            end
            if (distance_y<=distance_y_threshold_min)
                continue;
            end
            if (angle<=angle_threshold_min)
                continue;
            end
            if (angle>=angle_threshold_max)
                continue;
            end
                if(xs<xd)
                    Couple_Spot_in_Every_Frame(s,1:8) = [SPOT_ID(source_column_number),FRAME(source_column_number),X(source_column_number),-Y(source_column_number),MEAN_INTENSITY(source_column_number),TOTAL_INTENSITY(source_column_number),TRACK_ID(source_column_number),-1];
                    Couple_Spot_in_Every_Frame(s,9:16) = [SPOT_ID(destination_column_number),FRAME(destination_column_number),X(destination_column_number),-Y(destination_column_number),MEAN_INTENSITY(destination_column_number),TOTAL_INTENSITY(destination_column_number),TRACK_ID(destination_column_number),-1];
                else
                    Couple_Spot_in_Every_Frame(s,1:8) = [SPOT_ID(destination_column_number),FRAME(destination_column_number),X(destination_column_number),-Y(destination_column_number),MEAN_INTENSITY(destination_column_number),TOTAL_INTENSITY(destination_column_number),TRACK_ID(destination_column_number),-1];
                    Couple_Spot_in_Every_Frame(s,9:16) = [SPOT_ID(source_column_number),FRAME(source_column_number),X(source_column_number),-Y(source_column_number),MEAN_INTENSITY(source_column_number),TOTAL_INTENSITY(source_column_number),TRACK_ID(source_column_number),-1];
                end
               s = s + 1;
        end
   end
         
end
% r = 1.5;
% [p,q] = size(group);
% for i = 1 : p
% rectangle('Position',[group(i,3) - r,-group(i,4) - r,2*r,2*r],'Curvature',[1,1]),axis equal
% % hold on
% end
% [m,n] = size(group);
name1 = [{'UPPER_SPOT_ID'},{'FRAME'},{'X'},{'Y'},{'MEAN_INTENSITY'},{'TOTAL_INTENSITY'},{'TRACK_ID'},{'PARTICLE_ID'}];
name2 = [{'LOWER_SPOT_ID'},{'FRAME'},{'X'},{'Y'},{'MEAN_INTENSITY'},{'TOTAL_INTENSITY'},{'TRACK_ID'},{'PARTICLE_ID'}];
xlswrite(strcat(output_path,'Couple_Spot_in_Every_Frame.xlsx'),name1,1,'A1');
xlswrite(strcat(output_path,'Couple_Spot_in_Every_Frame.xlsx'),name2,1,'I1');
xlswrite(strcat(output_path,'Couple_Spot_in_Every_Frame.xlsx'),Couple_Spot_in_Every_Frame,1,'A2');
toc

end

