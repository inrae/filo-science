<?php
class Example extends ObjetBDD {
	/**
	 * Constructeur de la classe
	 * 
	 * @param
	 *        	instance ADODB $bdd
	 * @param array $param        	
	 */
	function __construct($bdd, $param = null) {
		$this->table = "Example";
		$this->colonnes = array (
				"example_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0 
				),
				"example_parent_id" => array (
						"type" => 1,
						"requis" => 1,
						"parentAttrib" => 1 
				),
				"example_comment" => array (
						"defaultValue" => "Comment" 
				),
				"example_date" => array (
						"type" => 2,
						"requis" => 1,
						"defaultValue" => "getDateJour" 
				) 
		);
		parent::__construct ( $bdd, $param );
	}
}
?>