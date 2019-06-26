<script >
$(document).ready(function() {
	var strength = {
        0: "Worst ☹",
        1: "Bad ☹",
        2: "Weak ☹",
        3: "Good ☺",
        4: "Strong ☻"
}

var password = document.getElementById('password');
var meter = document.getElementById('password-strength-meter');
var text = document.getElementById('password-strength-text');

password.addEventListener('input', function()
{
    var val = password.value;
    var result = zxcvbn(val);
    
    // Update the password strength meter
    meter.value = result.score;
   
    // Update the text indicator
    if(val !== "") {
        text.innerHTML = "Strength: " + "<strong>" + strength[result.score] + "</strong>" + "<span class='feedback'>" + result.feedback.warning + " " + result.feedback.suggestions + "</span"; 
    }
    else {
        text.innerHTML = "";
    }
});

	$("#formPassword").submit(function (event) {
		var error = false;
		var message = "";
		/*
		 * Verifications
		 */
		 var mdp1 = $("#pass1").val();
		 var mdp2 = $("#pass2").val();
		 if (mdp1 != mdp2) {
		 	error = true;
		 	message = "{t}Les mots de passe ne sont pas identiques{/t}";
		 } else if (verifyLength(mdp1) == false) {
		 	error = true;
		 	message = "{t}Le mot de passe est trop court (minimum : 10 caractères){/t}";
		 } else if (verifyComplexity(mdp1) == false) {
		 	error = true;
		 	message = "{t}Le mot de passe n'est pas assez complexe (mixez 3 jeux de caractères parmi les minuscules, majuscules, chiffres et signes de ponctuation){/t}";
		 }
		 $("#message").text(message);
		/*
	 	 * Blocage de l'envoi du formulaire
		 */
		 if (error == true)
			event.preventDefault();
	});

});

</script>

<h2>{t}Modifier le mot de passe{/t}</h2>
<div class="row">
<div class="col-lg-6">
<form id="formPassword" method="post" class="form-horizontal protoform" action="index.php">
<input type="hidden" name="id" value="{$data.id}">
{if $passwordLost == 1}
<input type="hidden" name="token" value="{$token}">
<input type="hidden" name="module" value="passwordlostReinitwrite">
{else}
<input type="hidden" name="module" value="loginChangePasswordExec">
<div class="form-group">
<label for="oldPassword" class="control-label col-md-4">{t}Ancien mot de passe :{/t}</label>
<div class="col-md-8">
<input id="oldPassword" class="form-control" type="password" name="oldPassword" autocomplete="off" autofocus>
</div>
</div>
{/if}
<div class="form-group">
<label for="pass1" class="control-label col-md-4">
{t}Nouveau mot de passe :{/t}
</label>
<div class="col-md-8">
<input type="password" id="pass1" class="form-control" autocomplete="off" name="pass1">
</div>
</div>
<div class="form-group">
<label for="pass1" class="control-label col-md-4">
{t}Répétez le mot de passe :{/t}
</label>
<div class="col-md-8">
<input type="password" id="pass2" name="pass2" class="form-control" autocomplete="off">
</div>
</div>
<meter max="4" id="password-strength-meter"></meter>
        <p id="password-strength-text"></p>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
</div>
<span id="helpBlock" class="help-block center">{t}Le mot de passe doit avoir une longueur minimale de 10 caractères
Il doit comprendre au minimum 3 types de caractères différents
(minuscule, majuscule, chiffre, ponctuation et autre symboles){/t}</span>
</form>
</div>
</div>
<div class="row">
<div class="col-lg-6">
<div id="message"></div>
</div>
</div>