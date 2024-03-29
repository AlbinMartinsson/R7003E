clear

%LoadSymbolicParameters
LabA_Solutions_LoadPhysicalParameters

syms alpha_11 alpha_12 alpha_13 alpha_14 alpha_21 alpha_22 alpha_23 alpha_24;
syms beta_1 beta_2;
syms gamma_11 gamma_12 gamma_21 gamma_22;

gamma_11 = I_w/l_w + l_w*m_w + l_w*m_b;
gamma_12 = l_w*m_b*l_b;

alpha_11 = 0;
alpha_12 = - (K_e*K_t) / (R_m*l_w);
alpha_13 = 0;
alpha_14 = (K_e*K_t) / R_m;

beta_1 = K_t/R_m;


gamma_21 = m_b*l_b;
gamma_22 = I_b + m_b*l_b^2;

alpha_21 = 0;
alpha_22 = (K_e*K_t) / (R_m*l_w);
alpha_23 = m_b*l_b*g;
alpha_24 = - (K_e*K_t) / R_m;

beta_2 = - K_t/R_m;

alpha = [alpha_11, alpha_12, alpha_13, alpha_14; alpha_21, alpha_22, alpha_23, alpha_24];
beta = [beta_1; beta_2];
gamma = [gamma_11, gamma_12; gamma_21, gamma_22];

tmpA = inv(gamma) * alpha;
A = [0, 1, 0, 0;
    tmpA(1, 1), tmpA(1, 2), tmpA(1, 3), tmpA(1, 4);
    0, 0, 0, 1;
    tmpA(2, 1), tmpA(2, 2), tmpA(2, 3), tmpA(2, 4)];

tmpB = inv(gamma) * beta;
B = [0; tmpB(1); 0; tmpB(2)];

C = [0, 0, 1, 0];

D = 0;

Co = ctrb(A, B);
Ob = ctrb(A', C');

SS_SYS = ss(A, B, C, D);
TF_SYS = tf(SS_SYS);
p = pole(TF_SYS);

pcl = [p(1);
    -15.6574;
    p(3)];


s = tf('s');
% Kp = p(1) + p(2) + p(3) - pcl(1) - pcl(2) - pcl(3);
% Kd = - p(1)*p(2) - p(1)*p(3) - p(2)*p(3) + pcl(1)*pcl(2) + pcl(1)*pcl(3) + pcl(2)*pcl(3);
% Ki = p(1)*p(2)*p(3) - pcl(1)*pcl(2)*pcl(3);

%New values of Kp, Ki and Kd

k = -90.03;
kP = (- p(1)*p(2) - p(2)*p(3) - p(1)*p(3) + pcl(1)*pcl(2) + pcl(2)*pcl(3) + pcl(1)*pcl(3)) / k;
kI = (p(1)*p(2)*p(3) - pcl(1)*pcl(2)*pcl(3)) / k;
kD = (p(1) + p(2) + p(3)  -  pcl(1) - pcl(2) - pcl(3)) / k;

%syms Kp Kd Ki
%syms z1 p1 p2 p3
%syms s
%SYS = (s-z1) / ( (s-p1)*(s-p2)*(s-p3) )

PID = kP + kI/s + s*kD;
cl =  feedback(TF_SYS, PID);
pole(cl);

%For the simulink with disturbance

beta_d = [beta, [l_w; l_b]];

tmpB = inv(gamma) * beta_d;
Bd = [0, 0; tmpB(1, 1), tmpB(1, 2); 0, 0; tmpB(2, 1), tmpB(2, 2)];

Cd = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];

Dd = [0 0; 0 0; 0 0; 0 0];

sys_dist = ss(A,Bd,Cd,Dd);
tf_dist = tf(sys_dist);

%--------------------------------------------------------------------
% simulink parts: TODO fix the plots
%--------------------------------------------------------------------

% open_system('H:\R7003E-master\R7003E-master\LabA_LinearizedBot');
% %saveas(get_param('LabA_LinearizedBot','Handle'),'LabA_LinearizedBot_Simulink_diagram.eps');
% sim('LabA_LinearizedBot');
% close_system('LabA_LinearizedBot');
% 
% 
% figure(1)
% plot(x_w.time,x_w.signals.values);
% title('x_w');
% xlabel('time');
% ylabel('meters');
% set(gcf,'Units','centimeters');
% set(gcf,'Position',afFigurePosition);
% set(gcf,'PaperPositionMode','auto');
% %print('-depsc2','-r300','LabA_LinearizedBot_Simulink_diagram.eps');

%--------------------------------------------------------------------
% Discretization:
%--------------------------------------------------------------------
bw = 13.7;
cf = 2 * bw;
cf_hertz = cf / (2 * pi);
freq_interval = 2 * cf_hertz;

%From the book
Ts = 1/(freq_interval * 25);
Ts = 0.01;





%bw = bandwidth(TF_SYS)/(2*pi)
%bw = bandwidth(cl)/(2*pi)
%sf_min = 2*bw

%figure;
%bode(TF_SYS);
%figure;
%bode(cl);
%figure;
%bode(TF_SYS, cl)

%--------------------------------------------------------------------
% cascade experiments:
%--------------------------------------------------------------------

Cc = [0, 1, 0, 0];

G2_ss = ss(A, B, Cc, 0);
G2 = tf(G2_ss);

G1 = TF_SYS;

C1 = PID;

feedback(G1, C1);

U = minreal(feedback(C1, G1));