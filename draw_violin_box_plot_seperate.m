function draw_violin_box_plot_seperate(data, modal_all, direction, color_list)


% first confirm scale
final_f = zeros(length(modal_all), 100);
final_yi = zeros(length(modal_all), 100);
for i = 1: length(modal_all)
    eval(['y_data = data.', modal_all{i}, ';']);
    [final_f(i, :), final_yi(i, :)] = ksdensity(y_data);
end
scale_size = max(final_f(:)) / 1.5;

axis_min = min(final_yi(:)) - (max(final_yi(:))-min(final_yi(:))) / 12;
axis_max = max(final_yi(:)) + (max(final_yi(:))-min(final_yi(:))) / 12;

if strcmp(direction, 'horizontal')
    plot([-10000, 10000], [0, 0], '--', 'LineWidth', 3, 'Color', [0.5, 0.5, 0.5]);
elseif strcmp(direction, 'vertical')
    plot([0, 0], [-10000, 10000], '--', 'LineWidth', 3, 'Color', [0.5, 0.5, 0.5]);
end

for i = 1: length(modal_all)
    eval(['y_data = data.', modal_all{i}, ';']);

    f = final_f(i, :);
    yi = final_yi(i, :);

    f = f ./ scale_size;
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

    basic_pos = i * 0.5;

    if strcmp(direction, 'horizontal')
        a_violin = [yi(1),yi,yi(end)];
        b_violin = [0,f,0];
        a_scatter = y_data;
        b_scatter = -2+(basic_pos+0.17.*(rand(size(y_data,1),1)-0.5).*2);
        a_qt75 = [outli_max,qt75];
        b_qt75 = -2+([basic_pos,basic_pos]);
        a_qt25 = [outli_min,qt25];
        b_qt25 = -2+([basic_pos,basic_pos]);
        a_box = [qt25,qt25,qt75,qt75];
        b_box = -2+(basic_pos+0.15.*[-1,1,1,-1]);
        a_med = [med,med];
        b_med = -2+([-0.15, 0.15]+basic_pos);
    elseif strcmp(direction, 'vertical')
        b_violin = [yi(1),yi,yi(end)];
        a_violin = [0,f,0];
        b_scatter = y_data;
        a_scatter = -2+(basic_pos+0.17.*(rand(size(y_data,1),1)-0.5).*2);
        b_qt75 = [outli_max,qt75];
        a_qt75 = -2+([basic_pos,basic_pos]);
        b_qt25 = [outli_min,qt25];
        a_qt25 = -2+([basic_pos,basic_pos]);
        b_box = [qt25,qt25,qt75,qt75];
        a_box = -2+(basic_pos+0.15.*[-1,1,1,-1]);
        b_med = [med,med];
        a_med = -2+([-0.15, 0.15]+basic_pos);
    end

    fill(a_violin, b_violin, color_list(i,:), ...
        'FaceAlpha',0.75, 'EdgeColor', [0, 0, 0], 'LineWidth', 1.5);
    scatter(a_scatter, b_scatter, 20, 'filled',...
        'CData', color_list(i, :), 'LineWidth',1.5, 'MarkerFaceAlpha',0.75);
    
    plot(a_qt75, b_qt75, 'LineWidth', 1.5, 'Color', [0,0,0]);
    plot(a_qt25, b_qt25, 'LineWidth', 1.5, 'Color', [0,0,0]);
    fill(a_box, b_box, [1,1,1],...
        'FaceAlpha', 0, 'EdgeColor', [0, 0, 0], 'LineWidth', 1.5);
    plot(a_med, b_med, 'LineWidth', 1.5, 'Color', [0, 0, 0]);

end

set(gca, 'color', 'none'); set(gcf, 'color', 'none');
set(gca, 'FontSize', 30, 'FontName', 'Aptos');
set(gca, 'LineWidth', 2);

if strcmp(direction, 'horizontal')
    set(gca, 'XLim', [axis_min, axis_max]);
    set(gca, 'YLim', [-2, 1.8]);    
    set(gcf, 'Position', [0, 0, 900, 500]);
    set(gca, 'YTick', [-1.5, -1, -0.5, 0, 1.5]);
    set(gca, 'YTickLabel', {'', '', '', '0', num2str(round(max(final_f(:))))});
elseif strcmp(direction, 'vertical')
    set(gca, 'YLim', [axis_min, axis_max]);
    set(gca, 'XLim', [-2, 1.8]);    
    set(gcf, 'Position', [0, 0, 500, 900]);
    set(gca, 'XTick', [-1.5, -1, -0.5, 0, 1.5]);
    set(gca, 'XTickLabel', {'', '', '', '0', num2str(round(max(final_f(:))))});
end

end

