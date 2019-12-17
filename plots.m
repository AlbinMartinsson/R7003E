plot(x_w.time,x_w.signals.values);
title('Values of x over time');
xlabel('time');
ylabel('x');
lgd = legend('actual x_w','estimated x_w full order', 'estimated x_w reduced order');
lgd.Location = 'southeast';

figure;
plot(theta_b.time,theta_b.signals.values);
title('Values of theta_b over time');
xlabel('time');
ylabel('rad');
lgd = legend('actual theta_b','estimated theta_b full order', 'estimated theta_b full order');
lgd.Location = 'southeast';

figure;
plot(u.time,u.signals.values);
title('Values of u over time');
xlabel('time');
ylabel('u');
lgd = legend('u');
lgd.Location = 'southeast';

x_w_real = x_w.signals.values(:,1);
x_w_est_fo = x_w.signals.values(:,2);
x_w_est_ro = x_w.signals.values(:,3)

error_xw_fo = abs(x_w_real - x_w_est_fo);
error_xw_ro = abs(x_w_real - x_w_est_ro);

max_error_xw_fo = max(error_xw_fo);
max_error_xw_ro = max(error_xw_ro);

theta_b_real = theta_b.signals.values(:,1);
theta_b_est_fo = theta_b.signals.values(:,2);
theta_b_est_ro = theta_b.signals.values(:,3);

error_thetab_fo = abs(theta_b_real - theta_b_est_fo);
error_thetab_ro = abs(theta_b_real - theta_b_est_ro);

max_error_thetab_fo = max(error_thetab_fo);
max_error_thetab_ro = max(error_thetab_ro);






