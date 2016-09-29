FROM centos:7

RUN yum install -y wget git gcc pcre-devel openssl openssl-devel libxslt-devel

WORKDIR /

RUN wget https://nodejs.org/dist/v4.6.0/node-v4.6.0-linux-x64.tar.xz

RUN tag -xvf node-v4.6.0-linux-x64.tar.xz

RUN ln -s node-v4.6.0-linux-x64/bin/node /usr/local/bin/node

RUN ln -s node-v4.6.0-linux-x64/bin/npm /usr/local/bin/npm

RUN npm -v

RUN node -v

RUN wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz

RUN xz -d ffmpeg-release-64bit-static.tar.xz

RUN tar xvf ffmpeg-release-64bit-static.tar

RUN git clone git://github.com/arut/nginx-rtmp-module.git

RUN wget http://nginx.org/download/nginx-1.2.4.tar.gz

RUN tar xzf nginx-1.2.4.tar.gz

WORKDIR /nginx-1.2.4

RUN ./configure --add-module=/nginx-rtmp-module --with-http_xslt_module

RUN make

RUN make install

COPY nginx.conf /nginx-1.2.4/conf/nginx.conf

COPY nclients.xsl /usr/local/nginx/html/

RUN chmod 777 /usr/local/nginx/html 

EXPOSE 80

EXPOSE 1935

CMD /usr/local/nginx/sbin/nginx -c /nginx-1.2.4/conf/nginx.conf
