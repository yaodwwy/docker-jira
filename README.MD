
### 基于jira8.5.1版本

> 主程序包下载地址:

    https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-8.5.1.tar.gz

> 主程序破解文件
    
    atlassian-extras-3.2.jar

> 插件破解文件
    
    atlassian-universal-plugin-manager-plugin-4.0.8.jar
    
> Git插件

    jira_git_plugin-3.4.1.4.jar

> jira推荐挂载方式：
    
      # 用户头像(avatars) 附件(attachments) 插件(git-plugin)
    - mountPath: /var/jira/data
      name: jira
      subPath: jira/data
      
      # 系统备份输出目录
    - mountPath: /var/jira/export
      name: jira
      subPath: jira/export
      
      # 系统备份导入目录
    - mountPath: /var/jira/import
      name: jira
      subPath: jira/import

      # Lucene搜索索引不支持NFS挂载，因为已知NFS挂载会导致您的应用程序出现稳定性问题。
        不推荐搜索索引目录/var/jira/caches/indexesV1挂载在nfs。
