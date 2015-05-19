function demo(varargin)
% demo() is a wrapper to recover topics from some standard public datasets.
% Input the corpus name and the function will use TSVD to recover 50 topics.
% Steps involved are downloading data, processing data then running TSVD.
% 
% Inputs -
% corpus: string, specify corpus for demo, available choices (case-sensitive) -
%         "20NG", "nips", "enron", "kos", "nytimes" (big), "pubmed" (caution: very big)
%         (default is nips)
% dir: string, working directory (default is current directory)
% 
% Example: demo()
% Example: demo('20NG')

if ~isempty(varargin)
    corpus = varargin{1};
    if length(varargin) == 2, dir = varargin{2};
    else dir = '.';
    end
else
    corpus = 'nips';
    dir = '.';
end

dir = strcat(dir,'/demo_',corpus,'/');
if ~exist(dir,'dir'), mkdir(dir); end

%% Download Data 
if strcmp(corpus,'20NG')
    datafile = 'train.data';
    zipdata = '20news-bydate-matlab.tgz';
    vocabfile = 'vocabulary.txt';
    url = 'http://qwone.com/~jason/20Newsgroups/';
else
    datafile = strcat('docword.',corpus,'.txt');
    zipdata = strcat('docword.',corpus,'.txt.gz');
    vocabfile = strcat('vocab.',corpus,'.txt');
    url = 'http://archive.ics.uci.edu/ml/machine-learning-databases/bag-of-words/';
end

if ~exist(strcat(dir,'/',datafile),'file')
    fprintf('Downloading %s data from %s\n',corpus,url);
    urlwrite(strcat(url,zipdata), strcat(dir,'/',zipdata),'get',{});
    fprintf('Unzipping data\n');
    if strcmp(corpus,'20NG')
        untar(strcat(dir,'/',zipdata),dir);
        movefile(strcat(dir,'/20news-bydate/matlab/train.data'),strcat(dir,'/train.data'));
    %     rmdir(strcat(dir,'/20news-bydate/'),'s');
    else gunzip(strcat(dir,'/',zipdata),dir);
    end
end

if ~exist(strcat(dir,'/',vocabfile),'file')
    fprintf('Download %s vocabulary\n',corpus);
    urlwrite(strcat(url,vocabfile), strcat(dir,'/',vocabfile),'get',{});
end

%% Remove stop words and truncate vocabulary
fprintf('Preprocessing Data\n');
vocab = 5000;
vocabfile = strcat(dir,'/',vocabfile);
infile = strcat(dir,'/',datafile);
stopfile = 'stopwords.txt';
outfile = strcat(dir,'/',corpus);

pycmnd = sprintf('python process_data.py %s %s %s %d %s %d', ...
    infile, vocabfile, stopfile, vocab, outfile, ~strcmp(corpus,'20NG'));
[status, exp] = system(pycmnd);
if status ~= 0
    error('Python command to process data failed:\n %s', exp);
end

%% Run algorithm
K = 50;
fprintf('\n******Running TSVD******\n');
[M_hat,~] = TSVD(strcat(outfile,'.proc.txt'),dir,K);

% Print topics
num_words = 10; 
print_topics(M_hat, strcat(dir,'/',corpus,'.vocab.trunc.txt'), num_words);

end