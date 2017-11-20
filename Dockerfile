FROM alpine

ADD Shanghai /etc/localtime

#ADD repositories /etc/apk/repositories
#RUN apk add --no-cache alpine-sdk
RUN apk add --no-cache pcre pcre-dev openssl openssl-dev ruby zlib-dev libxslt-dev libxml2-dev

RUN apk add --no-cache nodejs=6.10.3-r1 nodejs-npm=6.10.3-r1

RUN npm -v

RUN apk add --no-cache curl git unzip xz g++ gcc make irssi tar zsh wget

#RUN npm install -g tty.js 

#ADD ttyjs-config.json /

# Install oh-my-zsh
RUN git clone --depth=1 git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
        && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

ADD zshrc /root/.zshrc

ENV SHELL /bin/zsh

COPY . /root/web

WORKDIR /root/web

RUN npm install

RUN npm install ali-oss co

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

RUN ./configure --add-module=/nginx-rtmp-module --add-module=/ngx_cache_purge-master --add-module=/nginx_mod_h264_streaming-2.2.7 --with-http_xslt_module --with-http_stub_status_module --with-http_ssl_module --with-http_sub_module --with-http_gzip_static_module --with-http_flv_module

#修改nginx安装目录下的objs下的Makefile 删除-Werror
RUN sed -i "s/-Werror/ /g" objs/Makefile

RUN make

RUN make install

COPY nginx.conf /nginx-1.9.0/conf/nginx.conf

COPY nclients.xsl /usr/local/nginx/html/

RUN chmod 777 /usr/local/nginx/html

RUN mkdir /usr/local/nginx/html/record

RUN chmod 777 /usr/local/nginx/html/record

EXPOSE 80

EXPOSE 1935

#EXPOSE 3001

WORKDIR /root/web

RUN chmod +x start.sh

CMD ./start.sh
