docker build -t yaodwwy/jira .
docker push yaodwwy/jira:latest
docker tag yaodwwy/jira:latest yaodwwy/jira:8.5.1
docker push yaodwwy/jira:8.5.1
