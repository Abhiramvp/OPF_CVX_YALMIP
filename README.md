# Optimal Power Flow (OPF) in AC network

An optimal Power Flow (OPF) Problem in an AC network is a typical optimization problem. An OPF problem minimizes an objective (e.g., power generation cost, network power loss, etc), while satisfying the physical conditions of the power system network as the constraints. The constraints of an OPF problem are typically the power generation limits of each source, the predefined voltage bounds at each bus (aka nodes of the power network graph), the power flow limits in the lines (aka edges of the power network graph), bus reactive power injection bounds, etc. 

A simple OPF considers the network data in the form of all the relevant bounds on power, voltage, etc, and the network line impedances, and load demands at the buses, to find out the optimal power flow in the network, which corresponds to the minimum (aka optimal point) of the objective function considered.

Here, a semidefinite programming relaxation (SDR) technique to efficiently convert the nonlinear nonconvex problem into a tractable semidefinite program (SDP) form, which is a convex optimization problem, solved using a commercial solver.
A simple OPF is the prerequisite for any addition to an OPF problem making it complex, e.g., security-constrained, stability-constrained, robust optimization, etc.

## Simple OPF

$$
\begin{align}
&\mathrm{minimize} && \boldsymbol{h}_g(\mathrm{real}(\mathbf{s}^g)), \\ 
&\mathrm{subject~to} && \hat{\mathrm{C}}^{\top}(\mathbf{S}^g ) = \hat{\mathrm{D}}^{\top} (\mathbf{S}^d) + \mathrm{diag} (\mathbf{v}\mathbf{v}^* \mathbf{Y}^* ), \\ 
& && (\mathbf{v}^{\min})^2 \leq { \mathbf{v}\mathbf{v}^*} \leq (\mathbf{v}^{\max})^2, \\ 
& && \mathbf{s}^{g,\min} \leq \mathbf{s}^g \leq \mathbf{s}^{g,\max}, \\ 
&\mathrm{variables} && \mathbf{s}^g \in \mathbb{C}^{|\mathcal{N}|}; \mathbf{v} \in \mathbb{C}^{|\mathcal{N}|};
\end{align}
$$

#### Additional constraints OPF

$$
\begin{align}
&\mathrm{minimize} && \boldsymbol{h}_g(\mathrm{real}(\mathbf{s}^g)), \\ 
&\mathrm{subject~to} && \hat{\mathrm{C}}^{\top}(\mathbf{S}^g ) = \hat{\mathrm{D}}^{\top} (\mathbf{S}^d) + \mathrm{diag} (\mathbf{v}\mathbf{v}^* \mathbf{Y}^* ), \\ 
& && |\mathrm{diag} ( \mathbf{C} \mathbf{v} \mathbf{v}^* \mathbf{Y}^* )| = \mathbf{f}, \\ 
& && (\mathbf{v}^{\min})^2 \leq { \mathbf{v}\mathbf{v}^*} \leq (\mathbf{v}^{\max})^2, \\ 
& && \mathbf{s}^{g,\min} \leq \mathbf{s}^g \leq \mathbf{s}^{g,\max}, \\ 
& && -\mathbf{f}^{\max} \leq \mathbf{f} \leq \mathbf{f}^{\max}, \\ 
& && \angle \boldsymbol{v}_1 = 0, \\ 
&\mathrm{variables} && \mathbf{s}^g \in \mathbb{C}^{|\mathcal{N}|}; \mathbf{v} \in \mathbb{C}^{|\mathcal{N}|}; \mathbf{f} \in \mathbb{C}^{|\mathcal{E}|}; 
\end{align}
$$

## Convex OPF with slack variables

$$
\begin{align}
&\mathrm{minimize} && \boldsymbol{h}_g(\mathrm{real}(\mathbf{s}^g)), \\ 
&\mathrm{subject~to} && \hat{\mathrm{C}}^{\top}(\mathbf{S}^g ) = \hat{\mathrm{D}}^{\top} (\mathbf{S}^d) + \mathrm{diag} ( \mathbf{W} \mathbf{Y}^* ), \\ 
& && (\mathbf{v}^{\min})^2 \leq  \mathbf{W} \leq (\mathbf{v}^{\max})^2, \\ 
& && \mathbf{s}^{g,\min} \leq \mathbf{s}^g \leq \mathbf{s}^{g,\max}, \\ 
&\mathrm{variables} && \mathbf{s}^g \in \mathbb{C}^{|\mathcal{N}|}; \mathbf{v} \in \mathbb{C}^{|\mathcal{N}|}; \mathbf{W}\in \mathbb{C}^{|\mathcal{N}|\times |\mathcal{N}|}
\end{align}
$$

#### Additional constraints OPF with slack variables

$$
\begin{align}
&\mathrm{minimize} && \boldsymbol{h}_g(\mathrm{real}(\mathbf{s}^g)), \\ 
&\mathrm{subject~to} && \hat{\mathrm{C}}^{\top}(\mathbf{S}^g ) = \hat{\mathrm{D}}^{\top} (\mathbf{S}^d) + \mathrm{diag} ( \mathbf{W}\mathbf{Y}^* ), \\ 
& && |\mathrm{diag} ( \mathbf{C}  \mathbf{W} \mathbf{Y}^* )| = \mathbf{f}, \\ 
& && (\mathbf{v}^{\min})^2 \leq {  \mathbf{W}} \leq (\mathbf{v}^{\max})^2, \\ 
& && \mathbf{s}^{g,\min} \leq \mathbf{s}^g \leq \mathbf{s}^{g,\max}, \\ 
& && -\mathbf{f}^{\max} \leq \mathbf{f} \leq \mathbf{f}^{\max}, \\ 
& && \angle \boldsymbol{v}_1 = 0, \\ 
& && \begin{bmatrix}
 \mathbf{W} & \mathbf{v} \\
 \mathbf{v}^* & 1
        \end{bmatrix} \succeq 0, \\
&\mathrm{variables} && \mathbf{s}^g \in \mathbb{C}^{|\mathcal{N}|}; \mathbf{v} \in \mathbb{C}^{|\mathcal{N}|}; \mathbf{f} \in \mathbb{C}^{|\mathcal{E}|}; \mathbf{W}\in \mathbb{C}^{|\mathcal{N}|\times |\mathcal{N}|}
\end{align}
$$

---

## MATLAB implementation in this repository

This repository includes a small 3-bus AC network example that solves the convex OPF (SDR with slack variable \( \mathbf{W} \)) using either CVX or YALMIP.

- `opf_main.m`  
  - Defines the 3-bus network data (Y-bus, loads, generator locations, limits, cost coefficients).  
  - Packs data into a struct `net`.  
  - Calls either the CVX or YALMIP backend depending on the input argument.

  Example usage:
  ```matlab
  % CVX-based OPF
  results_cvx = opf_main('cvx');

  % YALMIP-based OPF
  results_yalmip = opf_main('yalmip');
