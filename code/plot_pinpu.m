clear all
[s,fs,nbits]=wavread('2.wav');
N=length(s);
t=(0:N-1)/fs;
f=(0:N-1)*fs/N;%Ƶ����
y=abs(fft(s));
f=f(1:N/2);
y=y(1:N/2);
subplot(2,1,1)
plot(t,s)
title('ʱ���ź�')
subplot(2,1,2)
plot(f,y)
title('Ƶ��ͼ')
