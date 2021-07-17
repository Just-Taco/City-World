/* ################################ */
/* Theme Style */
var main_color          = "rgba(54, 54, 54, 0.85)";                                 /* primary background color*/
var title_bar_color     = "#0e0e0ee3";                                              /* titble bar background color*/
var main_job_color      = "rgba(37, 37, 37, 0.85)";                                 /* main job bar background color*/
var extra_job_color     = "rgba(39, 39, 39, 0.432)";                                /* extra job bar background color*/
var footer_bar_color    = "#0e0e0ee3";                                              /* footer Bar Color */

/* ################################ */
/* Change to desired name/color */
var title_name = "Server Name";            var title_color = "rgba(116, 0, 0, 1)";        /* title name and color */
var title_text_size = "5vh";
/* ################################ */
/* Main Job Bar */
var job_name_1 = "TBD" + ":";              var job_color_1 = "red";                 /* 1st job counter name and color */
var job_count_color_1 = "rgb(204, 204, 204)";

var job_name_2 = "TBD" + ":";              var job_color_2 = "#5ea1e0";             /* 2nd job counter name and color */
var job_count_color_2 = "rgb(204, 204, 204)";

var job_name_3 = "TBD" + ":";              var job_color_3 = "yellow";              /* 3rd job counter name and color */
var job_count_color_3 = "rgb(204, 204, 204)";

var job_name_4 = "TBD" + ":";              var job_color_4 = "grey";                /* 4th job counter name and color */
var job_count_color_4 = "rgb(204, 204, 204)";

/* ################################ */
/* Extra Job Bar */
var extra_job_name_1 = "TBD" + ":";        var extra_job_color_1 = "red";           /* 1st extra job counter name and color  ( Hidden by Default )*/
var extra_counter_color_1 = "rgb(204, 204, 204)";

var extra_job_name_2 = "TBD" + ":";        var extra_job_color_2 = "#5ea1e0";       /* 2nd extra job counter name and color  ( Hidden by Default )*/
var extra_counter_color_2 = "rgb(204, 204, 204)";

var extra_job_name_3 = "TBD" + ":";        var extra_job_color_3 = "yellow";        /* 3rd extra job counter name and color  ( Hidden by Default )*/
var extra_counter_color_3 = "rgb(204, 204, 204)";

var extra_job_name_4 = "TBD" + ":";        var extra_job_color_4 = "grey";          /* 4th extra job counter name and color  ( Hidden by Default )*/
var extra_counter_color_4 = "rgb(204, 204, 204)";

/* ################################ */
/* Table */
var cat_id_color = "rgb(204, 204, 204)";                                            /* ID Catagory Color */
var cat_name_color = "rgb(204, 204, 204)";                                          /* Name Catagory Color */

/* ################################ */
/* Footer Bar Info */
var online_1 = "Owner";                var online_color_1 = "#f100ff";         /* 1st bottom counter name and color */
var online_counter_color_1 = "rgb(204, 204, 204)";

var online_2 = "Admin";                var online_color_2 = "#ff8800";         /* 2nd bottom counter name and color */
var online_counter_color_2 = "rgb(204, 204, 204)";

var online_3 = "Mod";                  var online_color_3 = "#00ff85";         /* 3rd bottom counter name and color */
var online_counter_color_3 = "rgb(204, 204, 204)";

var online_4 = "User";                 var online_color_4 = "grey";            /* 4th bottom counter name and color */
var online_counter_color_4 = "rgb(204, 204, 204)";

/* ################################ */
/* Discord */
var discord = "discord.gg/UwV724zyVZ";         var discord_color = "darkturquoise";      /* Discord Link & color*/

/* ################################ */
/* images */
var image_1 = "url(/cfg/html/img/icon.png)";                                        /* left spinning image */   
var image_2 = "url(/cfg/html/img/icon.png)";                                        /* right spinning image */  
var image_3 = "url(/cfg/html/img/arrow.png)";                                       /* dropdown image */

