# 安装事前依赖
yum install -y gcc gcc-c++  make zlib zlib-devel pcre pcre-devel  libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel gdbm-devel db4-devel libXpm-devel libX11-devel gd-devel gmp gmp-devel expat-devel libxml2 libxml2-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel libcurl libcurl-devel curl curl-devel libmcrypt libmcrypt-devel libxslt libxslt-devel xmlrpc-c xmlrpc-c-devel libicu-devel libmemcached-devel libzip readline readline-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers sqlite-devel autoconf-2.69-11.el7.noarch automake-1.13.4-3.el7.noarch libtool
echo "依赖安装成功"
# 创建并进入php文件夹
installDir=/ty/lnmp
mkdir -p $installDir/php
cd $installDir/php
echo "文件夹新建成功"

# 下载源文件并编译安装到/ty/lnmp/nginx
wget https://www.php.net/distributions/php-7.4.12.tar.gz
tar -zxvf php-7.4.12.tar.gz
cd php-7.4.12

# reinstall libzip
wget https://libzip.org/download/libzip-1.7.3.tar.gz
tar -zxvf libzip-1.7.3.tar.gz
cd libzip-1.7.3
yum install -y cmake3
ln -s /usr/bin/cmake3 /usr/bin/cmake
mkdir build && cd build && cmake .. && make && make install
cd ../../
rm -f libzip-1.3.2.tar.gz
rm -rf libzip-1.3.2
# error: off_t undefined; check your library configuration
# update ldconfig
echo '/usr/local/lib64
/usr/local/lib
/usr/lib
/usr/lib64'>>/etc/ld.so.conf
ldconfig -v

# 正则
wget https://github.com/kkos/oniguruma/archive/v6.9.4.tar.gz -O oniguruma-6.9.4.tar.gz
tar -zxvf oniguruma-6.9.4.tar.gz
cd oniguruma-6.9.4/
./autogen.sh
./configure
make && make install
cd ../
yum config-manager --set-enabled PowerTools
yum -y install oniguruma oniguruma-devel

./configure --prefix=$installDir/php --with-config-file-path=$installDir/php/etc --enable-inline-optimization --disable-debug --enable-fpm --with-fpm-user=nobody --with-fpm-group=nobody --disable-rpath --enable-soap --with-libxml-dir --with-xmlrpc --with-openssl  --with-mhash --with-pcre-regex --with-zlib --enable-bcmath --with-bz2 --enable-calendar --with-curl --enable-exif --with-pcre-dir --enable-ftp --with-gd --with-openssl-dir --with-jpeg-dir --with-png-dir --with-zlib-dir --with-freetype-dir --enable-gd-jis-conv --with-gettext --with-gmp --with-mhash --enable-mbstring --with-onig --enable-shared --enable-opcache --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-readline --with-iconv --enable-pcntl --enable-shmop --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-sockets  --enable-zip --enable-wddx --with-pear --disable-fileinfo
make && make install
echo "安装完成"
cp php.ini-production $installDir/php/etc/php.ini
cp $installDir/php/etc/php-fpm.conf.default $installDir/php/etc/php-fpm.conf
cp $installDir/php/etc/php-fpm.d/www.conf.default $installDir/php/etc/php-fpm.d/www.conf
cp sapi/fpm/init.d.php-fpm $installDir/php/etc/php-fpm

# ps -ef|grep php
# 删除安装文件
cd ../
rm -f php-7.3.12.tar.gz
rm -rf php-7.3.12
echo "源码包删除完成"
