function [ ] = data_cleaning(track_result)
% Filename            :       data_cleaning.m
% Date                :       2018-10-12
% Description         :       data cleaning.
%% data cleaning
%% step1 ?????????????????????????????????
global total_frame1_number
step1 = track_result;
upper_spot_id = step1(:,1);
lower_spot_id = step1(:,9);
particle_id = step1(:,8);
max_particle_id = particle_id(end);
[u,~] = find(upper_spot_id == -1 & lower_spot_id == -1);
Diff_u = diff(u);
[U,~] = size(Diff_u);
temp_row = zeros();
delete_row =  0;
count = 0;
flag = 0;
for i = 1:U
    if Diff_u(i) == 1  %计数中
        count = count + 1;
        flag = 1;
        temp_row(count) = u(i);
    elseif (Diff_u(i) ~= 1 && flag ~= 1) % 计数前
        count = 0;
        flag = 0;
    elseif (Diff_u(i) ~= 1 && flag == 1) % 计数后
        count = count + 1;
        flag = 0;
        temp_row(count) = u(i);
        if(count <= 3)
            count = 0;       
            temp_row = zeros();
            continue;
        else
            frist_row = temp_row(1);
            last_row = temp_row(end);
            if(mod(frist_row,total_frame1_number) == 1 || mod(last_row,total_frame1_number) == 0)
                delete_row = [delete_row;temp_row'];
                count = 0;       
                temp_row = zeros();
            else
                count = 0;       
                temp_row = zeros();
                continue;
            end
        end
    end
end
step1(delete_row(2:end),:)=[];

%% output
% name1 = [{'UPPER_SPOT_ID'},{'FRAME'},{'X'},{'Y'},{'MEAN_INTENSITY'},{'TOTAL_INTENSITY'},{'TRACK_ID'},{'NUM'}];
% name2 = [{'LOWER_SPOT_ID'},{'FRAME'},{'X'},{'Y'},{'MEAN_INTENSITY'},{'TOTAL_INTENSITY'},{'TRACK_ID'},{'NUM'}];
% xlswrite(strcat(output_path,'step1.xlsx'),name1,4,'A1');
% xlswrite(strcat(output_path,'step1.xlsx'),name2,4,'I1');
% xlswrite(strcat(output_path,'step1.xlsx'),outputmat_sum,4,'A2');
%% step2 
step2 = step1;
upper_spot_id = step2(:,1);
particle_id = step2(:,8);

[u,~] = find(upper_spot_id == -1);
Diff_u = diff(u);
[U,~] = size(Diff_u);
temp_row = zeros();
delete_row =  0;
count = 0;
flag = 0;
k = 1;
for i = 1:U
    if Diff_u(i) == 1  %计数中
        count = count + 1;
        flag = 1;
        temp_row(count) = u(i);
    elseif (Diff_u(i) ~= 1 && flag ~= 1) % 计数前
        count = 0;
        flag = 0;
    elseif (Diff_u(i) ~= 1 && flag == 1) % 技术后
        count = count + 1;
        flag = 0;
        temp_row(count) = u(i);
        if(count <= 3)
            count = 0;       
            temp_row = zeros();
            continue;
        else
            temp_particle_id = particle_id(temp_row(1));
            [u1,~] = find(particle_id == temp_particle_id);
            min_u1 = min(u1);
            max_u1 = max(u1);
            max_temp_row = temp_row(count);
            step2(max_temp_row:max_u1,8) = max_particle_id + k;
            step2(max_temp_row:max_u1,16) = max_particle_id + k;
            k = k + 1;          
            count = 0;
            delete_row = [delete_row;temp_row'];
            temp_row = zeros();
        end
        
    end
end
step2_nondelete_left = step2;
step2(delete_row(2:end),:)=[];
step2_left = step2;

lower_spot_id = step2_left(:,9);
particle_id = step2_left(:,8);
[v,~] = find(lower_spot_id == -1);
Diff_v = diff(v);
[V,~] = size(Diff_v);
temp_row = zeros();
delete_row =  0;
count = 0;
flag = 0;
for i = 1:V
    if Diff_v(i) == 1  %计数中
        count = count + 1;
        flag = 1;
        temp_row(count) = v(i);
    elseif (Diff_v(i) ~= 1 && flag ~= 1) % 计数前
        count = 0;
        flag = 0;
    elseif (Diff_v(i) ~= 1 && flag == 1) % 技术后
        count = count + 1;
        flag = 0;
        temp_row(count) = v(i);
        if(count <= 3)
            count = 0;       
            temp_row = zeros();
            continue;
        else
            temp_particle_id = particle_id(temp_row(1));
            [v1,~] = find(particle_id == temp_particle_id);
            min_v1 = min(v1);
            max_v1 = max(v1);
            max_temp_row = temp_row(count);
            step2_left(max_temp_row:max_v1,8) = max_particle_id + k;
            step2_left(max_temp_row:max_v1,16) = max_particle_id + k;
            k = k + 1;          
            count = 0;
            delete_row = [delete_row;temp_row'];
            temp_row = zeros();
        end
        
    end
end
step2_nondelete_right = step2_left;
step2_left(delete_row(2:end),:)=[];
step2_right = step2_left;

%% step3 ????????????
step3 = step2_right;
upper_spot_id = step3(:,1);
lower_spot_id = step3(:,9);
upper_frame = step3(:,2);
upper_X = step3(:,3);
upper_Y = step3(:,4);
upper_mean_intensity = step3(:,5);
[u,~] = find(upper_spot_id == -1);
Diff_u = diff(u);
[U,~] = size(Diff_u);
temp_row = zeros();
delete_row =  0;
count = 0;
flag = 0;
for i = 1:U
    if Diff_u(i) == 1  %???
        count = count + 1;
        flag = 1;
        temp_row(count) = u(i);
    elseif (Diff_u(i) ~= 1 && flag ~= 1) % ???
        count = 0;
        flag = 0;
        %???
        above_X = upper_X(u(i)-1);
        next_X = upper_X(u(i)+1); 
        after_interp = interp1([1,3],[above_X,next_X],2);
        upper_X(u(i)) = after_interp;
        
        above_Y = upper_Y(u(i)-1);
        next_Y = upper_Y(u(i)+1);
        after_interp = interp1([1,3],[above_Y,next_Y],2);
        upper_Y(u(i)) = after_interp;
        
        above_frame = upper_frame(u(i)-1);
        next_frame = upper_frame(u(i)+1);
        after_interp = interp1([1,3],[above_frame,next_frame],2);
        upper_frame(u(i)) = after_interp;
        
        above_mean_intensity = upper_mean_intensity(u(i)-1);
        next_mean_intensity = upper_mean_intensity(u(i)+1);
        after_interp = interp1([1,3],[above_mean_intensity,next_mean_intensity],2);
        upper_mean_intensity(u(i)) = after_interp;
        
    elseif (Diff_u(i) ~= 1 && flag == 1) % ???
        flag = 0;
        count = count + 1;
        temp_row(count) = u(i);
        if(count <= 3) %??????
            above_X = upper_X(temp_row(1)-1);
            next_X = upper_X(temp_row(end)+1);            
            linX = 1:1:(count+2);
            after_interp = interp1([1,count+2],[above_X,next_X],linX);
            upper_X(temp_row) = after_interp(2:end-1)';
            
            above_Y = upper_Y(temp_row(1)-1);
            next_Y = upper_Y(temp_row(end)+1);            
            linY = 1:1:(count+2);
            after_interp = interp1([1,count+2],[above_Y,next_Y],linY);
            upper_Y(temp_row) = after_interp(2:end-1)';
            
            above_frame = upper_frame(temp_row(1)-1);
            next_frame = upper_frame(temp_row(end)+1);            
            linX = 1:1:(count+2);
            after_interp = interp1([1,count+2],[above_frame,next_frame],linX);
            upper_frame(temp_row) = after_interp(2:end-1)';
            
            above_mean_intensity = upper_mean_intensity(temp_row(1)-1);
            next_mean_intensity = upper_mean_intensity(temp_row(end)+1);            
            linX = 1:1:(count+2);
            after_interp = interp1([1,count+2],[above_mean_intensity,next_mean_intensity],linX);
            upper_mean_intensity(temp_row) = after_interp(2:end-1)';
        else
            disp('到了step3居然还有大于3行的-1...');    
        end
        count = 0;
        temp_row = zeros();
    end
end


lower_X = step3(:,11);
lower_Y = step3(:,12);
lower_frame = step3(:,10);
lower_mean_intensity = step3(:,13);
[v,~] = find(lower_spot_id == -1);
Diff_v = diff(v);
[V,~] = size(Diff_v);
temp_row = zeros();
delete_row =  0;
count = 0;
flag = 0;
for i = 1:V
    if Diff_v(i) == 1  %???
        count = count + 1;
        flag = 1;
        temp_row(count) = v(i);
    elseif (Diff_v(i) ~= 1 && flag ~= 1) % ???
        count = 0;
        flag = 0;
        %???
        above_X = lower_X(v(i)-1);
        next_X = lower_X(v(i)+1); 
        after_interp = interp1([1,3],[above_X,next_X],2);
        lower_X(v(i)) = after_interp;
        
        above_Y = lower_Y(v(i)-1);
        next_Y = lower_Y(v(i)+1);
        after_interp = interp1([1,3],[above_Y,next_Y],2);
        lower_Y(v(i)) = after_interp;
        
        above_frame = lower_frame(v(i)-1);
        next_frame = lower_frame(v(i)+1);
        after_interp = interp1([1,3],[above_frame,next_frame],2);
        lower_frame(v(i)) = after_interp;
        
        above_mean_intensity = lower_mean_intensity(v(i)-1);
        next_mean_intensity = lower_mean_intensity(v(i)+1);
        after_interp = interp1([1,3],[above_mean_intensity,next_mean_intensity],2);
        lower_mean_intensity(v(i)) = after_interp;
    elseif (Diff_v(i) ~= 1 && flag == 1) % ???
        flag = 0;
        count = count + 1;
        temp_row(count) = v(i);
        if(count <= 3)
            above_X = lower_X(temp_row(1)-1);
            next_X = lower_X(temp_row(end)+1);            
            linX = 1:1:(count+2);
            after_interp = interp1([1,count+2],[above_X,next_X],linX);
            lower_X(temp_row) = after_interp(2:end-1)';
            
            above_Y = lower_Y(temp_row(1)-1);
            next_Y = lower_Y(temp_row(end)+1);            
            linY = 1:1:(count+2);
            after_interp = interp1([1,count+2],[above_Y,next_Y],linY);
            lower_Y(temp_row) = after_interp(2:end-1)';
            
            above_frame = lower_frame(temp_row(1)-1);
            next_frame = lower_frame(temp_row(end)+1);            
            linY = 1:1:(count+2);
            after_interp = interp1([1,count+2],[above_frame,next_frame],linY);
            lower_frame(temp_row) = after_interp(2:end-1)';
            
            above_mean_intensity = lower_mean_intensity(temp_row(1)-1);
            next_mean_intensity = lower_mean_intensity(temp_row(end)+1);            
            linY = 1:1:(count+2);
            after_interp = interp1([1,count+2],[above_mean_intensity,next_mean_intensity],linY);
            lower_mean_intensity(temp_row) = after_interp(2:end-1)';
        else
            disp('到了step3居然还有大于3行的-1...');    
        end
        count = 0;
        temp_row = zeros();
    end
end
step3(:,2) = upper_frame;
step3(:,3) = upper_X;
step3(:,4) = upper_Y;
step3(:,5) = upper_mean_intensity;

step3(:,10) = lower_frame;
step3(:,11) = lower_X;
step3(:,12) = lower_Y;
step3(:,13) = lower_mean_intensity;

global output_path;
name1 = [{'UPPER_SPOT_ID'},{'FRAME'},{'X'},{'Y'},{'MEAN_INTENSITY'},{'TOTAL_INTENSITY'},{'TRACK_ID'},{'PARTICLE_ID'}];
name2 = [{'LOWER_SPOT_ID'},{'FRAME'},{'X'},{'Y'},{'MEAN_INTENSITY'},{'TOTAL_INTENSITY'},{'TRACK_ID'},{'PARTICLE_ID'}];
xlswrite(strcat(output_path,'data_cleaning','.xlsx'),name1,'step1','A1');
xlswrite(strcat(output_path,'data_cleaning','.xlsx'),name2,'step1','I1');
xlswrite(strcat(output_path,'data_cleaning','.xlsx'),step1,'step1','A2');

xlswrite(strcat(output_path,'data_cleaning','.xlsx'),name1,'step2_nondelete_left','A1');
xlswrite(strcat(output_path,'data_cleaning','.xlsx'),name2,'step2_nondelete_left','I1');
xlswrite(strcat(output_path,'data_cleaning','.xlsx'),step2_nondelete_left,'step2_nondelete_left','A2');

xlswrite(strcat(output_path,'data_cleaning','.xlsx'),name1,'step2_left','A1');
xlswrite(strcat(output_path,'data_cleaning','.xlsx'),name2,'step2_left','I1');
xlswrite(strcat(output_path,'data_cleaning','.xlsx'),step2_left,'step2_left','A2');

xlswrite(strcat(output_path,'data_cleaning','.xlsx'),name1,'step2_nondelete_right','A1');
xlswrite(strcat(output_path,'data_cleaning','.xlsx'),name2,'step2_nondelete_right','I1');
xlswrite(strcat(output_path,'data_cleaning','.xlsx'),step2_nondelete_right,'step2_nondelete_right','A2');

xlswrite(strcat(output_path,'data_cleaning','.xlsx'),name1,'step2_right','A1');
xlswrite(strcat(output_path,'data_cleaning','.xlsx'),name2,'step2_right','I1');
xlswrite(strcat(output_path,'data_cleaning','.xlsx'),step2_right,'step2_right','A2');

xlswrite(strcat(output_path,'data_cleaning','.xlsx'),name1,'step3','A1');
xlswrite(strcat(output_path,'data_cleaning','.xlsx'),name2,'step3','I1');
xlswrite(strcat(output_path,'data_cleaning','.xlsx'),step3,'step3','A2');


end