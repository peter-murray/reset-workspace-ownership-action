ARG busybox_version=1.32.0

FROM busybox:${busybox_version}

COPY *.sh /
ENTRYPOINT ["/entrypoint.sh"]