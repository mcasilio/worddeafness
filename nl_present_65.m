function nl_present_641(pid)

% Version 6.4, 12/13/2016, Stephen M. Wilson, Vanderbilt University

% 6.4
% - better stimuli for semmatch syllable task
% 6.32
% - start with Philips scanner trigger `~ as well as 5
% 6.31
% - started to address linux font rendering problems
% - started to address linux video playback
% 6.3
% - in semmatch syllable matching task, made timing slower and increased
%   difficulty of control task
% - started to make compatible with linux
% - improved handling of key codes
% 6.21
% - write item information for semmatch syllable task
% 6.2
% - added syllable matching task to semmatch with ADM
% 6.12
% - Also accept '0' key in semmatch
% 6.11
% - Fixed significant bug in whowas narr timing
% - Removed whowas narr practice and renamed paradigms
% 6.1
% - Added whowas narr paradigms
% 6.01
% - Scrambled pictures for picname using Fourier method
% 6.0
% - Added new narrative paradigms for aphasia norming study
% - Added new picname paradigms for aphasia norming study
% - Made nat volume sensitive to sound_vol setting
% 5.93
% - Improved "da" tone stimuli in semmatch
% - Added quick scan paradigms to semmatch
% - Added 1-tone level of difficulty in semmatch tones condition
% - Reordered paradigms
% - Removed debug log
% 5.92
% - Fixed semmatch timing inaccuracy bug
% 5.91
% - Fixed bugs and details in new versions of semmatch
% 5.9
% - Separate auditory and visual versions of semmatch
% 5.81
% - Fixed bug in semmatch that ended the experiment after one trial of the
%   second-last block
% - Fixed bug in logging trial number
% - Reintroduced changes from version 5.73 and 5.74 that had been lost
% 5.8
% - Added semmatch experiment
% 5.74
% - Attempted to fix bug loading nat movies
% 5.73
% - Added Halloween nat paradigm
% 5.72
% - Fixed bug in selecting picname paradigms
% 5.71
% - Fixed bug involving dynamic changes to sound_vol
% 5.7
% - New picture naming paradigms, four matched runs, no audio
% - New narr hwh paradigms that are 7 minutes long
% - Interactive control of sound_vol
% - Normed cloze audio to match median rms of hwh
% - Manual and auto soundcheck based on cloze
% - Unified mechanism for user-advanced (6 key) practice trials
% 5.6
% - Added nat paradigm
% 5.5
% - Revised version of cloze
% 5.41
% - Edited cloze (pilot) to conform to all conventions
% 5.4
% - Added new study cloze (pilot) (MY)
% 5.31
% - Fixed bug loading narrsw paradigms
% - Vertically centered text in narrsw
% 5.3
% - Added spoken and written narrative study
% 5.2
% - Added delexdegram study
% 5.13
% - save breathhold screenshot
% 5.12
% - allow PID to be passed as an argument
% 5.11
% - Fixed minor error in narr hwh3 paradigms
% 5.1
% - Adjusted breathhold timing for TR = 2300
% - Shortened all sparse naratives by reducing amount of silence
% - new picname paradigms
% 5.0
% - Revamped whole script
% - Reorganized locations of paradigm and stimulus files
% - Added Spanish paradigms
% - Removed defunct paradigms
% - Removed all references to dio
% 4.62
% - Adjusted timing for trigger
% - Yellow indicator when ready for trigger
% 4.61
% - Adjusted timing for clinical fMRI
% 4.6
% - Added hwh paradigm
% - Tweaked for USB trigger
% 4.5
% - Added sparse narrative paradigm
% - Added tonguetwister paradigm
% - Added picture-guided repetition paradigm
% 4.4
% - Moved written narrative block paradigm to narrative section
% - Added repetition paradigm
% - explicitly set fs rather than reading from arbitrary .wav file
% 4.3
% - Added written narrative block paradigm (ADM)
% 4.21
% - Fixed version counter
% 4.2
% - Added pnarr paradigm
% 4.12
% - Slight fix to cvcread stimuli (no actual changes to script)
% 4.11
% - Upper case stimuli for cvcread
% - Slight changes to make cvcread parallel to all other studies
% 4.1
% - Added final stimuli/schedules of both pw and w/pwds in cvcread (Andrew)
% 4.0
% - Hierarchical study/paradigm selection menu and code organization
% - Added new picname paradigms (9.x)
% - No countdown before practice paradigms
% 3.4
% - Added new study cvcread (ADM)
% 3.3
% - Added 3-2-1 countdown before scanner trigger
% - Fixed bug where catch trials for reading were in the same location for
%   every run (randomized only once per initialization of the script)
% - Fixed bug to properly log event times for basicbold
% - Fixed bug in loguntil that sometimes logged spurious events
% 3.2
% - Moved to new computer
% - Fixed bug where state changes in keyboard, dio and audio were not
%   always captured by making persistent variables in loguntil
% 3.1
% - Doubled sound volume
% - Added 9 new picture naming paradigms, each with a balanced set of
%   pictures spanning a range of frequency and length
% - Fixed bug where cross was not turning white before pictures
% - Added basicbold paradigm
% - Randomized placement of catch trials in fast reading paradigm
% 3.0
% - Incorporated all studies in one presentation function

ver = regexprep(mfilename, '[^0-9]', '');
ver = [ver(1) '.' ver(2:end)];

logline1 = sprintf('Welcome to NL_PRESENT version %s\n', ver);
fprintf(logline1);
logline2 = sprintf('%s\n\n', datestr(now, 31));
fprintf(logline2);

% change directory
wd = pwd;
c1 = onCleanup(@()cd(wd));
mydir = which(mfilename);
mydir = fileparts(mydir);
pathstr = fileparts(mydir);
cd(pathstr);

% get participant id and open log file
if nargin < 1
  pid = input('Participant identifier: ', 's');
end
timestamp = datestr(now, 31);
timestamp(timestamp == ' ') = '_';
timestamp(timestamp == ':') = '-';
if ~isempty(pid)
  logfname = sprintf('logs/log_%s_%s.txt', timestamp, pid);
  disp(logfname);
else
  logfname = sprintf('logs/log_%s.txt', timestamp);  
end
fid = fopen(logfname, 'a+');
c2 = onCleanup(@()fclose(fid));
fprintf(fid, [logline1 logline2 'Participant identifier: ' pid '\n']);

% studies
fmristudies = {'semmatch', 'nat', 'fmap', 'basicbold', 'picname', 'reading', ...
  'narr', 'narrsw', 'artic', 'cvcread', 'rest', 'breathhold', 'delexdegram', 'cloze', 'quit'};
SEMMATCH = 1;
NAT = 2;
FMAP = 3;
BASICBOLD = 4;
PICNAME = 5;
READING = 6;
NARR = 7;
NARRSW = 8;
ARTIC = 9;
CVCREAD = 10;
REST = 11;
BREATHHOLD = 12;
DELEXDEGRAM = 13;
CLOZE = 14;
QUIT = 15;

% paradigms
paradigms{SEMMATCH} = {'written-practice', 'written-adaptive', 'written-scan', 'written-quickscan', 'auditory-practice', 'auditory-adaptive', 'auditory-scan', 'auditory-quickscan', 'syl-practice', 'syl-adaptive', 'syl-scan', 'syl-quickscan'};
paradigms{NAT} = {'practice', 'mathlete', 'mascot', 'newgirl', 'halloween'};
paradigms{FMAP} = {'on', 'arn', 'vrn', 'tongue', 'hand', 'foot', 'on-spanish', 'arn-spanish', 'vrn-spanish', 'tongue-spanish', 'hand-spanish', 'foot-spanish'};
paradigms{BASICBOLD} = {'checkerboard'};
paradigms{PICNAME} = {'practice', '1', '2', '3', '4', 'av1', 'av2', 'av3', 'sc1', 'sc2'};
paradigms{READING} = {'fast', 'slow'};
paradigms{NARR} = {'practice', 'pp', 'pp-spanish', 'hwh1', 'hwh2', 'hwh3', 'hwh4', 'hwh5', 'hwh6', 'written', 'hwh4practice', 'hwh41', 'hwh42', 'hwh43', 'hwh44', 'hwh45', 'hwh5prac', 'hwh51', 'hwh52', 'einstein', 'beatles'};
paradigms{NARRSW} = {'1', '2', '3', '4', '5'};
paradigms{ARTIC} = {'practice', 'real'};
paradigms{CVCREAD} = {'practice', 'p1', 'p2', 'p3', 'wp1', 'wp2', 'wp3'};
paradigms{REST} = {' '};
paradigms{BREATHHOLD} = {'practice', 'real'};
paradigms{DELEXDEGRAM} = {'c1', 'c2', 'c3', 'c4', 'c5', 'c6', 'c7', 'c8', 's1', 's2', 's3', 's4', 's5', 's6', 's7', 's8'};
paradigms{CLOZE} = {'practice', 'manual-soundcheck', 'auto-soundcheck', '11', '12', '13', '14', '21', '22', '23', '24', '31', '32', '33', '34'};
paradigms{QUIT} = {' '};

preload = []; % e.g. [FMAP NARR];
loaded = zeros(length(fmristudies), 1);

% misc initialization
bgcolor = 192;
cmap = 0:(bgcolor / 255):bgcolor;
textcolor = 0;
whitecolor = 255;
q = false;
fs = 44100;
splashpic = imread('paradigms/splash.jpg');
if exist(fullfile(mydir, 'sound_vol.txt'), 'file')
  sound_vol = dlmread(fullfile(mydir, 'sound_vol.txt'));
else
  sound_vol = 1;
end

spiralsound = ptbwavread('paradigms/spiralsound.wav');

% set up screen
%Screen('Preference', 'SkipSyncTests', 1); % for UCSF
Screen('Preference', 'DefaultTextYPositionIsBaseline', 1);
HideCursor;
c3 = onCleanup(@()ShowCursor);
[w, wrect] = Screen('OpenWindow', 0);
w2 = Screen('OpenOffscreenWindow', 0);
c4 = onCleanup(@()Screen('CloseAll'));
x = wrect(3) / 2;
y = wrect(4) / 2;

% set up sound
InitializePsychSound;
deviceId = []; % this defaults to finding the ASIO driver
mode = []; % sound playback only
regLatencyClass = 2; % take full control of audio device
nchan = 2;
pahandle = PsychPortAudio('Open', deviceId, mode, regLatencyClass, fs, nchan);
c5 = onCleanup(@()PsychPortAudio('Close', pahandle));
% play a dummy sound in order to speed up the first sound later
PsychPortAudio('FillBuffer', pahandle, 0 * spiralsound);
PsychPortAudio('Start', pahandle, 1, 0, 1);

% set up keyboard
KbName('UnifyKeyNames');
quitCode = KbName('q');

while true
  if ~isempty(preload)
    % preload stimuli
    Screen('FillRect', w, bgcolor);
    Screen('Flip', w);
    
    study = preload(1);
    paradigm = 0;
    preload = preload(2:end);
    
  else
    % main menu
    if ~exist('go', 'var')
      study = 1;
      paradigm = 1;
    end
    go = false;
    while ~go
      Screen('FillRect', w, bgcolor);

      % splash
      [ysize, xsize, nchannels] = size(splashpic); %#ok<NASGU>
      sfac = 0.4;
      picrect = round([x - xsize / 2 * sfac, y - ysize / 2 * sfac, x + xsize / 2 * sfac, y + ysize / 2 * sfac]);
      Screen('PutImage', w, splashpic, picrect);

      % text under splash
      Screen('TextFont', w, 'Monospaced');
      Screen('TextSize', w , 60);
      Screen('TextStyle', w, 1); % bold

      txt = 'University';
      bounds = Screen('TextBounds', w, txt);
      Screen('DrawText', w, txt, x - bounds(3) / 2, y + ysize / 2 * sfac + bounds(4) / 3, textcolor);            
      txt = 'of';
      bounds = Screen('TextBounds', w, txt);
      Screen('DrawText', w, txt, x - bounds(3) / 2, y + ysize / 2 * sfac + bounds(4) / 3 + 0.9 * bounds(4), textcolor);            
      txt = 'Arizona';
      bounds = Screen('TextBounds', w, txt);
      Screen('DrawText', w, txt, x - bounds(3) / 2, y + ysize / 2 * sfac + bounds(4) / 3 + 1.8 * bounds(4), textcolor);            

      % draw menu
      ygap = 16;
      xgap = 12;
      Screen('TextSize', w , 9);

      for i = 0:length(fmristudies)
        if i == 0
          txt = sprintf('NL_PRESENT %s               sound_vol = %.1f', ver, sound_vol);
        else
          txt = fmristudies{i};
        end
        curx = 50;
        if study == i
          txtcolor = whitecolor;
        else
          txtcolor = bgcolor - 30;
        end
        Screen('DrawText', w, txt, curx, 50 + i * ygap, txtcolor);
        bounds = Screen('TextBounds', w, txt);
        curx = curx + bounds(3) + xgap;      

        if i >= 1
          for j = 1:length(paradigms{i})
            txt = paradigms{i}{j};
            if study == i && paradigm == j
              txtcolor = whitecolor;
            else
              txtcolor = bgcolor - 30;
            end
            Screen('DrawText', w, txt, curx, 50 + i * ygap, txtcolor);
            bounds = Screen('TextBounds', w, txt);
            curx = curx + bounds(3) + xgap;
          end
        end
      end
      Screen('Flip', w);

      % navigate through menu
      keyIsDown = true;
      while keyIsDown
        [keyIsDown, ~, keyCode] = KbCheck;
      end
      keyIsDown = false;
      while ~keyIsDown
        [keyIsDown, ~, keyCode] = KbCheck;
      end
      key = KbName(keyCode);
      if iscell(key)
        key = key{1};
      end
      switch key
        case 'LeftArrow'
          paradigm = max(paradigm - 1, 1);
        case 'RightArrow'
          paradigm = min(paradigm + 1, length(paradigms{study}));
        case 'UpArrow'
          study = max(study - 1, 1);
          paradigm = min(paradigm, length(paradigms{study}));
        case 'DownArrow'
          study = min(study + 1, length(fmristudies));
          paradigm = min(paradigm, length(paradigms{study}));
        case '=+'
          sound_vol = sound_vol + 0.1;
          dlmwrite(fullfile(mydir, 'sound_vol.txt'), sound_vol);
        case '-_'
          sound_vol = sound_vol - 0.1;
          dlmwrite(fullfile(mydir, 'sound_vol.txt'), sound_vol);
        case 'q' % q (quit)
          return;
        case 'Return'
          go = true;
      end
    end
    if study == QUIT
      return;
    else
      fprintf(fid, '%s Starting study %s paradigm %s\n', datestr(now, 31), fmristudies{study}, paradigms{study}{paradigm});
      Screen('FillRect', w, bgcolor);
      drawcrosshair(w, [255 0 0]);
      Screen('Flip', w);      
    end
  end

  % set up paradigm
  switch study
    case FMAP
      expduration = 272; % 136 volumes with TR = 2000 ms

      if ~loaded(FMAP)
        loaded(FMAP) = true;

        % object naming
        fnames = textread('paradigms/fmap/on.txt', '%s'); %#ok<*REMFF1>
        onpic = cell(32, 1);
        for i = 1:32
          onpic{i} = imread(sprintf('paradigms/fmap/on/%s.bmp', fnames{i}));
          onpic{i} = cmap(onpic{i} + 1);
        end
        % auditory responsive naming
        fnames = textread('paradigms/fmap/arn.txt', '%s');
        arnwav = cell(34, 1);
        for i = 1:34
          arnwav{i} = ptbwavread(sprintf('paradigms/fmap/arn/%s.wav', fnames{i}));
        end
        % visual responsive naming
        vrntext = textread('paradigms/fmap/vrn.txt', '%s', 'delimiter', '\n');
        % motor mapping
        mpic = cell(5, 1);
        mpic{1} = imread('paradigms/fmap/motor/stop.jpg');
        mpic{2} = imread('paradigms/fmap/motor/tongue.jpg');
        mpic{3} = imread('paradigms/fmap/motor/hand.jpg');
        mpic{4} = imread('paradigms/fmap/motor/foot.jpg');
        mpic{5} = imread('paradigms/fmap/motor/go.jpg'); % this is actually used for repetition
        for i = 1:5
          mpic{i} = cmap(mpic{i} + 1);
        end
        mmaptext = cell(4, 1);
        mmaptext{1} = 'Rest now';
        mmaptext{2} = 'Move your tongue';
        mmaptext{3} = 'Move your fingers';
        mmaptext{4} = 'Move your feet';
        % arn spanish
        fnames = textread('paradigms/fmap/arn-spanish.txt', '%s', 'delimiter', '\n');
        arnspanishwav = cell(34, 1);
        for i = 1:34
          arnspanishwav{i} = ptbwavread(sprintf('paradigms/fmap/arn-spanish/%s.wav', fnames{i}));
        end
        % vrn spanish
        vrnspanishtext = textread('paradigms/fmap/vrn-spanish.txt', '%s', 'delimiter', '\n');
        % motor spanish
        mmapspanishtext = cell(4, 1);
        mmapspanishtext{1} = 'Descanse ahora';
        mmapspanishtext{2} = 'Move your tongue'; % translate!
        mmapspanishtext{3} = 'Move your fingers'; % translate!
        mmapspanishtext{4} = 'Move your feet'; % translate!
      end

      events = [1 * ones(9, 1), (0:32:256)']; % rest
      events = [events; [2 * ones(8, 1), (16:32:240)']]; %#ok<AGROW> % instruction
      trial1 = (18:32:242)';
      events = [events; [3 * ones(32, 1), [trial1; trial1 + 3.5; trial1 + 7; trial1 + 10.5]]]; %#ok<AGROW> % trials
      events = sortrows(events, 2);

    case BASICBOLD
      expduration = 377.2; % 164 volumes, TR = 2300; 
      cboard1 = repmat(kron(255 * eye(2), ones(10)), [11 11 3]);
      cboard2 = repmat(kron(255 * (1 - eye(2)), ones(10)), [11 11 3]);
      basicbold_sound = rand(2, round(fs * 2.0));
      events = dlmread(sprintf('paradigms/picname/picname_paradigm%02d.txt', 1));
      
    case PICNAME
      if ~loaded(PICNAME)
        loaded(PICNAME) = true;

        picnamepic = cell(260, 1);
        for i = 1:260
          picnamepic{i} = imread(sprintf('paradigms/picname/pics/%03d.bmp', i));
          picnamepic{i} = cmap(picnamepic{i} + 1);
        end

        scramblepic = cell(260, 1);
        for i = 1:260
          scramblepic{i} = imread(sprintf('paradigms/picname/scrambled_pics/%03d.jpg', i));
          scramblepic{i} = cmap(scramblepic{i} + 1);
        end
        
        picnamewav = cell(260, 1);
        for i = 1:260
          picnamewav{i} = ptbwavread(sprintf('paradigms/picname/wavs/%03d_norm.wav', i));
        end
      end
      
      switch paradigm
        case 1 % practice
          expduration = inf;
%           events = dlmread('paradigms/picname/picname_langmap_practice.txt');
          events = dlmread('paradigms/picname/picname_scp.txt');
        case {2, 3, 4, 5}
          expduration = 420; % 210 volumes, TR = 2000;
          events = dlmread(sprintf('paradigms/picname/picname_langmap%02d.txt', paradigm - 1));
        case {6, 7, 8}
          expduration = 377.2; % 164 volumes, TR = 2300; 
          events = dlmread(sprintf('paradigms/picname/picname_paradigm%02d.txt', paradigm - 5));
        case {9, 10}
          expduration = 400;
          events = dlmread(sprintf('paradigms/picname/picname_sc%d.txt', paradigm - 8));          
      end

    case READING
      expduration = 360; % 180 volumes with TR = 2
      
      six_letter_words = textread('paradigms/reading/six-letter-words.txt', '%s', 'delimiter', '\n');
      varying_length_words = textread('paradigms/reading/varying-length-words.txt', '%s', 'delimiter', '\n');
      false_font = [915 916 923 928 931 934 936 937 948 952 955 1026 1041 ...
        1048 1060 1063 1067 1068 915 916 923 928 931 934 936 937];

      events = [1.1 0; 3 20; 2.6 40; 1.2 60; 2.5 80; 3 100; 2.4 120; ...
        1.3 140; 3 160; 2.3 180; 3 200; 1.4 220; 3 240; 1.5 260; ...
        2.2 280; 1.6 300; 2.1 320; 3 340];

      switch paradigm
        case 1 % fast
          events_ = events;
          events = [];
          for i = 1:size(events_, 1)
            if floor(events_(i, 1)) == 1
              events = [events; 1 * ones(67, 1), events_(i, 2) + (0:0.3:19.8)']; %#ok<AGROW>
              events = [events; 3 * ones(67, 1), events_(i, 2) + (0.1:0.3:19.9)']; %#ok<AGROW>
            elseif floor(events_(i, 1)) == 2
              events = [events; 2 * ones(67, 1), events_(i, 2) + (0:0.3:19.8)']; %#ok<AGROW>
              events = [events; 3 * ones(67, 1), events_(i, 2) + (0.1:0.3:19.9)']; %#ok<AGROW>
            elseif events_(i, 1) == 3
              events = [events; 4, events_(i, 2)]; %#ok<AGROW>
            end
          end
          events = sortrows(events, 2);
          wordorder = randperm(469);

          catchtrials = sort([0 randperm(5)] * 67 + floor(rand(1, 6) * 50) + 15);
          catchtrials = catchtrials(1:4);
          ff_catchtrials = sort([0 randperm(5)] * 67 + floor(rand(1, 6) * 50) + 15);
          ff_catchtrials = ff_catchtrials(1:4);

        case 2 % slow
          events_ = events;
          events = [];
          for i = 1:size(events_, 1)
            if floor(events_(i, 1)) == 1
              events = [events; 1 * ones(8, 1), events_(i, 2) + (0:2.5:17.5)']; %#ok<AGROW>
              events = [events; 3 * ones(8, 1), events_(i, 2) + (2:2.5:19.5)']; %#ok<AGROW>
            elseif floor(events_(i, 1)) == 2
              events = [events; 2 * ones(8, 1), events_(i, 2) + (0:2.5:17.5)']; %#ok<AGROW>
              events = [events; 3 * ones(8, 1), events_(i, 2) + (2:2.5:19.5)']; %#ok<AGROW>
            elseif events_(i, 1) == 3
              events = [events; 4, events_(i, 2)]; %#ok<AGROW>
            end
          end
          events = sortrows(events, 2);
      end

    case NARR
      if ~loaded(NARR)
        loaded(NARR) = true;

        nstories = 6;
        maxsegs = 90;
        narrwav = cell(nstories, maxsegs, 2);
        for story = 1:nstories
          switch story
            case 1
              storyname = 'pp/jacks%d';
              nsegs = 2;
            case 2
              storyname = 'pp/pps%d';
              nsegs = 19;
            case 3
              storyname = 'pp-spanish/pps%d';
              nsegs = 19;
            case 4
              storyname = 'hwh3/%03d';
              nsegs = 90;
            case 5
              storyname = 'hwh5/hwh5-%02d';
              nsegs = 20;
            case 6
              storyname = 'whowas/whowas%02d';
              nsegs = 20;              
          end
          for seg = 1:nsegs
            narrwav{story, seg, 1} = ptbwavread(sprintf(['paradigms/narr/' storyname '.wav'], seg));
            narrwav{story, seg, 2} = fliplr(narrwav{story, seg, 1}); % reverse
          end
        end
        
        % written narrative
        wp_narr_story = textread('paradigms/narr/written/StoryRumpel1and2.txt','%s','delimiter','\n'); % the whole story...
        wp_narr_onsets = dlmread('paradigms/narr/written/SpokenOnsetsRump1and2.txt'); % onsets of spoken words...
        wp_word_breaks = [1 findstr(wp_narr_story{1},' ')]; %#ok<FSTR> % 0 is so we get the first element when we look for words by chr60s
      
        einstein_pic = imread('paradigms/narr/whowas/einstein.jpg');
        beatles_pic = imread('paradigms/narr/whowas/beatles.jpg');
      end

      switch paradigm
        case 1
          expduration = inf; % practice
          events = dlmread('paradigms/narr/pp/jacks-timing.txt');
          events = [events; [99 * ones(20, 1), (0:9:(9 * (20 - 1)))']]; %#ok<AGROW>
          events = sortrows(events, 2);
        case 2
          expduration = 477.5; % 50 trials + one extra TR at the end = 51 volumes with TR = 9500
          events = dlmread('paradigms/narr/pp/pp-timing.txt');
        case 3
          expduration = 477.5; % 50 trials + one extra TR at the end = 51 volumes with TR = 9500
          events = dlmread('paradigms/narr/pp-spanish/pp-spanish-timing.txt');
        case {4, 5, 6, 7, 8, 9}
          expduration = 382.5; % 40 trials + one extra TR at the end = 41 volumes with TR = 9500
          events = dlmread(sprintf('paradigms/narr/hwh3/hwh3_paradigm%02d.txt', paradigm - 3));

        case 10 % This is the written narrative (wp-block) by ADM
          expduration = 360;
          % Scale the actual spoken times and make into blocks as per Kindle and Pagie (for scrolling...)
          events = [1.1 0; 3 20; 2.1 40; 1.2 60; 2.2 80; 3 100; 2.3 120; ...
            1.3 140; 3 160; 2.4 180; 3 200; 1.4 220; 3 240; 1.5 260; ...
            2.5 280; 1.6 300; 2.6 320; 3 340]; % we'll use the .1 etcs to offset the items we're reading in.
          events_ = events; events = [];
          scale = 1.5; % Slow the display times by scaling the onsettimes...
          wp_narr_onsets = wp_narr_onsets*scale;
          WordNumber=0; % we'll use this later to decide how many words to display/accumulate in each block ..
          clear wordlists;
          block = 0; %hack fix...
          for i = 1:size(events_, 1)
            if floor(events_(i, 1)) ~= 3 % let's insert some text!
              BlockNumber = 10*mod(events_(i,1),1); % pulls the e.g. "4" off event 2.4
              BlockLength = 20; BlockType = floor(events_(i,1)); % 1 or 2...
              % Pull correct elements based on time (the decimal of the block!)...
              BlockWords = find((BlockNumber-1)*BlockLength < wp_narr_onsets & wp_narr_onsets < BlockNumber*BlockLength);
              % We'll pull the actual words from wordlists{i} during presentation (same for words and NONWORDS!)
              if floor(events_(i,1)) == 1 % we'll only do this for word lists... we'll reuse the same strings for nonwords though.
                block = block+1; % ghetto fix...
                text = wp_narr_story{1}(wp_word_breaks(min(BlockWords)):wp_word_breaks(max(BlockWords)+1));
                wordlists{block} = text; %#ok<AGROW>
              end
              RelativeOnsets = wp_narr_onsets(BlockWords)-((BlockNumber-1)*BlockLength);
              events = [events; BlockType+(BlockNumber/10) * ones(numel(BlockWords), 1), events_(i,2)+RelativeOnsets]; %#ok<AGROW>
            else
              events = [events; 3, events_(i, 2)]; %#ok<AGROW>
            end
          end
          assignin('base','investigate',wordlists);
          % make scrambled wordlists
          for m=1:6
            text = wordlists{m};
            newtext = [];
            for CharNum=1:numel(text)
              currentchar = text(CharNum);
              if double(currentchar) >= 97 && double(currentchar) <= 122 % lowercase
                currentchar = char(97+floor(rand(1,1)*25));
              elseif double(currentchar) >= 65 && double(currentchar) <= 90 % uppercase
                currentchar = char(65+floor(rand(1,1)*25));
              end
              newtext = [newtext currentchar]; %#ok<AGROW>
            end
            scramblewordlists{m} = newtext; %#ok<AGROW>
          end
          
        case 11
          expduration = inf; % practice
          events = dlmread('paradigms/narr/hwh3/hwh4_practice.txt');
        case {12, 13, 14, 15, 16}
          expduration = 420; % 44 trials + one extra TR at the end = 45 volumes with TR = 9500
          events = dlmread(sprintf('paradigms/narr/hwh3/hwh4_paradigm%02d.txt', paradigm - 11));
        case 17
          expduration = inf;
          events = dlmread('paradigms/narr/hwh5/hwh5prac.txt');
        case {18, 19}
          expduration = 400;
          events = dlmread(sprintf('paradigms/narr/hwh5/hwh5%d.txt', paradigm - 17));
        case {20, 21}
          expduration = 400;
          events = dlmread(sprintf('paradigms/narr/whowas/whowas%d.txt', paradigm - 19));
      end
      
    case NARRSW
      if ~loaded(NARRSW)
        loaded(NARRSW) = true;

        narrsw_wav = cell(3, 10, 2);
        for r = 1:3
          for item = 1:10
            switch r
              case 1
                story = 'beatles';
              case 2
                story = 'amelia';
              case 3
                story = 'galileo';
            end
            fname = sprintf('paradigms/narr2200/%s%d.wav', story, item);
            if exist(fname, 'file')
              narrsw_wav{r, item, 1} = ptbwavread(fname);
              narrsw_wav{r, item, 2} = fliplr(narrsw_wav{r, item, 1}); % reverse
            end
          end
        end

        edison_pic = imread('paradigms/narr2200/edison.jpg');
        beatles_pic = imread('paradigms/narr2200/beatles.jpg');
        shakespeare_pic = imread('paradigms/narr2200/shakespeare.jpg');
        amelia_pic = imread('paradigms/narr2200/amelia.jpg');
      end
      

      run = mod(paradigm - 1, 4) + 1;
      parad = txtread(sprintf('paradigms/narr2200/narr2200_paradigm%d.txt', paradigm));
      switch paradigm
        case 2
          run = 1;
        case 4
          run = 2;
        case 5
          run = 3;
        otherwise
          run = 0;
      end

      events = [parad.event_type, parad.onset, parad.duration, parad.height];
      words = parad.word;

      expduration = 480;

    case ARTIC
      expduration = 382.5; % 40 volumes with TR of 9.5 seconds + one extra TA of 2.5 seconds at the end; total 41 volumes
      artic_words = textread('paradigms/artic/artic-words.txt', '%s', 'delimiter', '\n');
      events = dlmread('paradigms/artic/artic-paradigm01.txt');
      
    case CVCREAD
      expduration = 360;

      all_cvcread_stims = textread('paradigms/cvcread/CVCreadLists.txt','%s','delimiter','\n'); % Load in all lists from one concatenated file.    

      if paradigm ~= 8
        cvcread_stims = all_cvcread_stims(((paradigm - 1) * 42) + 1 : ((paradigm - 1) * 42) + 42); % Extract the 42 stimuli based on paradigm # indicated.
      end
      switch paradigm
        case 1 % pseudoword practice
          events = dlmread('paradigms/cvcread/NWProtocolFinalParms04.txt'); % 4th best goes to practice
        case 2 % pseudoword list 1
          events = dlmread('paradigms/cvcread/NWProtocolFinalParms01.txt'); % Load the correct event timing for this run.
        case 3 % pseudoword list 2
          events = dlmread('paradigms/cvcread/NWProtocolFinalParms02.txt');
        case 4 % pseudoword list 3
          events = dlmread('paradigms/cvcread/NWProtocolFinalParms03.txt');
        case 5 % mixed word pseudoword list 1
          events = dlmread('paradigms/cvcread/MixedStimulusOrdering01.txt');
        case 6 % mixed word pseudoword list 2
          events = dlmread('paradigms/cvcread/MixedStimulusOrdering02.txt');
        case 7 % mixed word pseudoword list 3
          events = dlmread('paradigms/cvcread/MixedStimulusOrdering03.txt');
      end
      events=[ones(size(events, 1), 1), events(:, 2)]; % Still CVC read - pad column 1 with 1s and only retain onset times      

    case REST
      expduration = 294.4;
      events = [1 -8];
      
    case BREATHHOLD
      expduration = 294.4; % 128 volumes, TR = 2300

      bg = 128;
      linewidth = 5;
      window = 30;
      curposwithinwindow = 1 / 4;
      ballradius = 10;
      skip = 3;

      % breathe
      normalbreath = 4.6;
      microtime = 0.01;
      t = (0:microtime:(normalbreath - microtime))';
      b = sin(t / normalbreath * 2 * pi - (pi / 2));
      b0 = -ones(size(b));

      if paradigm == 1 % practice
        parad = [repmat(b, [22 1]); repmat([repmat(b0, [3 1]); repmat(b, [4 1])], [6 1]); repmat(b, [30 1])];
      else % real
        parad = [repmat(b, [25 1]); repmat([repmat(b0, [3 1]); repmat(b, [6 1])], [6 1]); repmat(b, [30 1])];
      end
      % extra 15 normal breaths at the start to allow for "already done" part of waveform
      
    case DELEXDEGRAM
      if ~loaded(DELEXDEGRAM)
        loaded(DELEXDEGRAM) = true;

        nstories = 2;
        maxsegs = 86;
        nconds = 4;
        dldgwav = cell(nstories, maxsegs, nconds);
        for story = 1:nstories
          switch story
            case 1
              storyname = 'cind';
              nsegs = 86;
            case 2
              storyname = 'sleep';
              nsegs = 70;
          end
          for seg = 1:nsegs
            dldgwav{story, seg, 1} = ptbwavread(sprintf('paradigms/delexdegram/%s%03d_normal.wav', storyname, seg));
            dldgwav{story, seg, 2} = ptbwavread(sprintf('paradigms/delexdegram/%s%03d_degram.wav', storyname, seg));
            dldgwav{story, seg, 3} = ptbwavread(sprintf('paradigms/delexdegram/%s%03d_delex.wav', storyname, seg));
            dldgwav{story, seg, 4} = ptbwavread(sprintf('paradigms/delexdegram/%s%03d_scram.wav', storyname, seg));
          end
        end
      end
      
      if paradigm <= 8
        expduration = 1016.5; % 106 trials + one extra TR at the end = 107 volumes with TR = 9500
        events = dlmread(sprintf('paradigms/delexdegram/delexdegram_paradigm_c%d.txt', paradigm));
      else
        expduration = 864.5; % 90 trials + one extra TR at the end = 91 volumes with TR = 9500
        events = dlmread(sprintf('paradigms/delexdegram/delexdegram_paradigm_s%d.txt', paradigm - 8));
      end
    
    case CLOZE
      expduration = 420; % 210 volumes, TR = 2000
      if ~loaded(CLOZE)
        loaded(CLOZE) = true;
        clozewav = cell(200,1);
        for i = 1:200
          clozewav{i} = ptbwavread(sprintf('paradigms/cloze/%03d.wav', i));
        end
        clozetxt = textread('paradigms/cloze/cloze.txt', '%s', 'delimiter', '\n');
      end
      events = dlmread(sprintf('paradigms/cloze/cloze_%s.txt', paradigms{CLOZE}{paradigm}));
      
    case NAT
      % attempt to avoid crashes
%       clear c5
%       pahandle = PsychPortAudio('Open', deviceId, mode, regLatencyClass, fs, nchan);
%       c5 = onCleanup(@()PsychPortAudio('Close', pahandle));
%       diary([logfname(1:end - 4) '_debug.txt']);
%       memory
%       whos
%       diary off
      
      [moviePtr, expduration] = Screen('OpenMovie', w, fullfile(pwd, sprintf('paradigms/nat/%s.f4v', paradigms{NAT}{paradigm})));
      % this does not currently work. for a start, the video format cannot
      % be played by gstreamer. but even if a video is used of acceptable
      % format (e.g. mp4), it seems necessary to turn off PortAudio for the
      % movie to play. This could be done easily enough.
  
    case SEMMATCH
      expduration = inf;
      if ~loaded(SEMMATCH)
        loaded(SEMMATCH) = true;
        matches = txtread('paradigms/semmatch/matches.txt');
        mismatches = txtread('paradigms/semmatch/mismatches.txt');
        syl_pseudowords = txtread('paradigms/semmatch/syl_pseudowords.txt');  
        
        d = dir('paradigms/semmatch/words/*.wav');
        for i = 1:length(d)
          wav = ptbwavread(['paradigms/semmatch/words/' d(i).name]);
           % previously amplified x3 with extra argument 3 to ptbwavread
%           wav = wav(:, sum(wav, 1) ~= 0); % remove silence from beginning and end
          semmatch_wavs.(d(i).name(1:end - 4)) = wav;
        end
        
        symfid = fopen('paradigms/semmatch/symbols.txt', 'r', 'native', 'utf8');
        symbols = fgetl(symfid);
        symbols = double(symbols); % unicode
        fclose(symfid);
        
        ding = ptbwavread('paradigms/semmatch/ding.wav');
        da = cell(3, 5);
        da{1, 1} = ptbwavread('paradigms/semmatch/da/da1_830.wav');
        da{1, 2} = ptbwavread('paradigms/semmatch/da/da1_415.wav');
        da{1, 3} = ptbwavread('paradigms/semmatch/da/da1_276.wav');
        da{1, 4} = ptbwavread('paradigms/semmatch/da/da1_208.wav');
        da{1, 5} = ptbwavread('paradigms/semmatch/da/da1_166.wav');
        da{2, 1} = ptbwavread('paradigms/semmatch/da/da2_830.wav');
        da{2, 2} = ptbwavread('paradigms/semmatch/da/da2_415.wav');
        da{2, 3} = ptbwavread('paradigms/semmatch/da/da2_276.wav');
        da{2, 4} = ptbwavread('paradigms/semmatch/da/da2_208.wav');
        da{2, 5} = ptbwavread('paradigms/semmatch/da/da2_166.wav');
        da{3, 1} = ptbwavread('paradigms/semmatch/da/da3_830.wav');
        da{3, 2} = ptbwavread('paradigms/semmatch/da/da3_415.wav');
        da{3, 3} = ptbwavread('paradigms/semmatch/da/da3_276.wav');
        da{3, 4} = ptbwavread('paradigms/semmatch/da/da3_208.wav');
        da{3, 5} = ptbwavread('paradigms/semmatch/da/da3_166.wav');
      end      

      semlogfname = sprintf('logs/log_semmatch_%s.txt', pid);
      % if the log file does not exist, create it and write a header row
      if ~exist(semlogfname, 'file')
        smfid = fopen(semlogfname, 'a+');
        fprintf(smfid, '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', ...
          'datetime', 'intended_time', 'actual_time', 'run_id', 'paradigm', 'cond', 'match', 'difficulty', ...
          'rt_window', 'item', 'response', 'rt', 'correct', 'new_difficulty');
      else % otherwise open it for writing
        smfid = fopen(semlogfname, 'a+');
      end
      % read what is there already (which may be nothing but the column headings)
      history = txtread(semlogfname);
      nhistory = length(history.datetime);
      
      block_length = 20;
      nblocks = 20;
      n_difficulty_levels = 7;
      if paradigm <= 4 % written
        max_stims_per_block = 10;
        min_stims_per_block = 4;
        ignore_window = 0.3;
      elseif paradigm >= 5 && paradigm <= 8 % auditory
        max_stims_per_block = 7;
        min_stims_per_block = 4;
        ignore_window = 0.83;       
      elseif paradigm >= 9 % syl
        max_stims_per_block = 10;
        min_stims_per_block = 4;
        ignore_window = 0.3;
      end
      if paradigm == 4 || paradigm == 8 || paradigm == 12 % quick scan
        nblocks = 12;
      end
      if ~exist('training_difficulty', 'var')
        training_difficulty = 1;
      end
      step_harder = 1;
      step_easier = 2;
      nwords = length(matches.word1);
      n_very_easy_items = 50;
      diff_ranges{1} = 1:n_very_easy_items; %#ok<AGROW>
      for i = 2:n_difficulty_levels
        diff_ranges{i} = (diff_ranges{i - 1}(end) + 1):(n_very_easy_items + ceil((i - 1) / (n_difficulty_levels - 1) * (nwords - n_very_easy_items))); %#ok<AGROW>
      end
      iti = 0.1;
      tones_dur = 0.83; % mean word duration
      intended_prestime = -1;
      actual_prestime = 0;
      num_letters = [];
      
      run_id = now;
            
      switch paradigm
        case {1, 5, 9}
          ntrials = 1000;
          expduration = inf;
        case {2, 6, 10}
          ntrials = nblocks * 6;
          upcoming_cond = repmat([ones(1, 6), 2 * ones(1, 6)], 1, 10);
          upcoming_match = [];
          for i = 1:nblocks
            r = rand;
            if r < 0.1
              next_matches = [1 1 1 1 0 0];
            elseif r < 0.2
              next_matches = [1 1 0 0 0 0];
            else
              next_matches = [1 1 1 0 0 0];
            end
            % no three in a row same
            while ~all(diff(diff(next_matches)))
              next_matches = next_matches(randperm(6));
            end
            upcoming_match = [upcoming_match next_matches]; %#ok<AGROW>
          end
          expduration = inf;
        case {3, 4, 7, 8, 11, 12}
          ntrials = 1000;
          upcoming_cond = [];
          upcoming_match = [];
          upcoming_onset = [];
          next_block_pair_onset = 0;
          expduration = nblocks * block_length;
      end
  end

  if paradigm == 0 % just preloading
    continue;
  end
  
  % start
  loguntil('reset');

  % crosshair during dummy acquisitions
  Screen('TextSize', w , 60);
  Screen('FillRect', w, bgcolor);
  if study == NARR && paradigm == 20
    Screen('PutImage', w, einstein_pic);
  elseif study == NARR && paradigm == 21
    Screen('PutImage', w, beatles_pic);
  end
  if study == NARRSW
    switch paradigm
      case 1
        Screen('PutImage', w, edison_pic);
      case 2
        Screen('PutImage', w, beatles_pic);
      case 3
        Screen('PutImage', w, shakespeare_pic);
      case 4
        Screen('PutImage', w, amelia_pic);
      end
  end
  drawcrosshair(w, [255 255 0]);
  Screen('Flip', w);

  % wait for trigger
  expstarttime = waitforkey('5`~');

  if study == NARR && paradigm == 20
    Screen('PutImage', w, einstein_pic);
  elseif study == NARR && paradigm == 21
    Screen('PutImage', w, beatles_pic);
  else
    drawcrosshair(w, textcolor);
  end
  Screen('Flip', w);
  
  % start the experiment
  switch study
    case BREATHHOLD
      while GetSecs < expstarttime + expduration
        curtime = GetSecs - expstarttime;
        wavey = zeros(x * 2, 1);
        for i = 1:(x * 2 + skip)
          wavey(i) = parad(round((curtime - (curposwithinwindow * window) + i / (x * 2) * window) * 100 + normalbreath * 15 / microtime));
        end
        curpoint = round(x * 2 * curposwithinwindow);
        Screen('FillRect', w, bg);
        for i = 1:skip:(x * 2 - 1)
          if i < curpoint - 1
            linecolor = 75;
          else
            linecolor = 255;
          end
          if i < 100
            linecolor = (i / 100) * linecolor + (100 - i) / 100 * bg;
          end
          if i > (x * 2 - 1) - 100
            linecolor = ((x * 2 - 1 - i) / 100) * linecolor + (100 - (x * 2 - 1 - i)) / 100 * bg;
          end
          Screen('DrawLine', w, repmat(linecolor, 1, 3), i, y - 100 * wavey(i), i + skip, ...
            y - 100 * wavey(i + skip), linewidth);
        end
        rect = [curpoint - ballradius, y - 100 * wavey(curpoint) - ballradius, ...
          curpoint + ballradius, y - 100 * wavey(curpoint) + ballradius];

        Screen('FillOval', w, [255 255 0], rect);
        Screen('FrameOval', w, [75 75 75], rect);  
        Screen('Flip', w);

  %       if curtime > 8
  %         imageArray = Screen('GetImage', w);
  %         imwrite(imageArray, sprintf('breathhold_screenshot_%.3f.tif', curtime), 'TIFF');
  %       end

        q = loguntil(GetSecs + 0.001, fid, expstarttime, pahandle);
        if q, break; end
      end
    
    case NAT
      Screen('FillRect', w, 0);
      Screen('Flip', w);

      fprintf(fid, '%.3f\tStarting movie\nIntended duration = %.3f\n', GetSecs - expstarttime, expduration);
      droppedFrames = Screen('PlayMovie', moviePtr, 1, 0, min(sound_vol, 1));
      fprintf(fid, '%.3f\tReturned from PlayMovie call, droppedFrames = %d\n', GetSecs - expstarttime, droppedFrames);
      
      q = false;
      while ~q
        [tex, timeidx] = Screen('GetMovieImage', w, moviePtr); %#ok<NASGU>
        if tex <= 0 % movie is over
          fprintf(fid, '%.3f\tMovie is over\n', GetSecs - expstarttime); % this time is over half a second after presentation of the last frame, it must take some time to wrap up
          break;
        end

        Screen('DrawTexture', w, tex);
        fliptime = Screen('Flip', w); %#ok<NASGU>
        
        %returned_timeidx = Screen('GetMovieTimeIndex', moviePtr);
        % fprintf(fid, 'timeidx = %.3f; fliptime - expstarttime = %.3f; offset = %.3f; returned_timeidx = %.3f; calculated_offset = %.3f\n', timeidx, fliptime - expstarttime, (fliptime - expstarttime) - timeidx, returned_timeidx, (fliptime - expstarttime) - returned_timeidx);
        % the movie seems to retain a fairly constant lag of about 150 ms
        
        Screen('Close', tex);

        [keyIsDown, ~, keyCode] = KbCheck;
        if keyCode(quitCode)
          q = true;
        end
      end
      
      Screen('PlayMovie', moviePtr, 0);
      fprintf(fid, '%.3f\tStopping movie\n', GetSecs - expstarttime);      
      Screen('CloseMovie', moviePtr);
      
    case SEMMATCH
      Screen('TextFont', w, 'Monospaced');
      Screen('TextSize', w , 60);
      Screen('TextStyle', w, 0);            
      Screen('FillRect', w, bgcolor);
      Screen('Flip', w);
      
      for trial = 1:ntrials
        fprintf(fid, 'timing\t%.3f\tstart of trial %d\n', GetSecs - expstarttime, trial);
        switch paradigm
          case {1, 5, 9}
            [~, key] = waitforkey('wertyuisdfgq');
            switch key
              case 'w'
                training_difficulty = 1;
                keyIsDown = true;
                while keyIsDown
                  keyIsDown = KbCheck;
                end                
                continue
              case 'e'
                training_difficulty = 2;
                keyIsDown = true;
                while keyIsDown
                  keyIsDown = KbCheck;
                end                
                continue
              case 'r'
                training_difficulty = 3;
                keyIsDown = true;
                while keyIsDown
                  keyIsDown = KbCheck;
                end                
                continue
              case 't'
                training_difficulty = 4;
                keyIsDown = true;
                while keyIsDown
                  keyIsDown = KbCheck;
                end                
                continue
              case 'y'
                training_difficulty = 5;
                keyIsDown = true;
                while keyIsDown
                  keyIsDown = KbCheck;
                end                
                continue
              case 'u'
                training_difficulty = 6;
                keyIsDown = true;
                while keyIsDown
                  keyIsDown = KbCheck;
                end                
                continue
              case 'i'
                training_difficulty = 7;
                keyIsDown = true;
                while keyIsDown
                  keyIsDown = KbCheck;
                end                
                continue
              case 's' % words match
                this_cond = 1;
                this_match = 1;
              case 'd' % words mismatch
                this_cond = 1;
                this_match = 0;
              case 'f' % symbols/tones match
                this_cond = 2;
                this_match = 1;
              case 'g' % symbols/tones mismatch
                this_cond = 2;
                this_match = 0;
              case 'q'
                q = true;
                break;
            end
            this_difficulty = training_difficulty;
            intended_prestime = -1;
            this_rt_window = 600;
            
          case {2, 6, 10}
            if isempty(upcoming_cond) % finished
              expduration = GetSecs - expstarttime;
              break;
            end
            
            this_cond = upcoming_cond(trial);
            this_match = upcoming_match(trial);
            
            % words
            words_new_difficulty = history.new_difficulty(history.paradigm == paradigm & history.cond == 1);
            if isempty(words_new_difficulty)
              words_difficulty = training_difficulty;
            else
              words_difficulty = words_new_difficulty(end);
            end
            % tones
            tones_new_difficulty = history.new_difficulty(history.paradigm == paradigm & history.cond == 2);
            if isempty(tones_new_difficulty)
              tones_difficulty = training_difficulty;
            else
              tones_difficulty = tones_new_difficulty(end);
            end
            
            if this_cond == 1
              this_difficulty = words_difficulty;
            else
              this_difficulty = tones_difficulty;
            end
            
            this_rt_window = block_length / (min_stims_per_block + ...
              ((words_difficulty + tones_difficulty) / 2 - 1) / ...
              (n_difficulty_levels - 1) * (max_stims_per_block - min_stims_per_block));            
          
            intended_prestime = GetSecs - expstarttime + iti;

          case {3, 4, 7, 8, 11, 12}
            % words
            words_new_difficulty = history.new_difficulty((history.paradigm == paradigm | history.paradigm == ceil(paradigm / 4) * 4 - 2 - 1) & history.cond == 1);
            if isempty(words_new_difficulty)
              words_difficulty = training_difficulty;
            else
              words_difficulty = words_new_difficulty(end);
            end
            % tones
            tones_new_difficulty = history.new_difficulty((history.paradigm == paradigm | history.paradigm == ceil(paradigm / 4) * 4 - 2) & history.cond == 2);
            if isempty(tones_new_difficulty)
              tones_difficulty = training_difficulty;
            else
              tones_difficulty = tones_new_difficulty(end);
            end
            
            if isempty(upcoming_cond) % start of block pair
              if next_block_pair_onset == block_length * nblocks % end of block design
                break;
              end
              
              possible_rt_windows = block_length ./ (min_stims_per_block:max_stims_per_block)
              ideal_rt_window = block_length / (min_stims_per_block + ...
                ((words_difficulty + tones_difficulty) / 2 - 1) / ...
                (n_difficulty_levels - 1) * (max_stims_per_block - min_stims_per_block))           
              block_pair_rt_window = min([block_length / min_stims_per_block, possible_rt_windows(possible_rt_windows >= ideal_rt_window)])
              trials_per_block = round(block_length / block_pair_rt_window)
              
              upcoming_cond = [ones(1, trials_per_block), 2 * ones(1, trials_per_block)];
              r = rand;
              if mod(trials_per_block, 2) == 1 % odd
                if r < 0.5
                  nmatches = (trials_per_block - 1) / 2;
                else
                  nmatches = (trials_per_block + 1) / 2;
                end
              else
                if r < 0.1
                  nmatches = trials_per_block / 2 + 1;
                elseif r < 0.2
                  nmatches = trials_per_block / 2 - 1;
                else
                  nmatches = trials_per_block / 2;
                end
              end
              for b = 1:2
                next_matches = [ones(1, nmatches), zeros(1, trials_per_block - nmatches)];
                next_matches = next_matches(randperm(trials_per_block));
                while ~all(diff(diff(next_matches)))
                  next_matches = next_matches(randperm(trials_per_block));
                  % occasionally allow weird long strings
                  if rand < 0.02
                    break;
                  end
                end
                upcoming_match = [upcoming_match next_matches]; %#ok<AGROW>
              end
              upcoming_onset = next_block_pair_onset + (0:block_pair_rt_window:((2 * trials_per_block - 1) * block_pair_rt_window));
              next_block_pair_onset = next_block_pair_onset + 2 * block_length;
            end
            
            this_cond = upcoming_cond(1);
            upcoming_cond = upcoming_cond(2:end);
            this_match = upcoming_match(1);
            upcoming_match = upcoming_match(2:end);
            intended_prestime = upcoming_onset(1);
            upcoming_onset = upcoming_onset(2:end);
            this_rt_window = block_pair_rt_window;
            
            if this_cond == 1
              this_difficulty = words_difficulty;
            else
              this_difficulty = tones_difficulty;
            end
        end

        switch this_cond
          case 1 % words
            if paradigm <= 8 % semantic task (written or auditory)
              % find an item of the right difficulty range that has not been presented previously
              diff_range = diff_ranges{this_difficulty};
              if ~this_match
                diff_range = -diff_range;
              end
              already_presented = history.item(history.cond == 1);
              valid_items = diff_range(~ismember(diff_range, already_presented));
              if isempty(valid_items)
                % consider only items presented today
                already_presented = history.item(history.cond == 1 & floor(history.datetime) == floor(run_id));
                valid_items = diff_range(~ismember(diff_range, already_presented));
                if isempty(valid_items)
                  % give up, present anything in range
                  valid_items = diff_range;
                end
              end
              this_item = valid_items(randi(length(valid_items)));

              if paradigm <= 4 % visual paradigms
                if this_match
                  word1 = matches.word1{this_item};
                  word2 = matches.word2{this_item};
                else
                  word1 = mismatches.word1{-this_item};
                  word2 = mismatches.word2{-this_item};
                end

                word1 = upper(word1);
                word2 = upper(word2);

                num_letters = [num_letters; length(word1) + length(word2)]; %#ok<AGROW>

              else % auditory paradigms
                if this_match
                  word1 = semmatch_wavs.(matches.word1{this_item});
                  word2 = semmatch_wavs.(matches.word2{this_item});
                else
                  word1 = semmatch_wavs.(mismatches.word1{-this_item});
                  word2 = semmatch_wavs.(mismatches.word2{-this_item});
                end
                gap_in_pair = 0.5 - this_difficulty * 0.07;
                stimulus = [word1, zeros(2, round(gap_in_pair * fs)), word2];
              end        
              
            else % syllables task
              r = rand;
              switch this_difficulty
                case 1
                  if this_match
                    if r < 0.2
                      letters_and_syllables = [3 1 3 1];
                    elseif r < 0.7
                      letters_and_syllables = [4 1 4 1];
                    else
                      letters_and_syllables = [3 1 4 1];
                    end
                  else
                    if r < 0.7
                      letters_and_syllables = [4 1 4 2];
                    else
                      letters_and_syllables = [3 1 4 2];
                    end
                  end
                case 2
                  if this_match
                    if r < 0.2
                      letters_and_syllables = [3 1 3 1];
                    elseif r < 0.45
                      letters_and_syllables = [4 1 4 1];
                    elseif r < 0.7
                      letters_and_syllables = [4 2 4 2];
                    elseif r < 0.85
                      letters_and_syllables = [3 1 4 1];
                    else
                      letters_and_syllables = [3 2 4 2];
                    end
                  else
                    if r < 0.2
                      letters_and_syllables = [3 1 3 2];
                    elseif r < 0.7
                      letters_and_syllables = [4 1 4 2];
                    elseif r < 0.9
                      letters_and_syllables = [3 1 4 2];
                    else
                      letters_and_syllables = [4 1 3 2];
                    end
                  end
                case 3
                  if this_match
                    if r < 0.2
                      letters_and_syllables = [4 1 4 1];
                    elseif r < 0.35
                      letters_and_syllables = [5 1 5 1];
                    elseif r < 0.5
                      letters_and_syllables = [4 2 4 2];
                    elseif r < 0.7
                      letters_and_syllables = [5 2 5 2];
                    elseif r < 0.85
                      letters_and_syllables = [4 1 5 1];
                    else
                      letters_and_syllables = [4 2 5 2];
                    end
                  else
                    if r < 0.35
                      letters_and_syllables = [4 1 4 2];
                    elseif r < 0.7
                      letters_and_syllables = [5 1 5 2];
                    elseif r < 0.9
                      letters_and_syllables = [4 1 5 2];
                    else
                      letters_and_syllables = [5 1 4 2];
                    end
                  end
                case 4
                  if this_match
                    if r < 0.2
                      letters_and_syllables = [5 1 5 1];
                    elseif r < 0.35
                      letters_and_syllables = [6 1 6 1];
                    elseif r < 0.5
                      letters_and_syllables = [5 2 5 2];
                    elseif r < 0.7
                      letters_and_syllables = [6 2 6 2];
                    elseif r < 0.85
                      letters_and_syllables = [5 1 6 1];
                    else
                      letters_and_syllables = [5 2 6 2];
                    end
                  else
                    if r < 0.35
                      letters_and_syllables = [5 1 5 2];
                    elseif r < 0.7
                      letters_and_syllables = [6 1 6 2];
                    elseif r < 0.9
                      letters_and_syllables = [5 1 6 2];
                    else
                      letters_and_syllables = [6 1 5 2];
                    end
                  end
                case 5
                  if this_match
                    if r < 0.2
                      letters_and_syllables = [6 2 6 2];
                    elseif r < 0.35
                      letters_and_syllables = [7 2 7 2];
                    elseif r < 0.5
                      letters_and_syllables = [6 3 6 3];
                    elseif r < 0.7
                      letters_and_syllables = [7 3 7 3];
                    elseif r < 0.85
                      letters_and_syllables = [6 2 7 2];
                    else
                      letters_and_syllables = [6 3 7 3];
                    end
                  else
                    if r < 0.35
                      letters_and_syllables = [6 2 6 3];
                    elseif r < 0.7
                      letters_and_syllables = [7 2 7 3];
                    elseif r < 0.9
                      letters_and_syllables = [6 2 7 3];
                    else
                      letters_and_syllables = [7 2 6 3];
                    end
                  end
                case 6
                  if this_match
                    if r < 0.2
                      letters_and_syllables = [7 2 7 2];
                    elseif r < 0.35
                      letters_and_syllables = [8 2 8 2];
                    elseif r < 0.5
                      letters_and_syllables = [7 3 7 3];
                    elseif r < 0.7
                      letters_and_syllables = [8 3 8 3];
                    elseif r < 0.85
                      letters_and_syllables = [7 2 8 2];
                    else
                      letters_and_syllables = [7 3 8 3];
                    end
                  else
                    if r < 0.35
                      letters_and_syllables = [7 2 7 3];
                    elseif r < 0.7
                      letters_and_syllables = [8 2 8 3];
                    elseif r < 0.9
                      letters_and_syllables = [7 2 8 3];
                    else
                      letters_and_syllables = [8 2 7 3];
                    end
                  end
                case 7
                  if this_match
                    if r < 0.2
                      letters_and_syllables = [8 3 8 3];
                    elseif r < 0.35
                      letters_and_syllables = [9 3 9 3];
                    elseif r < 0.5
                      letters_and_syllables = [8 4 8 4];
                    elseif r < 0.7
                      letters_and_syllables = [9 4 9 4];
                    elseif r < 0.85
                      letters_and_syllables = [8 3 9 3];
                    else
                      letters_and_syllables = [8 4 9 4];
                    end
                  else
                    if r < 0.35
                      letters_and_syllables = [8 3 8 4];
                    elseif r < 0.7
                      letters_and_syllables = [9 3 9 4];
                    elseif r < 0.9
                      letters_and_syllables = [8 3 9 4];
                    else
                      letters_and_syllables = [9 3 8 4];
                    end
                  end
              end

              widx1 = 0;
              widx2 = 0;
              while widx1 == widx2
                widx1 = find(syl_pseudowords.syllables == letters_and_syllables(2) & syl_pseudowords.letters == letters_and_syllables(1));
                widx1 = widx1(randi(length(widx1)));
                widx2 = find(syl_pseudowords.syllables == letters_and_syllables(4) & syl_pseudowords.letters == letters_and_syllables(3));
                widx2 = widx2(randi(length(widx2)));
              end
              
              if rand < 0.5
                tempwidx = widx1;
                widx1 = widx2;
                widx2 = tempwidx;
              end
              
              word1 = upper(syl_pseudowords.word{widx1});
              word2 = upper(syl_pseudowords.word{widx2});
              
              num_letters = [num_letters; length(word1) + length(word2)]; %#ok<AGROW>
              
              this_item = widx1 + widx2 / 10000;
            end
            
          case 2 % symbols or tones
            if paradigm <= 4 || paradigm >= 9 % symbols
              this_item = [];
              % how many letters to use?
              if paradigm == 1 || paradigm == 9
                letters = 10;
              elseif isempty(num_letters)
                letters = 10;
              else
                last_num_letters = length(num_letters);  
                if paradigm == 2 || paradigm == 10
                  first_num_letters = last_num_letters - 5;
                else
                  first_num_letters = last_num_letters - trials_per_block + 1;
                end
                if first_num_letters < 1
                  first_num_letters = 1;
                end
                letters = round(mean(num_letters(first_num_letters:last_num_letters)) - 1 + rand * 2);
              end
              if this_match
                if mod(letters, 2) == 1
                  letters = letters + round(rand) * 2 - 1;
                end
                letters = letters / 2;
                this_item{1} = symbols(randi(24, letters, 1));
                this_item{2} = this_item{1};
                
              else
                % adjust the difficulty for the syls task to make the symbols harder
