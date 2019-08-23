<script>
function renderForm(data){
    $("#metadata").alpaca({
        "data": data,
        "view": "bootstrap-edit-horizontal",
        "schema": {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "name": {
                        "title": "{t}Nom du champ (sans espace, sans accent, en minuscule){/t}",
                        "type": "string",
                        "required": true
                    },
                    "type": {
                        "title": "{t}Type du champ{/t}",
                        "type": "string",
                        "required": true,
                        "enum": ["number","string","textarea","checkbox","select", "radio", "url"],
                        "default": "string"
                    },
                    "choiceList": {
                        "title": "{t}Choix possibles{/t}",
                        "type": "array",
                        "items": {
                            "type": "string"
                        }
                    },
                   /* "enum": {
                        "title":"Liste de valeurs possibles (radio-boutons ou cases à cocher)",
                        "type": "array"
                    },*/
                    "required": {
                        "title":"{t}Le champ est-il obligatoire ?{/t}"
                    },
                    "defaultValue": {
                        "title":"{t}Valeur par défaut{/t}"
                    },
                    "description" :{
                        "title": "{t}Description du champ{/t}",
                        "type" : "string",
                        "required": true
                    },
                    "measureUnit" :{
                        "title": "{t}Unité de mesure (ou modalités) - N/A si non applicable{/t}",
                        "type" : "string",
                        "required": true,
                        "default":"N/A"
                    }
                },
                "dependencies": {
                    "choiceList": ["type"],
                }
            }
        },
        "options": {
            "items": {
                "fields": {
                    "type": {
                        "optionLabels": ["{t}Nombre{/t}","{t}Texte (une ligne){/t}","{t}Texte (multi-ligne){/t}","{t}Case à cocher{/t}","{t}Liste à choix multiple{/t}","{t}Boutons Radio{/t}", "{t}Lien vers un site externe (URL){/t}"],
                        "type": "select",
                        "hideNone": true,
                        "sort": function(a, b) { 
                                        return 0; 
                                    }
                    },
                    "choiceList":{
                        "dependencies": {
                            "type":["select","checkbox","radio"]
                        }
                    },
                    
                    "required": {
                        "type": "checkbox",
                        "rightLabel": "{t}Obligatoire{/t}"
                    },
                    "defaultValue": {
                        "type": "text"                            
                    },
                    "description" :{
                        "type" : "textarea",
                        "rows":3
                    },
                    "measureUnit" :{
                        "type" : "textarea",
                        "rows":3
                    }
                }
            }
        },
        "postRender": function(control) {
            var value = control.getValue();
            $("#metadataField").val(JSON.stringify(value, null, null));
            
             control.on("mouseout",function(){
                var value = control.getValue();
                $("#metadataField").val(JSON.stringify(value, null, null));
            });

            control.on("change",function(){
                var value = control.getValue();
                $("#metadataField").val(JSON.stringify(value, null, null));
             });               
        }           
    });
}
</script>
