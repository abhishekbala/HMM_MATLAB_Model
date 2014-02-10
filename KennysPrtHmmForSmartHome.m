prtDir = 'C:\Users\Alberto\Desktop\Disaggregation MATLAB\PRT' ;
addpath(genpath(prtDir))
dataDir = 'C:\Users\Alberto\Desktop\Disaggregation MATLAB\guiV2\Results\Lights';

matFiles = prtUtilSubDir(dataDir,'*.mat');

for iFile = 1:length(matFiles)
    cFile = matFiles{iFile};
    
    loadedStuff = load(cFile);
    
    if iFile == 1
        allData = loadedStuff.data(:);
    else
        allData = cat(1,allData,loadedStuff.data(:));
    end
end

[classNames,~,classInds] = unique({allData.item}');

ds = prtDataSetTimeSeries({allData.power}',classInds,'classNames',classNames);
ds = ds.retainObservations(cellfun(@length,ds.data)>0);

plot(ds);

%%
ds24 = ds.retainClassesByInd([1 2 3 4]);

%% Setup and run the HMM classifier
gem = prtBrvDiscreteStickBreaking;
gem.model.alphaGammaParams = [1 1e-6]; % These parameters control the preferences for the number of states

bhmm = prtBrvDpHmm('components',repmat(prtBrvMvn,10,1),'verboseStorage',false,'vbVerbosePlot',1,'vbVerboseText',1,'vbConvergenceDecreaseThreshold', inf, 'vbMaxIterations',50);
bhmm.initialProbabilities = gem;
bhmm.transitionProbabilities = gem;

% classifier = prtClassMap('rvs',bhmm,'verboseStorage',false);
classifier = prtClassMapLog('rvs',bhmm,'verboseStorage',false);
classifier.twoClassParadigm = 'mary';
classifierTrained = train(classifier,ds24);
%%
dsOut = run(classifierTrained, ds24);
dsDecision = rt(prtDecisionMap,dsOut);
prtScoreConfusionMatrix(dsDecision);
%%

dsOutCrossVal = kfolds(classifierTrained,ds24,2);
dsDecisionCrossVal = rt(prtDecisionMap,dsOutCrossVal);
close all
prtScoreConfusionMatrix(dsDecisionCrossVal);
%%



% % Take new data
% newTimeSeries = ds.data{1} ;
% dsNew = prtDataSetTimeSeries({newTimeSeries}');
% newLogLikelihoods = run(classifierTrained,dsNew) ;
% newLogLikelihoods.X % Outputs the log likelihood
% 
% % Getting class names and class indices
% ds24.classNames ; % Class Names
% ds24.classNamesToClassInd(ds24.classNames) ; % Indices corresponding to the class names

