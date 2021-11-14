%hACLRParametersNR Bandwidth parameters to measure ACLR
%   ACLR = hACLRParametersNR(WAVECFG) returns ACLR measurement parameters.
%   WAVECFG is an nrDLCarrierConfig object or a generator parameter
%   structure from the NR reference waveform generator,
%   hNRReferenceWaveformGenerator. ACLR is a structure containing ACLR
%   parameters.

%   Copyright 2019-2020 The MathWorks, Inc.

function aclr = hACLRParametersNR(waveCfg)

    % Get the OFDM info for SCS carrier
    if isstruct(waveCfg)
        NRB = waveCfg.Carriers.NRB;
        scs = waveCfg.Carriers.SubcarrierSpacing;
    else
        NRB = waveCfg.SCSCarriers{1}.NSizeGrid;
        scs = waveCfg.SCSCarriers{1}.SubcarrierSpacing; 
    end
    info = nrOFDMInfo(NRB,scs);

    % Channel bandwidth of the input signal    
    aclr.Bandwidth = waveCfg.ChannelBandwidth*1e6;

    % Subcarrier spacing
    aclr.SubcarrierSpacing = scs*1e3;
    
    % Transmission bandwidth
    nSubcarriers = NRB*12;
    aclr.BandwidthConfig = aclr.SubcarrierSpacing*nSubcarriers;

    % Calculate the overall signal bandwidth to support 2nd adjacent NR signal
    aclr.BandwidthACLR = ((2*aclr.Bandwidth) + (aclr.Bandwidth/2))*2;

    % Calculate the measurement oversampling ratio and sampling rate,
    % allowing for at most 85% bandwidth occupancy
    aclr.OSR = ceil((aclr.BandwidthACLR/0.85)/double(info.SampleRate));        
    aclr.SamplingRate = double(info.SampleRate)*aclr.OSR;   
    
end