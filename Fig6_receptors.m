
%% Figure 6a example receptor maps, using interpolation of schaefer200 -> schaefer400
% plotting roi-wise data onto cifti-version file.
schaefer200_roi = ft_read_cifti('Schaefer2018_200Parcels_7Networks_order.dlabel.nii');
schaefer400_roi = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');

cifti_template = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');
cifti_template = rmfield(cifti_template, {'parcels', 'parcelslabel', 'parcelsrgba'});

cifti_file_path = '../Figure6/results_cifti';
mkdir(cifti_file_path);

load('../Figure6/Receptor_map_Schaefer200.mat');
receptor_map = zscore(Receptor_map.receptor_map200);
receptor_name = Receptor_map.receptor_name;
receptor_map400 = zeros(400, length(receptor_name));

for i = 1: length(receptor_name)
    data_200roi = zeros(64984, 1);
    data_400roi = zeros(64984, 1);
    for j = 1: 200
        data_200roi(schaefer200_roi.parcels==j) = receptor_map(j, i);
    end
    for j = 1: 400
        receptor_map400(j, i) = mean(data_200roi(schaefer400_roi.parcels==j));
        data_400roi(schaefer400_roi.parcels==j) = mean(data_200roi(schaefer400_roi.parcels==j));
    end
    
    tmp_cifti_template = cifti_template;
    tmp_cifti_template.dscalar = data_400roi;
    ft_write_cifti(fullfile(cifti_file_path, receptor_name{i}), tmp_cifti_template, 'parameter', 'dscalar');

end

% plotting files onto surface and plotting colorbars.
addpath('~/VDisk1/Xinyu/plot_fig_subcortex/dependencies/slanCM');
addpath(genpath('../cortical_mapper'));

cifti_file_path = '../Figure6/results_cifti';
pic_path = '../Figure6/results_fig';
mkdir(pic_path);

for i = 1: length(receptor_name)
    c_map = slanCM(3, 256);

    cifti_file = fullfile(cifti_file_path, [receptor_name{i}, '.dscalar.nii']);
    create_combined_cortical_image(cifti_file, 'cmap', c_map);
    export_fig(fullfile(pic_path, [receptor_name{i}, '.png']), '-m4', '-q100');
    close;

    draw_colorbar(c_map);
    export_fig(fullfile(pic_path, [receptor_name{i}, '_colorbar.png']), '-q100');
    close;
end

rmfield(Receptor_map, 'receptor_map200');
Receptor_map.receptor_map400 = receptor_map400;
save('../Figure6/Receptor_map_Schaefer400.mat', "Receptor_map");


%% Figure 6a: receptor heatmap using existing data.
addpath('~/VDisk1/Xinyu/plot_fig_subcortex/dependencies/slanCM');
addpath('~/VDisk1/Xinyu/plot_fig_subcortex/dependencies/export_fig');
addpath(genpath('~/VDisk1/Xinyu/softwares/ENIGMA-master/matlab'));


% load
load('../Figure6/receptor_and_gene.mat');
receptor_name = receptor_and_gene.DK_receptor_name;
Func_reorg_name = {'Subtype1', 'Subtype2'};

corr_results = zeros(2, length(receptor_name));
corr_results(1, :) = receptor_and_gene.subtype_coef2;
corr_results(2, :) = receptor_and_gene.subtype_coef1;

figure;
heatmap(receptor_name, Func_reorg_name, corr_results, CellLabelColor="none", ColorLimits=[-1, 1], FontName='Aptos');
c_map = slanCM(103, 256);
colormap(c_map);

set(gcf, 'Position', [0, 0, 1800, 165]);
set(gcf, 'color', 'none');

pic_path = '../Figure6/results_fig';
mkdir(pic_path);

export_fig(fullfile(pic_path, 'Func_reorg_Receptor_Heatmap.png'), '-m6', '-q100');
close;

% plotting colorbar
addpath('~/VDisk1/Xinyu/plot_fig_subcortex/dependencies/slanCM');
addpath(genpath('../cortical_mapper'));

pic_path = '../Figure6/results_fig';
mkdir(pic_path);

c_map = slanCM(103, 256);

draw_colorbar(c_map);
export_fig(fullfile(pic_path, 'Func_reorg_receptor_heatmap_colorbar.png'), '-q100');
close;

%% Figure 6a: receptor heatmap recalculate
addpath('~/VDisk1/Xinyu/plot_fig_subcortex/dependencies/slanCM');
addpath('~/VDisk1/Xinyu/plot_fig_subcortex/dependencies/export_fig');
addpath(genpath('~/VDisk1/Xinyu/softwares/ENIGMA-master/matlab'));

load('../Figure6/T_value_map.mat');
Func_reorg = zeros(400, 2);
Func_reorg(:, 1) = T_value_map.stats_sub2.tstat;
Func_reorg(:, 2) = T_value_map.stats_sub1.tstat;

load('../Figure6/Receptor_map_Schaefer400.mat');
receptor_map = Receptor_map.receptor_map400;

receptor_name = Receptor_map.receptor_name;
Func_reorg_name = {'Subtype1', 'Subtype2'};

% check Spearman's r and its significance
corr_results = zeros(2, length(receptor_name));
p_results = zeros(2, length(receptor_name));
for i = 1: length(Func_reorg_name)
    for j = 1: length(receptor_name)
        x = Func_reorg(:, i);
        y = receptor_map(:, j);
        corr_results(i, j) = corr(x, y, 'type', 'Spearman');
        p_results(i, j) = roundn(spin_test(x, y, 'parcellation_name', 'schaefer_400', 'n_rot', 1000, 'type', 'spearman'), -2);
    end
end

% fdr correction
[~, ~, p_results_adj] = fdr(p_results(:));
p_results_adj = reshape(p_results_adj, 2, length(receptor_name));

figure;
heatmap(receptor_name, Func_reorg_name, corr_results, CellLabelColor="none", ColorLimits=[-1, 1], FontName='Aptos');
c_map = slanCM(103, 256);
colormap(c_map);

set(gcf, 'Position', [0, 0, 1800, 165]);
set(gcf, 'color', 'none');

pic_path = '../Figure6/results_fig';
mkdir(pic_path);

export_fig(fullfile(pic_path, 'Func_reorg_Receptor_Heatmap.png'), '-m6', '-q100');
close;

% plotting colorbar
addpath('~/VDisk1/Xinyu/plot_fig_subcortex/dependencies/slanCM');
addpath(genpath('../cortical_mapper'));

pic_path = '../Figure6/results_fig';
mkdir(pic_path);

c_map = slanCM(103, 256);

draw_colorbar(c_map);
export_fig(fullfile(pic_path, 'Func_reorg_receptor_heatmap_colorbar.png'), '-q100');
close;
