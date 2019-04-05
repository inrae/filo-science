<?php
$root = "param/news";
$ext = ".txt";
$file = file($root.$ext);
if (file_exists($root.$language.$ext))
	$file = $root.$language.$ext;
$doc = "";
foreach($file as $key=>$value) {
	if (substr($value,1,1)=="*" or substr($value,0,1)=="*"){
		$doc .= "&nbsp;&nbsp;&nbsp;";
	}
	if ($APPLI_utf8==true) utf8_encode($value);
	$doc .= htmlentities($value)."<br>";
}

$vue->set($doc, "texteNews");
$vue->set("documentation/quoideneuf.tpl", "corps");
?>