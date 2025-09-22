
%% Supp Figure 2a: gradients 7 net
addpath('~/VDisk1/Xinyu/softwares/spider_plot-master');

schaefer400_roi = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');

color_list = [
0.764705882352941	0.552941176470588	0.768627450980392
0.996078431372549	0.850980392156863	0.690196078431373
0.984313725490196	0.505882352941176	0.450980392156863
]; color_list = flip(color_list);


load('../Figure1/Fig_1_FG_Subtypes_statitsc_new.mat');

sub1 = zeros(1, 7);
sub1(1) = mean(FG_Subtypes_statitsc.depression_subtype_ave2(contains(schaefer400_roi.parcelslabel, 'Vis')));
sub1(2) = mean(FG_Subtypes_statitsc.depression_subtype_ave2(contains(schaefer400_roi.parcelslabel, 'SomMot')));
sub1(3) = mean(FG_Subtypes_statitsc.depression_subtype_ave2(contains(schaefer400_roi.parcelslabel, 'DorsAttn')));
sub1(4) = mean(FG_Subtypes_statitsc.depression_subtype_ave2(contains(schaefer400_roi.parcelslabel, 'SalVentAttn')));
sub1(5) = mean(FG_Subtypes_statitsc.depression_subtype_ave2(contains(schaefer400_roi.parcelslabel, 'Limbic')));
sub1(6) = mean(FG_Subtypes_statitsc.depression_subtype_ave2(contains(schaefer400_roi.parcelslabel, 'Cont')));
sub1(7) = mean(FG_Subtypes_statitsc.depression_subtype_ave2(contains(schaefer400_roi.parcelslabel, 'Default')));

sub2 = zeros(1, 7);
sub2(1) = mean(FG_Subtypes_statitsc.depression_subtype_ave1(contains(schaefer400_roi.parcelslabel, 'Vis')));
sub2(2) = mean(FG_Subtypes_statitsc.depression_subtype_ave1(contains(schaefer400_roi.parcelslabel, 'SomMot')));
sub2(3) = mean(FG_Subtypes_statitsc.depression_subtype_ave1(contains(schaefer400_roi.parcelslabel, 'DorsAttn')));
sub2(4) = mean(FG_Subtypes_statitsc.depression_subtype_ave1(contains(schaefer400_roi.parcelslabel, 'SalVentAttn')));
sub2(5) = mean(FG_Subtypes_statitsc.depression_subtype_ave1(contains(schaefer400_roi.parcelslabel, 'Limbic')));
sub2(6) = mean(FG_Subtypes_statitsc.depression_subtype_ave1(contains(schaefer400_roi.parcelslabel, 'Cont')));
sub2(7) = mean(FG_Subtypes_statitsc.depression_subtype_ave1(contains(schaefer400_roi.parcelslabel, 'Default')));

hc = zeros(1, 7);
hc(1) = mean(FG_Subtypes_statitsc.graident1_depression_HC_ave(contains(schaefer400_roi.parcelslabel, 'Vis')));
hc(2) = mean(FG_Subtypes_statitsc.graident1_depression_HC_ave(contains(schaefer400_roi.parcelslabel, 'SomMot')));
hc(3) = mean(FG_Subtypes_statitsc.graident1_depression_HC_ave(contains(schaefer400_roi.parcelslabel, 'DorsAttn')));
hc(4) = mean(FG_Subtypes_statitsc.graident1_depression_HC_ave(contains(schaefer400_roi.parcelslabel, 'SalVentAttn')));
hc(5) = mean(FG_Subtypes_statitsc.graident1_depression_HC_ave(contains(schaefer400_roi.parcelslabel, 'Limbic')));
hc(6) = mean(FG_Subtypes_statitsc.graident1_depression_HC_ave(contains(schaefer400_roi.parcelslabel, 'Cont')));
hc(7) = mean(FG_Subtypes_statitsc.graident1_depression_HC_ave(contains(schaefer400_roi.parcelslabel, 'Default')));

figure; hold;

% rc = radarChart([sub1; sub2; hc]);
% rc.RLim = [-0.8, 0.8];
% rc.RTick = [-0.8, 0, 0.8];
% 
% rc.setBkg('FaceColor', [0, 0, 0]);
% rc.setPropLabel('FontSize',20,'FontName','Cambria','Color',[0,0,.8]);
% rc.PropName = {'VN', 'SMN', 'DAN', 'SAN', 'Lib', 'CON', 'DMN'};
% 
% rc.draw();

set(gcf, 'Position', [0, 0, 1000, 1000]);

