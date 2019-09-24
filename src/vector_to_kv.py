import argparse
from gensim.models import keyedvectors

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Loads a word2vec format file and saves it back as KeyedVectors model.')
    parser.add_argument('-i', '--input_file', help='word2vec input filename', required=True, action='store')
    parser.add_argument('-o', '--output_file', help='keyedvector output filename', required=True, action='store')
    parser.add_argument('--binary', help='input word2vec file is in binary format', action='store_true')

    parsed = parser.parse_args()
    model = keyedvectors.Word2VecKeyedVectors.load_word2vec_format(parsed.input_file, binary=parsed.binary)
    model.save(parsed.output_file)
