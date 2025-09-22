

%% Figure 3b synergy and redundancy for subtype1 subtype2 and HC
% plotting roi-wise data onto cifti-version file.
schaefer400_roi = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');

cifti_template = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');
cifti_template = rmfield(cifti_template, {'parcels', 'parcelslabel', 'parcelsrgba'});

cifti_file_path = '../Figure3/results_cifti';
mkdir(cifti_file_path);

load('../Figure3/IDD_Statistic_group.mat');

% switch sub1 and sub2, aligning with the first manuscript
IDD_stat_sub1_hc = IDD_Statistic_group.Statics_subtype2_hc; 
IDD_stat_sub2_hc = IDD_Statistic_group.Statics_subtype1_hc;
IDD_stat_sub1_sub2 = IDD_Statistic_group.Statics_subtype2_subtype1;

max_roi_num = 400;
for modal = {'IDD_stat_sub1_hc', 'IDD_stat_sub2_hc', 'IDD_stat_sub1_sub2'}
    data = zeros(64984, 1);
    for j = 1: max_roi_num
        eval(['data(schaefer400_roi.parcels==j) = ', cell2mat(modal), '(j);']);
    end

    tmp_cifti_template = cifti_template;
    tmp_cifti_template.dscalar = data;
    ft_write_cifti(fullfile(cifti_file_path, cell2mat(modal)), tmp_cifti_template, 'parameter', 'dscalar');

end

% plotting files onto surface and plotting colorbars.
addpath('~/VDisk1/Xinyu/plot_fig_subcortex/dependencies/slanCM');
addpath(genpath('../cortical_mapper'));

cifti_file_path = '../Figure3/results_cifti';
pic_path = '../Figure3/results_fig';
mkdir(pic_path);

for modal = {'IDD_stat_sub1_hc', 'IDD_stat_sub2_hc', 'IDD_stat_sub1_sub2'}
    c_map = flip(slanCM(97, 256));

    cifti_file = fullfile(cifti_file_path, [cell2mat(modal), '.dscalar.nii']);
    create_combined_cortical_image(cifti_file, 'cmap', c_map, 'color_range', [-5, 5]);
    export_fig(fullfile(pic_path, [cell2mat(modal), '.png']), '-m4', '-q100');
    close;

    draw_colorbar(c_map);
    export_fig(fullfile(pic_path, [cell2mat(modal), '_colorbar.png']), '-q100');
    close;
end

%% Figure 3c: association - sensory axis
addpath('~/VDisk1/Xinyu/softwares/export_fig-3.38');

pic_path = '../Figure3/results_fig';
mkdir(pic_path)

color_list = [
0.764705882352941	0.552941176470588	0.768627450980392
0.996078431372549	0.850980392156863	0.690196078431373
0.984313725490196	0.505882352941176	0.450980392156863
];

% Fig 3c: association synergy 
load('../Figure3/Network_value_subty.mat');
data = struct;
data.value_sub1 = Network_value_subty.synergy_ass_group_subty1';
data.value_sub2 = Network_value_subty.synergy_ass_group_subty2';
data.value_hc = Network_value_subty.synergy_ass_group_hc';

figure; hold on;
draw_violin_box_plot_seperate(data, {'value_hc', 'value_sub2', 'value_sub1'}, 'horizontal', color_list);

out_fig_path = fullfile(pic_path, 'Synergy_Association.png');
export_fig(out_fig_path, '-m4', '-q100');
close;

% Fig 3c: association redundancy 
load('../Figure3/Network_value_subty.mat');
data = struct;
data.value_sub1 = Network_value_subty.redundancy_ass_group_subty1';
data.value_sub2 = Network_value_subty.redundancy_ass_group_subty2';
data.value_hc = Network_value_subty.redundancy_ass_group_hc';

figure; hold on;
% draw_violin_scatter_box_plot(data, {'value_hc', 'value_sub2', 'value_sub1'}, 'horizontal', color_list, 0.02);
draw_violin_box_plot_seperate(data, {'value_hc', 'value_sub2', 'value_sub1'}, 'horizontal', color_list);

out_fig_path = fullfile(pic_path, 'Redundancy_Association.png');
export_fig(out_fig_path, '-m4', '-q100');
close;

% Fig 3c: sensory synergy 
load('../Figure3/Network_value_subty.mat');
data = struct;
data.value_sub1 = Network_value_subty.synergy_sen_group_subty1';
data.value_sub2 = Network_value_subty.synergy_sen_group_subty2';
data.value_hc = Network_value_subty.synergy_sen_group_hc';

figure; hold on;
draw_violin_box_plot_seperate(data, {'value_hc', 'value_sub2', 'value_sub1'}, 'horizontal', color_list);

out_fig_path = fullfile(pic_path, 'Synergy_Sensory.png');
export_fig(out_fig_path, '-m4', '-q100');
close;

% Fig 3c: sensory redundancy 
load('../Figure3/Network_value_subty.mat');
data = struct;
data.value_sub1 = Network_value_subty.redundancy_sen_group_subty1';
data.value_sub2 = Network_value_subty.redundancy_sen_group_subty2';
data.value_hc = Network_value_subty.redundancy_sen_group_hc';

