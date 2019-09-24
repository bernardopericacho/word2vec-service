####################################
############### DATA ###############
####################################

FROM alpine:3.10.2 as data

COPY src/vector_to_kv.py builder-requirements.txt ./

RUN set -x \
    && apk add --update --no-cache --virtual .build-dependencies aria2 python3 openblas libstdc++ gcc gfortran python3-dev build-base freetype-dev libpng-dev openblas-dev \
    && python3 -m ensurepip --upgrade \
    && python3 -m pip install -r builder-requirements.txt \
    && aria2c -x10 -s10 --check-integrity=true --checksum=md5=1c892c4707a8a1a508b01a01735c0339 "https://s3.amazonaws.com/dl4j-distribution/GoogleNews-vectors-negative300.bin.gz" -o googlenews-vec.bin.gz \
    && python3 vector_to_kv.py -i googlenews-vec.bin.gz -o googlenews-vec.kv_model --binary \
    && rm googlenews-vec.bin.gz \
    && apk del .build-dependencies \
    && rm -rf /var/cache/apk/*

####################################
############# WORD2VEC #############
####################################

FROM alpine:3.10.2 as word2vec
LABEL maintainer="vincenzo.ampolo@gmail.com"

EXPOSE 8000
CMD ["python3", "/app/main.py"]

COPY --from=data googlenews-vec.kv_model* ./data/

COPY requirements.txt /

RUN set -x \
    && apk add --no-cache python3 openblas libstdc++ \
    && python3 -m ensurepip --upgrade \
    && apk add --no-cache --virtual .build-dependencies gcc gfortran python3-dev build-base freetype-dev libpng-dev openblas-dev \
    && python3 -m pip install -r requirements.txt \
    && apk del .build-dependencies

ENV VECTOR_FILE=/data/googlenews-vec.kv_model

COPY src /app
