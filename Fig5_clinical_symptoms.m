
%% Figure 5a: HAMD and HAMA
addpath('~/VDisk1/Xinyu/softwares/export_fig-3.38');

pic_path = '../Figure5/results_fig';
mkdir(pic_path)

color_list = [
0.996078431372549	0.850980392156863	0.690196078431373
0.984313725490196	0.505882352941176	0.450980392156863
]; 
color_list = flip(color_list);

% Fig 1c: HAMD
load('../Figure5/HAMD_HAMA_new.mat');
data = struct;
data.hamd_sub1 = HAMD_HAMA.Subtype2_HAMD;
data.hamd_sub2 = HAMD_HAMA.Subtype1_HAMD;

% 2 sample t-test.
[~, p_val, ~, stats] = ttest2(data.hamd_sub1, data.hamd_sub2);
t_val = roundn(stats.tstat, -2);
if p_val >= 0.05 
    p_annot = '{\it{p}} = N.S.';
elseif p_val >= 0.01 && p_val < 0.05
    p_annot = '{\it{p}} < 0.050';
elseif p_val >= 0.001 && p_val < 0.01
    p_annot = '{\it{p}} < 0.010';
elseif p_val < 0.001
    p_annot = '{\it{p}} < 0.001';
end

figure; hold on;
draw_violin_scatter_box_plot(data, {'hamd_sub1', 'hamd_sub2'}, 'vertical', color_list, 10);

% external settings
annotation('textbox', [0.15, 0.9, 0.1, 0.1], 'FontName', 'Aptos', 'FontSize', 30,...
    'String', ['t = ', num2str(t_val), ', ', p_annot],...
    'BackgroundColor', 'none', 'EdgeColor', 'none');

set(gcf, 'Position', [0, 0, 600, 700]);

out_fig_path = fullfile(pic_path, 'HAMD.png');
export_fig(out_fig_path, '-m4', '-q100');
close;

% Fig 1c: HAMA
load('../Figure5/HAMD_HAMA_new.mat');
data = struct;
data.hama_sub1 = HAMD_HAMA.Subtype2_HAMA;
data.hama_sub2 = HAMD_HAMA.Subtype1_HAMA;

% 2 sample t-test.
[~, p_val, ~, stats] = ttest2(data.hama_sub1, data.hama_sub2);
t_val = roundn(stats.tstat, -2);
if p_val >= 0.05 
    p_annot = '{\it{p}} = N.S.';
elseif p_val >= 0.01 && p_val < 0.05
    p_annot = '{\it{p}} < 0.050';
elseif p_val >= 0.001 && p_val < 0.01
    p_annot = '{\it{p}} < 0.010';
elseif p_val < 0.001
    p_annot = '{\it{p}} < 0.001';
end

figure; hold on;
draw_violin_scatter_box_plot(data, {'hama_sub1', 'hama_sub2'}, 'vertical', color_list, 10);

% external settings
annotation('textbox', [0.15, 0.9, 0.1, 0.1], 'FontName', 'Aptos', 'FontSize', 30,...
    'String', ['t = ', num2str(t_val), ', ', p_annot],...
    'BackgroundColor', 'none', 'EdgeColor', 'none');

set(gcf, 'Position', [0, 0, 600, 700]);

out_fig_path = fullfile(pic_path, 'HAMA.png');
export_fig(out_fig_path, '-m4', '-q100');
close;

%% Figure 5b: CTQ-test

color_list = [
0.996078431372549	0.850980392156863	0.690196078431373
0.984313725490196	0.505882352941176	0.450980392156863
];
color_list = flip(color_list);

load('../Figure5/CTQ_Group.mat');

% first confirm scale
modal_all = {'CTQ-EA', 'CTQ-EI', 'CTQ-PA', 'CTQ-PI', 'CTQ-SA', 'CTQ-T'};

figure; hold on;

