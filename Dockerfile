FROM openjdk:8-alpine
MAINTAINER adam<yaodwwy@gmail.com>

ENV JIRA_HOME     /var/atlassian/jira
ENV JIRA_INSTALL  /opt/atlassian/jira
ENV WEB_INF       /opt/atlassian/jira/atlassian-jira/WEB-INF

RUN set -x \
    && echo "https://mirrors.aliyun.com/alpine/v3.8/main" > /etc/apk/repositories \
    && echo "https://mirrors.aliyun.com/alpine/v3.8/community" >> /etc/apk/repositories \
	&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apk add --no-cache curl xmlstarlet bash ttf-dejavu libc6-compat \
    && mkdir -p          "${JIRA_HOME}" \
    && mkdir -p          "${JIRA_HOME}/caches/indexes" \
    && chmod -R 700      "${JIRA_HOME}" \
    && mkdir -p          "${JIRA_INSTALL}/conf/Catalina" \
    && curl -Ls          "https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-8.5.1.tar.gz" | tar -xz --directory "${JIRA_INSTALL}" --strip-components=1 --no-same-owner \
    && rm   -rf          "${JIRA_INSTALL}/atlassian-jira-software-8.5.1.tar.gz" \
    && chmod -R 700      "${JIRA_INSTALL}/conf" \
    && chmod -R 700      "${JIRA_INSTALL}/logs" \
    && chmod -R 700      "${JIRA_INSTALL}/temp" \
    && chmod -R 700      "${JIRA_INSTALL}/work" \
    && sed --in-place    "s/java version/openjdk version/g" "${JIRA_INSTALL}/bin/check-java.sh" \
    && echo -e           "\njira.home=$JIRA_HOME" >> "${WEB_INF}/classes/jira-application.properties" \
    && touch -d "@0"     "${JIRA_INSTALL}/conf/server.xml"

EXPOSE 8080

VOLUME ["/var/atlassian/jira", "/opt/atlassian/jira", "/opt/atlassian/jira/logs"]

WORKDIR /var/atlassian/jira

# 破解软件及插件
COPY jira_k_file/atlassian-extras-3.2.jar ${WEB_INF}/lib/atlassian-extras-3.2.jar
COPY jira_k_file/atlassian-universal-plugin-manager-plugin-4.0.8.jar ${WEB_INF}/atlassian-bundled-plugins/atlassian-universal-plugin-manager-plugin-4.0.8.jar
COPY plugin/jira_git_plugin-3.4.1.4.jar ${WEB_INF}/application-installation/jira-software-application/jira_git_plugin-3.4.1.4.jar

COPY "docker-entrypoint.sh" "/"

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/opt/atlassian/jira/bin/start-jira.sh", "-fg"]
