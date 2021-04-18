FROM ubuntu:20.04

# disable interactivity
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies (for building the toolchain from source)
RUN apt-get update
RUN apt-get install -y apt-utils python-dev libpython2.7 bison python3 grep git texinfo ccache ninja-build wget check python3-pip python3-cryptography ca-certificates libtool-bin help2man cmake curl python3-pyelftools unzip zip python3-serial make gettext gperf libtool flex python3-pyparsing python3-setuptools libncurses-dev libssl-dev gawk xz-utils python3-future libffi-dev lcov automake libusb-1.0-0-dev python

# Set python 3 as the default, and install venv.
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10
RUN python -m pip install --upgrade pip virtualenv

# set IDF-PATH environment variable.
ENV IDF_PATH=/opt/esp/idf
ENV IDF_TOOLS_PATH=/opt/esp
ENV IDF_VERSION=v3.3.5

RUN git clone -b $IDF_VERSION --depth 1 --recursive https://github.com/espressif/esp-idf.git $IDF_PATH

# Install python packages
RUN python3 -m pip install -r $IDF_PATH/requirements.txt

# Install ESP-IDF
RUN $IDF_PATH/tools/idf_tools.py --non-interactive install required
RUN $IDF_PATH/tools/idf_tools.py --non-interactive install cmake
RUN $IDF_PATH/tools/idf_tools.py --non-interactive install-python-env

RUN mkdir -p $HOME/.ccache
RUN touch $HOME/.ccache/ccache.conf

ADD entrypoint.sh /opt/esp/entrypoint.sh
RUN chmod +x /opt/esp/entrypoint.sh

ENTRYPOINT [ "/opt/esp/entrypoint.sh" ]