%                 if paradigm <= 8
%                   this_difficulty_adjusted = this_difficulty;
%                 else
                  switch this_difficulty
                    case 1
                      this_difficulty_adjusted = 3;
                    case 2
                      this_difficulty_adjusted = 4;
                    case 3
                      this_difficulty_adjusted = 5;
                    case 4
                      this_difficulty_adjusted = 5.1;
                    case 5
                      this_difficulty_adjusted = 5.2;
                    case 6
                      this_difficulty_adjusted = 6;
                    case 7
                      this_difficulty_adjusted = 7;
                  end
%                 end
                switch this_difficulty_adjusted
                  case 1
                    if mod(letters, 2) == 0
                      letters = letters + round(rand) * 2 - 1;
                    end
                    if rand < 0.5
                      letters1 = letters / 2 + 1.5;
                      letters2 = letters / 2 - 1.5;
                    else
                      letters1 = letters / 2 - 1.5;
                      letters2 = letters / 2 + 1.5;
                    end
                    this_item{1} = symbols(randi(24, letters1, 1));
                    this_item{2} = symbols(randi(24, letters2, 1));
                  case 2
                    if mod(letters, 2) == 1
                      letters = letters + round(rand) * 2 - 1;
                    end
                    if rand < 0.5
                      letters1 = letters / 2 + 1;
                      letters2 = letters / 2 - 1;
                    else
                      letters1 = letters / 2 - 1;
                      letters2 = letters / 2 + 1;
                    end
                    this_item{1} = symbols(randi(24, letters1, 1));
                    this_item{2} = symbols(randi(24, letters2, 1));
                  case 3
                    if mod(letters, 2) == 0
                      letters = letters + round(rand) * 2 - 1;
                    end
                    if rand < 0.5
                      letters1 = letters / 2 + 0.5;
                      letters2 = letters / 2 - 0.5;
                    else
                      letters1 = letters / 2 - 0.5;
                      letters2 = letters / 2 + 0.5;
                    end
                    this_item{1} = symbols(randi(24, letters1, 1));
                    this_item{2} = symbols(randi(24, letters2, 1));
                  case 4
                    if mod(letters, 2) == 1
                      letters = letters + round(rand) * 2 - 1;
                    end
                    letters = letters / 2;
                    this_item{1} = symbols(randi(24, letters, 1));
                    this_item{2} = symbols(randi(24, letters, 1));
                  case {5, 5.1, 5.2, 6, 7}
                    if mod(letters, 2) == 1
                      letters = letters + round(rand) * 2 - 1;
                    end
                    letters = letters / 2;
                    this_item{1} = symbols(randi(24, letters, 1));
                    this_item{2} = this_item{1};
                    switch this_difficulty_adjusted
                      case 5 % swap first letter, last letter, and one from middle
                        swap = [1, randi(letters - 2) + 1, letters];
                      case 5.1
                        if rand < 0.5
                          swap = [1, randi(letters - 2) + 1];
                        else
                          swap = [randi(letters - 2) + 1, letters];
                        end
                      case 5.2
                        if rand < 0.5
                          swap = 1;
                        else
                          swap = letters;
                        end
                      case 6 % swap two letters at random
                        swap = randperm(letters);
                        swap = swap(1:2);
                      case 7 % swap one letter at random
                        swap = randi(letters);
                    end
                    for i = 1:length(swap)
                      while this_item{1}(swap(i)) == this_item{2}(swap(i))
                        this_item{2}(swap(i)) = symbols(randi(24));
                      end
                    end
                end
              end
              word1 = this_item{1};
              word2 = this_item{2};
              this_item = 0;
              
            else % tones
              switch this_difficulty
                case 1
                  ntones = 1;
                  nflip = 1;
                  da_length = 1;
                case 2
                  ntones = 2;
                  nflip = 1;
                  da_length = 2;
                case 3
                  ntones = 3;
                  nflip = 2;
                  da_length = 3;
                case 4
                  ntones = 4;
                  nflip = 3;
                  da_length = 4;
                case 5
                  ntones = 4;
                  nflip = 1;
                  da_length = 4;
                case 6
                  ntones = 5;
                  nflip = 2;
                  da_length = 5;
                case 7
                  ntones = 5;
                  nflip = 1;
                  da_length = 5;
              end
              this_item = repmat(floor(rand(1, ntones) * 3), 2, 1);
              if ~this_match
                flip = randperm(size(this_item, 2));
                flip = flip(1:nflip);

                for i = 1:nflip
                  switch this_item(2, flip(i))
                    case 0
                      this_item(2, flip(i)) = 1;
                    case 1
                      this_item(2, flip(i)) = round(rand) * 2; % 0 or 2
                    case 2
                      this_item(2, flip(i)) = 0;
                  end
                end
              end
                            
