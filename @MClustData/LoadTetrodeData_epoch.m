function OK = LoadTetrodeData_epoch(self, useFileDialog)

if useFileDialog
    % find basename
    [fn dn] = uigetfile(self.TText, ...
        'Select the spike data file from the desired tetrode.');
    if isequal(fn,0) % user hit cancel
        return
    end
    else
    % use "get" paradigm
    MCS = MClust.GetSettings();
    [fn dn] = feval(MCS.NeuralLoadingFunction, 'get', 'filenames');
end

[self.TTdn self.TTfn self.TText] = fileparts(fullfile(dn,fn));

self.TTdn = fileparts(self.TTdn); %Need the folder before the epoch folder
self.TTfn = [self.TTfn(end-3:end) '.'];

if exist(fullfile(self.TTdn, 'FD'), 'dir')
    self.FDdn = fullfile(self.TTdn, 'FD'); %keep this... issue is that _nt1 is not going to be loaded at the next stage
else
    self.FDdn = self.TTdn;
end


% Calculate features
OK = self.FillFeatures();
end
