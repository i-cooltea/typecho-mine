<?php
/**
 * 导航
 *
 * @package custom
 */
?>
<?php if (!defined('__TYPECHO_ROOT_DIR__')) exit; ?>
<?php $this->need('header.php'); ?>
    <div id="main">
        <?php if (!empty($this->options->Breadcrumbs) && in_array('Pageshow', $this->options->Breadcrumbs)): ?>
            <div class="breadcrumbs">
                <a href="<?php $this->options->siteUrl(); ?>">首页</a> &raquo; <?php $this->title() ?>
            </div>
        <?php endif; ?>
        <article class="post">


            <h1 class="post-title"><a href="<?php $this->permalink() ?>"><?php $this->title() ?></a></h1>
            <div class="post-content">
                <?php $this->content(); ?>
                <ul class="links">
                    <script>function erroricon(obj) {
                            var a = obj.parentNode, i = document.createElement("i");
                            i.appendChild(document.createTextNode("★"));
                            a.removeChild(obj);
                            a.insertBefore(i, a.childNodes[0])
                        }</script>
                    <?php
                    $pattern = <<<EOF
<li><a href="{url}" title="{title}" alt="{name}" target="_blank">
<img src="{url}/favicon.ico" width="20" height="20" onerror="erroricon(this)" />
<span>{name}</span></a> </li> 
EOF;
                    Links_Plugin::output($pattern, true); ?>
                </ul>
            </div>


        </article>
        <?php $this->need('comments.php'); ?>
    </div>
<?php $this->need('sidebar.php'); ?>
<?php $this->need('footer.php'); ?>