rc = spider_plot([sub1; sub2; hc], ...
    'AxesLabels', {'VN', 'SMN', 'DAN', 'SAN', 'Lib', 'CON', 'DMN'}, ...
    'AxesLimits', repmat([-0.8; 0.8], 1, 7), ...
    'AxesInterval', 2, ...
    'AxesLabelsOffset', 0.15, ...
    'AxesWebType', 'circular', ...
    'LineWidth', 3, ...
    'AxesRadialLineWidth', 2, ...
    'AxesWebLineWidth', 2, ...
    'Color', color_list, ...
    'AxesFont', 'Aptos', ...
    'AxesFontSize', 25, ...
    'LabelFont', 'Aptos', ...
    'LabelFontSize', 25, ...
    'AxesLabelsEdge', 'none', ...
    'BackgroundColor', 'none'...
    );

set(gca, 'color', 'none'); % set(gcf, 'color', 'none');
set(gca, 'FontSize', 30, 'FontName', 'Aptos');
set(gca, 'LineWidth', 2);

pic_path = '../SuppFig2/results_fig';
mkdir(pic_path)

out_fig_path = fullfile(pic_path, 'Gradient_7net.png');
export_fig(out_fig_path, '-m4', '-q100');
close;



%% Supp Figure 2b: dispersion 7 net

color_list = [
0.764705882352941	0.552941176470588	0.768627450980392
0.996078431372549	0.850980392156863	0.690196078431373
0.984313725490196	0.505882352941176	0.450980392156863
];

load('../Figure1/depression_group.mat');

% first confirm scale
modal_all = {'VN', 'SMN', 'DAN', 'SAN', 'Lib', 'CON', 'DMN'};

figure; hold on;

sub1 = zeros(length(depression_group.Global_depression_sub2), 7);
sub1(:, 1) = depression_group.dispdispre_vis_dis_sub2;
sub1(:, 2) = depression_group.dispdispre_sm_dis_sub2;
sub1(:, 3) = depression_group.dispdispre_dan_dis_sub2;
sub1(:, 4) = depression_group.dispdispre_san_dis_sub2;
sub1(:, 5) = depression_group.dispdispre_lib_dis_sub2;
sub1(:, 6) = depression_group.dispdispre_con_dis_sub2;
sub1(:, 7) = depression_group.dispdispre_dmn_dis_sub2;

sub2 = zeros(length(depression_group.Global_depression_sub1), 7);
sub2(:, 1) = depression_group.dispdispre_vis_dis_sub1;
sub2(:, 2) = depression_group.dispdispre_sm_dis_sub1;
sub2(:, 3) = depression_group.dispdispre_dan_dis_sub1;
sub2(:, 4) = depression_group.dispdispre_san_dis_sub1;
sub2(:, 5) = depression_group.dispdispre_lib_dis_sub1;
sub2(:, 6) = depression_group.dispdispre_con_dis_sub1;
sub2(:, 7) = depression_group.dispdispre_dmn_dis_sub1;

hc = zeros(length(depression_group.Global_depression_HC), 7);
hc(:, 1) = depression_group.dispdispre_vis_dis_HC;
hc(:, 2) = depression_group.dispdispre_sm_dis_HC;
hc(:, 3) = depression_group.dispdispre_dan_dis_HC;
hc(:, 4) = depression_group.dispdispre_san_dis_HC;
hc(:, 5) = depression_group.dispdispre_lib_dis_HC;
hc(:, 6) = depression_group.dispdispre_con_dis_HC;
hc(:, 7) = depression_group.dispdispre_dmn_dis_HC;


