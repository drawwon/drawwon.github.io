<script type="text/javascript">
var thisURL = document.URL;
if(thisURL == "http://drawon.site/about/"){
var z1 = document.getElementsByClassName("content-wrap")[0];
var div = document.createElement("div");
div.setAttribute("id", "newDiv1");
var div2 = "<hr><iframe src='http://drawon.site/simple/' style='overflow-x:hidden;overflow-y:hidden; border:0xp none #fff; min-height:240px; width:100%;'  frameborder='0' scrolling='no'></iframe>";
div.innerHTML = div2;
z1.appendChild(div);
}
var z = document.getElementById("posts").tagName;
if(z != "SECTION"){
var x = document.getElementsByClassName("post-body");
var parent = document.getElementsByClassName("post post-type-normal")[0];
var el = x[0];
var div = document.createElement("div");
div.setAttribute("id", "newDiv");
var div2 = "<hr><iframe src='http://drawon.site/simple/' style='overflow-x:hidden;overflow-y:hidden; border:0xp none #fff; min-height:240px; width:100%;'  frameborder='0' scrolling='no'></iframe>";
div.innerHTML = div2;
insertAfter(div,el.nextSibling);
}
function insertAfter(newElement,targetElement) {  
  var parent = targetElement.parentNode;  
  if (parent.lastChild == targetElement) {  
// 如果最后的节点是目标元素，则直接添加。因为默认是最后  
  parent.appendChild(newElement);  
  } else {  
  parent.insertBefore(newElement,targetElement.nextSibling);  
//如果不是，则插入在目标元素的下一个兄弟节点 的前面。也就是目标元素的后面。  
  }  
}  
</script>