/* ####################################################################### */
/*              DO NOT TOUCH ANYTHING BEYOND THIS POINT                    */
/* ####################################################################### */
/* ################################ */
/*          General Style           */
/* ################################ */
document.getElementById("main").style.backgroundColor = main_color;             
document.getElementById("title").style.backgroundColor = title_bar_color;
document.getElementById("main_bar").style.backgroundColor = main_job_color;
document.getElementById("extra_bar").style.backgroundColor = extra_job_color;
document.getElementById("footer_bar").style.backgroundColor = footer_bar_color;
/* ################################ */
/*            images                */
/* ################################ */
document.getElementById("icon_1").style.backgroundImage = image_1;
document.getElementById("icon_2").style.backgroundImage = image_2;
document.getElementById("drop_down").style.backgroundImage = image_3;
/* ################################ */
/*          Title Style             */
/* ################################ */
document.getElementById('name').innerHTML = title_name;
document.getElementById("name").style.color = title_color;
document.getElementById("name").style.fontSize = title_text_size;
/* ################################ */
/*           Main Job Bar           */
/* ################################ */
document.getElementById('job_1').innerHTML = job_name_1;                /* job counter 1 */
document.getElementById("job_1").style.color = job_color_1;
document.getElementById("count_1").style.color = job_count_color_1;

document.getElementById('job_2').innerHTML = job_name_2;                /* job counter 2 */
document.getElementById("job_2").style.color = job_color_2;
document.getElementById("count_2").style.color = job_count_color_2;

document.getElementById('job_3').innerHTML = job_name_3;                /* job counter 3 */
document.getElementById("job_3").style.color = job_color_3;
document.getElementById("count_3").style.color = job_count_color_3;

document.getElementById('job_4').innerHTML = job_name_4;                /* job counter 4 */
document.getElementById("job_4").style.color = job_color_4;
document.getElementById("count_4").style.color = job_count_color_4;
/* ################################ */
/*          extra Job Bar           */
/* ################################ */
document.getElementById('extra_job_1').innerHTML = extra_job_name_1;                /* extra job counter 1 */
document.getElementById("extra_job_1").style.color = extra_job_color_1;
document.getElementById("extra_count_1").style.color = extra_counter_color_1;

document.getElementById('extra_job_2').innerHTML = extra_job_name_2;                /* extra job counter 2 */
document.getElementById("extra_job_2").style.color = extra_job_color_2;
document.getElementById("extra_count_2").style.color = extra_counter_color_2;

document.getElementById('extra_job_3').innerHTML = extra_job_name_3;                /* extra job counter 3 */
document.getElementById("extra_job_3").style.color = extra_job_color_3;
document.getElementById("extra_count_3").style.color = extra_counter_color_3;

document.getElementById('extra_job_4').innerHTML = extra_job_name_4;                /* extra job counter 4 */
document.getElementById("extra_job_4").style.color = extra_job_color_4;
document.getElementById("extra_count_4").style.color = extra_counter_color_4;
/* ################################ */
/*          Catagories Style        */
/* ################################ */
document.getElementById('cat_id').style.color = cat_id_color;                       /* Catagories Label 1 Color */
document.getElementById('cat_name').style.color = cat_name_color;                   /* Catagories Label 2 Color */
/* ################################ */
/*          bottom Bar           */
/* ################################ */
document.getElementById('online_1').innerHTML = online_1 + ":";                           /* Online counter (default: Owner)*/
document.getElementById("online_1").style.color = online_color_1;
document.getElementById("online_count_1").style.color = online_counter_color_1;

document.getElementById('online_2').innerHTML = online_2 + ":";                           /* Online counter (default: Admin) */
document.getElementById("online_2").style.color = online_color_2;
document.getElementById("online_count_2").style.color = online_counter_color_2;

document.getElementById('online_3').innerHTML = online_3 + ":";                           /* Online counter (default: Mod) */
document.getElementById("online_3").style.color = online_color_3;
document.getElementById("online_count_3").style.color = online_counter_color_3;

document.getElementById('online_4').innerHTML = online_4 + ":";                           /* Online counter (default: User) */
document.getElementById("online_4").style.color = online_color_4;
document.getElementById("online_count_4").style.color = online_counter_color_4;

/* ################################ */
/*          Discord Style           */
/* ################################ */
document.getElementById('discord_link').innerHTML = discord;                    /* Discord Link */
document.getElementById('discord_link').style.color = discord_color;            /* Link color*/