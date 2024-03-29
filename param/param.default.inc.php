<?php
/** Fichier cree le 4 mai 07 par quinton
*
*UTF-8
*
* Parametres par defaut de l'application
* Si des modifications doivent etre apportees, faites-les dans le fichier param.inc.php
*/
$APPLI_version = "23.0.0";
$APPLI_dbversion = "1.11";
$APPLI_versiondate = _("11/10/2023");
//$APPLI_versiondate = "3/7/2018";
$language = "fr";
$DEFAULT_formatdate = "fr";
/*
 * Navigation a partir du fichier xml
 */
$navigationxml = array("framework/actions.xml", "param/actions.xml");
/*
 * Duree de la session par defaut
 * @var unknown_type
 */
// 4 heures
$APPLI_session_ttl = 14400;
// 3 mois
$APPLI_cookie_ttl = 7776000;
// 10 heures
$APPLI_absolute_session = 36000;
$ident_header_vars = array(
	"login" => "MELLON_MAIL",
	"mail" => "MELLON_MAIL",
	"name" => "MELLON_cn",
	"firstname"=>"MELLON_givenname",
	"lastname" => "MELLON_sn",
	"organization" => "MELLON_supannentiteaffectationprincipale",
	"organizationGranted" => array(),
	"createUser" => true,
	"groupAttribute" => "MELLON_supannentiteaffectation",
	"groupsGranted" => array()
);
$user_attributes = array (
	"mail" => "mail",
	"firstname"=>"givenName",
	"lastname"=>"sn",
	"name"=>"cn",
	"groups"=>"supannentiteaffectation"
);
$ident_header_logout_address = "";

/*
 *
 * Nom du chemin de stockage des sessions
 * @var unknown_type
 */
$APPLI_path_stockage_session = "prototypephp";
/*
 * Duree de conservation des traces (en jours) dans la table log
 */
$LOG_duree = 365;
/*
 * Type d'identification
 *
 * BDD : mot de passe en base de donnees
 * CAS : utilisation d'un serveur CAS
 * LDAP : utilisation d'un serveur LDAP
 * LDAP-BDD : test d'abord aupres du serveur LDAP, puis du serveur BDD
 * HEADER : l'identification est fournie dans une variable HEADER (derriere un proxy comme
 * LemonLdap, par exemple)
 */
$ident_header_login_var = "AUTH_USER";
$ident_header_logout_address = "";
$ident_type = "BDD";
$LDAP = array(
		"address"=>"localhost",
		"port" => 389,
		"rdn" => "cn=manager,dc=example,dc=com",
		"basedn" => "ou=people,ou=example,o=societe,c=fr",
		"user_attrib" => "uid",
		"v3" => true,
		"tls" => false,
		"upn_suffix" => "", //pour Active Directory
		"groupSupport"=>false,
		"groupAttrib"=>"supannentiteaffectation",
		"commonNameAttrib"=>"displayname",
		"mailAttrib"=>"mail",
		'attributgroupname' => "cn",
		'attributloginname' => "memberuid",
		'basedngroup' => 'ou=example,o=societe,c=fr'
);

/*
 * Parametres concernant la base de donnees
 */
$BDD_login = "proto";
$BDD_passwd = "proto";
$BDD_dsn = "pgsq:host=localhost;dbname=proto";
$BDD_schema = "public";
/*
 * Parametres concernant SMARTY
 */
$display = "display"; // Dossier de base contenant tout l'affichage
$SMARTY_param = array("templates"=> "$display/templates",
		"templates_c"=>"$display/templates_c",
		"cache"=>false,
		"cache_dir"=>"$display/smarty_cache",
		"template_main"=>"main.htm"
);

/*
 * Variables de base de l'application
 */
$APPLI_mail = "proto@proto.com";
$APPLI_nom = "Prototype d'application";
$APPLI_code = 'proto';
$APPLI_fds = "$display/CSS/blue.css";
$APPLI_address = "http://localhost/proto";
$APPLI_modeDeveloppement = false;
$APPLI_modeDeveloppementDroit = false;
$APPLI_utf8 = true;
$APPLI_menufile = "param/menu.xml";
$APPLI_temp = "temp";
$APPLI_assist_address = "https://github.com/inrae/filo-science/issues/new";
$APPLI_isFullDns = false;
/*
 * Variables systematiques pour SMARTY
 */
$SMARTY_variables = array(
		"entete"=>"entete.tpl",
		"enpied"=>"enpied.tpl",
		"corps"=>"main.tpl",
		"melappli"=>$APPLI_mail,
		"ident_type"=>$ident_type,
        "appliAssist"=>$APPLI_assist_address,
        "display"=>"/$display",
        "favicon"=>"/favicon.png"
);
/*
 * Variables liees a GACL et l'identification via base de donnees
 */
$GACL_dblogin = "proto";
$GACL_dbpasswd = "proto";
$GACL_aco = "col";
$GACL_dsn = "pgsql:host=localhost;dbname=proto";
$GACL_schema = "gacl";
/*
 * Inhib the creation of a new right with 1
 */
$GACL_disable_new_right = 0;
/*
 * Gestion des erreurs
 */
$ERROR_level=E_ERROR;
/*
 * Pour le developpement :
 * $ERROR_level = E_ALL & ~E_NOTICE & E_STRICT
 * En production :
 * $ERROR_level = E_ERROR ;
 */
$ERROR_display=0;
$ADODB_debugmode = 0;
$OBJETBDD_debugmode = 1;
/*
 * Modules de traitement des erreurs
 */
$APPLI_moduleDroitKO = "droitko";
$APPLI_moduleErrorBefore = "errorbefore";
$APPLI_moduleNoLogin = "errorlogin";
$APPLI_notSSL = false;
/*
 * Cles privee et publique utilisees
 * pour la generation des jetons
 */
$privateKey = "param/id_filo-science";
$pubKey = "param/id_filo-science.pub";
/*
 * Duree de validite du token d'identification
 */
$tokenIdentityValidity = 36000; // 10 heures

/*
 * Nombre maximum d'essais de connexion
 */
$CONNEXION_max_attempts = 5;
/*
 * Duree de blocage du compte (duree reinitialisee a chaque tentative)
 */
$CONNEXION_blocking_duration = 600;
/*
 * Laps de temps avant de renvoyer un mail a l'administrateur en cas de blocage de compte
 */
$APPLI_mailToAdminPeriod = 7200;
$APPLI_admin_ttl = 600; // Duree maxi d'inactivite pour acceder a un module d'administration
$APPLI_lostPassword = 1; // Autorise la recuperation d'un nouveau mot de passe en cas de perte
$APPLI_passwordMinLength = 12;
$APPLI_hour_duration = 3600; // Duration of an hour for count all calls to a module
$APPLI_day_duration = 36000; //Duration of a day for count all calls to a module
$MAIL_enabled = 1; // send mails

$CAS_address = "localhost/CAS"; // Address of CAS server
$CAS_port = 443; //port of CAS server
$CAS_debug = false; // Activation of debug mode
$CAS_CApath=""; // path to the certificate of the CAS
/*
 * default values for feedCacheMap (OSM map cache)
 */
$mapSeedMinZoom = 12;
$mapSeedMaxZoom = 16;
$mapSeedMaxAge = 7;
$mapCacheMaxAge = 7 * 24 * 3600 * 1000;
?>
