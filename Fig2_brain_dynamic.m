
%% Figure 2: 
addpath('~/VDisk1/Xinyu/softwares/export_fig-3.38');

pic_path = '../Figure2/results_fig';
mkdir(pic_path)

color_list = [
0.764705882352941	0.552941176470588	0.768627450980392
0.996078431372549	0.850980392156863	0.690196078431373
0.984313725490196	0.505882352941176	0.450980392156863
];
color_list = flip(color_list);

% Fig 1c: dispersion
load('../Figure2/GCA_BILI.mat')
data = struct;
data.brain_dyn_sub1 = GCA_BILI.GCA_subtype22;
data.brain_dyn_sub2 = GCA_BILI.GCA_subtype11;
data.brain_dyn_hc = GCA_BILI.GCA_HC;

figure; hold on;
draw_violin_scatter_box_plot(data, {'brain_dyn_sub1', 'brain_dyn_sub2', 'brain_dyn_hc'}, 'vertical', color_list, 0.4);

% external settings
set(gca, 'YLim', [0, 3]);
set(gca, 'YTick', [0, 1, 2, 3]); 
set(gcf, 'Position', [0, 0, 700, 800]);

out_fig_path = fullfile(pic_path, 'Brain_dynamic.png');
export_fig(out_fig_path, '-m4', '-q100');
close;


