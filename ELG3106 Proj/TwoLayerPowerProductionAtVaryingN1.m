% Two layer

PI = 3.1415926;
ReflArr = [];       % Array to contain extracted reflectivity values 
TransmArr = [];     % Array to contain extracted transmissivity values
IrradArr = [];      % Array to contain irradiance values
PowerArr = [];
PowerSum = 0;
PowerSumArr = [];
N2ValsArr = [];

% Set material parameters 
    % Indicies
    N0 = 1;         % air
    N1 = 1.2;       % layer 1
    N2 = 2.62;      % layer 2
    N3 = 3.5;       % solar cell
while(N1 <= 1.9)
        % Reflective Coefficient
        R01 = (N0-N1)/(N0+N1);
        R12 = (N1-N2)/(N1+N2);
        R23 = (N2-N3)/(N2+N3); 
        % Transmission Coefficient
        T01 = (2*N0)/(N0+N1);
        T12 = (2*N1)/(N1+N2);
        T23 = (2*N2)/(N2+N3);

        % Dynamical Matrix
        Q01 = (1/T01)*[1 R01; R01 1];
        Q12 = (1/T12)*[1 R12; R12 1];
        Q23 = (1/T23)*[1 R23; R23 1];

    % Set Design Parameters
        % Center wavelength
        Wc = 650;

        % Layer thickness

    % Calculate Transfer matrix

        for W = 200:2200        % Wavelength range from 400 to 1400 nm
            Delta = (PI*Wc)/(2*W);

            % Propagation Matrix
            P1 = [exp(j*Delta) 0; 0 exp(-j*Delta)];
            P2 = P1;            % same delta

            % Transfer Matrix
            T = Q01*(P1*Q12*P2*Q23);

            % Extract Reflectivity
                R = T(2,1)/T(1,1);      % Reflectiive coeficient from transfer matrix
                Refl = (abs(R))^2;

                % Record reflectivity value
                ReflArr = [ReflArr Refl];

            % Extract Transmissivity
                taow = (1/T(1,2));      % transmission coefficient via transfer matrix
                Transm = ((abs(taow))^2)*(N3/N0);

                % Record transmissivity value
                TransmArr = [TransmArr Transm];

            % Compute Irradiance value   
                Irrad = (6.16*10^15)/((W^5)*(exp(2484/W)-1));
                IrradArr = [ IrradArr Irrad];

            % Compute Power
                Power = Irrad*Transm;
                PowerArr = [PowerArr Power];

                PowerSum = PowerSum + Power;
        end;
        
        N1 = N1 + 0.1;
        N2ValsArr = [N2ValsArr N1];
        PowerSumArr = [PowerSumArr PowerSum];
        
        ReflArr = [];       % Array to contain extracted reflectivity values 
        TransmArr = [];     % Array to contain extracted transmissivity values
        IrradArr = [];      % Array to contain irradiance values
        PowerArr = [];
        PowerSum = 0;
end
   % Plot N2 against power production:
   plot(N2ValsArr, PowerSumArr);
   xlabel('N1 - Index of refraction')
   ylabel('Power Production (W/m^2)')
       

   
   