
%% simple drude model
function epsilon_metal = metal_dielectric(w, wp, gamma)

    epsilon_metal =  1 - wp^2./(w.^2+1i*gamma*w);

end