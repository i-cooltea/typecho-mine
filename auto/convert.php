<?php

$config = [
    'host' => '127.0.0.1',
    'username' => 'root',
    'password' => 'Gao@789',
    'db' => 'db_blog',
    'output' => '/data/wwwroot/gitPage/content/posts/',
];

$db = new mysqli();
$db->connect($config['host'], $config['username'], $config['password'], $config['db']);

$prefix = "typecho";
$sql = <<<TEXT
select u.screenName author,url authorUrl,title,text,created,t2.category,t1.tags,slug from {$prefix}_contents c 
left join
 (select cid,CONCAT('"',group_concat(m.name SEPARATOR '","'),'"') tags from {$prefix}_metas m,{$prefix}_relationships r where m.mid=r.mid and m.type='tag' group by cid ) t1
 on c.cid=t1.cid
 left join
(select cid,CONCAT('"',GROUP_CONCAT(m.name SEPARATOR '","'),'"') category from {$prefix}_metas m,{$prefix}_relationships r where m.mid=r.mid and m.type='category' group by cid) t2
on c.cid=t2.cid
left join ( select uid, screenName ,url from {$prefix}_users)  as u
on c.authorId = u.uid
where type='post'
TEXT;

$successCount = 0;
$file_name = '';
$db->query("set character set 'utf8'");//读库
$res = $db->query($sql);
if ($res) {
    if ($res->num_rows > 0) {
        while ($r = $res->fetch_object()) {
            $_c = date('Y-m-d H:i:s', $r->created);
            $_t = str_replace('<!--markdown-->', '', $r->text);
            $_a = str_replace(array('C#'), 'CSharp', $r->tags);
            $_g = str_replace(array('C#'), 'CSharp', $r->category);
            $_g = str_replace(array(','), '-', $_g);
            $_author = $r->author;
            if ($r->authorUrl != "") {
                $_author = "<a href=\"{$r->authorUrl}\" rel=\"noopener\" target=\"_blank\">{$r->author}</a>";
            }
            $_tmp = <<<TMP
+++
title= "$r->title"
categories= [$r->category]
tags= [$r->tags]
draft = false
author = '{$_author}'
date= "$_c"
+++

$_t

TMP;
            $file_name = $config['output'] . str_replace(array(" ", "?", "\\", "/", ":", "|", "*"), '-', $r->title);
            file_put_contents($file_name . ".md", $_tmp);
            $successCount++;
        }
    }
    $res->free();
}
echo "successCount :$successCount \n";
$db->close();
