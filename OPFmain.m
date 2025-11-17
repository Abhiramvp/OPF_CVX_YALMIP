
---

### `opf_main.m`

```matlab
function results = opf_main(method)
% opf_main.m
% Driver for AC-OPF via semidefinite relaxation (SDR).

if nargin < 1
    method = 'cvx';
end

switch lower(method)
    case 'cvx'
        fprintf('Running OPF (SDR) with CVX...\n');
        results = cvx_opf_sdr();

    case 'yalmip'
        fprintf('Running OPF (SDR) with YALMIP...\n');
        results = yalmip_opf_sdr();

    otherwise
        error('Unknown method "%s". Use "cvx" or "yalmip".', method);
end

end
