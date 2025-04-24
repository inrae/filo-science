<?php 
namespace App\Models;
use Ppci\Models\PpciModel;

/**
 * @author Eric Quinton
 * @copyright Copyright (c) 2014, IRSTEA / Eric Quinton
 * @license http://www.cecill.info/licences/Licence_CeCILL-C_V1-fr.html LICENCE DE LOGICIEL LIBRE CeCILL-C
 *  Creation 7 avr. 2014
 *
 *  Les classes fonctionnent avec les tables suivantes :
 *
 CREATE TABLE mime_type
 (
 mime_type_id  serial     NOT NULL,
 content_type  varchar    NOT NULL,
 extension     varchar    NOT NULL
 );

 -- Column mime_type_id is associated with sequence public.mime_type_mime_type_id_seq


 ALTER TABLE mime_type
 ADD CONSTRAINT mime_type_pk
 PRIMARY KEY (mime_type_id);

 COMMENT ON TABLE mime_type IS 'Table des types mime, pour les documents associés';
 COMMENT ON COLUMN mime_type.content_type IS 'type mime officiel';
 COMMENT ON COLUMN mime_type.extension IS 'Extension du fichier correspondant';
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  1,  'application/pdf',  'pdf');

 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  2,  'application/zip',  'zip');

 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  3,  'audio/mpeg',  'mp3');

 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  4,  'image/jpeg',  'jpg');

 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES(  5,  'image/jpeg',  'jpeg');

 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  6,  'image/png',  'png');

 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  7,  'image/tiff',  'tiff');

 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  9,  'application/vnd.oasis.opendocument.text',  'odt');

 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  10,  'application/vnd.oasis.opendocument.spreadsheet',  'ods');

 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  11,  'application/vnd.ms-excel',  'xls');

 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  12,  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',  'xlsx');

 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  13,  'application/msword',  'doc');

 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  14,  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',  'docx');

 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  8,  'text/csv',  'csv');


 CREATE TABLE document
 (
 document_id           serial     NOT NULL,
 mime_type_id          integer    NOT NULL,
 document_import_date  timestamp       NOT NULL,
 document_name          varchar    NOT NULL,
 document_description  varchar,
 data                  bytea,
 size                  integer,
 thumbnail             bytea
 );

 -- Column document_id is associated with sequence public.document_document_id_seq


 ALTER TABLE document
 ADD CONSTRAINT document_pk
 PRIMARY KEY (document_id);

 ALTER TABLE document
 ADD CONSTRAINT mime_type_document_fk FOREIGN KEY (mime_type_id)
 REFERENCES mime_type (mime_type_id)
 ON UPDATE NO ACTION
 ON DELETE NO ACTION;

 COMMENT ON TABLE document IS 'Documents numériques rattachés à un poisson ou à un événement';
 COMMENT ON COLUMN document.document_name IS 'Nom d''origine du document';
 COMMENT ON COLUMN document.document_description IS 'Description libre du document';
 */
/**
 * ORM de gestion de la table mime_type
 *
 * @author quinton
 *
 */
class DocumentException extends Exception
{ }

class MimeType extends PpciModel
{

	/**
	 * Constructeur de la classe
	 *
	 * @param 
	 * @param array $param
	 */
	function __construct($bdd, $param = null)
	{
		$this->table = "mime_type";
		$this->fields = array(
			"mime_type_id" => array(
				"type" => 1,
				"key" => 1,
				"requis" => 1,
				"defaultValue" => 0
			),
			"extension" => array(
				"type" => 0,
				"requis" => 1
			),
			"content_type" => array(
				"type" => 0,
				"requis" => 1
			)
		);
		parent::__construct();
	}

