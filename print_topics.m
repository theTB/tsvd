function print_topics(M_hat, vocabfile, numtop)
% print_topics(M_hat, vocabfile, numtop)
% Prints the top words of every topic
% 
% Inputs:
%   M_hat is the output topic matrix from TSVD (vocab*K)
%   vocabfile is the vocabulary-word file
%   numtop is the number of top words to print per topic

fid = fopen(vocabfile);
if (fid == -1)
  error('Amatrix: cant open %s.',inpath);
end

v = 1;
while ~feof(fid)
    l = fgetl(fid);
    vocab{v} = strtrim(l);
    v = v+1;
end
fclose(fid);

% fid = fopen(strcat(outpath,'/topics.txt'),'w');
[~, topw] = sort(M_hat, 1, 'descend');
for k=1:size(M_hat,2)
    fprintf('Topic %d: ',k);
    for i=1:numtop
        fprintf([vocab{topw(i,k)}, ' ']);
    end
    fprintf('\n');
end
% fclose(fid);
end