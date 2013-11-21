TRANS = [.9 .1; .05 .95;];
EMIS = [1/6, 1/6, 1/6, 1/6, 1/6, 1/6;...
7/12, 1/12, 1/12, 1/12, 1/12, 1/12];
pi =[.5;.5];

for i= 1:100
    [seq,states] = hmmgenerate(i,TRANS,EMIS);
    
p(i)=hmmForward(seq,TRANS,EMIS,pi);
end