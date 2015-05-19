# Thresholded SVD based K-means for Topic Modeling

Code for the paper:  
*"[A Provable SVD-based Algorithm for Learning Topics in Dominant Admixture Corpus](http://papers.nips.cc/paper/5302-a-provable-svd-based-algorithm-for-learning-topics-in-dominant-admixture-corpus)". Trapit Bansal, Chiranjib Bhattacharyya, Ravindran Kannan. In Neural Information Processing Systems (NIPS), 2014.*
***

This file provides useful information for using the code. 
First we show how to use the demos for running the algorithm on a variety of standard public datasets.
To run on your own data, check the following data format, pre-processing steps and the main matlab function for running the algorithm.
Provided code has been tested on Matlab R2012a/b on a Linux system.

For bugs/queries/suggestions/thanks feel free to email me at "trapitbansal at gmail dot com"


### Running Demos
Open Matlab with the current directory as the code directory, make sure Matlab is configured for internet access and type:  
`demo()`  
This will run a demo of the algorithm on the NIPS corpus.  

This function can recover topics from a specified public corpus using TSVD. Other available choices for the corpus are the 20-NewsGroup and any corpus on the UCI repository (that is NIPS, ENRON, KOS, NYT, PUBMED).
Specify the corpus name as input variable, the possible values are: "_nips_", "_enron_", "_kos_", "_20NG_" (default is nips).
The function downloads corresponding data, processes it, runs TSVD and prints the topics.
If you have problems downloading the data from matlab, create a folder called "*demo_[corpus]*" where *[corpus]* is the corpus name as above and put the unzipped data file and the vocabulary file in that folder. Then call `demo([corpus])`.
The demo script calls the python code to preprocess the data.  
_Note_: Using "nytimes" or "pubmed" as corpus name is also possible though the datasets are quite big and memory issues may arise, so use these at your own risk (nytimes works with around 4GB memory if you have some small swap space available and close all other running programs, pubmed has not been tested).


### Data Format
For the TSVD function, input data should be in a text file in matlab sparse matrix format, that is each line of input text file is:  
*Doc_id Word_id Count*  
where Doc_id and Word_id start from 1.  
The UCI data is in the same format with 3 addtional header-lines at the start which need to be removed.


### Pre-processing Data
It is recommended to preprocess the data before running the algorithm. 
The provided python code is a helper script to remove words from a standard list of stop-words and truncate vocabulary based on term-frequency.
Truncating vocabulary is good for compuational/memory efficiency, and also gives better quality topics.
To run the script type:  
`python process_data.py <inputData> <inputVocab> <stopwords> <vocab> <outputName>`  

where  
- _inputData_ is in the input data file to be processed in sparse matrix format  
- _inputVocab_ is vocabulary-words file where i-th line contains the i-th indexed word in inputData  
- _stopwords_ is list of stopwords (one per line) - a standard list is provided though you can use your own  
- _vocab_ is the desired vocabulary truncation  
- _outputName_ is the location (including name) of the output processed file (the code will append ".proc.txt" at end to ensure there is no name conflict)  
One can also use UCI format input data for this code, just pass the integer 1 as an additional last argument.


### Running TSVD Algorithm
The matlab function signature is:  
`[M_hat, dominantTopic] = TSVD(infile, outpath, K)`  
where  
- _infile_ is the path to the data file (in above format),
- _outpath_ is the output folder name where topic matrix will be written
- _K_ is the number of topics
- *M_hat* is the topic matrix (vocab*K)
- _dominantTopic_ is the dominant topic assignment for each document
Type `help TSVD` in matlab for more info on additional parametrers


### Printing Topics
The matlab function signature is:  
`print_topics(M_hat, vocabfile, numtop)`  
where  
- *M_hat* is the output topic matrix from TSVD (vocab*K)
- _vocabfile_ is the vocabulary-word file where i-th line contains the i-th indexed word in inputData
- _numtop_ is the number of top words to print per topic

***
