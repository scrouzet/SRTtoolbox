function [R] = makeRTDistrib(RT,correct,bincenters,cumul,alpha)
% Compute the distribution of reaction times (RTs)
% can be:
% - relative counts (proportion of saccades per bin -> good to compare conditions)
% - cumulative
% 
% Example:
% R = makeRTDistrib(RT,correct,bincenters,1);
%
% seb.crouzet@gmail.com

%==========================================================================
% Default arguments
if nargin < 3 || isempty(bincenters),  bincenters = 0:10:1000; end
if nargin < 4 || isempty(cumul),       cumul = 0; end % if TRUE, plot the cumulative distribution
if nargin < 5 || isempty(alpha),       alpha = .05; end
if nargin < 6 || isempty(nbb),         nbb = 500; end % number of bootstrap resample
%==========================================================================

% Compute the statistics of the distribution
%R.RT = RT;
%R.correct = correct;

R.accuracy      = mean(correct)*100;
R.accuracy_stat = 100 * bootstrp(nbb,@mean, correct);
R.accuracy_ci   = getCIfromboot(R.accuracy_stat,alpha);

%R.stdRT_cor = std(RT(correct==1));
%R.stdRT_inc = std(RT(correct==1));

R.meanRT_cor = mean(RT(correct==1));
R.meanRT_inc = mean(RT(correct==0));
R.meanRT_cor_stat = bootstrp(nbb,@mean,RT(correct==1));
R.meanRT_cor_ci   = getCIfromboot(R.meanRT_cor_stat,alpha);

R.medianRT_cor = median(RT(correct==1));
R.medianRT_inc = median(RT(correct==0));
R.medianRT_cor_stat = bootstrp(nbb,@median,RT(correct==1));
R.medianRT_cor_ci   = getCIfromboot(R.medianRT_cor_stat,alpha);

R.minRT      = ComputeMinRT(RT,correct);
R.minRT_stat = bootstrp(nbb, @ComputeMinRT, RT, correct);
R.minRT_ci   = getCIfromboot(R.minRT_stat,alpha);

% RT distribs characteristics
R.bin_centers = 0:10:1000;
R.counts_correct   = hist(RT(correct==1), bincenters);
R.counts_incorrect = hist(RT(correct==0), bincenters);

% RT distribs characteristics - Relative counts
% for plotting (and comparison of conditions)
R.nTrial = sum(R.counts_correct) + sum(R.counts_incorrect);
R.counts_correct_REL   = (R.counts_correct / R.nTrial) * 100;
R.counts_incorrect_REL = (R.counts_incorrect / R.nTrial) * 100;

% Compute MaxRT (trick using the basic minRT function in reversed)
%R.maxRT = compute_minRT(fliplr(R.counts_correct), fliplr(R.counts_incorrect), fliplr(R.bin_centers));


% if plotnow
%     %--------------------------------------------------------------------------
%     % PLOT
%     plot(bincenters, R.counts_correct_REL, 'Color', mycolor , 'Linewidth', mylinewidth(1)) ; hold on
%     plot(bincenters, R.counts_incorrect_REL, 'Color', mycolor, 'Linewidth', mylinewidth(2)); hold on
%     
%     % display minimum RT information
%     mybinsize = bincenters(2)-bincenters(1);
%     mybar = [R.minRT - mybinsize/2  R.minRT + mybinsize/2];
%     fill([mybar fliplr(mybar)], [myylim(1) myylim(1) myylim(2) myylim(2)],...
%         mycolor, 'FaceAlpha', 0.5, 'EdgeColor', 'none'); hold on
%     % display text with a 10% decalage (on y and x axes)
%     text(R.minRT + R.minRT*0.1, myylim(2) - myylim(2)*0.1, [num2str(R.minRT) ' ms'], 'Color', mycolor); hold on 
% end

end