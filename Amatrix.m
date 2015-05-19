function A = Amatrix(inpath)
% Read input data in sparse metrix format from text file and convert to
% sparse matrix.
% Each line of input is (DocId and WordId start from 1): 
% DocId WordId Count
%
% Returns sparse matrix A (words*docs)


if ~exist(inpath,'file')
    error('In Amatrix: input file %s does not exist', inpath);
end

fid = fopen(inpath);
% textscan(fid,'%f\n',3);
data = textscan(fid,'%f %f %f\n',Inf);
fclose(fid);
A = sparse(data{2}, data{1}, data{3});

end