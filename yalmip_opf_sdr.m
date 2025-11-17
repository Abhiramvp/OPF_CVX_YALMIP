function results = yalmip_opf_sdr(net)
% 3-bus AC-OPF SDR with YALMIP.

nbus   = net.nbus;
Y      = net.Y;
sd     = net.sd;
Cg     = net.Cg;
Pg_min = net.Pg_min;
Pg_max = net.Pg_max;
Qg_min = net.Qg_min;
Qg_max = net.Qg_max;
Vmin   = net.Vmin;
Vmax   = net.Vmax;
a      = net.a;
b      = net.b;
c      = net.c;
ng     = net.ng;

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
