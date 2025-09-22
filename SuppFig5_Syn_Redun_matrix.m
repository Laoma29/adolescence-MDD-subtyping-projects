%% Supp Fig5a: Synergy matrix
addpath('~/VDisk1/Xinyu/plot_fig_subcortex/dependencies/slanCM');

pic_path = '../SuppFig5/results_fig';
mkdir(pic_path);

c_map = slanCM(2, 256);

load('../Figure4/Age_effect_data_group.mat')
sa_axis = Age_effect_data_group.Functional_Gradient_template(:, 2);
[~, sa_axis_order] = sort(sa_axis);

load('../Figure3/Network_value_subty.mat')
Syn_mat_sub1 = Network_value_subty.synergy_mat_group_subty1(sa_axis_order, sa_axis_order);
Syn_mat_sub2 = Network_value_subty.synergy_mat_group_subty2(sa_axis_order, sa_axis_order);
Syn_mat_hc = Network_value_subty.synergy_mat_group_hc(sa_axis_order, sa_axis_order);

for modal = {'Syn_mat_sub1', 'Syn_mat_sub2', 'Syn_mat_hc'}
    eval(['sim_mat = ' cell2mat(modal), ';']);
    imshow(sim_mat, [0.6, 0.9]);
    
    colormap(c_map);
    set(gca, 'color', 'none'); set(gcf, 'color', 'none');
    
    out_fig_path = fullfile(pic_path, [cell2mat(modal), '.png']);
    export_fig(out_fig_path, '-m4', '-q100');
    close;
end

draw_colorbar(c_map);
export_fig(fullfile(pic_path, 'Synergy_mat_colorbar.png'), '-q100');
close;

%% Supp Fig 5a: Synergy map
% plotting roi-wise data onto cifti-version file.
schaefer400_roi = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');

cifti_template = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');
cifti_template = rmfield(cifti_template, {'parcels', 'parcelslabel', 'parcelsrgba'});

cifti_file_path = '../SuppFig5/results_cifti';
mkdir(cifti_file_path);

load('../Figure3/Network_value_subty.mat')
Syn_map_sub1 = Network_value_subty.synergy_map_group_subty1;
Syn_map_sub2 = Network_value_subty.synergy_map_group_subty2;
Syn_map_hc = Network_value_subty.synergy_map_group_hc;

max_roi_num = 400;
for modal = {'Syn_map_sub1', 'Syn_map_sub2', 'Syn_map_hc'}
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

cifti_file_path = '../SuppFig5/results_cifti';
pic_path = '../SuppFig5/results_fig';
mkdir(pic_path);

for modal = {'Syn_map_sub1', 'Syn_map_sub2', 'Syn_map_hc'}
    c_map = slanCM(2, 256);

    cifti_file = fullfile(cifti_file_path, [cell2mat(modal), '.dscalar.nii']);
    create_combined_cortical_image(cifti_file, 'cmap', c_map, 'color_range', [0.6, 0.9]);
    export_fig(fullfile(pic_path, [cell2mat(modal), '.png']), '-m4', '-q100');
    close;
end

c_map = slanCM(2, 256);
draw_colorbar(c_map);
export_fig(fullfile(pic_path,  'Synergy_map_colorbar.png'), '-q100');
close;


%% Supp Fig5b: Redundancy matrix
addpath('~/VDisk1/Xinyu/plot_fig_subcortex/dependencies/slanCM');

pic_path = '../SuppFig5/results_fig';
mkdir(pic_path);

c_map = slanCM(2, 256);

load('../Figure4/Age_effect_data_group.mat')
sa_axis = Age_effect_data_group.Functional_Gradient_template(:, 2);
[~, sa_axis_order] = sort(sa_axis);

load('../Figure3/Network_value_subty.mat')
Redun_mat_sub1 = Network_value_subty.redundancy_mat_group_subty1(sa_axis_order, sa_axis_order);
Redun_mat_sub2 = Network_value_subty.redundancy_mat_group_subty2(sa_axis_order, sa_axis_order);
Redun_mat_hc = Network_value_subty.redundancy_mat_group_hc(sa_axis_order, sa_axis_order);

for modal = {'Redun_mat_sub1', 'Redun_mat_sub2', 'Redun_mat_hc'}
    eval(['sim_mat = ' cell2mat(modal), ';']);
    imshow(sim_mat, [0.01, 0.05]);
    
    colormap(c_map);
    set(gca, 'color', 'none'); set(gcf, 'color', 'none');
    
    out_fig_path = fullfile(pic_path, [cell2mat(modal), '.png']);
    export_fig(out_fig_path, '-m4', '-q100');
    close;
end

draw_colorbar(c_map);
export_fig(fullfile(pic_path, 'Redundency_mat_colorbar.png'), '-q100');
close;

%% Supp Fig 5b: Redundancy map
% plotting roi-wise data onto cifti-version file.
schaefer400_roi = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');

cifti_template = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');
cifti_template = rmfield(cifti_template, {'parcels', 'parcelslabel', 'parcelsrgba'});

cifti_file_path = '../SuppFig5/results_cifti';
mkdir(cifti_file_path);

load('../Figure3/Network_value_subty.mat')
Redun_map_sub1 = Network_value_subty.redundancy_map_group_subty1;
Redun_map_sub2 = Network_value_subty.redundancy_map_group_subty2;
Redun_map_hc = Network_value_subty.redundancy_map_group_hc;

max_roi_num = 400;
for modal = {'Redun_map_sub1', 'Redun_map_sub2', 'Redun_map_hc'}
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

cifti_file_path = '../SuppFig5/results_cifti';
pic_path = '../SuppFig5/results_fig';
mkdir(pic_path);

for modal = {'Redun_map_sub1', 'Redun_map_sub2', 'Redun_map_hc'}
    c_map = slanCM(2, 256);

    cifti_file = fullfile(cifti_file_path, [cell2mat(modal), '.dscalar.nii']);
    create_combined_cortical_image(cifti_file, 'cmap', c_map, 'color_range', [0.01, 0.05]);
    export_fig(fullfile(pic_path, [cell2mat(modal), '.png']), '-m4', '-q100');
    close;
end    
   
c_map = slanCM(2, 256);
draw_colorbar(c_map);
export_fig(fullfile(pic_path,  'Redundency_map_colorbar.png'), '-q100');
close;
