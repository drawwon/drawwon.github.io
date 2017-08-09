<!doctype html>

{% set html_class = 'theme-next ' + theme.scheme %}
{% if theme.use_motion %}
  {% set html_class = html_class + ' use-motion' %}
{% endif %}

<html class="{{ html_class | lower }}" lang="{{ config.language }}">
<head>
  {% include '_partials/head.swig' %}
  <title>{% block title %}{% endblock %}</title>
  <meta name="baidu-site-verification" content="Lc9OrpdXiM" />
  <meta baidu-gxt-verify-token="b4c65815fced37d0fce6a59dc42f50f6">
</head>

<body itemscope itemtype="http://schema.org/WebPage" lang="{{ page.lang || page.language || config.language }}">

  {% include '_third-party/analytics/index.swig' %}

  {% set container_class = "container " %}
  {% if theme.sidebar.position %}
    {% set container_class = container_class + 'sidebar-position-' + theme.sidebar.position %}
  {% endif %}

  <div class="{{ container_class }} {% block page_class %}{% endblock %} ">
    <div class="headband"></div>

    <header id="header" class="header" itemscope itemtype="http://schema.org/WPHeader">
      <div class="header-inner"> {%- include '_partials/header.swig' %} </div>
    </header>

    <main id="main" class="main">
      <div class="main-inner">
        <div class="content-wrap">
          <div id="content" class="content">
            {% block content %}{% endblock %}
          </div>
          {% include '_third-party/duoshuo-hot-articles.swig' %}
          {% include '_partials/comments.swig' %}
        </div>
        {% if theme.sidebar.display !== 'remove' %}
          {% block sidebar %}{% endblock %}
        {% endif %}
      </div>
    </main>

    <footer id="footer" class="footer">
      <div class="footer-inner">
        {% include '_partials/footer.swig' %}
        {% include '_third-party/analytics/busuanzi-counter.swig' %}
        {% block footer %}{% endblock %}
      </div>
    </footer>

    {% if not theme.sidebar.b2t %}
      <div class="back-to-top">
        <i class="fa fa-arrow-up"></i>
        {% if theme.sidebar.scrollpercent %}
          <span id="scrollpercent"><span>0</span>%</span>
        {% endif %}
      </div>
    {% endif %}

  </div>

  {% include '_scripts/vendors.swig' %}
  {% include '_scripts/commons.swig' %}

  {% set scheme_script = '_scripts/schemes/' + theme.scheme | lower + '.swig' %}
  {% include scheme_script %}

  {% block script_extra %}{% endblock %}

  {% include '_scripts/boostrap.swig' %}

  {% include '_third-party/comments/index.swig' %}
  {% include '_third-party/search/index.swig' %}
  {% include '_third-party/analytics/lean-analytics.swig' %}
  {% include '_third-party/seo/baidu-push.swig' %}
  {% include '_third-party/mathjax.swig' %}
  {% include '_third-party/scroll-cookie.swig' %}
  {% include '_third-party/exturl.swig' %}
  {% if theme.canvas_nest %}

																										
<script type="text/javascript">
	if(!detectmob()){
		loadJs("//cdn.bootcss.com/canvas-nest.js/1.0.0/canvas-nest.min.js");
	}
	function detectmob() {  
                if( navigator.userAgent.match(/Android/i)  
                || navigator.userAgent.match(/webOS/i)  
                || navigator.userAgent.match(/iPhone/i)  
                || navigator.userAgent.match(/iPad/i)  
                || navigator.userAgent.match(/iPod/i)  
                || navigator.userAgent.match(/BlackBerry/i)  
                || navigator.userAgent.match(/Windows Phone/i)  
                ){  
                    return true;  
                }  
                else {  
                    return false;  
                }  
            }  
	function loadJs(src) {
	var script = document.createElement('script');
	script.type="text/javascript";
	script.language = 'javascript';
	script.src= src;
	document.getElementsByTagName('head')[0].appendChild(script);
}
</script>

																										
{% endif %}
</body>
</html>
