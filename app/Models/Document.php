<?php

namespace App\Models;

use Config\App;
use Ppci\Libraries\PpciException;
use Ppci\Models\PpciModel;




/**
 * Orm de gestion de la table document :
 * Stockage des pièces jointes
 *
 * @author quinton
 *
 */
class Document extends PpciModel
{

    public $temp = "temp";
    public Mimetype $mimeType;
    private $parents = array("project", "protocol", "operation");
    private $parent_ids = array("operation_id", "project_id", "protocol_id");
    // Chemin de stockage des images générées à la volée
    /**
     * Constructeur de la classe
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct()
    {
        $app = service('AppConfig');
        $this->temp = $app->APP_temp;
        $this->table = "document";
        $this->fields = array(
            "document_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "uid" => array(
                "type" => 1,
                "parentAttrib" => 1
            ),
            "campaign_id" => array("type" => 1),
            "mime_type_id" => array(
                "type" => 1,
                "requis" => 1
            ),
            "document_import_date" => array(
                "type" => 3,
                "requis" => 1,
                "defaultValue" => $this->getDateTime()
            ),
            "document_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "document_description" => array(
                "type" => 0
            ),
            "data" => array(
                "type" => 0
            ),
            "thumbnail" => array(
                "type" => 0
            ),
            "size" => array(
                "type" => 1,
                "defaultValue" => 0
            ),
            "document_creation_date" => array(
                "type" => 2,
                "defaultValue" => $this->getDateJour()
            )
        );
        parent::__construct();
    }

    /**
     * Get the max Upload size of a document, in Mb
     *
     * @return integer
     */
    function getMaxUploadSize(): int
    {
        $max_upload = (int) (ini_get('upload_max_filesize'));
        $max_post = (int) (ini_get('post_max_size'));
        $memory_limit = (int) (ini_get('memory_limit'));
        return (min($max_upload, $max_post, $memory_limit));
    }

    /**
     * Ecriture d'un document
     *
     * @param array $file
     *            : tableau contenant les informations sur le fichier importé
     * @param
     *            string description : description du contenu du document
     * @return int
     */
    function documentWrite($file, $parentName, $parentKeyValue, $description = NULL, $document_creation_date = NULL)
    {
        if ($file["error"] == 0 && $file["size"] > 0 && is_numeric($parentKeyValue) && $parentKeyValue > 0) {
            /**
             * Recuperation de l'extension
             */
            $extension = substr($file["name"], strrpos($file["name"], ".") + 1);
            $mimeType = new MimeType;
            $mime_type_id = $mimeType->getTypeMime($extension);
            if ($mime_type_id > 0) {
                $data = array();
                $data["document_name"] = $file["name"];
                $data["size"] = $file["size"];
                $data["mime_type_id"] = $mime_type_id;
                $data["document_description"] = $description;
                $data["document_import_date"] = date($_SESSION["date"]["maskdatelong"]);
                $data[$parentName . "_id"] = $parentKeyValue;
                if (!is_null($document_creation_date)) {
                    $data["document_creation_date"] = $document_creation_date;
                }
                $dataDoc = array(
                    "thumbnail" => "",
                    "data" => ""
                );
                /**
                 * Recherche pour savoir s'il s'agit d'une image ou d'un pdf pour créer une vignette
                 */
                $extension = strtolower($extension);
                /**
                 * Ecriture du document
                 */

                $dataBinaire = fread(fopen($file["tmp_name"], "r"), $file["size"]);

                $dataDoc["data"] = pg_escape_bytea($this->db->connID, $dataBinaire);
                if ($extension == "pdf" || $extension == "png" || $extension == "jpg") {
                    $image = new \Imagick();
                    $image->readImageBlob($dataBinaire);
                    $image->setiteratorindex(0);
                    $image->resizeimage(200, 200, \imagick::FILTER_LANCZOS, 1, true);
                    $image->setformat("png");
                    $dataDoc["thumbnail"] = pg_escape_bytea($this->db->connID, $image->getimageblob());
                }
                /**
                 *  suppression du stockage temporaire
                 */
                unset($file["tmp_name"]);
                /**
                 * Ecriture dans la base de données
                 */
                $id = parent::write($data);
                if ($id > 0) {
                    $sql = "update document set data = '" . $dataDoc["data"] . "', thumbnail = '" . $dataDoc["thumbnail"] . "' where document_id = " . $id;
                    $this->executeSQL($sql, [], true);
                    /**
                     * Generate the relation with the parent table
                     */
                    if (in_array($parentName, $this->parents)) {
                        $sql = "insert into " . $parentName . "_document
									(" . $parentName . "_id, document_id)
									values
									(:parent_id:, :document_id:)";
                        $this->executeQuery($sql, array("parent_id" => $parentKeyValue, "document_id" => $id), true);
                    } else {
                        $this->message->set(sprintf(_("L'ajout de documents à %s n'est pas autorisé"), $parentName));
                        throw new PpciException("Error: " . $parentName . " not parameterized");
                    }
                }
                return $id;
            }
        }
    }

    /**
     * Recupere les informations d'un document
     *
     * @param int $id
     * @return array
     */
    function getData(int $id)
    {
        if ($id > 0) {
            $sql = "select document_id, document_name, content_type, mime_type_id, extension,
					document_import_date, document_creation_date
				from document
				join mime_type using (mime_type_id)
				where document_id = :document_id:";

            return $this->lireParamAsPrepared(
                $sql,
                array(
                    "document_id" => $id
                )
            );
        }
    }

