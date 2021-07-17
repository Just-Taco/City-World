/* ########################### */
/*      UI Functions        */
/* ########################### */
$(function() {
	window.addEventListener('message', function(event) {
		if (event.data.type === "openUI"){
			document.getElementById('main').style.display = "block";
		} 
		else if (event.data.type === "closeUI"){
			document.getElementById('main').style.display = "none";
			document.getElementById("ptbl").innerHTML = "";
		} 
		else if (event.data.type === "update_List"){
			var data = event.data;
			var wrap = $('#table');
			wrap.find('table').append("<td></td>");
			
			wrap.find('table').append(data.text);
			$('#table').show();
		}
		else if (event.data.type === "update_Counts"){
			var data = event.data.jobs;
			
			document.getElementById('online_1').html(data.online_4);
			document.getElementById('online_2').html = data.online_4;
			document.getElementById('online_3').innerHTML = data.online_1;
			document.getElementById('online_4').innerHTML(data.online_4);
		}
	});
});
/* ########################### */
/*      Close Functions        */
/* ########################### */
$(document).keydown(function(event) {
    /* key toggle handler */ 
    if (event.keyCode == 192) {
		$.post("https://Boss_scoreboard/NUIFocusOff", JSON.stringify({}));
	}
	if (event.keyCode == 190) {
		$.post("https://Boss_scoreboard/NUIFocusOff_m", JSON.stringify({}));
	}
});
/* ########################### */
/*      Click Functions        */
/* ########################### */

$(function() {
	window.addEventListener('click', function(event) {
		var exit = "exit_btn"; var arrow = "drop_down"
		var x = document.getElementById("extra_bar");

		if (event.target.id == exit){
			document.getElementById('main').style.display = "none";
			document.getElementById("ptbl").innerHTML = "";

			$.post("https://Boss_scoreboard/NUIFocusOff", JSON.stringify({}));
		}
		if (event.target.id == arrow){
			if (x.style.display === "none") {
				x.style.display = "inline-flex";
				document.getElementById('drop_down').style.transform = "rotateX(150deg)";

				document.getElementById('catagories').style.marginTop = "4%";
				document.getElementById('table').style.marginTop = "4%";
				document.getElementById('table').style.height = "72%";
			} else {
				x.style.display = "none";
				document.getElementById('drop_down').style.transform = "rotateX(0deg)";
				document.getElementById('catagories').style.marginTop = "0%";
				document.getElementById('table').style.marginTop = "0%";
				document.getElementById('table').style.height = "76%";
			}
		}

	});
});
/* ########################### */
/*      Counter Update         */
/* ########################### */
$(function()
{
	window.addEventListener('message', function (event) {

		switch (event.data.action) {
			
			case 'update_Counts':
				var jobs = event.data.jobs;

				$('#count_1').html(jobs.job_1);
				$('#count_2').html(jobs.job_2);
				$('#count_3').html(jobs.job_3);
				$('#count_4').html(jobs.job_4);
				
				$('#extra_count_1').html(jobs.extra_1);
				$('#extra_count_2').html(jobs.extra_2);
				$('#extra_count_3').html(jobs.extra_3);
				$('#extra_count_4').html(jobs.extra_4);
				
				$('#online_count_1').html(jobs.online_1);
				$('#online_count_2').html(jobs.online_2);
				$('#online_count_3').html(jobs.online_3);
				$('#online_count_4').html(jobs.online_4);
				
				break;
				
			default:
				break;
		}
	}, false);
});