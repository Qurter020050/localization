function [ theta_L ] = estimateAzimutILD(ILD_m,ILD_ref ,methode )
%
% [ theta_L ] = estimateAzimutILD(ILD_m,ILD_ref,Naz,Nband ,methode )
%
% estimateAzimutILD : estimation de l'azimut � partir de l'ILD et d'une carte
% IN
%          ILD_m     : vecteur d'ILD
%          ILD_ref   : carte ILD issues d'HRTF
%          Naz       : nombre de valeurs d'azimut
%          Nband     : nombre de bande
%          methode   : m�thode de rattachement � la carte('step'/'full')
% OUT
%          theta_L   : matrice d'azimut estim� par ILD

    [Naz Nband]=size(ILD_ref);
    
    %init matrice azimut estimes
    theta_L=zeros(Nband,Naz);
    
    % deviation par azimut de la carte
    %EC =std(ILD_ref,1);
    
    switch methode
        
        case 'together' 
            
            % repetition des ILDs
            tmp=repmat(ILD_m,1,Naz);

            % distance minimum entre ILD calcul� et ILD carte
            [val,ind] = min(sqrt(mean((tmp'-ILD_ref).^2,2)));

            % attribution d'une valeur image de la distance
            az_est_ild=zeros(1,Naz);
            az_est_ild(ind)=1;

            % copie sur chaque frequence de la valeur
            theta_L=repmat(az_est_ild,Nband,1);
            
        case 'independant'
            
            for iband=1:Nband
            
                tmp=ILD_m(iband)*ones(1,Naz);

                % recherche distance minimum par bande de frequence
                [val,ind] = min(sqrt(mean((tmp'-ILD_ref(:,iband)).^2,2)));

                % attribution d'une valeur image de la distance
                theta_L(iband,ind)=1;%EC(iband);%1/val; 
                
            end
            
        otherwise
            
            error('methode d''Estimation d''azimut � partir de l''ILD inexsitante')
    end
    

end

