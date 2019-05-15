FROM alpine

RUN apk add bash

#COPY wait-services /usr/local/bin/
ADD https://github.com/xmm/wait-services/raw/master/wait-services /usr/local/bin/
RUN chmod +x /usr/local/bin/wait-services

CMD ["wait-services"]
