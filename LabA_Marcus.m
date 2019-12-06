
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
TF_SYS = tf(SS_SYS)

s = tf('s');
Kp = 1;
Kd = 1;
Ki = 1;

%syms Kp Kd Ki
%syms z1 p1 p2 p3
%syms s
%SYS = (s-z1) / ( (s-p1)*(s-p2)*(s-p3) )

%PID = Kp + Ki/s + s*Kd
