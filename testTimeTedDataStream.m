%the script is done simply to test the TED rate of refreshments. USe it to
%establish which is the correct rate that has to be set in your detectEvent
%timer

x = tedDataStream;
x = x.streamInitiate;
tic;
x = x.streamUpdate;
toc;