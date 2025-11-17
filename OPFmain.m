function results = opf_main(method)
% Driver for AC-OPF via semidefinite relaxation (SDR).

if nargin < 1
    method = 'cvx';
end

% ----- network and OPF data -----
net.nbus = 3;

% Bus admittance matrix Y (p.u.)
net.Y = [ 10-30j   -10+30j     0+0j ;
         -10+30j   15-45j   -5+15j ;
           0+0j   -5+15j     5-15j ];

% Loads: s^d = Pd + j Qd (p.u.)
net.Pd = [0.90; 0.50; 0.60];
net.Qd = [0.30; 0.20; 0.25];

% Generators at buses
net.gen_bus = [1; 2];          % one generator at bus 1, one at bus 2
net.ng      = length(net.gen_bus);

% Generator limits (p.u.)
net.Pg_min = [0.0; 0.0];
net.Pg_max = [2.0; 2.0];
net.Qg_min = [-0.5; -0.5];
net.Qg_max = [ 0.5;  0.5];

% Voltage magnitude limits
net.Vmin = 0.95;
net.Vmax = 1.05;

% Quadratic cost h_g(Pg) = sum( a Pg^2 + b Pg + c )
net.a = [0.10; 0.10];
net.b = [1.00; 1.00];
net.c = [0.00; 0.00];

% Generator-to-bus incidence matrix Cg (nbus x ng)
net.Cg = zeros(net.nbus, net.ng);
for k = 1:net.ng
    net.Cg(net.gen_bus(k),k) = 1;
end

% precompute complex load
net.sd = net.Pd + 1j*net.Qd;

% ----- select solver -----
switch lower(method)
    case 'cvx'
        results = cvx_opf_sdr(net);

    case 'yalmip'
        results = yalmip_opf_sdr(net);

    otherwise
        error('Unknown method "%s". Use "cvx" or "yalmip".', method);
end

end