figure; hold on;
draw_violin_box_plot_seperate(data, {'value_hc', 'value_sub2', 'value_sub1'}, 'horizontal', color_list);

out_fig_path = fullfile(pic_path, 'Redundancy_Sensory.png');
export_fig(out_fig_path, '-m4', '-q100');
close;

%% Figure 3d: global properties
addpath('~/VDisk1/Xinyu/softwares/export_fig-3.38');

pic_path = '../Figure3/results_fig';
mkdir(pic_path)

color_list = [
0.764705882352941	0.552941176470588	0.768627450980392
0.996078431372549	0.850980392156863	0.690196078431373
0.984313725490196	0.505882352941176	0.450980392156863
];

% Fig 3d: Synergy modularity
load('../Figure3/Network_properties_subty.mat');
data = struct;
data.value_sub1 = Network_properties_subty.synergy_Q_subty2';
data.value_sub2 = Network_properties_subty.synergy_Q_subty1';
data.value_hc = Network_properties_subty.synergy_Q_hc';

figure; hold on;
draw_violin_box_plot_seperate(data, {'value_hc', 'value_sub2', 'value_sub1'}, 'horizontal', color_list);

set(gca, 'XLim', [0.002, 0.125]);
set(gca, 'XTick', [0.02, 0.06, 0.1]);

out_fig_path = fullfile(pic_path, 'Synergy_Modularity.png');
export_fig(out_fig_path, '-m4', '-q100');
close;

[~, p] = ttest2(data.value_sub1, data.value_sub2); fprintf(['sub1-sub2 p = ', num2str(p), '\n']);
[~, p] = ttest2(data.value_sub1, data.value_hc); fprintf(['sub1-hc p = ', num2str(p), '\n']);
[~, p] = ttest2(data.value_sub2, data.value_hc); fprintf(['sub2-hc p = ', num2str(p), '\n']);

% Fig 3d: Redundancy modularity
load('../Figure3/Network_properties_subty.mat');
data = struct;
data.value_sub1 = Network_properties_subty.redundancy_Q_subty2';
data.value_sub2 = Network_properties_subty.redundancy_Q_subty1';
data.value_hc = Network_properties_subty.redundancy_Q_hc';

figure; hold on;
draw_violin_box_plot_seperate(data, {'value_hc', 'value_sub2', 'value_sub1'}, 'horizontal', color_list);

out_fig_path = fullfile(pic_path, 'Redundancy_Modularity.png');
export_fig(out_fig_path, '-m4', '-q100');
close;

[~, p] = ttest2(data.value_sub1, data.value_sub2); fprintf(['sub1-sub2 p = ', num2str(p), '\n']);
[~, p] = ttest2(data.value_sub1, data.value_hc); fprintf(['sub1-hc p = ', num2str(p), '\n']);
[~, p] = ttest2(data.value_sub2, data.value_hc); fprintf(['sub2-hc p = ', num2str(p), '\n']);

% Fig 3d: Synergy efficiency
load('../Figure3/Network_properties_subty.mat');
data = struct;
data.value_sub1 = Network_properties_subty.synergy_Eglob_subty2';
data.value_sub2 = Network_properties_subty.synergy_Eglob_subty1';
data.value_hc = Network_properties_subty.synergy_Eglob_hc';

figure; hold on;
draw_violin_box_plot_seperate(data, {'value_hc', 'value_sub2', 'value_sub1'}, 'horizontal', color_list);

out_fig_path = fullfile(pic_path, 'Synergy_Efficiency.png');
export_fig(out_fig_path, '-m4', '-q100');
close;

[~, p] = ttest2(data.value_sub1, data.value_sub2); fprintf(['sub1-sub2 p = ', num2str(p), '\n']);
[~, p] = ttest2(data.value_sub1, data.value_hc); fprintf(['sub1-hc p = ', num2str(p), '\n']);
[~, p] = ttest2(data.value_sub2, data.value_hc); fprintf(['sub2-hc p = ', num2str(p), '\n']);

% Fig 3d: Redundancy efficiency
load('../Figure3/Network_properties_subty.mat');
data = struct;
data.value_sub1 = Network_properties_subty.redundancy_Eglob_subty2';
data.value_sub2 = Network_properties_subty.redundancy_Eglob_subty1';
data.value_hc = Network_properties_subty.redundancy_Eglob_hc';

figure; hold on;
draw_violin_box_plot_seperate(data, {'value_hc', 'value_sub2', 'value_sub1'}, 'horizontal', color_list);

set(gca, 'XLim', [0.03, 0.12]);

out_fig_path = fullfile(pic_path, 'Redundancy_Efficiency.png');
export_fig(out_fig_path, '-m4', '-q100');
close;

[~, p] = ttest2(data.value_sub1, data.value_sub2); fprintf(['sub1-sub2 p = ', num2str(p), '\n']);
[~, p] = ttest2(data.value_sub1, data.value_hc); fprintf(['sub1-hc p = ', num2str(p), '\n']);
[~, p] = ttest2(data.value_sub2, data.value_hc); fprintf(['sub2-hc p = ', num2str(p), '\n']);
