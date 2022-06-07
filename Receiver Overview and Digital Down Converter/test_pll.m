[s]=pll_init(0.1,1,1,1);
Nb=10; %number of blocks
Ns=100; %number of samples
load('ref_800hz'); % input signal
%scaling the provided waveforms

in_scale = reshape(ref_in,Ns,Nb);
out=zeros(Ns,Nb);
for n=1:Nb
    [out(:,n),s]=pll(in_scale(:,n),s);
    plot(1:length(in_scale(:,n)),in_scale(:,n),1:length(in_scale(:,n)),out(:,n))
    pause;
end
