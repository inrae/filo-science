<?php

/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Project extends ObjetBDD
{
    private $sql = "select project_id, project_name, is_active, metric_srid,protocol_id
    ,array_to_string(array_agg(groupe),', ') as groupe
    ,protocol_name, measure_default, measure_default_only
    from project
    left outer join project_group using (project_id)
    left outer join aclgroup using (aclgroup_id)
    left outer join protocol on (protocol_default_id = protocol_id)
    ";
    private $group = " group by project_id, project_name, is_active, protocol_id, protocol_name, measure_default, measure_default_only";
    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "project";
        $this->colonnes = array(
            "project_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "project_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "is_active" => array(
                "type" => 0,
                "defaultValue" => 1
            ),
            "metric_srid" => array(
                "type" => 1,
                "defaultValue" => 2154
            ),
            "protocol_default_id" => array(
                "type" => 1
            )
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Ajoute la liste des groupes a la liste des projects
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::getListe()
     */
    function getListe($order = 0, $is_active = -1)
    {
        $orderSql = " order by $order";
        if ($is_active > -1) {
            $where = " where is_active = :is_active";
            return $this->getListeParamAsPrepared($this->sql . $where . $this->group . $orderSql, array("is_active" => $is_active));
        } else {
            return $this->getListeParam($this->sql . $this->group . $orderSql);
        }
    }
    /**
     * Get the detail of a project
     *
     * @param [int] $project_id
     * @return array
     */
    function getDetail($project_id)
    {
        $where = " where project_id = :project_id";

        return $this->lireParamAsPrepared($this->sql . $where . $this->group, array("project_id" => $project_id));
    }

    /**
     * Retourne la liste des projects autorises pour un login
     *
     * @return array
     */
    function getprojectsFromLogin()
    {
        return $this->getprojectsFromGroups($_SESSION["groupes"]);
    }

    /**
     * Retourne la liste des projects correspondants aux groupes indiques
     *
     * @param array $groups 
     * 
     * @return array
     */
    function getprojectsFromGroups(array $groups)
    {
        if (count($groups) > 0) {
            /*
             * Preparation de la clause in
             */
            $comma = false;
            $in = "(";
            foreach ($groups as $value) {
                if (strlen($value["groupe"]) > 0) {
                    $comma ? $in .= ", " : $comma = true;
                    $in .= "'" . $value["groupe"] . "'";
                }
            }
            $in .= ")";
            $sql = "select distinct project_id, project_name
					from project
					join project_group using (project_id)
					join aclgroup using (aclgroup_id)
					where groupe in $in";
            $order = " order by project_name";
            return $this->getListeParam($sql . $order);
        } else {
            return array();
        }
    }

    /**
     * Surcharge de la fonction ecrire, pour enregistrer les groupes autorises
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::ecrire()
     */
    function ecrire($data)
    {
        $id = parent::ecrire($data);
        if ($id > 0) {
            /*
             * Ecriture des groupes
             */
            $this->ecrireTableNN("project_group", "project_id", "aclgroup_id", $id, $data["groupes"]);
        }
        return $id;
    }

    /**
     * Delete a project
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::supprimer()
     */
    function supprimer($id)
    {
        if ($id > 0 && is_numeric($id)) {

            $sql = "delete from project_group where project_id = :project_id";
            $data["project_id"] = $id;
            $this->executeAsPrepared($sql, $data);
            /**
             * delete documents
             */
            include_once "modules/classes/document.class.php";
            $doc = new Document($this->connection);
            $doc->deleteAllFromParent("project", $id);

            return parent::supprimer($id);
        }
    }

    /**
     * Retourne la liste de tous les groupes, en indiquant s'ils sont ou non presents
     * dans le projet (attribut checked a 1)
     *
     * @param int $project_id
     * @return array
     */
    function getAllGroupsFromproject($project_id)
    {
        if ($project_id > 0 && is_numeric($project_id)) {
            $data = $this->getGroupsFromproject($project_id);
            $dataGroup = array();
            foreach ($data as $value) {
                $dataGroup[$value["aclgroup_id"]] = 1;
            }
        }
        require_once 'framework/droits/droits.class.php';
        $aclgroup = new Aclgroup($this->connection);
        $groupes = $aclgroup->getListe(2);
        foreach ($groupes as $key => $value) {
            $groupes[$key]["checked"] = $dataGroup[$value["aclgroup_id"]];
        }
        return $groupes;
    }

    /**
     * Retourne la liste des groupes attaches a un projet
     *
     * @param int $project_id
     * @return array
     */
    function getGroupsFromproject($project_id)
    {
        $data = array();
        if ($project_id > 0 && is_numeric($project_id)) {
            $sql = "select aclgroup_id, groupe from project_group
					join aclgroup using (aclgroup_id)
					where project_id = :project_id";
            $var["project_id"] = $project_id;
            $data = $this->getListeParamAsPrepared($sql, $var);
        }
        return $data;
    }

    /**
     * Initialise la liste des connexions rattachees au login
     */
    function initprojects()
    {
        $_SESSION["projects"] = $this->getprojectsFromLogin();
        /*
         * Attribution des droits de gestion si attache a un projet
         */
        if (count($_SESSION["projects"]) > 0) {
            $_SESSION["droits"]["gestion"] = 1;
        }
    }

    function getProjectsActive($is_active, $projects)
    {
        /**
         * Creation of the list of authorized projects
         */
        $in = "";
        $comma = "";
        foreach ($projects as $project) {
            $in .= $comma . $project["project_id"];
            $comma = ", ";
        }
        $where = " where is_active = :is_active and project_id in (" . $in . ")";
        $order = " order by project_name";
        return ($this->getListeParamAsPrepared($this->sql . $where . $this->group . $order, array("is_active" => $is_active)));
    }
}
