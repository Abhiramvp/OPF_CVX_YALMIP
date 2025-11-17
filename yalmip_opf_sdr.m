function results = yalmip_opf_sdr()
% yalmip_opf_sdr.m
% 3-bus AC-OPF using semidefinite relaxation (SDR) in YALMIP.

nbus = 3;

Y = [ 10-30j   -10+30j     0+0j ;
     -10+30j   15-45j   -5+15j ;
       0+0j   -5+15j     5-15j ];

Pd = [0.90; 0.50; 0.60];
Qd = [0.30; 0.20; 0.25];
sd = Pd + 1j*Qd;

gen_bus = [1; 2];
ng      = length(gen_bus);

Pg_min = [0.0; 0.0];
Pg_max = [2.0; 2.0];
Qg_min = [-0.5; -0.5];
Qg_max = [ 0.5;  0.5];

Vmin = 0.95;
Vmax = 1.05;

a = [0.10; 0.10];
b = [1.00; 1.00];
c = [0.00; 0.00];

Cg = zeros(nbus,ng);
for k = 1:ng
    Cg(gen_bus(k),k) = 1;
end

Pg = sdpvar(ng,1,'full');
Qg = sdpvar(ng,1,'full');
W  = sdpvar(nbus,nbus,'hermitian','complex');

Constraints = [];
Constraints = [Constraints, W >= 0];
Constraints = [Constraints, Vmin^2 <= real(diag(W)) <= Vmax^2];
Constraints = [Constraints, Pg_min <= Pg <= Pg_max];
Constraints = [Constraints, Qg_min <= Qg <= Qg_max];

s_g   = Cg*(Pg + 1j*Qg);
s_inj = s_g - sd;

for i = 1:nbus
    Constraints = [Constraints, s_inj(i) == conj(Y(i,:))*W(i,:).'];
end

Objective = sum( a.*(Pg.^2) + b.*Pg + c );

ops = sdpsettings('solver','mosek','verbose',1);   % change if needed
info = optimize(Constraints, Objective, ops);

results.info  = info;
results.Pg    = value(Pg);
results.Qg    = value(Qg);
results.W     = value(W);
results.cost  = value(Objective);

end
