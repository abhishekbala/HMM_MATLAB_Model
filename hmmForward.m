function p=hmmForward(O,A,B,pi)
%INPUTS:
% O = Given observation sequence labellebd in numerics
% A(N,N) = transition probability matrix
% B(N,M) = Emission matrix
% pi = initial probability matrix
% Output
% P = probability of given sequence in the given model
n=length(A(1,:));
T=length(O);

for i=1:n                      %initialization
    M(1,i)=B(i,O(1))*pi(i);    %m is alfa in the article
end

for t=1:(T-1)                    %induction till the observation right before the last
    for j=1:n                    %do that for every state at t+1
        z=0;
        for i=1:n
            z=z+A(i,j)*M(t,i);    %probability to get to j state at t+1 coming from all the possible i s
        end
        M(t+1,j)=z*B(j,O(t+1));   %probability to be in the state j at t+1 given the observation O(t+1)
    end
end

p=0;                               %initialization o fprability

for i=1:n                          %termination: sum all the probability for the different state at the last observation T
    p=p+M(T,i);        
end
