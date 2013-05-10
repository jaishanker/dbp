<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" <?php language_attributes(); ?>>

<head profile="http://gmpg.org/xfn/11">
<meta http-equiv="Content-Type" content="<?php bloginfo('html_type'); ?>; charset=<?php bloginfo('charset'); ?>" />

<title><?php wp_title('&laquo;', true, 'right'); ?> <?php bloginfo('name'); ?></title>

	<link rel="stylesheet" href="<?php bloginfo('template_directory'); ?>/style.css" type="text/css" media="screen" />
	
	<!-- new style added -->
	<link rel="stylesheet" href="<?php bloginfo('template_directory'); ?>/style_new.css" type="text/css" media="screen" />
	<!-- end additon -->
	
	<?php if(get_option('colorbold_style')!=''){?>
	<link rel="stylesheet" href="<?php bloginfo('template_directory'); ?>/css/<?php echo get_option('colorbold_style'); ?>" media="screen" />
	<?php }else{?>
	<link rel="stylesheet" href="<?php bloginfo('template_directory'); ?>/css/blue.css" media="screen" />
	<?php }?>
	<link rel="stylesheet" href="<?php bloginfo('template_directory'); ?>/css/jquery.lightbox-0.5.css" media="screen" />
	 <link rel="stylesheet" href="<?php bloginfo('template_directory'); ?>/css/superfish.css" media="screen" />	 
	 <!--[if gte IE 7]>
    <link rel="stylesheet" media="screen" type="text/css" href="<?php bloginfo('template_directory'); ?>/ie7.css" />
    <![endif]-->
	<script language="JavaScript" type="text/javascript" src="<?php bloginfo('template_directory'); ?>/js/jquery-1.3.2.min.js"></script>
	<script language="JavaScript" type="text/javascript" src="<?php bloginfo('template_directory'); ?>/js/jquery.form.js"></script>
	<script language="JavaScript" type="text/javascript" src="<?php bloginfo('template_directory'); ?>/js/jquery.lightbox-0.5.min.js">
	</script>
    <script type="text/javascript" src="<?php bloginfo('template_directory'); ?>/js/superfish.js"></script>
	<script type="text/javascript" src="<?php bloginfo('template_directory'); ?>/js/jquery.corner.js"></script>
	
	<!-- lightbox initialize script -->
	<script type="text/javascript">
		$(function() {
		   $('a.lightbox').lightBox();
		});
	 </script>
	<!-- ajax contact form -->
	 <script type="text/javascript">
		 $(document).ready(function(){
			  $('#contact').ajaxForm(function(data) {
				 if (data==1){
					 $('#success').fadeIn("slow");
					 $('#bademail').fadeOut("slow");
					 $('#badserver').fadeOut("slow");
					 $('#contact').resetForm();
					 }
				 else if (data==2){
						 $('#badserver').fadeIn("slow");
					  }
				 else if (data==3)
					{
					 $('#bademail').fadeIn("slow");
					}
					});
				 });
		</script>
		<script type="text/javascript"> 
			$(document).ready(function(){ 
				$("ul.sf-menu").superfish({
					autoArrows:  false,
					delay:       200,                             // one second delay on mouseout 
					animation:   {opacity:'show',height:'show'},  // fade-in and slide-down animation 
					speed:       'fast',                          // faster animation speed 
					autoArrows:  true,                           // disable generation of arrow mark-up 
					dropShadows: true                            // disable drop shadows 			
					}); 
			});
		</script>

	<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="<?php bloginfo('rss2_url'); ?>" />
	<link rel="alternate" type="text/xml" title="RSS .92" href="<?php bloginfo('rss_url'); ?>" />
	<link rel="alternate" type="application/atom+xml" title="Atom 1.0" href="<?php bloginfo('atom_url'); ?>" />

	<link rel="pingback" href="<?php bloginfo('pingback_url'); ?>" />
	<?php wp_get_archives('type=monthly&format=link'); ?>
	<?php //comments_popup_script(); // off by default ?>
	<?php wp_head(); ?>

</head>
<body>

<!-- begin mainWrapper -->
<div id="mainWrapper">
	<!-- begin wrapper -->
	<div id="wrapper">
	<!-- begin header -->
	<div id="header">
	
	<!-- added from html -->
		
	<!-- Logo Header Start -->
	<div class="header">
	

    	<div class="logo"><a href="index.php"></a></div>
         
		<!-- Login Start -->
		
		<div class="joinnow"> </div>
        <div class="login">
 
         </div>
		<!-- Login Start -->
    </div>
	<!-- Logo Header End -->
    
	<div class="clear"></div>
	<!-- Head Link Start -->
    <div class="headlink">
    	<div class="c1">
        	<div class="navLink01" style = "width:399px;" >
                <ul>
                    <li class="first L2"><a href="/designs" class="hvr01" id="L2">Design Central</a></li>
                    <li class="L1"><a href="/discussions" class="hvr" id="L1">Discussion Lounge</a></li>
                    <li class="L3"><a href="/learnings" class="hvr" id="L3">Learning Center</a></li>
                    <li class="L4 last"><a href="/groups" class="hvr" id="L4">Groups</a></li>
                    <!--<li class="L5"><a href="#" class="hvr" id="L5">Education</a></li>
                    <li class="last L6"><a href="#" class="hvr01" id="L6">CSWP</a></li>-->
                </ul>
            </div>
        </div>
        <div class="c2">
            <div class="iconlink">
              <!--  <a href="/groups"><p class="groups brdleft GP1">groups</p></a> -->
                <a href="/games"><p class="games brdleft GP2">games</p></a>
                <a href="/news"><p class="news brdleft GP3">news</p></a>
                <a href="#"><p class="rss brdleft GP4">RSS feed</p></a>
                <a href="/blog"><p class="blogs brdleft GP5">blog</p></a>
                <a href="/events"><p class="events brdleft GP6">events</p></a>
                <a href="#"><p class="sitemap GP7">sitemap</p></a>
            </div>
        </div>
    </div>
	<!-- Head Link End -->
    <div class="clear"></div>
	<!-- Head Banner Start -->
    <div class="banner">
    	<img src="/images/blog_img.jpg" />
    </div>
	<p class="clear"></p>
	<!-- Head Banner End -->

	
	<!-- end addition -->
	
	
	<div style="display:none" id="site5top"><a href="http://www.site5.com/reseller">Site5 | Experts In Reseller Hosting.</a></div>
	<a style="display:none" href="<?php bloginfo('rss2_url'); ?>" title="RSS" class="rssTag">RSS Feeds</a>
	<!-- logo -->
		<div id="logo"><a href="<?php bloginfo('url'); ?>/"><img src="<?php echo get_option('colorbold_logo_img'); ?>" alt="<?php echo get_option('colorbold_logo_alt'); ?>" /></a></div>
		<!-- begin topmenu -->
		<div id="topMenu" style="display:none" >
			<ul>
				<li><a href="<?php bloginfo('url'); ?>/">Home</a></li>
				<?php wp_list_pages('title_li=') ?>
			</ul>
		</div>
		<!-- end topmenu -->
		<!-- begin mainMenu -->
			<div style="display:none" id="mainMenu">
				<ul class="sf-menu">
				<?php wp_list_categories('hide_empty=1&exclude=1&title_li='); ?>
				</ul>
			</div>
		<!-- end mainMenu -->
	</div>
	<!-- end header -->
	<!-- begin content -->
	<div id="content" class="clearfix">