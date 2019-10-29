<script>
    function patternForm(data) {
        $("#alpacaPattern").alpaca({
            "data": data,
            "view": "bootstrap-edit-horizontal",
            "schema": {
                "title":"{t}Description du modèle{/t}",
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "tableName": {
                            "title": "{t}Nom de la table{/t}",
                            "type": "string",
                            "required": true
                        },
                        "tableAlias": {
                            "title": "{t}Alias de la table (si elle dépend de plusieurs parents){/t}",
                            "type": "string"
                        },
                        "technicalKey": {
                            "title": "{t}Clé primaire{/t}",
                            "type": "string"
                        },
                        "businessKey": {
                            "title": "{t}Clé métier{/t}",
                            "type": "string",
                        },
                        "parentKey": {
                            "title": "{t}Nom de la clé étrangère (table parente){/t}",
                            "type": "string"
                        },
                        "secondaryParentKey": {
                            "title": "{t}Nom de la seconde clé étrangère{/t}",
                            "type": "string"
                        },
                        "children": {
                            "title": "{t}Liste des alias des tables liées{/t}",
                            "type": "array",
                            "items": {
                                "type": "string"
                            }
                        }
                    }
                }
            },
            "postRender": function (control) {
                var value = control.getValue();
                $("#pattern").val(JSON.stringify(value, null, null));
                control.on("mouseout", function () {
                    var value = control.getValue();
                    $("#pattern").val(JSON.stringify(value, null, null));
                });
                control.on("change", function () {
                    var value = control.getValue();
                    $("#pattern").val(JSON.stringify(value, null, null));
                });
            }
        });
    }
</script>