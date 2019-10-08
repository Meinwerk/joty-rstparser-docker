FROM java:7

ENV WNHOME=/usr/share/wordnet
ENV WNSEARCHDIR=/usr/share/wordnet

RUN apt-get update
RUN apt-get install sudo

# Installs python
RUN apt-get install -y python2.7 python-dev python-pip python-virtualenv

# Installs python packages
RUN apt-get install -y libblas-dev liblapack-dev libatlas-base-dev gfortran \
        && pip install numpy==1.16.4 scipy==0.13 scikit-learn==0.17.1 nltk==3.2.5

#RUN apt-get install -y wget \
RUN apt-get install -y wget vim wordnet-base
RUN python -c 'import nltk; nltk.download("wordnet")'

RUN wget http://alt.qcri.org/tools/discourse-parser/releases/current/Discourse_Parser_Dist.tar.gz \
    && tar -xf Discourse_Parser_Dist.tar.gz \
    && rm -rf Discourse_Parser_Dist.tar.gz

# Installs WordNet Query Script
RUN cd Discourse_Parser_Dist/Tools \
        && tar -xf WordNet-QueryData-1.49.tar.gz

RUN cd Discourse_Parser_Dist/Tools/WordNet-QueryData-1.49/ \
        && perl Makefile.PL && make && make test && make install \
    && cd .. && rm -rf WordNet-QueryData-1.49 WordNet-QueryData-1.49.tar.gz

# Re-train sklearn segmenter model
ADD retrain.patch .
RUN patch Discourse_Parser_Dist/Discourse_Segmenter.py < retrain.patch
ADD test.txt Discourse_Parser_Dist/
RUN cd Discourse_Parser_Dist \
        && python Discourse_Segmenter.py --train test.txt

## Add and test convenience script
ADD parse.sh Discourse_Parser_Dist/

# Clean up
RUN rm -rf /var/lib/apt/lists/*

#CMD ["su", "-", "user", "-c", "/bin/bash"]
CMD ["/bin/bash"]
