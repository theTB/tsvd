import sys
from collections import defaultdict

if len(sys.argv) < 6:
	print "Usage: python process_data.py <inputData> <inputVocab> <stopwords> <vocabSize> <outname> <?isUCIformat:0/1>"
	sys.exit()

infile = open(sys.argv[1],"r")

with open(sys.argv[2],"r") as vf:
	vocab = map(lambda x: x.strip(),vf.readlines())

with open(sys.argv[3],"r") as sf:
	stops = map(lambda x: x.strip(),sf.readlines())

V = int(sys.argv[4])

if len(sys.argv) > 6: isUCI = int(sys.argv[6])
else: isUCI = 0

if isUCI == 1: [infile.readline() for _ in range(3)]  # discard three header-lines in UCI format

DFLIMIT = False  ## if limit vocab by document frequency, else term frequency
MIN_W_DOC = 20  ## minimum words per document
pruneTop = 10 ## Remove some highest frequency words

dfrequency = defaultdict(int)
tfrequency = defaultdict(int)

proc_line = lambda x: map(int,x.strip().split(" "))

for line in infile:
	d,w,c = proc_line(line)
	if vocab[w-1] in stops: continue
	dfrequency[w] += 1
	tfrequency[w] += c
	
def findVocab(frequency, V, pruneTop):
	''' Returns the list of top words and vocabulary offset to include all words of same frequency'''
	top_words = sorted(frequency,key=dfrequency.get,reverse=True)
	f = frequency[top_words[V-1+pruneTop]]
	if f==0:  ## at stop-words
		for c in range(2,V):
			if frequency[V-c+pruneTop] > 0: break
		return top_words, -c+1
		
	c = 0
	for w in top_words[V+pruneTop:]:
		if frequency[w] < f: break
		c += 1
	return top_words, c

if V > len(tfrequency): V = len(tfrequency) - pruneTop

if DFLIMIT: top_words, c = findVocab(dfrequency, V, pruneTop)
else: top_words, c = findVocab(tfrequency, V, pruneTop)
V = V+c
print "Vocab Size:",V
words = top_words[pruneTop:V+pruneTop]
vmap = {}
for i,w in enumerate(words): vmap[w] = i+1  #note that vocab still starts from 1

infile.seek(0)
if isUCI == 1: [infile.readline() for _ in range(3)]
name = sys.argv[5].strip()
outfile = open(name+".proc.txt","w+") # processed output

currentD = 1
numDocs = 0
docData = defaultdict(int)
num_w_doc = 0
nnz = 0 #this is redundant

outdata = ""

for line in infile:
	d,w,c = proc_line(line)
	if d==currentD:
		if w in words: 
			docData[vmap[w]] += c
			num_w_doc += c
	else:
		if num_w_doc >= MIN_W_DOC:
			numDocs += 1
			nnz += len(docData)
			for w in docData:
				outdata += "%d %d %d\n"%(numDocs, w, docData[w])
			if numDocs%5000==0: 
				outfile.write(outdata)
				outdata = ""
		currentD += 1
		docData = defaultdict(int)
		num_w_doc = 0
		if w in words: 
			docData[vmap[w]] += c
			num_w_doc += c

if num_w_doc >= MIN_W_DOC:
	numDocs += 1
	nnz += len(docData)
	for w in docData: 
		outdata += "%d %d %d\n"%(numDocs, w, docData[w])
outfile.write(outdata)


outfile.close()
print "Docs retained",numDocs

with open(name+".vocab.trunc.txt","w+") as vf:
	for w in words: vf.write(vocab[w-1]+"\n")
	
'''with open("tfrequency."+name+".txt","w+") as tf:
	for w in top_words: tf.write("%s : %d\n"%(vocab[w-1],tfrequency[w]))'''


