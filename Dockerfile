FROM ubuntu:18.04
RUN apt-get update
RUN apt-get -y install wget p7zip-full

# Chrome
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
RUN dpkg -i chrome.deb || apt-get -yf install
RUN echo -e '#!/bin/bash\nset -eu\n/usr/bin/google-chrome --no-sandbox "$@"' >/usr/bin/chrome-no-sandbox
RUN chmod +x /usr/bin/chrome-no-sandbox

# PowerShell Core
RUN wget -q https://github.com/PowerShell/PowerShell/releases/download/v6.1.1/powershell_6.1.1-1.ubuntu.18.04_amd64.deb -O /opt/powershell.deb
RUN dpkg -i /opt/powershell.deb || apt-get -yf install

# NodeJS
WORKDIR /nodejs
RUN wget https://nodejs.org/dist/v11.3.0/node-v11.3.0-linux-x64.tar.xz
RUN 7z x *.xz
RUN tar -xf *.tar
ENV PATH="${PATH}:/nodejs/node-v11.3.0-linux-x64/bin"

# Yarn
RUN apt-get install -y curl gnupg
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install --no-install-recommends -y yarn

RUN npm install -g @angular/cli

ENV CHROME_BIN=/usr/bin/chrome-no-sandbox
WORKDIR /run
COPY angularbench.ps1 .
CMD pwsh -File angularbench.ps1
