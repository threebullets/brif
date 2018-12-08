%% data path
clc;
clear;
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
[filename,pathname]=uigetfile({'*.*','All Files(*.*)'},'Select reference image',...
                          input_path);
raw_data=importdata(strcat(pathname,filename));
%% init
output=zeros();
data = raw_data.data;
[U,~]=size(data);
x1=raw_data.data(:,3);
y1=-raw_data.data(:,4);
x2=raw_data.data(:,11);
y2=-raw_data.data(:,12);
frame_mumber1=raw_data.data(:,2);
frame_mumber2=raw_data.data(:,10);
particle_ID1=raw_data.data(:,8);
particle_ID2=raw_data.data(:,16);
LeftspotI=raw_data.data(:,5);
RightspotI=raw_data.data(:,13);
I_SUM=LeftspotI+RightspotI;
I_substract=LeftspotI-RightspotI;
a=I_substract(1:U,1)./I_SUM(1:U,1);
% a1=abs(a);
% am=max(a1);
% an=min(a1);
% a2=(a1(1:u,1)-an)./(am-an);
Azimuth_angle=acos(a);
Azimuth_angle=Azimuth_angle/2*180/pi;

%% 拟合
ID = zeros();
IDs = zeros();
[M,~] = size(particle_ID1);
ID = particle_ID1(1);
IDs = particle_ID1(1);
divide = zeros();
i = 1;
while 1
    [u,~] = find(particle_ID1==ID);
    ID_begin = min(u);
    ID_end = max(u);
    divide(i,1) = ID_begin;
    if (ID_end == M)
        break;
    end
    ID = particle_ID1(ID_end + 1);
    IDs(i+1,1) = ID;
    i = i + 1;
end

[R,~] = size(divide);
disp('统计如下：');
disp(['轨迹条数：',num2str(R),'条']);
total_frame_number = zeros();
for i = 1:R
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

DT = 0.02;
t = zeros(R,1);
b = zeros(R,1);
k = 1;
for i  = 1:R
    temp_a = a(divide(i):divide(i)+total_frame_number(i)-1,1);
    [g,~] = size(temp_a);
    if(g<=20)  
        continue
    end
    [t,C] = autocorrelation(temp_a,DT);
    [fitresult, gof] = createFit(t, C);
    t(k) = fitresult.t;
    b(k) = fitresult.b;
    k = k + 1;
end

output(1:U,1)=x1(:,1);
output(:,2)=y1(:,1);
output(:,3)=LeftspotI(:,1);
output(:,4)=frame_mumber1(:,1);
output(:,5)=particle_ID1(:,1);
output(:,6)=x2(:,1);
output(:,7)=y2(:,1);
output(:,8)=RightspotI(:,1);
output(:,9)=frame_mumber2(:,1);
output(:,10)=particle_ID2(:,1);
output(:,11)=I_SUM(:,1);
output(:,12)=a(:,1);
output(:,13)=Azimuth_angle(:,1);
% autocorrelation(a(1:61,:),0.02);
M = max(frame_mumber1);
for i = 0:5:800                   %每隔两帧输出一张
[row_frame,~] = find(frame_mumber1 == i & frame_mumber2 == i);
X1 = x1(row_frame);
Y1 = y1(row_frame);
Z1 = Azimuth_angle(row_frame);
X2 = x2(row_frame);
Y2 = y2(row_frame);
Z2 = Azimuth_angle(row_frame);
scatter([X1;X2],[Y1;Y2],10,[Z1;Z2],'filled');
colormap(jet);
% caxis([0,90])
colorbar
saveas(gcf,strcat(output_path,num2str(i),'.png'));
end
xlswrite(strcat(output_path,'output.xlsx'),output,1);
disp('done!')
% SPOT_ID = raw_data.data(:,1);
% X = raw_data.data(:,4);
% Y = -raw_data.data(:,5);
% FRAME = raw_data.data(:,8);
% TRACK_ID = raw_data.data(:,2);
% MEAN_INTENSITY = raw_data.data(:,12);
% TOTAL_INTENSITY = raw_data.data(:,16);
% [M,~] = size(SPOT_ID);
