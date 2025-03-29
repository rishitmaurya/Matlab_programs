function bifurcation(x0, rmin, rmax, rstep, n, l)
    figure
    hold on
    for r = rmin:rstep:rmax
        traj = logisticMap(x0, r, n);
        R = r * ones(n+1, 1);
        plot(R(l:n), traj(l:n), '.', 'MarkerSize', .1, 'Color', [0.2, 0.2, 0.2])
    end
    axis([rmin, rmax, min(traj), max(traj)])
    hold off
    return
end

function [traj] = logisticMap(xo, r, n)
    xcurr = xo;
    traj(1, :) = xo;
    for i = 2:n
        traj(i, :) = r * xcurr * (1 - xcurr);
        xcurr = traj(i, :);
    end
    return
end
