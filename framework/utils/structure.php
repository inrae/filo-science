<?php
/* 
 * Recuperation de la structure de la base de donnees
 */
require_once 'framework/utils/structure.class.php';
$vue->set("framework/dbstructure.tpl", "corps");

switch ($t_module["param"]) {
    case "html":
        $dataclass = new Structure($bdd, array(),$t_module["schemas"]);
        $vue->set(
            $dataclass->generateHtml(
                "tablename",
                "tablecomment",
                "table table-bordered table-hover"
            ),
            "data"
        );
        $vue->htmlVars[] = "data";

        break;
    case "latex":
        $dataclass = new Structure($bdd, array(), $t_module["schemas"]);
        $vue->set(
            $dataclass->generateLatex(
                "subsection",
                "\\begin{tabular}{|l| p{2cm}|c|c|c| p{3cm}|}",
                "\\end{tabular}",
                $t_module["schemas"]
            ),
            "data"
        );
        $vue->htmlVars[] = "data";

        break;
    case "gacl":
        $dataclass = new Structure($bdd_gacl);
        $vue->set(
            $dataclass->generateHtml(
                "tablename",
                "tablecomment",
                "table table-bordered table-hover"
            ),
            "data"
        );
        $vue->htmlVars[] = "data";

        break;
    case "schema":
        $vue->setParam(
            array(
                "tmp_name" => 'database/filo.png',
                "filename" => "filo-science.png",
                "disposition" => "inline"
            )
        );
        break;
}
