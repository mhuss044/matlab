% Three layer

PI = 3.1415926;
ReflArr = [];       % Array to contain extracted reflectivity values 
TransmArr = [];     % Array to contain extracted transmissivity values
IrradArr = [];      % Array to contain irradiance values
PowerArr = [];
PowerSum = 0;
PowerSumArr = [];
N2ValArr = [];

HighestPower = 0;
BestN2 = 0;

% Set material parameters 
    % Indicies
    N0 = 1;         % air
    N1 = 1.4;       % layer 1
    N2 = 1.5;      % layer 2
    N3 = 3.15;      % layer 3
    N4 = 3.5;       % solar cell

    %N2ValArr = [N2ValArr N2];
    while(N2 <= 3.1)
        % Reflective Coefficient
        R01 = (N0-N1)/(N0+N1);
        R12 = (N1-N2)/(N1+N2);
        R23 = (N2-N3)/(N2+N3); 
        R34 = (N3-N4)/(N3+N4);
        % Transmission Coefficient
        T01 = (2*N0)/(N0+N1);
        T12 = (2*N1)/(N1+N2);
        T23 = (2*N2)/(N2+N3);
        T34 = (2*N3)/(N3+N4);

        % Dynamical Matrix
        Q01 = (1/T01)*[1 R01; R01 1];
        Q12 = (1/T12)*[1 R12; R12 1];
        Q23 = (1/T23)*[1 R23; R23 1];
        Q34 = (1/T34)*[1 R34; R34 1];

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
            P3 = P1;

            % Transfer Matrix
            T = Q01*(P1*Q12*P2*Q23*P3*Q34);

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
        
        if PowerSum > HighestPower
            HighestPower = PowerSum;
            BestN2 = N2;
        end;
        
        N2 = N2 + 0.1;
        N2ValArr = [N2ValArr N2];
        
        PowerSumArr = [PowerSumArr PowerSum];
        
        ReflArr = [];       % Array to contain extracted reflectivity values 
        TransmArr = [];     % Array to contain extracted transmissivity values
        IrradArr = [];      % Array to contain irradiance values
        PowerArr = [];
        PowerSum = 0;
   end;
   % Plot reflectivity against wavelength:
   wavelength = 200:1:2200;
   plot(N2ValArr, PowerSumArr);
   xlabel('N2 - Index of refraction')
   ylabel('Power Production (W/m^2)')
   
   HighestPower
   BestN2
   
   