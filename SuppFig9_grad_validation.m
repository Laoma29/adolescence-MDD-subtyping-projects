%% Supp Fig 9: validation (another clu) gradient for subtype1 subtype2 and HC
% plotting roi-wise data onto cifti-version file.
schaefer400_roi = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');

cifti_template = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');
cifti_template = rmfield(cifti_template, {'parcels', 'parcelslabel', 'parcelsrgba'});

cifti_file_path = '../SuppFig9/results_cifti';
mkdir(cifti_file_path);

% switch sub1 and sub2, aligning with the first manuscript
load('../SuppFig9/FG_Subtypes_statitsc_otherclu.mat');
Func_Grad_sub1 = FG_Subtypes_statitsc_otherclu.depression_subtype_ave2; 
Func_Grad_sub2 = FG_Subtypes_statitsc_otherclu.depression_subtype_ave1; 
Func_Grad_hc = FG_Subtypes_statitsc_otherclu.graident1_depression_HC_ave; 

max_roi_num = 400;
for modal = {'Func_Grad_sub1', 'Func_Grad_sub2', 'Func_Grad_hc'}
    data = zeros(64984, 1);
    for j = 1: max_roi_num
        eval(['data(schaefer400_roi.parcels==j) = ', cell2mat(modal), '(j);']);
    end

    tmp_cifti_template = cifti_template;
    tmp_cifti_template.dscalar = data;
    ft_write_cifti(fullfile(cifti_file_path, [cell2mat(modal), '_otherclu']), tmp_cifti_template, 'parameter', 'dscalar');

end

% plotting files onto surface and plotting colorbars.
addpath('~/VDisk1/Xinyu/plot_fig_subcortex/dependencies/slanCM');
addpath(genpath('../cortical_mapper'));

cifti_file_path = '../SuppFig9/results_cifti';
pic_path = '../SuppFig9/results_fig';
mkdir(pic_path);

for modal = {'Func_Grad_sub1', 'Func_Grad_sub2', 'Func_Grad_hc'}
    c_map = flip(slanCM(95, 256));

    cifti_file = fullfile(cifti_file_path, [cell2mat(modal), '_otherclu.dscalar.nii']);
    create_combined_cortical_image(cifti_file, 'cmap', c_map, 'color_range', [-0.9, 0.9]);
    export_fig(fullfile(pic_path, [cell2mat(modal), '_otherclu.png']), '-m4', '-q100');
    close;

    draw_colorbar(c_map);
    export_fig(fullfile(pic_path, [cell2mat(modal), '_otherclu_colorbar.png']), '-q100');
    close;
end

%% Supp Fig 9: validation (another clu) functional reorganization for subtype1 subtype2 and HC

% plotting roi-wise data onto cifti-version file.
schaefer400_roi = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');

cifti_template = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');
cifti_template = rmfield(cifti_template, {'parcels', 'parcelslabel', 'parcelsrgba'});

cifti_file_path = '../SuppFig9/results_cifti';
mkdir(cifti_file_path);

% switch sub1 and sub2, aligning with the first manuscript
load('../SuppFig9/FG_Subtypes_statitsc_otherclu.mat');
Tval_sub1_HC = FG_Subtypes_statitsc_otherclu.T_value_subtype2_HC;
Tval_sub2_HC = FG_Subtypes_statitsc_otherclu.T_value_subtype1_HC; 
Tval_sub1_sub2 = FG_Subtypes_statitsc_otherclu.T_value_subtype1_subype2; 

% setting range [-10, -2] and [2, 10]
Tval_sub1_HC(Tval_sub1_HC > 0) = Tval_sub1_HC(Tval_sub1_HC > 0) - 2;
Tval_sub1_HC(Tval_sub1_HC < 0) = Tval_sub1_HC(Tval_sub1_HC < 0) + 2;
Tval_sub2_HC(Tval_sub2_HC > 0) = Tval_sub2_HC(Tval_sub2_HC > 0) - 2;
Tval_sub2_HC(Tval_sub2_HC < 0) = Tval_sub2_HC(Tval_sub2_HC < 0) + 2;
Tval_sub1_sub2(Tval_sub1_sub2 > 0) = Tval_sub1_sub2(Tval_sub1_sub2 > 0) - 2;
Tval_sub1_sub2(Tval_sub1_sub2 < 0) = Tval_sub1_sub2(Tval_sub1_sub2 < 0) + 2;

