import os
from gensim.models import keyedvectors

# Load pretrained model (since intermediate data is not included, the model cannot be refined with additional data)
vector_filepath = os.getenv("VECTOR_FILE", None)
assert vector_filepath is not None, "Please provide a vector file to load"

model = keyedvectors.Word2VecKeyedVectors.load(vector_filepath, mmap='r')
