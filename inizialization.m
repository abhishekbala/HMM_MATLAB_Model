%this script initialize the the data stream with both the devices used
%the default source for the eguage is the "microwave". Plase modify it if
%other circuits need to be monitored

switch device
    case 'eGuage'

x = eguageDataStream ; 

source = 'microwave';
class(source);
x = x.streamInitiate;

    case 'TED'
        x = tedDataStream;
        x = x.streamInitiate ; 
end             