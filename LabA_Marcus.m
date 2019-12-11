
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
    -2.6574;
    p(3)];


s = tf('s');
% Kp = p(1) + p(2) + p(3) - pcl(1) - pcl(2) - pcl(3);
% Kd = - p(1)*p(2) - p(1)*p(3) - p(2)*p(3) + pcl(1)*pcl(2) + pcl(1)*pcl(3) + pcl(2)*pcl(3);
% Ki = p(1)*p(2)*p(3) - pcl(1)*pcl(2)*pcl(3);

%New values of Kp, Ki and Kd

k = -90.03;
Kp = (- p(1)*p(2) - p(2)*p(3) - p(1)*p(3) + pcl(1)*pcl(2) + pcl(2)*pcl(3) + pcl(1)*pcl(3)) / k;
Ki = (p(1)*p(2)*p(3) - pcl(1)*pcl(2)*pcl(3)) / k;
Kd = (p(1) + p(2) + p(3)  -  pcl(1) - pcl(2) - pcl(3)) / k;

%syms Kp Kd Ki
%syms z1 p1 p2 p3
%syms s
%SYS = (s-z1) / ( (s-p1)*(s-p2)*(s-p3) )

PID = Kp + Ki/s + s*Kd;
cl =  feedback(TF_SYS, PID);
pole(cl);

%For the simulink with disturbance

beta_d = [beta, [l_w; l_b]]

tmpB = inv(gamma) * beta_d;
Bd = [0, 0; tmpB(1, 1), tmpB(1, 2); 0, 0; tmpB(2, 1), tmpB(2, 2)]

Cd = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];

Dd = [0 0; 0 0; 0 0; 0 0];

ss(A,Bd,Cd,Dd);




bw = bandwidth(TF_SYS)/(2*pi)
%bw = bandwidth(cl)/(2*pi)
sf_min = 2*bw

figure;
bode(TF_SYS);
figure;
bode(cl);
figure;
bode(TF_SYS, cl)

%--------------------------------------------------------------------
% cascade experiments:
%--------------------------------------------------------------------

Cc = [0, 1, 0, 0];

G2_ss = ss(A, B, Cc, 0);
G2 = tf(G2_ss);

H_w = minreal(G2 * PID);





