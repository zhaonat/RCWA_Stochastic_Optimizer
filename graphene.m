classdef graphene
    %GRAPHENE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        tau_range = [1e-12, 1e-11]; % seconds, min, max
        mu_range = [0.6, 1];        % eV; min, max
        T = 300;
        thickness = 0.34e-9;
        mu
        tau
        omega_range
    end
    
    methods
        function obj = graphene(Ef, tau)
            %GRAPHENE Construct an instance of this class
            %   Detailed explanation goes here
            obj.tau = tau;
            obj.mu = Ef;
        end
        
        function epsilon= graphene_properties(obj, w)
            %tau [unit s], w [unit rad/s], mu[ev], T[K]
            %example imput: 1e14,1e-3,0,1e-13
            tau = obj.tau; mu = obj.mu;
            sheet_thickness = obj.thickness;
            h = 1.054571596e-34;           %Planck's constant over 2*pi
            c0 = 2.99792458e+8;            %speed of light in vacuum
            kb = 1.3806503e-23;
            qe = 1.602176462e-19;          %elementary electric charge %

            if T<1 %% temperature less than 1 K, what's that for?
            sigma_D=1i/(w+1i/tau)*2*qe^2/pi/h^2*mu*qe/2; %% intra band
            else
            sigma_D=1i/(w+1i/tau)*2*qe^2*kb*T/pi/h^2*log(2*cosh(mu*qe/2/kb/T)); % interband
            end

            eta=[1e-4:3e-5:1]*2e-17;
            for ii=1:length(eta)
                temp(ii)=1i*4*h*w/pi*(G(eta(ii),T,mu)-G(h*w/2,T,mu))/(h^2*w^2-4*eta(ii)^2);
            end
            sigma_inte=(temp(1)+4*sum(temp(2:2:(end-1)))+2*sum(temp(3:2:(end-2)))+temp(end))*(eta(3)-eta(2))/3;
            sigma_I=qe^2/4/h*(G(h*w/2,T,mu)+sigma_inte);
            sigma=sigma_D+sigma_I;
            epsilon = 1+1i*(sigma/(w*e0*sheet_thickness));
            
        end
    end
end

