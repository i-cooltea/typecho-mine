#!/usr/bin/bash
## 清除原来的文件 & 版本回退
echo "synch date :$(date +%Y%m%d) " >synch_gitpage.log
(cd /data/wwwroot/gitPage/public/ rm -rf posts/* && git reset --hard HEAD^ ) &>>synch_gitpage.log

## 转换hugo文件
/usr/bin/php /data/wwwroot/myBlog/auto/convert.php &>>synch_gitpage.log
(cd /data/wwwroot/gitPage && /usr/local/bin/hugo --theme=maupassant --baseUrl="http://i-cooltea.github.io/") &>>synch_gitpage.log

## 自动提交
(cd /data/wwwroot/gitPage/public && /usr/bin/git add . && git commit -m "date-$(date +%y%m%d)" && git push -f) &>>synch_gitpage.log