    /**
     * Envoie un fichier au navigateur, pour affichage
     *
     * @param int $id
     *            : cle de la photo
     * @param int $phototype
     *            : 0 - photo originale, 1 - resolution fournie, 2 - vignette
     * @param boolean $attached
     * @param int $resolution
     *            : resolution pour les photos redimensionnees
     */
    function prepareDocument($id, $phototype = 0, $resolution = 800)
    {
        $filename = $this->generateFileName($id, $phototype, $resolution);
        if (!empty($filename) && is_numeric($id) && $id > 0) {
            if (!file_exists($filename)) {
                $this->writeFileImage($id, $phototype, $resolution);
            }
        }
        if (file_exists($filename)) {
            return $filename;
        }
    }

    /**
     * Calcule le nom de la photo
     *
     * @param int $id
     * @param int $phototype
     *            : type de la photo - 0 : original, 1 : photo reduite, 2 : vignette
     * @param number $resolution
     * @return string
     */
    function generateFileName($id, $phototype = 0, $resolution = 800)
    {
        /**
         * Preparation du nom de la photo
         */
        switch ($phototype) {
            case 0:
                if (is_numeric($id)) {
                    $data = $this->getData($id);
                }
                $filename = $this->temp . '/' . $id . "-" . $data["document_name"];
                break;
            case 1:
                $filename = $this->temp . '/' . $id . "x" . $resolution . ".png";
                break;
            case 2:
                $filename = $this->temp . '/' . $id . '_vignette.png';
                break;
            default:
                throw new PpciException(_("Le type de document n'est pas correctement défini"));
        }
        return $filename;
    }

    /**
     * Ecrit une photo dans un dossier temporaire, pour lien depuis navigateur
     *
     * @param int $id
     * @param $phototype :
     *            0 - photo originale, 1 - photo a la resolution fournie, 2 - vignette
     * @param binary $document
     * @return string
     */
    function writeFileImage($id, $phototype = 0, $resolution = 800)
    {
        if ($id > 0 && is_numeric($id) && is_numeric($phototype) && is_numeric($resolution)) {
            $data = $this->getData($id);
            $okgenerate = false;
            /**
             * Recherche si la photo doit etre generee (en fonction du phototype ou du mimetype)
             */
            switch ($phototype) {
                case 0:
                    $okgenerate = true;
                    break;
                case 2:
                    if (
                        in_array(
                            $data["mime_type_id"],
                            array(
                                1,
                                4,
                                5,
                                6
                            )
                        )
                    ) {
                        $okgenerate = true;
                    }
                    break;
                case 1:
                    if (
                        in_array(
                            $data["mime_type_id"],
                            array(
                                4,
                                5,
                                6
                            )
                        )
                    ) {
                        $okgenerate = true;
                    }
                    break;
            }
            if ($okgenerate) {
                /**
                 * Selection de la colonne contenant la photo
                 */
                $phototype == 2 ? $colonne = "thumbnail" : $colonne = "data";
                $filename = $this->generateFileName($id, $phototype, $resolution);
                if (!file_exists($filename)) {
                    try {
                        $sql = "select $colonne as picture from document where document_id = :id:";
                        $data = $this->readParam($sql, ["id" => $id]);
                        if (empty($data)) {
                            throw new PpciException(_("Le document demandé n'existe pas"));
                        }
                        if (($data["mime_type_id"] == 4 || $data["mime_type_id"] == 5 || $data["mime_type_id"] == 6)) {
                            $image = new \Imagick();
                            try {
                                $image->readImageBlob(pg_unescape_bytea($data["picture"]));
                                if ($phototype == 1) {
                                    $resize = false;
                                    $geo = $image->getimagegeometry();
                                    if ($geo["width"] > $resolution || $geo["height"] > $resolution) {
                                        $resize = true;
                                        if ($resize) {
                                            /*
                                        * Mise a l'image de la photo
                                        */
                                            $image->resizeImage($resolution, $resolution, \Imagick::FILTER_LANCZOS, 1, true);
                                        }
                                    }
                                }
                                /**
                                 * Ecriture de la photo
                                 */
                                $image->writeImage($filename);
                            } catch (\ImagickException $ie) {
                                throw new PpciException(sprintf(_("Impossible de lire la photo %s : "),  $id) . $ie->getMessage());
                            }
                        } else {
                            /**
                             * Others docs
                             */
                            $handle = fopen($filename, 'wb');
                            fwrite($handle, pg_unescape_bytea($data["picture"]));
                            fclose($handle);
                        }
                    } catch (PpciException $e) {
                        throw new PpciException($e->getMessage());
                    }
                }
            }
        }
        return $filename;
    }

    /**
     * Get the documents associated to a parent table
     *
     * @param string $parentTable
     * @param int $parentId
     * @return array
     */
    function documentGetListFromParent($parentTable, $parentId)
    {
        if (in_array($parentTable, $this->parents)) {
            $sql = "select document_id, document_import_date, document_name, document_description,
					size, document_creation_date, mime_type_id
					from document
					join " . $parentTable . "_document using (document_id)
					join " . $parentTable . " using (" . $parentTable . "_id)
					where " . $parentTable . "_id = :parentId:";
            return $this->getListeParamAsPrepared($sql, array("parentId" => $parentId));
        }
    }
}
