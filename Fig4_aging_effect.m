%% Figure 4 functional gradients for subtype1 subtype2 and HC
% plotting roi-wise data onto cifti-version file.
schaefer400_roi = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');

cifti_template = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');
cifti_template = rmfield(cifti_template, {'parcels', 'parcelslabel', 'parcelsrgba'});

cifti_file_path = '../Figure4/results_cifti';
mkdir(cifti_file_path);

load('../Figure4/Age_effect_data_group.mat');

% switch sub1 and sub2
Age_effect_sub1 = Age_effect_data_group.Age_effect_subtype2; 
Age_effect_sub2 = Age_effect_data_group.Age_effect_subtype1; 
Age_effect_hc = Age_effect_data_group.Age_effect_HC; 

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

cifti_file_path = '../Figure4/results_cifti';
pic_path = '../Figure4/results_fig';
mkdir(pic_path);

for modal = {'Age_effect_sub1', 'Age_effect_sub2', 'Age_effect_hc'}
    c_map = flip(slanCM(97, 256));

    cifti_file = fullfile(cifti_file_path, [cell2mat(modal), '.dscalar.nii']);
    create_combined_cortical_image(cifti_file, 'cmap', c_map, 'color_range', [-0.3, 0.3]);
    export_fig(fullfile(pic_path, [cell2mat(modal), '.png']), '-m4', '-q100');
    close;

    draw_colorbar(c_map);
    export_fig(fullfile(pic_path, [cell2mat(modal), '_colorbar.png']), '-q100');
    close;
end

% associations with functional hierarchy
addpath(genpath('~/VDisk1/Xinyu/softwares/ENIGMA-master/matlab'));
addpath(genpath('~/VDisk1/Xinyu/softwares/BrainSpace-0.1.2/matlab/'));
addpath('~/VDisk1/Xinyu/softwares/export_fig-3.38');

Func_Grad = Age_effect_data_group.Functional_Gradient_template;

pic_path = '../Figure4/results_fig';
mkdir(pic_path)

for modal = {'Age_effect_sub1', 'Age_effect_sub2', 'Age_effect_hc'}
    for i = 1: 3
        x = Func_Grad(:, i);
        eval(['y = ', cell2mat(modal), '(:);']);

        % enigma style
        r_val = roundn(corr(x, y, 'type', 'Spearman'), -2); 
        p_val = roundn(spin_test(x, y, 'parcellation_name', 'schaefer_400', 'n_rot', 1000, 'type', 'spearman'), -2);
%         if p_val >= 0.05 
%             p_annot = '{\it{p}} = N.S.';
%         elseif p_val >= 0.01 && p_val < 0.05
%             p_annot = '{\it{p}} < 0.05';
%         elseif p_val >= 0.001 && p_val < 0.01
%             p_annot = '{\it{p}} < 0.01';
%         elseif p_val < 0.001
%             p_annot = '{\it{p}} < 0.001';
%         end
        if p_val < 0.001
            p_annot = '{\it{P}} < 0.001';
        else
            p_annot = ['{\it{P}} = ', num2str(p_val)];
        end

        p = polyfit(x, y, 1);
        f = polyval(p, x);

        hold("on");
        scatter(x, y, 500, [0.5, 0.5, 0.5], 'fill', 'MarkerFaceAlpha', 0.5, 'MarkerEdgeAlpha', 0.5);
        plot(x, f, 'Color', [0,0,0], 'LineWidth', 3);
%         annotation('textbox', [0.15, 0.9, 0.1, 0.1], 'FontName', 'Aptos', 'FontSize', 35,...
%             'String', ['Spearman''s r = ', num2str(r_val), ', ', p_annot],...
%             'BackgroundColor', 'none', 'EdgeColor', 'none');

        % better visual effects.
        set(gcf, 'Position', [0, 0, 1100, 800]);
        set(gca, 'color', 'none'); set(gcf, 'color', 'none');
        set(gca, 'YLim', [1.05*min(y)-0.05*max(y), 1.05*max(y)-0.05*min(y)]);
        set(gca, 'XLim', [1.05*min(x)-0.05*max(x), 1.05*max(x)-0.05*min(x)]);
        set(gca, 'FontSize', 35, 'FontName', 'Aptos');
        set(gca, 'LineWidth', 2);
        ax = gca;
        ax.XRuler.TickLabelGapOffset = 25;
        ax.YRuler.TickLabelGapOffset = 40;
        
        % x_axis colorbar
        ax1 = axes('Position', ax.Position, 'Color', 'none', 'Visible', 'off');
        colormap(ax1, flip(slanCM(100, 256)));
        cb1 = colorbar(ax1, 'southoutside', 'Ticks', []);
        barwidth = cb1.Position(4)*2;
        cb1.Position = [ax.Position(1), ax.Position(2)-barwidth, ax.Position(3), barwidth]; % position based on main axis
        
        % y_axis colorbar
        ax2 = axes('Position', ax.Position, 'Color', 'none', 'Visible', 'off');
        colormap(ax2, flip(slanCM(97, 256)));
        cb2 = colorbar(ax2, 'westoutside', 'Ticks', []);
        barwidth = cb2.Position(3)*2;
        cb2.Position = [ax.Position(1)-barwidth, ax.Position(2), barwidth, ax.Position(4)]; % position based on main axis

        out_fig_path = fullfile(pic_path, [cell2mat(modal), '_Func_Grad', num2str(i), '.png']);
        export_fig(out_fig_path, '-m2', '-q100');
        close;
    
    end

end
