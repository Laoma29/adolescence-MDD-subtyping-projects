%% Supp Fig 6: significant age effect
% plotting roi-wise data onto cifti-version file.
schaefer400_roi = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');

cifti_template = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');
cifti_template = rmfield(cifti_template, {'parcels', 'parcelslabel', 'parcelsrgba'});

cifti_file_path = '../SuppFig6/results_cifti';
mkdir(cifti_file_path);

load('../Figure4/Age_effect_data_group.mat');
Age_effect_sub1 = Age_effect_data_group.Age_effect_subtype2_Thre; 
Age_effect_sub2 = Age_effect_data_group.Age_effect_subtype1_Thre; 
Age_effect_hc = Age_effect_data_group.Age_effect_HC_Thre; 

max_roi_num = 400;
for modal = {'Age_effect_sub1', 'Age_effect_sub2', 'Age_effect_hc'}
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

cifti_file_path = '../SuppFig6/results_cifti';
pic_path = '../SuppFig6/results_fig';
mkdir(pic_path);

for modal = {'Age_effect_sub1', 'Age_effect_sub2', 'Age_effect_hc'}
    c_map = flip(slanCM(97, 256));

    cifti_file = fullfile(cifti_file_path, [cell2mat(modal), '.dscalar.nii']);
    create_combined_cortical_image(cifti_file, 'cmap', c_map, 'color_range', [-0.3, 0.3]);
    export_fig(fullfile(pic_path, [cell2mat(modal), '.png']), '-m4', '-q100');
    close;


end

c_map = flip(slanCM(97, 256));
draw_colorbar(c_map);
export_fig(fullfile(pic_path, 'Significant_age_effect_colorbar.png'), '-q100');
close;

%% correlations with functional gradients

% associations with functional hierarchy
addpath(genpath('~/VDisk1/Xinyu/softwares/ENIGMA-master/matlab'));
addpath(genpath('~/VDisk1/Xinyu/softwares/BrainSpace-0.1.2/matlab/'));
addpath('~/VDisk1/Xinyu/softwares/export_fig-3.38');

load('../Figure4/Age_effect_data_group.mat');
Grad_sub1 = Age_effect_data_group.gradient1_subtype2;
Grad_sub2 = Age_effect_data_group.gradient1_subtype1;
Grad_hc = Age_effect_data_group.gradient1_HC;

load('../Figure4/Age_effect_data_group.mat');
Age_sub1 = Age_effect_data_group.Age_subtype2;
Age_sub2 = Age_effect_data_group.Age_subtype1;
Age_hc = Age_effect_data_group.Age_HC;

pic_path = '../SuppFig6/results_fig';
mkdir(pic_path)

for modal = {'sub1', 'sub2', 'hc'}
    eval(['x = Grad_', cell2mat(modal), '(:);']);
    eval(['y = Age_', cell2mat(modal), '(:);']);

    % enigma style
    [r_val, p_val] = corr(x, y, 'type', 'Spearman');
    r_val = roundn(r_val, -2);
    % p_val = roundn(spin_test(x, y, 'parcellation_name', 'schaefer_400', 'n_rot', 1000, 'type', 'spearman'), -2);
    if p_val < 0.001
        p_annot = 'p < 0.001';
    else
        p_annot = ['p = ', num2str(p_val)];
    end

    p = polyfit(x, y, 1);
    f = polyval(p, x);

    hold("on");
    scatter(x, y, 500, [0.5, 0.5, 0.5], 'fill', 'MarkerFaceAlpha', 0.5, 'MarkerEdgeAlpha', 0.5);
    plot(x, f, 'Color', [0,0,0], 'LineWidth', 3);
%     annotation('textbox', [0.15, 0.9, 0.1, 0.1], 'FontName', 'Aptos', 'FontSize', 35,...
%         'String', ['Spearman''s r = ', num2str(r_val), ', ', p_annot],...
%         'BackgroundColor', 'none', 'EdgeColor', 'none');

    fprintf(['Spearman''s r = ', num2str(r_val), ', ', p_annot]);

    % better visual effects.
    set(gcf, 'Position', [0, 0, 1100, 800]);
    set(gca, 'color', 'none'); set(gcf, 'color', 'none');
    set(gca, 'YLim', [1.05*min(y)-0.05*max(y), 1.05*max(y)-0.05*min(y)]);
    set(gca, 'XLim', [1.05*min(x)-0.05*max(x), 1.05*max(x)-0.05*min(x)]);
    set(gca, 'FontSize', 35, 'FontName', 'Aptos');
    set(gca, 'LineWidth', 2);

    out_fig_path = fullfile(pic_path, ['Grad1_', cell2mat(modal), '_Age_', cell2mat(modal), '.png']);
    export_fig(out_fig_path, '-m2', '-q100');
    close;


end