max_roi_num = 400;
for modal = {'Tval_sub1_HC', 'Tval_sub2_HC', 'Tval_sub1_sub2'}
    data = zeros(64984, 1);
    for j = 1: max_roi_num
        eval(['data(schaefer400_roi.parcels==j) = ', cell2mat(modal), '(j);']);
    end

    tmp_cifti_template = cifti_template;
    tmp_cifti_template.dscalar = data;
    ft_write_cifti(fullfile(cifti_file_path, [cell2mat(modal), '_otherclu']), tmp_cifti_template, 'parameter', 'dscalar');

end

% plotting files onto surface and plotting colorbars.
addpath('~/VDisk1/Xinyu/plot_fig_subcortex/dependencies/slanCM');
addpath(genpath('../cortical_mapper'));

cifti_file_path = '../SuppFig9/results_cifti';
pic_path = '../SuppFig9/results_fig';
mkdir(pic_path);

for modal = {'Tval_sub1_HC', 'Tval_sub2_HC', 'Tval_sub1_sub2'}
    c_map1 = flip(slanCM(97, 256));
    c_map2 = flip(slanCM(97, 86));
    c_map = [c_map2(1:end/2, :); c_map1(end/2+1:end, :)];

    cifti_file = fullfile(cifti_file_path, [cell2mat(modal), '_otherclu.dscalar.nii']);
    create_combined_cortical_image(cifti_file, 'cmap', c_map, 'color_range', [-1, 3]);
    export_fig(fullfile(pic_path, [cell2mat(modal), '_otherclu.png']), '-m4', '-q100');
    close;

    draw_colorbar(c_map);
    export_fig(fullfile(pic_path, [cell2mat(modal), '_otherclu_colorbar.png']), '-q100');
    close;
end

%% Supp Fig 9: validation (balance) gradient for subtype1 subtype2 and HC
% plotting roi-wise data onto cifti-version file.
schaefer400_roi = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');

cifti_template = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');
cifti_template = rmfield(cifti_template, {'parcels', 'parcelslabel', 'parcelsrgba'});

cifti_file_path = '../SuppFig9/results_cifti';
mkdir(cifti_file_path);

% switch sub1 and sub2, aligning with the first manuscript
load('../SuppFig9/FG_Subtypes_statitsc_balance.mat');
Func_Grad_sub1 = FG_Subtypes_statitsc_balance.depression_subtype_ave1; 
Func_Grad_sub2 = FG_Subtypes_statitsc_balance.depression_subtype_ave2; 
Func_Grad_hc = FG_Subtypes_statitsc_balance.graident1_depression_HC_ave; 

max_roi_num = 400;
for modal = {'Func_Grad_sub1', 'Func_Grad_sub2', 'Func_Grad_hc'}
    data = zeros(64984, 1);
    for j = 1: max_roi_num
        eval(['data(schaefer400_roi.parcels==j) = ', cell2mat(modal), '(j);']);
    end

    tmp_cifti_template = cifti_template;
    tmp_cifti_template.dscalar = data;
    ft_write_cifti(fullfile(cifti_file_path, [cell2mat(modal), '_balance']), tmp_cifti_template, 'parameter', 'dscalar');

end

% plotting files onto surface and plotting colorbars.
addpath('~/VDisk1/Xinyu/plot_fig_subcortex/dependencies/slanCM');
addpath(genpath('../cortical_mapper'));

cifti_file_path = '../SuppFig9/results_cifti';
pic_path = '../SuppFig9/results_fig';
mkdir(pic_path);

