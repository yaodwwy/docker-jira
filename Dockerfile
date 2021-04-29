FROM openjdk:8-alpine

ENV TZ            Asia/Shanghai
ENV JIRA_HOME     /var/jira
ENV JIRA_INSTALL  /opt/jira
ENV WEB_INF       /opt/jira/atlassian-jira/WEB-INF
ENV JAR           /atlassian-jira-software-8.14.1.tar.gz

COPY atlassian-jira-software-8.14.1.tar.gz ${JAR}
RUN set -x  \
    && echo "https://mirrors.aliyun.com/alpine/v3.8/main" > /etc/apk/repositories \
    && echo "https://mirrors.aliyun.com/alpine/v3.8/community" >> /etc/apk/repositories \
	&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apk add --no-cache curl xmlstarlet bash ttf-dejavu libc6-compat \
    && mkdir -p          "${JIRA_HOME}" \
    && mkdir -p          "${JIRA_HOME}/caches/indexes" \
    && mkdir -p          "${JIRA_INSTALL}/conf/Catalina" \
    && tar -zxf           ${JAR} --directory ${JIRA_INSTALL} --strip-components=1 --no-same-owner \
    && rm   -rf           ${JAR} \
    && chmod -R 700      "${JIRA_HOME}" \
    && chmod -R 700      "${JIRA_INSTALL}/conf" \
    && chmod -R 700      "${JIRA_INSTALL}/logs" \
    && chmod -R 700      "${JIRA_INSTALL}/temp" \
    && chmod -R 700      "${JIRA_INSTALL}/work" \
    && sed --in-place    "s/java version/openjdk version/g" "${JIRA_INSTALL}/bin/check-java.sh" \
    && echo -e           "\njira.home=$JIRA_HOME" >> "${WEB_INF}/classes/jira-application.properties" \
    && touch -d "@0"     "${JIRA_INSTALL}/conf/server.xml" \
    && echo hello8.14.1.3

COPY dbconfig.xml ${JIRA_HOME}/dbconfig.xml

# 破解软件及安装Git插件
COPY atlassian-extras-3.2.jar ${WEB_INF}/lib/atlassian-extras-3.2.jar
COPY atlassian-universal-plugin-manager-plugin-4.0.8.jar ${WEB_INF}/atlassian-bundled-plugins/atlassian-universal-plugin-manager-plugin-4.0.8.jar
COPY jira_git_plugin-3.6.1.2.jar ${WEB_INF}/application-installation/jira-software-application/jira_git_plugin-3.6.1.2.jar

COPY docker-entrypoint.sh /

EXPOSE 8080

VOLUME ["/var/jira", "/opt/jira/logs"]

WORKDIR /var/jira

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/opt/jira/bin/start-jira.sh", "-fg"]
