
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!-- version: 2.9.2 -->
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - DDNSTO远程控制</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script language="JavaScript" type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/dbconf?p=ddnsto&v=Sat, 13 Jul 2019 16:18:47 +0800(2250287 secs since boot)"></script>
<style>
.Bar_container {
    width:85%;
    height:20px;
    border:1px inset #999;
    margin:0 auto;
    margin-top:20px \9;
    background-color:#FFFFFF;
    z-index:100;
}
#proceeding_img_text {
    position:absolute;
    z-index:101;
    font-size:11px;
    color:#000000;
    line-height:21px;
    width: 83%;
}
#proceeding_img {
    height:21px;
    background:#C0D1D3 url(/images/ss_proceding.gif);
}

.ddnsto_btn {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #003333  0%, #000000 100%); /* W3C */
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:16%;
}
.ddnsto_btn:hover {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%); /* W3C */
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:16%;
}

input[type=button]:focus {
    outline: none;
}
.cloud_main_radius_left{
    -webkit-border-radius: 10px 0 0 10px;
    -moz-border-radius: 10px 0 0 10px;
    border-radius: 10px 0 0 10px;
}
.cloud_main_radius_right{
    -webkit-border-radius: 0 10px 10px 0;
    -moz-border-radius: 0 10px 10px 0;
    border-radius: 0 10px 10px 0;
}
.cloud_main_radius{
    -webkit-border-radius: 10px;
    -moz-border-radius: 10px;
    border-radius: 10px;
}
.cloud_main_radius h2 { border-bottom:1px #AAA dashed;}
.cloud_main_radius h3,
.cloud_main_radius h4 { font-size:12px;font-weight:normal;font-style: normal;}
.cloud_main_radius h5 { color:#FFF;font-weight:normal;font-style: normal;}
</style>
<script>
var noChange_status = 0;
var _responseLen;

function E(e) {
    return (typeof(e) == 'string') ? document.getElementById(e) : e;
}

function init() {
    show_menu(menu_hook);
    get_status();
    conf_to_obj();
    buildswitch();
    toggle_switch();
    notice_show();
    version_show();
}

function get_status() {
    $.ajax({
        url: 'apply.cgi?current_page=Module_ddnsto.asp&next_page=Module_ddnsto.asp&group_id=&modified=0&action_mode=+Refresh+&action_script=&action_wait=&first_time=&preferred_lang=CN&SystemCmd=ddnsto_status.sh',
        dataType: 'html',
        error: function(xhr) {
            alert("error");
        },
        success: function(response) {
            //alert("success");
            setTimeout("check_DDNSTO_status();", 1000);
        }
    });
}


function check_DDNSTO_status() {
    $.ajax({
        url: '/res/ddnsto_check.html',
        dataType: 'html',

        error: function(xhr) {
            setTimeout("check_DDNSTO_status();", 1000);
        },
        success: function(response) {
            var _cmdBtn = E("cmdBtn");
            if (response.search("XU6J03M6") != -1) {
                ddnsto_status = response.replace("XU6J03M6", " ");
                //alert(ddnsto_status);
                E("status").innerHTML = ddnsto_status;
                return true;
            }

            if (_responseLen == response.length) {
                noChange_status++;
            } else {
                noChange_status = 0;
            }
            if (noChange_status > 100) {
                noChange_status = 0;
                //refreshpage();
            } else {
                setTimeout("check_DDNSTO_status();", 400);
            }
            _responseLen = response.length;
        }
    });
}

function toggle_switch() {
    var rrt = E("switch");
    if (document.form.ddnsto_enable.value != "1") {
        rrt.checked = false;
    } else {
        rrt.checked = true;
    }
}

function buildswitch() {
    $("#switch").click(
        function() {
            if (E('switch').checked) {
                document.form.ddnsto_enable.value = 1;
            } else {
                document.form.ddnsto_enable.value = 0;
            }
        });
}

function conf_to_obj() {
    if (typeof db_ddnsto != "undefined") {
        for (var field in db_ddnsto) {
            var el = E(field);
            if (el != null) {
                el.value = db_ddnsto[field];
            }
        }
    }
}

function onSubmitCtrl(o, s) {
    showSSLoadingBar(5);
    document.form.action_mode.value = s;
    updateOptions();
}

function done_validating(action) {
    return true;
}

function updateOptions() {
    document.form.enctype = "";
    document.form.encoding = "";
    document.form.action = "/applydb.cgi?p=ddnsto_";
    document.form.SystemCmd.value = "ddnsto_config.sh";
    document.form.submit();
}

function menu_hook(title, tab) {
    var enable_ss = "0";
    var enable_soft = "1";
    if (enable_ss == "1" && enable_soft == "1") {
        tabtitle[tabtitle.length - 2] = new Array("", "ddnsto 远程控制");
        tablink[tablink.length - 2] = new Array("", "Module_ddnsto.asp");
    } else {
        tabtitle[tabtitle.length - 1] = new Array("", "ddnsto 远程控制");
        tablink[tablink.length - 1] = new Array("", "Module_ddnsto.asp");
    }
}

function openShutManager(oSourceObj, oTargetObj, shutAble, oOpenTip, oShutTip) {
    var sourceObj = typeof oSourceObj == "string" ? E(oSourceObj) : oSourceObj;
    var targetObj = typeof oTargetObj == "string" ? E(oTargetObj) : oTargetObj;
    var openTip = oOpenTip || "";
    var shutTip = oShutTip || "";
    if (targetObj.style.display != "none") {
        if (shutAble) return;
        targetObj.style.display = "none";
        if (openTip && shutTip) {
            sourceObj.innerHTML = shutTip;
        }
    } else {
        targetObj.style.display = "block";
        if (openTip && shutTip) {
            sourceObj.innerHTML = openTip;
        }
    }
}


function showSSLoadingBar(seconds) {
    if (window.scrollTo)
        window.scrollTo(0, 0);

    disableCheckChangedStatus();

    htmlbodyforIE = document.getElementsByTagName("html"); //this both for IE&FF, use "html" but not "body" because <!DOCTYPE html PUBLIC.......>
    htmlbodyforIE[0].style.overflow = "hidden"; //hidden the Y-scrollbar for preventing from user scroll it.

    winW_H();

    var blockmarginTop;
    var blockmarginLeft;
    if (window.innerWidth)
        winWidth = window.innerWidth;
    else if ((document.body) && (document.body.clientWidth))
        winWidth = document.body.clientWidth;

    if (window.innerHeight)
        winHeight = window.innerHeight;
    else if ((document.body) && (document.body.clientHeight))
        winHeight = document.body.clientHeight;

    if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth) {
        winHeight = document.documentElement.clientHeight;
        winWidth = document.documentElement.clientWidth;
    }

    if (winWidth > 1050) {
        winPadding = (winWidth - 1050) / 2;
        winWidth = 1105;
        blockmarginLeft = (winWidth * 0.3) + winPadding - 150;
    } else if (winWidth <= 1050) {
        blockmarginLeft = (winWidth) * 0.3 + document.body.scrollLeft - 160;
    }

    if (winHeight > 660)
        winHeight = 660;

    blockmarginTop = winHeight * 0.5

    E("loadingBarBlock").style.marginTop = blockmarginTop + "px";
    E("loadingBarBlock").style.marginLeft = blockmarginLeft + "px";
    E("loadingBarBlock").style.width = 770 + "px";
    E("LoadingBar").style.width = winW + "px";
    E("LoadingBar").style.height = winH + "px";

    loadingSeconds = seconds;
    progress = 100 / loadingSeconds;
    y = 0;
    LoadingLocalProgress(seconds);
}


function LoadingLocalProgress(seconds) {
    E("LoadingBar").style.visibility = "visible";
    if (document.form.ddnsto_enable.value != "1") {
        E("loading_block3").innerHTML = "ddnsto关闭中 ..."
    } else {
        E("loading_block3").innerHTML = "ddnsto启用中 ..."
    }

    y = y + progress;
    if (typeof(seconds) == "number" && seconds >= 0) {
        if (seconds != 0) {
            E("proceeding_img").style.width = Math.round(y) + "%";
            E("proceeding_img_text").innerHTML = Math.round(y) + "%";

            if (E("loading_block1")) {
                E("proceeding_img_text").style.width = E("loading_block1").clientWidth;
                E("proceeding_img_text").style.marginLeft = "175px";
            }
            --seconds;
            setTimeout("LoadingLocalProgress(" + seconds + ");", 1000);
        } else {
            E("proceeding_img_text").innerHTML = "完成";
            y = 0;
            setTimeout("hideSSLoadingBar();", 1000);
            refreshpage();
        }
    }
}

function reload_Soft_Center() {
    location.href = "/Main_Soft_center.asp";
}
function notice_show(){
    $.ajax({
        url: 'https://ks.ddnsto.com/ddnsto/push_message.json.js',
        type: 'GET',
        dataType: 'jsonp',
        success: function(res) {
			$("#push_titile").html(res.title);
			$("#push_content1").html(res.content1);
			$("#push_content2").html(res.content2);
			$("#push_content3").html(res.content3);
			if(res.content4){
				document.getElementById("push_content4_li").style.display = "";
				$("#push_content4").html(res.content4);
			}
			if(res.content5){
				document.getElementById("push_content5_li").style.display = "";
				$("#push_content5").html(res.content5);
			}
        }
    });
}
function version_show() {
    $.ajax({
        url: 'https://ks.ddnsto.com/ddnsto/config.json.js',
        type: 'GET',
        dataType: 'jsonp',
        success: function(res) {
            if (typeof(res["version"]) != "undefined" && res["version"].length > 0) {
                if (res["version"] == db_ddnsto["ddnsto_version"]) {
                    $("#ddnsto_version_show").html("插件版本：" + res["version"]);
                } else if (res["version"] > db_ddnsto["ddnsto_version"]) {
                    $("#ddnsto_version_show").html("<font color=\"#66FF66\">有新版本：" + res.version + "</font>");
                }
            }
        }
    });
}
</script>
</head>
<body onload="init();">
    <div id="TopBanner"></div>
    <div id="Loading" class="popup_bg"></div>
    <div id="LoadingBar" class="popup_bar_bg">
        <table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock" align="center">
            <tr>
                <td height="100">
                    <div id="loading_block3" style="margin:10px auto;width:85%; font-size:12pt;"></div>
                    <div id="loading_block1" class="Bar_container"> <span id="proceeding_img_text"></span>
                        <div id="proceeding_img"></div>
                    </div>
                    <div id="loading_block2" style="margin:10px auto; width:85%;">进度条走动过程中请勿刷新网页，请稍后...</div>
                </td>
            </tr>
        </table>
    </div>
    <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
    <form method="POST" name="form" action="/applydb.cgi?p=ddnsto_" target="hidden_frame">
        <input type="hidden" name="current_page" value="Module_ddnsto.asp">
        <input type="hidden" name="next_page" value="Module_ddnsto.asp">
        <input type="hidden" name="group_id" value="">
        <input type="hidden" name="modified" value="0">
        <input type="hidden" name="action_mode" value="">
        <input type="hidden" name="action_script" value="">
        <input type="hidden" name="action_wait" value="8">
        <input type="hidden" name="first_time" value="">
        <input type="hidden" name="preferred_lang" id="preferred_lang" value="CN">
        <input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="">
        <input type="hidden" name="firmver" value="3.0.0.4">
        <input type="hidden" id="ddnsto_enable" name="ddnsto_enable" value='1' />
        <table class="content" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="17">&nbsp;</td>
                <td valign="top" width="202">
                    <div id="mainMenu"></div>
                    <div id="subMenu"></div>
                </td>
                <td valign="top">
                    <div id="tabMenu" class="submenuBlock"></div>
                    <table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
                        <tr>
                            <td align="left" valign="top">
                                <table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
                                    <tr>
                                        <td bgcolor="#4D595D" colspan="3" valign="top">
                                            <div>&nbsp;</div>
                                            <div class="formfonttitle">软件中心 - ddnsto远程控制</div>
                                            <div style="float:right; width:15px; height:25px;margin-top:-20px">
                                                <img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
                                            </div>
                                            <div style="margin-left:5px;margin-top:10px;margin-bottom:10px">
                                                <img src="/images/New_ui/export/line_export.png">
                                            </div>

											<div id='app'>
											{{ message }}												
											</div>


                                            <div style="margin-left:5px;margin-top:10px;margin-bottom:10px">
                                                <img src="/images/New_ui/export/line_export.png">
                                            </div>
                                            <div id="NoteBox" style="display:none">
                                                <li>ddnsto远程控制目前处于测试阶段，仅提供给koolshare固件用户使用，提供路由界面的穿透，请勿用于反动、不健康等用途；</li>
                                                <li>穿透教程：<a id="gfw_number" href="http://koolshare.cn/thread-116500-1-1.html" target="_blank"><i>DDNSTO远程控制使用教程</i></a>
                                                </li>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
                <td width="10" align="center" valign="top"></td>
            </tr>
        </table>
    </form>
    <div id="footer"></div>
												<script src="/res/ideaServer_js/vue.js"></script>
											<script src="/res/ideaServer_js/axios.min.js"></script>
											<script>
											var app = new Vue({
  el: '#app',
  data: {
    message: 'Hello Vue!'
  }
})

											</script>
</body>
</html>