for i = 1: length(modal_all)
    % subtype1
    y_data = CTQ_Group.CTQ_Sub1(:, i);

    qt25 = quantile(y_data, 0.25);
    qt75 = quantile(y_data, 0.75);
    med = median(y_data);
    outli_min=min(y_data(~isoutlier(y_data,'quartiles')));
    outli_max=max(y_data(~isoutlier(y_data,'quartiles')));

    basic_pos = i-0.2;

    b_scatter = y_data;
    a_scatter = (basic_pos+0.17.*(rand(size(y_data,1),1)-0.5).*2);
    b_qt75 = [outli_max,qt75];
    a_qt75 = ([basic_pos,basic_pos]);
    b_qt25 = [outli_min,qt25];
    a_qt25 = ([basic_pos,basic_pos]);
    b_box = [qt25,qt25,qt75,qt75];
    a_box = (basic_pos+0.15.*[-1,1,1,-1]);
    b_med = [med,med];
    a_med = ([-0.15, 0.15]+basic_pos);

    scatter(a_scatter, b_scatter, 50, 'filled',...
        'CData', color_list(1, :), 'LineWidth',1.5, 'MarkerFaceAlpha',0.75);
    
    plot(a_qt75, b_qt75, 'LineWidth', 1.5, 'Color', [0,0,0]);
    plot(a_qt25, b_qt25, 'LineWidth', 1.5, 'Color', [0,0,0]);
    fill(a_box, b_box, [1,1,1],...
        'FaceAlpha', 0, 'EdgeColor', [0, 0, 0], 'LineWidth', 1.5);
    plot(a_med, b_med, 'LineWidth', 1.5, 'Color', [0, 0, 0]);

    % subtype2
    y_data = CTQ_Group.CTQ_Sub2(:, i);

    qt25 = quantile(y_data, 0.25);
    qt75 = quantile(y_data, 0.75);
    med = median(y_data);
    outli_min=min(y_data(~isoutlier(y_data,'quartiles')));
    outli_max=max(y_data(~isoutlier(y_data,'quartiles')));

    basic_pos = i+0.2;

    b_scatter = y_data;
    a_scatter = (basic_pos+0.17.*(rand(size(y_data,1),1)-0.5).*2);
    b_qt75 = [outli_max,qt75];
    a_qt75 = ([basic_pos,basic_pos]);
    b_qt25 = [outli_min,qt25];
    a_qt25 = ([basic_pos,basic_pos]);
    b_box = [qt25,qt25,qt75,qt75];
    a_box = (basic_pos+0.15.*[-1,1,1,-1]);
    b_med = [med,med];
    a_med = ([-0.15, 0.15]+basic_pos);

    scatter(a_scatter, b_scatter, 50, 'filled',...
        'CData', color_list(2, :), 'LineWidth',1.5, 'MarkerFaceAlpha',0.75);
    
    plot(a_qt75, b_qt75, 'LineWidth', 1.5, 'Color', [0,0,0]);
    plot(a_qt25, b_qt25, 'LineWidth', 1.5, 'Color', [0,0,0]);
    fill(a_box, b_box, [1,1,1],...
        'FaceAlpha', 0, 'EdgeColor', [0, 0, 0], 'LineWidth', 1.5);
    plot(a_med, b_med, 'LineWidth', 1.5, 'Color', [0, 0, 0]);

end

set(gca, 'color', 'none'); set(gcf, 'color', 'none');
set(gca, 'FontSize', 30, 'FontName', 'Aptos');
set(gca, 'LineWidth', 2);


set(gca, 'YLim', [0, 120]);
set(gca, 'XLim', [0.25 6.75]);    
set(gcf, 'Position', [0, 0, 1200, 700]);
set(gca, 'YTick', [0, 40, 80, 120]);
set(gca, 'XTick', [1,2,3,4,5,6]);

set(gca, 'XTickLabel', {'', '', '', '', '', ''});

pic_path = '../Figure5/results_fig';
mkdir(pic_path)

out_fig_path = fullfile(pic_path, 'CTQ_test.png');
export_fig(out_fig_path, '-m4', '-q100');
close;