%               tones_seg = tones_dur / (size(this_item, 2) * 10 - 1);
%               lo_tone = make_da(tones_seg * 9, (2 ^ (1/12)) ^ -1, da_d, da_a);
%               mid_tone = make_da(tones_seg * 9, (2 ^ (1/12)) ^ 1, da_d, da_a);
%               hi_tone = make_da(tones_seg * 9, (2 ^ (1/12)) ^ 3, da_d, da_a);
%               little_gap = zeros(1, round(tones_seg * fs));
              gap_in_pair = 0.8 - this_difficulty * 0.07;
              big_gap = zeros(1, round(gap_in_pair * fs));
              stimulus = [];
              for i = 1:2
                for j = 1:size(this_item, 2)
                  if this_item(i, j) == 0
                    stimulus = [stimulus da{1, da_length}(1, :)]; %#ok<AGROW>
                  elseif this_item(i, j) == 1
                    stimulus = [stimulus da{2, da_length}(1, :)]; %#ok<AGROW>
                  else
                    stimulus = [stimulus da{3, da_length}(1, :)]; %#ok<AGROW>
                  end
                end
                if i == 1
                  stimulus = [stimulus big_gap]; %#ok<AGROW>
                end
              end
              stimulus = repmat(stimulus, [2 1]);
              this_item = 0;
            end
        end

        % present the trial
        if paradigm <= 4 || paradigm >= 9 % visual paradigms
          Screen('FillRect', w, bgcolor);
          bounds1 = Screen('TextBounds', w, word1);
          Screen('DrawText', w, word1, x - bounds1(3) / 2, 5/6 * y - bounds1(4) / 2, textcolor);
          bounds2 = Screen('TextBounds', w, word2);
          Screen('DrawText', w, word2, x - bounds2(3) / 2, 7/6 * y - bounds2(4) / 2, textcolor);          
          Screen('CopyWindow', w, w2); % "backup" to continue drawing over later, because Screen('Flip', w, 0, true) throws an error for no apparent reason
          while GetSecs < expstarttime + intended_prestime, end
          t = Screen('Flip', w);
          actual_prestime = GetSecs - expstarttime;
          this_datetime = now;
          Screen('CopyWindow', w2, w); % restore from backup        

        else % auditory paradigms
          PsychPortAudio('FillBuffer', pahandle, scalesound(stimulus, sound_vol));
          while GetSecs < expstarttime + intended_prestime, end
          PsychPortAudio('Stop', pahandle, 2);
          t = PsychPortAudio('Start', pahandle, 1, 0, 1);
          actual_prestime = GetSecs - expstarttime;
          this_datetime = now;
        end
        
        if intended_prestime == -1
          intended_prestime = actual_prestime;
        end
        
        % don't accept responses too early because they probably belong to the previous trial
        q = loguntil(expstarttime + actual_prestime + ignore_window, fid, expstarttime, pahandle);
        if q, break; end
        
        % now wait for a response
        if paradigm == 1 || paradigm == 5 || paradigm == 9
          keys_allowed = '01234zqwertyuisdfg';
        else
          keys_allowed = '01234q';
        end
        [key_time, key] = waitforkey(keys_allowed, intended_prestime - actual_prestime + this_rt_window - ignore_window - iti);
        if isempty(key)
          key = '-';
        end
        
        this_response = [];
        switch key
          case {'0', '1', '2', '3', '4'} % button press
            this_response = true;
            this_rt = key_time - expstarttime - actual_prestime;
            
            % feedback that button was pressed
            if paradigm <= 4 || paradigm >= 9
              Screen('DrawLine', w, textcolor, x * 2/5, y * 1/2, x * 8/5, y * 1/2, 4);
              Screen('DrawLine', w, textcolor, x * 2/5, y * 3/2, x * 8/5, y * 3/2, 4);
              Screen('DrawLine', w, textcolor, x * 2/5, y * 1/2, x * 2/5, y * 3/2, 4);
              Screen('DrawLine', w, textcolor, x * 8/5, y * 1/2, x * 8/5, y * 3/2, 4);
              Screen('Flip', w);
            else
              PsychPortAudio('Stop', pahandle, 2);
              PsychPortAudio('FillBuffer', pahandle, scalesound(ding, sound_vol));
              PsychPortAudio('Start', pahandle, 1, 0, 1);
            end
          case {'z', '-', 'w', 'e', 'r', 't', 'y', 'u', 'i', 's', 'd', 'f', 'g'} % no response
            this_response = false;
            this_rt = 0;
          case 'q' % quit
            q = true;
            break;
        end

        % 2-up-1-down staircase
        this_correct = this_response == this_match;
        if this_correct
          prev_correct = history.correct(history.run_id == run_id & history.cond == this_cond);
          prev_difficulty = history.difficulty(history.run_id == run_id & history.cond == this_cond);
          if ~isempty(prev_correct) && prev_correct(end) == 1 && prev_difficulty(end) == this_difficulty
            this_new_difficulty = min(this_difficulty + step_harder, n_difficulty_levels);
          else
            this_new_difficulty = this_difficulty;
          end
        else
          this_new_difficulty = max(this_difficulty - step_easier, 1);
        end

        % update history structure and log file
        nhistory = nhistory + 1;
        history.datetime(nhistory) = this_datetime;
        history.intended_time(nhistory) = intended_prestime;
        history.actual_time(nhistory) = actual_prestime;
        history.run_id(nhistory) = run_id;
        history.paradigm(nhistory) = paradigm;
        history.cond(nhistory) = this_cond;
        history.match(nhistory) = this_match;
        history.difficulty(nhistory) = this_difficulty;
        history.rt_window(nhistory) = this_rt_window;
        history.item(nhistory) = this_item;
        history.response(nhistory) = this_response;
        history.rt(nhistory) = this_rt;
        history.correct(nhistory) = this_correct;
        history.new_difficulty(nhistory) = this_new_difficulty;
        
        fprintf(smfid, '%.8f\t%.3f\t%.3f\t%.8f\t%d\t%d\t%d\t%.3f\t%.3f\t%.4f\t%d\t%.3f\t%d\t%.3f\n', ...
          history.datetime(nhistory), ...
          history.intended_time(nhistory), ...
          history.actual_time(nhistory), ...
          history.run_id(nhistory), ...
          history.paradigm(nhistory), ...
          history.cond(nhistory), ...
          history.match(nhistory), ...
          history.difficulty(nhistory), ...
          history.rt_window(nhistory), ...
          history.item(nhistory), ...
          history.response(nhistory), ...
          history.rt(nhistory), ...
          history.correct(nhistory), ...
          history.new_difficulty(nhistory));
        
        % wait before moving on if necessary
        if paradigm == 1 || paradigm == 5 || paradigm == 9 % practice
          if this_response
            q = loguntil(GetSecs + 1, fid, expstarttime, pahandle);
            if q, break; end
          end
        else
          q = loguntil(expstarttime + intended_prestime + this_rt_window - iti, fid, expstarttime, pahandle);
          if q, break; end
        end
        
        Screen('FillRect', w, bgcolor);
        Screen('Flip', w);
      end
      fclose(smfid);
      
    otherwise
      % loop through events
      trial = 1;
      ff_trial = 1;
      for i = 1:size(events, 1)
        trialtype = events(i, 1);
        onset = events(i, 2);

        % wait till it's time for next trial
        q = loguntil(expstarttime + onset, fid, expstarttime, pahandle);
        if q, break; end
        
        if onset == -1 % practice
          % wait half a second
          startdelay = GetSecs;
          q = loguntil(startdelay + 0.5, fid, expstarttime, pahandle);  
          % wait for key
          [~, key] = waitforkey('6q');
          if key == 'q'
            q = true;
            break;
          end
        end

        switch study
          case FMAP
            switch paradigm
              case {1, 7} % object naming
                Screen('FillRect', w, bgcolor);
                switch trialtype
                  case 1
                    if paradigm == 1 % english
                      txt = vrntext{34};
                    else % spanish
                      txt = vrnspanishtext{34};
                    end
                    delay = 2;
                  case 2
                    if paradigm == 1 % english
                      txt = vrntext{33};
                    else % spanish
                      txt = vrnspanishtext{33};
                    end
                    delay = 1.5;
                  case 3
                    [ysize, xsize, nchannels] = size(onpic{trial}); %#ok<NASGU>
                    picrect = [x - xsize, y - ysize, x + xsize, y + ysize];
                    Screen('PutImage', w, onpic{trial}, picrect);
                    trial = trial + 1;
                    delay = 2.5;
                end
                if trialtype <= 2
                  bounds = Screen('TextBounds', w, txt);
                  Screen('DrawText', w, txt, x - bounds(3) / 2, y - bounds(4) / 2, textcolor);
                end
                t = Screen('Flip', w);
                fprintf(fid, '%.3f\tPresented event %d\n', t - expstarttime, i);
                startdelay = GetSecs;
                q = loguntil(startdelay + delay, fid, expstarttime, pahandle);
                if q, break; end
                Screen('FillRect', w, bgcolor);
                drawcrosshair(w, textcolor);
                Screen('Flip', w);          

              case {2, 8} % auditory responsive naming
                switch trialtype
                  case 1
                    wavi = 34;
                  case 2
                    wavi = 33;
                  case 3
                    wavi = trial;
                    trial = trial + 1;
                end
                if paradigm == 2 % english
                  PsychPortAudio('FillBuffer', pahandle, scalesound(arnwav{wavi}, sound_vol));
                else % spanish
                  PsychPortAudio('FillBuffer', pahandle, scalesound(arnspanishwav{wavi}, sound_vol));
                end
                t = PsychPortAudio('Start', pahandle, 1, 0, 1);
                fprintf(fid, '%.3f\tPresented event %d\n', t - expstarttime, i);

              case {3, 9} % visual responsive naming
                Screen('FillRect', w, bgcolor);
                switch trialtype
                  case 1
                    texti = 34;
                    delay = 2;
                  case 2
                    texti = 33;
                    delay = 1.5;
                  case 3
                    texti = trial;
                    trial = trial + 1;
                    delay = 2.5;
                end
                if paradigm == 3 % english
                  txt = vrntext{texti};
                else % spanish
                  txt = vrnspanishtext{texti};
                end
                bounds = Screen('TextBounds', w, txt);
                Screen('DrawText', w, txt, x - bounds(3) / 2, y - bounds(4) / 2, textcolor);
                t = Screen('Flip', w);
                fprintf(fid, '%.3f\tPresented event %d\n', t - expstarttime, i);
                startdelay = GetSecs;
                q = loguntil(startdelay + delay, fid, expstarttime, pahandle);
                if q, break; end
                Screen('FillRect', w, bgcolor);
                drawcrosshair(w, textcolor);
                Screen('Flip', w);

              case {4, 5, 6, 10, 11, 12} % motor mapping
                Screen('FillRect', w, bgcolor);
                switch trialtype
                  case 1
                    mpicnum = 1;
                  case 2
                    mpicnum = paradigm - 2;
                    if paradigm >= 10 % spanish
                      mpicnum = mpicnum - 6;
                    end
                end
                if trialtype <= 2
                  if paradigm <= 6 % english                  
                    txt = mmaptext{mpicnum};
                  else % spanish
                    txt = mmapspanishtext{mpicnum};
                  end
                  bounds = Screen('TextBounds', w, txt);
                  [ysize, xsize, nchannels] = size(mpic{mpicnum}); %#ok<NASGU>
                  % picrect = [x - xsize, y - ysize, x + xsize, y + ysize];
                  hh = 150;
                  picrect = round([x - xsize / ysize * hh, y - hh - bounds(4) / 2 - 15, ...
                    x + xsize / ysize * hh, y + hh - bounds(4) / 2 - 15]);
                  Screen('PutImage', w, mpic{mpicnum}, picrect);
                  Screen('DrawText', w, txt, x - bounds(3) / 2, y + hh - bounds(4) / 2 + 15, textcolor);
                  t = Screen('Flip', w);
                  fprintf(fid, '%.3f\tPresented event %d\n', t - expstarttime, i);
                  delay = 2.5;
                  startdelay = GetSecs;
                  q = loguntil(startdelay + delay, fid, expstarttime, pahandle);
                  if q, break; end
                  Screen('FillRect', w, bgcolor);
                  drawcrosshair(w, textcolor);
                  Screen('Flip', w);     
                end
                trial = trial + 1;
            end

          case BASICBOLD
            Screen('FillRect', w, bgcolor);
            PsychPortAudio('FillBuffer', pahandle, scalesound(basicbold_sound, sound_vol));
            t = PsychPortAudio('Start', pahandle, 1, 0, 1); %#ok<NASGU>
            [ysize, xsize, nchannels] = size(cboard1); %#ok<NASGU>
            picrect = [x - xsize, y - ysize, x + xsize, y + ysize];
            for flicker = 1:20
              if mod(flicker, 2)
                Screen('PutImage', w, cboard1, picrect);
              else
                Screen('PutImage', w, cboard2, picrect);
              end
              t = Screen('Flip', w);
              if flicker == 1
                fprintf(fid, '%.3f\tPresented event %d\n', t - expstarttime, i);
              end
              q = loguntil(expstarttime + onset + flicker * 0.1, fid, expstarttime, pahandle);
              if q, break; end
            end
            Screen('FillRect', w, bgcolor);
            drawcrosshair(w, textcolor);
            Screen('Flip', w);

          case PICNAME
            item = round(rem(trialtype, 1) * 10000);
            Screen('FillRect', w, bgcolor);
            [ysize, xsize, nchannels] = size(picnamepic{item}); %#ok<NASGU>
            scaling = 3;
            picrect = round([x - xsize / 2 * scaling, y - ysize / 2 * scaling, x + xsize / 2 * scaling, y + ysize / 2 * scaling]);
            if (paradigm == 1 || paradigm == 9 || paradigm == 10) && floor(trialtype) == 2
              Screen('PutImage', w, scramblepic{item}, picrect);
            else
              Screen('PutImage', w, picnamepic{item}, picrect);
            end
            t = Screen('Flip', w);
            fprintf(fid, '%.3f\tPresented event %d\n', t - expstarttime, i);
            
            % av version only
            if paradigm == 6 || paradigm == 7 || paradigm == 8
              PsychPortAudio('FillBuffer', pahandle, scalesound(picnamewav{item}, sound_vol));
              t = PsychPortAudio('Start', pahandle, 1, 0, 1); %#ok<NASGU>
            end

            delay = 3;
            startdelay = GetSecs;
            q = loguntil(startdelay + delay, fid, expstarttime, pahandle);
            if q, break; end
            Screen('FillRect', w, bgcolor);
            drawcrosshair(w, textcolor);
            Screen('Flip', w);

          case READING
            Screen('FillRect', w, bgcolor);
            thistextcolor = textcolor;
            wascatch = '';
            if trialtype == 1
              if paradigm == 1
                txt = six_letter_words{wordorder(trial)};
                if any(trial == catchtrials)
                  thistextcolor = [255 0 0];
                  wascatch = '(catch)';
                end
              else
                txt = varying_length_words{trial};
              end
              tr = trial;
              trial = trial + 1;
              bounds = Screen('TextBounds', w, txt);
              Screen('DrawText', w, txt, x - bounds(3) / 2, y - bounds(4) / 2, thistextcolor);
            elseif trialtype == 2
              if paradigm == 1
                txt = six_letter_words{wordorder(ff_trial)};
                if any(ff_trial == ff_catchtrials)
                  thistextcolor = [255 0 0];
                  wascatch = '(catch)';
                end
              else
                txt = varying_length_words{ff_trial};
              end
              txt = false_font(txt - 'A' + 1);
              txt = double(txt); % required for unicode
              tr = -ff_trial;
              ff_trial = ff_trial + 1;
              bounds = Screen('TextBounds', w, txt);
              Screen('DrawText', w, txt, x - bounds(3) / 2, y - bounds(4) / 2, thistextcolor);            
            elseif trialtype == 3
              drawcrosshair(w, textcolor, 5);
            elseif trialtype == 4
              drawcrosshair(w, textcolor);
            end
            t = Screen('Flip', w);
            if trialtype == 1 || trialtype == 2
              fprintf(fid, '%.3f\tPresented trial %d %s\n', t - expstarttime, tr, wascatch);
            end

          case NARR
            if paradigm ~= 10 % auditory
              switch paradigm
                case 1 % jack sparse (practice)
                  story = 1;
                  seg = round(mod(trialtype, 1) * 100);
                case 2 % pp
                  story = 2;
                  seg = round(mod(trialtype, 1) * 100);
                case 3
                  story = 3;
                  seg = round(mod(trialtype, 1) * 100);
                case {4, 5, 6, 7, 8, 9}
                  story = 4;
                  seg = round(mod(trialtype, 1) * 1000);
                case {11, 12, 13, 14, 15, 16}
                  story = 4;
                  seg = round(mod(trialtype, 1) * 1000);
                case 17
                  story = 4;
                  seg = round(mod(trialtype, 1) * 1000);                  
                case {18, 19}
                  story = 5;
                  seg = round(mod(trialtype, 1) * 1000);
                case {20, 21}
                  story = 6;
                  seg = round(mod(trialtype, 1) * 1000);
              end
              if trialtype == 99
                PsychPortAudio('FillBuffer', pahandle, scalesound(spiralsound, sound_vol));
                dur = size(spiralsound, 2) / fs;
              else 
                PsychPortAudio('FillBuffer', pahandle, scalesound(narrwav{story, seg, floor(trialtype)}, sound_vol));

                dur = size(narrwav{story, seg, floor(trialtype)}, 2) / fs;
              end
              t = PsychPortAudio('Start', pahandle, 1, 0, 1);
              audtime = GetSecs; % t does not work with way the port was opened
              fprintf(fid, '%.3f\t%.3f\tPresented event %d\n', t - expstarttime, audtime - expstarttime, i);
              fprintf(fid, '\tIntended duration = %.3f\n', dur);

            else % written
              if i > 1 && (floor(events(i,1)) == floor(events(i-1,1)))
                WordNumber = WordNumber+1;
              else
                WordNumber = 0; % new block....!
              end
              BlockNumber = round(10*(mod(events(i,1),1))); % 1 to 6 only for words and nonsense strings...
              switch floor(events(i,1))
                case 1
                  Spaces = findstr(wordlists{BlockNumber}(:)',' '); %#ok<FSTR>
                  txt = wordlists{BlockNumber}(1:Spaces(WordNumber+1)); % Retrieve accumulating string...
                case 2
                  Spaces = findstr(scramblewordlists{BlockNumber}(:)',' '); %#ok<FSTR>
                  txt = scramblewordlists{BlockNumber}(1:Spaces(WordNumber+1)); % Retrieve accumulating string...
                case 3
                  txt = '+';
              end
              if floor(events(i,1)) ~= 3 % if we're NOT showing "nothing"
                % bounds = Screen('TextBounds', w, txt); % Determine the text bounds of our item.
                Screen('FillRect', w, bgcolor); % Paint background color.
                DrawFormattedText(w, txt, 20, 150, [1 1 1], 35,0,0,1.2); % 25 = # chars to wrap at...
                t = Screen('Flip', w); % Display background and text we just drew.
                fprintf(fid, '%.3f\tPresented event %d\n', t - expstarttime, i); % Log onset time.
                startdelay = GetSecs; % Get actual stimulus onset time.
                delay = .1; %
                q = loguntil(startdelay + delay, fid, expstarttime, pahandle); % Delay.
                if q, break; end % Wait for a quit signal.....
                Screen('FillRect', w, bgcolor); % Paint new background
              else
                drawcrosshair(w, textcolor); % Draw the crosshairs
                Screen('Flip', w); % Show the crosshairs/background we just drew.
                delay = 20; % This will be the fixation....
                q = loguntil(startdelay + delay, fid, expstarttime, pahandle); % Delay.
                if q, break; end % Wait for a quit signal.....
              end
            end

          case ARTIC
            trialtype_int = floor(trialtype);
            trialtype_dec = round((trialtype - trialtype_int) * 100);
            if trialtype_int == 1
              txt = artic_words{trialtype_dec};
            else
              txt = artic_words{15 + trialtype_dec};
            end
            Screen('FillRect', w, bgcolor);
            bounds = Screen('TextBounds', w, txt);
            Screen('DrawText', w, txt, x - bounds(3) / 2, y - bounds(4) * 1.2 - bounds(4) / 2, textcolor);
            Screen('DrawText', w, txt, x - bounds(3) / 2, y + 0               - bounds(4) / 2, textcolor);
            Screen('DrawText', w, txt, x - bounds(3) / 2, y + bounds(4) * 1.2 - bounds(4) / 2, textcolor);
            t = Screen('Flip', w);          
            fprintf(fid, '%.3f\tPresented event %.2f\n', t - expstarttime, trialtype);

            q = loguntil(expstarttime + onset + 4, fid, expstarttime, pahandle);
            if q, break; end

            Screen('FillRect', w, bgcolor);
            drawcrosshair(w, textcolor);
            Screen('Flip', w);

          case CVCREAD
            txt = cvcread_stims{i}; % Retrieve our current stimulus item.
            txt = upper(txt); % Make uppercase
            bounds = Screen('TextBounds', w, txt); % Determine the text bounds of our item.
            Screen('FillRect', w, bgcolor); % Paint background color.
            Screen('DrawText', w, txt, x - bounds(3) / 2, y - bounds(4) / 2, textcolor); % Write text
            t = Screen('Flip', w); % Display background and text we just drew.
            fprintf(fid, '%.3f\tPresented event %d\n', t - expstarttime, i); % Log onset time.
            startdelay = GetSecs; % Get actual stimulus onset time.
            delay = 3;
            q = loguntil(startdelay + delay, fid, expstarttime, pahandle); % Delay.
            if q, break; end % Wait for a quit signal.....
            Screen('FillRect', w, bgcolor); % Paint new background
            drawcrosshair(w, textcolor); % Draw the crosshairs
            Screen('Flip', w); % Show the crosshairs/background we just drew.

          case REST
            % do nothing

          case DELEXDEGRAM
            if trialtype
              wav = dldgwav{ceil(paradigm / 8), floor(trialtype), round(mod(trialtype, 1) * 10) + 1};

              PsychPortAudio('FillBuffer', pahandle, scalesound(wav, sound_vol));
              dur = size(wav, 2) / fs;

              t = PsychPortAudio('Start', pahandle, 1, 0, 1);
              audtime = GetSecs; % t does not work with way the port was opened
              fprintf(fid, '%.3f\t%.3f\tPresented event %d\n', t - expstarttime, audtime - expstarttime, i);
              fprintf(fid, '\tIntended duration = %.3f\n', dur);
            end  

          case NARRSW
            narrsw_text_size = 54;
            narrsw_line_height = 90;
            narrsw_margin = 200;
            if i == 1
              Screen('TextSize', w , narrsw_text_size);
            end

            item = round(rem(trialtype, 1) * 1000);

            switch floor(trialtype)
              case {1, 2}
                PsychPortAudio('FillBuffer', pahandle, scalesound(narrsw_wav{run, item, floor(trialtype)}, sound_vol));
                dur = size(narrsw_wav{run, item, floor(trialtype)}) / fs;
                t = PsychPortAudio('Start', pahandle, 1, 0, 1);
                audtime = GetSecs;
                fprintf(fid, '%.3f\t%.3f\tPresented event %d\n', t - expstarttime, audtime - expstarttime, i);
                fprintf(fid, '\tIntended duration = %.3f\n', dur);              
              case {6, 7}
                if ~isempty(words{i})
                  for find_start = i:-1:1
                    if events(find_start, 1) == trialtype
                      start_at = find_start;
                    else
                      break;
                    end
                  end
                  for find_end = i:size(events, 1)
                    if events(find_end, 1) == trialtype && ~isempty(words{find_end})
                      end_at = find_end;
                    else
                      break;
                    end
                  end
                  % first draw the whole trial's text to figure out the size
                  pen_x = narrsw_margin;
                  pen_y = narrsw_margin;
                  for j = start_at:end_at
                    bounds = Screen('TextBounds', w, words{j});
                    if pen_x + bounds(3) > wrect(3) - narrsw_margin
                      pen_x = narrsw_margin;
                      pen_y = pen_y + narrsw_line_height;
                    end
                    [pen_x, pen_y] = Screen('DrawText', w, [words{j} ' '], pen_x, pen_y, textcolor);
                  end
                  % now draw for real
                  Screen('FillRect', w, bgcolor);
                  pen_x = narrsw_margin;
                  pen_y = y - (pen_y - narrsw_margin + narrsw_line_height) / 2;
                  for j = start_at:i
                    bounds = Screen('TextBounds', w, words{j});
                    if pen_x + bounds(3) > wrect(3) - narrsw_margin
                      pen_x = narrsw_margin;
                      pen_y = pen_y + narrsw_line_height;
                    end
                    this_textcolor = min(i - j, 4) * 32;
                    [pen_x, pen_y] = Screen('DrawText', w, [words{j} ' '], pen_x, pen_y, this_textcolor);
                  end
                  Screen('Flip', w);
                else
                  Screen('FillRect', w, bgcolor);
                  drawcrosshair(w, textcolor);
                  Screen('Flip', w);
                end
            end

          case CLOZE
  %           cloze_text_size = 40;
            cloze_text_size = 70;
            if i == 1
              Screen('TextSize', w , cloze_text_size);
            end
            cond = floor(trialtype);
            item = round(mod(trialtype, 1) * 10000);
            switch cond
              case 1 % auditory
                PsychPortAudio('FillBuffer', pahandle, scalesound(clozewav{item}, sound_vol));  
                t = PsychPortAudio('Start', pahandle, 1, 0, 1);
                fprintf(fid, '%.3f\tPresented event %d\n', t - expstarttime, i);
                startdelay = GetSecs;
                q = loguntil(startdelay + 3, fid, expstarttime, pahandle);
                if q, break; end
              case 2 % written
                txt = clozetxt{item, 1};
                spaces = find(txt == ' ');
                [~, mi] = min(abs(spaces - ceil(length(txt) / 2)));
                txt1 = txt(1:spaces(mi) - 1);
                txt2 = txt(spaces(mi) + 1:end);
                bounds = Screen('TextBounds', w, txt1);
                Screen('DrawText', w, txt1, x - bounds(3) / 2, y - bounds(4) / 2 - cloze_text_size, textcolor);
                bounds = Screen('TextBounds', w, txt2);
                Screen('DrawText', w, txt2, x - bounds(3) / 2, y - bounds(4) / 2 + cloze_text_size, textcolor);
  %               bounds = Screen('TextBounds', w, txt);
  %               Screen('DrawText', w, txt, x - bounds(3) / 2, y - bounds(4) / 2, textcolor);
                t = Screen('Flip', w);
                fprintf(fid, '%.3f\tPresented event %d\n', t - expstarttime, i);
                startdelay = GetSecs;
                q = loguntil(startdelay + 4.5, fid, expstarttime, pahandle);
                if q, break; end
                Screen('FillRect', w, bgcolor);
                drawcrosshair(w, textcolor);
                Screen('Flip', w);
            end
        end
      end
  end

  % wait for end of experiment
  if ~q
    q = loguntil(expstarttime + expduration, fid, expstarttime, pahandle);
  end    
  
  if q % quit key was pressed
    fprintf(fid, '%.3f\tParadigm aborted\n', GetSecs - expstarttime);
    % wait for key up to return to main menu
    keyIsDown = true;
    while keyIsDown
      keyIsDown = KbCheck;
    end
    fprintf(fid, '%.3f\tQuit key released\n', GetSecs - expstarttime);
    PsychPortAudio('Stop', pahandle, 2);
    fprintf(fid, '%.3f\tAudio stopped\n', GetSecs - expstarttime);

  else % experiment is complete
    fprintf(fid, '%.3f Completed paradigm\n', GetSecs - expstarttime);
    fprintf(fid, '%s Completed paradigm\n', datestr(now, 31));

    % inform subject task is complete
    Screen('FillRect', w, bgcolor);
    txt = 'Thanks, you''ve finished this task.';
    bounds = Screen('TextBounds', w, txt);
    Screen('DrawText', w, txt, x - bounds(3) / 2, y - bounds(4) / 2, textcolor);
    Screen('Flip', w);
    startdelay = GetSecs;
    delay = 2;
    q = loguntil(startdelay + delay, fid, expstarttime, pahandle);
  end
end
