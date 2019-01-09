FROM gitlab/gitlab-ce:latest

ADD scripts /scripts
RUN chmod -R +x /scripts

ENTRYPOINT ["/scripts/entrypoint.sh"]

CMD ["/assets/wrapper"]

HEALTHCHECK --interval=60s --timeout=30s --retries=5 \
CMD /opt/gitlab/bin/gitlab-healthcheck --fail --max-time 10
