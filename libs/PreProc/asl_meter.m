function ActiveSpeechLevel=asl_meter(x,fs)
% function ActiveSpeechLevel=asl_meter(x,fs)
%
% x: the input speech samples, 
%    it can be imported result by 'wavread' for '.wav' file or 'loadb' for '.pcm' file. 
%    if the input x is has a range larger than (-1,1), it will be considered as pcm data and divided by 2^15. 
%
% fs: sampling frequency
% 
%
% Active speech level measurement following ITU-T P.56 
% Author: Lu Huo, LNS/CAU, December, 2005, Kiel.
%
% 

if max(x)>1
    x=x/(2^15);
end


nbit=16; % Bit number per sample
T=0.03; % Time constant of smoothing in seconds
g=exp(-1/(T*fs));
H=0.20; % Time of handover in seconds
I=floor(H*fs+0.5); % Rounded up tp next interger
M=15.9; % Margin in dB, difference between threshold and active speech level.
MIN_LOG_OFFSET=1e-20;


a=zeros(nbit-1,1); % Activity count
c=(0.5).^[nbit-1:-1:1]'; % Threshold level
h=ones(nbit-1,1)*I; % Hangover count
%n=0; % Number of samples read 
s=0; % Sum of absolute samples
sq=0; % Squared sum of samples
p=0; % Intermediate quantities
q=0; % Envelope
%max_sample=0; % Max absolute value found
%maxP=0; % Most positive value
%maxN=0; % Most negative value
%DClevel=0; % Average level 
%ActiveityFactor=0; % Activity factor
ActiveSpeechLevel=-100;


len=length(x);
s=sum(abs(x));
sq=sum(x.^2);
dclevel=s./([1:len])';
LondTermLevel=10*log10(sq./([1:len])'+MIN_LOG_OFFSET);
CdB=20*log10(c);

for i=1:len
    p=g*p+(1-g)*abs(x(i));
    q=g*q+(1-g)*p;
    for j=1:nbit-1
        if q>=c(j)
            a(j)=a(j)+1;
            h(j)=0;
        elseif h(j)<I
            a(j)=a(j)+1;
            h(j)=h(j)+1;            
        end
    end
end

AdB=-100*ones(nbit-1,1);
for i=1:nbit-1
    if a(i)~=0
        AdB(i)=10*log10(sq/a(i));    
    end
end

delta=AdB-CdB;
i=find(delta<=M);

if isempty(i)==0
   i=i(1);
   if i>1
       ActiveSpeechLevel=bin_interp(AdB(i),AdB(i-1),CdB(i),CdB(i-1),M,0.1);
   else
       ActiveSpeechLevel=AdB(i);
   end
end


function als=bin_interp(upcount,lwcount,upthr,lwthr,Margin,tol)
if tol<0
    tol=-tol;
end
iterno=1;
if abs(upcount-upthr-Margin)<tol
    als=upcount;
elseif abs(lwcount-lwthr-Margin)<tol
    als=lwcount;
else
    midcount=(upcount+lwcount)/2;
    midthr=(upthr+lwthr)/2;
    diff=midcount-midthr-Margin;
    while abs(diff)>tol
        iterno=iterno+1;
        if (iterno>20)
            tol=tol*1.1;
        end
        if diff>tol
            midcount=(upcount+midcount)/2;
            midthr=(upthr+midthr)/2;
        elseif diff<-tol
            midcount=(lwcount+midcount)/2;
            midthr=(lwthr+midthr)/2;
        end
        diff=midcount-midthr-Margin;
    end
    als=midcount;
end

