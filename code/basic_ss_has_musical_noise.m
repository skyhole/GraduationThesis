clear;
[xx,fs]=wavread('1.wav');      % �������ź�
[team,row]=size(xx);                               
if row==2
    x=(xx(:,1)+xx(:,2))/2;                        %   ����ͨ����ƽ��ֵ
    yy=x;
else
    x=xx;
    yy=x;
end
x=x-mean(x)+0.1*rand(length(x),1);           %   ȥֱ������������
N=length(x);
n=220;                                     % ÿһ֡��
n1=160;                                     %ÿ��֡�غϵĳ���
frame=floor((N-n)/(n-n1));                      %֡��
for i=1:frame
    y1=x((i-1)*(n-n1)+1:(i-1)*(n-n1)+n).*hamming(n);      % ÿһ֡��Ӧ�������ź�
    fy=fft(y1,n);                                        %��fft
    nen(i,:)=abs(fy).^2;                                 %������
    ang(i,:)=angle(fy);                                  % ��Ƕ�
end
yuzhi=sum(sum(nen(2:5,:)))/(4*n);             % ����ֵ���źſ�ʼ�׶ε�����ƽ��ֵ
for i=1:frame
    nen(i,:)=nen(i,:)-yuzhi;                  % ����
    nen(i,find(nen(i,:)<0))=0;                 % ��С��0�Ĳ��ָ�ֵΪ0
end
for i=1:frame
    nen(i,:)=sqrt(nen(i,:));
    jie=nen(i,:).*exp(j*ang(i,:));                    %��Ƶ����
    out(i,:)=real(ifft(jie))./hamming(n)';         %����fft
end
zong=out(1,:)';                      % ��out�󵼣��Ա���ԭ�źűȽ�
jiewei=n;
for i=2:frame                      %��һϵ�е�֡��ϻ�ԭ
    zong(jiewei-n1+1:jiewei)=(zong(jiewei-n1+1:jiewei)+out(i,1:n1)')/2; 
    jiewei=jiewei+n-n1;
    zong=[zong;out(i,n1+1:end)'];
end
figure(1); 
subplot(211);
plot(x);                        %�������ԭʼ�����ź�
axis([1,(n-n1)*frame+n,min(x),max(x)]);
subplot(212);
specgram(x,fs,1024,n,n1);          % ��Ӧ������ͼ
figure(2);
subplot(211);
plot(zong);                   %����ǿ�������ź�
axis([1,(n-n1)*frame+n,min(zong),max(zong)]);
subplot(212);
specgram(zong,fs,1024,n,n1);
wavplay(x,fs);           % �����Ƶ
wavplay(zong,fs);
