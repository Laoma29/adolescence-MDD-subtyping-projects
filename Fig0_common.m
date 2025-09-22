
%% example illustration for networks.

% plotting roi-wise data onto cifti-version file.
schaefer400_roi = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');

cifti_template = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');
cifti_template = rmfield(cifti_template, {'parcels', 'parcelslabel', 'parcelsrgba'});

cifti_file_path = '../Figure0/results_cifti';
mkdir(cifti_file_path);

load('/home/xinyu/VDisk1/Xinyu/2025_adolescent_subtype_mdd_redraw/Figure4/Age_effect_data_group.mat');

% switch sub1 and sub2
Func_Grad = Age_effect_data_group.Functional_Gradient_template;

max_roi_num = 400;
for modal = {'Func_Grad'}
    for i = 1:3
        data = zeros(64984, 1);
        for j = 1: max_roi_num
            eval(['data(schaefer400_roi.parcels==j) = ', cell2mat(modal), '(j, i);']);
        end
    
        tmp_cifti_template = cifti_template;
        tmp_cifti_template.dscalar = data;
        ft_write_cifti(fullfile(cifti_file_path, [cell2mat(modal), num2str(i)]), tmp_cifti_template, 'parameter', 'dscalar');
        
        tmp_cifti_template = cifti_template;
        tmp_cifti_template.dscalar = data;
        tmp_cifti_template.dscalar(tmp_cifti_template.dscalar < 0) = 0;
        ft_write_cifti(fullfile(cifti_file_path, [cell2mat(modal), num2str(i), '_pos']), tmp_cifti_template, 'parameter', 'dscalar');
        
        tmp_cifti_template = cifti_template;
        tmp_cifti_template.dscalar = data;
        tmp_cifti_template.dscalar(tmp_cifti_template.dscalar > 0) = 0;
        ft_write_cifti(fullfile(cifti_file_path, [cell2mat(modal), num2str(i), '_neg']), tmp_cifti_template, 'parameter', 'dscalar');
    end
end

% plotting files onto surface and plotting colorbars.
addpath('~/VDisk1/Xinyu/plot_fig_subcortex/dependencies/slanCM');
addpath(genpath('../cortical_mapper'));

cifti_file_path = '../Figure0/results_cifti';
pic_path = '../Figure0/results_fig';
mkdir(pic_path);

for modal = {'Func_Grad'}
    for i = 1:3
        c_map = flip(slanCM(100, 256));
        c_map_pos = c_map(129:256, :);
        c_map_neg = c_map(1:128, :);
    
        cifti_file = fullfile(cifti_file_path, [cell2mat(modal), num2str(i), '.dscalar.nii']);
        create_combined_cortical_image(cifti_file, 'cmap', c_map);
        export_fig(fullfile(pic_path, [cell2mat(modal), num2str(i), '.png']), '-m4', '-q100');
        close;

        cifti_file = fullfile(cifti_file_path, [cell2mat(modal), num2str(i), '_pos.dscalar.nii']);
        create_combined_cortical_image(cifti_file, 'cmap', c_map_pos);
        export_fig(fullfile(pic_path, [cell2mat(modal), num2str(i), '_pos.png']), '-m4', '-q100');
        close;

        cifti_file = fullfile(cifti_file_path, [cell2mat(modal), num2str(i), '_neg.dscalar.nii']);
        create_combined_cortical_image(cifti_file, 'cmap', c_map_neg);
        export_fig(fullfile(pic_path, [cell2mat(modal), num2str(i), '_neg.png']), '-m4', '-q100');
        close;
    end

    draw_colorbar(c_map);
    export_fig(fullfile(pic_path, [cell2mat(modal), '_colorbar.png']), '-q100');
    close;
end