for i = 1: length(modal_all)
    % subtype1
    y_data = sub1(:, i);

    qt25 = quantile(y_data, 0.25);
    qt75 = quantile(y_data, 0.75);
    med = median(y_data);
    outli_min=min(y_data(~isoutlier(y_data,'quartiles')));
    outli_max=max(y_data(~isoutlier(y_data,'quartiles')));

    basic_pos = i-0.3;

    b_scatter = y_data;
    a_scatter = (basic_pos+0.11.*(rand(size(y_data,1),1)-0.5).*2);
    b_qt75 = [outli_max,qt75];
    a_qt75 = ([basic_pos,basic_pos]);
    b_qt25 = [outli_min,qt25];
    a_qt25 = ([basic_pos,basic_pos]);
    b_box = [qt25,qt25,qt75,qt75];
    a_box = (basic_pos+0.1.*[-1,1,1,-1]);
    b_med = [med,med];
    a_med = ([-0.1, 0.1]+basic_pos);

    scatter(a_scatter, b_scatter, 20, 'filled',...
        'CData', color_list(3, :), 'LineWidth',1.5, 'MarkerFaceAlpha',0.75);
    
    plot(a_qt75, b_qt75, 'LineWidth', 1.5, 'Color', [0,0,0]);
    plot(a_qt25, b_qt25, 'LineWidth', 1.5, 'Color', [0,0,0]);
    fill(a_box, b_box, [1,1,1],...
        'FaceAlpha', 0, 'EdgeColor', [0, 0, 0], 'LineWidth', 1.5);
    plot(a_med, b_med, 'LineWidth', 1.5, 'Color', [0, 0, 0]);

    % subtype2
    y_data = sub2(:, i);

    qt25 = quantile(y_data, 0.25);
    qt75 = quantile(y_data, 0.75);
    med = median(y_data);
    outli_min=min(y_data(~isoutlier(y_data,'quartiles')));
    outli_max=max(y_data(~isoutlier(y_data,'quartiles')));

    basic_pos = i;

    b_scatter = y_data;
    a_scatter = (basic_pos+0.11.*(rand(size(y_data,1),1)-0.5).*2);
    b_qt75 = [outli_max,qt75];
    a_qt75 = ([basic_pos,basic_pos]);
    b_qt25 = [outli_min,qt25];
    a_qt25 = ([basic_pos,basic_pos]);
    b_box = [qt25,qt25,qt75,qt75];
    a_box = (basic_pos+0.1.*[-1,1,1,-1]);
    b_med = [med,med];
    a_med = ([-0.1, 0.1]+basic_pos);

    scatter(a_scatter, b_scatter, 20, 'filled',...
        'CData', color_list(2, :), 'LineWidth',1.5, 'MarkerFaceAlpha',0.75);
    
    plot(a_qt75, b_qt75, 'LineWidth', 1.5, 'Color', [0,0,0]);
    plot(a_qt25, b_qt25, 'LineWidth', 1.5, 'Color', [0,0,0]);
    fill(a_box, b_box, [1,1,1],...
        'FaceAlpha', 0, 'EdgeColor', [0, 0, 0], 'LineWidth', 1.5);
    plot(a_med, b_med, 'LineWidth', 1.5, 'Color', [0, 0, 0]);

    % HC
    y_data = hc(:, i);

    qt25 = quantile(y_data, 0.25);
    qt75 = quantile(y_data, 0.75);
    med = median(y_data);
    outli_min=min(y_data(~isoutlier(y_data,'quartiles')));
    outli_max=max(y_data(~isoutlier(y_data,'quartiles')));

    basic_pos = i+0.3;

    b_scatter = y_data;
    a_scatter = (basic_pos+0.11.*(rand(size(y_data,1),1)-0.5).*2);
    b_qt75 = [outli_max,qt75];
    a_qt75 = ([basic_pos,basic_pos]);
    b_qt25 = [outli_min,qt25];
    a_qt25 = ([basic_pos,basic_pos]);
    b_box = [qt25,qt25,qt75,qt75];
    a_box = (basic_pos+0.1.*[-1,1,1,-1]);
    b_med = [med,med];
    a_med = ([-0.1, 0.1]+basic_pos);

    scatter(a_scatter, b_scatter, 20, 'filled',...
        'CData', color_list(1, :), 'LineWidth',1.5, 'MarkerFaceAlpha',0.75);
    
    plot(a_qt75, b_qt75, 'LineWidth', 1.5, 'Color', [0,0,0]);
    plot(a_qt25, b_qt25, 'LineWidth', 1.5, 'Color', [0,0,0]);
    fill(a_box, b_box, [1,1,1],...
        'FaceAlpha', 0, 'EdgeColor', [0, 0, 0], 'LineWidth', 1.5);
    plot(a_med, b_med, 'LineWidth', 1.5, 'Color', [0, 0, 0]);

end

set(gca, 'color', 'none'); set(gcf, 'color', 'none');
set(gca, 'FontSize', 30, 'FontName', 'Aptos');
set(gca, 'LineWidth', 2);


set(gca, 'YLim', [8, 22]);
set(gca, 'XLim', [0.25 7.75]);    
set(gcf, 'Position', [0, 0, 1100, 700]);
set(gca, 'YTick', [10, 15, 20]);
set(gca, 'XTick', [1,2,3,4,5,6,7]);

set(gca, 'XTickLabel', {'', '', '', '', '', ''});

pic_path = '../SuppFig2/results_fig';
mkdir(pic_path)

out_fig_path = fullfile(pic_path, 'Disperision_7net.png');
export_fig(out_fig_path, '-m4', '-q100');
close;

