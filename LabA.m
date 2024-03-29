g = 9.8;
b_f = 0;
m_b = 0.381;
l_b = 0.112;
I_b = 0.00616;
m_w = 0.036;
l_w = 0.021;
I_w = 0.00000746;
R_m = 4.4;
l_m = 0;
b_m = 0;
K_e = 0.444;
K_t = 0.470;

gamma_11 = (I_w)/(l_w) + l_w * m_w + l_w * m_b;
gamma_12 = l_w * m_b * l_b;
alpha_11 = 0;
alpha_12 = -(K_e * K_t) / (R_m * l_w);
alpha_13 = 0;
alpha_14 = (K_e * K_t) / (R_m);
beta_1 = K_t/R_m;

gamma_21 = l_b * m_b;
gamma_22 = I_b + (m_b * l_b^2);
alpha_21 = 0;
alpha_22 = (K_e * K_t) / (R_m * l_w);
alpha_23 = m_b * l_b * g;
alpha_24 = - (K_e * K_t) / (R_m);
beta_2 = -(K_t)/(R_m);

delta = gamma_11*gamma_22 - gamma_12*gamma_21;

a_22 = (gamma_22*alpha_12 - gamma_12*alpha_22) / delta;
a_23 = (gamma_22*alpha_13 - gamma_12*alpha_23) / delta;
a_24 = (gamma_22*alpha_14 - gamma_12*alpha_24)/ delta;
a_42 = (-gamma_21*alpha_12 + gamma_11*alpha_22)/delta;
a_43 = (-gamma_21*alpha_13 + gamma_11*alpha_23) / delta;
a_44 = (-gamma_21*alpha_14 + gamma_11*alpha_24) / delta;

b_2 = (gamma_22*beta_1)/delta;
b_4 = (-gamma_21*beta_1)/delta;





A = [0 1 0 0; 0 a_22 a_23 a_24; 0 0 0 1; 0 a_42 a_43 a_44];

B = [0; b_2; 0; b_4];

%The right B

B = [0 20.5759 0 -90.0275]';

C = [0 0 1 0];

ctrl = [B ,A*B, A^2*B, A^3*B]; 

rank(ctrl);

obsv = [C; C*A; C*A^2; C*A^3];

rank(obsv);

sys = ss(A,B,C,0);

t_f = tf(sys);

p = pole(t_f);
z = zero(t_f);

p_1 = p(1);
p_2 = p(2);
p_3 = p(3);
pcl_1 = p_1;
pcl_2 = -p_2;
pcl_3 = p_3;
pcl_4 = -10;
z_1 = z;


K_d = - pcl_1 - pcl_2 - pcl_3  + p_1 + p_2 + p_3;
K_p = + z_1 * K_d - p_1*p_2 - p_1*p_3 - p_2*p_3 + pcl_1*pcl_2 + pcl_2 + pcl_3 + pcl_1*pcl_4 + pcl_2*pcl_4 + pcl_3*pcl_4;
K_i = + z_1 * K_p + p_1*p_2*p_3 - pcl_1*pcl_2*pcl_3 - pcl_1*pcl_2*pcl_4 - pcl_1*pcl_3*pcl_4 -  pcl_2*pcl_3*pcl_4; 

s = tf('s');
pid = K_p + (K_i / s) + (K_d * s);

syscl = (t_f * pid) / (1 + t_f * pid);

syscl = feedback( (t_f * pid) ,1);

pole(syscl);
zero(syscl);
zero(sys);