for modal = {'Func_Grad_sub1', 'Func_Grad_sub2', 'Func_Grad_hc'}
    c_map = flip(slanCM(95, 256));

    cifti_file = fullfile(cifti_file_path, [cell2mat(modal), '_balance.dscalar.nii']);
    create_combined_cortical_image(cifti_file, 'cmap', c_map, 'color_range', [-1, 1]);
    export_fig(fullfile(pic_path, [cell2mat(modal), '_balance.png']), '-m4', '-q100');
    close;

    draw_colorbar(c_map);
    export_fig(fullfile(pic_path, [cell2mat(modal), '_balance_colorbar.png']), '-q100');
    close;
end

%% Supp Fig 9: validation (balance) functional reorganization for subtype1 subtype2 and HC

% plotting roi-wise data onto cifti-version file.
schaefer400_roi = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');

cifti_template = ft_read_cifti('Schaefer2018_400Parcels_7Networks_order.dlabel.nii');
cifti_template = rmfield(cifti_template, {'parcels', 'parcelslabel', 'parcelsrgba'});

cifti_file_path = '../SuppFig9/results_cifti';
mkdir(cifti_file_path);

load('../SuppFig9/FG_Subtypes_statitsc_balance.mat');
Tval_sub1_HC = FG_Subtypes_statitsc_balance.T_value_subtype1_HC;
Tval_sub2_HC = FG_Subtypes_statitsc_balance.T_value_subtype2_HC; 
Tval_sub1_sub2 = -FG_Subtypes_statitsc_balance.T_value_subtype1_subype2; % no switch in balance set, therefore switch T_map_sub1_sub2

% setting range [-10, -2] and [2, 10]
Tval_sub1_HC(Tval_sub1_HC > 0) = Tval_sub1_HC(Tval_sub1_HC > 0) - 2;
Tval_sub1_HC(Tval_sub1_HC < 0) = Tval_sub1_HC(Tval_sub1_HC < 0) + 2;
Tval_sub2_HC(Tval_sub2_HC > 0) = Tval_sub2_HC(Tval_sub2_HC > 0) - 2;
Tval_sub2_HC(Tval_sub2_HC < 0) = Tval_sub2_HC(Tval_sub2_HC < 0) + 2;
Tval_sub1_sub2(Tval_sub1_sub2 > 0) = Tval_sub1_sub2(Tval_sub1_sub2 > 0) - 2;
Tval_sub1_sub2(Tval_sub1_sub2 < 0) = Tval_sub1_sub2(Tval_sub1_sub2 < 0) + 2;

max_roi_num = 400;
for modal = {'Tval_sub1_HC', 'Tval_sub2_HC', 'Tval_sub1_sub2'}
    data = zeros(64984, 1);
    for j = 1: max_roi_num
        eval(['data(schaefer400_roi.parcels==j) = ', cell2mat(modal), '(j);']);
    end

    tmp_cifti_template = cifti_template;
    tmp_cifti_template.dscalar = data;
    ft_write_cifti(fullfile(cifti_file_path, [cell2mat(modal), '_balance']), tmp_cifti_template, 'parameter', 'dscalar');

end

% plotting files onto surface and plotting colorbars.
addpath('~/VDisk1/Xinyu/plot_fig_subcortex/dependencies/slanCM');
addpath(genpath('../cortical_mapper'));

cifti_file_path = '../SuppFig9/results_cifti';
pic_path = '../SuppFig9/results_fig';
mkdir(pic_path);

for modal = {'Tval_sub1_HC', 'Tval_sub2_HC', 'Tval_sub1_sub2'}
    c_map1 = flip(slanCM(97, 256));
    c_map2 = flip(slanCM(97, 86));
    c_map = [c_map2(1:end/2, :); c_map1(end/2+1:end, :)];

    cifti_file = fullfile(cifti_file_path, [cell2mat(modal), '_balance.dscalar.nii']);
    create_combined_cortical_image(cifti_file, 'cmap', c_map, 'color_range', [-1, 3]);
    export_fig(fullfile(pic_path, [cell2mat(modal), '_balance.png']), '-m4', '-q100');
    close;

    draw_colorbar(c_map);
    export_fig(fullfile(pic_path, [cell2mat(modal), '_balance_colorbar.png']), '-q100');
    close;
end


