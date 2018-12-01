function [ couple_trj_group,long_trj_group,long_trj_sequence,track_result ] = Couple_Spot_Trj(angle_threshold_max,angle_threshold_min,distance_x_threshold_max,distance_x_threshold_min,distance_y_threshold_max,distance_y_threshold_min)
% Filename            :       long_trj_group_ts_1.m
% Date                :       2018-10-2
% Description         :       Calculate displacement,angle and velocity.
%% data path
m_path = mfilename('fullpath');
slash_num = strfind(m_path,'\');
file_path = m_path(1:slash_num(end-1));
input_path = strcat(file_path,'input');
global output_path;
output_path = strcat(file_path,'output');
% make file for output path
if (exist(output_path,'dir')==0)                          % 如果文件夹不存在
    mkdir(output_path);
end
output_path = strcat(file_path,'output\');
%% read Particle trajectories Data
[filename,pathname]=uigetfile({'*.*','All Files(*.*)'},'Select Spots in tracks statistics',...
                          input_path);
raw_data=importdata(strcat(pathname,filename));
%% init
LABEL = raw_data.textdata(1,2:end);
data = raw_data.data;
SPOT_ID = raw_data.data(:,1);
X = raw_data.data(:,4);
Y = -raw_data.data(:,5);
FRAME = raw_data.data(:,8);
FRAME1 = FRAME + 1;
MEAN_INTENSITY = raw_data.data(:,12);
TOTAL_INTENSITY = raw_data.data(:,16);
TRACK_ID_raw = raw_data.data(:,2);
TRACK_ID = raw_data.data(:,2)+1;
[M,N] = size(data);
%% couple_trj_group
tic
couple_trj_group = zeros();
global total_frame1_number
total_frame1_number =max(FRAME1);
total_frame_number =max(FRAME);
for i = 0 : total_frame_number                                    % ???????
    [U,~] = find(FRAME == i);                                     % ???i????spot?????????????U?
    [u,~] = size(U);
    for j = 1 : u                                                 % ?????i?????spot 
        source_column_number = U(j);                              % ???i???j?????????????????????????????source spot?,
        xs = X(source_column_number);                             % ?????x?
        ys = Y(source_column_number);                             % ?????y?
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
                track_ID_s = TRACK_ID(U(j));
                track_ID_d = TRACK_ID(U(k));
                [ps,qs] = find(couple_trj_group ==track_ID_s);
                [pd,qd] = find(couple_trj_group ==track_ID_d);
                if(isempty(ps)&&isempty(pd))
                    couple_trj_group(end+1,1) = track_ID_s;
                    couple_trj_group(end,2) = track_ID_d;
                elseif(isempty(ps) ~= 1 && isempty(pd) == 1)
                    [~,q1] = size(couple_trj_group);
                    [~,q2] = find(couple_trj_group(ps,:)==0);
                    q3 = min(q2);
                    if(xs<xd)
                            temp_left = track_ID_s;
                            temp_right = track_ID_d;
                        else
                            temp_left = track_ID_d;
                            temp_right = track_ID_s;
                    end
                    if (q3 < q1)
                        couple_trj_group(ps,q3) = temp_left;
                        couple_trj_group(ps,q3+1) = temp_right;
                    else
                        couple_trj_group(ps,end+1) = temp_left; 
                        couple_trj_group(ps,end+1) = temp_right; 
                    end
                elseif (isempty(ps) == 1 && isempty(pd) ~= 1)
                    [~,q1] = size(couple_trj_group);
                    [~,q2] = find(couple_trj_group(pd,:)==0);
                    q3 = min(q2);
                    if(xs<xd)
                            temp_left = track_ID_s;
                            temp_right = track_ID_d;
                        else
                            temp_left = track_ID_d;
                            temp_right = track_ID_s;
                    end
                    if (q3 < q1)
                        couple_trj_group(ps,q3) = temp_left;
                        couple_trj_group(ps,q3+1) = temp_right;
                    else
                        couple_trj_group(ps,end+1) = temp_left; 
                        couple_trj_group(ps,end+1) = temp_right; 
                    end
                else
                    continue;
                    %disp('居然sspot和dspot的track_ID之前都存在过！')
                end
        end
    end
                
end
couple_trj_group = couple_trj_group(2:end,:) - 1;
[u1,v1] = size(couple_trj_group);
couple_trj_group(:,end+1) = 1:1:u1;
xlswrite(strcat(output_path,'Couple_Spot_Trj','.xlsx'),couple_trj_group,'couple_trj_group','A1');
%% couple_trj_group to long_trj_group
[P,Q] = size(couple_trj_group);
long_trj_group = zeros(P,Q)-1;
for i = 1:P
    temp_raw = couple_trj_group(i,:);
    [~,v] = find(temp_raw==-1);
    if (isempty(v))
        V = Q/2;
    else
        vmin = min(v);
        V = (vmin-1)/2;
    end
    for j = 1:V
        track_ID_left = temp_raw(1,2*j-1);
        track_ID_right = temp_raw(1,2*j);
        [u1,~] = find(TRACK_ID_raw == track_ID_left);
        [left_track_length,~] = size(u1);
        [u2,~] = find(TRACK_ID_raw == track_ID_right);
        [right_track_length,~] = size(u2);
        if(left_track_length >= right_track_length)
            long_trj_group(i,j) = track_ID_left;
        else
            long_trj_group(i,j) = track_ID_right;
        end
    end
end
[u1,~] = size(long_trj_group);
long_trj_group(:,end+1) = 1:1:u1;
xlswrite(strcat(output_path,'Couple_Spot_Trj','.xlsx'),long_trj_group,'long_trj_group','A1');

%% long_trj_group to long_trj_sequence
[P,~] = size(long_trj_group);
long_trj_sequence = zeros();
for i = 1:P
    temp_raw = long_trj_group(i,:);
    [~,v] = find(temp_raw==-1);
    vmin = min(v);
    V = vmin - 1;
    for j = 1:V
        track_ID = temp_raw(j);
        if(j ~= 1)
            [~,v2] = find(temp_raw(1:j-1) == track_ID);
            if(~isempty(v2))
                continue;
            end
        end
        [u1,~] = find(TRACK_ID_raw == track_ID);
        [track_length,~] = size(u1);
        if(size(long_trj_sequence)~=[1,1])
            long_trj_sequence(end+1:end+track_length,1:N+1) = [data(u1,:),ones(track_length,1) * i];
        else
            long_trj_sequence = [data(u1,:),ones(track_length,1) * i];
        end
    end
    
end

xlswrite(strcat(output_path,'Couple_Spot_Trj','.xlsx'),[LABEL,{'PARTICLE_ID'}],'long_trj_sequence','A1');
xlswrite(strcat(output_path,'Couple_Spot_Trj','.xlsx'),long_trj_sequence,'long_trj_sequence','A2');
%% couple_trj_group to track_result
temp_track_result = zeros(total_frame_number+1,16)-1;
temp_track_result(:,8) = 1; 
temp_track_result(:,16) = 1; 
[cgr,cgc] = size(couple_trj_group);
MAX_cgr = max(cgr);
J = floor(cgc/2);
for i = 1: MAX_cgr
     temp_couple_trj_group_raw = couple_trj_group(i,:);
     for j = 1 : J
         if (temp_couple_trj_group_raw(2*j-1) ~= -1)
             left_track_ID = temp_couple_trj_group_raw(2*j-1);
             right_track_ID = temp_couple_trj_group_raw(2*j);
             [u,~] = find(TRACK_ID_raw == left_track_ID);
             [U,~] = size(u);
             for k = 1 : U
                 spot_id = SPOT_ID(u(k));
                 frame = FRAME1(u(k));
                 position_x = X(u(k));
                 position_y = -Y(u(k));
                 track_id = TRACK_ID_raw(u(k));
                 mean_intensity = MEAN_INTENSITY(u(k));
                 total_intensity = TOTAL_INTENSITY(u(k));
                 temp_track_result(frame,1:8) = [spot_id,frame-1,position_x,position_y,mean_intensity,total_intensity,track_id,i];
             end
             [v,~] = find(TRACK_ID_raw == right_track_ID);
             [V,~] = size(v);
             for k = 1 : V
                 spot_id = SPOT_ID(v(k));
                 frame = FRAME1(v(k));
                 position_x = X(v(k));
                 position_y = -Y(v(k));
                 track_id = TRACK_ID_raw(v(k));
                 mean_intensity = MEAN_INTENSITY(v(k));
                 total_intensity = TOTAL_INTENSITY(v(k));
                 temp_track_result(frame,9:16) = [spot_id,frame-1,position_x,position_y,mean_intensity,total_intensity,track_id,i];
             end
             if(j == J)
                 track_result((total_frame_number+1)*(i-1)+1:(total_frame_number+1)*i,:) = temp_track_result;
                 temp_track_result = zeros(total_frame_number+1,16)-1;
                 temp_track_result(:,8) = i+1; 
                 temp_track_result(:,16) = i+1; 
             end
         else
              
              track_result((total_frame_number+1)*(i-1)+1:(total_frame_number+1)*i,:) = temp_track_result;
              temp_track_result = zeros(total_frame_number+1,16)-1;
              temp_track_result(:,8) = i+1; 
              temp_track_result(:,16) = i+1; 
              break;
         end
     end
end

name1 = [{'UPPER_SPOT_ID'},{'FRAME'},{'X'},{'Y'},{'MEAN_INTENSITY'},{'TOTAL_INTENSITY'},{'TRACK_ID'},{'PARTICLE_ID'}];
name2 = [{'LOWER_SPOT_ID'},{'FRAME'},{'X'},{'Y'},{'MEAN_INTENSITY'},{'TOTAL_INTENSITY'},{'TRACK_ID'},{'PARTICLE_ID'}];
xlswrite(strcat(output_path,'Couple_Spot_Trj','.xlsx'),name1,'track_result','A1');
xlswrite(strcat(output_path,'Couple_Spot_Trj','.xlsx'),name2,'track_result','I1');
xlswrite(strcat(output_path,'Couple_Spot_Trj','.xlsx'),track_result,'track_result','A2');
toc

end

