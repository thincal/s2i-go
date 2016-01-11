# It's debian based.
FROM golang:1.4.3

# Put the maintainer name in the image metadata
MAINTAINER Liu Song <song-liu@ceyes.cn>

########################################################
# Essential settings derived from openshift/base-centos7

# Location of the STI scripts inside the image
#
LABEL io.openshift.s2i.scripts-url=image:///usr/libexec/s2i

# DEPRECATED: This label will be kept here for backward compatibility
LABEL io.s2i.scripts-url=image:///usr/libexec/s2i

# Deprecated. Use above LABEL instead, because this will be removed in future versions.
ENV STI_SCRIPTS_URL=image:///usr/libexec/s2i

# Path to be used in other layers to place s2i scripts into
ENV STI_SCRIPTS_PATH=/usr/libexec/s2i

# The $HOME is not set by default, but some applications needs this variable
ENV HOME=/go/src/app

RUN mkdir -p ${HOME} && \
    useradd -u 1001 -r -g 0 -d ${HOME} LOGIN && \
    chown -R 1001:0 ${HOME}

WORKDIR ${HOME}

########################################################

EXPOSE 8080

ENV GO_VERSION 1.4.3

# Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for building and running Go 1.4.3 applications" \
      io.k8s.display-name="Go 1.4.3" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,go, go143"

# TODO: Install required packages here:
# RUN yum install -y ... && yum clean all -y

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
