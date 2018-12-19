## 一： 在两台linux服务器上分别安装mariadb数据库

1. 查看是否有残留安装`rpm -qa | grep mariadb`

2. 若有残留安装，执行`yum remove mysql mysql-server mysql-libs compat-mysql51`全部删除，若没有，可跳过

3. 执行`vi /etc/yum.repos.d/MariaDB.repo`,并在文件中写入

   ```
   # MariaDB 10.2.4 CentOS repository list - created 2017-05-05 16:13 UTC
   # http://downloads.mariadb.org/mariadb/repositories/
   [mariadb]
   name = MariaDB
   baseurl = http://yum.mariadb.org/10.2.4/centos7-amd64
   gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
   gpgcheck=1
   ```

4. 运行mysql_secure_installation进行配置

5. 安装yum -y install MariaDB-server MariaDB-client

6. 启动服务`systemctl start mariadb`

7. 设置开机启动`systemctl enable mariadb` 

8. 运行`mysql_secure_installation`进行配置

## 二：配置主数据库

1. 编辑主数据库配置`vim /etc/my.cnf.d/server.cnf`添加如下内容

   ```chinese
   server-id=8
   log-bin=master-bin
   log-bin-index=master-bin.index
   ```

2. 重启服务 `systemctl restart mariadb`

3. 登录数据库 `mysql -uroot -p`

4. 授权远程用户

   ```
   grant replication slave on *.* to 'user'@'ip' identified by 'password';
   # user为用户名,password为密码，ip为从服务器的ip(可使用通配符，入192.168.1.*代表192.168.1开头的ip都可以作为从数据库
   ```

5. 刷新权限表使用户生效`flush privileges;`

6. 重启服务 `systemctl restart mariadb`

7. 在主数据库上查看状态`SHOW MASTER STATUS`并记录

## 三：配置从数据库

1. 编辑从数据库配置`vim /etc/my.cnf.d/server.cnf`添加如下内容

   ```
   server-id=9
   relay-log-index=slave-relay-bin.index
   relay-log=slave-relay-bin
   # 这里要注意server-id不能与主数据库相同
   ```

2. 重启服务 `systemctl restart mariadb`

3. 登录数据库 `mysql -uroot -p`

4. 配置主数据库连接

   ```
   change master to master_host='主数据库ip',master_user='刚刚主数据库建的用户',master_password='刚刚主数据库建的用户密码', master_log_file='主数据库最后一步查询结果',master_log_pos=主数据库最后一步查询结果;
   例如:change master to master_host='127.0.0.1',master_user='slaveuser',master_password='slaveuser', master_log_file='master-bin.000005',master_log_pos=882;
   ```

5. 启动slave同步 `START SLAVE;`

6. 查看运行状态`show slave status\G`

## 四：附录

1. 创建用户命令`create user username@localhost identified by 'password';`
2. 直接创建用户并授权的命令`grant all on *.* to username@localhost indentified by 'password';`
3. 授予外网登陆权限`grant all privileges on *.* to username@'%' identified by 'password';`
4. 授予权限并且可以授权`grant all privileges on *.* to username@'hostname' identified by 'password' with grant option;`
5.  停止服务`systemctl stop mariadb.service`