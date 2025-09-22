function draw_violin_scatter_box_plot(data, modal_all, direction, color_list, scale_size)

counter = 1;
axis_min = inf;
axis_max = -inf;

for modal = modal_all
    
    eval(['y_data = data.', modal{1}, ';']);

    [f, yi] = ksdensity(y_data);
    f = f .* scale_size;
    qt25 = quantile(y_data, 0.25);
    qt75 = quantile(y_data, 0.75);
    med = median(y_data);
    outli_min=min(y_data(~isoutlier(y_data,'quartiles')));
    outli_max=max(y_data(~isoutlier(y_data,'quartiles')));

    if (yi(1) - (yi(end)-yi(1)) / 12) < axis_min
        axis_min = yi(1) - (yi(end)-yi(1)) / 12;
    end
    if (yi(end) + (yi(end)-yi(1)) / 12) > axis_max
        axis_max = yi(end) + (yi(end)-yi(1)) / 12;
    end

    basic_pos = counter * 2 - 1;

    if strcmp(direction, 'horizontal')
        a_violin = [yi(1),yi,yi(end)];
        b_violin = [0,f,0].*1.2+basic_pos+0.15;
        a_scatter = y_data;
        b_scatter = basic_pos-0.15+0.17.*(rand(size(y_data,1),1)-0.5).*2;
        a_qt75 = [outli_max,qt75];
        b_qt75 = [basic_pos,basic_pos]-0.15;
        a_qt25 = [outli_min,qt25];
        b_qt25 = [basic_pos,basic_pos]-0.15;
        a_box = [qt25,qt25,qt75,qt75];
        b_box = basic_pos-0.15+0.15.*[-1,1,1,-1];
        a_med = [med,med];
        b_med = [-0.15, 0.15]+basic_pos-0.15;
    elseif strcmp(direction, 'vertical')
        b_violin = [yi(1),yi,yi(end)];
        a_violin = [0,f,0].*1.2+basic_pos+0.15;
        b_scatter = y_data;
        a_scatter = basic_pos-0.15+0.17.*(rand(size(y_data,1),1)-0.5).*2;
        b_qt75 = [outli_max,qt75];
        a_qt75 = [basic_pos,basic_pos]-0.15;
        b_qt25 = [outli_min,qt25];
        a_qt25 = [basic_pos,basic_pos]-0.15;
        b_box = [qt25,qt25,qt75,qt75];
        a_box = basic_pos-0.15+0.15.*[-1,1,1,-1];
        b_med = [med,med];
        a_med = [-0.15, 0.15]+basic_pos-0.15;
    end

    fill(a_violin, b_violin, color_list(counter,:), ...
        'FaceAlpha',0.75, 'EdgeColor', [0, 0, 0], 'LineWidth', 1.5);
    scatter(a_scatter, b_scatter, 20, 'filled',...
        'CData', color_list(counter,:), 'LineWidth',1.5, 'MarkerFaceAlpha',0.75);
    
    plot(a_qt75, b_qt75, 'LineWidth', 1.5, 'Color', [0,0,0]);
    plot(a_qt25, b_qt25, 'LineWidth', 1.5, 'Color', [0,0,0]);
    fill(a_box, b_box, [1,1,1],...
        'FaceAlpha', 0, 'EdgeColor', [0, 0, 0], 'LineWidth', 1.5);
    plot(a_med, b_med, 'LineWidth', 1.5, 'Color', [0, 0, 0]);
    
    counter = counter + 1;
end
set(gca, 'color', 'none'); set(gcf, 'color', 'none');
set(gca, 'FontSize', 30, 'FontName', 'Aptos');
set(gca, 'LineWidth', 2);

if strcmp(direction, 'horizontal')
    set(gca, 'XLim', [axis_min, axis_max]);
    set(gcf, 'Position', [0, 0, 900, 500]);
    set(gca, 'YTick', [1, 3, 5]);
elseif strcmp(direction, 'vertical')
    set(gca, 'YLim', [axis_min, axis_max]);
    set(gcf, 'Position', [0, 0, 500, 900]);
    set(gca, 'XTick', [1, 3, 5]);
end

end

