%--------------------------------------------
%Load the values from Lab A
%--------------------------------------------
LabA_Marcus

%--------------------------------------------
%Controllability and observability: 
%TODO controllability and observabilty index
%--------------------------------------------

%--------------------------------------------
%4.6.1
%TODO write in the rapport.
%--------------------------------------------

P = pole(SS_SYS);

%P = pole(cl)

P = [-475.0690; -5.6571; -5.6571; -5.6571];

K = acker(A,B,P);

%--------------------------------------------
%4.7.1
%TODO Explain and motivate our choice of rho. 
%--------------------------------------------
% syms s;
% I = eye(4);
% N = det([s.*I - A,  -B; C, 0]);
% D = det([s.*I - A]);
% negativeN = det([-s.*I - A,  -B; C, 0]);
% negativeD = det([-s.*I - A]);

SS = ss(A,B,C,D);
[N,D] = ss2tf(A,B,C,D,1);
s = tf('s');
sp = [s^4; s^3; s^2; s; 1];
Gp = (N*sp) / (D*sp);
sp2 = [s^4; -s^3; s^2; -s; 1];
Gm = (N*sp2) / (D*sp2);

%rlocus(Gp*Gm);
rho = 10;
afUnsortedAllRoots = rlocus( Gp*Gm, rho );
[~, aiSortingIndexes] = sort( real(afUnsortedAllRoots) );
afSortedAllRoots = afUnsortedAllRoots(aiSortingIndexes);
afSortedRoots = afSortedAllRoots(1:4);

%K = acker(A, B, afSortedRoots);

%--------------------------------------------
%4.8.1 full-order
%TODO ... 
%--------------------------------------------

C = [1 0 0 0; 0 0 1 0];

P_o = [P(1) * 4; P(2) * 4 + 0.01; P(3) * 4; P(4) * 4 - 0.01];

L = (place(A', C', P_o))';

%--------------------------------------------
%4.8.1 reduced order
%TODO ... 
%--------------------------------------------

V = [C(2,:);0, 1, 0, 0; 0, 0, 0, 1];
C_notacc = C(2,:);
C_acc = C(1,:);
T_inv = [C(1,:) ; V];
T = inv(T_inv);

A_tilde = T_inv * A * T;
B_tilde = T_inv * B;


 C_acc_tilde = C_acc * T;
 C_notacc_tilde = C_notacc * T;

 n = 4;
 m = 1;
 
 A_tilde_yy = A_tilde(1:m, 1:m);
 A_tilde_yx = A_tilde(1:m, 1+m:n);
 A_tilde_xy = A_tilde(1+m:n, 1:m);
 A_tilde_xx = A_tilde(1+m:n, 1+m:n);
 
 B_tilde_y = B_tilde(1:m);
 B_tilde_x = B_tilde(1+m:n);
 
 C_tilde_y = C_notacc_tilde(1:m);
 C_tilde_x = C_notacc_tilde(1+m:n);
% y_acc = C(1,;) * x
% x_hat = T(:,1) * y_acc + T(:,2:)

AA = A_tilde_xx;
CC = [A_tilde_yx; C_tilde_x];

L_r = (place(AA', CC', P_o(1+m:n)))';
L_acc = [L_r(:, 1:m)];
L_notacc = L_r(:, 1+m:size(L_r, 2));

M1 = A_tilde_xx - L_acc * A_tilde_yx - L_notacc * C_tilde_x;
M2 = B_tilde_x - L_acc * B_tilde_y;
M3 = A_tilde_xy - L_acc * A_tilde_yy - L_notacc * C_tilde_y;
M4 = L_notacc;

M5 = L_acc

M6 = T(: , 1:m)
M7 = T(: , 1+m:n)