# 安装事前依赖
yum install -y gcc
yum install -y pcre-devel
yum install -y zlib zlib-devel
yum install -y openssl openssl-devel
echo "依赖安装成功"
# 创建并进入nginx文件夹
installDir=/ty/lnmp
mkdir -p $installDir/nginx
cd $installDir/nginx
echo "文件夹新建成功"

# 下载源文件并编译安装到/ty/lnmp/nginx
wget http://nginx.org/download/nginx-1.9.9.tar.gz
tar -zxvf nginx-1.9.9.tar.gz
cd nginx-1.9.9
./configure --prefix=$installDir/nginx --with-http_ssl_module
make && make install
echo "安装完成"
# 删除安装文件
cd ../
rm -f nginx-1.9.9.tar.gz
rm -rf nginx-1.9.9
echo "源码包删除完成"

# 启动nginx
.$installDir/nginx/sbin/nginx
echo "启动完成"