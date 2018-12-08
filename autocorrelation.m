function [T,C] = autocorrelation(LD,DT)
[n,~] = size(LD);
LD_ave = sum(LD)/n;
a = LD- LD_ave;
C = zeros(n,1);
T = zeros(n,1);
C(1) = 1;
T(1) = 0;
for t = 1:n-1
   vet1=0.0;
   vet2=0.0;  
   for t_p = 1 : n-t
      vet01=a(t_p)*a(t_p+t);
      vet02=a(t_p)*a(t_p);
      vet1 = vet1 + vet01;
      vet2 = vet2 + vet02;
   end
   C(t+1) = vet1/vet2;
   T(t+1)=t*DT;
end
% subplot(2,1,1)
% plot(T(1:21),C(1:21));
% subplot(2,1,2)
% y = autocorr(a(1:61));
% plot(y)


end