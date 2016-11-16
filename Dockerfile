FROM ubuntu

RUN apt-get update -y

RUN apt-get install -y unzip wget git build-essential libpcre3 libpcre3-dev openssl libssl-dev ruby zlib1g-dev libxslt-dev libxml2-dev yamdi

WORKDIR /

RUN curl --silent --location https://rpm.nodesource.com/setup_4.x | bash -

RUN wget http://cdn.npm.taobao.org/dist/node/latest-v4.x/node-v4.4.4-linux-x64.tar.gz

RUN tar -xvf node-v4.4.4-linux-x64.tar.gz

RUN mv node-v4.4.4-linux-x64 /opt/

RUN ln -s /opt/node-v4.4.4-linux-x64/bin/node /usr/local/bin/node

RUN ln -s /opt/node-v4.4.4-linux-x64/bin/npm /usr/local/bin/npm

COPY . /root/web

WORKDIR /root/web

RUN npm -v

RUN npm install

RUN npm install -g supervisor

RUN echo -n "ldwcnmlgb.pw" > conf/DBIp

WORKDIR /

RUN wget http://h264.code-shop.com/download/nginx_mod_h264_streaming-2.2.7.tar.gz

RUN tar -xzvf  nginx_mod_h264_streaming-2.2.7.tar.gz

COPY ngx_http_streaming_module.c /nginx_mod_h264_streaming-2.2.7/src/

RUN wget https://github.com/FRiCKLE/ngx_cache_purge/archive/master.zip

RUN unzip master.zip

RUN wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz -O ffmpeg.tar.xz

RUN xz -d ffmpeg.tar.xz

RUN mkdir ffmpeg

RUN tar xvf ffmpeg.tar -C ffmpeg --strip-components 1

RUN git clone git://github.com/arut/nginx-rtmp-module.git

RUN wget http://nginx.org/download/nginx-1.9.0.tar.gz

RUN tar xzf nginx-1.9.0.tar.gz

WORKDIR /nginx-1.9.0

RUN ./configure --add-module=/nginx-rtmp-module --add-module=../ngx_cache_purge-master --add-module=/nginx_mod_h264_streaming-2.2.7 --with-http_xslt_module --with-http_stub_status_module --with-http_ssl_module --with-http_sub_module --with-http_gzip_static_module --with-http_flv_module

#修改nginx安装目录下的objs下的Makefile 删除-Werror
RUN sed -i "s/-Werror/ /g" objs/Makefile

RUN make

RUN make install

COPY nginx.conf /nginx-1.9.0/conf/nginx.conf

COPY nclients.xsl /usr/local/nginx/html/

RUN chmod 777 /usr/local/nginx/html

RUN mkdir /usr/local/nginx/html/record

RUN chmod 777 /usr/local/nginx/html/record

EXPOSE 8099

EXPOSE 1935

WORKDIR /root/web

RUN chmod +x start.sh

CMD ./start.sh