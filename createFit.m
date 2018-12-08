function [fitresult, gof] = createFit(a, b)
%CREATEFIT(A,B)
%  Create a fit.
%
%  Data for 'KWW function' fit:
%      X Input : a
%      Y Output: b
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 27-Nov-2018 14:44:57 自动生成


%% Fit: 'KWW function'.
[xData, yData] = prepareCurveData( a, b );

% Set up fittype and options.
ft = fittype( 'exp(-(x/t)^(b))', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [0 0];
opts.StartPoint = [1 1];
opts.Upper = [1 Inf];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
% figure( 'Name', 'KWW function' );
% h = plot( fitresult, xData, yData );
% legend( h, 'b vs. a', 'KWW function', 'Location', 'NorthEast' );
% % Label axes
% xlabel a
% ylabel b
% grid on


