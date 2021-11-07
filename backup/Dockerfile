FROM ubuntu
RUN mkdir /app
WORKDIR /app
RUN apt update
RUN apt --yes install curl
RUN curl -L -o azcopy.tar.gz https://aka.ms/downloadazcopy-v10-linux
RUN mkdir ./azcopy
RUN tar -zxvf azcopy.tar.gz -C ./azcopy --strip-components 1 
RUN ln -s /app/azcopy/azcopy /bin/azcopy
COPY entrypoint.sh /app
RUN chmod +x entrypoint.sh