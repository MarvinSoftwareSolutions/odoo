ARG ODOO_VERSION="16.0"

FROM odoo:${ODOO_VERSION} AS production

COPY --chown=odoo:odoo LICENSE LICENSE

COPY --chown=odoo:odoo ./extra-addons /mnt/extra-addons/default-addons
COPY --chown=odoo:root ./config/etc/odoo/odoo.conf /etc/odoo/odoo.conf
COPY --chown=root:root ./config/etc/ssl/openssl.cnf /etc/ssl/openssl.cnf

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      git \
      python3-chardet \
      python3-m2crypto \
      python3-ofxparse \
      python3-pykcs11 \
      python3-xlrd \
    &&\
    apt-get -y autoremove &&\
    apt-get autoclean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER odoo
RUN mkdir -p  /mnt/extra-addons/enterprise-addons \
              /mnt/extra-addons/default-addons \
              /mnt/extra-addons/custom-addons
RUN --mount=type=bind,source=requirements.txt,target=/var/lib/odoo/requirements.txt \
    pip install -r /var/lib/odoo/requirements.txt
