FROM cpchou/ubuntu_openjdk8

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g @vue/cli@3

RUN wget -O /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
RUN chmod +x /usr/local/bin/gitlab-runner
RUN useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash

USER gitlab-runner

ENV JAVA_HOME /opt/jdk
ENV PATH $PATH:$JAVA_HOME
ENV PATH /opt/jdk/bin:${PATH}


ENV MAVEN_VERSION 3.5.4
ENV MAVEN_HOME /usr/lib/mvn
ENV PATH $MAVEN_HOME/bin:$PATH

USER root
RUN echo "export JAVA_HOME=/opt/jdk" >> /etc/profile
RUN echo "export MAVEN_HOME=/usr/lib/mvn" >> /etc/profile
RUN echo "export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH" >> /etc/profile




RUN gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
RUN gitlab-runner start
