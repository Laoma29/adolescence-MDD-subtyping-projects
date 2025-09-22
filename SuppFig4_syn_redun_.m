%% Supp Fig 4: synergy and redundancy for subtype1 subtype2 and HC
% plotting roi-wise data onto cifti-version file.
schaefer400_roi = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');

cifti_template = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');
cifti_template = rmfield(cifti_template, {'parcels', 'parcelslabel', 'parcelsrgba'});

cifti_file_path = '../SuppFig4/results_cifti';
mkdir(cifti_file_path);

load('../Figure3/IDD_Statistic_group.mat');
Syn_Redun_Grad_sub1 = IDD_Statistic_group.gradient_subtype2_ave;
Syn_Redun_Grad_sub2 = IDD_Statistic_group.gradient_subtype1_ave;
Syn_Redun_Grad_hc = IDD_Statistic_group.gradient_hc_ave;

max_roi_num = 400;
for modal = {'Syn_Redun_Grad_sub1', 'Syn_Redun_Grad_sub2', 'Syn_Redun_Grad_hc'}
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

cifti_file_path = '../SuppFig4/results_cifti';
pic_path = '../SuppFig4/results_fig';
mkdir(pic_path);

for modal = {'Syn_Redun_Grad_sub1', 'Syn_Redun_Grad_sub2', 'Syn_Redun_Grad_hc'}
    c_map = slanCM(2, 256);

    cifti_file = fullfile(cifti_file_path, [cell2mat(modal), '.dscalar.nii']);
    create_combined_cortical_image(cifti_file, 'cmap', c_map, 'color_range', [-380, 370]);
    export_fig(fullfile(pic_path, [cell2mat(modal), '.png']), '-m4', '-q100');
    close;

    draw_colorbar(c_map);
    export_fig(fullfile(pic_path, [cell2mat(modal), '_colorbar.png']), '-q100');
    close;
end

%% correlations with functional gradients

% associations with functional hierarchy
addpath(genpath('~/VDisk1/Xinyu/softwares/ENIGMA-master/matlab'));
addpath(genpath('~/VDisk1/Xinyu/softwares/BrainSpace-0.1.2/matlab/'));
addpath('~/VDisk1/Xinyu/softwares/export_fig-3.38');

load('../Figure3/IDD_Statistic_group.mat');
Syn_Redun_Grad_sub1 = IDD_Statistic_group.gradient_subtype2_ave;
Syn_Redun_Grad_sub2 = IDD_Statistic_group.gradient_subtype1_ave;
Syn_Redun_Grad_hc = IDD_Statistic_group.gradient_hc_ave;

load('../Figure4/Age_effect_data_group.mat');
Func_Grad = Age_effect_data_group.Functional_Gradient_template;

pic_path = '../SuppFig4/results_fig';
mkdir(pic_path)

for modal = {'Syn_Redun_Grad_sub1', 'Syn_Redun_Grad_sub2', 'Syn_Redun_Grad_hc'}
    y = Func_Grad(:, 2);
    eval(['x = ', cell2mat(modal), '(:);']);

    % enigma style
    r_val = roundn(corr(x, y, 'type', 'Spearman'), -2); 
    p_val = roundn(spin_test(x, y, 'parcellation_name', 'schaefer_400', 'n_rot', 1000, 'type', 'spearman'), -2);
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

    out_fig_path = fullfile(pic_path, [cell2mat(modal), '_Func_Grad1.png']);
    export_fig(out_fig_path, '-m2', '-q100');
    close;


end

