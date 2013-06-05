clear;
[xx,fs]=wavread('1.wav');      % 读语音信号
[team,row]=size(xx);                               
if row==2
    x=(xx(:,1)+xx(:,2))/2;                        %   将多通道求平均值
    yy=x;
else
    x=xx;
    yy=x;
end
x=x-mean(x)+0.1*rand(length(x),1);           %   去直流分量并加噪
N=length(x);
n=220;                                     % 每一帧长
n1=160;                                     %每两帧重合的长度
frame=floor((N-n)/(n-n1));                      %帧数
for i=1:frame
    y1=x((i-1)*(n-n1)+1:(i-1)*(n-n1)+n).*hamming(n);      % 每一帧对应的语音信号
    fy=fft(y1,n);                                        %求fft
    nen(i,:)=abs(fy).^2;                                 %求能量
    ang(i,:)=angle(fy);                                  % 求角度
end
yuzhi=sum(sum(nen(2:5,:)))/(4*n);             % 求阈值，信号开始阶段的能量平均值
for i=1:frame
    nen(i,:)=nen(i,:)-yuzhi;                  % 减谱
    nen(i,find(nen(i,:)<0))=0;                 % 将小于0的部分赋值为0
end
for i=1:frame
    nen(i,:)=sqrt(nen(i,:));
    jie=nen(i,:).*exp(j*ang(i,:));                    %求频域函数
    out(i,:)=real(ifft(jie))./hamming(n)';         %求逆fft
end
zong=out(1,:)';                      % 对out求导，以便于原信号比较
jiewei=n;
for i=2:frame                      %将一系列的帧组合还原
    zong(jiewei-n1+1:jiewei)=(zong(jiewei-n1+1:jiewei)+out(i,1:n1)')/2; 
    jiewei=jiewei+n-n1;
    zong=[zong;out(i,n1+1:end)'];
end
figure(1); 
subplot(211);
plot(x);                        %画加噪的原始语音信号
axis([1,(n-n1)*frame+n,min(x),max(x)]);
subplot(212);
specgram(x,fs,1024,n,n1);          % 对应的鱼谱图
figure(2);
subplot(211);
plot(zong);                   %画增强的语音信号
axis([1,(n-n1)*frame+n,min(zong),max(zong)]);
subplot(212);
specgram(zong,fs,1024,n,n1);
wavplay(x,fs);           % 输出音频
wavplay(zong,fs);
