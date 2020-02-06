FROM ubuntu:bionic
RUN apt update -y 
RUN apt install -y libc6 zlib1g libstdc++6 openjdk-8-jdk wget curl git gnupg2
RUN wget http://mirror.nbtelecom.com.br/apache//ant/binaries/apache-ant-1.10.7-bin.tar.gz
RUN tar -xzf apache-ant-1.10.7-bin.tar.gz
ENV ANT_HOME=/apache-ant-1.10.7
RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk-bionic main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN apt install  -y
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN apt update -y &&  apt install -y  google-cloud-sdk google-cloud-sdk-app-engine-java
RUN git clone --depth=1 https://github.com/mit-cml/appinventor-sources.git
WORKDIR /appinventor-sources
RUN git submodule update --init
WORKDIR /appinventor-sources/appinventor
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/"
ENV PATH="${ANT_HOME}/bin/:${JAVA_HOME}:${PATH}"
RUN ant MakeAuthKey
RUN ant
WORKDIR /appinventor-sources/appinventor/buildserver
CMD ["/usr/lib/google-cloud-sdk/bin/java_dev_appserver.sh", "--port=8888", "--address=0.0.0.0", "../appengine/build/war/", "&", "ant", "RunLocalBuildServer" ]
