%% 1.2 Algo: Alternate Minimization
% This algo uses the "Alternate Minimization" for the reconstruction.
% 
% Objective Function:
%
% $E(\theta_1,\theta_2) = || f-A_1\theta_1-A_2\theta_2||_2$ 
%  |s.t| $\theta_1 \leq T_0$ |and|  $\theta_2 \leq T_0$ 
% 
% Where,
%
% $f1=A_1\theta_1$ |s.t| $A_1 = \phi \Psi_1$
% |s.t A1 is DFT matrix of 128x128 &| $\theta_1$ |is| $T_0$ |sparse|
%
% $f2=A_2\theta_2$ |s.t| $A_1 = \phi \Psi_2$
% 
% $\Psi_1$ 1d-DFT Matrix, $\Psi_1 \in R^{128\times128}$
%
% $\Psi_2$ Identity Matrix, $\Psi_1 \in R^{128\times128}$
% 
% As we know that by C.S theory identity matrix is highly *incoherent* with DFT. 
%
% So here, $\phi$ is *Identity Matrix*, $\phi \in R^{128\times128}$
%
% Therefore,
%
% $A_1 = \Psi_1$
%
% $A_2 =  \Psi_2$
% 
% *Algo*
%
% For finding $\theta_1$ & $\theta_2$, we will use OMP with $T_0$.
% 
% * Initalize: $\theta_2$ to some random value
% * Do the following till convergence (ith iteration)
% 
% # $f'=f-A_2*\theta_2^i$ 
% # $\theta_1^{i+1} = OMP (f',A_1,T_0)$
% # $f''=f-A_1*\theta_1^{i+1}$
% # $\theta_2^{i+1} = OMP (f'',A_2,T_0)$
%

