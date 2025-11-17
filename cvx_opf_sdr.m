function results = cvx_opf_sdr()
% cvx_opf_sdr.m
% 3-bus AC-OPF using semidefinite relaxation (SDR) in CVX.

nbus = 3;

% Example bus admittance matrix Y (p.u.)
Y = [ 10-30j   -10+30j     0+0j ;
     -10+30j   15-45j   -5+15j ;
       0+0j   -5+15j     5-15j ];

% Complex loads s^d = Pd + j Qd  (p.u.)
Pd = [0.90; 0.50; 0.60];
Qd = [0.30; 0.20; 0.25];
sd = Pd + 1j*Qd;

% Generators at buses
gen_bus = [1; 2];     % one generator at bus 1, one at bus 2
ng      = length(gen_bus);

% Generator limits (p.u.)
Pg_min = [0.0; 0.0];
Pg_max = [2.0; 2.0];
Qg_min = [-0.5; -0.5];
Qg_max = [ 0.5;  0.5];

% Voltage magnitude limits
Vmin = 0.95;
Vmax = 1.05;

% Quadratic cost h_g(Pg) = sum( a Pg^2 + b Pg + c )
a = [0.10; 0.10];
b = [1.00; 1.00];
c = [0.00; 0.00];

% Generator-to-bus incidence matrix Cg (nbus x ng)
Cg = zeros(nbus,ng);
for k = 1:ng
    Cg(gen_bus(k),k) = 1;
end

cvx_begin sdp
    cvx_precision medium

    variables Pg(ng) Qg(ng)
    variable  W(nbus,nbus) complex

    minimize( sum( a.*(Pg.^2) + b.*Pg + c ) )

    subject to
        % Semidefinite relaxation
        W == hermitian_semidefinite(nbus);

        % Voltage magnitude bounds
        Vmin^2 <= real(diag(W)) <= Vmax^2;

        % Generator limits
        Pg_min <= Pg <= Pg_max;
        Qg_min <= Qg <= Qg_max;

        % Nodal complex power balance
        s_g   = Cg*(Pg + 1j*Qg);   % bus-wise generation
        s_inj = s_g - sd;          % net injection

        for i = 1:nbus
            s_inj(i) == conj(Y(i,:)) * W(i,:).';
        end

cvx_end

results.Pg     = Pg;
results.Qg     = Qg;
results.W      = W;
results.status = cvx_status;
results.cost   = cvx_optval;

end
