<?
/**
 * ORM of the table analyse_template
 */
class Analyse_template extends ObjetBDD
{

    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "analyse_template";
        $this->colonnes = array(
            "analyse_template_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "analyse_template_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "analyse_template_value" => array("type"=>0)
        );
        parent::__construct($bdd, $param);
    }
}