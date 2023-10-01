%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code for reproducing the stimuli for the spoken and written narrative 
% paradigms in Casilio et al., "Situating word deafness in aphasia recovery"

% Last updated by Marianne Casilio on 9/27/23
% Questions? Email marianne.e.casilio@vanderbilt.edu

% Note: The finalized stimuli is also provided in the narrv2 folder as part 
% of the larger zip file. The paradigms can be run in Psychophysics toolbox
% using the nl_present_65.m script in the narrv2 folder.

% Another note: The first run of the spoken narrative paradigm and the 
% word-level paradigms are available as part of the Adaptive Language 
% Mapping toolbox (Wilson et al., 2018; Yen et al., 2019), which can be 
% downloaded at https://langneurosci.org/alm.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


vowels = 'aeiou';
consonants = 'bcdfghjklmnpqrstvwxyz';

for r = 1:2
  switch r
    case 1
      story = 'edison';
      paradigm = '1';
    case 2
      story = 'shakespeare';
      paradigm = '3';
  end
  outfid = fopen(sprintf('narr2200_paradigm%s.txt', paradigm), 'w');
  fprintf(outfid, 'event_type	onset	duration	height	word\n');
  for i = 1:10
    fid = fopen(sprintf('%s%d.txt', story, i), 'r');
    c = textscan(fid, '%f%s');
    dur(i) = c{1}(end);
    fclose(fid);
  end
  restBlockLength = (480 - sum(dur) * 2) / 10;
  curTime = 0;
  for i = 1:10
    % language
    fid = fopen(sprintf('%s%d.txt', story, i), 'r');
    c = textscan(fid, '%f%s');
    fclose(fid);
    fprintf(outfid, '%d\t%.3f\t%.3f\t%d\t%s\n', 3, curTime, c{1}(end), 1, '');
    for j = 1:length(c{1})
      fprintf(outfid, '%d\t%.3f\t%.3f\t%d\t%s\n', 6, curTime + c{1}(j), 0, 0, c{2}{j});
    end
    curTime = curTime + c{1}(end) + 1;  
    % scrambled
    fid = fopen(sprintf('%s%d.txt', story, 11 - i), 'r');
    c = textscan(fid, '%f%s');
    fclose(fid);
    fprintf(outfid, '%d\t%.3f\t%.3f\t%d\t%s\n', 4, curTime, c{1}(end), 1, '');
    for j = 1:length(c{1})
      word = c{2}{j};
      for i = 1:length(word)
        reup = false;
        if word(i) >= 'A' && word(i) <= 'Z'
          word(i) = lower(word(i));
          reup = true;
        end
        if any(word(i) == vowels)
          other_vowels = vowels(vowels ~= word(i));
          word(i) = other_vowels(randi(4));
        elseif any(word(i) == consonants)
          other_consonants = consonants(consonants ~= word(i));
          word(i) = other_consonants(randi(20));
        end
        if reup
          word(i) = upper(word(i));
        end
      end
      fprintf(outfid, '%d\t%.3f\t%.3f\t%d\t%s\n', 7, curTime + c{1}(j), 0, 0, word);
    end
    curTime = curTime + c{1}(end);
    % rest
    curTime = curTime + restBlockLength - 1;
  end
end
fclose(outfid);

for r = 1:2
  switch r
    case 1
      story = 'beatles';
      paradigm = '2';
    case 2
      story = 'amelia';
      paradigm = '4';
  end
  outfid = fopen(sprintf('narr2200_paradigm%s.txt', paradigm), 'w');
  fprintf(outfid, 'event_type	onset	duration	height	word\n');
  for i = 1:10
    [y, fs] = audioread(sprintf('%s%d.wav', story, i));
    dur(i) = length(y) / fs;
  end
  restBlockLength = (480 - sum(dur) * 2) / 10;
  curTime = 0;
  for i = 1:10
    % language
    fprintf(outfid, '%.3f\t%.3f\t%.3f\t%d\t%s\n', 1 + i / 1000, curTime, dur(i), 1, '');
    curTime = curTime + dur(i) + 1;  
    % scrambled
    fprintf(outfid, '%.3f\t%.3f\t%.3f\t%d\t%s\n', 2 + (11 - i) / 1000, curTime, dur(11 - i), 1, '');
    curTime = curTime + dur(11 - i);
    % rest
    curTime = curTime + restBlockLength - 1;
  end
end

