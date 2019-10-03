Dockerfile for the Joty 2013 RST Parser
=======================================

About the Dockerfile
--------------------

This Dockerfile provides a full environment for running the Joty 2013 RST Parser on bare text. It includes all dependencies, a simple patch to re-train the discourse segmenter via commandline and for convenience, a bash script to robustly parse a larger collection of texts without having issues of old temporary files.

Note: Do not run the same parser instance in parallel, as the parser relies on hardcoded temporary files.

### Usage

```
docker build -t parser .
docker run -it --rm --volume $(pwd)/samples:/samples --workdir /Discourse_Parser_Dist --user $(id -u):$(id -g) parser
./parse.sh /samples/example.txt
cat /samples/example.txt.rst
```


About the RST Parser
--------------------

See http://alt.qcri.org/tools/discourse-parser/

### Developer

* Shafiq Joty
  sjoty@qf.org.qa

### References

* Shafiq Joty, Giuseppe Carenini, Raymond Ng and Yashar Mehdad. Combining Intra- and Multi-sentential Rhetorical Parsing for Document-level Discourse Analysis.In Proceedings of the 51st Annual Meeting of the Association for Computational Linguistics (ACL 2013), Sofia, Bulgaria
* Shafiq Joty, Giuseppe Carenini and Raymond Ng. A Novel Discriminative Framework for Sentence-Level Discourse Analysis. In Proceedings of the Conference on Empirical Methods in Natural Language Processing and the Conference on Natural Language Learning (EMNLP-CoNLL 2012), Jeju, Korea.
