function [] = fusionWeightedSumICPR2010(scoresT_norm, qualNorm, genImp, dirScores, dirResults, normData, nomedb, nomi_matchers, ...
    numGenuini, numImpostori, numInd, numSamples, kfold, fidResults, plottaROCs)

%C. Chia, N. Sherkat and L. Nolle, "Towards a Best Linear Combination for Multimodal Biometric Fusion,"
%Pattern Recognition (ICPR), 2010 20th International Conference on, Istanbul, 2010, pp. 1176-1179.

%init
numScores = size(scoresT_norm, 1);

%weight computation according to paper
weight = computeWeightsICPR2010(scoresT_norm, qualNorm, genImp, dirScores, numGenuini, numImpostori, numInd, numSamples, kfold);

%score fusion
%(if necessary parfor -> for)
scoresWeightedSum = zeros(numScores, 1);
parfor i = 1 : numScores
    scoreSum = 0;
    for k = 1 : numel(dirScores)
        scoreSum = scoreSum + weight(k) * scoresT_norm(i, k) * qualNorm(i,k);
    end %for k
    scoresWeightedSum(i) = scoreSum;
end %for i

%divide in genuine and impostors
[genuini, impostori] = dividiScoresGenImp(scoresWeightedSum, genImp);
saveGenImp(genuini, impostori, [dirResults 'distr_weighted_sum.mat']);

%biometric error measures
labelTest = [nomedb '_WSUM_ICPR2010_' [nomi_matchers{:}]];
[EER, deltaFMR_EER, deltaFNMR_EER, zeroFMR, FMR1000] = indiciStatisticiIncertezzaVLFEAT(genuini, impostori, 'R', labelTest, dirResults, plottaROCs);

%save computed weights
save([dirResults 'weights_icpr2010'], 'weight');

%print results on file
fprintf(fidResults, '%s\r\n', labelTest);
fprintf(fidResults, 'Weights computed using k-fold validation\r\n');
fprintf(fidResults, 'K = %d\r\n', kfold);
fprintf(fidResults, 'EER (%%): %f\r\n', EER*100);
fprintf(fidResults, 'deltaFMR_EER (%%): %f\r\n', deltaFMR_EER*100);
fprintf(fidResults, 'deltaFNMR_EER (%%): %f\r\n', deltaFNMR_EER*100);
fprintf(fidResults, 'ZeroFMR (%%): %f\r\n', zeroFMR*100);
fprintf(fidResults, 'FMR_1000 (%%): %f\r\n', FMR1000*100);
fprintf(fidResults, 'Weights: \r\n');
for k = 1 : numel(dirScores)
    fprintf(fidResults, '%f: \r\n', weight(k));
end %for k
fprintf(fidResults, '\r\n\r\n');



%%%%%%%%%
pause(1)
%%%%%%%%%