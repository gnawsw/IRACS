<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
request.setAttribute("ctx", path);
%>

<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>查看信息</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0"> 
    <script type="text/javascript" src="${basePath}js/jquery/jquery-1.10.2.min.js"></script>   

  </head>
  
  <body>
    <div align="center " style="text-align: left; width: 80%; margin: 0 auto; height: 100%;">
    	<!-- 标题 -->
        <div style="text-align: center; width: 100%;">
        	<h1><s:property value="info.title"/></h1>
        </div>
        <hr/>
        <!-- 时间、作者 -->
        <div style="text-align: left; width: 100%;color:#ccc; font-size:12px;">
                                    信息分类：<s:property value="#infoTypeMap[info.type]"/>&nbsp;&nbsp;&nbsp;&nbsp;
        	创建人：<s:property value="info.creator"/>&nbsp;&nbsp;&nbsp;&nbsp;
        	创建时间：<s:date name="info.createTime" format="yyyy-MM-dd HH:mm"/>	
        </div>
        <div style="text-align: left; width: 100%;padding:8px;">
        	<s:property value="info.content" escape="false"/>
        </div>
    </div>
    
<!-- 背景动画 -->
<canvas id="c" width="300" height="150" style="z-index:-1; position: fixed; top: 0; left: 0;"></canvas>   
<script type="text/javascript">		
$(document).ready(function() {			
	var canvas = document.getElementById("c");
	var ctx = canvas.getContext("2d");
	var c = $("#c");
	var w,h;
	var pi = Math.PI;
	var all_attribute = {
		num:100,            			 // 个数
		start_probability:0.1,		     // 如果数量小于num，有这些几率添加一个新的     		     
		radius_min:1,   			     // 初始半径最小值
		radius_max:2,   			     // 初始半径最大值
		radius_add_min:.3,               // 半径增加最小值
		radius_add_max:.5,               // 半径增加最大值
		opacity_min:0.3,                 // 初始透明度最小值
		opacity_max:0.5, 				 // 初始透明度最大值
		opacity_prev_min:.003,            // 透明度递减值最小值
		opacity_prev_max:.005,            // 透明度递减值最大值
		light_min:40,                 // 颜色亮度最小值
		light_max:70,                 // 颜色亮度最大值
	};
	var style_color = find_random(0,360);  
	var all_element =[];
	window_resize();
	function start(){
		window.requestAnimationFrame(start);
		style_color+=.1;
		ctx.fillStyle = 'hsl('+style_color+',100%,97%)';
		ctx.fillRect(0, 0, w, h);
		if (all_element.length < all_attribute.num && Math.random() < all_attribute.start_probability){
			all_element.push(new ready_run);
		}
		all_element.map(function(line) {
			line.to_step();
		})
	}
	function ready_run(){
		this.to_reset();
	}
	ready_run.prototype = {
		to_reset:function(){
			var t = this;
			t.x = find_random(0,w);
			t.y = find_random(0,h);
			t.radius = find_random(all_attribute.radius_min,all_attribute.radius_max);
			t.radius_change = find_random(all_attribute.radius_add_min,all_attribute.radius_add_max);
			t.opacity = find_random(all_attribute.opacity_min,all_attribute.opacity_max);
			t.opacity_change = find_random(all_attribute.opacity_prev_min,all_attribute.opacity_prev_max);
			t.light = find_random(all_attribute.light_min,all_attribute.light_max);
			t.color = 'hsl('+style_color+',100%,'+t.light+'%)';
		},
		to_step:function(){
			var t = this;
			t.opacity -= t.opacity_change;
			t.radius += t.radius_change;
			if(t.opacity <= 0){
				t.to_reset();
				return false;
			}
			ctx.fillStyle = t.color;
			ctx.globalAlpha = t.opacity;
			ctx.beginPath();
			ctx.arc(t.x,t.y,t.radius,0,2*pi,true);
			ctx.closePath();
			ctx.fill();
			ctx.globalAlpha = 1;
		}
	}
	function window_resize(){
		w = window.innerWidth;
		h = window.innerHeight;
		canvas.width = w;
		canvas.height = h;
	}
	$(window).resize(function(){
		window_resize();
	});
	function find_random(num_one,num_two){
		return Math.random()*(num_two-num_one)+num_one;
	}
	(function() {
		var lastTime = 0;
		var vendors = ['webkit', 'moz'];
		for(var xx = 0; xx < vendors.length && !window.requestAnimationFrame; ++xx) {
			window.requestAnimationFrame = window[vendors[xx] + 'RequestAnimationFrame'];
			window.cancelAnimationFrame = window[vendors[xx] + 'CancelAnimationFrame'] ||
										  window[vendors[xx] + 'CancelRequestAnimationFrame'];
		}
	
		if (!window.requestAnimationFrame) {
			window.requestAnimationFrame = function(callback, element) {
				var currTime = new Date().getTime();
				var timeToCall = Math.max(0, 16.7 - (currTime - lastTime));
				var id = window.setTimeout(function() {
					callback(currTime + timeToCall);
				}, timeToCall);
				lastTime = currTime + timeToCall;
				return id;
			};
		}
		if (!window.cancelAnimationFrame) {
			window.cancelAnimationFrame = function(id) {
				clearTimeout(id);
			};
		}
	}());
	start();
});
</script>
    
  </body>
</html>
