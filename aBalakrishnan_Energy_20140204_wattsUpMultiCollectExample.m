%% aBalakrishnan_Energy_20140204_wattsUpMultiCollectExample

description = 'iPhone';
item = 'iPhone';
nCollectionSeconds = 15;

nCollections = 4;

for iCollection = 1:nCollections
    
    disp(sprintf('Waiting to collection collection # %02d...\n',iCollection));
    pause;
    
    cData = wattsUpCollect(item,description, nCollectionSeconds);
    
    if iCollection == 1
        allData = cData;
    else    
        allData(iCollection,1) = cData;
    end
end

%%
strPath = ['MATLAB Disaggregation Models\HMM_MATLAB_Model\WattsUpData\Results' description '.mat'];
save strPath allData;
% Fullfile

%%
ds = prtDataSetTimeSeries({allData.power}) 
plot(ds)