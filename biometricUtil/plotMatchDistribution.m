function plotMatchDistribution(indexes, curAxes, optPlotgms, optPlotims)

%error(nargchk(2,4,nargin));

% set the graphics handler
if nargin == 1
    curAxes = figure;
end
% color and type of line
if nargin <= 2
    optPlotgms = 'g-';
end
if nargin <= 3
    optPlotims = 'r-';
end
axes(curAxes);

hold on, grid on, axis square;

% normalizzo
gN = indexes.gmsN / max(indexes.gmsN);
iN = indexes.imsN / max(indexes.imsN);

set(gca, 'XScale', 'linear');
set(gca, 'YScale', 'linear');
plot(indexes.gmsX, gN, optPlotgms);
plot(indexes.imsX, iN, optPlotims);
xlabel('Threshold');
ylabel('Genuine and Impostors');