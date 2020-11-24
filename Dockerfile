ARG busybox_version=1.32.0

FROM busybox:${busybox_version}

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]