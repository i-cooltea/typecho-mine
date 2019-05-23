#!/bin/bash
#备份路径
DIR=/home/wwwroot/myBlogDB
BACKUP=/home/wwwroot/myBlogDB/auto
#当前时间
DATETIME=$(date +%Y-%m-%d_%H%M%S)
echo "===备份开始==="
echo "备份文件存放于${BACKUP}/$DATETIME.tar.gz"
#数据库地址
HOST=127.0.0.1          # host
DB_USER=root            # 数据库用户名
DB_PW=Gao@7890          # 数据库密码
DATABASE=db_blog        # 数据库名称
random=$(($RANDOM%10+1))
if [ "$random" \< "8" ]
then
    # 回退
    cd $DIR && git reset --hard HEAD^
	#创建备份目录
	[ ! -d "${BACKUP}/$DATETIME" ] && mkdir -p "${BACKUP}/$DATETIME"
	#后台系统数据库
    cd $BACKUP
	git reset --hard HEAD^

	mysqldump -u${DB_USER} -p${DB_PW} --host=$HOST -q -R --databases $DATABASE | gzip > ${BACKUP}/$DATETIME/$DATABASE.sql.gz

	#压缩成tar.gz包
	tar -zcvf $DATETIME.tar.gz $DATETIME

	#删除10天前备份的数据
	find $BACKUP -mtime +10 -name "*.tar.gz" -exec rm -rf {} \;
	echo "===备份成功==="

    cd $DIR
	git add .
	git commit -m "${DATETIME}"
	git push origin backup
else
	echo "===未备份==="
fi
