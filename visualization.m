function [] = visualization( data )

%% init
particle_ID = data(:,8);
UPPER_X = data(:,3);
UPPER_Y = -data(:,4);
LOWER_X = data(:,11); 
LOWER_Y = -data(:,12);
[M,~] = size(data);
%% statistics
ID = zeros();
IDs = zeros();
ID = particle_ID(1);
IDs = particle_ID(1);
divide = zeros();
i = 1;
while 1
    [u,~] = find(particle_ID==ID);
    ID_begin = min(u);
    ID_end = max(u);
    divide(i,1) = ID_begin;
    if (ID_end == M)
        break;
    end
    ID = particle_ID(ID_end + 1);
    IDs(i+1,1) = ID;
    i = i + 1;
end

[a,~] = size(divide);
disp('统计如下：');
disp(['轨迹条数：',num2str(a),'条']);
total_frame_number = zeros();
for i = 1:a
    try
    total_frame_number(i,1) = divide(i+1) - divide(i);
    catch
        total_frame_number(i,1) = M - divide(i)+1;
    end
end
max_frame_num = max(total_frame_number);
maximum_range = ceil(max_frame_num/100)*100;
for i = 100:100:maximum_range
[b,~] = find(total_frame_number>=(i-100+1)&total_frame_number<=i);
[c,~] = size(b);
disp([num2str(i-100+1),'<帧数<',num2str(i),' 的有：',num2str(c),'条']);
end
%% 
for i = 1:a
[pID_u,~] = find(particle_ID == IDs(i));
trjA_X = UPPER_X(pID_u);
trjA_Y = UPPER_Y(pID_u);
% [upper_length,~] = size(pID_u);
trjB_X = LOWER_X(pID_u);
trjB_Y = LOWER_Y(pID_u);
% [lower_length,~] = size(B);
plot(trjA_X,trjA_Y,'-','color','b')
hold on
plot(trjB_X,trjB_Y,'-','color','g')
% legend(num2str(track_ID_s-1),num2str(track_ID_d-1));
pause(1)
close;
end
end