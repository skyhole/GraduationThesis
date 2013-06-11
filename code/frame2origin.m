function y=frame2origin(x,frameSize,overlap)
sizeofx=size(x);frameNum=sizeofx(1,2);y=[];
for i=1:frameNum

        y=[y;x(1:(frameSize-overlap),i)];
  
end
y=[y;x((frameSize-overlap+1):end,end)];
%y=y';