	/**
	 * Retourne le numero de type mime correspondant a l'extension
	 *
	 * @param string $extension
	 * @return int
	 */
	function getTypeMime($extension)
	{
		if (!empty($extension) ) {
			$sql = "SELECT mime_type_id from mime_type where extension = :extension";
			$res = $this->lireParamAsPrepared($sql, array("extension" => strtolower($extension)));
			return $res["mime_type_id"];
		}
	}
}

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
	private $parents = array("project", "protocol", "operation");

	// Chemin de stockage des images générées à la volée
	/**
	 * Constructeur de la classe
	 *
	 * @param 
	 * @param array $param
	 */
	function __construct()
	{
		global $APPLI_temp;
		if (!empty($APPLI_temp)) {
			$this->temp = $APPLI_temp;
		}
		$this->table = "document";
		$this->fields = array(
			"document_id" => array(
				"type" => 1,
				"key" => 1,
				"requis" => 1,
				"defaultValue" => 0
			),
			"mime_type_id" => array(
				"type" => 1,
				"requis" => 1
			),
			"document_import_date" => array(
				"type" => 2,
				"requis" => 1,
				"defaultValue" => "getDateJour"
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
				"defaultValue" => "getDateJour"
			)
		);
		parent::__construct();
	}


	/**
	 * Write a document and associated it with the parent
	 *
	 * @param array $file
	 * @param string $parentTable
	 * @param int $parentId
	 * @param string $description
	 * @param date $document_creation_date
	 * @return void
	 */
	function documentEcrire($file, $parentTable, $parentId, $description = NULL, $document_creation_date = NULL)
	{
		if ($file["error"] == 0 && $file["size"] > 0) {
			global $message;
			/*
             * Recuperation de l'extension
             */
			$extension = $this->encodeData(substr($file["name"], strrpos($file["name"], ".") + 1));
			$mimeType = new MimeType;
			$mime_type_id = $mimeType->getTypeMime($extension);
			if ($mime_type_id > 0) {
				$data = array();
				$data["document_name"] = $file["name"];
				$data["size"] = $file["size"];
				$data["mime_type_id"] = $mime_type_id;
				$data["document_description"] = $description;
				$data["document_import_date"] = date($_SESSION["MASKDATE"]);
				if (!is_null($document_creation_date)) {
					$data["document_creation_date"] = $document_creation_date;
				}
				$dataDoc = array();
				/*
                 * Recherche antivirale
                 */
				$virus = false;
				try {
					testScan($file["tmp_name"]);
				} catch (VirusException $ve) {
					$message->set($ve->getMessage());
					$virus = true;
				} catch (FileException $fe) {
					$message->set($fe->getMessage());
				}

				/*
                 * Recherche pour savoir s'il s'agit d'une image ou d'un pdf pour créer une vignette
                 */
				$extension = strtolower($extension);
				/*
                 * Ecriture du document
                 */
				if (!$virus) {
					$dataBinaire = fread(fopen($file["tmp_name"], "r"), $file["size"]);

					$dataDoc["data"] = pg_escape_bytea($dataBinaire);
					if ($extension == "pdf" || $extension == "png" || $extension == "jpg") {
						try {
							//$image = new Imagick($file["tmp_name"].'[0]');
							$image = new Imagick();
							$image->readImageBlob($dataBinaire);
							$image->setiteratorindex(0);
							$image->resizeImage(200, 200, imagick::FILTER_LANCZOS, 1, true);
							$image->setFormat("png");
							$dataDoc["thumbnail"] = pg_escape_bytea($image->getimageblob());
						} catch (ImagickException $ie) {
							$message->set(sprintf(_("Génération de la vignette en échec pour %s"), $data["document_name"]));
							$message->setSyslog($ie->getMessage());
						}
					}
					/*
                     * suppression du stockage temporaire
                     */
					unset($file["tmp_name"]);
					/*
                     * Ecriture dans la base de données
                     */
					$id = parent::write($data);
					if ($id > 0) {
						$sql = "update " . $this->table . " set data = '" . $dataDoc["data"] . "', thumbnail = '" . $dataDoc["thumbnail"] . "' where document_id = " . $id;
						$this->executeSQL($sql);
						/**
						 * Generate the relation with the parent table
						 */
						if (in_array($parentTable, $this->parents)) {
							$sql = "insert into " . $parentTable . "_document
									(" . $parentTable . "_id, document_id)
									values
									(:parent_id, :document_id)";
							$this->executeAsPrepared($sql, array("parent_id" => $parentId, "document_id" => $id), true);
						} else {
							$message->set(sprintf(_("L'ajout de documents à %s n'est pas autorisé"), $parentTable));
							throw new DocumentException("Error: ".$parentTable." not parameterized");
						}
					}
					return $id;
				}
			}
		}
	}

	/**
	 * Recupere les informations d'un document
	 *
	 * @param int $id
	 * @return array
	 */
	function getData($id)
	{
		if ($id > 0 && is_numeric($id)) {
			$sql = "SELECT document_id, document_name, content_type, mime_type_id, extension,
					document_import_date, document_creation_date
				from document
				join mime_type using (mime_type_id)
				where document_id = :document_id";

			return $this->lireParamAsPrepared($sql, array(
				"document_id" => $id
			));
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
		global $message;
		$id = $this->encodeData($id);
		try {
			$filename = $this->generateFileName($id, $phototype, $resolution);
			if (!empty($filename)  && is_numeric($id) && $id > 0) {
				if (!file_exists($filename)) {
					$this->writeFileImage($id, $phototype, $resolution);
				}
			}
			if (file_exists($filename)) {
				return $filename;
			}
		} catch (DocumentException $de) {
			$message->set($de->getMessage());
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
		/*
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
				throw new DocumentException(_("Génération du nom du fichier image : le type de photo n'est pas correctement défini"));
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
		global $message;
		if ($id > 0 && is_numeric($id) && is_numeric($phototype) && is_numeric($resolution)) {
			$data = $this->getData($id);
			$okgenerate = false;
			$redim = false;
			/*
             * Recherche si la photo doit etre generee (en fonction du phototype ou du mimetype)
             */
			switch ($phototype) {
				case 0:
					$okgenerate = true;
					break;
				case 2:
					if (in_array($data["mime_type_id"], array(
						1,
						4,
						5,
						6
					))) {
						$okgenerate = true;
					}
					$redim = true;
					break;
				case 1:
					if (in_array($data["mime_type_id"], array(
						4,
						5,
						6
					))) {
						$okgenerate = true;
					}
					$redim = true;
					break;
			}
			if ($okgenerate) {
				$writeOk = false;
				/*
                 * Selection de la colonne contenant la photo
                 */
				$phototype == 2 ? $colonne = "thumbnail" : $colonne = "data";
				$filename = $this->generateFileName($id, $phototype, $resolution);
				if (!empty($filename) && !file_exists($filename)) {
					/*
                     * Recuperation des donnees concernant la photo
                     */
					$docRef = $this->getBlobReference($id, $colonne);
					if (in_array($data["mime_type_id"], array(
						4,
						5,
						6
					)) && $docRef != NULL) {
						try {
							$image = new Imagick();
							$image->readImageFile($docRef);
							if ($redim) {
								/*
                                 * Redimensionnement de l'image
                                 */
								$resize = 0;
								$geo = $image->getimagegeometry();
								if ($geo["width"] > $resolution || $geo["height"] > $resolution) {
									$resize = 1;
									/*
                                     * Calcul de la résolution dans les deux sens
                                     */
									if ($geo["width"] > $resolution) {
										$resx = $resolution;
										$resy = $geo["height"] * ($resolution / $geo["width"]);
									} else {
										$resy = $resolution;
										$resx = $geo["width"] * ($resolution / $geo["height"]);
									}
								}
								if ($resize == 1) {
									$image->resizeImage($resx, $resy, imagick::FILTER_LANCZOS, 1);
								}
							}
							$document = $image->getimageblob();
							$writeOk = true;
						} catch (ImagickException $ie) {
							throw new DocumentException(sprintf(_("Erreur de génération de l'image %s"), $data["document_name"]));
						}
					} else {
						/*
                         * Autres types de documents : ecriture directe du contenu
                         */
						if (($data["mime_type_id"] == 1 && $phototype == 2) || $phototype == 0) {
							$writeOk = true;
							$document = stream_get_contents($docRef);
							if (!$document) {
								throw new DocumentException("Erreur de lecture" . $docRef);
							}
						}
					}
					/*
                     * Ecriture du document dans le dossier temporaire
                     */
					if ($writeOk) {
						$handle = fopen($filename, 'wb');
						fwrite($handle, $document);
						fclose($handle);
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
			$sql = "SELECT document_id, document_import_date, document_name, document_description,
					size, document_creation_date, mime_type_id
					from document
					join " . $parentTable . "_document using (document_id)
					join " . $parentTable . " using (" . $parentTable . "_id)
					where " . $parentTable . "_id = :parentId";
			return $this->getListeParamAsPrepared($sql, array("parentId" => $parentId));
		}
	}

	function deleteAllFromParent($parentTable, $parentId) {
		if (in_array($parentTable, $this->parents)) {
			$ldoc = $this->getListFromParent($parentTable, $parentId);
			/**
			 * Delete records in the relation table
			 */
			$sql = "delete from ".$parentTable."_document where ".$parentTable."_id = :parentId";
			$this->executeAsPrepared($sql, array("parentId"=>$parentId), true);
			/**
			 * Delete records
			 */
			foreach ($ldoc as $doc) {
				$this->delete($doc["document_id"]);
			}
		}
	}
}
